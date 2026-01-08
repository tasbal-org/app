-- =========================================
-- Tasbal Initial Schema Migration
-- Balloon Modification Functions
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
