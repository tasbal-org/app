-- =========================================
-- Tasbal Initial Schema Migration
-- Task Modification Functions
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
