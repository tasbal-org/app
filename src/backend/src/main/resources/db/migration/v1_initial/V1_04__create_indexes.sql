-- =========================================
-- Tasbal Initial Schema Migration
-- Indexes for Performance
-- =========================================

-- Users
CREATE INDEX idx_users_handle ON users(handle) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_is_guest ON users(is_guest);

-- Tasks
CREATE INDEX idx_tasks_user_id ON tasks(user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_status ON tasks(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_due_at ON tasks(due_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_completed_at ON tasks(completed_at);

-- Balloons
CREATE INDEX idx_balloons_type ON balloons(balloon_type) WHERE is_active = true;
CREATE INDEX idx_balloons_visibility ON balloons(visibility) WHERE is_active = true;
CREATE INDEX idx_balloons_owner_user_id ON balloons(owner_user_id) WHERE is_active = true;
CREATE INDEX idx_balloons_country_code ON balloons(country_code) WHERE is_active = true;

-- Balloon Progress
CREATE INDEX idx_balloon_progress_balloon_id ON balloon_progress(balloon_id);

-- Contribution Ledger
CREATE INDEX idx_contribution_ledger_actor_user_id ON contribution_ledger(actor_user_id);
CREATE INDEX idx_contribution_ledger_balloon_id ON contribution_ledger(balloon_id);
CREATE INDEX idx_contribution_ledger_created_at ON contribution_ledger(created_at);

-- Sessions
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id) WHERE revoked_at IS NULL;
CREATE INDEX idx_user_sessions_device_id ON user_sessions(device_id) WHERE revoked_at IS NULL;

-- Guerrilla Events
CREATE INDEX idx_guerrilla_events_tasbal_day ON guerrilla_events(tasbal_day);
CREATE INDEX idx_guerrilla_events_time_range ON guerrilla_events(starts_at, ends_at);
