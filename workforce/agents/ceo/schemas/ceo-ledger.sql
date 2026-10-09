-- ACME Bonsai CEO Team (Apex) — CEO Ledger
-- SQLite schema. Canonical source of truth for strategic questions,
-- decision entries, strategic memos, and external communications.

CREATE TABLE IF NOT EXISTS strategic_questions (
    question_id TEXT PRIMARY KEY,
    headline TEXT NOT NULL,
    trade_off_json TEXT NOT NULL,
    context TEXT,
    source_signals_json TEXT NOT NULL,
    what_would_change_my_mind TEXT,
    status TEXT NOT NULL DEFAULT 'queued' CHECK (status IN (
        'queued', 'researching', 'drafted', 'ceo_review',
        'answered', 'deferred', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    answered_at TEXT,
    answer_text TEXT,
    answer_reasoning TEXT,
    linked_decision_id TEXT
);

CREATE TABLE IF NOT EXISTS decision_entries (
    decision_id TEXT PRIMARY KEY,
    headline TEXT NOT NULL,
    decided_at TEXT NOT NULL,
    decided_by TEXT NOT NULL DEFAULT 'Jane',
    reversibility TEXT NOT NULL CHECK (reversibility IN (
        'reversible', 'hard_to_reverse', 'irreversible'
    )),
    horizon TEXT CHECK (horizon IN ('today', 'this_quarter', 'this_year', 'multi_year')),
    alternatives_considered_json TEXT NOT NULL,
    choice_made TEXT NOT NULL,
    rationale TEXT NOT NULL,
    what_would_change_my_mind TEXT,
    expected_outcome TEXT,
    outcome_window_end TEXT,
    linked_question_id TEXT,
    linked_initiative_id TEXT,
    linked_memo_id TEXT,
    linked_comm_id TEXT,
    source_teams_json TEXT,
    status TEXT NOT NULL DEFAULT 'captured' CHECK (status IN (
        'captured', 'outcome_window_open', 'outcome_captured',
        'outcome_inconclusive', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS outcome_captures (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    decision_id TEXT NOT NULL REFERENCES decision_entries(decision_id),
    captured_at TEXT NOT NULL DEFAULT (datetime('now')),
    outcome_text TEXT NOT NULL,
    outcome_vs_expected TEXT NOT NULL CHECK (outcome_vs_expected IN (
        'better', 'as_expected', 'worse', 'different_axis', 'inconclusive'
    )),
    reflection_note TEXT,
    would_decide_again TEXT CHECK (would_decide_again IN ('same', 'different', 'unsure')),
    supporting_references_json TEXT
);

CREATE TABLE IF NOT EXISTS strategic_memos (
    memo_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN (
        'investor_update', 'all_hands_letter', 'strategic_positioning',
        'board_material', 'press_statement', 'internal_announcement', 'adhoc'
    )),
    headline TEXT NOT NULL,
    audience TEXT NOT NULL,
    body_markdown TEXT,
    word_count INTEGER NOT NULL DEFAULT 0,
    soft_cap INTEGER NOT NULL DEFAULT 1500,
    supporting_references_json TEXT,
    linked_decision_id TEXT,
    linked_question_id TEXT,
    status TEXT NOT NULL DEFAULT 'requested' CHECK (status IN (
        'requested', 'drafting', 'ceo_review', 'revising',
        'approved', 'delivered', 'rejected', 'archived'
    )),
    requested_at TEXT NOT NULL DEFAULT (datetime('now')),
    requested_by TEXT NOT NULL DEFAULT 'Jane',
    drafted_at TEXT,
    approved_at TEXT,
    delivered_at TEXT,
    delivery_channel TEXT,
    revision_history_json TEXT
);

CREATE TABLE IF NOT EXISTS external_comms (
    comm_id TEXT PRIMARY KEY,
    stakeholder_kind TEXT NOT NULL CHECK (stakeholder_kind IN (
        'investor', 'advisor', 'bank', 'key_partner',
        'press', 'regulator', 'vendor_strategic', 'other'
    )),
    recipient_name TEXT NOT NULL,
    recipient_email TEXT NOT NULL,
    recipient_organization TEXT,
    stakeholder_record_id TEXT,
    channel TEXT NOT NULL CHECK (channel IN ('email', 'letter', 'phone_call_note', 'in_person_note')),
    subject TEXT,
    body_text TEXT,
    body_html TEXT,
    linked_memo_id TEXT,
    linked_decision_id TEXT,
    prior_comm_history_json TEXT,
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'queued' CHECK (status IN (
        'queued', 'drafting', 'ceo_review', 'revising',
        'approved', 'sent', 'acknowledged', 'rejected', 'failed', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    approved_at TEXT,
    sent_at TEXT,
    acknowledged_at TEXT,
    failure_reason TEXT,
    provider_message_id TEXT
);

CREATE TABLE IF NOT EXISTS stakeholder_records (
    stakeholder_record_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN (
        'investor', 'advisor', 'bank', 'key_partner',
        'press', 'regulator', 'vendor_strategic', 'other'
    )),
    name TEXT NOT NULL,
    organization TEXT,
    email TEXT NOT NULL,
    phone TEXT,
    relationship_summary TEXT,
    communication_cadence TEXT,
    last_contact_at TEXT,
    last_comm_id TEXT,
    added_at TEXT NOT NULL DEFAULT (datetime('now')),
    added_by TEXT NOT NULL DEFAULT 'Jane',
    notes TEXT,
    do_not_contact INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN (
        'strategic_question', 'decision_entry', 'strategic_memo',
        'external_comm', 'stakeholder_record'
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
CREATE INDEX IF NOT EXISTS idx_questions_status ON strategic_questions(status);
CREATE INDEX IF NOT EXISTS idx_decisions_status ON decision_entries(status);
CREATE INDEX IF NOT EXISTS idx_decisions_outcome_window ON decision_entries(outcome_window_end);
CREATE INDEX IF NOT EXISTS idx_decisions_reversibility ON decision_entries(reversibility);
CREATE INDEX IF NOT EXISTS idx_memos_status ON strategic_memos(status);
CREATE INDEX IF NOT EXISTS idx_memos_kind ON strategic_memos(kind);
CREATE INDEX IF NOT EXISTS idx_comms_status ON external_comms(status);
CREATE INDEX IF NOT EXISTS idx_comms_stakeholder_kind ON external_comms(stakeholder_kind);
CREATE INDEX IF NOT EXISTS idx_comms_idempotency ON external_comms(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_stakeholders_kind ON stakeholder_records(kind);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
