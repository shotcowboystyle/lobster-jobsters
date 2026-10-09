-- ACME Bonsai Customer Service Manager Team (Poppy) — Care Workflow Ledger
-- SQLite schema. Tracks workflow state for tickets, order issues,
-- care consultations, health check-ins, customer feedback, refunds/credits,
-- and escalations.
--
-- Customer records read from Director of Sales' sales ledger.
-- Order data read from COO + Contract Coordinator ledgers.
-- This ledger holds customer service workflow + outcomes.

CREATE TABLE IF NOT EXISTS customer_tickets (
    ticket_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    channel TEXT NOT NULL CHECK (channel IN (
        'email', 'sms', 'chat', 'phone',
        'social_media', 'in_person', 'internal_referral'
    )),
    received_at TEXT NOT NULL DEFAULT (datetime('now')),
    summary TEXT NOT NULL,
    category TEXT,
    subcategory_tags_json TEXT,
    severity TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    owner TEXT CHECK (owner IN ('pearl', 'oakley', 'maple', 'poppy')),
    linked_order_issue_id TEXT,
    linked_consult_id TEXT,
    linked_refund_id TEXT,
    linked_escalation_id TEXT,
    first_response_json TEXT,
    status_updates_json TEXT,
    resolution_json TEXT,
    legal_trigger_detected INTEGER NOT NULL DEFAULT 0,
    contact_count INTEGER NOT NULL DEFAULT 1,
    status TEXT NOT NULL DEFAULT 'received' CHECK (status IN (
        'received', 'triaged', 'assigned', 'in_progress',
        'resolved', 'escalated', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS order_issues (
    order_issue_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES customer_tickets(ticket_id),
    customer_id TEXT NOT NULL,
    kind TEXT NOT NULL,
    reported_at TEXT NOT NULL DEFAULT (datetime('now')),
    linked_order_reference_json TEXT,
    investigation_summary TEXT,
    proposed_resolution_json TEXT,
    customer_acceptance_json TEXT,
    approval_path TEXT CHECK (approval_path IN (
        'oakley_only', 'poppy_only', 'poppy_plus_ceo'
    )),
    execution_json TEXT,
    status TEXT NOT NULL DEFAULT 'reported' CHECK (status IN (
        'reported', 'investigating', 'resolution_proposed',
        'customer_review', 'resolved', 'escalated', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS care_consultations (
    consult_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES customer_tickets(ticket_id),
    customer_id TEXT NOT NULL,
    tree_id TEXT,
    species TEXT NOT NULL,
    purchased_at TEXT,
    environment_json TEXT,
    symptoms_json TEXT,
    photos_json TEXT,
    timeline TEXT,
    diagnosis_json TEXT,
    prescription_json TEXT,
    care_guide_references_json TEXT,
    follow_up_date TEXT,
    follow_ups_json TEXT,
    outcome_json TEXT,
    species_pattern_flag INTEGER NOT NULL DEFAULT 0,
    linked_inventory_alert TEXT,
    requested_at TEXT NOT NULL DEFAULT (datetime('now')),
    status TEXT NOT NULL DEFAULT 'requested' CHECK (status IN (
        'requested', 'diagnosing', 'guidance_provided',
        'follow_up_scheduled', 'confirmed_healthy', 'tree_lost',
        'escalated', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS health_check_ins (
    checkin_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    kind TEXT NOT NULL CHECK (kind IN (
        'post_delivery', 'post_workshop', 'post_care_consult',
        'subscription_satisfaction', 'wholesale_relationship',
        'at_risk_intervention', 'renewal_window', 'csat_dip', 'activity_drop'
    )),
    trigger_json TEXT,
    scheduled_for TEXT NOT NULL,
    outreach_channel TEXT CHECK (outreach_channel IN (
        'email', 'sms', 'phone', 'in_person'
    )),
    execution_json TEXT,
    customer_response_json TEXT,
    no_response_attempts INTEGER NOT NULL DEFAULT 0,
    outcome_json TEXT,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN (
        'scheduled', 'executed', 'response_received',
        'no_response', 're_attempt', 'escalated', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS customer_feedback (
    feedback_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    linked_ticket_id TEXT,
    linked_consult_id TEXT,
    kind TEXT NOT NULL,
    summary TEXT NOT NULL,
    verbatim_quote TEXT,
    routed_to_json TEXT,
    routing_idempotency_key TEXT,
    received_at TEXT NOT NULL DEFAULT (datetime('now')),
    captured_by TEXT,
    consent_to_publish_json TEXT,
    sentiment TEXT CHECK (sentiment IN (
        'very_positive', 'positive', 'neutral', 'negative', 'very_negative'
    )),
    status TEXT NOT NULL DEFAULT 'captured' CHECK (status IN (
        'captured', 'routed', 'acknowledged', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS refunds_credits (
    refund_id TEXT PRIMARY KEY,
    ticket_id TEXT NOT NULL REFERENCES customer_tickets(ticket_id),
    order_issue_id TEXT,
    customer_id TEXT NOT NULL,
    kind TEXT NOT NULL CHECK (kind IN (
        'refund_partial', 'refund_full', 'store_credit', 'fee_waiver'
    )),
    amount_usd REAL NOT NULL,
    rationale TEXT NOT NULL,
    approval_path TEXT NOT NULL CHECK (approval_path IN (
        'poppy_only', 'poppy_plus_ceo'
    )),
    company_responsibility TEXT,
    linked_stripe_payment_intent_id TEXT,
    stripe_refund_id TEXT,
    approval_json TEXT,
    execution_json TEXT,
    cfo_notification_json TEXT,
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    status TEXT NOT NULL DEFAULT 'proposed' CHECK (status IN (
        'proposed', 'csm_approved', 'ceo_approval_required',
        'ceo_approved', 'rejected', 'processed', 'archived'
    )),
    rejected_reason TEXT
);

CREATE TABLE IF NOT EXISTS escalation_cards (
    escalation_id TEXT PRIMARY KEY,
    linked_ticket_id TEXT,
    linked_consult_id TEXT,
    linked_order_issue_id TEXT,
    linked_refund_id TEXT,
    customer_id TEXT,
    kind TEXT NOT NULL,
    decision_needed TEXT NOT NULL,
    options_json TEXT,
    context TEXT,
    recommended_action TEXT,
    routed_to_json TEXT,
    ledger_references_json TEXT,
    opened_at TEXT NOT NULL DEFAULT (datetime('now')),
    decided_by TEXT,
    decided_at TEXT,
    decision_notes TEXT,
    corrective_action TEXT,
    customer_communicated_at TEXT,
    status TEXT NOT NULL DEFAULT 'opened' CHECK (status IN (
        'opened', 'routed', 'acknowledged', 'resolved', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS care_actions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_kind TEXT NOT NULL CHECK (action_kind IN (
        'first_response', 'status_update', 'refund_process',
        'replacement_dispatch', 'care_followup', 'health_checkin',
        'feedback_routing'
    )),
    related_id TEXT NOT NULL,
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'sent', 'failed', 'cancelled')),
    attempt INTEGER NOT NULL DEFAULT 1,
    channel TEXT,
    failure_reason TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    completed_at TEXT
);

CREATE TABLE IF NOT EXISTS ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL CHECK (entity_type IN (
        'customer_ticket', 'order_issue', 'care_consultation',
        'health_check_in', 'customer_feedback', 'refund_credit',
        'escalation_card', 'care_action'
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
CREATE INDEX IF NOT EXISTS idx_ticket_status ON customer_tickets(status);
CREATE INDEX IF NOT EXISTS idx_ticket_customer ON customer_tickets(customer_id);
CREATE INDEX IF NOT EXISTS idx_ticket_category ON customer_tickets(category);
CREATE INDEX IF NOT EXISTS idx_ticket_owner ON customer_tickets(owner);
CREATE INDEX IF NOT EXISTS idx_ticket_received ON customer_tickets(received_at);
CREATE INDEX IF NOT EXISTS idx_order_issue_status ON order_issues(status);
CREATE INDEX IF NOT EXISTS idx_order_issue_kind ON order_issues(kind);
CREATE INDEX IF NOT EXISTS idx_consult_status ON care_consultations(status);
CREATE INDEX IF NOT EXISTS idx_consult_species ON care_consultations(species);
CREATE INDEX IF NOT EXISTS idx_consult_pattern ON care_consultations(species_pattern_flag);
CREATE INDEX IF NOT EXISTS idx_checkin_status ON health_check_ins(status);
CREATE INDEX IF NOT EXISTS idx_checkin_scheduled ON health_check_ins(scheduled_for);
CREATE INDEX IF NOT EXISTS idx_feedback_kind ON customer_feedback(kind);
CREATE INDEX IF NOT EXISTS idx_feedback_sentiment ON customer_feedback(sentiment);
CREATE INDEX IF NOT EXISTS idx_refund_status ON refunds_credits(status);
CREATE INDEX IF NOT EXISTS idx_refund_amount ON refunds_credits(amount_usd);
CREATE INDEX IF NOT EXISTS idx_escalation_status ON escalation_cards(status);
CREATE INDEX IF NOT EXISTS idx_escalation_kind ON escalation_cards(kind);
CREATE INDEX IF NOT EXISTS idx_actions_idempotency ON care_actions(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
