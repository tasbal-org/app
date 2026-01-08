-- =========================================
-- Tasbal Initial Schema Migration
-- Balloons / Guerrilla Events Tables
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
