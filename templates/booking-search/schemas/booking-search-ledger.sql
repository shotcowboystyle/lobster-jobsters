-- Booking Search Agent ledger: search lifecycle only. No guest names, contacts, or payment data.
-- Every state change writes a ledger_state_transitions row. That table is the audit trail.

PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS searches (
    id TEXT PRIMARY KEY,                       -- booking-search-{query_hash}-{hour_bucket}
    query_hash TEXT NOT NULL,                  -- sha256 of the normalized query (see AGENTS.md)
    hour_bucket TEXT NOT NULL,                 -- yyyy-mm-ddThh, the dedupe window
    location TEXT NOT NULL,
    checkin TEXT NOT NULL,
    checkout TEXT NOT NULL,
    adults INTEGER NOT NULL,
    children INTEGER NOT NULL DEFAULT 0,
    rooms INTEGER NOT NULL DEFAULT 1,
    currency TEXT,
    resolved_destination TEXT,
    total_count INTEGER,
    status TEXT NOT NULL CHECK (status IN (
        'searching', 'answered', 'no_results', 'blocked', 'failed'
    )),
    attempt INTEGER NOT NULL DEFAULT 0,
    failure_reason TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (query_hash, hour_bucket)           -- one provider call per identical query per hour
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('search')),
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT,                             -- JSON; never guest PII
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_transitions_at ON ledger_state_transitions(transitioned_at);
CREATE INDEX IF NOT EXISTS idx_searches_created ON searches(created_at);

-- Searches in the last hour, for the hourly cap
CREATE VIEW IF NOT EXISTS v_searches_last_hour AS
SELECT COUNT(*) AS n FROM searches WHERE created_at > datetime('now', '-1 hour');
