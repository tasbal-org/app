-- =========================================
-- Tasbal Initial Schema Migration
-- User Modification Functions
-- =========================================

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
