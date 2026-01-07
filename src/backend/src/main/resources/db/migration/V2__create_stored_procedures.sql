-- =========================================
-- Tasbal Stored Procedures
-- すべての戻り値はテーブル形式（ResultSet）
-- =========================================

-- =========================================
-- Task Stored Procedures
-- =========================================

-- タスク作成
CREATE OR REPLACE FUNCTION sp_create_task(
    p_user_id UUID,
    p_title VARCHAR,
    p_memo TEXT,
    p_due_at TIMESTAMPTZ
)
RETURNS TABLE(
    id UUID,
    user_id UUID,
    title VARCHAR,
    memo TEXT,
    due_at TIMESTAMPTZ,
    status SMALLINT,
    pinned BOOLEAN,
    completed_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
) AS $$
DECLARE
    v_task_id UUID;
BEGIN
    INSERT INTO tasks (user_id, title, memo, due_at)
    VALUES (p_user_id, p_title, p_memo, p_due_at)
    RETURNING tasks.id INTO v_task_id;

    RETURN QUERY
    SELECT t.id, t.user_id, t.title, t.memo, t.due_at, t.status, t.pinned,
           t.completed_at, t.archived_at, t.created_at, t.updated_at, t.deleted_at
    FROM tasks t
    WHERE t.id = v_task_id;
END;
$$ LANGUAGE plpgsql;

-- タスク一覧取得
CREATE OR REPLACE FUNCTION sp_get_tasks(
    p_user_id UUID,
    p_limit INT DEFAULT 20,
    p_offset INT DEFAULT 0
)
RETURNS TABLE(
    id UUID,
    user_id UUID,
    title VARCHAR,
    memo TEXT,
    due_at TIMESTAMPTZ,
    status SMALLINT,
    pinned BOOLEAN,
    completed_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    tag_ids UUID[]
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.id, t.user_id, t.title, t.memo, t.due_at, t.status, t.pinned,
        t.completed_at, t.archived_at, t.created_at, t.updated_at, t.deleted_at,
        ARRAY(
            SELECT tt.tag_id
            FROM task_tags tt
            WHERE tt.task_id = t.id
        ) AS tag_ids
    FROM tasks t
    WHERE t.user_id = p_user_id
      AND t.deleted_at IS NULL
    ORDER BY t.pinned DESC, t.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;

-- タスク1件取得
CREATE OR REPLACE FUNCTION sp_get_task_by_id(
    p_task_id UUID,
    p_user_id UUID
)
RETURNS TABLE(
    id UUID,
    user_id UUID,
    title VARCHAR,
    memo TEXT,
    due_at TIMESTAMPTZ,
    status SMALLINT,
    pinned BOOLEAN,
    completed_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    tag_ids UUID[]
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.id, t.user_id, t.title, t.memo, t.due_at, t.status, t.pinned,
        t.completed_at, t.archived_at, t.created_at, t.updated_at, t.deleted_at,
        ARRAY(
            SELECT tt.tag_id
            FROM task_tags tt
            WHERE tt.task_id = t.id
        ) AS tag_ids
    FROM tasks t
    WHERE t.id = p_task_id
      AND t.user_id = p_user_id
      AND t.deleted_at IS NULL;
END;
$$ LANGUAGE plpgsql;

-- タスク完了切替（風船加算トリガ）
CREATE OR REPLACE FUNCTION sp_toggle_task_completion(
    p_task_id UUID,
    p_user_id UUID,
    p_is_done BOOLEAN
)
RETURNS TABLE(
    id UUID,
    user_id UUID,
    title VARCHAR,
    memo TEXT,
    due_at TIMESTAMPTZ,
    status SMALLINT,
    pinned BOOLEAN,
    completed_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    was_completed BOOLEAN,
    popped_balloon_ids UUID[]
) AS $$
DECLARE
    v_new_status SMALLINT;
    v_completed_at TIMESTAMPTZ;
    v_was_completed BOOLEAN;
    v_selected_balloon_id UUID;
    v_popped_balloons UUID[];
BEGIN
    -- 現在の状態を取得
    SELECT (t.status = 3) INTO v_was_completed
    FROM tasks t
    WHERE t.id = p_task_id AND t.user_id = p_user_id;

    -- 新しいステータスを決定
    IF p_is_done THEN
        v_new_status := 3; -- DONE
        v_completed_at := CURRENT_TIMESTAMP;
    ELSE
        v_new_status := 1; -- TODO
        v_completed_at := NULL;
    END IF;

    -- タスクを更新
    UPDATE tasks
    SET status = v_new_status,
        completed_at = v_completed_at,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_task_id AND user_id = p_user_id;

    -- 完了時の処理
    IF p_is_done AND NOT v_was_completed THEN
        -- 完了履歴を作成（冪等性確保）
        INSERT INTO task_completions (task_id, user_id, completed_at)
        VALUES (p_task_id, p_user_id, v_completed_at)
        ON CONFLICT (task_id) DO NOTHING;

        -- 選択中の風船を取得
        SELECT bs.balloon_id INTO v_selected_balloon_id
        FROM balloon_selections bs
        WHERE bs.user_id = p_user_id
          AND bs.left_at IS NULL
        LIMIT 1;

        -- 風船に加算（ストアドプロシージャを呼び出し）
        IF v_selected_balloon_id IS NOT NULL THEN
            SELECT ARRAY_AGG(popped_id) INTO v_popped_balloons
            FROM sp_add_balloon_contribution(
                p_user_id,
                v_selected_balloon_id,
                1, -- TASK
                p_task_id,
                1  -- amount
            ) AS popped_id;
        ELSE
            v_popped_balloons := ARRAY[]::UUID[];
        END IF;
    ELSE
        v_popped_balloons := ARRAY[]::UUID[];
    END IF;

    -- 結果を返す
    RETURN QUERY
    SELECT
        t.id, t.user_id, t.title, t.memo, t.due_at, t.status, t.pinned,
        t.completed_at, t.archived_at, t.created_at, t.updated_at, t.deleted_at,
        v_was_completed,
        v_popped_balloons
    FROM tasks t
    WHERE t.id = p_task_id;
END;
$$ LANGUAGE plpgsql;

-- タスク更新
CREATE OR REPLACE FUNCTION sp_update_task(
    p_task_id UUID,
    p_user_id UUID,
    p_title VARCHAR DEFAULT NULL,
    p_memo TEXT DEFAULT NULL,
    p_due_at TIMESTAMPTZ DEFAULT NULL,
    p_pinned BOOLEAN DEFAULT NULL
)
RETURNS TABLE(
    id UUID,
    user_id UUID,
    title VARCHAR,
    memo TEXT,
    due_at TIMESTAMPTZ,
    status SMALLINT,
    pinned BOOLEAN,
    completed_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
) AS $$
BEGIN
    UPDATE tasks
    SET
        title = COALESCE(p_title, tasks.title),
        memo = COALESCE(p_memo, tasks.memo),
        due_at = COALESCE(p_due_at, tasks.due_at),
        pinned = COALESCE(p_pinned, tasks.pinned),
        updated_at = CURRENT_TIMESTAMP
    WHERE tasks.id = p_task_id AND tasks.user_id = p_user_id;

    RETURN QUERY
    SELECT t.id, t.user_id, t.title, t.memo, t.due_at, t.status, t.pinned,
           t.completed_at, t.archived_at, t.created_at, t.updated_at, t.deleted_at
    FROM tasks t
    WHERE t.id = p_task_id;
END;
$$ LANGUAGE plpgsql;

-- タスク削除（論理削除）
CREATE OR REPLACE FUNCTION sp_delete_task(
    p_task_id UUID,
    p_user_id UUID
)
RETURNS TABLE(
    id UUID,
    deleted_at TIMESTAMPTZ
) AS $$
BEGIN
    UPDATE tasks
    SET deleted_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE tasks.id = p_task_id AND tasks.user_id = p_user_id;

    RETURN QUERY
    SELECT t.id, t.deleted_at
    FROM tasks t
    WHERE t.id = p_task_id;
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- Balloon Stored Procedures
-- =========================================

-- 風船に貢献を加算（システム用）
CREATE OR REPLACE FUNCTION sp_add_balloon_contribution(
    p_actor_user_id UUID,
    p_balloon_id UUID,
    p_source_type SMALLINT,
    p_source_id UUID,
    p_amount INT
)
RETURNS TABLE(
    popped_balloon_id UUID
) AS $$
DECLARE
    v_unit_type SMALLINT;
    v_unit_key VARCHAR;
    v_current_value INT;
    v_next_threshold INT;
    v_break_count INT;
    v_popped BOOLEAN := false;
BEGIN
    -- 風船の種類に応じて集計単位を決定
    SELECT
        CASE
            WHEN b.balloon_type = 4 THEN 1  -- USER
            WHEN b.balloon_type = 2 THEN 2  -- LOCATION (COUNTRY)
            WHEN b.balloon_type = 1 THEN 3  -- GLOBAL
            WHEN b.balloon_type = 3 THEN 4  -- BREATHING (UTC_DAY)
            WHEN b.balloon_type = 5 THEN 5  -- GUERRILLA (EVENT)
            ELSE 3
        END INTO v_unit_type
    FROM balloons b
    WHERE b.id = p_balloon_id;

    -- unit_key を決定
    v_unit_key := p_actor_user_id::VARCHAR;

    -- 進捗を更新（楽観的ロック）
    UPDATE balloon_progress
    SET
        current_value = current_value + p_amount,
        updated_at = CURRENT_TIMESTAMP,
        lock_version = lock_version + 1
    WHERE balloon_id = p_balloon_id
      AND unit_type = v_unit_type
      AND unit_key = v_unit_key
    RETURNING current_value, next_threshold, break_count
    INTO v_current_value, v_next_threshold, v_break_count;

    -- 進捗レコードが存在しない場合は作成
    IF NOT FOUND THEN
        INSERT INTO balloon_progress (balloon_id, unit_type, unit_key, current_value, next_threshold, break_count)
        VALUES (p_balloon_id, v_unit_type, v_unit_key, p_amount, 1, 0)
        RETURNING current_value, next_threshold, break_count
        INTO v_current_value, v_next_threshold, v_break_count;
    END IF;

    -- 貢献台帳に記録
    INSERT INTO contribution_ledger (actor_user_id, balloon_id, unit_type, unit_key, source_type, source_id, amount)
    VALUES (p_actor_user_id, p_balloon_id, v_unit_type, v_unit_key, p_source_type, p_source_id, p_amount);

    -- 割れ判定
    IF v_current_value >= v_next_threshold THEN
        v_popped := true;

        -- 進捗をリセットして次回必要量を増やす
        UPDATE balloon_progress
        SET
            current_value = v_current_value - v_next_threshold,
            next_threshold = v_next_threshold + 1,
            break_count = break_count + 1,
            updated_at = CURRENT_TIMESTAMP
        WHERE balloon_id = p_balloon_id
          AND unit_type = v_unit_type
          AND unit_key = v_unit_key;

        -- 割れ履歴に記録
        INSERT INTO balloon_pop_history (balloon_id, unit_type, unit_key, trigger_user_id, threshold_at_pop, consumed, context_type, context_id)
        VALUES (p_balloon_id, v_unit_type, v_unit_key, p_actor_user_id, v_next_threshold, v_next_threshold, p_source_type, p_source_id);
    END IF;

    -- 割れた風船のIDを返す
    IF v_popped THEN
        RETURN QUERY SELECT p_balloon_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 風船作成
CREATE OR REPLACE FUNCTION sp_create_balloon(
    p_owner_user_id UUID,
    p_title VARCHAR,
    p_description TEXT,
    p_color_id SMALLINT,
    p_tag_icon_id SMALLINT,
    p_is_public BOOLEAN
)
RETURNS TABLE(
    id UUID,
    balloon_type SMALLINT,
    display_group SMALLINT,
    visibility SMALLINT,
    owner_user_id UUID,
    title VARCHAR,
    description TEXT,
    color_id SMALLINT,
    tag_icon_id SMALLINT,
    country_code CHAR,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
DECLARE
    v_balloon_id UUID;
    v_visibility SMALLINT;
BEGIN
    -- 公開設定に応じてvisibilityを決定
    v_visibility := CASE WHEN p_is_public THEN 3 ELSE 2 END; -- 3:PUBLIC, 2:PRIVATE

    INSERT INTO balloons (balloon_type, display_group, visibility, owner_user_id, title, description, color_id, tag_icon_id)
    VALUES (4, 2, v_visibility, p_owner_user_id, p_title, p_description, p_color_id, p_tag_icon_id) -- 4:USER, 2:DRIFTING
    RETURNING balloons.id INTO v_balloon_id;

    -- 自動参加
    INSERT INTO balloon_memberships (user_id, balloon_id)
    VALUES (p_owner_user_id, v_balloon_id);

    RETURN QUERY
    SELECT b.id, b.balloon_type, b.display_group, b.visibility, b.owner_user_id,
           b.title, b.description, b.color_id, b.tag_icon_id, b.country_code,
           b.is_active, b.created_at, b.updated_at
    FROM balloons b
    WHERE b.id = v_balloon_id;
END;
$$ LANGUAGE plpgsql;

-- 公開風船一覧取得
CREATE OR REPLACE FUNCTION sp_get_public_balloons(
    p_limit INT DEFAULT 20,
    p_offset INT DEFAULT 0
)
RETURNS TABLE(
    id UUID,
    balloon_type SMALLINT,
    display_group SMALLINT,
    visibility SMALLINT,
    owner_user_id UUID,
    title VARCHAR,
    description TEXT,
    color_id SMALLINT,
    tag_icon_id SMALLINT,
    country_code CHAR,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT b.id, b.balloon_type, b.display_group, b.visibility, b.owner_user_id,
           b.title, b.description, b.color_id, b.tag_icon_id, b.country_code,
           b.is_active, b.created_at, b.updated_at
    FROM balloons b
    WHERE b.visibility = 3  -- PUBLIC
      AND b.is_active = true
      AND b.balloon_type = 4  -- USER
    ORDER BY b.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;

-- 選択中風船設定
CREATE OR REPLACE FUNCTION sp_set_balloon_selection(
    p_user_id UUID,
    p_balloon_id UUID
)
RETURNS TABLE(
    user_id UUID,
    balloon_id UUID,
    priority INT,
    selected_at TIMESTAMPTZ,
    left_at TIMESTAMPTZ
) AS $$
BEGIN
    -- 既存の選択を解除
    UPDATE balloon_selections
    SET left_at = CURRENT_TIMESTAMP
    WHERE balloon_selections.user_id = p_user_id
      AND left_at IS NULL;

    -- 新しい選択を作成
    INSERT INTO balloon_selections (user_id, balloon_id, priority)
    VALUES (p_user_id, p_balloon_id, 1)
    ON CONFLICT (user_id, balloon_id)
    DO UPDATE SET left_at = NULL, selected_at = CURRENT_TIMESTAMP;

    RETURN QUERY
    SELECT bs.user_id, bs.balloon_id, bs.priority, bs.selected_at, bs.left_at
    FROM balloon_selections bs
    WHERE bs.user_id = p_user_id AND bs.balloon_id = p_balloon_id;
END;
$$ LANGUAGE plpgsql;

-- 選択中風船取得
CREATE OR REPLACE FUNCTION sp_get_balloon_selection(
    p_user_id UUID
)
RETURNS TABLE(
    user_id UUID,
    balloon_id UUID,
    priority INT,
    selected_at TIMESTAMPTZ,
    left_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT bs.user_id, bs.balloon_id, bs.priority, bs.selected_at, bs.left_at
    FROM balloon_selections bs
    WHERE bs.user_id = p_user_id
      AND bs.left_at IS NULL
    ORDER BY bs.priority
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- User / Auth Stored Procedures
-- =========================================

-- ゲストユーザー作成
CREATE OR REPLACE FUNCTION sp_create_guest_user(
    p_handle VARCHAR
)
RETURNS TABLE(
    id UUID,
    handle VARCHAR,
    plan SMALLINT,
    is_guest BOOLEAN,
    auth_state SMALLINT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
) AS $$
DECLARE
    v_user_id UUID;
BEGIN
    INSERT INTO users (handle, is_guest, auth_state, plan)
    VALUES (p_handle, true, 1, 1)  -- 1:GUEST, 1:FREE
    RETURNING users.id INTO v_user_id;

    -- ユーザー設定を作成
    INSERT INTO user_settings (user_id)
    VALUES (v_user_id);

    RETURN QUERY
    SELECT u.id, u.handle, u.plan, u.is_guest, u.auth_state,
           u.created_at, u.updated_at, u.last_login_at, u.deleted_at
    FROM users u
    WHERE u.id = v_user_id;
END;
$$ LANGUAGE plpgsql;

-- ユーザー情報取得
CREATE OR REPLACE FUNCTION sp_get_user_by_id(
    p_user_id UUID
)
RETURNS TABLE(
    id UUID,
    handle VARCHAR,
    plan SMALLINT,
    is_guest BOOLEAN,
    auth_state SMALLINT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id, u.handle, u.plan, u.is_guest, u.auth_state,
           u.created_at, u.updated_at, u.last_login_at, u.deleted_at
    FROM users u
    WHERE u.id = p_user_id AND u.deleted_at IS NULL;
END;
$$ LANGUAGE plpgsql;

-- ユーザー設定取得
CREATE OR REPLACE FUNCTION sp_get_user_settings(
    p_user_id UUID
)
RETURNS TABLE(
    user_id UUID,
    country_code CHAR,
    render_quality SMALLINT,
    auto_low_power BOOLEAN,
    updated_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT us.user_id, us.country_code, us.render_quality, us.auto_low_power, us.updated_at
    FROM user_settings us
    WHERE us.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- ユーザー設定更新
CREATE OR REPLACE FUNCTION sp_update_user_settings(
    p_user_id UUID,
    p_country_code CHAR DEFAULT NULL,
    p_render_quality SMALLINT DEFAULT NULL,
    p_auto_low_power BOOLEAN DEFAULT NULL
)
RETURNS TABLE(
    user_id UUID,
    country_code CHAR,
    render_quality SMALLINT,
    auto_low_power BOOLEAN,
    updated_at TIMESTAMPTZ
) AS $$
BEGIN
    UPDATE user_settings
    SET
        country_code = COALESCE(p_country_code, user_settings.country_code),
        render_quality = COALESCE(p_render_quality, user_settings.render_quality),
        auto_low_power = COALESCE(p_auto_low_power, user_settings.auto_low_power),
        updated_at = CURRENT_TIMESTAMP
    WHERE user_settings.user_id = p_user_id;

    RETURN QUERY
    SELECT us.user_id, us.country_code, us.render_quality, us.auto_low_power, us.updated_at
    FROM user_settings us
    WHERE us.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- ゲストユーザー作成
CREATE OR REPLACE FUNCTION sp_create_guest_user(
    p_handle VARCHAR DEFAULT NULL
)
RETURNS TABLE(
    id UUID,
    handle VARCHAR,
    plan SMALLINT,
    is_guest BOOLEAN,
    auth_state SMALLINT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
DECLARE
    v_user_id UUID;
    v_handle VARCHAR;
BEGIN
    -- handleが指定されていない場合はランダムな値を生成
    IF p_handle IS NULL THEN
        v_handle := 'guest_' || substr(md5(random()::text), 1, 8);
    ELSE
        v_handle := p_handle;
    END IF;

    INSERT INTO users (handle, is_guest, auth_state, plan)
    VALUES (v_handle, true, 1, 1)  -- 1:GUEST, 1:FREE
    RETURNING users.id INTO v_user_id;

    -- user_settingsにデフォルト設定を作成
    INSERT INTO user_settings (user_id)
    VALUES (v_user_id);

    RETURN QUERY
    SELECT u.id, u.handle, u.plan, u.is_guest, u.auth_state, u.created_at, u.updated_at
    FROM users u
    WHERE u.id = v_user_id;
END;
$$ LANGUAGE plpgsql;
-- =========================================
-- ゲストユーザー作成ストアドプロシージャ
-- =========================================

-- 既存の関数を削除
DROP FUNCTION IF EXISTS sp_create_guest_user(VARCHAR);
DROP FUNCTION IF EXISTS sp_create_guest_user();

-- ゲストユーザー作成
CREATE OR REPLACE FUNCTION sp_create_guest_user(
    p_handle VARCHAR DEFAULT NULL
)
RETURNS TABLE(
    id UUID,
    handle VARCHAR,
    plan SMALLINT,
    is_guest BOOLEAN,
    auth_state SMALLINT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
) AS $$
DECLARE
    v_user_id UUID;
    v_handle VARCHAR;
BEGIN
    -- handleが指定されていない場合はランダムな値を生成
    IF p_handle IS NULL THEN
        v_handle := 'guest_' || substr(md5(random()::text), 1, 8);
    ELSE
        v_handle := p_handle;
    END IF;

    INSERT INTO users (handle, is_guest, auth_state, plan)
    VALUES (v_handle, true, 1, 1)  -- 1:GUEST, 1:FREE
    RETURNING users.id INTO v_user_id;

    -- user_settingsにデフォルト設定を作成
    INSERT INTO user_settings (user_id)
    VALUES (v_user_id);

    RETURN QUERY
    SELECT u.id, u.handle, u.plan, u.is_guest, u.auth_state, u.created_at, u.updated_at
    FROM users u
    WHERE u.id = v_user_id;
END;
$$ LANGUAGE plpgsql;
