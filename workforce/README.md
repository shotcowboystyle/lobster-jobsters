# ACME Bonsai — Example AI Agent Workforce

A complete OpenClaw multi-agent workforce for **ACME Bonsai**, a fictional specialty nursery with five operating units: retail / local-direct, wholesale tree operations, subscription display services, event rentals, and workshops.

ACME Bonsai is a worked example, not a real company. The company name, owner ("Jane Founder"), location ("Harbor City"), emails, and domains are placeholders. Run `scripts/rebrand.sh` from the repo root to swap them for yours, then rewrite `team-memory/` with your own brand voice, customers, and market.

---

## Architecture

- Every executive function is its own OpenClaw workspace under `agents/<name>/`
- Each workspace has its own coordinator agent + specialist sub-agents (each sub-agent is itself a full OpenClaw workspace)
- All coordination happens via Discord (`#acme-*` channels)
- All cross-team escalations flow through River (Chief of Staff) → Jane (CEO, human)
- Every team has its own ledger (SQLite) as the canonical source of truth for that domain
- Cross-team handoffs are documented in `CROSS-TEAM-HANDOFFS.md`
- Shared brand voice + ICP + tech stack live in `team-memory/`
- Master kill switch in `config/shared-emergency-stop.json` halts ALL outbound across the workforce

---

## Executive Org Chart

```
                              Jane (CEO — human)
                                       │
                              Apex 🪨 (CEO AI shadow)
                                       │
                              River 🦉 (Chief of Staff)
                                       │
   ┌──────────┬──────────┬──────────┬──┴──────┬──────────┬──────────┬────────────────┐
   │          │          │          │         │          │          │                │
  CMO        CFO        COO        CTO     DoS         CD         CSM            Contract
                                                                                  Coordinator
   │          │          │          │         │          │          │                │
  team     Sterling   Victor      Allen     Cash      Masahiko    Poppy            Rowan
           🦅 hawk    🐙 octopus  🎯        🐬        🦌 elk     🪼 jellyfish     🦋 silkmoth
                                            dolphin
```

---

## Persona Reference (45 agents)

### Executive Layer

| Workspace | Coordinator | Sub-agents |
|---|---|---|
| **CEO** `agents/ceo/` | Apex 🪨 (granite) | Compass 🧭 (Strategy Synthesizer), Almanac 📓 (Decision Journal), Atlas 🗺️ (Memo Drafter), Envoy 📨 (External Comms) |
| **Chief of Staff** `agents/chief-of-staff/` | River 🦉 (owl) | Heron 🪶 (Briefing Synthesizer), Wren 🐦 (Action-Item Tracker), Magpie 🪞 (Agent Health Monitor), Egret 🪿 (Initiative Tracker) |

### Operating Layer

| Workspace | Coordinator | Sub-agents |
|---|---|---|
| **CMO** `agents/cmo/` | Marketing team lead | Strategy Planner 📅, Content Brief 📝, Platform Copywriter ✍️, Creative Director 🎨, Brand QA 🔍, Approval Coordinator ✅, Publisher 🚀, Engagement Monitor 👀, Reply Drafter 💬, Weekly Analyst 📊 |
| **CFO** `agents/cfo/` | Sterling 🦅 (red-tailed hawk) | Ledger 📊 (Finance Ops), Horizon 📈 (FP&A), Garrison 🛡️ (Controls & Compliance), Margin 💰 (Pricing & Profitability) |
| **COO** `agents/coo/` | Victor 🐙 (octopus) | Tally 🌲 (Inventory), Cedar 🚚 (Logistics), Hazel 🎓 (Workshops), Birch 🏡 (Facility) |
| **CTO** `agents/cto/` | Allen 🎯 (orchestrator) | Pixel 🎨 (Frontend), Forge ⚙️ (Backend), Bastion 🏰 (DevOps) |
| **Director of Sales** `agents/director-of-sales/` | Cash 🐬 (dolphin) | Wade 📦 (Wholesale), Lily 🌿 (Local), Sophia 🤝 (Subscription), Max 🎉 (Event Rental) |
| **Creative Director** `agents/creative-director/` | Masahiko 🦌 (elk) | Hana 🌸 (Brand Designer), Iris 📷 (Photography), Mira 📘 (Educational Content) |
| **Customer Service Manager** `agents/customer-service-manager/` | Poppy 🪼 (jellyfish) | Pearl 🦭 (Support), Oakley 🐕 (Order Management), Maple 🌳 (Care Education) |
| **Contract Coordinator** `agents/contract-coordinator/` | Rowan 🦋 (silkmoth) | Sage 🪺 (Contract Specialist), Finch 🪙 (Payments), Grove 🌱 (Inventory & Orders), Miles 🛣️ (Delivery Router) |

---

## Cross-Team Handoffs (Summary)

See `CROSS-TEAM-HANDOFFS.md` for the full end-to-end flows. Quick reference:

| Source → Destination | Trigger |
|---|---|
| **DoS Wade → CC Rowan** | Wholesale deal `won` → contract send → deposit → reservation → routing → delivery → balance |
| **DoS Sophia → COO Cedar + CFO Sterling** | Subscription `signed` → installation + billing setup |
| **DoS Max → COO Cedar** | Event booking `confirmed` → rental cycle (outbound → at_event → return → inspected) |
| **DoS Lily → COO Tally + COO Cedar** | Local sale `purchased` → inventory allocation + delivery (if applicable) |
| **CSM Maple → CD Mira** | Species health pattern detected → care guide update |
| **CSM Oakley → CFO Sterling** | Refund execution → finance ledger reconciliation |
| **CMO Engagement Monitor → CSM Poppy** | Negative customer engagement → service recovery |
| **CTO Bastion → all teams** | Production deploy → cross-team release notification |
| **COO Tally + CC Grove** | Shared inventory sheet — atomic per-row updates |
| **CFO Margin → DoS Cash** | Pricing decisions → sales execution |
| **River 🦉 → Jane** | All cross-team escalations route through River for executive briefing |

---

## Workspace-Level Coordination Files

| File | Purpose |
|---|---|
| `SOUL.md` | Company-level voice + boundaries (cascades to every team) |
| `IDENTITY.md` | Company identity |
| `CROSS-TEAM-HANDOFFS.md` | End-to-end choreography across teams + state diagrams |
| `SHARED_KNOWLEDGE.json` | Workspace-level semantic memory index |
| `config/shared-emergency-stop.json` | **Master kill switch** — halts ALL outbound across all teams |
| `ops/exec-runbook.md` | Cross-team escalation procedures, incident response, joint ops |
| `team-memory/` | Shared brand voice, ICP, market brief, tech stack, exec decisions log, glossary |

---

## Per-Team Workspace Pattern

Each team workspace follows the same layout:

```
agents/<team>/
├── README.md                       # team architecture, state machine, RACI
├── SOUL.md                         # team voice and boundaries
├── IDENTITY.md                     # coordinator persona
├── AGENTS.md                       # operating instructions for all sub-agents
├── USER.md                         # owner profile + per-team authority matrix
├── HEARTBEAT.md                    # periodic checks (tiny)
├── MEMORY.md                       # ≤200-line durable facts
├── TOOLS.md                        # local services + paths
├── agents/<sub-agent>/             # one OpenClaw sub-workspace per specialist
│   ├── AGENTS.md  SOUL.md  IDENTITY.md  USER.md  HEARTBEAT.md  [TOOLS.md MEMORY.md]
├── config/
│   ├── emergency-stop.json         # team kill switch (master stop overrides)
│   ├── approval-policy.json        # who approves what, timeouts, allowed actions
│   ├── discord-config.example.json
│   ├── env.example
│   └── routines.example.sh         # scheduled routines (documented prompts)
├── schemas/                        # handoff JSON schemas + ledger SQL
├── prompts/                        # per-sub-agent task prompts
├── discord-templates/message-templates.md
└── ops/runbook.md
```

---

## Per-Team Authoritative Ledgers

| Team | Kill-switch flag | Ledger | Owns (canonical for) |
|---|---|---|---|
| CMO | `publishing_enabled` | `post-ledger.db` | Posts, calendars, QA, approvals, publish jobs, engagement |
| Chief of Staff | `escalations_enabled` | `exec-ledger.db` | Briefings, action items, agendas, initiatives, agent-health snapshots, escalations |
| CEO | `external_comms_enabled` | `ceo-ledger.db` | Strategic questions, decisions, outcomes, memos, external comms, stakeholders |
| CFO | `finance_actions_enabled` | `finance-ledger.db` | Monthly close, forecasts, variance, pricing decisions, exceptions, compliance, runway |
| COO | `ops_actions_enabled` | `ops-ledger.db` | Inventory, deliveries, rentals, workshops, facility incidents, environmental readings |
| CTO | `deploys_enabled` | `tech-ledger.db` | Feature requests, specs, PRs, releases, incidents, security findings, tech debt |
| Director of Sales | `sales_actions_enabled` | `sales-ledger.db` | Leads, opportunities, quotes, deals, subscriptions, bookings, accounts |
| Creative Director | `publish_assets_enabled` | `creative-ledger.db` | Briefs, deliverables, shoots, care guides, brand assets, revisions |
| Customer Service Manager | `outbound_replies_enabled` | `care-ledger.db` | Tickets, order issues, consultations, check-ins, feedback, refunds, escalations |
| Contract Coordinator | `contracts_enabled` | `contract-ledger.db` | Contracts, line items, e-sign envelopes, payments, reservations, routes, pick lists |

Each ledger is the **single source of truth** for its domain. Every state transition is written to a `*_state_transitions` table with `agent`, `from_status`, `to_status`, `reason`, `metadata`, `transitioned_at` — this is the audit trail. `scripts/ledger.sh` initializes ledgers and exports transitions as evidence.

---

## Operating Principles (Company-Wide)

- No publishing, contracting, invoicing, shipping, or other outbound action without explicit human approval at the appropriate level
- All sensitive credentials live outside the workspace
- Per-team emergency-stop kill switches; the workspace-level kill switch overrides any team-level "on" setting
- Every team writes to its own ledger; River reads them all for cross-team briefings
- Briefings to Jane are hard-capped at ≈400 words
- Cross-team escalations route through River → Jane
- Every state transition logged to the team's canonical ledger
- Idempotency keys on every outbound side-effect
- Every sub-agent has explicit cost controls (max turns per cycle, max retries)

---

## Deployment

- OpenClaw (or Claude Desktop with Routines) for scheduled work — see each team's `config/routines.example.sh`
- Discord bot for all coordination
- SQLite ledgers per team, backed up nightly
- See each team's `config/env.example` for required environment variables
- Third-party skills are pinned in `.clawhub/lock.json` per workspace and installed with `clawhub install`, not vendored
