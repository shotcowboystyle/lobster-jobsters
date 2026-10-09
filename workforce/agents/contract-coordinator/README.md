# ACME Bonsai — Contract Coordinator Team

## Architecture Summary

Multi-agent OpenClaw system that runs ACME Bonsai's wholesale tree operations end-to-end: from qualified quote, through signed contract, deposit, inventory reservation, multi-stop van delivery, and final balance collection. Discord is the human coordination layer. All outbound contract, invoice, and delivery actions require explicit operator approval. The system follows a "qualify → contract → deposit → reserve → route → deliver → balance → close" pipeline.

Key principles:

- No autonomous contract sending — every contract requires explicit Coordinator approval
- No autonomous delivery scheduling — deposit must clear before a route is planned
- Safe failure mode — when uncertain, draft / flag / pause / escalate
- Auditable — every state transition logged to the contract ledger
- Idempotent outbound actions — deduplicated via idempotency keys
- Van-only fulfillment — no third-party freight, ever

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | Contract Coordinator | Rowan 🦋 | Orchestrates the team, owns buyer summary, escalates to CEO | Routine + on-demand | Sub-agents + Jane |
| 2 | Contract Specialist | Sage 🪺 | Generates wholesale purchase agreements via DocuSign | Per qualified quote | Payments Agent |
| 3 | Payments Agent | Finch 🪙 | Issues deposit invoices, tracks payments, sends balance-due notices | After contract signed; 7d before delivery | Inventory & Orders / Coordinator |
| 4 | Inventory & Orders | Grove 🌱 | Reserves stock on cleared deposit; generates pick lists | After deposit paid | Delivery Router |
| 5 | Delivery Router | Miles 🛣️ | Plans multi-stop routes; estimates ETAs; emails delivery windows | After inventory reserved | Buyers + Coordinator |

---

## Contract State Machine

```
inquiry → qualified → contract_sent → contract_signed
                                          ↓
                               deposit_invoiced → deposit_paid
                                                       ↓
                                            inventory_reserved → routed
                                                                    ↓
                                              in_transit → delivered → balance_paid → closed
```

Failed variants: `contract_rejected`, `signature_expired`, `deposit_failed`, `inventory_short`, `delivery_failed`

Statuses (canonical):
`inquiry`, `qualified`, `contract_sent`, `contract_signed`, `contract_rejected`,
`signature_expired`, `deposit_invoiced`, `deposit_paid`, `deposit_failed`,
`inventory_reserved`, `inventory_short`, `routed`, `in_transit`,
`delivered`, `delivery_failed`, `balance_paid`, `closed`

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Qualify Inquiry | New inquiry email or referral | Rowan | Coordinator confirms buyer qualifies |
| B. Generate Contract | Qualified quote | Sage | Coordinator reviews draft before send |
| C. Monitor Signature | After contract sent | Sage | Reminders at +48h, +5d; escalate to Jane after +5d |
| D. Issue Deposit Invoice | After signature | Finch | Coordinator reviews invoice amount + terms |
| E. Confirm Payment | Stripe/ACH webhook | Finch | Ledger entry; alert on failure |
| F. Reserve Inventory | After deposit cleared | Grove | Coordinator verifies reservation matches contract |
| G. Plan Route | After inventory reserved + within 14d of delivery | Miles | Coordinator approves route before buyer emails |
| H. Send Delivery Window | After route approved | Miles | Coordinator signs off on email content |
| I. Reconcile Delivery | After delivery completed | Grove + Miles | Coordinator verifies all stops + pick list |
| J. Collect Balance | Day-of or day-after delivery | Finch | Coordinator confirms payment received |
| K. Close Contract | After balance paid | Rowan | Coordinator archives and adds to repeat-buyer pipeline |
| L. Escalate | Any contract > $5K or any blocker > 72h | Rowan | CEO acknowledges in `#acme-contracts-approvals` |
| M. Emergency Stop | Any time | Rowan | Operator sets `contracts_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Contract | Contracts > $5,000 total require explicit CEO escalation before send |
| Contract | No edits to standard contract templates without Coordinator review |
| Contract | Signature reminders at +48h and +5d; escalate after +5d |
| Payment | Minimum 50% deposit before delivery scheduling — no exceptions |
| Payment | Deposits > $10,000 require CFO acknowledgement in the ledger |
| Payment | Balance-due notice sent 7 days before scheduled delivery |
| Inventory | Inventory cannot be reserved until the deposit clears |
| Inventory | Never promise stock Grove has not reserved |
| Inventory | Safety threshold alerts must be acknowledged before overselling |
| Delivery | ACME van only — no third-party freight, ever |
| Delivery | No route change after delivery-window emails are sent without CEO approval |
| Delivery | Van capacity is a hard constraint, not a target |
| Operational | No publishing without explicit human approval |
| Operational | All state transitions logged to the contract ledger |
| Data | No credential access from prompts (DocuSign, Stripe, Google Maps tokens live outside the workspace) |
| Crisis | High-risk content (legal disputes, force majeure events, ag/import restrictions) → mandatory CEO review |

---

## RACI Table

| Activity | Rowan | Sage | Finch | Grove | Miles | Jane (CEO) | CFO |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Qualify inquiry | R | — | — | — | — | A | — |
| Generate contract draft | C | R | — | — | — | I | — |
| Approve contract send | A/R | I | — | — | — | A (if >$5K) | — |
| Monitor signature | R | R | — | — | — | I | — |
| Issue deposit invoice | A | — | R | — | — | I | A (if >$10K) |
| Confirm deposit paid | I | — | R | — | — | I | — |
| Reserve inventory | A | — | — | R | — | — | — |
| Plan delivery route | A | — | — | C | R | — | — |
| Send delivery window | A | — | — | — | R | I | — |
| Reconcile delivery | A | — | — | R | R | I | — |
| Collect balance | A | — | R | — | — | I | — |
| Close contract | R | — | — | — | — | I | — |
| Emergency stop | R | I | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-contracts-drafts` | Quote summaries, contract drafts, deposit invoices for review | Sage + Finch post; Rowan + Jane review |
| `#acme-contracts-approvals` | CEO escalations: contracts > $5K, inventory shortfall, mid-transit route changes | Rowan posts; Jane acts |
| `#acme-contracts-delivery` | Route plans, delivery-window emails, pick lists | Miles + Grove post; Rowan + Jane review |
| `#acme-contracts-alerts` | Payment failures, signature timeouts, emergency-stop events, ledger anomalies | All agents post; Rowan + Jane triage |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "contracts_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `contracts_enabled` is set to `false`:

1. Sage refuses to send contracts via DocuSign
2. Finch refuses to issue invoices or send balance-due notices
3. Grove can still update inventory but does not transition `inventory_reserved` outward
4. Miles can still plan routes internally but does not send delivery-window emails
5. All agents continue drafting / reviewing / logging (pipeline stays warm)
6. Discord alert posted to `#acme-contracts-alerts`: "🛑 CONTRACTS PAUSED: {reason}"

To resume: set `contracts_enabled: true`, post confirmation to Discord.

---

## Idempotency Strategy

Every outbound side-effect gets an idempotency key. Format and ledger lookup are documented in `AGENTS.md`. The contract ledger is the authoritative store.

---

## High-Risk Content Detection Checklist

Sage and Rowan flag any contract for mandatory CEO escalation if ANY of these are detected:

- [ ] Total contract value > $5,000
- [ ] Buyer in a state with restrictive ag/import laws (CA, HI, AZ, FL — confirm current list with CEO)
- [ ] Custom clauses beyond the standard wholesale template
- [ ] Buyer requests deposit < 50% or net-terms billing
- [ ] Buyer requests delivery outside the standard ACME van service area
- [ ] Buyer is a competing nursery or designer who could resell
- [ ] Buyer has a prior `contract_rejected`, `deposit_failed`, or `delivery_failed` history
- [ ] Buyer is a government, school, or nonprofit entity (requires W-9 + alt invoice flow)
- [ ] Buyer requests indemnification, IP, or confidentiality clauses
- [ ] Quote includes species flagged as low inventory by Grove

---

## Recommended File Tree

```
workforce/agents/contract-coordinator/
├── README.md                          # This file
├── IDENTITY.md                        # Coordinator identity
├── SOUL.md                            # Persona + boundaries
├── AGENTS.md                          # Operating instructions
├── USER.md                            # Operator profile
├── HEARTBEAT.md                       # Periodic checks
├── MEMORY.md                          # Curated long-term memory
├── agents/                            # Each sub-agent is its own OpenClaw sub-workspace
│   ├── contract-specialist/           # Sage
│   ├── payments-agent/                # Finch
│   ├── inventory-orders/              # Grove
│   └── delivery-router/               # Miles
├── schemas/
│   ├── contract-request.schema.json
│   ├── wholesale-agreement.schema.json
│   ├── deposit-invoice.schema.json
│   ├── inventory-reservation.schema.json
│   ├── pick-list.schema.json
│   ├── route-plan.schema.json
│   ├── delivery-eta.schema.json
│   ├── escalation-packet.schema.json
│   └── contract-ledger.sql
├── prompts/
│   ├── contract-generation.md
│   ├── deposit-invoice.md
│   ├── inventory-check.md
│   ├── route-planning.md
│   └── escalation-summary.md
├── config/
│   ├── discord-config.example.json
│   ├── env.example
│   ├── routines.example.sh
│   ├── approval-policy.json
│   └── emergency-stop.json
├── ops/
│   └── runbook.md
└── discord-templates/
    └── message-templates.md
```

---

## Deployment Assumptions

- Claude Desktop with Claude Code Routines enabled
- Discord bot with permissions to post in the 4 designated channels
- DocuSign account with API integration (envelope-create + status-poll endpoints)
- Stripe account with payment-intent + webhook integration; ACH transfers via Stripe ACH
- Google Maps Platform: Directions API + Geocoding API (van routing)
- SQLite database for contract ledger (local to agent workspace; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Human approvers (Jane as CEO; optional CFO secondary) have Discord access and understand the approval flow
