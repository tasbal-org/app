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
