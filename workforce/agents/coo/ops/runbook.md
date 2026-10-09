# ACME Bonsai COO Team (Victor) — Operations Runbook

## Overview

This runbook covers daily, weekly, and monthly operations for the ACME Bonsai operations team — Victor (COO), Tally (Inventory), Cedar (Logistics), Hazel (Workshops), Birch (Facility).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-ops-alerts` for overnight env / mortality / delivery failures
2. Review daily environmental check (Birch, 6 AM)
3. Review daily inventory reconciliation + health scan (Tally, 7 AM)
4. Review delivery confirmation sweep (Cedar, 8 AM); approve any exceptions
5. Review workshop reminder sweep (Hazel, 9 AM)

### Throughout the Day

1. Pricing requests from Sales surface via Tally for availability checks
2. Delivery exceptions surface in `#acme-ops-fulfillment`
3. Workshop registrations flow into Hazel's queue
4. Facility incidents flow from Birch into Victor's triage
5. Victor escalates above-threshold items to Jane

### Evening (6:00 PM ET)

1. Day-end check on tomorrow's deliveries + workshops
2. Note any items rolling to tomorrow
3. Verify next-morning routines are armed

---

## Weekly Operations

### Sunday Afternoon (4 PM ET)

1. Hazel refreshes rolling 3-month workshop calendar
2. Confirm instructor availability for next 4 weeks
3. Coordinate with CMO on workshop promotion 4-6 weeks ahead

### Monday Morning (8 AM ET)

1. Cedar posts proposed routes for next week
2. Victor reviews; approves before customer-facing communication

### Friday Morning (10 AM ET)

1. Birch performs safety walkthrough
2. Logs any incidents

### Friday Afternoon (4 PM ET)

1. Tally publishes weekly inventory snapshot
2. Shared with Sterling (CFO) for close + Director of Sales for pipeline

---

## Monthly Operations

### Day 1 (10 AM ET)

1. Birch performs structured equipment inspection
2. HVAC, watering, greenhouse, lights, sensors, van
3. Items needing repair $1K–$5K: open incident with Jane approval required
4. Items > $5K: open incident with mandatory Jane approval

---

## Approval Decisions

### Inventory

| Scenario | Approval Path |
|----------|--------------|
| Routine reservation | Auto |
| Reallocation away from confirmed customer | Victor |
| Shortfall on confirmed commitment | Victor + Jane |
| Mortality > 2% in 30 days | Jane immediate alert |

### Deliveries / Rentals

| Scenario | Approval Path |
|----------|--------------|
| Routine confirmation | Auto (Cedar) |
| Route approval | Victor |
| Rental damage ≤ $300 | Process automatically |
| Rental damage > $300 | Jane approval |
| Delivery failure remediation | Victor |

### Workshops

| Scenario | Approval Path |
|----------|--------------|
| Routine confirmation | Auto (Hazel) |
| Under-minimum within 2 weeks | Victor |
| Cancellation | Jane approval |

### Facility

| Scenario | Approval Path |
|----------|--------------|
| Routine maintenance | Auto (Birch) |
| Intervention < $1K | Birch + Victor sign-off |
| Intervention $1K–$5K | Jane approval |
| Major repair > $5K | Jane approval |
| Environmental failure | Birch executes mitigation immediately; logs incident |

---

## Common Failures

### Mortality Spike

1. Tally alerts Jane in `#acme-ops-alerts`
2. Cross-reference with Birch's environmental data
3. Pull species/zone clusters from last 30 days
4. Document root cause (environmental, pest, treatment failure)
5. Implement corrective action; document preventive action
6. Track resolution in weekly snapshot

### Environmental System Failure

1. Birch confirms not a sensor malfunction
2. Activate backup systems immediately
3. Tally rechecks affected trees
4. Open facility_incident; status `detected → triaged → in_progress`
5. If > $1K: escalate to Jane
6. Resolve before any tree mortality

### Late Delivery

1. Cedar notifies customer proactively
2. Offer remediation (discount, expedited future, redelivery)
3. Document delivery_job as `failed` with `failure_reason`
4. Open follow-up: was it inventory, route, customer-unavailable, equipment?

### Rental Damage Dispute

1. Cedar documents before/after photos + damage assessment
2. If estimated > $300: escalate to Victor → Jane
3. Decision: approve assessment, edit, or waive
4. Document outcome; update deposit refund logic

### Workshop Under Minimum

1. Hazel flags 2 weeks out
2. Options: promote (with CMO), push date, comp existing registrants, cancel
3. Victor reviews; Jane approves cancellation

### Facility Emergency (Weather, Pest, Disease)

1. Birch immediate response: secure, quarantine, contain
2. Open facility_incident with critical severity
3. Jane alert immediate
4. Document mitigation; coordinate with Tally on affected trees
5. Post-incident: root cause + preventive action

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single bulb out, minor sheet drift | Next business day |
| Medium | Single sensor failure, missed reminder, registration under min | Within 4 hours |
| High | HVAC partial failure, late delivery, workshop materials gap | Within 1 hour |
| Critical | HVAC full failure, mortality > 2%, weather damage, safety incident | Immediately |

### Incident Steps

1. Assess severity
2. If critical: activate emergency stop immediately if outbound exposure
3. Investigate root cause (read ledger + sensors + sheet)
4. Resolve or escalate to Jane
5. Log incident with root cause + corrective + preventive
6. Post resolution to `#acme-ops-alerts`

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "ops_actions_enabled": false,
  "reason": "Describe why outbound is paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-06-27T12:00:00Z"
}
```

**What stops:**

- Cedar delivery + rental dispatches
- Hazel confirmations + reminders
- Tally's outward `allocated` transitions
- Birch intervention purchases

**What continues:**

- Internal inventory, environmental, safety monitoring
- Ledger writes
- Drafting + reporting

### Resuming

```json
{
  "ops_actions_enabled": true,
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

### Inventory Health

- Total trees on hand
- Available vs reserved vs allocated counts
- Health distribution (A/B/C/quarantine)
- Trailing 30-day mortality rate (target: < 2%)
- Safety threshold breaches per week

### Delivery + Rental Performance

- On-time delivery rate (target: > 95%)
- Average lead time from `scheduled` to `closed`
- Rental damage rate
- Damage disputes per quarter
- Routes optimized (miles vs straight-line)

### Workshop Performance

- Registration fill rate per session
- Attendance vs no-show rate
- Average satisfaction score
- Repeat attendee rate

### Facility Health

- Environmental in-range rate per zone
- Facility incidents by severity per month
- Average resolution time per severity
- Maintenance spend trend
- Equipment uptime

### System Health

- Ops ledger integrity check
- Sheet sync latency
- Sensor uptime
- Routine on-time rate
- Emergency stop activations
