# ACME Bonsai — Director of Sales Team (Cash)

## Architecture Summary

Multi-agent OpenClaw system that runs ACME Bonsai's revenue pipeline across four streams: wholesale (B2B), local direct, subscription display services, and event rentals. Discord is the human coordination layer. The sales ledger holds CRM data + workflow state. Inventory commitments coordinate with COO (Tally); contract execution coordinates with Contract Coordinator (Rowan); pricing decisions route through CFO (Margin); installations + deliveries coordinate with COO (Cedar).

Key principles:

- Targets are commitments; pipeline forecasts are probability-weighted
- Inventory never committed without Tally's confirmation
- Wholesale deals hand off cleanly to Rowan for contract execution
- Subscription renewal rate ≥ 90%; expansion through site-specific tailoring
- Event rentals: 50% deposit minimum; flawless coordination with Cedar
- Customer relationships are long-term; one bad deal teaches the next
- Field signals flow back to Marketing, Operations, Finance

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | Director of Sales | Cash 🐬 | Orchestrates the team; owns pipeline integrity | Routine + on-demand | Sub-agents + Jane |
| 2 | Wholesale | Wade 📦 | B2B retailer / corporate gifting relationships | Daily lead + opportunity nudge | Rowan (Contract Coordinator) |
| 3 | Local | Lily 🌿 | Walk-in / single-tree sales + care consults | Daily walk-in follow-up | Tally + Cedar |
| 4 | Subscription | Sophia 🤝 | Recurring revenue contracts + renewals | Daily renewal + churn scan | Cedar + Sterling (CFO billing) |
| 5 | Event Rental | Max 🎉 | Event bookings + rental agreements | Daily booking confirmation | Cedar (rental cycle) |

---

## State Machines

**Lead:** `received → qualified → opportunity_created → archived` (disqualified as side state)

**Opportunity (pipeline):** `discovery → proposal → negotiation → committed → won → archived` (lost as side state)

**Quote:** `drafted → sent → viewed → accepted → archived` (rejected / expired as side states)

**Subscription contract:** `prospect → site_visit → proposed → signed → active → renewing → renewed → archived` (churned as side state)

**Event booking:** `inquiry → quoted → deposit_paid → confirmed → in_progress → returned → closed → archived` (cancelled as side state)

**Local sale:** `walk_in → consult → recommended → purchased → followed_up → archived` (no_purchase as side state)

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Daily Lead Intake | Routine: 8 AM ET | All sub-agents | Cash reviews escalations |
| B. Daily Open Quote Follow-Up | Routine: 9 AM ET | All sub-agents | Cash on stalled quotes > 7d |
| C. Daily Event Booking Confirmation | Routine: 9:30 AM ET | Max | Cash on day-of changes |
| D. Daily Subscription Renewal Scan | Routine: 10 AM ET | Sophia | Cash on at-risk renewals |
| E. Daily Walk-In Follow-Up | Routine: 10:30 AM ET | Lily | Cash on cross-stream opportunities |
| F. Weekly Pipeline Review | Routine: Mon 8 AM ET | Cash | Jane acks |
| G. Weekly Wholesale Pipeline Nudge | Routine: Mon 10 AM ET | Wade | Cash on stalled > 30 days |
| H. Weekly Subscription Renewal Outreach | Routine: Mon 11 AM ET | Sophia | Cash on contracts within 60-day window |
| I. Weekly Revenue + Pipeline Report | Routine: Fri 4 PM ET | Cash | Posted to Sterling (CFO) + Jane |
| J. Wholesale Deal Won | On commit | Wade → Rowan | Rowan executes contract flow |
| K. Subscription Signed | On signature | Sophia → Cedar + Sterling | Cedar installs; Sterling sets up billing |
| L. Event Booking Confirmed | On deposit | Max → Cedar | Cedar runs rental cycle |
| M. Emergency Stop | Any time | Cash | Jane or Cash sets `sales_actions_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Inventory | Never commit without Tally's confirmation |
| Discounts | ≤ 20% off list: Cash approval |
| Discounts | 20–25% on wholesale > 100 trees: Cash approval (volume tier) |
| Discounts | > 25% or below cost: Jane approval + Margin sign-off + strategic rationale |
| Subscriptions | 12-month minimum term unless Jane approves shorter |
| Subscriptions | Renewal sponsor outreach 60 days before expiration |
| Subscriptions | Churn risk identified via quarterly satisfaction review |
| Rentals | 50% deposit minimum upfront |
| Rentals | Rental agreement signed before any tree leaves |
| Wholesale | Verbal-only commitments forbidden — all wholesale deals documented |
| Wholesale | Deals > $5,000 route to Rowan (Contract Coordinator) for execution |
| Pipeline | Forecasts are probability-weighted; no "best case" disguised as base |
| Operational | All state transitions logged to the sales ledger |
| Confidentiality | Customer information stays in this team; do not disclose across channels or to third parties |
| Personnel | Sensitive matters: 1:1 Jane only |

---

## RACI Table

| Activity | Cash | Wade | Lily | Sophia | Max | Jane | Cross-Team |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Lead intake | A | R | R | R | R | — | — |
| Quote drafting | A | R | C | R | R | — | C (Margin) |
| Inventory commitment | A | C | C | C | C | — | A (Tally) |
| Wholesale contract send | I | — | — | — | — | — | A/R (Rowan) |
| Pricing decision (≤20%) | A/R | — | — | — | — | — | C (Margin) |
| Pricing decision (>25%) | A | — | — | — | — | A (decides) | A (Margin) |
| Subscription renewal | A | — | — | R | — | I | I (Sterling) |
| Event booking | A | — | — | — | R | — | C (Cedar) |
| Pipeline forecast | A/R | C | C | C | C | A (acks) | I (CFO) |
| Major-account save | A | C | — | C | — | A/R | C |
| Customer dispute | A | — | — | — | — | A (>$1K) | — |
| Emergency stop | R | I | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-sales-drafts` | Quote drafts, opportunity reviews, subscription proposals, event quotes | All sub-agents post; Cash reviews |
| `#acme-sales-approvals` | CEO escalations: > 25% discount, < 12-mo subscription, major saves, custom terms | Cash posts; Jane acts |
| `#acme-sales-pipeline` | Weekly pipeline snapshot, weighted forecast, conversion metrics | Cash posts; Jane + Sterling review |
| `#acme-sales-alerts` | Stalled opportunities, missed quotes, churn risks, missed deposits | All agents post; Cash triages |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "sales_actions_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `sales_actions_enabled` is `false`:

1. All sub-agents refuse to send quotes, renewal pitches, follow-ups; drafts continue
2. Inventory commitments pause (no new `proposal → negotiation` transitions)
3. Wholesale handoffs to Rowan queue locally
4. Discord alert posted to `#acme-sales-alerts`: "🛑 SALES ACTIONS PAUSED: {reason}"

To resume: set `sales_actions_enabled: true`, post confirmation to Discord.

---

## Recommended File Tree

```
workforce/agents/director-of-sales/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── agents/
│   ├── wholesale-sales/          # Wade
│   ├── local-sales/              # Lily
│   ├── subscription-sales/       # Sophia
│   └── event-rental/             # Max
├── schemas/
│   ├── lead.schema.json
│   ├── opportunity.schema.json
│   ├── quote.schema.json
│   ├── closed-deal.schema.json
│   ├── subscription-contract.schema.json
│   ├── event-booking.schema.json
│   ├── local-sale.schema.json
│   ├── customer-account.schema.json
│   └── sales-ledger.sql
├── prompts/
│   ├── pipeline-review.md
│   ├── wholesale-cycle.md
│   ├── subscription-renewal.md
│   └── event-booking.md
├── config/
│   ├── emergency-stop.json
│   ├── approval-policy.json
│   ├── discord-config.example.json
│   ├── env.example
│   └── routines.example.sh
├── ops/
│   └── runbook.md
└── discord-templates/
    └── message-templates.md
```

---

## Deployment Assumptions

- Claude Desktop with Claude Code Routines enabled
- Discord bot with permissions to post in the 4 designated channels
- Email + SMS provider for quotes, follow-ups, renewal pitches
- Payment provider (Stripe) for deposits + first month
- DocuSign integration via Rowan (for wholesale contracts)
- SQLite database for the sales ledger (local; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Cash holds delegated authority within thresholds; Jane is final approver for anything above
