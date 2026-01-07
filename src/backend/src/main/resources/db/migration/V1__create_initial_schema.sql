-- =========================================
-- Tasbal Initial Schema Migration
-- 区分値はすべて1始まり（0は未使用）
-- =========================================

-- =========================================
-- Users / Auth / Devices
-- =========================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    handle VARCHAR(50) NOT NULL,
    plan SMALLINT NOT NULL DEFAULT 1 CHECK (plan >= 1), -- 1:FREE 2:PRO
    is_guest BOOLEAN NOT NULL DEFAULT true,
    auth_state SMALLINT NOT NULL DEFAULT 1 CHECK (auth_state >= 1), -- 1:GUEST 2:LINKED 3:DISABLED
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    CONSTRAINT unique_handle UNIQUE (handle)
);

CREATE TABLE user_settings (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    country_code CHAR(2),
    render_quality SMALLINT NOT NULL DEFAULT 1 CHECK (render_quality >= 1), -- 1:AUTO 2:NORMAL 3:LOW
    auto_low_power BOOLEAN NOT NULL DEFAULT true,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_identities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider SMALLINT NOT NULL CHECK (provider >= 1), -- 1:APPLE 2:GOOGLE 3:ANON
    provider_user_id VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    email_verified BOOLEAN NOT NULL DEFAULT false,
    linked_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_provider_user UNIQUE (provider, provider_user_id)
);

CREATE TABLE user_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_fingerprint VARCHAR(255) NOT NULL,
    device_name VARCHAR(100),
    platform SMALLINT NOT NULL CHECK (platform >= 1), -- 1:iOS 2:Android 3:Web
    app_version VARCHAR(20),
    os_version VARCHAR(50),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_device_fingerprint UNIQUE (device_fingerprint)
);

CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id UUID NOT NULL REFERENCES user_devices(id) ON DELETE CASCADE,
    refresh_token_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revoked_at TIMESTAMPTZ
);

CREATE TABLE transfer_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    issued_device_id UUID NOT NULL REFERENCES user_devices(id) ON DELETE CASCADE,
    token_hash TEXT NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    used_by_device_id UUID REFERENCES user_devices(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_token_hash UNIQUE (token_hash)
);

-- =========================================
-- Tasks / Tags
-- =========================================

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(500) NOT NULL,
    memo TEXT,
    due_at TIMESTAMPTZ,
    status SMALLINT NOT NULL DEFAULT 1 CHECK (status >= 1), -- 1:TODO 2:DOING 3:DONE
    pinned BOOLEAN NOT NULL DEFAULT false,
    completed_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE TABLE task_completions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_task_completion UNIQUE (task_id)
);

CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_tag_name UNIQUE (user_id, name)
);

CREATE TABLE task_tags (
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);

-- =========================================
-- Balloons
-- =========================================

CREATE TABLE balloons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    balloon_type SMALLINT NOT NULL CHECK (balloon_type >= 1), -- 1:GLOBAL 2:LOCATION 3:BREATHING 4:USER 5:GUERRILLA
    display_group SMALLINT NOT NULL CHECK (display_group >= 1), -- 1:PINNED 2:DRIFTING
    visibility SMALLINT NOT NULL CHECK (visibility >= 1), -- 1:SYSTEM 2:PRIVATE 3:PUBLIC
    owner_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    title VARCHAR(100),
    description TEXT,
    color_id SMALLINT,
    tag_icon_id SMALLINT,
    country_code CHAR(2),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE balloon_memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    balloon_id UUID NOT NULL REFERENCES balloons(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE balloon_selections (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    balloon_id UUID NOT NULL REFERENCES balloons(id) ON DELETE CASCADE,
    priority INT NOT NULL DEFAULT 1,
    selected_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMPTZ,
    PRIMARY KEY (user_id, balloon_id)
);

CREATE TABLE balloon_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    balloon_id UUID NOT NULL REFERENCES balloons(id) ON DELETE CASCADE,
    unit_type SMALLINT NOT NULL CHECK (unit_type >= 1), -- 1:USER 2:COUNTRY 3:GLOBAL 4:UTC_DAY 5:EVENT
    unit_key VARCHAR(100) NOT NULL,
    current_value INT NOT NULL DEFAULT 0,
    next_threshold INT NOT NULL DEFAULT 1,
    break_count INT NOT NULL DEFAULT 0,
    lock_version INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_balloon_progress_unit UNIQUE (balloon_id, unit_type, unit_key)
);

CREATE TABLE contribution_ledger (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    balloon_id UUID NOT NULL REFERENCES balloons(id) ON DELETE CASCADE,
    unit_type SMALLINT NOT NULL CHECK (unit_type >= 1),
    unit_key VARCHAR(100) NOT NULL,
    source_type SMALLINT NOT NULL CHECK (source_type >= 1), -- 1:TASK 2:BREATH 3:SYSTEM 4:ADMIN
    source_id UUID,
    amount INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE balloon_pop_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    balloon_id UUID NOT NULL REFERENCES balloons(id) ON DELETE CASCADE,
    unit_type SMALLINT NOT NULL CHECK (unit_type >= 1),
    unit_key VARCHAR(100) NOT NULL,
    trigger_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    popped_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    threshold_at_pop INT NOT NULL,
    consumed INT NOT NULL,
    context_type SMALLINT CHECK (context_type >= 1), -- 1:TASK 2:BREATH 3:OTHER
    context_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE balloon_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    balloon_id UUID NOT NULL REFERENCES balloons(id) ON DELETE CASCADE,
    reason_type SMALLINT NOT NULL CHECK (reason_type >= 1),
    comment TEXT,
    status SMALLINT NOT NULL DEFAULT 1 CHECK (status >= 1),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMPTZ
);

-- =========================================
-- Guerrilla Events
-- =========================================

CREATE TABLE guerrilla_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tasbal_day DATE NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    source SMALLINT NOT NULL CHECK (source >= 1), -- 1:AUTO 2:ADMIN
    priority INT NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE balloon_event_links (
    event_id UUID NOT NULL REFERENCES guerrilla_events(id) ON DELETE CASCADE,
    balloon_id UUID NOT NULL REFERENCES balloons(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, balloon_id)
);

-- =========================================
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
