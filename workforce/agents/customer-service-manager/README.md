# ACME Bonsai — Customer Service Manager Team (Poppy)

## Architecture Summary

Multi-agent OpenClaw system that owns the post-purchase customer experience: support tickets, order resolution, care education, proactive retention, and the voice of the customer flowing back into the company. Discord is the human coordination layer. The care ledger holds workflow state for tickets, order issues, consultations, check-ins, feedback, refunds, and escalations. Customer records are read from the Director of Sales' sales ledger.

Key principles:

- Be proactive — monitor customer health metrics; intervene before churn
- Define success per customer; align with Sales on goals + renewal trajectories
- Renewal is an outcome of value delivered, not a sale to be made
- Pace value-added offerings to actual usage
- Bridge between customer and company — relay signals; share product context
- Harbor City hospitality at the baseline; professional throughout
- Teach with reasoning, not just instructions
- Personalized retention — no generic templates

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | CSM | Poppy 🪼 | Orchestrates the team; protects customer experience | Routine + on-demand | Sub-agents + Jane |
| 2 | Support | Pearl 🦭 | First contact; triage; resolve simple; route the rest | Daily ticket intake | Oakley / Maple / Poppy |
| 3 | Order Management | Oakley 🐕 | Order status, delivery problems, billing | Daily order issue sweep | COO Cedar / Contract Coordinator Rowan |
| 4 | Care Education | Maple 🌳 | Tree health diagnostics, prescriptions, follow-ups | Daily follow-ups | Mira (CD educational content) + Tally (species health) |

---

## State Machines

**Customer ticket:** `received → triaged → assigned → in_progress → resolved → archived` (escalated as side state)

**Order issue:** `reported → investigating → resolution_proposed → resolved → archived` (escalated as side state)

**Care consultation:** `requested → diagnosing → guidance_provided → follow_up_scheduled → confirmed_healthy → archived` (escalated as side state)

**Health check-in:** `scheduled → executed → response_received → archived` (no_response → re-attempt → escalated)

**Refund/credit:** `proposed → csm_approved → processed → archived` (ceo_approval_required → ceo_approved → processed; rejected as side state)

**Escalation card:** `opened → routed → acknowledged → resolved → archived`

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Daily Ticket Intake | Routine: 8 AM ET | Pearl | Poppy reviews escalations |
| B. Daily Order Issue Sweep | Routine: 9 AM ET | Oakley | Poppy on > $500 / > $300 rental damage |
| C. Daily Care Follow-Ups | Routine: 10 AM ET | Maple | Poppy on repeated tree-health failures |
| D. Daily Proactive Health Check | Routine: 11 AM ET | Poppy | Jane on at-risk major accounts |
| E. Weekly Trending Issues | Routine: Mon 9 AM ET | Poppy | Jane on pattern-issues + root cause |
| F. Weekly Customer Health Report | Routine: Fri 4 PM ET | Poppy | Cross-posted to Jane + CMO + DoS |
| G. Monthly Voice-of-Customer Report | Routine: Day 1 at 10 AM ET | Poppy | Jane + operating teams |
| H. Emergency Stop | Any time | Poppy | Jane or Poppy sets `outbound_replies_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Response time | First response < 2h during business hours |
| Resolution time | < 24h for most issues |
| Complex issues | Status update every 24h until resolved |
| Refunds | ≤ $500 Poppy; > $500 Jane |
| Replacement trees | Verified quality issue → Poppy approval; coordinate with Tally |
| Store credit + waivers | ≤ $200 Poppy |
| Rental damage | ≤ $300 Cedar handles via COO; > $300 Jane |
| Legal language | Immediate Jane escalation (lawyer, lawsuit, consumer protection) |
| Media escalation | Immediate Jane escalation |
| Repeated pattern | ≥ 3 customers same issue → Jane + operating team |
| Persistent unresolved | > 3 contacts same issue → escalate |
| Confidentiality | Customer data never shared across customers or external |
| Personalization | No generic templates for retention conversations |
| Care advice | Aligned with Care Guide library (Mira's authority); calibrated for Zone 9a |
| Operational | All state transitions logged to the care ledger |
| Personnel | Sensitive matters: 1:1 Jane only |

---

## RACI Table

| Activity | Poppy | Pearl | Oakley | Maple | Jane | Cross-Team |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|
| Ticket triage | A | R | C | C | I | — |
| First response | A | R | R (orders) | R (care) | — | — |
| Order issue resolution | A | C | R | — | I (>$500) | C (Cedar / Rowan) |
| Care consultation | A | C | — | R | I (recurring) | C (Mira / Tally) |
| Refund issuance | A | C | R (orders) | C (care) | A (>$500) | C (Sterling) |
| Replacement tree dispatch | A | C | C | C | — | A (Tally + Cedar) |
| Proactive customer health | A/R | — | — | — | I (major) | C (DoS Sophia) |
| Trending issues analysis | A/R | C | C | C | A | C (all operating) |
| Major-account save | A | — | — | — | A/R | C (DoS) |
| Legal / media escalation | R | I | I | I | A/R | I |
| Emergency stop | R | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-care-tickets` | Ticket intake, daily triage, sub-agent coordination | All sub-agents post; Poppy reviews |
| `#acme-care-approvals` | CEO escalations: > $500 refunds, legal, rental > $300, major saves, patterns | Poppy posts; Jane acts |
| `#acme-care-resolutions` | Resolved closures, customer thank-yous, success stories | All sub-agents post; CMO + DoS may reference |
| `#acme-care-alerts` | Legal, viral risk, pattern issues, high-value at-risk | All agents post; Poppy triages |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "outbound_replies_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `outbound_replies_enabled` is `false`:

1. Pearl, Oakley, Maple refuse to send outbound replies; drafts continue
2. Refund execution pauses (drafts continue)
3. Replacement tree dispatch queues
4. Proactive outreach (health check-ins) pauses
5. Discord alert posted to `#acme-care-alerts`: "🛑 CARE OUTBOUND PAUSED: {reason}"

To resume: set `outbound_replies_enabled: true`, post confirmation to Discord.

---

## Idempotency Strategy

Every outbound side-effect carries an idempotency key:

- First-response reply: `acme-care-{ticket_id}-reply-first-{attempt}`
- Status update: `acme-care-{ticket_id}-update-{count}-{attempt}`
- Refund issuance: `acme-care-{refund_id}-process-{attempt}`
- Replacement tree dispatch: `acme-care-{ticket_id}-replace-{attempt}`
- Care follow-up: `acme-care-{consult_id}-followup-{number}-{attempt}`
- Health check-in send: `acme-care-{checkin_id}-checkin-{attempt}`

Before send, check the ledger for an existing entry with the same key.

---

## Recommended File Tree

```
workforce/agents/customer-service-manager/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── agents/
│   ├── workspace-support/       # Pearl
│   ├── order-management/        # Oakley
│   └── care-education/          # Maple
├── schemas/
│   ├── customer-ticket.schema.json
│   ├── order-issue.schema.json
│   ├── care-consultation.schema.json
│   ├── health-check-in.schema.json
│   ├── customer-feedback.schema.json
│   ├── refund-credit.schema.json
│   ├── escalation-card.schema.json
│   └── care-ledger.sql
├── prompts/
│   ├── ticket-triage.md
│   ├── order-resolution.md
│   ├── care-consultation.md
│   └── proactive-outreach.md
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
- Email + SMS provider for customer-facing replies
- Stripe access for refund execution (via Sterling's flow)
- DocuSign access for replacement-tree paperwork (via Iris's release flow if customer venue)
- Read access to: Director of Sales' sales ledger (customer records); COO's ops ledger (orders, rentals); Contract Coordinator's contract ledger (wholesale deals); CFO's finance ledger (refunds, billing); Creative Director's care guides (care advice authority)
- SQLite database for the care ledger (local; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Poppy holds delegated authority within thresholds; Jane is final approver for anything above
