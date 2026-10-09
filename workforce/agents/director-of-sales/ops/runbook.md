# ACME Bonsai Director of Sales (Cash) — Operations Runbook

## Overview

This runbook covers daily, weekly, and monthly operations for the ACME Bonsai sales team — Cash (Director of Sales), Wade (Wholesale), Lily (Local), Sophia (Subscription), Max (Event Rental).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-sales-alerts` for overnight quote / deposit / churn issues
2. Review daily lead intake summary (all sub-agents, 8 AM)
3. Review open quote follow-up sweep (9 AM)
4. Review event booking confirmation sweep (Max, 9:30 AM)
5. Review subscription renewal scan (Sophia, 10 AM)
6. Review walk-in follow-up (Lily, 10:30 AM)

### Throughout the Day

1. Quote drafts surface in `#acme-sales-drafts` for Cash review
2. Stalled opportunities flag to Cash for strategy reset
3. Churn-risk signals route to Cash; escalate to Jane if major account
4. Cross-stream opportunities route between sub-agents
5. Cash escalates above-threshold items to Jane

### Evening (6:00 PM ET)

1. Day-end check on quotes awaiting customer response
2. Note tomorrow's must-confirm event bookings
3. Verify next-morning routines are armed

---

## Weekly Operations

### Monday Morning

1. **8:00 AM**: Cash runs weighted pipeline review; posts to `#acme-sales-pipeline`
2. **10:00 AM**: Wade runs wholesale pipeline nudge
3. **11:00 AM**: Sophia runs subscription renewal outreach for 60-day window contracts

### Friday Afternoon

1. **4:00 PM**: Cash runs weekly revenue + pipeline report; cross-posts to Sterling

---

## Monthly Operations

### Day 1 (9:00 AM ET)

1. Cash refreshes cohort + LTV analysis
2. Cohort revenue by month, subscription churn cohorts, wholesale repeat rate, event cross-stream conversion
3. Updates LTV estimates per stream

---

## Approval Decisions

### Discounts

| Discount | Approval Path |
|----------|--------------|
| ≤ 20% off list | Cash (with documented rationale) |
| 20–25% on wholesale > 100 trees | Cash (volume tier) |
| > 25% or below cost | Cash + Jane + Margin (CFO) — strategic rationale required |

### Subscription terms

| Scenario | Approval Path |
|----------|--------------|
| ≥ 12 months | Cash |
| < 12 months | Jane approval |

### Commercial terms

| Scenario | Approval Path |
|----------|--------------|
| Standard terms | Cash |
| Custom payment / SLA / clauses | Jane approval |

### Customer disputes + refunds

| Scenario | Approval Path |
|----------|--------------|
| Refund ≤ $1,000 | Cash + Customer Service Manager |
| Refund > $1,000 | Jane approval |
| Major account save concession | Jane approval |

---

## Common Failures

### Quote Stalled > 7 Days

1. Wade / Lily / Sophia / Max sends gentle follow-up
2. After 14 days: surface to Cash for decision (nudge / extend / archive)
3. Decision logged in `quotes.status` transition

### Inventory Commitment Conflict

1. Tally reports unavailable for the requested species/size/quantity
2. Sub-agent surfaces to Cash with Tally's proposed substitute
3. Cash decision: accept substitute / revise quote / disqualify

### Subscription Churn Risk

1. Sophia detects signals (missed payment, complaint, sponsor change, etc.)
2. Flag in `#acme-sales-alerts`
3. Cash assesses; if major account: escalate to Jane for save concession authority

### Event Booking Deposit Missing

1. Max nudges customer 48h after quote acceptance if no deposit
2. After 72h: surface to Cash for decision (nudge / cancel / extend)
3. If event is within 14 days and deposit not paid: immediate Cash escalation

### Wholesale Deal Lost to Competitor

1. Wade documents `lost_factors` + `lost_competitor` in closed_deal record
2. If lost to specific competitor pattern: surface to Cash for pricing / positioning review
3. Pattern across 3+ losses → Cash escalates to Jane + Margin for strategy reset

### Marketing-Sourced Lead with Conflict

1. CMO routes a lead through; Sub-agent qualifies
2. If lead is mismatched stream (e.g., subscription lead routed to wholesale): re-route to correct sub-agent
3. Document mis-routing to feedback into CMO's targeting

---

## Cross-Team Handoffs

### Wholesale Deal Won → Rowan (Contract Coordinator)

1. Wade marks opportunity `won`
2. Creates closed_deal with `downstream_handoff.team = 'contract-coordinator'`
3. Writes hand-off packet to Contract Coordinator inbox
4. Rowan picks up: contract send → deposit → reservation → routing → delivery → balance
5. Wade stays informed via Contract Coordinator updates; does not duplicate

### Subscription Signed → Cedar (Installation) + Sterling (Billing)

1. Sophia marks subscription `signed`
2. Hand off to Cedar for installation scheduling (delivery_job in COO ledger)
3. Hand off to Sterling for Stripe subscription setup
4. Sophia schedules first satisfaction check 30 days post-install

### Event Booking Confirmed → Cedar (Rental Cycle)

1. Max marks booking `confirmed` (deposit + agreement + inventory all confirmed)
2. Hand off to Cedar's rental_job (COO ledger): outbound → at_event → return → inspected
3. Max stays informed; routes post-event cross-stream opportunities

### Local Sale Purchased → Tally (Allocation) + Cedar (Delivery if applicable)

1. Lily marks local_sale `purchased`
2. Hand off to Tally for tree allocation
3. If delivery required: hand off to Cedar for delivery_job
4. Lily schedules care follow-up + identifies cross-stream

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single quote stalled, one unanswered follow-up | Next business day |
| Medium | Inventory conflict, deposit missing > 48h, single churn signal | Within 4 hours |
| High | Major account churn risk, sustained pipeline shortfall, repeated lost-to-competitor | Within 1 hour |
| Critical | Public customer complaint, major-account ultimatum, ledger corruption | Immediately |

### Incident Steps

1. Assess severity
2. If critical: activate emergency stop immediately if outbound exposure
3. Investigate root cause (read sales ledger + cross-team handoffs)
4. Resolve or escalate to Jane
5. Log incident outcome in sales ledger
6. Post resolution to `#acme-sales-alerts`

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "sales_actions_enabled": false,
  "reason": "Describe why outbound is paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-06-27T12:00:00Z"
}
```

**What stops:**

- All quote sends + follow-ups + renewal pitches + booking confirmations
- New inventory commitments (no `proposal → negotiation` transitions)
- Cross-team handoffs queue locally

**What continues:**

- Drafting, pipeline review, ledger writes
- Internal qualification and analysis

### Resuming

```json
{
  "sales_actions_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "Describe why outbound is resumed",
  "resumed_by": "Your name",
  "resumed_at": "2026-06-27T14:00:00Z"
}
```

---

## Metrics to Track

### Pipeline Health

- Weighted pipeline by stream (target: 3x forecast)
- Conversion rate by stage (discovery → proposal → negotiation → committed → won)
- Win rate by stream
- Average days in stage
- Stalled opportunity count

### Revenue Performance

- Closed deals by stream this week / month / quarter
- Pace vs quarterly target
- Forecast accuracy (base forecast vs actuals, abs %)
- Subscription MRR + renewal rate (target: > 90%)
- Cross-stream conversion rate

### Customer Health

- New customers per quarter
- Repeat customer rate
- NPS / CSAT trend
- LTV per stream
- Churn rate per stream

### System Health

- Sales ledger integrity check
- Outbound action send success rate
- Cross-team handoff completion rate
- Routine on-time rate
- Emergency stop activations
