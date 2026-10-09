# Discord Message Templates — Director of Sales Team (Cash)

Standard message templates used by Cash, Wade, Lily, Sophia, and Max.

---

## #acme-sales-drafts

### Quote Draft for Review

```
📋 **Quote Draft — {{quote_id}}** ({{stream}})

**Customer:** {{customer_name}} ({{organization}})
**Total:** ${{total_usd}}
**Discount:** {{discount_pct}}% (approval path: {{approval_path}})
**Valid until:** {{valid_until}}

**Line items:**
{{#each line_items}}
- {{description}} × {{quantity}} @ ${{unit_price_usd}} = ${{line_total_usd}}
{{/each}}

**Inventory confirmed by Tally:** {{inventory_confirmation.confirmed_by_tally}}
**Margin floor check:** {{margin_floor_check.above_floor}}

{{#if strategic_rationale}}
**Strategic rationale:** {{strategic_rationale}}
{{/if}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### Opportunity Review (Stalled > 30 days)

```
🐬 **Stalled Opportunity — {{opportunity_id}}** ({{stream}})

**Customer:** {{customer_name}}
**Stage:** {{stage}} ({{days_in_stage}} days)
**Value (weighted):** ${{weighted_value_usd}}
**Owner:** {{owner}}
**Last touch:** {{last_touch_at}}

**Owner-proposed reset:** {{proposed_reset}}

**Cash recommends:** {{recommendation}}

**Actions:** `approve_reset` / `reassign` / `disqualify` / `extend`
```

### Subscription Renewal Proposal

```
🤝 **Renewal Proposal — {{subscription_id}}**

**Customer:** {{customer_name}}
**Current term ends:** {{renewal_date}}
**Current monthly fee:** ${{current_monthly_fee}}
**Proposed term:** {{term_months}} months
**Proposed monthly fee:** ${{proposed_monthly_fee}}
**Expansion offer:** {{expansion_summary}}

**Service tier:** {{service_tier}}
**Satisfaction signals:** NPS {{nps_score}} | complaints {{complaints_count}} | referrals {{referrals_count}}

{{#if churn_risk_signals}}
⚠️ **Churn risk:** {{churn_risk_signals}}
{{/if}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### Event Booking Confirmation Sweep

```
🎉 **Event Booking Sweep — {{date}}**

**Next 14 days:** {{booking_count}} bookings
**Confirmed:** {{confirmed_count}}
**Gaps:**
{{#each gaps}}
- {{booking_id}} on {{event_date}}: {{gap_kind}}
{{/each}}
```

### Daily Lead Intake Summary

```
🐬 **Daily Lead Intake — {{date}}**

**New leads:** {{new_count}}
{{#each by_stream}}
- {{stream}}: {{count}}
{{/each}}

**Qualified today:** {{qualified_count}}
**Disqualified:** {{disqualified_count}}
**Stalled in `received` > 24h:** {{stalled_count}}
```

---

## #acme-sales-approvals

### CEO Escalation — Large Discount

```
🐬 **Approval Needed — Discount > 25%** ({{quote_id}})

**Customer:** {{customer_name}} ({{stream}})
**Quote total at list:** ${{list_total_usd}}
**Discount:** {{discount_pct}}% → ${{discounted_total_usd}}
**Below cost:** {{below_cost}}

**Margin impact (from Margin):** Δ{{delta_margin_pct}}% margin

**Strategic rationale:** {{strategic_rationale}}

**Cash recommends:** {{recommendation}}

**Actions (Jane + Margin both needed):** `approve` / `reject <reason>` / `edit <notes>`
```

### CEO Escalation — Short-Term Subscription

```
🐬 **Approval Needed — Subscription < 12 Months** ({{subscription_id}})

**Customer:** {{customer_name}}
**Proposed term:** {{term_months}} months
**Monthly fee:** ${{monthly_fee_usd}}
**Total contract value:** ${{total_value_usd}}

**Reason for short term:** {{short_term_reason}}

**Cash recommends:** {{recommendation}}

**Actions:** `approve` / `reject <reason>` / `edit_term <months>`
```

### CEO Escalation — Major Account Save

```
🐬 **Approval Needed — Major Account Save**

**Account:** {{customer_name}}
**Annual / monthly value:** ${{annual_or_monthly_value}}
**Threat:** {{threat_summary}}

**Proposed concession:** {{concession_summary}}
**Concession value:** ${{concession_value}}

**Cash recommends:** {{recommendation}}

**Actions:** `approve` / `reject <reason>` / `edit <notes>`
```

### Customer Dispute Refund Escalation

```
🐬 **Approval Needed — Refund > $1,000**

**Customer:** {{customer_name}} ({{stream}})
**Dispute summary:** {{dispute_summary}}
**Refund requested:** ${{refund_amount_usd}}
**Customer Service involvement:** {{csm_involvement}}

**Cash recommends:** {{recommendation}}

**Actions:** `approve` / `reject <reason>` / `edit <notes>`
```

---

## #acme-sales-pipeline

### Weekly Pipeline Snapshot

```
🐬 **Weekly Pipeline — Week of {{week_of}}**

**Decision needed:** {{headline_recommendation}}

**Pipeline (weighted):** ${{total_weighted_usd}}
{{#each by_stream}}
- {{stream}}: ${{weighted}} ({{count}} opportunities)
{{/each}}

**Forecast this quarter:**
- Base: ${{base_forecast_usd}}
- Low: ${{low_forecast_usd}}
- High: ${{high_forecast_usd}}

**Pace vs target:** {{pace_emoji}} {{pace_label}}

**Top wins this week:**
{{#each top_wins}}
- {{deal_id}}: {{stream}} ${{amount}} — {{factors}}
{{/each}}

**Top losses this week:**
{{#each top_losses}}
- {{deal_id}}: {{stream}} ${{amount}} — {{factors}}
{{/each}}

**Stalled > 30d:**
{{#each stalled}}
- {{opportunity_id}}: {{stream}} ${{amount}} — owner {{owner}}
{{/each}}

**Churn risks:**
{{#each churn_risks}}
- {{subscription_id}}: {{signals}}
{{/each}}

**Cash recommends:** {{recommendation}}
```

### Weekly Revenue + Pipeline Report

```
🐬 **Weekly Revenue + Pipeline — Week of {{week_of}}**

**Closed deals this week:**
| Stream | Wins | Won $ | Losses |
|---|---|---|---|
{{#each by_stream}}
| {{stream}} | {{wins_count}} | ${{won_usd}} | {{losses_count}} |
{{/each}}

**Conversion rates (trailing 30d):**
{{#each conversion_rates}}
- {{stage_transition}}: {{rate_pct}}%
{{/each}}

**Subscription health:**
- Active: {{active_count}}
- Churn this week: {{churn_count}}
- Renewal expansions: {{expansion_count}}

**Cross-stream conversions:** {{cross_stream_count}}

Cross-posted summary sent to Sterling (CFO).
```

---

## #acme-sales-alerts

### Stalled Quote Alert

```
⚠️ **Quote Stalled > 7 Days — {{quote_id}}**

**Customer:** {{customer_name}}
**Stream:** {{stream}}
**Total:** ${{total_usd}}
**Sent:** {{sent_at}}
**Owner:** {{owner}}

**Actions:** `nudge` / `extend_valid` / `archive`
```

### Subscription Churn Risk

```
🔴 **Churn Risk — {{subscription_id}}**

**Customer:** {{customer_name}}
**Monthly fee:** ${{monthly_fee_usd}}
**Renewal date:** {{renewal_date}}

**Signals detected:**
{{#each churn_risk_signals}}
- {{this}}
{{/each}}

**Sophia recommends:** {{recommendation}}

@Cash — review.
```

### Missed Deposit Alert

```
⚠️ **Event Booking Deposit Missing — {{booking_id}}**

**Customer:** {{customer_name}}
**Event date:** {{event_date}} ({{days_until_event}} days)
**Quote accepted:** {{quote_accepted_at}}
**Deposit expected:** ${{deposit_usd}}
**Hours overdue:** {{hours_overdue}}

**Actions:** `nudge` / `cancel` / `extend`
```

### Inventory Commitment Conflict

```
⚠️ **Inventory Conflict — {{quote_id}}**

**Customer:** {{customer_name}}
**Requested:** {{requested_species_size_quantity}}
**Tally available:** {{available}}
**Short:** {{short}}

**Tally proposed substitute:** {{substitute_summary}}

Cash awaiting decision: `accept_substitute` / `revise_quote` / `disqualify`
```

### Emergency Stop Active

```
🛑 **SALES ACTIONS PAUSED**

All quote sends, follow-ups, renewal pitches, and booking confirmations are stopped.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

Drafting, reporting, ledger writes continue. To resume: set
`sales_actions_enabled: true` in `config/emergency-stop.json`.
```

### Emergency Stop Resumed

```
✅ **SALES ACTIONS RESUMED**

Outbound sales actions re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved actions will now proceed.
```
