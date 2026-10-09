# ACME Bonsai Chief of Staff — Operations Runbook

## Overview

This runbook covers daily and weekly operations for the ACME Bonsai executive office team (River, Heron, Wren, Magpie, Egret).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-exec-briefings` for the morning briefing (Mon: weekly; others: ad-hoc)
2. Acknowledge briefings — Jane replies `ack`
3. Review overnight `#acme-exec-actions` follow-ups
4. Check `#acme-exec-alerts` for any anomaly notifications

### Throughout the Day

1. Monitor `#acme-exec-actions` for owner replies and follow-up cadence
2. Monitor `#acme-exec-alerts` for Magpie's anomaly surfaces and escalations
3. Approve action-item drops and reassignments
4. Respond to River's cross-team escalations

### Evening (6:00 PM ET)

1. Review tomorrow's meeting agendas posted to `#acme-exec-briefings`
2. Approve, edit, or hold agendas (must complete 24h before meeting)
3. Check open action-item roll-up

---

## Weekly Operations

### Monday Morning

1. Read the weekly briefing in `#acme-exec-briefings` (auto-published 7 AM)
2. Note any directives for River
3. Set or confirm initiative-sponsor assignments

### Friday Afternoon

1. Read the mid-week briefing (auto-published 4 PM)
2. Identify blockers carried into next week

### Sunday Evening

1. Reply to sponsor pings from Egret (`#acme-exec-initiatives`)
2. Set traffic-light color and one-line "why" for every active initiative
3. Review the published dashboard (8 PM)

---

## Briefing Approval

### Briefing Actions

| Action | What Happens | When to Use |
|--------|-------------|-------------|
| `ack` | Briefing transitions to `acknowledged` | You've read it |
| `edit <notes>` | Returns to Heron with revision notes | Content needs changes |
| `hold` | Briefing parked; not published | Wait for more data |
| `retract` | Published briefing pulled | Found an error post-publish |

### Briefing Best Practices

- Publish window: weekly 7–9 AM Mon, mid-week 4–6 PM Fri
- ≤400 words; if it's longer, push back
- Verify every metric has a `ledger_reference`
- Approve within 2 hours of draft posting

---

## Action-Item Handling

### Owner Actions

| Action | What Happens |
|--------|-------------|
| `in_progress` | Status moves; deadline still in effect |
| `blocked <reason>` | Status moves; deadline holds; Wren follows up daily |
| `done <note>` | Status moves to `done`; closes the item |
| `drop <reason>` | Status moves to `dropped`; closes the item |
| `extend <new_date>` | Coordinator sets new deadline if reasonable |

### Follow-Up Cadence

- +24h after deadline: first ping
- +48h after deadline: second ping with River copied
- +72h after deadline: escalation to River with structured roll-up

---

## Initiative Handling

### Sponsor Actions (weekly ping)

| Action | What Happens |
|--------|-------------|
| `green <why>` | Healthy; on track |
| `yellow <why>` | At risk; sponsor explains |
| `red <why>` | Off track; River will surface to Jane |
| `no update` | Carries forward previous color; `stall_flag` if > 14 days |
| `closed` | Sponsor reports done; verify success criteria |
| `cancelled` | Sponsor reports cancellation with rationale |

---

## Common Failures

### Briefing Missing Source Team Data

1. Magpie should have flagged the source team as red/yellow earlier
2. Heron generates the briefing with the gap explicitly called out: "CFO weekly: not yet posted — last data X days old"
3. Jane decides whether to publish or hold

### Action Item Owner Unreachable

1. After +72h escalation, River decides to reassign, drop, or escalate to Jane
2. Reassignment requires the new owner's acknowledgement

### Initiative Sponsor Silent

1. Egret defaults to "no update; carry forward previous color"
2. `stall_flag` triggers if > 14 days unchanged
3. River notes the stall in the next weekly briefing

### Agent Health Sweep Detects Red

1. Magpie posts to `#acme-exec-alerts` immediately
2. River triages: contact the workspace owner; do NOT restart the agent
3. If no response within 4h, River escalates to Jane

### Routine Failure

1. Check routine status at `claude.ai/code/routines`
2. Trigger manually if needed
3. If a sweep, briefing, or initiative ping is missed, log it as an incident

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single briefing late, one owner silent | Next business day |
| Medium | Agent health degraded yellow, multiple owners silent | Within 4 hours |
| High | Agent health red, initiative status uncollected company-wide | Within 1 hour |
| Critical | Multiple agent workspaces red, exec ledger corruption | Immediately |

### Incident Steps

1. Assess severity
2. If critical: activate emergency stop immediately
3. Investigate root cause (read affected workspace's ledger directly)
4. Resolve or escalate to Jane
5. Log incident
6. Post resolution to `#acme-exec-alerts`

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "escalations_enabled": false,
  "reason": "Describe why escalations are paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-04-19T12:00:00Z"
}
```

**What stops:**

- River, Wren, Magpie, Egret outbound Discord posts
- Heron publishing briefings (drafting continues)
- Action-item follow-up pings
- Initiative sponsor pings

**What continues:**

- Drafting, review, ledger writes
- Agent health polling (logging only)
- Internal planning

### Resuming

Edit `config/emergency-stop.json`:

```json
{
  "escalations_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "Describe why escalations are resumed",
  "resumed_by": "Your name",
  "resumed_at": "2026-04-19T14:00:00Z"
}
```

---

## Metrics to Track

### Process Performance

- Briefing publish on-time rate (Mon 7am, Fri 4pm)
- Action item median time-to-done
- Action item escalation rate (% of items hitting +72h)
- Initiative stall rate (% with `stall_flag = true`)
- Agent health overall status trend

### System Health

- Agent-health sweep completeness (% of workspaces successfully polled)
- Ledger integrity check pass rate
- Cross-team escalation response time (median, p95)
- Emergency stop activations
