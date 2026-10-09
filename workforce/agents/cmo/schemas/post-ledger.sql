-- ACME Bonsai Social Media Post Ledger
-- SQLite schema for tracking post lifecycle, approvals, and engagement

CREATE TABLE IF NOT EXISTS posts (
    post_id TEXT PRIMARY KEY,
    campaign_id TEXT,
    calendar_id TEXT,
    platform TEXT NOT NULL CHECK (platform IN ('instagram', 'facebook')),
    vertical TEXT NOT NULL CHECK (vertical IN ('wholesale', 'local', 'display', 'events')),
    scheduled_date TEXT NOT NULL,
    caption_text TEXT,
    hashtags TEXT, -- JSON array
    status TEXT NOT NULL DEFAULT 'planned' CHECK (status IN (
        'planned', 'drafted', 'qa_reviewing', 'qa_passed', 'qa_failed',
        'awaiting_approval', 'approved', 'rejected', 'held',
        'scheduled', 'publishing', 'published', 'publish_failed',
        'monitoring', 'archived'
    )),
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS post_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id TEXT NOT NULL REFERENCES posts(post_id),
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT, -- JSON blob for additional context
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS qa_reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id TEXT NOT NULL REFERENCES posts(post_id),
    qa_status TEXT NOT NULL CHECK (qa_status IN ('pass', 'pass_with_flags', 'fail')),
    brand_voice TEXT,
    vertical_alignment TEXT,
    factual_accuracy TEXT,
    prohibited_patterns TEXT, -- JSON array
    high_risk_flags TEXT, -- JSON array
    notes TEXT,
    revision_instructions TEXT,
    reviewed_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS approvals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id TEXT NOT NULL REFERENCES posts(post_id),
    approval_status TEXT NOT NULL CHECK (approval_status IN (
        'awaiting_approval', 'approved', 'rejected', 'held', 'edited'
    )),
    approved_by TEXT,
    notes TEXT,
    posted_to_discord_at TEXT,
    decided_at TEXT,
    timeout_reminder_sent INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS publish_jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id TEXT NOT NULL REFERENCES posts(post_id),
    platform TEXT NOT NULL,
    idempotency_key TEXT UNIQUE NOT NULL,
    publish_status TEXT NOT NULL CHECK (publish_status IN (
        'pending', 'publishing', 'published', 'publish_failed',
        'skipped_duplicate', 'blocked_emergency_stop'
    )),
    attempt INTEGER NOT NULL DEFAULT 1,
    platform_post_id TEXT,
    platform_container_id TEXT,
    scheduled_publish_time TEXT,
    error_message TEXT,
    error_code TEXT,
    published_at TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS engagement_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id TEXT NOT NULL REFERENCES posts(post_id),
    platform TEXT NOT NULL,
    platform_post_id TEXT,
    likes INTEGER DEFAULT 0,
    comments INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0,
    shares INTEGER DEFAULT 0,
    reach INTEGER DEFAULT 0,
    impressions INTEGER DEFAULT 0,
    engagement_rate REAL,
    measured_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS engagement_alerts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    alert_id TEXT UNIQUE NOT NULL,
    post_id TEXT NOT NULL REFERENCES posts(post_id),
    platform TEXT NOT NULL,
    alert_type TEXT NOT NULL CHECK (alert_type IN ('comment', 'dm', 'mention', 'reaction_spike')),
    classification TEXT NOT NULL CHECK (classification IN ('routine', 'actionable', 'negative', 'spam', 'crisis')),
    commenter_handle TEXT,
    comment_text TEXT,
    comment_id TEXT,
    suggested_action TEXT,
    detected_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS reply_drafts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    reply_id TEXT UNIQUE NOT NULL,
    alert_id TEXT REFERENCES engagement_alerts(alert_id),
    post_id TEXT NOT NULL REFERENCES posts(post_id),
    platform TEXT NOT NULL,
    commenter_handle TEXT,
    original_comment TEXT,
    drafted_reply TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN ('drafted', 'approved', 'posted', 'skipped')),
    approved_by TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    decided_at TEXT
);

CREATE TABLE IF NOT EXISTS incidents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    incident_id TEXT UNIQUE NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    type TEXT NOT NULL,
    description TEXT NOT NULL,
    affected_post_ids TEXT, -- JSON array
    agent_source TEXT,
    error_details TEXT,
    resolution TEXT,
    resolved_by TEXT,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'investigating', 'resolved', 'escalated')),
    detected_at TEXT NOT NULL DEFAULT (datetime('now')),
    resolved_at TEXT
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_posts_status ON posts(status);
CREATE INDEX IF NOT EXISTS idx_posts_platform ON posts(platform);
CREATE INDEX IF NOT EXISTS idx_posts_vertical ON posts(vertical);
CREATE INDEX IF NOT EXISTS idx_posts_scheduled_date ON posts(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_transitions_post_id ON post_state_transitions(post_id);
CREATE INDEX IF NOT EXISTS idx_publish_jobs_idempotency ON publish_jobs(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_publish_jobs_post_id ON publish_jobs(post_id);
CREATE INDEX IF NOT EXISTS idx_engagement_post_id ON engagement_metrics(post_id);
CREATE INDEX IF NOT EXISTS idx_alerts_post_id ON engagement_alerts(post_id);
CREATE INDEX IF NOT EXISTS idx_alerts_classification ON engagement_alerts(classification);
CREATE INDEX IF NOT EXISTS idx_incidents_status ON incidents(status);
CREATE INDEX IF NOT EXISTS idx_incidents_severity ON incidents(severity);
