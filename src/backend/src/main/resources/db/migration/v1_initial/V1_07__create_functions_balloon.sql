-- =========================================
-- Tasbal Initial Schema Migration
-- Balloon GET Functions
-- =========================================

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
