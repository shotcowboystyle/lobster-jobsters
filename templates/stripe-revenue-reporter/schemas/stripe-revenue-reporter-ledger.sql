-- Stripe Revenue Reporter ledger: run lifecycle only. Revenue figures and customer data never land here.
-- Every state change writes a ledger_state_transitions row. That table is the audit trail.

PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS digest_runs (
    id TEXT PRIMARY KEY,                       -- stripe-revenue-reporter-{period_start}-{period_end}
    kind TEXT NOT NULL CHECK (kind IN ('daily', 'on_demand')),
    period_start TEXT NOT NULL,                -- ISO date, inclusive
    period_end TEXT NOT NULL,                  -- ISO date, inclusive
    status TEXT NOT NULL CHECK (status IN (
        'running', 'posted', 'skipped_partial_data', 'failed'
    )),
    discord_message_id TEXT,
    idempotency_key TEXT UNIQUE,               -- stripe-revenue-reporter-{period_start}-{period_end}-post-{attempt}
    attempt INTEGER NOT NULL DEFAULT 0,
    failure_reason TEXT,                       -- e.g. "refunds query timed out"; never figures
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (period_start, period_end)          -- one digest per period
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('digest_run')),
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT,                             -- JSON; never revenue figures or customer data
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_transitions_at ON ledger_state_transitions(transitioned_at);
CREATE INDEX IF NOT EXISTS idx_digest_runs_status ON digest_runs(status);

-- Runs that did not post in the last 3 days
CREATE VIEW IF NOT EXISTS v_unposted_runs AS
SELECT id, kind, period_start, period_end, status, failure_reason, updated_at
FROM digest_runs
WHERE status != 'posted' AND julianday('now') - julianday(updated_at) <= 3;
