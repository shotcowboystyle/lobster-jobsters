-- SEO Content Planner ledger: brief lifecycle and calendar writes.
-- Every state change writes a ledger_state_transitions row. That table is the audit trail.

PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS briefs (
    id TEXT PRIMARY KEY,                       -- seo-content-planner-{YYYY-MM-DD}-{keyword-slug}
    target_keyword TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'drafted', 'user_review', 'confirmed', 'carded', 'rejected'
    )),
    confirmed_by TEXT,
    calendar_card_url TEXT,
    idempotency_key TEXT UNIQUE,               -- seo-content-planner-{brief_id}-card-{attempt}
    attempt INTEGER NOT NULL DEFAULT 0,
    payload TEXT,                              -- JSON per schemas/brief.schema.json
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
-- one calendar card per brief, ever
CREATE UNIQUE INDEX IF NOT EXISTS idx_briefs_one_card ON briefs(calendar_card_url) WHERE calendar_card_url IS NOT NULL;

CREATE TABLE IF NOT EXISTS competitor_fetches (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    brief_id TEXT NOT NULL REFERENCES briefs(id),
    url TEXT NOT NULL,
    outcome TEXT NOT NULL CHECK (outcome IN ('fetched', 'robots_disallowed', 'error', 'injection_flagged')),
    fetched_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (brief_id, url)                     -- 1 fetch per URL per brief
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('brief')),
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
CREATE INDEX IF NOT EXISTS idx_briefs_status ON briefs(status);

-- Briefs waiting on the user for more than 72 hours
CREATE VIEW IF NOT EXISTS v_stale_reviews AS
SELECT id, target_keyword, updated_at,
       ROUND((julianday('now') - julianday(updated_at)) * 24, 1) AS hours_waiting
FROM briefs
WHERE status = 'user_review' AND julianday('now') - julianday(updated_at) > 3;
