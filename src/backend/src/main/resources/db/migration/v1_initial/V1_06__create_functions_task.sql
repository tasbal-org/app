-- =========================================
-- Tasbal Initial Schema Migration
-- Task GET Functions
-- =========================================

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
