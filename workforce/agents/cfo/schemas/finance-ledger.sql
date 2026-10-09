-- ACME Bonsai CFO Team (Sterling) — Finance Workflow Ledger
-- SQLite schema. Tracks workflow state (close packages, forecasts, exceptions,
-- pricing decisions, compliance deadlines, runway snapshots).
--
-- The accounting system (QBO / Xero) holds the financial state of record.
-- This ledger holds the workflow / approval state of finance activity.

CREATE TABLE IF NOT EXISTS monthly_close (
    close_id TEXT PRIMARY KEY,
    period TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'opened' CHECK (status IN (
        'opened', 'reconciling', 'variance_review', 'cfo_review',
        'ceo_review', 'closed', 'held', 'archived'
    )),
    opened_at TEXT NOT NULL DEFAULT (datetime('now')),
    target_close_at TEXT,
    actual_close_at TEXT,
    tasks_json TEXT NOT NULL,
    reconciliations_json TEXT,
    material_variances_json TEXT,
    summary_json TEXT,
    approved_by TEXT,
    approved_at TEXT
);

CREATE TABLE IF NOT EXISTS forecasts (
    forecast_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN ('monthly', 'quarterly', 'adhoc', 'runway')),
    horizon_periods_json TEXT NOT NULL,
    assumptions_json TEXT NOT NULL,
    scenarios_json TEXT NOT NULL,
    sensitivity_json TEXT,
    key_metrics_json TEXT,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'assumptions_locked', 'cfo_review',
        'ceo_review', 'published', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    published_at TEXT,
    drafted_by TEXT NOT NULL DEFAULT 'fpa',
    approved_by TEXT
);

CREATE TABLE IF NOT EXISTS variance_reports (
    variance_id TEXT PRIMARY KEY,
    period TEXT NOT NULL,
    kind TEXT NOT NULL DEFAULT 'monthly' CHECK (kind IN ('monthly', 'quarterly', 'ytd')),
    lines_json TEXT NOT NULL,
    summary TEXT,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'cfo_review', 'published', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    published_at TEXT
);

CREATE TABLE IF NOT EXISTS pricing_decisions (
    pricing_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN (
        'price_change', 'discount', 'promo', 'channel_repricing',
        'subscription_change', 'deal_economics'
    )),
    channel TEXT,
    subject TEXT NOT NULL,
    requested_by TEXT,
    current_json TEXT NOT NULL,
    proposed_json TEXT NOT NULL,
    margin_impact_json TEXT NOT NULL,
    strategic_rationale TEXT,
    expected_outcome TEXT,
    expiry_date TEXT,
    approval_path TEXT NOT NULL CHECK (approval_path IN (
        'sterling_only', 'sterling_plus_ceo', 'ceo_only'
    )),
    status TEXT NOT NULL DEFAULT 'proposed' CHECK (status IN (
        'proposed', 'analysis', 'cfo_review', 'ceo_review',
        'approved', 'rejected', 'in_effect', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    approved_at TEXT,
    approved_by TEXT,
    rejected_reason TEXT
);

CREATE TABLE IF NOT EXISTS exception_logs (
    exception_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL,
    description TEXT NOT NULL,
    detected_at TEXT NOT NULL DEFAULT (datetime('now')),
    detected_by TEXT,
    amount_usd REAL,
    linked_references_json TEXT,
    owner TEXT NOT NULL,
    root_cause TEXT,
    corrective_action TEXT,
    preventive_action TEXT,
    approval_chain_json TEXT,
    status TEXT NOT NULL DEFAULT 'detected' CHECK (status IN (
        'detected', 'documented', 'owner_assigned', 'resolved',
        'escalated', 'archived'
    )),
    resolved_at TEXT,
    severity TEXT NOT NULL DEFAULT 'low' CHECK (severity IN (
        'low', 'medium', 'high', 'critical'
    ))
);

CREATE TABLE IF NOT EXISTS compliance_deadlines (
    compliance_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL,
    jurisdiction TEXT NOT NULL,
    due_date TEXT NOT NULL,
    frequency TEXT CHECK (frequency IN ('monthly', 'quarterly', 'annual', 'one_time')),
    owner TEXT NOT NULL DEFAULT 'garrison',
    preparer TEXT,
    amount_due_usd REAL,
    estimated_amount_due_usd REAL,
    filing_method TEXT CHECK (filing_method IN ('electronic', 'paper', 'in_person')),
    status TEXT NOT NULL DEFAULT 'tracked' CHECK (status IN (
        'tracked', 'due_soon', 'in_progress', 'filed', 'missed', 'archived'
    )),
    acknowledged_at TEXT,
    filed_at TEXT,
    filing_confirmation TEXT,
    filing_receipt_path TEXT,
    linked_exception_id TEXT REFERENCES exception_logs(exception_id)
);

CREATE TABLE IF NOT EXISTS cash_runway_snapshots (
    runway_id TEXT PRIMARY KEY,
    as_of TEXT NOT NULL,
    cash_position_usd REAL NOT NULL,
    operating_cash_usd REAL,
    restricted_cash_usd REAL,
    ar_usd REAL,
    ap_usd REAL,
    burn_rate_usd_per_month REAL,
    trailing_3mo_avg_burn_usd REAL,
    runway_days INTEGER NOT NULL,
    runway_status TEXT NOT NULL CHECK (runway_status IN ('green', 'yellow', 'red')),
    thirteen_week_projection_json TEXT NOT NULL,
    key_assumptions_json TEXT,
    alerts_json TEXT,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'cfo_review', 'published', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS finance_actions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_kind TEXT NOT NULL CHECK (action_kind IN (
        'invoice_send', 'refund', 'vendor_payment', 'filing'
    )),
    related_id TEXT NOT NULL,
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'pending', 'sent', 'failed', 'cancelled'
    )),
    attempt INTEGER NOT NULL DEFAULT 1,
    amount_usd REAL,
    provider_reference TEXT,
    failure_reason TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    completed_at TEXT
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN (
        'monthly_close', 'forecast', 'variance_report', 'pricing_decision',
        'exception_log', 'compliance_deadline', 'cash_runway_snapshot',
        'finance_action'
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
CREATE INDEX IF NOT EXISTS idx_close_status ON monthly_close(status);
CREATE INDEX IF NOT EXISTS idx_close_period ON monthly_close(period);
CREATE INDEX IF NOT EXISTS idx_forecasts_status ON forecasts(status);
CREATE INDEX IF NOT EXISTS idx_forecasts_kind ON forecasts(kind);
CREATE INDEX IF NOT EXISTS idx_variance_period ON variance_reports(period);
CREATE INDEX IF NOT EXISTS idx_pricing_status ON pricing_decisions(status);
CREATE INDEX IF NOT EXISTS idx_pricing_channel ON pricing_decisions(channel);
CREATE INDEX IF NOT EXISTS idx_exception_status ON exception_logs(status);
CREATE INDEX IF NOT EXISTS idx_exception_severity ON exception_logs(severity);
CREATE INDEX IF NOT EXISTS idx_compliance_status ON compliance_deadlines(status);
CREATE INDEX IF NOT EXISTS idx_compliance_due ON compliance_deadlines(due_date);
CREATE INDEX IF NOT EXISTS idx_runway_as_of ON cash_runway_snapshots(as_of);
CREATE INDEX IF NOT EXISTS idx_runway_status ON cash_runway_snapshots(runway_status);
CREATE INDEX IF NOT EXISTS idx_finance_actions_idempotency ON finance_actions(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
