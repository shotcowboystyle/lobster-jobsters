-- {{COMPANY}} {{TEAM_NAME}} ledger — canonical source of truth for this team's domain.
-- Every agent that changes state writes a ledger_state_transitions row. That table is the audit trail.

PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS work_items (
    id TEXT PRIMARY KEY,                       -- e.g. {{TEAM_SLUG}}-2026-01-15-001
    kind TEXT NOT NULL,                        -- domain-specific type of work item
    title TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'intake', 'drafted', 'review', 'approved', 'rejected', 'held',
        'executed', 'execution_failed', 'archived'
    )),
    owner_agent TEXT NOT NULL,
    approver TEXT,
    amount_usd REAL,
    idempotency_key TEXT UNIQUE,               -- {{TEAM_SLUG}}-{id}-{action}-{date}-{attempt}
    attempt INTEGER NOT NULL DEFAULT 0,
    payload TEXT,                              -- JSON artifact
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS approvals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    work_item_id TEXT NOT NULL REFERENCES work_items(id),
    rule TEXT NOT NULL,                        -- approval-policy.json rule name
    approver TEXT NOT NULL,
    decision TEXT NOT NULL CHECK (decision IN ('approve', 'edit', 'hold', 'reject')),
    notes TEXT,
    decided_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('work_item', 'approval')),
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT,                             -- JSON
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_transitions_at ON ledger_state_transitions(transitioned_at);
CREATE INDEX IF NOT EXISTS idx_work_items_status ON work_items(status);

-- Items waiting on a human for more than 24 hours
CREATE VIEW IF NOT EXISTS v_stale_reviews AS
SELECT id, title, approver, updated_at,
       ROUND((julianday('now') - julianday(updated_at)) * 24, 1) AS hours_waiting
FROM work_items
WHERE status = 'review' AND julianday('now') - julianday(updated_at) > 1;
