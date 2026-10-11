-- PR Review Agent ledger: one row per reviewed head SHA. Never stores diff contents or secrets.
-- Every state change writes a ledger_state_transitions row. That table is the audit trail.

PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS reviews (
    id TEXT PRIMARY KEY,                       -- pr-review-{owner}-{repo}-{pr_number}-{head_sha}
    repo TEXT NOT NULL,                        -- owner/name
    pr_number INTEGER NOT NULL,
    head_sha TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('reviewing', 'commented', 'skipped', 'failed')),
    skip_reason TEXT CHECK (skip_reason IN ('draft', 'bot_author', 'too_large', 'not_allowlisted', 'emergency_stop')),
    changed_lines INTEGER,
    risk_flags INTEGER NOT NULL DEFAULT 0,     -- count of inline annotations
    secret_flags INTEGER NOT NULL DEFAULT 0,   -- count only; never the values
    github_review_id TEXT,
    idempotency_key TEXT UNIQUE,               -- pr-review-{owner}-{repo}-{pr_number}-{head_sha}-post-{attempt}
    attempt INTEGER NOT NULL DEFAULT 0,
    failure_reason TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (repo, pr_number, head_sha)         -- one review per head SHA
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('review')),
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT,                             -- JSON; never diff contents or secrets
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_transitions_at ON ledger_state_transitions(transitioned_at);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);

-- Reviews stuck in progress for more than an hour
CREATE VIEW IF NOT EXISTS v_stuck_reviews AS
SELECT id, repo, pr_number, head_sha, updated_at,
       ROUND((julianday('now') - julianday(updated_at)) * 24, 1) AS hours_stuck
FROM reviews
WHERE status = 'reviewing' AND julianday('now') - julianday(updated_at) > 1.0 / 24;
