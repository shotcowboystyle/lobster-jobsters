-- ACME Bonsai Chief of Staff Team — Executive Ledger
-- SQLite schema. Canonical source of truth for agendas, action items,
-- briefings, initiatives, agent-health snapshots, and escalations.

CREATE TABLE IF NOT EXISTS briefings (
    briefing_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN ('weekly', 'midweek', 'daily', 'adhoc')),
    headline_decision TEXT NOT NULL,
    summary TEXT NOT NULL,
    word_count INTEGER NOT NULL CHECK (word_count <= 400),
    key_metrics_json TEXT,
    open_blockers_json TEXT,
    recommended_action TEXT,
    team_contributions_json TEXT,
    status TEXT NOT NULL DEFAULT 'queued' CHECK (status IN (
        'queued', 'drafting', 'coordinator_review', 'revising',
        'published', 'acknowledged', 'archived', 'held', 'retracted'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    published_at TEXT,
    acknowledged_at TEXT,
    drafted_by TEXT NOT NULL DEFAULT 'briefing-synthesizer',
    approved_by TEXT
);

CREATE TABLE IF NOT EXISTS action_items (
    action_item_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    outcome_statement TEXT,
    owner TEXT NOT NULL,
    deadline TEXT NOT NULL,
    originating_meeting_id TEXT,
    originating_briefing_id TEXT,
    originating_initiative_id TEXT,
    status TEXT NOT NULL DEFAULT 'opened' CHECK (status IN (
        'opened', 'in_progress', 'blocked', 'done', 'dropped', 'archived'
    )),
    blocked_reason TEXT,
    dropped_reason TEXT,
    follow_ups_sent_json TEXT,
    opened_at TEXT NOT NULL DEFAULT (datetime('now')),
    completed_at TEXT,
    completion_note TEXT
);

CREATE TABLE IF NOT EXISTS meeting_agendas (
    meeting_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    scheduled_for TEXT NOT NULL,
    duration_minutes INTEGER,
    attendees_json TEXT NOT NULL,
    objective TEXT NOT NULL,
    items_json TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN (
        'draft', 'ceo_review', 'approved', 'in_progress', 'completed', 'cancelled'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    approved_at TEXT,
    approved_by TEXT,
    minutes_url TEXT
);

CREATE TABLE IF NOT EXISTS initiatives (
    initiative_id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    summary TEXT,
    sponsor TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'proposed' CHECK (status IN (
        'proposed', 'active', 'on_hold', 'closed', 'cancelled', 'archived'
    )),
    success_criteria_json TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    last_changed_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS initiative_status_snapshots (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    initiative_id TEXT NOT NULL REFERENCES initiatives(initiative_id),
    health_color TEXT NOT NULL CHECK (health_color IN ('green', 'yellow', 'red')),
    previous_health_color TEXT,
    milestones_json TEXT,
    current_blockers_json TEXT,
    next_review_date TEXT,
    days_since_last_change INTEGER,
    stall_flag INTEGER NOT NULL DEFAULT 0,
    snapshot_at TEXT NOT NULL DEFAULT (datetime('now')),
    sponsor_confirmed INTEGER NOT NULL DEFAULT 0,
    sponsor_confirmed_at TEXT
);

CREATE TABLE IF NOT EXISTS agent_health_snapshots (
    snapshot_id TEXT PRIMARY KEY,
    swept_at TEXT NOT NULL DEFAULT (datetime('now')),
    agents_json TEXT NOT NULL,
    overall_status TEXT NOT NULL CHECK (overall_status IN ('green', 'yellow', 'red')),
    delta_json TEXT,
    posted_to_discord INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS escalations (
    escalation_id TEXT PRIMARY KEY,
    source_team TEXT NOT NULL CHECK (source_team IN (
        'cmo', 'ceo', 'cfo', 'coo', 'cto',
        'director-of-sales', 'creative-director',
        'customer-service-manager', 'contract-coordinator'
    )),
    kind TEXT NOT NULL,
    originating_artifact_id TEXT,
    decision_needed TEXT NOT NULL,
    options_json TEXT,
    context TEXT,
    recommended_action TEXT,
    ledger_references_json TEXT,
    posted_at TEXT NOT NULL DEFAULT (datetime('now')),
    status TEXT NOT NULL DEFAULT 'awaiting_decision' CHECK (status IN (
        'awaiting_decision', 'approved', 'rejected', 'deferred', 'timed_out'
    )),
    decided_by TEXT,
    decided_at TEXT,
    decision_notes TEXT
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN (
        'briefing', 'action_item', 'meeting_agenda', 'initiative', 'escalation', 'agent_health'
    )),
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT,
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_briefings_status ON briefings(status);
CREATE INDEX IF NOT EXISTS idx_briefings_kind ON briefings(kind);
CREATE INDEX IF NOT EXISTS idx_action_items_status ON action_items(status);
CREATE INDEX IF NOT EXISTS idx_action_items_owner ON action_items(owner);
CREATE INDEX IF NOT EXISTS idx_action_items_deadline ON action_items(deadline);
CREATE INDEX IF NOT EXISTS idx_meetings_scheduled ON meeting_agendas(scheduled_for);
CREATE INDEX IF NOT EXISTS idx_initiatives_status ON initiatives(status);
CREATE INDEX IF NOT EXISTS idx_initiative_snapshots_initiative ON initiative_status_snapshots(initiative_id);
CREATE INDEX IF NOT EXISTS idx_health_swept_at ON agent_health_snapshots(swept_at);
CREATE INDEX IF NOT EXISTS idx_escalations_status ON escalations(status);
CREATE INDEX IF NOT EXISTS idx_escalations_source ON escalations(source_team);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
