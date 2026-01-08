-- =========================================
-- Tasbal Initial Schema Migration
-- User GET Functions
-- =========================================

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
