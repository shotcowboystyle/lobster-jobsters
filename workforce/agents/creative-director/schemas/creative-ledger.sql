-- ACME Bonsai Creative Director Team (Masahiko) — Creative Workflow Ledger
-- SQLite schema. Tracks workflow state for briefs, deliverables, photo shoots,
-- care guides, brand assets, brand system updates, revision cycles.
--
-- The brand asset library (data/asset-library/) holds delivered finals.
-- The brand system (data/brand-system/) holds the canonical style guide.
-- This ledger tracks workflow + approvals.

CREATE TABLE IF NOT EXISTS creative_briefs (
    brief_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    requester TEXT NOT NULL,
    requester_team TEXT NOT NULL CHECK (requester_team IN (
        'cmo', 'director-of-sales', 'coo', 'cfo', 'cto',
        'customer-service-manager', 'contract-coordinator',
        'ceo', 'chief-of-staff'
    )),
    purpose TEXT NOT NULL,
    kind TEXT NOT NULL,
    audience TEXT,
    specs_json TEXT,
    deadline TEXT,
    estimated_hours REAL,
    estimated_cost_usd REAL,
    approval_path TEXT CHECK (approval_path IN ('cd_only', 'cd_plus_ceo')),
    assigned_to TEXT CHECK (assigned_to IN ('hana', 'iris', 'mira', 'external')),
    linked_deliverable_ids_json TEXT,
    submitted_at TEXT NOT NULL DEFAULT (datetime('now')),
    triaged_at TEXT,
    triaged_by TEXT,
    assigned_at TEXT,
    delivered_at TEXT,
    status TEXT NOT NULL DEFAULT 'intake' CHECK (status IN (
        'intake', 'triaged', 'assigned', 'in_production', 'in_review',
        'approved', 'delivered', 'rejected', 'revising', 'archived'
    )),
    rejected_reason TEXT
);

CREATE TABLE IF NOT EXISTS design_deliverables (
    deliverable_id TEXT PRIMARY KEY,
    brief_id TEXT NOT NULL REFERENCES creative_briefs(brief_id),
    owner TEXT NOT NULL CHECK (owner IN ('hana', 'mira', 'masahiko')),
    kind TEXT NOT NULL,
    title TEXT,
    description TEXT,
    self_checklist_json TEXT,
    rationale TEXT,
    brand_system_references_json TEXT,
    files_json TEXT,
    revision_count INTEGER NOT NULL DEFAULT 0,
    revisions_json TEXT,
    linked_asset_id TEXT,
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    approved_at TEXT,
    approved_by TEXT,
    delivered_at TEXT,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'cd_review', 'revising', 'approved',
        'delivered', 'rejected', 'archived'
    )),
    rejected_reason TEXT
);

CREATE TABLE IF NOT EXISTS photo_shoots (
    shoot_id TEXT PRIMARY KEY,
    linked_brief_id TEXT REFERENCES creative_briefs(brief_id),
    kind TEXT NOT NULL,
    subject_summary TEXT NOT NULL,
    tree_ids_json TEXT,
    venue_json TEXT,
    scheduled_at TEXT,
    photographer TEXT,
    shot_list_json TEXT,
    lighting_notes TEXT,
    honest_representation_check_json TEXT,
    raw_files_location TEXT,
    edited_files_location TEXT,
    metadata_json TEXT,
    requested_at TEXT NOT NULL DEFAULT (datetime('now')),
    captured_at TEXT,
    edited_at TEXT,
    approved_at TEXT,
    linked_asset_ids_json TEXT,
    status TEXT NOT NULL DEFAULT 'requested' CHECK (status IN (
        'requested', 'scheduled', 'captured', 'editing', 'cd_review',
        'approved', 'rescheduled', 'cancelled', 'rejected', 'archived'
    )),
    rescheduled_reason TEXT,
    cancelled_reason TEXT
);

CREATE TABLE IF NOT EXISTS care_guides (
    guide_id TEXT PRIMARY KEY,
    linked_brief_id TEXT REFERENCES creative_briefs(brief_id),
    title TEXT NOT NULL,
    kind TEXT NOT NULL,
    topic TEXT,
    target_audience TEXT CHECK (target_audience IN (
        'beginner', 'intermediate', 'advanced', 'all'
    )),
    format TEXT CHECK (format IN (
        'pdf', 'web_page', 'social_carousel', 'video',
        'print_handout', 'infographic'
    )),
    sections_json TEXT,
    technical_review_json TEXT,
    cd_review_json TEXT,
    linked_asset_id TEXT,
    publication_targets_json TEXT,
    published_at TEXT,
    publish_idempotency_key TEXT,
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'technical_review', 'cd_review', 'revising',
        'approved', 'published', 'rejected', 'archived'
    )),
    rejected_reason TEXT
);

CREATE TABLE IF NOT EXISTS brand_assets (
    asset_id TEXT PRIMARY KEY,
    source_deliverable_id TEXT,
    source_shoot_id TEXT,
    source_guide_id TEXT,
    kind TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    tags_json TEXT,
    subject_tree_ids_json TEXT,
    file_paths_json TEXT NOT NULL,
    version TEXT,
    previous_versions_json TEXT,
    approval_json TEXT,
    release_status_json TEXT,
    usage_history_json TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    status TEXT NOT NULL DEFAULT 'staging' CHECK (status IN (
        'staging', 'approved', 'published', 'deprecated', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS brand_system_updates (
    update_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL,
    scope TEXT NOT NULL CHECK (scope IN (
        'minor_adjustment', 'addition', 'deprecation',
        'major_change', 'rebranding'
    )),
    proposed_by TEXT,
    rationale TEXT,
    current_state TEXT,
    proposed_state TEXT,
    impact_analysis_json TEXT,
    approval_path TEXT NOT NULL CHECK (approval_path IN (
        'cd_only', 'cd_plus_ceo'
    )),
    cd_decision_json TEXT,
    ceo_decision_json TEXT,
    published_at TEXT,
    linked_retrofit_brief_ids_json TEXT,
    proposed_at TEXT NOT NULL DEFAULT (datetime('now')),
    status TEXT NOT NULL DEFAULT 'proposed' CHECK (status IN (
        'proposed', 'impact_analysis', 'cd_review', 'ceo_review',
        'approved', 'published', 'rejected', 'archived'
    )),
    rejected_reason TEXT
);

CREATE TABLE IF NOT EXISTS revision_cycles (
    revision_id TEXT PRIMARY KEY,
    parent_kind TEXT NOT NULL CHECK (parent_kind IN (
        'deliverable', 'shoot', 'care_guide'
    )),
    parent_id TEXT NOT NULL,
    round INTEGER NOT NULL,
    feedback_json TEXT NOT NULL,
    owner_response TEXT,
    files_after_json TEXT,
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    responded_at TEXT,
    resolved_at TEXT,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN (
        'open', 'responded', 'resolved', 'abandoned'
    ))
);

CREATE TABLE IF NOT EXISTS creative_actions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_kind TEXT NOT NULL CHECK (action_kind IN (
        'publish_web', 'publish_social', 'publish_care_guide', 'release_request'
    )),
    related_id TEXT NOT NULL,
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'sent', 'failed', 'cancelled')),
    attempt INTEGER NOT NULL DEFAULT 1,
    provider_reference TEXT,
    failure_reason TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    completed_at TEXT
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN (
        'creative_brief', 'design_deliverable', 'photo_shoot',
        'care_guide', 'brand_asset', 'brand_system_update',
        'revision_cycle', 'creative_action'
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
CREATE INDEX IF NOT EXISTS idx_brief_status ON creative_briefs(status);
CREATE INDEX IF NOT EXISTS idx_brief_team ON creative_briefs(requester_team);
CREATE INDEX IF NOT EXISTS idx_brief_assigned ON creative_briefs(assigned_to);
CREATE INDEX IF NOT EXISTS idx_brief_deadline ON creative_briefs(deadline);
CREATE INDEX IF NOT EXISTS idx_deliverable_status ON design_deliverables(status);
CREATE INDEX IF NOT EXISTS idx_deliverable_owner ON design_deliverables(owner);
CREATE INDEX IF NOT EXISTS idx_deliverable_brief ON design_deliverables(brief_id);
CREATE INDEX IF NOT EXISTS idx_shoot_status ON photo_shoots(status);
CREATE INDEX IF NOT EXISTS idx_shoot_scheduled ON photo_shoots(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_guide_status ON care_guides(status);
CREATE INDEX IF NOT EXISTS idx_guide_topic ON care_guides(topic);
CREATE INDEX IF NOT EXISTS idx_asset_kind ON brand_assets(kind);
CREATE INDEX IF NOT EXISTS idx_asset_status ON brand_assets(status);
CREATE INDEX IF NOT EXISTS idx_bs_update_status ON brand_system_updates(status);
CREATE INDEX IF NOT EXISTS idx_bs_update_scope ON brand_system_updates(scope);
CREATE INDEX IF NOT EXISTS idx_revision_parent ON revision_cycles(parent_kind, parent_id);
CREATE INDEX IF NOT EXISTS idx_revision_status ON revision_cycles(status);
CREATE INDEX IF NOT EXISTS idx_actions_idempotency ON creative_actions(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
