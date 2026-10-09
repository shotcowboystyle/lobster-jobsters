-- ACME Bonsai Director of Sales Team (Cash) — Sales Ledger / CRM
-- SQLite schema. Tracks leads, opportunities, quotes, closed deals,
-- subscription contracts, event bookings, local sales, customer accounts,
-- and outbound sales actions.

CREATE TABLE IF NOT EXISTS customer_accounts (
    customer_id TEXT PRIMARY KEY,
    kind TEXT NOT NULL CHECK (kind IN (
        'individual', 'business', 'hospitality', 'venue',
        'designer', 'event_planner', 'other'
    )),
    name TEXT NOT NULL,
    organization TEXT,
    primary_email TEXT NOT NULL,
    primary_phone TEXT,
    billing_address_json TEXT,
    shipping_address_json TEXT,
    primary_stream TEXT NOT NULL CHECK (primary_stream IN (
        'wholesale', 'local', 'subscription', 'event_rental'
    )),
    active_streams_json TEXT,
    owner TEXT NOT NULL CHECK (owner IN ('wade', 'lily', 'sophia', 'max', 'cash')),
    preferences_json TEXT,
    ltv_estimate_usd REAL DEFAULT 0,
    first_purchase_at TEXT,
    last_purchase_at TEXT,
    total_lifetime_spend_usd REAL DEFAULT 0,
    purchase_count INTEGER DEFAULT 0,
    satisfaction_signals_json TEXT,
    tags_json TEXT,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS leads (
    lead_id TEXT PRIMARY KEY,
    stream TEXT NOT NULL CHECK (stream IN (
        'wholesale', 'local', 'subscription', 'event_rental'
    )),
    source TEXT NOT NULL CHECK (source IN (
        'website_form', 'phone', 'email', 'walk_in', 'referral',
        'marketing_campaign', 'trade_show', 'social_media', 'other'
    )),
    marketing_campaign_id TEXT,
    contact_json TEXT NOT NULL,
    inquiry_summary TEXT,
    estimated_value_usd REAL,
    received_at TEXT NOT NULL DEFAULT (datetime('now')),
    qualified_at TEXT,
    qualified_by TEXT,
    qualification_notes TEXT,
    disqualified_reason TEXT,
    linked_opportunity_id TEXT,
    linked_customer_id TEXT,
    status TEXT NOT NULL DEFAULT 'received' CHECK (status IN (
        'received', 'qualified', 'opportunity_created', 'disqualified', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS opportunities (
    opportunity_id TEXT PRIMARY KEY,
    stream TEXT NOT NULL CHECK (stream IN (
        'wholesale', 'local', 'subscription', 'event_rental'
    )),
    linked_lead_id TEXT REFERENCES leads(lead_id),
    customer_id TEXT NOT NULL REFERENCES customer_accounts(customer_id),
    stage TEXT NOT NULL CHECK (stage IN (
        'discovery', 'proposal', 'negotiation', 'committed'
    )),
    stage_probability_json TEXT,
    probability_pct REAL,
    estimated_value_usd REAL,
    weighted_value_usd REAL,
    expected_close_date TEXT,
    owner TEXT NOT NULL CHECK (owner IN ('wade', 'lily', 'sophia', 'max', 'cash')),
    linked_quote_id TEXT,
    next_action_json TEXT,
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    stage_history_json TEXT,
    status TEXT NOT NULL DEFAULT 'discovery' CHECK (status IN (
        'discovery', 'proposal', 'negotiation', 'committed',
        'won', 'lost', 'archived'
    )),
    won_at TEXT,
    lost_at TEXT,
    lost_reason TEXT,
    linked_deal_id TEXT
);

CREATE TABLE IF NOT EXISTS quotes (
    quote_id TEXT PRIMARY KEY,
    stream TEXT NOT NULL,
    linked_opportunity_id TEXT REFERENCES opportunities(opportunity_id),
    customer_id TEXT NOT NULL REFERENCES customer_accounts(customer_id),
    line_items_json TEXT NOT NULL,
    subtotal_usd REAL NOT NULL,
    discount_pct REAL DEFAULT 0,
    discount_usd REAL DEFAULT 0,
    total_usd REAL NOT NULL,
    approval_path TEXT NOT NULL CHECK (approval_path IN (
        'cash_only', 'cash_volume', 'cash_plus_ceo_plus_margin'
    )),
    strategic_rationale TEXT,
    payment_terms TEXT,
    valid_until TEXT,
    delivery_window_json TEXT,
    inventory_confirmation_json TEXT,
    margin_floor_check_json TEXT,
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    sent_at TEXT,
    viewed_at TEXT,
    accepted_at TEXT,
    rejected_at TEXT,
    expired_at TEXT,
    idempotency_key TEXT UNIQUE NOT NULL,
    status TEXT NOT NULL DEFAULT 'drafted' CHECK (status IN (
        'drafted', 'cash_review', 'sent', 'viewed',
        'accepted', 'rejected', 'expired', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS closed_deals (
    deal_id TEXT PRIMARY KEY,
    stream TEXT NOT NULL,
    linked_opportunity_id TEXT REFERENCES opportunities(opportunity_id),
    linked_quote_id TEXT REFERENCES quotes(quote_id),
    customer_id TEXT NOT NULL REFERENCES customer_accounts(customer_id),
    outcome TEXT NOT NULL CHECK (outcome IN ('won', 'lost')),
    total_usd REAL NOT NULL,
    expected_total_usd REAL,
    won_factors_json TEXT,
    lost_factors_json TEXT,
    lost_competitor TEXT,
    closed_at TEXT NOT NULL DEFAULT (datetime('now')),
    closed_by TEXT,
    downstream_handoff_json TEXT
);

CREATE TABLE IF NOT EXISTS subscription_contracts (
    subscription_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL REFERENCES customer_accounts(customer_id),
    linked_opportunity_id TEXT REFERENCES opportunities(opportunity_id),
    linked_quote_id TEXT REFERENCES quotes(quote_id),
    site_visit_json TEXT,
    tree_plan_json TEXT NOT NULL,
    term_months INTEGER NOT NULL DEFAULT 12,
    monthly_fee_usd REAL NOT NULL,
    deposit_usd REAL NOT NULL,
    service_tier TEXT CHECK (service_tier IN (
        'essentials', 'professional', 'premium', 'custom'
    )),
    service_includes_json TEXT,
    start_date TEXT,
    renewal_date TEXT,
    billing_setup_json TEXT,
    renewal_history_json TEXT,
    churn_risk_signals_json TEXT,
    status TEXT NOT NULL DEFAULT 'prospect' CHECK (status IN (
        'prospect', 'site_visit', 'proposed', 'signed',
        'active', 'renewing', 'renewed', 'churned', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    signed_at TEXT,
    churned_at TEXT,
    churn_reason TEXT
);

CREATE TABLE IF NOT EXISTS event_bookings (
    booking_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL REFERENCES customer_accounts(customer_id),
    linked_opportunity_id TEXT REFERENCES opportunities(opportunity_id),
    linked_quote_id TEXT REFERENCES quotes(quote_id),
    event_kind TEXT CHECK (event_kind IN (
        'wedding', 'corporate', 'private_party',
        'trade_show', 'photo_shoot', 'other'
    )),
    event_date TEXT NOT NULL,
    event_window_start TEXT,
    event_window_end TEXT,
    venue_json TEXT,
    trees_requested_json TEXT NOT NULL,
    rental_fee_usd REAL NOT NULL,
    deposit_usd REAL NOT NULL,
    damage_policy TEXT,
    rental_agreement_url TEXT,
    rental_agreement_signed_at TEXT,
    linked_rental_job_id TEXT,
    idempotency_key TEXT UNIQUE,
    status TEXT NOT NULL DEFAULT 'inquiry' CHECK (status IN (
        'inquiry', 'quoted', 'deposit_paid', 'confirmed',
        'in_progress', 'returned', 'closed', 'cancelled', 'archived'
    )),
    drafted_at TEXT NOT NULL DEFAULT (datetime('now')),
    closed_at TEXT,
    cancellation_reason TEXT
);

CREATE TABLE IF NOT EXISTS local_sales (
    local_sale_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL REFERENCES customer_accounts(customer_id),
    linked_lead_id TEXT REFERENCES leads(lead_id),
    interaction_at TEXT NOT NULL,
    interaction_kind TEXT CHECK (interaction_kind IN (
        'walk_in', 'scheduled_visit', 'remote_consult'
    )),
    consult_topics_json TEXT,
    trees_recommended_json TEXT,
    purchased_tree_ids_json TEXT,
    total_usd REAL DEFAULT 0,
    payment_method TEXT CHECK (payment_method IN (
        'stripe', 'cash', 'check', 'ach', 'other'
    )),
    stripe_payment_intent_id TEXT,
    delivery_required INTEGER NOT NULL DEFAULT 0,
    linked_delivery_id TEXT,
    care_guidance_sent INTEGER NOT NULL DEFAULT 0,
    follow_up_at TEXT,
    cross_stream_opportunity_json TEXT,
    status TEXT NOT NULL DEFAULT 'walk_in' CHECK (status IN (
        'walk_in', 'consult', 'recommended', 'purchased',
        'no_purchase', 'followed_up', 'archived'
    ))
);

CREATE TABLE IF NOT EXISTS sales_actions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_kind TEXT NOT NULL CHECK (action_kind IN (
        'quote_send', 'follow_up', 'renewal_pitch', 'booking_confirmation'
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
        'lead', 'opportunity', 'quote', 'closed_deal',
        'subscription_contract', 'event_booking', 'local_sale',
        'customer_account', 'sales_action'
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
CREATE INDEX IF NOT EXISTS idx_customers_owner ON customer_accounts(owner);
CREATE INDEX IF NOT EXISTS idx_customers_primary_stream ON customer_accounts(primary_stream);
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_stream ON leads(stream);
CREATE INDEX IF NOT EXISTS idx_opportunities_status ON opportunities(status);
CREATE INDEX IF NOT EXISTS idx_opportunities_stage ON opportunities(stage);
CREATE INDEX IF NOT EXISTS idx_opportunities_owner ON opportunities(owner);
CREATE INDEX IF NOT EXISTS idx_opportunities_close ON opportunities(expected_close_date);
CREATE INDEX IF NOT EXISTS idx_quotes_status ON quotes(status);
CREATE INDEX IF NOT EXISTS idx_quotes_customer ON quotes(customer_id);
CREATE INDEX IF NOT EXISTS idx_quotes_idempotency ON quotes(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_deals_outcome ON closed_deals(outcome);
CREATE INDEX IF NOT EXISTS idx_deals_closed ON closed_deals(closed_at);
CREATE INDEX IF NOT EXISTS idx_subs_status ON subscription_contracts(status);
CREATE INDEX IF NOT EXISTS idx_subs_renewal ON subscription_contracts(renewal_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON event_bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_event_date ON event_bookings(event_date);
CREATE INDEX IF NOT EXISTS idx_local_status ON local_sales(status);
CREATE INDEX IF NOT EXISTS idx_actions_idempotency ON sales_actions(idempotency_key);
CREATE INDEX IF NOT EXISTS idx_transitions_entity ON ledger_state_transitions(entity_type, entity_id);
