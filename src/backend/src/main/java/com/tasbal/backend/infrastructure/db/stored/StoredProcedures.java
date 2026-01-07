package com.tasbal.backend.infrastructure.db.stored;

/**
 * ストアドプロシージャ名を一元管理するクラス
 * 文字列直書きを禁止し、タイポを防ぐ
 */
public final class StoredProcedures {

    private StoredProcedures() {
        // Utility class
    }

    // Task Stored Procedures
    public static final String SP_CREATE_TASK = "sp_create_task";
    public static final String SP_GET_TASKS = "sp_get_tasks";
    public static final String SP_GET_TASK_BY_ID = "sp_get_task_by_id";
    public static final String SP_TOGGLE_TASK_COMPLETION = "sp_toggle_task_completion";
    public static final String SP_UPDATE_TASK = "sp_update_task";
    public static final String SP_DELETE_TASK = "sp_delete_task";

    // Balloon Stored Procedures
    public static final String SP_CREATE_BALLOON = "sp_create_balloon";
    public static final String SP_GET_PUBLIC_BALLOONS = "sp_get_public_balloons";
    public static final String SP_SET_BALLOON_SELECTION = "sp_set_balloon_selection";
    public static final String SP_GET_BALLOON_SELECTION = "sp_get_balloon_selection";
    public static final String SP_ADD_BALLOON_CONTRIBUTION = "sp_add_balloon_contribution";

    // User Stored Procedures
    public static final String SP_CREATE_GUEST_USER = "sp_create_guest_user";
    public static final String SP_GET_USER_BY_ID = "sp_get_user_by_id";
    public static final String SP_GET_USER_SETTINGS = "sp_get_user_settings";
    public static final String SP_UPDATE_USER_SETTINGS = "sp_update_user_settings";
}
