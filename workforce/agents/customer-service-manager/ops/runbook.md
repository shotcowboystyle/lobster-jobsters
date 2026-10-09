# ACME Bonsai Customer Service Manager Team (Poppy) — Operations Runbook

## Overview

This runbook covers daily, weekly, and monthly operations for the ACME Bonsai customer service team — Poppy (CSM), Pearl (Support), Oakley (Order Management), Maple (Care Education).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-care-alerts` for overnight legal triggers / viral risk / major-account at-risk / patterns
2. Review daily ticket triage (Pearl, 8 AM) — first-response SLA, escalations
3. Review daily order issue sweep (Oakley, 9 AM) — open + new
4. Review daily care consultation follow-ups (Maple, 10 AM) — species patterns flagged
5. Run daily proactive customer health check (Poppy, 11 AM) — at-risk signals

### Throughout the Day

1. Customer replies flow into open tickets — status advances
2. Refund proposals surface in `#acme-care-tickets` for Poppy review
3. Order issue resolutions surface for cross-team coordination
4. Care consultations route to Maple
5. Poppy escalates above-threshold items to Jane

### Evening (6:00 PM ET)

1. Day-end check on tickets approaching 24h resolution SLA
2. Review tomorrow's scheduled follow-ups + check-ins
3. Verify next-morning routines armed

---

## Weekly Operations

### Monday Morning

1. **9:00 AM**: Poppy runs trending issues analysis; escalates patterns to Jane

### Friday Afternoon

1. **4:00 PM**: Poppy runs weekly customer health report; cross-posts to Jane + CMO + DoS

---

## Monthly Operations

### Day 1 (10:00 AM ET)

1. Poppy compiles voice-of-customer report
2. Themes from customer feedback this month
3. Product / operational / service gaps
4. Bright spots
5. Recommended operational changes
6. Posts to `#acme-care-approvals` for Jane + operating teams

---

## Approval Decisions

### Refunds + Credits

| Amount | Approval Path |
|--------|--------------|
| ≤ $200 (store credit / fee waiver) | Poppy |
| ≤ $500 (refund) | Poppy |
| > $500 (refund) | Jane |
| Replacement tree (verified quality issue) | Poppy approves; coordinate with Tally |

### Rental Damage

| Amount | Approval Path |
|--------|--------------|
| ≤ $300 | Cedar (COO) handles via damage_assessment in rental_jobs |
| > $300 | Jane approval |

### Other Escalations

| Scenario | Approval Path |
|----------|--------------|
| Subscription cancellation save | Poppy + Jane |
| Major-account save concession | Jane |
| Legal language response | Jane |
| Media / social escalation response | Jane + CMO |
| Pattern-issue corrective action | Jane + operating team owner |
| External attorney engagement | Jane (legal counsel direct) |

---

## Common Failures

### First-Response SLA Miss

1. Pearl flagged in daily triage report
2. Identify root cause: volume spike / agent issue / channel monitoring gap
3. Apologize to affected customers; explain delay
4. If systemic: surface to Poppy for capacity discussion with Jane

### Tree Health Decline Despite Intervention

1. Maple identifies during follow-up
2. Maple escalates to Poppy with prescription history + decline timeline
3. Options:
   - Continued intervention with adjusted prescription
   - Replacement tree (verified quality issue)
   - Customer education on tree care realities
4. Document outcome; root cause if quality issue

### Customer with > 3 Contacts Same Issue

1. Heartbeat surfaces; Poppy reviews
2. Identify why unresolved: missing context / cross-team handoff failure / fundamental disagreement
3. Direct Poppy outreach to customer
4. Escalate to Jane if cannot be resolved within Poppy's authority

### Refund Pattern Spike

1. Trending issues analysis identifies
2. Open feedback entry routed to responsible operating team
3. Jane approves corrective action
4. Track refund rate by category trailing 4-week

### Major Account Threatening Cancellation

1. Daily proactive check or direct customer contact
2. Immediate alert in `#acme-care-alerts` to Jane + Cash (DoS)
3. Discovery call within 24h
4. Save plan with concession approval from Jane
5. Execute save plan; track outcome
6. If save fails: graceful cancellation + voice-of-customer feedback

### Legal Language Detected

1. Pearl flags immediately — no automated response sent
2. Poppy reviews; Jane briefed within 1h
3. Jane decides: respond with approved wording / engage external attorney / acknowledge only
4. All correspondence logged; preserve evidence
5. Postmortem after resolution

### Viral / Media Risk

1. Pearl flags or Maple flags during care consultation review
2. Immediate alert to Jane + CMO
3. Coordinated response (CMO leads brand voice; Poppy leads customer service)
4. Don't engage public until coordinated response approved
5. Direct outreach to original customer parallel to public response

### Species-Specific Health Pattern

1. Maple flags during care consultations (≥ 3 customers, 30 days)
2. Route to Tally (COO Inventory) — investigate sourcing, quarantine if needed
3. Route to Mira (Creative Director Educational Content) — update care guide if education gap
4. Track until pattern resolves

---

## Cross-Team Coordination

### Care Consultation → Care Guide Update

1. Maple identifies care guide gap or outdated guidance
2. Open customer_feedback entry routed to Creative Director
3. Mira drafts updated guide
4. Care Education team (CSM) provides technical review
5. Masahiko approves brand
6. Updated guide published; existing customers notified if relevant

### Order Issue → Operational Improvement

1. Oakley spots pattern (3+ same issue in 7 days)
2. Open customer_feedback entry routed to responsible team:
   - Delivery issue → Cedar (COO)
   - Inventory issue → Tally (COO)
   - Billing issue → Sterling (CFO) + Margin (if pricing)
   - Wholesale issue → Rowan (Contract Coordinator)
3. Responsible team commits to corrective action; tracked in escalation card
4. Reduction in pattern verified after 30 days

### Subscription Save → DoS Coordination

1. Sophia (DoS) is primary on subscription contracts
2. CSM detects churn risk; opens escalation card routed to Sophia + Cash
3. Joint save plan: Sophia leads commercial terms; Poppy leads service recovery
4. Jane approves concessions above thresholds

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single missed SLA, minor billing dispute | Next business day |
| Medium | Repeated unresolved, large refund request, pattern emerging | Within 4 hours |
| High | Legal language, viral risk, major-account at-risk | Within 1 hour |
| Critical | Active lawsuit threat, regulatory complaint, mass quality issue | Immediately |

### Incident Steps

1. Assess severity
2. If critical: legal counsel engaged immediately if applicable
3. Investigate root cause
4. Resolve or escalate to Jane
5. Log incident outcome
6. Post resolution to `#acme-care-alerts`

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "outbound_replies_enabled": false,
  "reason": "Describe why outbound is paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-06-28T12:00:00Z"
}
```

**What stops:**

- All customer-facing replies
- Refund execution
- Replacement tree dispatch
- Proactive outreach (health check-ins)
- Care follow-ups

**What continues:**

- Internal triage + investigation
- Drafting
- Ledger writes
- Cross-team coordination
- Escalations to Jane

### Resuming

```json
{
  "outbound_replies_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "Describe why outbound is resumed",
  "resumed_by": "Your name",
  "resumed_at": "2026-06-28T14:00:00Z"
}
```

---

## Metrics to Track

### Service Quality

- First-response SLA (target: > 95% within 2h)
- Resolution SLA (target: > 90% within 24h)
- CSAT trend (target: > 4.5/5)
- Repeat-contact rate (target: < 10%)
- Escalation rate (target: appropriate, not too high or low)

### Customer Health

- Active subscription health distribution (green / yellow / red)
- Subscription churn rate driven by service quality (target: < 5% annual)
- Wholesale repeat-buyer rate
- Major-account at-risk count
- Post-delivery check-in completion rate

### Operational Insights

- Tickets by category trend (week / month / quarter)
- Refund rate by category
- Pattern issues identified and corrective actions completed
- Care consultation outcome rate (confirmed healthy %)
- Species pattern detections per quarter

### Financial Impact

- Refunds + credits issued (count + total $)
- Replacement trees dispatched (count)
- Save concessions value vs revenue retained
- Cost-per-ticket trend

### System Health

- Care ledger integrity check
- Outbound action send success rate
- Cross-team handoff completion rate
- Routine on-time rate
- Emergency stop activations
