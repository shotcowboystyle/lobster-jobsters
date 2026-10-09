# Discord Message Templates — CFO Team (Sterling)

Standard message templates used by Sterling, Ledger, Horizon, Garrison, and Margin.

---

## #acme-finance-drafts

### Daily Reconciliation Summary

```
📊 **Daily Reconciliation — {{date}}**

**Accounts reconciled:** {{reconciled_count}} / {{total_accounts}}
**Clean:** {{clean_count}}
**Variance documented:** {{documented_count}}
**Unresolved:** {{unresolved_count}}

{{#if unresolved}}
**Unresolved:**
{{#each unresolved}}
- {{account}}: {{variance_usd}} — {{note}}
{{/each}}
{{/if}}
```

### Monthly Close Opening Checklist

```
📊 **Monthly Close — {{period}}** (target: {{target_close_at}})

**Tasks:**
{{#each tasks}}
- [ ] {{task}} — owner: {{owner}}
{{/each}}

Close kickoff at {{opened_at}}. Daily standup in this channel.
```

### Forecast Draft for Review

```
📈 **Forecast Draft — {{forecast_id}}** ({{kind}})

**Horizon:** {{horizon_periods}}
**Status:** {{status}}

**Key metrics (base case):**
- Ending cash: ${{key_metrics.ending_cash_usd}}
- Runway: {{key_metrics.runway_days}} days
- Revenue: ${{key_metrics.revenue_usd}}
- GM%: {{key_metrics.gross_margin_pct}}%

**Assumptions:**
{{#each assumptions}}
- {{assumption}} = {{value}}  _(rationale: {{rationale}})_
{{/each}}

**Sensitivity:**
{{#each sensitivity}}
- {{variable}}: low={{low_value}}, high={{high_value}} → {{effect_on_metric}}
{{/each}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### Pricing Analysis Draft

```
💰 **Pricing Decision — {{pricing_id}}** ({{kind}}, channel: {{channel}})

**Subject:** {{subject}}
**Requested by:** {{requested_by}}

**Current:** ${{current.effective_price_usd}} (margin: {{current.current_margin_pct}}%)
**Proposed:** ${{proposed.new_price_usd}} ({{proposed.discount_pct}}% off list, margin: {{proposed.new_margin_pct}}%)

**Margin impact:**
- Δ margin %: {{margin_impact.delta_margin_pct}}
- Est. volume: {{margin_impact.estimated_volume_units}} units
- Est. revenue impact: ${{margin_impact.estimated_revenue_impact_usd}}
- Est. gross profit impact: ${{margin_impact.estimated_gross_profit_impact_usd}}

**Strategic rationale:** {{strategic_rationale}}
{{#if proposed.below_cost}}
⚠️ **Below cost** — requires Jane approval
{{/if}}

**Approval path:** {{approval_path}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### Daily Compliance Check

```
🛡️ **Compliance Check — {{date}}**

**Due within 14 days:** {{due_soon_count}}
{{#each due_soon}}
- {{kind}} ({{jurisdiction}}) — due {{due_date}} — owner: {{owner}}
{{/each}}

**Open exceptions > 24h:** {{open_exceptions_count}}
{{#if open_exceptions_count}}
{{#each open_exceptions}}
- {{exception_id}} ({{severity}}) — {{description}}
{{/each}}
{{/if}}
```

---

## #acme-finance-approvals

### CEO Escalation — Unbudgeted Spend

```
🦅 **Approval Needed — Unbudgeted Spend**

**Amount:** ${{amount_usd}} (> $5K threshold)
**Vendor:** {{vendor}}
**Purpose:** {{purpose}}
**Owner:** {{owner}}
**Cash impact:** {{cash_impact_note}}

**Sterling recommends:** {{recommendation}}

**Actions:** `approve` / `reject <reason>` / `defer`
```

### CEO Escalation — Pricing Above Threshold

```
🦅 **Approval Needed — Pricing Decision** ({{pricing_id}})

**Subject:** {{subject}} (channel: {{channel}})
**Discount:** {{proposed.discount_pct}}% off list ({{below_cost_label}})
**Margin impact:** Δ{{margin_impact.delta_margin_pct}}% margin → ${{margin_impact.estimated_gross_profit_impact_usd}} gross profit impact
**Strategic rationale:** {{strategic_rationale}}

**Sterling recommends:** {{recommendation}}

**Actions:** `approve` / `reject <reason>` / `defer`
```

### CEO Escalation — External Finance Communication

```
🦅 **Approval Needed — External Finance Communication**

**To:** {{recipient}} ({{stakeholder_kind}})
**Subject:** {{subject}}

---
{{body_preview}}
---

**Sterling recommends:** {{recommendation}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### Monthly Close Ready for Jane

```
🦅 **Monthly Close Ready — {{period}}**

**Summary:** {{summary.headline}}
- Cash position: ${{summary.cash_position_usd}}
- Revenue: ${{summary.revenue_usd}}
- GM%: {{summary.gross_margin_pct}}%
- Net income: ${{summary.net_income_usd}}
- Runway: {{summary.runway_days}} days

**Material variances explained:** {{material_variances_count}}
**Material variances open:** 0

**Actions:** `approve` (close) / `edit <notes>` / `hold`
```

---

## #acme-finance-reports

### Weekly Cash + Runway

```
📈 **Weekly Cash + Runway — {{as_of}}**

**Cash position:** ${{cash_position_usd}} ({{runway_status_emoji}} {{runway_status}})
**Runway:** {{runway_days}} days
**Trailing 3mo avg burn:** ${{trailing_3mo_avg_burn_usd}} / month

**13-week cash projection:**
- Week 1 end: ${{thirteen_week_projection.[0].ending_cash_usd}}
- Week 4 end: ${{thirteen_week_projection.[3].ending_cash_usd}}
- Week 13 end: ${{thirteen_week_projection.[12].ending_cash_usd}}

**Key assumptions:**
{{#each key_assumptions}}
- {{this}}
{{/each}}

{{#if alerts}}
**Alerts:**
{{#each alerts}}
- {{severity}}: {{message}}
{{/each}}
{{/if}}
```

### Weekly Margin Snapshot

```
💰 **Weekly Margin Snapshot — week of {{week_of}}**

| Channel | Revenue | GM% | Floor | Status |
|---------|---------|-----|-------|--------|
{{#each channels}}
| {{channel}} | ${{revenue}} | {{gm_pct}}% | {{floor_pct}}% | {{status_emoji}} {{status}} |
{{/each}}

{{#if violations}}
**Below floor:**
{{#each violations}}
- {{channel}}: {{gm_pct}}% vs floor {{floor_pct}}% — opening pricing_decision {{pricing_id}}
{{/each}}
{{/if}}
```

### Weekly Exception Audit Roll-Up

```
🛡️ **Weekly Exception Audit — week of {{week_of}}**

**By kind:**
{{#each by_kind}}
- {{kind}}: {{count}} ({{total_amount_usd}})
{{/each}}

**By severity:**
- Critical: {{critical_count}}
- High: {{high_count}}
- Medium: {{medium_count}}
- Low: {{low_count}}

**Material items (escalated to Sterling):**
{{#each material}}
- {{exception_id}} — {{description}} (owner: {{owner}})
{{/each}}
```

---

## #acme-finance-alerts

### Runway Alert

```
🚨 **RUNWAY ALERT — runway < 90 days**

**Cash:** ${{cash_position_usd}}
**Burn:** ${{burn_rate_usd_per_month}}/month
**Runway:** {{runway_days}} days

@Jane — surfacing immediately. Full snapshot in #acme-finance-reports.
```

### Missed Deadline

```
❌ **Compliance Deadline Missed — {{compliance_id}}**

**Kind:** {{kind}} ({{jurisdiction}})
**Due:** {{due_date}}
**Linked exception:** {{linked_exception_id}}

Garrison opening incident. @Sterling, @Jane.
```

### Finance Action Failure

```
❌ **Finance Action Failed — {{action_kind}}**

**Related:** {{related_id}}
**Amount:** ${{amount_usd}}
**Idempotency key:** {{idempotency_key}}
**Attempt:** {{attempt}} of 3
**Reason:** {{failure_reason}}

Awaiting Sterling decision: `retry` / `cancel` / `void`.
```

### Emergency Stop Active

```
🛑 **FINANCE ACTIONS PAUSED**

All invoice sends, refunds, vendor payments, and filings are stopped.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

Drafting, reporting, ledger writes continue. To resume: set
`finance_actions_enabled: true` in `config/emergency-stop.json`.
```

### Emergency Stop Resumed

```
✅ **FINANCE ACTIONS RESUMED**

Outbound finance actions re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved actions will now proceed.
```
