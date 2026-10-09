-- ACME Bonsai Contract Coordinator — Contract Ledger
-- SQLite schema. Canonical source of truth for contract lifecycle.

CREATE TABLE IF NOT EXISTS contracts (
    contract_id TEXT PRIMARY KEY,
    buyer_legal_name TEXT NOT NULL,
    buyer_billing_email TEXT NOT NULL,
    buyer_state TEXT,
    total_usd REAL NOT NULL,
    deposit_usd REAL NOT NULL,
    balance_usd REAL NOT NULL,
    deposit_pct REAL NOT NULL DEFAULT 0.5 CHECK (deposit_pct >= 0.5 AND deposit_pct <= 1.0),
    deposit_method TEXT CHECK (deposit_method IN ('stripe', 'ach')),
    delivery_earliest TEXT NOT NULL,
    delivery_latest TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'inquiry' CHECK (status IN (
        'inquiry', 'qualified',
        'contract_sent', 'contract_signed', 'contract_rejected', 'signature_expired',
        'deposit_invoiced', 'deposit_paid', 'deposit_failed',
        'inventory_reserved', 'inventory_short',
        'routed', 'in_transit',
        'delivered', 'delivery_failed',
        'balance_paid', 'closed'
    )),
    ceo_escalated INTEGER NOT NULL DEFAULT 0,
    ceo_escalated_at TEXT,
    cfo_acknowledged INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS contract_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contract_id TEXT NOT NULL REFERENCES contracts(contract_id),
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,
    reason TEXT,
    metadata TEXT, -- JSON blob for additional context
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS contract_line_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contract_id TEXT NOT NULL REFERENCES contracts(contract_id),
    species TEXT NOT NULL,
    size TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_usd REAL NOT NULL CHECK (unit_price_usd >= 0),
    notes TEXT
);

CREATE TABLE IF NOT EXISTS docusign_envelopes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contract_id TEXT NOT NULL REFERENCES contracts(contract_id),
    envelope_id TEXT UNIQUE NOT NULL,
    template_id TEXT NOT NULL,
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'sent', 'delivered', 'completed', 'declined', 'voided', 'expired'
    )),
    sent_at TEXT,
    buyer_signed_at TEXT,
    company_countersigned_at TEXT,
    signed_pdf_url TEXT,
    reminders_sent_json TEXT, -- JSON array of {kind, sent_at}
    error_message TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contract_id TEXT NOT NULL REFERENCES contracts(contract_id),
    kind TEXT NOT NULL CHECK (kind IN ('deposit', 'balance')),
    method TEXT NOT NULL CHECK (method IN ('stripe', 'ach')),
    amount_usd REAL NOT NULL CHECK (amount_usd >= 0),
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'draft', 'sent', 'viewed', 'paid', 'failed', 'refunded', 'voided'
    )),
    stripe_payment_intent_id TEXT,
    stripe_invoice_id TEXT,
    ach_transfer_id TEXT,
    payment_link TEXT,
    due_date TEXT,
    issued_at TEXT,
    paid_at TEXT,
    failed_at TEXT,
    failure_reason TEXT,
    approval_status TEXT,
    cfo_acknowledged INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS inventory_reservations (
    reservation_id TEXT PRIMARY KEY,
    contract_id TEXT NOT NULL REFERENCES contracts(contract_id),
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'reserved', 'partial_reserved', 'short', 'released', 'fulfilled'
    )),
    reserved_at TEXT NOT NULL DEFAULT (datetime('now')),
    hold_until TEXT NOT NULL,
    released_at TEXT,
    release_reason TEXT,
    fulfilled_at TEXT,
    line_items_json TEXT NOT NULL,
    safety_threshold_flags_json TEXT
);

CREATE TABLE IF NOT EXISTS routes (
    route_id TEXT PRIMARY KEY,
    delivery_date TEXT NOT NULL,
    van_id TEXT,
    van_capacity_used_pct REAL,
    departure_time TEXT,
    return_time TEXT,
    total_miles REAL,
    total_drive_minutes INTEGER,
    google_maps_directions_url TEXT,
    status TEXT NOT NULL CHECK (status IN (
        'draft', 'coordinator_review', 'approved', 'emailed_buyers',
        'dispatched', 'completed', 'failed'
    )),
    approved_by TEXT,
    approved_at TEXT,
    idempotency_key TEXT UNIQUE NOT NULL,
    stops_json TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS pick_lists (
    pick_list_id TEXT PRIMARY KEY,
    route_id TEXT NOT NULL REFERENCES routes(route_id),
    loading_date TEXT NOT NULL,
    van_id TEXT,
    items_json TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    reconciled_at TEXT,
    discrepancies_json TEXT
);

CREATE TABLE IF NOT EXISTS delivery_etas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    contract_id TEXT NOT NULL REFERENCES contracts(contract_id),
    route_id TEXT NOT NULL REFERENCES routes(route_id),
    idempotency_key TEXT UNIQUE NOT NULL,
    buyer_email TEXT NOT NULL,
    delivery_window_start TEXT NOT NULL,
    delivery_window_end TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'draft', 'coordinator_review', 'sent', 'delivered', 'bounced', 'buyer_replied'
    )),
    subject_line TEXT,
    body_text TEXT,
    sent_at TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS escalations (
    escalation_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN (
        'contract_over_threshold', 'inventory_short', 'signature_expired',
        'deposit_failed', 'route_change_post_dispatch', 'high_risk_buyer',
        'ledger_anomaly', 'emergency_stop_proposed'
    )),
    contract_id TEXT REFERENCES contracts(contract_id),
    decision_needed TEXT NOT NULL,
    context TEXT,
    recommended_action TEXT,
    options_json TEXT,
    ledger_references_json TEXT,
    status TEXT NOT NULL DEFAULT 'awaiting_decision' CHECK (status IN (
        'awaiting_decision', 'approved', 'rejected', 'deferred', 'timed_out'
    )),
    posted_at TEXT NOT NULL DEFAULT (datetime('now')),
    decided_by TEXT,
    decided_at TEXT,
    decision_notes TEXT
);

CREATE TABLE IF NOT EXISTS incidents (
    incident_id TEXT PRIMARY KEY,
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    type TEXT NOT NULL,
    description TEXT NOT NULL,
    affected_contract_ids TEXT, -- JSON array
    agent_source TEXT,
    error_details TEXT,
    resolution TEXT,
    resolved_by TEXT,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'investigating', 'resolved', 'escalated')),
    detected_at TEXT NOT NULL DEFAULT (datetime('now')),
    resolved_at TEXT
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_contracts_status ON contracts(status);
CREATE INDEX IF NOT EXISTS idx_contracts_buyer_state ON contracts(buyer_state);
CREATE INDEX IF NOT EXISTS idx_contracts_delivery_earliest ON contracts(delivery_earliest);
CREATE INDEX IF NOT EXISTS idx_transitions_contract_id ON contract_state_transitions(contract_id);
CREATE INDEX IF NOT EXISTS idx_envelopes_contract_id ON docusign_envelopes(contract_id);
CREATE INDEX IF NOT EXISTS idx_payments_contract_id ON payments(contract_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_reservations_contract_id ON inventory_reservations(contract_id);
CREATE INDEX IF NOT EXISTS idx_routes_delivery_date ON routes(delivery_date);
CREATE INDEX IF NOT EXISTS idx_etas_contract_id ON delivery_etas(contract_id);
CREATE INDEX IF NOT EXISTS idx_escalations_status ON escalations(status);
CREATE INDEX IF NOT EXISTS idx_incidents_status ON incidents(status);
CREATE INDEX IF NOT EXISTS idx_incidents_severity ON incidents(severity);
