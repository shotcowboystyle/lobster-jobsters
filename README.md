# 🦞 Lobster Jobsters

**Complete, production-shaped OpenClaw agent workspaces — not just a `SOUL.md`.**

Most "awesome OpenClaw agents" lists give you a persona file and wish you luck. Each agent here is a full OpenClaw workspace: operating instructions, kill switch, approval policy, ledger schema, handoff contracts, Discord templates, scheduled routines, runbook, and a roster of sub-agents that are themselves full workspaces. Drop one into your OpenClaw instance and it knows how to behave before you say a word.

The example company is **ACME Bonsai**, a fictional specialty nursery with a 53-agent executive workforce. The tooling makes it yours in one command.

```
scripts/rebrand.sh --company "Northwind Plants" --slug northwind --owner "Sam Rivera" --owner-first Sam
```

---

## What's inside

| Path | What it is |
|---|---|
| [`workforce/`](workforce/) | The ACME Bonsai company workspace: 10 executive teams, 53 agents, cross-team handoffs, shared memory, master kill switch |
| [`templates/`](templates/) | Blank team-workspace and sub-agent templates used by the scaffolder |
| [`scripts/`](scripts/) | Rebrand, scaffold, validate, audit, and ledger tooling |
| [`docs/`](docs/) | Architecture, governance, security model, evidence & benchmarking, adding agents |

### The workforce

```
                              Jane (CEO — human)
                                       │
                              Apex 🪨 (CEO AI shadow)
                                       │
                              River 🦉 (Chief of Staff)
                                       │
   ┌──────────┬──────────┬──────────┬──┴──────┬──────────┬──────────┬────────────────┐
  CMO        CFO        COO        CTO     Sales       Creative    Customer        Contract
  Marisol 📣 Sterling 🦅 Victor 🐙  Allen 🎯  Cash 🐬    Masahiko 🦌 Poppy 🪼        Rowan 🦋
```

| Team | Coordinator | Sub-agents | Domain |
|---|---|---|---|
| [CEO](workforce/agents/ceo/) | Apex 🪨 | Compass, Almanac, Atlas, Envoy | Strategy synthesis, decision journal, memos, external comms |
| [Chief of Staff](workforce/agents/chief-of-staff/) | River 🦉 | Heron, Wren, Magpie, Egret | Briefings, action items, agent health, initiatives |
| [CMO](workforce/agents/cmo/) | Marisol 📣 | 10 pipeline agents | Plan → draft → QA → approve → publish → monitor |
| [CFO](workforce/agents/cfo/) | Sterling 🦅 | Ledger, Horizon, Garrison, Margin | Close, FP&A, controls, pricing |
| [COO](workforce/agents/coo/) | Victor 🐙 | Tally, Cedar, Hazel, Birch | Inventory, logistics, workshops, facility |
| [CTO](workforce/agents/cto/) | Allen 🎯 | Pixel, Forge, Bastion | Frontend, backend, DevOps |
| [Director of Sales](workforce/agents/director-of-sales/) | Cash 🐬 | Wade, Lily, Sophia, Max | Wholesale, local, subscription, events |
| [Creative Director](workforce/agents/creative-director/) | Masahiko 🦌 | Hana, Iris, Mira | Brand design, photography, education |
| [Customer Service](workforce/agents/customer-service-manager/) | Poppy 🪼 | Pearl, Oakley, Maple | Support, orders, care education |
| [Contract Coordinator](workforce/agents/contract-coordinator/) | Rowan 🦋 | Sage, Finch, Grove, Miles | Contracts, payments, reservations, routing |

Every team workspace has the same shape:

```
agents/<team>/
├── AGENTS.md  SOUL.md  IDENTITY.md  USER.md  HEARTBEAT.md  MEMORY.md  TOOLS.md  README.md
├── openclaw.json                # agent entry to merge into your global OpenClaw config
├── agents/<sub-agent>/          # each sub-agent is a full OpenClaw workspace (+ its own openclaw.json)
├── config/
│   ├── emergency-stop.json      # team kill switch — one boolean flag
│   ├── approval-policy.json     # who approves what, timeouts, allowed actions
│   ├── discord-config.example.json  env.example  routines.example.sh
├── schemas/                     # JSON Schemas for every handoff + the SQLite ledger
├── prompts/                     # task prompts per sub-agent
├── discord-templates/           # approval cards, alerts, reports
└── ops/runbook.md               # daily / weekly / incident / emergency-stop procedures
```

---

## Quickstart

**1. Try one agent.** Copy a team into your OpenClaw workspaces directory and point an agent at it.

```bash
git clone https://github.com/shotcowboystyle/lobster-jobsters.git
cp -R lobster-jobsters/workforce/agents/cfo ~/.openclaw/workspaces/cfo
```

Register the team with your OpenClaw gateway. Every agent directory ships an `openclaw.json` holding its `agents.entries.<id>` block (id `cfo` for the coordinator, `cfo-<sub>` for each sub-agent; workspace paths assume `~/.openclaw/workspaces/<team>`). Deep-merge them into your global config:

```bash
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  $(find ~/.openclaw/workspaces/cfo -name openclaw.json) > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

(or list them under `$include` — see [architecture](docs/architecture.md#registering-agents-with-openclaw)). Sub-agents live under `agents/<name>/` inside the team and are spawned by the coordinator, which may only spawn the ids in its `subagents.allowAgents`. Fill `config/env.example` → `.env` (outside the repo), create the Discord channels in `config/discord-config.example.json`, then initialize the ledger:

```bash
scripts/ledger.sh init cfo
```

**2. Make it your company.**

```bash
scripts/rebrand.sh --company "Northwind Plants" --slug northwind \
  --owner "Sam Rivera" --owner-first Sam --domain northwindplants.com --city Portland
```

Then rewrite `workforce/team-memory/` (brand voice, ICP, market brief, tech stack) — that's where the domain knowledge lives. The agents read it; they don't hard-code it.

**3. Add a team or a sub-agent.**

```bash
scripts/new-agent.sh team cro --name "Chief Revenue Officer" --persona Harbor --emoji ⚓ --creature pelican
scripts/new-agent.sh sub cro partnerships --persona Reef --role "Partnerships Agent" --emoji 🪸 --creature coral
```

Generated workspaces pass validation and score 12/12 on the governance audit out of the box.

**4. Check your work.**

```bash
scripts/validate.sh            # structure, JSON/SQL/shell validity, budgets, secrets, placeholders
scripts/audit.py --strict      # governance scorecard per team
scripts/ledger.sh metrics cfo  # operational metrics from the ledger once it has data
```

---

## Design principles

- **Humans decide, agents prepare.** No publish, contract, payment, deploy, or outbound message without approval per `approval-policy.json`. Timeouts remind or hold — never auto-approve.
- **Two-tier kill switch.** Each team has one boolean flag in `config/emergency-stop.json`; the workspace-level `shared-emergency-stop.json` overrides every team. Agents check both before any side-effect.
- **The ledger is the evidence.** Every state change is a `ledger_state_transitions` row with `agent`, `from_status`, `to_status`, `reason`, `metadata`, `transitioned_at`. `scripts/ledger.sh` exports it and computes approval latency and time-in-state.
- **Idempotency everywhere.** Every outbound side-effect carries a key checked against the ledger before acting.
- **Sub-agents only get `AGENTS.md` + `TOOLS.md`.** So every cross-cutting safety rule is restated in each sub-agent's `AGENTS.md`, and each has explicit cost controls (max turns, max retries).
- **Secrets never enter the workspace.** `env.example` names variables; values live in your secrets manager. CI runs a secret scan on every push.
- **Skills are allowlisted by name.** Every agent's `openclaw.json` lists its skills explicitly (`[]` for none) — no wildcards, enforced by `scripts/validate.sh`.

Read more: [architecture](docs/architecture.md) · [governance](docs/governance.md) · [security](docs/security.md) · [evidence & benchmarking](docs/evidence-and-benchmarking.md) · [adding agents](docs/adding-agents.md)

---

## Governance scorecard

`scripts/audit.py` checks twelve controls per team and flags persona collisions (two agents sharing a name or emoji):

| control | what it proves |
|---|---|
| `kill_switch` | one boolean flag + audit fields |
| `stop_in_agents` | agents are told to check it |
| `approval_policy` | every rule has approvers; no auto-approve |
| `authority_matrix` | USER.md states what the human decides |
| `ledger_schema` | state-transition table with agent/from/to/reason/timestamp |
| `idempotency` | keys on outbound side-effects |
| `cost_controls` | every sub-agent has turn/retry budgets |
| `subagent_safety` | every sub-agent restates safety rules |
| `heartbeat_tiny` | heartbeat checks the kill switch, ≤ 12 items |
| `memory_budget` | MEMORY.md ≤ 200 lines |
| `env_example` | present, no real-looking secrets |
| `runbook` | emergency stop + incident response documented |

All ten ACME teams score 12/12. CI fails the build if any drops.

---

## Status and scope

- Built for [OpenClaw](https://openclaw.com) workspace conventions (`AGENTS.md`, `SOUL.md`, `IDENTITY.md`, `USER.md`, `TOOLS.md`, `HEARTBEAT.md`, `MEMORY.md`, `memory/`, `skills/`). The routines files also map to Claude Code Routines.
- ACME Bonsai is fictional. Names, emails, domains, and the location are placeholders.
- No runtime code is included. These are workspaces (prompts, policies, schemas) plus repo tooling in bash, Python 3 stdlib, `jq`, and `sqlite3`.

## Contributing

New teams, new sub-agents, better prompts, and audit checks are all welcome. See [CONTRIBUTING.md](CONTRIBUTING.md). Report security concerns per [SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE) © Curtis Blanton — [shotcowboystyle.github.io](https://shotcowboystyle.github.io)
