-- ACME Bonsai COO Team (Victor) — Ops Workflow Ledger
-- SQLite schema. Tracks workflow state for inventory items, snapshots,
-- delivery jobs, rental jobs, workshop events + registrations, facility
-- incidents, environmental readings, and ops actions.
--
-- The inventory sheet (Google Sheets) is the canonical source of truth
-- for tree counts. This ledger holds workflow state for everything else.

CREATE TABLE IF NOT EXISTS inventory_items (
    tree_id TEXT PRIMARY KEY,
    species TEXT NOT NULL,
    size TEXT NOT NULL,
    location TEXT NOT NULL,
    health_grade TEXT NOT NULL CHECK (health_grade IN ('A', 'B', 'C', 'quarantine')),
    status TEXT NOT NULL DEFAULT 'received' CHECK (status IN (
        'received', 'quarantined', 'healthy', 'sick', 'reserved',
        'allocated', 'fulfilled', 'lost', 'archived'
    )),
    safety_threshold INTEGER DEFAULT 0,
    reserved_for_json TEXT,
    received_at TEXT NOT NULL DEFAULT (datetime('now')),
    quarantine_end_at TEXT,
    last_health_check_at TEXT,
    health_notes TEXT,
    treatment_log_json TEXT,
    fulfilled_at TEXT,
    lost_at TEXT,
    lost_reason TEXT
);

CREATE TABLE IF NOT EXISTS inventory_snapshots (
    snapshot_id TEXT PRIMARY KEY,
    as_of TEXT NOT NULL,
    totals_json TEXT NOT NULL,
    by_species_size_json TEXT NOT NULL,
    health_distribution_json TEXT NOT NULL,
    mortality_trailing_30d_json TEXT NOT NULL,
    alerts_json TEXT,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'coo_review', 'published', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS delivery_jobs (
    delivery_id TEXT PRIMARY KEY,
    kind TEXT CHECK (kind IN ('wholesale', 'subscription_install', 'retail', 'marketing', 'internal')),
    linked_ref_type TEXT,
    linked_ref_id TEXT,
    customer_json TEXT NOT NULL,
    tree_ids_json TEXT NOT NULL,
    scheduled_window_start TEXT NOT NULL,
    scheduled_window_end TEXT NOT NULL,
    address_json TEXT NOT NULL,
    route_id TEXT,
    driver TEXT,
    van_id TEXT,
    confirmation_json TEXT,
    pod_json TEXT,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN (
        'scheduled', 'confirmed', 'loaded', 'in_transit', 'delivered',
        'pod_captured', 'closed', 'rescheduled', 'failed'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    delivered_at TEXT,
    failure_reason TEXT
);

CREATE TABLE IF NOT EXISTS rental_jobs (
    rental_id TEXT PRIMARY KEY,
    customer_json TEXT NOT NULL,
    tree_ids_json TEXT NOT NULL,
    event_window_start TEXT NOT NULL,
    event_window_end TEXT NOT NULL,
    outbound_window_start TEXT,
    outbound_window_end TEXT,
    return_window_start TEXT,
    return_window_end TEXT,
    venue_address_json TEXT,
    deposit_usd REAL NOT NULL,
    rental_fee_usd REAL,
    rental_agreement_url TEXT,
    before_photos_json TEXT,
    after_photos_json TEXT,
    damage_assessment_json TEXT,
    pickup_notice_json TEXT,
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN (
        'scheduled', 'outbound', 'at_event', 'return_pickup',
        'inspected', 'closed', 'damaged', 'disputed', 'resolved'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    closed_at TEXT
);

CREATE TABLE IF NOT EXISTS workshop_events (
    workshop_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    kind TEXT CHECK (kind IN ('intro', 'intermediate', 'advanced', 'specialty', 'field_trip')),
    scheduled_at TEXT NOT NULL,
    duration_minutes INTEGER,
    location TEXT,
    instructor_json TEXT NOT NULL,
    capacity_min INTEGER NOT NULL DEFAULT 4,
    capacity_max INTEGER NOT NULL DEFAULT 12,
    price_usd REAL,
    materials_checklist_json TEXT,
    demo_tree_ids_json TEXT,
    registrations_count INTEGER NOT NULL DEFAULT 0,
    attended_count INTEGER NOT NULL DEFAULT 0,
    no_show_count INTEGER NOT NULL DEFAULT 0,
    satisfaction_score REAL,
    status TEXT NOT NULL DEFAULT 'proposed' CHECK (status IN (
        'proposed', 'calendar', 'registration_open', 'confirmed',
        'in_session', 'debrief', 'closed', 'cancelled'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    closed_at TEXT,
    cancellation_reason TEXT
);

CREATE TABLE IF NOT EXISTS workshop_registrations (
    registration_id TEXT PRIMARY KEY,
    workshop_id TEXT NOT NULL REFERENCES workshop_events(workshop_id),
    attendee_json TEXT NOT NULL,
    registered_at TEXT NOT NULL DEFAULT (datetime('now')),
    payment_status TEXT NOT NULL DEFAULT 'unpaid' CHECK (payment_status IN (
        'unpaid', 'paid', 'refunded', 'comped'
    )),
    amount_paid_usd REAL,
    reminders_sent_json TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN (
        'pending', 'confirmed', 'attended', 'no_show',
        'cancelled', 'followed_up'
    )),
    follow_up_json TEXT
);

CREATE TABLE IF NOT EXISTS facility_incidents (
    incident_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL,
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    description TEXT NOT NULL,
    detected_at TEXT NOT NULL DEFAULT (datetime('now')),
    detected_by TEXT,
    affected_zone TEXT,
    affected_tree_ids_json TEXT,
    estimated_cost_usd REAL,
    ceo_approval_required INTEGER NOT NULL DEFAULT 0,
    vendor_required INTEGER NOT NULL DEFAULT 0,
    owner TEXT NOT NULL DEFAULT 'birch',
    mitigation_plan TEXT,
    root_cause TEXT,
    corrective_action TEXT,
    preventive_action TEXT,
    status TEXT NOT NULL DEFAULT 'detected' CHECK (status IN (
        'detected', 'triaged', 'in_progress', 'resolved',
        'escalated', 'archived'
    )),
    resolved_at TEXT,
    linked_environmental_readings_json TEXT
);

CREATE TABLE IF NOT EXISTS environmental_readings (
    reading_id TEXT PRIMARY KEY,
    device_id TEXT NOT NULL,
    zone TEXT NOT NULL,
    measured_at TEXT NOT NULL,
    metrics_json TEXT NOT NULL,
    optimal_range_json TEXT,
    in_range INTEGER NOT NULL,
    off_range_metrics_json TEXT,
    consecutive_off_range_hours REAL DEFAULT 0,
    alert_raised INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS ops_actions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_kind TEXT NOT NULL CHECK (action_kind IN (
        'delivery_confirmation', 'workshop_reminder', 'rental_pickup_notice', 'damage_assessment'
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
        'inventory_item', 'inventory_snapshot', 'delivery_job', 'rental_job',
        'workshop_event', 'workshop_registration', 'facility_incident',
        'environmental_reading', 'ops_action'
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
CREATE INDEX IF NOT EXISTS idx_inventory_status ON inventory_items(status);
CREATE INDEX IF NOT EXISTS idx_inventory_species_size ON inventory_items(species, size);
CREATE INDEX IF NOT EXISTS idx_inventory_health ON inventory_items(health_grade);
CREATE INDEX IF NOT EXISTS idx_snapshot_as_of ON inventory_snapshots(as_of);
CREATE INDEX IF NOT EXISTS idx_delivery_status ON delivery_jobs(status);
CREATE INDEX IF NOT EXISTS idx_delivery_window ON delivery_jobs(scheduled_window_start);
CREATE INDEX IF NOT EXISTS idx_rental_status ON rental_jobs(status);
CREATE INDEX IF NOT EXISTS idx_rental_event_window ON rental_jobs(event_window_start);
CREATE INDEX IF NOT EXISTS idx_workshop_status ON workshop_events(status);
CREATE INDEX IF NOT EXISTS idx_workshop_scheduled ON workshop_events(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_registration_workshop ON workshop_registrations(workshop_id);
CREATE INDEX IF NOT EXISTS idx_registration_status ON workshop_registrations(status);
CREATE INDEX IF NOT EXISTS idx_incident_status ON facility_incidents(status);
CREATE INDEX IF NOT EXISTS idx_incident_severity ON facility_incidents(severity);
CREATE INDEX IF NOT EXISTS idx_env_zone ON environmental_readings(zone);
CREATE INDEX IF NOT EXISTS idx_env_measured ON environmental_readings(measured_at);
CREATE INDEX IF NOT EXISTS idx_actions_idempotency ON ops_actions(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
