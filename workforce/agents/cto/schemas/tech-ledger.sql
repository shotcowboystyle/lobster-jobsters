-- ACME Bonsai CTO Team (Allen) — Tech Workflow Ledger
-- SQLite schema. Tracks feature requests, specs, PRs, releases,
-- incidents, security findings, observability snapshots, tech debt
-- entries, and outbound tech actions.
--
-- GitHub holds source of truth for code; the hosting provider holds
-- source of truth for infrastructure. This ledger holds workflow /
-- coordination state.

CREATE TABLE IF NOT EXISTS feature_requests (
    feature_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    requester TEXT NOT NULL,
    requester_team TEXT NOT NULL CHECK (requester_team IN (
        'cmo', 'director-of-sales', 'coo', 'cfo',
        'creative-director', 'customer-service-manager',
        'contract-coordinator', 'ceo', 'chief-of-staff'
    )),
    purpose TEXT NOT NULL,
    requirements TEXT,
    acceptance_criteria_json TEXT,
    domains_json TEXT,
    estimated_hours REAL,
    estimated_cost_usd REAL,
    approval_path TEXT CHECK (approval_path IN ('cto_only', 'cto_plus_ceo')),
    priority TEXT CHECK (priority IN ('p0_critical', 'p1_high', 'p2_medium', 'p3_low')),
    deadline TEXT,
    submitted_at TEXT NOT NULL DEFAULT (datetime('now')),
    linked_spec_id TEXT,
    linked_pr_ids_json TEXT,
    status TEXT NOT NULL DEFAULT 'intake' CHECK (status IN (
        'intake', 'triaged', 'specced', 'in_dev', 'in_review',
        'in_staging', 'in_prod', 'rejected', 'deferred',
        'rolled_back', 'archived'
    )),
    triaged_at TEXT,
    triaged_by TEXT,
    rejected_reason TEXT,
    deferred_until TEXT
);

CREATE TABLE IF NOT EXISTS specs (
    spec_id TEXT PRIMARY KEY,
    feature_id TEXT NOT NULL REFERENCES feature_requests(feature_id),
    owner TEXT NOT NULL CHECK (owner IN ('pixel', 'forge', 'bastion', 'allen')),
    summary TEXT NOT NULL,
    architecture_notes TEXT,
    data_model_changes_json TEXT,
    api_changes_json TEXT,
    ui_changes_json TEXT,
    infra_changes_json TEXT,
    test_plan_json TEXT,
    rollout_plan TEXT,
    monitoring_additions_json TEXT,
    dependencies_json TEXT,
    estimated_hours REAL,
    estimated_cost_usd REAL,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'cto_review', 'requester_review',
        'accepted', 'rejected', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    accepted_at TEXT,
    accepted_by TEXT
);

CREATE TABLE IF NOT EXISTS pull_requests (
    pr_id TEXT PRIMARY KEY,
    github_pr_number INTEGER NOT NULL,
    github_repo TEXT NOT NULL,
    github_pr_url TEXT,
    feature_id TEXT REFERENCES feature_requests(feature_id),
    linked_spec_id TEXT REFERENCES specs(spec_id),
    author TEXT NOT NULL CHECK (author IN ('pixel', 'forge', 'bastion', 'human')),
    branch TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    files_changed INTEGER,
    lines_added INTEGER,
    lines_deleted INTEGER,
    ci_status TEXT CHECK (ci_status IN ('pending', 'passing', 'failing', 'neutral')),
    test_coverage_delta_pct REAL,
    reviewers_json TEXT,
    review_comments INTEGER,
    blockers_json TEXT,
    linked_release_id TEXT,
    commit_sha TEXT,
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    merged_at TEXT,
    deployed_at TEXT,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'review', 'approved', 'merged',
        'deployed', 'closed', 'rejected', 'abandoned'
    ))
);

CREATE TABLE IF NOT EXISTS releases (
    release_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    kind TEXT CHECK (kind IN ('standard', 'hotfix', 'major', 'infra_change', 'schema_migration')),
    scheduled_at TEXT NOT NULL,
    pr_ids_json TEXT NOT NULL,
    feature_ids_json TEXT,
    changelog TEXT,
    deploy_environment TEXT NOT NULL CHECK (deploy_environment IN ('staging', 'production')),
    backup_verified INTEGER NOT NULL DEFAULT 0,
    backup_verified_at TEXT,
    rollback_plan TEXT NOT NULL,
    rollback_idempotency_key TEXT,
    deploy_window_ok INTEGER NOT NULL,
    deploy_window_check_notes TEXT,
    staging_qa_json TEXT,
    approval_path TEXT CHECK (approval_path IN ('allen_only', 'allen_plus_ceo')),
    approved_by TEXT,
    approved_at TEXT,
    deploy_json TEXT,
    monitoring_window_hours INTEGER NOT NULL DEFAULT 24,
    monitoring_metrics_json TEXT,
    rollback_triggered INTEGER NOT NULL DEFAULT 0,
    rollback_reason TEXT,
    rollback_completed_at TEXT,
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN (
        'scheduled', 'in_staging', 'staging_qa', 'approved',
        'deploying', 'deployed', 'monitoring', 'closed',
        'rejected', 'rolled_back', 'failed'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    closed_at TEXT
);

CREATE TABLE IF NOT EXISTS incidents (
    incident_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN (
        'sev1_critical', 'sev2_high', 'sev3_medium', 'sev4_low'
    )),
    detected_at TEXT NOT NULL,
    detected_by TEXT,
    detection_source TEXT CHECK (detection_source IN (
        'sentry', 'uptime_check', 'user_report', 'internal_user',
        'alert_routine', 'other'
    )),
    affected_surfaces_json TEXT,
    user_impact_estimate TEXT,
    owner TEXT CHECK (owner IN ('bastion', 'forge', 'pixel', 'allen')),
    linked_release_id TEXT REFERENCES releases(release_id),
    triage_notes TEXT,
    triaged_at TEXT,
    mitigation_json TEXT,
    resolution_json TEXT,
    postmortem_json TEXT,
    ceo_escalated INTEGER NOT NULL DEFAULT 0,
    ceo_escalated_at TEXT,
    customer_notification_sent INTEGER NOT NULL DEFAULT 0,
    customer_notification_idempotency_key TEXT,
    status TEXT NOT NULL DEFAULT 'detected' CHECK (status IN (
        'detected', 'triaged', 'mitigated', 'resolved',
        'postmortem', 'archived', 'escalated'
    )),
    mttr_minutes INTEGER
);

CREATE TABLE IF NOT EXISTS security_findings (
    finding_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN (
        'dependency_cve', 'code_vuln', 'config_issue', 'secret_exposure',
        'auth_weakness', 'data_exposure', 'ssl_cert', 'third_party', 'other'
    )),
    cve_id TEXT,
    cvss_score REAL,
    severity TEXT NOT NULL CHECK (severity IN ('critical', 'high', 'medium', 'low', 'info')),
    summary TEXT NOT NULL,
    affected_components_json TEXT,
    detected_at TEXT NOT NULL DEFAULT (datetime('now')),
    detection_source TEXT,
    patch_available INTEGER,
    patch_summary TEXT,
    exploit_in_wild INTEGER DEFAULT 0,
    patch_target_date TEXT,
    risk_acceptance_json TEXT,
    patch_pr_id TEXT,
    verified_at TEXT,
    verified_by TEXT,
    status TEXT NOT NULL DEFAULT 'detected' CHECK (status IN (
        'detected', 'triaged', 'patching', 'patched',
        'verified', 'deferred', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS observability_snapshots (
    snapshot_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN ('daily', 'weekly', 'monthly')),
    as_of TEXT NOT NULL,
    period_start TEXT,
    period_end TEXT,
    uptime_json TEXT NOT NULL,
    latency_json TEXT NOT NULL,
    error_rate_json TEXT NOT NULL,
    page_load_json TEXT,
    infrastructure_json TEXT,
    deploys_this_period INTEGER,
    incidents_this_period_json TEXT,
    alerts_json TEXT,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'cto_review', 'published', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS tech_debt_entries (
    debt_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    domain TEXT NOT NULL CHECK (domain IN (
        'frontend', 'backend', 'infra', 'data',
        'integration', 'test', 'documentation'
    )),
    logged_at TEXT NOT NULL DEFAULT (datetime('now')),
    logged_by TEXT,
    discovered_in_incident_id TEXT,
    discovered_in_feature_id TEXT,
    principal_estimate_hours REAL NOT NULL,
    interest_rate_pct_monthly REAL NOT NULL,
    interest_explanation TEXT,
    cumulative_interest_paid_usd REAL DEFAULT 0,
    priority TEXT CHECK (priority IN ('high', 'medium', 'low')),
    scheduled_for_quarter TEXT,
    scheduled_owner TEXT,
    linked_pr_ids_json TEXT,
    status TEXT NOT NULL DEFAULT 'logged' CHECK (status IN (
        'logged', 'triaged', 'scheduled', 'in_progress',
        'resolved', 'deferred', 'archived'
    )),
    deferred_reason TEXT,
    deferred_next_review_date TEXT,
    resolved_at TEXT
);

CREATE TABLE IF NOT EXISTS tech_actions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_kind TEXT NOT NULL CHECK (action_kind IN (
        'deploy', 'rollback', 'backup', 'customer_notification', 'security_patch'
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
        'feature_request', 'spec', 'pull_request', 'release',
        'incident', 'security_finding', 'observability_snapshot',
        'tech_debt_entry', 'tech_action'
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
CREATE INDEX IF NOT EXISTS idx_feature_status ON feature_requests(status);
CREATE INDEX IF NOT EXISTS idx_feature_priority ON feature_requests(priority);
CREATE INDEX IF NOT EXISTS idx_feature_team ON feature_requests(requester_team);
CREATE INDEX IF NOT EXISTS idx_spec_feature ON specs(feature_id);
CREATE INDEX IF NOT EXISTS idx_spec_status ON specs(status);
CREATE INDEX IF NOT EXISTS idx_pr_status ON pull_requests(status);
CREATE INDEX IF NOT EXISTS idx_pr_feature ON pull_requests(feature_id);
CREATE INDEX IF NOT EXISTS idx_pr_github ON pull_requests(github_repo, github_pr_number);
CREATE INDEX IF NOT EXISTS idx_release_status ON releases(status);
CREATE INDEX IF NOT EXISTS idx_release_scheduled ON releases(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_release_idempotency ON releases(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_incident_status ON incidents(status);
CREATE INDEX IF NOT EXISTS idx_incident_severity ON incidents(severity);
CREATE INDEX IF NOT EXISTS idx_incident_detected ON incidents(detected_at);
CREATE INDEX IF NOT EXISTS idx_finding_status ON security_findings(status);
CREATE INDEX IF NOT EXISTS idx_finding_severity ON security_findings(severity);
CREATE INDEX IF NOT EXISTS idx_obs_as_of ON observability_snapshots(as_of);
CREATE INDEX IF NOT EXISTS idx_obs_kind ON observability_snapshots(kind);
CREATE INDEX IF NOT EXISTS idx_debt_status ON tech_debt_entries(status);
CREATE INDEX IF NOT EXISTS idx_debt_domain ON tech_debt_entries(domain);
CREATE INDEX IF NOT EXISTS idx_debt_priority ON tech_debt_entries(priority);
CREATE INDEX IF NOT EXISTS idx_actions_idempotency ON tech_actions(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
