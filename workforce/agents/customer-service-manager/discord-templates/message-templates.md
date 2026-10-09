# Discord Message Templates — Customer Service Manager Team (Poppy)

Standard message templates used by Poppy, Pearl, Oakley, and Maple.

---

## #acme-care-tickets

### Daily Ticket Triage Summary

```
🦭 **Ticket Triage — {{date}}**

**New tickets:** {{new_count}}
**Triaged + responded < 2h:** {{within_sla_count}} / {{new_count}}

**By owner:**
- Pearl resolved: {{pearl_count}}
- Routed to Oakley: {{oakley_count}}
- Routed to Maple: {{maple_count}}
- Escalated to Poppy: {{poppy_count}}

**By category:**
{{#each by_category}}
- {{category}}: {{count}}
{{/each}}

{{#if legal_triggers}}
⚠️ **Legal language detected:** {{legal_trigger_count}} — escalated
{{/if}}
```

### Order Issue Resolution Proposal

```
🐕 **Order Issue — {{order_issue_id}}** ({{kind}})

**Customer:** {{customer_name}}
**Ticket:** {{ticket_id}}
**Linked order:** {{linked_order_summary}}

**Investigation:** {{investigation_summary}}

**Proposed resolution:** {{proposed_resolution.kind}} ({{proposed_resolution.amount_usd}})
**Cross-team coordination needed:** {{cross_team_coordination}}
**Approval path:** {{approval_path}}

**Oakley recommends:** {{recommendation}}

**Actions:** `approve` / `edit <notes>` / `reject <reason>`
```

### Care Consultation Drafted

```
🌳 **Care Consultation — {{consult_id}}**

**Customer:** {{customer_name}}
**Species:** {{species}} (purchased {{purchased_at}})
**Environment:** {{environment_summary}}
**Symptoms:** {{symptoms}}
**Timeline:** {{timeline}}

**Diagnosis:** {{diagnosis.likely_cause}} (confidence: {{diagnosis.confidence}})
**Prescription:**
- Immediate: {{prescription.immediate_action}}
- Ongoing: {{prescription.ongoing_care}}
- Watch for: {{prescription.what_to_watch_for}}

**Reasoning:** {{prescription.reasoning}}

**Follow-up:** {{follow_up_date}}

{{#if species_pattern_flag}}
⚠️ Species pattern detected — flagged to Tally + Poppy
{{/if}}
```

### Weekly Trending Issues

```
🪼 **Trending Issues — Week of {{week_of}}**

**Top categories this week:**
{{#each top_categories}}
- {{category}}: {{count}} ({{trend_emoji}} {{trend_label}})
{{/each}}

**Patterns (≥ 3 customers):**
{{#each patterns}}
- {{pattern_summary}} — {{customer_count}} customers; routing to {{owner_team}}
{{/each}}

**Root cause analysis:**
{{root_cause_analysis}}

**Poppy recommends:** {{recommendation}}
```

### Weekly Customer Health Report

```
🪼 **Weekly Customer Health — Week of {{week_of}}**

**Decision needed:** {{headline_recommendation}}

**Tickets:** {{opened_count}} opened / {{resolved_count}} resolved
**CSAT trend:** {{csat_avg}} ({{csat_trend_emoji}} {{csat_trend_label}})
**First-response SLA:** {{first_response_sla_pct}}% within 2h
**Resolution SLA:** {{resolution_sla_pct}}% within 24h

**Top 3 patterns:**
{{#each patterns}}
{{@index}}. {{summary}} → owner: {{owner_team}}
{{/each}}

**Churn risks (major accounts):** {{major_account_risks}}

**Success stories:**
{{#each success_stories}}
- {{summary}}
{{/each}}

**Poppy recommends:** {{recommendation}}

Cross-posted summary sent to Jane + CMO + Director of Sales.
```

---

## #acme-care-approvals

### Refund > $500

```
🪼 **Approval Needed — Refund > $500** ({{refund_id}})

**Customer:** {{customer_name}}
**Amount:** ${{amount_usd}}
**Kind:** {{kind}}
**Company responsibility:** {{company_responsibility}}

**Rationale:** {{rationale}}

**Poppy recommends:** {{recommendation}}

**Actions:** `approve` / `edit <notes>` / `reject <reason>`
```

### Legal Language Escalation

```
🚨 **LEGAL LANGUAGE DETECTED — {{ticket_id}}**

**Customer:** {{customer_name}}
**Channel:** {{channel}}
**Trigger words:** {{trigger_words}}

**Original message excerpt:**
> {{message_excerpt}}

**Poppy recommends:** {{recommendation}}

No outbound response has been sent. Awaiting Jane direction.

**Actions:** `respond <approved wording>` / `engage_legal <contact>` / `acknowledge_only`
```

### Major Account Save

```
🪼 **Approval Needed — Major Account Save** ({{customer_id}})

**Account:** {{customer_name}}
**Stream:** {{stream}} (wholesale > $10K/year OR subscription > $1K/month)
**Annual value:** ${{annual_value_usd}}
**Threat:** {{threat_summary}}

**Proposed save concession:** {{concession_summary}}
**Concession value:** ${{concession_value_usd}}
**Coordinated with:** {{coordinated_teams}}

**Poppy recommends:** {{recommendation}}

**Actions:** `approve` / `edit <terms>` / `reject <reason>`
```

### Pattern Issue Root Cause

```
🪼 **Approval Needed — Pattern Issue** ({{escalation_id}})

**Pattern:** {{pattern_summary}}
**Affected customers:** {{customer_count}}
**Recent timeframe:** {{timeframe}}
**Suspected root cause:** {{suspected_root_cause}}

**Proposed corrective action:** {{corrective_action}}
**Operating team owner:** {{owner_team}}

**Poppy recommends:** {{recommendation}}

**Actions:** `approve` / `edit <action>` / `reject <reason>`
```

### Subscription Cancellation Save

```
🪼 **Approval Needed — Subscription Save** ({{subscription_id}})

**Customer:** {{customer_name}}
**Monthly fee:** ${{monthly_fee_usd}}
**Reason for cancellation:** {{cancellation_reason}}
**Save options proposed:**
{{#each save_options}}
{{@index}}. {{label}} — cost: ${{cost}}
{{/each}}

**Poppy recommends:** {{recommendation}}

**Actions:** Reply with option number, or `accept_cancellation <reason>`.
```

---

## #acme-care-resolutions

### Resolved Ticket — Customer Satisfied

```
✅ **Resolved — {{ticket_id}}**

**Customer:** {{customer_name}}
**Category:** {{category}}
**Resolution:** {{resolution_summary}}
**Owner:** {{owner}}
**Resolution time:** {{resolution_hours}}h
**CSAT:** {{csat_score}}/5

{{#if customer_quote}}
**Customer feedback:** "{{customer_quote}}"
{{/if}}
```

### Customer Thank-You / Compliment

```
💚 **Customer Compliment — {{customer_name}}**

**Channel:** {{channel}}
**Context:** {{context}}

**Quote:** "{{verbatim_quote}}"

{{#if consent_to_publish}}
✅ Consent to publish granted — routed to CMO for content consideration
{{/if}}
```

### Success Story Captured

```
🌟 **Success Story — {{customer_name}}**

**Stream:** {{stream}}
**Story:** {{story_summary}}
**Tree journey:** {{tree_journey_summary}}

**Consent status:** {{consent_summary}}

{{#if for_case_study}}
Routed to CMO + Director of Sales for potential case study.
{{/if}}
```

---

## #acme-care-alerts

### Legal Language Alert

```
🚨 **LEGAL LANGUAGE — {{ticket_id}}**

@Jane @Poppy — emergency response active. See approval channel.
```

### Media / Viral Escalation

```
🚨 **MEDIA / VIRAL ESCALATION**

**Where:** {{platform}}
**Content:** {{content_summary}}
**Reach estimate:** {{reach_estimate}}

@Jane @CMO — review immediately.

**Poppy recommends:** {{recommendation}}
```

### Persistent Unresolved Pattern

```
⚠️ **Persistent Unresolved — {{customer_name}}**

**Ticket:** {{ticket_id}}
**Contact count:** {{contact_count}} (threshold: > 3)
**Days open:** {{days_open}}
**Owner:** {{owner}}

**Why unresolved:** {{blocker_summary}}

@Poppy — strategy reset.
```

### Major Account At-Risk

```
🔴 **Major Account At-Risk — {{customer_name}}**

**Stream:** {{stream}}
**Annual value:** ${{annual_value_usd}}
**Signals:** {{at_risk_signals}}
**Days since last positive interaction:** {{days_inactive}}

**Poppy proposed save plan:** {{save_plan_summary}}

@Jane — review.
```

### Recurring Species Issue

```
⚠️ **Species Health Pattern — {{species}}**

**Affected customers:** {{customer_count}} (≥ 3 trigger)
**Symptoms:** {{symptoms}}
**Suspected cause:** {{suspected_cause}}

Routed to Tally (COO Inventory) for sourcing review.
Routed to Mira (Creative Director Educational Content) for care guide update.

@Poppy — coordinate response.
```

### Emergency Stop Active

```
🛑 **CARE OUTBOUND PAUSED**

All customer-facing replies, refunds, replacements, follow-ups, and check-ins are stopped. Drafting + ledger writes continue.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

To resume: set `outbound_replies_enabled: true` in `config/emergency-stop.json`.
```

### Emergency Stop Resumed

```
✅ **CARE OUTBOUND RESUMED**

Outbound re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved actions will now proceed.
```
