# ACME Bonsai CFO Team (Sterling) — Operations Runbook

## Overview

This runbook covers daily, weekly, monthly, and quarterly operations for the ACME Bonsai finance team — Sterling (CFO), Ledger (Finance Ops), Horizon (FP&A), Garrison (Controls & Compliance), Margin (Pricing & Profitability).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-finance-alerts` for overnight runway / deadline / action failures
2. Review daily reconciliation summary in `#acme-finance-drafts` (Ledger, 7 AM)
3. Review AR aging report (Ledger, 8 AM) — approve escalations to collections workflow
4. Review daily compliance check (Garrison, 7:30 AM) — acknowledge `due_soon` items
5. Approve AP schedule (Ledger, 9 AM) — any items > $5K outside budget surface to Jane

### Throughout the Day

1. Pricing requests from Sales surface via Margin in `#acme-finance-drafts`
2. Exception flags from Garrison surface in `#acme-finance-drafts`
3. Sterling triages and routes to Jane for items above thresholds

### Evening (6:00 PM ET)

1. Day-end check on AR aging and AP cutoff
2. Note any items rolling to tomorrow

---

## Weekly Operations

### Monday Morning

1. Read weekly cash + runway snapshot (Horizon, 8 AM ET) in `#acme-finance-reports`
2. Verify runway status (target: green > 180d)
3. Read weekly margin snapshot (Margin, 10 AM ET)
4. Review any below-floor channels

### Friday Afternoon

1. Read weekly exception audit (Garrison, 4 PM ET)
2. Approve any material exception escalations
3. Note items carrying into next week

---

## Monthly Operations

### Day 1 of Month

1. Ledger opens monthly close package at 9 AM ET
2. Review opening checklist; confirm owners + deadlines
3. Daily standup in `#acme-finance-drafts`

### Day 2–4

1. Reconciliations run daily; resolve unresolved items aggressively
2. Variance review begins as reconciliations complete

### Day 5 (Close Day)

1. Target: close package lands in Sterling review by noon
2. Sterling reviews material variance explanations
3. CEO review by 4 PM
4. Jane approves by 6 PM ET → close complete

### Day 6

1. Horizon refreshes monthly forecast using just-closed actuals
2. Posts draft for Sterling review by end of day
3. Sterling approves; Jane acks

---

## Quarterly Operations

### First Monday of Quarter

1. Horizon produces quarterly re-forecast at 9 AM ET
2. Revised annual P&L
3. Capital allocation review
4. Three scenarios (base / upside / downside)
5. Sterling reviews; Jane approves before publication

---

## Approval Decisions

### Pricing

| Discount | Approval Path |
|----------|--------------|
| ≤ 15% off list | Sterling only (sterling_only) |
| > 15% off list | Sterling + Jane (sterling_plus_ceo) |
| Below cost | Jane approval with strategic rationale required |

### Spend

| Amount | Approval Path |
|--------|--------------|
| ≤ Budget | Normal AP routing |
| > $5K outside budget | Jane approval |
| Banking decisions (financing, account changes) | Jane approval |

### External Communications

| Recipient | Approval Path |
|-----------|--------------|
| Bank | Jane approval |
| Tax authority | Jane approval |
| External auditor | Jane approval |
| Vendor (routine) | Sterling |

---

## Common Failures

### Reconciliation Unresolved at Day 4

1. Sterling identifies blocker — missing invoice, miscoded transaction, bank timing
2. If can't resolve by Day 5: status `held`; document the variance with size + nature; Sterling decides whether to close with note or extend close

### Cash Runway Drops Below 90 Days

1. Immediate Jane alert
2. Horizon prepares scenarios: cost reduction, revenue acceleration, financing options
3. Jane decides; Sterling executes; weekly tracking until back above 180d

### Tax Deadline Missed

1. Garrison transitions to `missed`; opens linked exception
2. Engage external CPA / tax service immediately
3. Estimate penalty exposure
4. File ASAP; document corrective + preventive action
5. Sterling reports to Jane

### Below-Floor Margin Persistent

1. Margin opens `pricing_decision` with corrective recommendation
2. Sterling reviews; coordinates with Sales (Director of Sales)
3. Either price up, cost down, or formal channel exit conversation

### Vendor Payment Failed

1. Ledger surfaces in `#acme-finance-alerts`
2. Common causes: bank rejection, ACH return, frozen vendor account
3. Sterling decides retry / cancel / void; no auto-retry

### Routine Failure

1. Check routine status at `claude.ai/code/routines`
2. Trigger manually if needed
3. Daily reconciliation missed? Trigger Ledger's daily routine
4. Weekly runway missed? Trigger Horizon's Monday routine

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single reconciliation variance, one late vendor reminder | Next business day |
| Medium | AR > 30d concentrated, single missed deadline, exception > $1K | Within 4 hours |
| High | Cash < 60 days runway, banking issue, fraud-suspect transaction | Within 1 hour |
| Critical | Ledger corruption, multiple control failures, regulatory notice | Immediately |

### Incident Steps

1. Assess severity
2. If critical: activate emergency stop immediately
3. Investigate root cause (read ledger + accounting system)
4. Resolve or escalate to Jane
5. Log exception with root cause + corrective + preventive
6. Post resolution to `#acme-finance-alerts`

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "finance_actions_enabled": false,
  "reason": "Describe why outbound is paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-06-27T12:00:00Z"
}
```

**What stops:**

- Invoice sends
- Refunds
- Vendor payments
- Filing sends

**What continues:**

- Drafting, reconciliation, close mechanics
- Reporting, runway refresh, margin snapshots
- Ledger writes
- Compliance tracking (no filings)

### Resuming

```json
{
  "finance_actions_enabled": true,
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

### Process Performance

- Monthly close on-time rate (target: 100% by Day 5 6 PM)
- Material variances unexplained at Day 5 (target: 0)
- Forecast accuracy (actual vs base forecast, abs % delta)
- Weekly runway refresh on-time rate
- Compliance deadlines acknowledged ≥ 14 days ahead (target: 100%)
- Missed deadlines (target: 0)

### Financial Health

- Cash position trend
- Runway days trend
- Trailing 3mo avg burn
- AR aging (current / 30 / 60 / 90+)
- Gross margin by channel
- Pricing decisions per quarter
- Exception count by severity

### System Health

- Finance ledger integrity check
- Accounting system API success rate
- Banking API success rate
- Routine on-time rate
- Emergency stop activations
