# ACME Bonsai — COO Team (Victor)

## Architecture Summary

Multi-agent OpenClaw system that runs ACME Bonsai's operations: tree inventory, deliveries and rentals, workshops, and facility. Discord is the human coordination layer. The inventory sheet (Google Sheets) is the canonical source of truth for tree counts; the COO ledger tracks workflow state for deliveries, rentals, workshops, facility incidents, and environmental readings.

Key principles:

- Execution over intention; clarity of ownership on every task
- Sales commitments are sacred — Tally never lets Sales overcommit
- No tree leaves the farm without inventory reservation
- No rental dispatched without before-photo documentation
- Environment is destiny — Birch keeps temp/humidity/light right
- Workshops are experiences, not transactions

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | COO | Victor 🐙 | Orchestrates the team; protects sales commitments | Routine + on-demand | Sub-agents + Jane |
| 2 | Inventory | Tally 🌲 | Single source of truth for every tree | Daily reconciliation + health scan | All teams |
| 3 | Logistics | Cedar 🚚 | Deliveries + rentals, on time and documented | Daily delivery sweep + weekly route review | Customers + Sales |
| 4 | Workshops | Hazel 🎓 | Workshop calendar, registrations, materials, instructors | Daily reminder sweep + weekly calendar refresh | Registrants + Marketing |
| 5 | Facility | Birch 🏡 | Environmental conditions, maintenance, safety | Daily env check + weekly walkthrough + monthly equipment | Tally + Victor |

---

## State Machines

**Inventory item:** `received → quarantined → healthy → reserved → allocated → fulfilled → archived` (with `sick → treated → healthy` or `lost`)

**Delivery:** `scheduled → confirmed → loaded → in_transit → delivered → pod_captured → closed` (with `rescheduled` / `failed`)

**Rental:** `scheduled → outbound → at_event → return_pickup → inspected → closed` (with `damaged → disputed → resolved`)

**Workshop event:** `proposed → calendar → registration_open → confirmed → in_session → debrief → closed` (with `cancelled`)

**Workshop registration:** `pending → confirmed → attended → followed_up` (with `cancelled` / `no_show`)

**Facility incident:** `detected → triaged → in_progress → resolved → archived` (with `escalated`)

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Daily Inventory Reconciliation | Routine: 7 AM ET | Tally | Victor reviews escalations |
| B. Daily Health Scan | Routine: 7 AM ET (paired) | Tally + Birch | Mortality > 2% → Jane alert |
| C. Daily Environmental Check | Routine: 6 AM ET | Birch | Off-range > 6h → Victor alert |
| D. Daily Delivery Confirmation Sweep | Routine: 8 AM ET | Cedar | Victor reviews exceptions |
| E. Daily Workshop Reminder Sweep | Routine: 9 AM ET | Hazel | — (auto-confirmations) |
| F. Weekly Inventory Snapshot | Routine: Fri 4 PM ET | Tally | Posted to CFO + Sales channels |
| G. Weekly Route Review | Routine: Mon 8 AM ET | Cedar | Victor reviews next-week routes |
| H. Weekly Workshop Calendar Refresh | Routine: Sun 4 PM ET | Hazel | 3-month rolling calendar |
| I. Weekly Safety Walkthrough | Routine: Fri 10 AM ET | Birch | Incident detection + log |
| J. Monthly Equipment Inspection | Routine: Day 1 at 10 AM ET | Birch | Jane approves repairs > $1K |
| K. Rental Cycle | Per booking | Cedar + Tally | Jane on damage > $300 |
| L. Workshop Cycle | Per session | Hazel + Birch + Tally | Jane on cancellations |
| M. Incident Response | On detection | Birch + Victor | Jane on intervention > $1K |
| N. Emergency Stop | Any time | Victor | Jane or Victor sets `ops_actions_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Inventory | No commitment to Sales without Tally's confirmed availability |
| Inventory | Allocation priority enforced: wholesale > rental > local sales > marketing > workshop demo |
| Inventory | Tree mortality > 2% in 30-day window → immediate Jane alert |
| Inventory | Sick trees quarantined immediately; no return to healthy without documented treatment |
| Delivery | Confirm 24h ahead of window |
| Delivery | No third-party freight — ACME van only |
| Delivery | POD (signature or photo) required to close |
| Rental | Before photos (≥3) required to dispatch |
| Rental | Return pickup within 48h of event end |
| Rental | After photos (≥3) required to close |
| Rental | Damage disputes > $300 → Jane approval |
| Workshop | Attendance cap 8–12 participants |
| Workshop | Materials checklist + instructor confirmation required before `confirmed` |
| Workshop | Cancellations require Jane approval |
| Workshop | Demo trees inventoried back after each session |
| Facility | Environmental conditions monitored; off-range > 6h → Victor alert |
| Facility | Safety walkthrough weekly; incidents logged immediately |
| Facility | Intervention > $1K → Jane approval |
| Facility | Major repair > $5K → Jane approval |
| Operational | All state transitions logged to the ops ledger |
| Personnel | Sensitive matters: 1:1 Jane only |

---

## RACI Table

| Activity | Victor | Tally | Cedar | Hazel | Birch | Jane | Sales |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Inventory reconciliation | A | R | — | — | — | I | I |
| Health scan | A | R | — | — | C | I (>2%) | — |
| Sales commitment validation | A | R | — | — | — | I | A (commits) |
| Delivery scheduling | A | C | R | — | — | I | C |
| Rental cycle | A | C | R | — | — | I (damage) | C |
| Workshop planning | A | C | — | R | C | I | — |
| Workshop execution | A | — | — | R | C | — | — |
| Environmental monitoring | A | — | — | — | R | I (failures) | — |
| Maintenance | A | — | — | — | R | A (>$1K) | — |
| Facility incident | A/R | — | — | — | R | A (>$1K) | — |
| Mortality response | A | R | — | — | C | A (>2%) | — |
| Emergency stop | R | I | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-ops-drafts` | Inventory snapshots, delivery schedules, workshop calendars, environmental logs | All sub-agents post; Victor reviews |
| `#acme-ops-approvals` | CEO escalations: shortfall, rental damage, repairs, cancellations | Victor posts; Jane acts |
| `#acme-ops-fulfillment` | Delivery confirmations, rental coordination, workshop reminders | Cedar + Hazel post; customers receive |
| `#acme-ops-alerts` | Mortality, env failures, safety incidents, missed deliveries, emergency-stop | All agents post; Victor triages |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "ops_actions_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `ops_actions_enabled` is `false`:

1. Cedar refuses to dispatch deliveries or rentals; drafts continue
2. Hazel refuses to send workshop confirmations / reminders; drafts continue
3. Tally continues internal updates (reservations, health logs) but does not transition outward to `allocated`
4. Birch continues environmental + safety monitoring; intervention purchases pause
5. Discord alert posted to `#acme-ops-alerts`: "🛑 OPS ACTIONS PAUSED: {reason}"

To resume: set `ops_actions_enabled: true`, post confirmation to Discord.

---

## Idempotency Strategy

Every outbound side-effect carries an idempotency key:

- Customer delivery confirmation: `acme-ops-{delivery_id}-confirm-{attempt}`
- Workshop reminder: `acme-ops-{workshop_id}-reminder-{attempt}`
- Rental pickup notice: `acme-ops-{rental_id}-pickup-{attempt}`
- Damage assessment: `acme-ops-{rental_id}-damage-{attempt}`

Before send, check the ledger for an existing entry with the same key.

---

## Recommended File Tree

```
workforce/agents/coo/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── agents/
│   ├── inventory-agent/         # Tally
│   ├── logistics-agent/         # Cedar
│   ├── workshop-coordinator/    # Hazel
│   └── facility-management/     # Birch
├── schemas/
│   ├── inventory-item.schema.json
│   ├── inventory-snapshot.schema.json
│   ├── delivery-job.schema.json
│   ├── rental-job.schema.json
│   ├── workshop-event.schema.json
│   ├── workshop-registration.schema.json
│   ├── facility-incident.schema.json
│   ├── environmental-reading.schema.json
│   └── ops-ledger.sql
├── prompts/
│   ├── inventory-reconciliation.md
│   ├── delivery-coordination.md
│   ├── workshop-cycle.md
│   └── facility-monitoring.md
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
- Google Sheets API for canonical inventory sheet
- Google Calendar API (read-only) for workshop calendar
- Environmental sensors with API (temp, humidity, light, watering logs)
- Mapping service (Google Maps Directions) for route planning
- Email + SMS provider for customer confirmations + workshop reminders
- SQLite database for the COO ledger (local; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Victor holds delegated authority within thresholds; Jane is final approver for anything above
