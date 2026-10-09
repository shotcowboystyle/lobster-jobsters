# ACME Bonsai CEO Team (Apex) — Operations Runbook

## Overview

This runbook covers operations for the ACME Bonsai CEO team — Apex (the CEO's AI shadow), Compass (Strategy Synthesizer), Almanac (Decision Journal), Atlas (Memo Drafter), and Envoy (External Communications).

The CEO workspace is deliberately *quiet*. Most CEO work happens in Jane-driven sessions, not on cron. Only Compass and Almanac run on a schedule; Atlas and Envoy run only on Jane's explicit ask.

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-ceo-decisions` for last evening's decision entries needing your `ack`
2. Check `#acme-ceo-strategy` for any overnight pattern notes
3. Check `#acme-ceo-alerts` for any external-comm failures or stale-memo roll-ups

### Throughout the Day

1. When you make a meaningful decision in conversation with Apex, expect Almanac to draft a journal entry that evening — be ready to ack or edit
2. When you ask Atlas for a memo, expect a draft within 24 hours (longer for board materials)
3. When you ask Envoy to draft an outbound, expect a draft within a few hours

### Evening (6:00 PM ET)

1. Almanac runs the daily decision-capture sweep at 6:00 PM and the outcome-window check at 6:15 PM — review draft entries and outcome reminders
2. Apex's stale-memo / stale-comm sweep runs at 7:00 PM — clear the backlog or extend deadlines

---

## Weekly Operations

### Sunday Evening

1. Compass runs the weekly strategic question at 9:00 PM ET
2. Almanac runs the pattern-surfacing note at 9:30 PM ET
3. Read both in `#acme-ceo-strategy`
4. Answer the question when ready — no SLA, but the longer you defer the more the trade-off may shift

---

## Decision Capture

### Approving Drafts

| Action | What Happens |
|--------|-------------|
| `ack` | Decision entry locks in as written |
| `edit <notes>` | Almanac redrafts with your corrections |
| `drop <reason>` | Entry archived without journaling |

### Recording Outcomes

When Almanac reopens an entry at its outcome window:

| Action | What Happens |
|--------|-------------|
| `outcome <text> (better / as_expected / worse / different_axis)` | Recorded; status → `outcome_captured` |
| `inconclusive <reason>` | Recorded; status → `outcome_inconclusive` |
| Silence > 7 days | Auto-transition to `outcome_inconclusive` |

Always include a one-line reflection — it's where the journal becomes valuable over time.

---

## Memo Drafting

### Requesting a Memo

Tell Apex: "Atlas, draft me a/an X for Y audience. Soft cap: Z words. Deadline: …"

Atlas drafts and posts to `#acme-ceo-memos` for review.

### Review Actions

| Action | What Happens |
|--------|-------------|
| `approve` | Status → `approved`; can deliver |
| `edit <notes>` | Status → `revising`; Atlas redrafts |
| `hold` | Memo parked; pick up later |
| `reject` | Memo archived as `rejected`; not delivered |

### Delivery

After `approve`, tell Atlas `deliver` to mark it final. If external, hand to Envoy as a linked comm.

---

## External Comm Drafting

### Requesting a Comm

Tell Apex: "Envoy, draft a note to X about Y." Specify the stakeholder kind and channel.

Envoy looks up the stakeholder record, drafts subject + body, posts to `#acme-ceo-memos`.

### Review Actions

| Action | What Happens |
|--------|-------------|
| `approve` | Status → `approved`; Envoy queues for send |
| `edit <notes>` | Status → `revising`; Envoy redrafts |
| `hold` | Comm parked |
| `reject` | Comm archived as `rejected`; never sent |

### Send

Approved comms send automatically with the idempotency key in place. On send-failure, Envoy alerts `#acme-ceo-alerts` and waits for your decision (`retry`, `void`, `redraft`).

---

## Adding a Stakeholder

Tell Apex: "Add Jane Doe from BankCo as a bank contact." Envoy drafts a `stakeholder-record` entry and posts to `#acme-ceo-memos`. Reply `approve` to add.

---

## Common Failures

### External Comm Send Failure

1. Check `#acme-ceo-alerts` for the failure reason
2. Common causes:
   - Recipient email bounced → fix in `data/stakeholder-records.jsonl`, redraft, resend
   - Provider rate limit → wait, retry
   - Provider authentication failure → check `EMAIL_PROVIDER_API_KEY`
3. Envoy never auto-retries — you decide

### Stale Memo in `ceo_review`

1. Daily 7 PM sweep posts to `#acme-ceo-alerts`
2. Decide per memo: `approve`, `edit`, `hold`, or `reject`
3. Memos do not auto-progress

### Compass Has No Question

1. If Compass posts "no strong signals this week — deferring", that's fine
2. If Compass produces a weak/forced question, edit the heuristics in `prompts/weekly-strategic-question.md`
3. Quality over quantity always

### Almanac Captures Too Much

1. If daily drafts include obvious non-decisions, tighten the "meaningful" filter in `prompts/decision-capture.md`
2. Use `drop <reason>` aggressively for the first month — Almanac learns from corrections

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single memo stale, one decision un-acked | Next business day |
| Medium | External comm failure, stakeholder record discrepancy | Within 4 hours |
| High | Multiple comm failures, suspected unauthorized send attempt | Within 1 hour |
| Critical | Ledger corruption, leaked outbound, regulatory notice | Immediately |

### Incident Steps

1. Assess severity
2. If critical: activate emergency stop immediately
3. Investigate root cause (read the ledger directly)
4. Resolve or capture as a decision entry
5. Post resolution to `#acme-ceo-alerts`

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "external_comms_enabled": false,
  "reason": "Describe why outbound is paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-06-27T12:00:00Z"
}
```

**What stops:**

- Envoy outbound sends (drafts continue)
- Atlas memo `delivered` transitions for external memos
- Stakeholder additions

**What continues:**

- Compass weekly synthesis (internal)
- Almanac decision capture (internal)
- Atlas memo drafting (cannot transition to delivered)
- Ledger writes

### Resuming

Edit `config/emergency-stop.json`:

```json
{
  "external_comms_enabled": true,
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

### Decision Quality

- % of decisions with outcome captured (target: ≥80%)
- % of decisions where `would_decide_again = same` (calibration signal)
- Median time from `outcome_window_end` to `outcome_captured`
- Ratio of `reversible` : `hard_to_reverse` : `irreversible` decisions (sanity check)

### Strategic Throughput

- Weekly questions answered vs. deferred vs. dropped
- Median time-to-answer per question
- Patterns surfaced per quarter

### External Comms

- Comms sent per quarter by stakeholder kind
- Send failure rate
- Average revision rounds per comm
- Stakeholder records added per quarter

### System Health

- CEO ledger integrity check pass rate
- Compass weekly run on-time rate
- Almanac daily sweep completeness
- Emergency stop activations
