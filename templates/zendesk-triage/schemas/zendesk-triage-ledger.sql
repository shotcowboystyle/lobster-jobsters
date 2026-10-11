-- Zendesk Triage Agent ledger: triage metadata only. Ticket bodies and requester details never land here.
-- Every state change writes a ledger_state_transitions row. That table is the audit trail.

PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS triage_records (
    id TEXT PRIMARY KEY,                       -- zendesk-triage-{ticket_id}-{event_id}
    ticket_id TEXT NOT NULL,
    event_id TEXT NOT NULL,                    -- Zendesk webhook event id
    event_type TEXT NOT NULL CHECK (event_type IN ('ticket.created', 'ticket.updated')),
    status TEXT NOT NULL CHECK (status IN (
        'received', 'triaged', 'held', 'failed', 'corrected'
    )),
    category TEXT,
    priority TEXT CHECK (priority IN ('high', 'normal', 'low')),
    suggested_assignee TEXT,
    duplicate_of TEXT,                         -- ticket id of a likely duplicate, if any
    possible_sev1 INTEGER NOT NULL DEFAULT 0 CHECK (possible_sev1 IN (0, 1)),
    idempotency_key TEXT UNIQUE,               -- zendesk-triage-{ticket_id}-{event_id}-{action}-{attempt}
    attempt INTEGER NOT NULL DEFAULT 0,
    failure_reason TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (ticket_id, event_id)               -- one triage per ticket event
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('triage_record')),
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT,                             -- JSON; never ticket bodies or PII
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_transitions_at ON ledger_state_transitions(transitioned_at);
CREATE INDEX IF NOT EXISTS idx_triage_records_status ON triage_records(status);
CREATE INDEX IF NOT EXISTS idx_triage_records_ticket ON triage_records(ticket_id);

-- Possible SEV-1 tickets surfaced in the last 24 hours
CREATE VIEW IF NOT EXISTS v_recent_sev1 AS
SELECT ticket_id, category, priority, updated_at
FROM triage_records
WHERE possible_sev1 = 1 AND julianday('now') - julianday(created_at) < 1;
