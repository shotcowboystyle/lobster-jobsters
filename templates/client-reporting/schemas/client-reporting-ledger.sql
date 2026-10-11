-- Client Reporting Agent ledger: lifecycle metadata only. Client metrics never land here.
-- Every state change writes a ledger_state_transitions row. That table is the audit trail.

PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS report_drafts (
    id TEXT PRIMARY KEY,                       -- client-reporting-{client_slug}-{week_start}
    client_slug TEXT NOT NULL,
    week_start TEXT NOT NULL,                  -- ISO date (Monday) of the reported week
    status TEXT NOT NULL CHECK (status IN (
        'drafting', 'am_review', 'sent_by_am', 'discarded', 'failed'
    )),
    am TEXT NOT NULL,
    discord_thread_id TEXT,
    idempotency_key TEXT UNIQUE,               -- client-reporting-{client_slug}-{week_start}-post-{attempt}
    attempt INTEGER NOT NULL DEFAULT 0,
    failure_reason TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (client_slug, week_start)           -- one draft per client per week
);

CREATE TABLE IF NOT EXISTS source_skips (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    report_draft_id TEXT NOT NULL REFERENCES report_drafts(id),
    source TEXT NOT NULL CHECK (source IN ('ga4', 'gsc', 'google_ads', 'meta_ads', 'tracker')),
    reason TEXT NOT NULL CHECK (reason IN ('not_configured', 'missing_credential', 'api_error', 'disabled')),
    detail TEXT,
    skipped_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('report_draft')),
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT,                             -- JSON; never client metrics
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_transitions_at ON ledger_state_transitions(transitioned_at);
CREATE INDEX IF NOT EXISTS idx_report_drafts_status ON report_drafts(status);

-- Drafts waiting on an AM for more than 48 hours
CREATE VIEW IF NOT EXISTS v_stale_reviews AS
SELECT id, client_slug, am, updated_at,
       ROUND((julianday('now') - julianday(updated_at)) * 24, 1) AS hours_waiting
FROM report_drafts
WHERE status = 'am_review' AND julianday('now') - julianday(updated_at) > 2;
