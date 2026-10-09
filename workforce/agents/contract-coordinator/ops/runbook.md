# ACME Bonsai Contract Coordinator — Operations Runbook

## Overview

This runbook covers daily and weekly operations for the ACME Bonsai wholesale Contract Coordinator team (Rowan, Sage, Finch, Grove, Miles).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-contracts-approvals` for any pending escalations from yesterday
2. Review the daily signature sweep summary in `#acme-contracts-drafts` (auto-generated at 8 AM)
3. Review the daily payment reconciliation in `#acme-contracts-drafts` (auto-generated at 8:30 AM)
4. Review the daily inventory snapshot in `#acme-contracts-drafts` (auto-generated at 9 AM)
5. Review the balance-due notice sweep (auto-generated at 9:30 AM) — approve, edit, or hold each draft

### Throughout the Day

1. Monitor `#acme-contracts-drafts` for contract drafts and invoice drafts needing review
2. Act on drafts: `approve`, `edit <notes>`, `hold`, or `reject`
3. Monitor `#acme-contracts-approvals` for CEO escalations needing your call
4. Monitor `#acme-contracts-alerts` for payment failures and ledger anomalies
5. Respond to buyer email replies routed by Miles

### Evening

1. Check for unanswered escalations from the day
2. Review stalled-deal triage (every 12h at 8 PM)
3. Note any directives or changes for tomorrow's routine

---

## Weekly Operations

### Sunday Evening

1. Review the weekly route plan delivered to `#acme-contracts-delivery` (auto-generated at 5 PM)
2. Approve, edit, or hold the proposed routes for the coming week
3. Note any special delivery requests or schedule constraints

### Monday Morning

1. Confirm approved routes are dispatched to the loading crew
2. Verify that per-buyer ETA emails are queued for review

---

## Escalation Decisions

### Decision Reference

| Action | What Happens | When to Use |
|--------|-------------|-------------|
| `approve` | Action proceeds (contract sent, invoice issued, route emailed) | Content is ready as-is |
| `edit <notes>` | Returns to sub-agent with your notes | Content needs changes |
| `hold` | Action parked; reminder in 24h | Need more info or timing isn't right |
| `reject` | Action archived, not taken | Action shouldn't happen |
| `defer <reason>` | Escalation snoozed for later | Decision needs more data |

### Escalation Best Practices

- Reply within 12 hours when possible
- For contract escalations > $5K: verify buyer history before approving
- For inventory shortfalls: check Grove's proposed substitute before deciding
- For payment failures: contact the buyer directly before voiding
- For route changes mid-dispatch: weigh buyer trust vs. operational cost

### Escalation Timeouts

- 12 hours: reminder posted
- 24 hours: re-pinged with summary
- 48 hours: status → `timed_out`, contract held pending decision
- Timeouts NEVER auto-approve

---

## Common Failures

### DocuSign Envelope Stuck

1. Check the envelope ID in DocuSign directly
2. Common causes:
   - Buyer email bounced → ask buyer for correct email, void and resend
   - Buyer hasn't viewed → first reminder at +48h, escalate at +5d
   - Buyer viewed but didn't sign → call buyer, then escalate
3. Sage retries automatically (up to 3 attempts on transient API errors)
4. Persistent failures → escalate to Rowan, then Jane

### Stripe / ACH Payment Failure

1. Check error message in `#acme-contracts-alerts`
2. Common causes:
   - Card declined → contact buyer for alternate method
   - ACH return → contact buyer; banking error usually self-resolves
   - Webhook delivery failure → manually verify in Stripe dashboard
3. System does NOT auto-pause the contract — Rowan decides

### Google Maps API Rate Limit

1. Symptoms: routing failures in `#acme-contracts-delivery`
2. Solution: Miles caches geocoded addresses for 90 days — verify cache hit rate
3. If rate limit persists: contact CTO, may need to request higher quota

### Inventory Sheet Out of Sync

1. Symptoms: Grove reports overselling or phantom reservations
2. Solution:
   - Take a snapshot of current sheet state
   - Cross-reference with `inventory_reservations` table in the ledger
   - Reconcile manually, then post a fixed snapshot
3. Future protection: enable Google Sheets revision history; add a daily integrity check

### Routine Failure

1. Check routine status at `claude.ai/code/routines` or Claude Desktop sidebar
2. Trigger manually if needed
3. Missing signature sweep? Trigger "Daily Signature Sweep"
4. Missing payment reconciliation? Trigger "Daily Payment Reconciliation"

### Bot Not Posting to Discord

1. Check Discord bot status and permissions
2. Verify channel IDs in `config/discord-config.example.json`
3. Check bot token validity
4. Verify bot has post permission in all 4 channels

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single envelope reminder missed, minor inventory sync drift | Next business day |
| Medium | Payment failure (retriable), signature timeout, single missed route stop | Within 4 hours |
| High | DocuSign auth failure, Stripe webhook downtime, van breakdown | Within 1 hour |
| Critical | Multiple deposit failures, inventory data corruption, regulatory issue | Immediately |

### Incident Steps

1. Assess severity
2. If critical: activate emergency stop immediately
3. Investigate root cause (check ledger, sub-agent logs, external API status)
4. Resolve or escalate to Jane
5. Log incident in the `incidents` table
6. Post resolution to `#acme-contracts-alerts`

---

## Emergency Stop

### Activating Emergency Stop

Edit `config/emergency-stop.json`:

```json
{
  "contracts_enabled": false,
  "reason": "Describe why operations are paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-04-19T12:00:00Z"
}
```

**What stops:**

- All outbound contract sends (Sage)
- All deposit and balance invoices (Finch)
- All inventory `inventory_reserved` outward transitions (Grove)
- All buyer-facing delivery-window emails (Miles)

**What continues:**

- Drafting, review, and ledger writes
- Inventory snapshots (read-only)
- Internal route planning (no buyer emails)
- Escalations to Jane

### Resuming Operations

Edit `config/emergency-stop.json`:

```json
{
  "contracts_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "Describe why operations are resumed",
  "resumed_by": "Your name",
  "resumed_at": "2026-04-19T14:00:00Z"
}
```

---

## Rolling Back Outbound Actions

### Pause All Outbound

1. Activate emergency stop (see above)
2. All queued sends remain in their current ledger state

### Disable Specific Routines

1. Go to `claude.ai/code/routines` or Claude Desktop sidebar → Routines
2. Find the routine (e.g., "Daily Signature Sweep" or "Weekly Route Planning")
3. Disable the schedule trigger (or delete the routine)

### Full System Pause

1. Activate emergency stop
2. Disable all routines
3. Post notice in `#acme-contracts-alerts`
4. To resume: re-enable routines + lift emergency stop

---

## Onboarding a New Sub-Agent or Approver

1. Add their Discord user ID to `config/discord-config.example.json`
2. Update `config/approval-policy.json` with their permissions
3. Grant them access to the 4 Discord channels
4. Brief them on:
   - Approval actions
   - Hard rules (see `AGENTS.md`)
   - Emergency stop procedure
   - Escalation contacts
5. Have them shadow Rowan for 1 week
6. Start with low-risk approvals (small deposit invoices) before graduating

---

## Metrics to Track

### Contract Performance

- Inquiry → contract_sent conversion rate
- Contract_sent → contract_signed conversion rate
- Avg days from `qualified` to `closed`
- Avg total contract value
- Repeat-buyer rate

### Operational Health

- Signature pending > 48h rate
- Deposit failure rate
- Inventory shortfall rate
- Route capacity utilization
- Delivery on-time rate

### System Health

- DocuSign API error rate
- Stripe webhook latency
- Google Maps API error rate
- Ledger integrity check pass rate
- Escalation response time (median, p95)
- Emergency stop activations
