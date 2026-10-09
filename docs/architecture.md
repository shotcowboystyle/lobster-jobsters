# Architecture

How a 45-agent company is organized so that no single agent can hurt the business and every action is traceable.

## Three layers

```
Company workspace  (workforce/)
│  SOUL.md · IDENTITY.md · SHARED_KNOWLEDGE.json · team-memory/ · CROSS-TEAM-HANDOFFS.md
│  config/shared-emergency-stop.json  ← master kill switch
│
├── Team workspace  (workforce/agents/<team>/)         × 10
│   │  coordinator persona · AGENTS.md · approval-policy · emergency-stop · ledger · runbook
│   │
│   └── Sub-agent workspace  (agents/<team>/agents/<sub>/)   × 35
│          AGENTS.md · SOUL.md · IDENTITY.md · USER.md · HEARTBEAT.md · TOOLS.md
```

**Company** sets voice, hard rules, shared facts, and the master kill switch. Every team's `SOUL.md` inherits it and may add rules but never override.

**Team** owns a domain and its ledger. The coordinator (e.g. Sterling for CFO) triages, delegates, approves within authority, and briefs the human. It is the only thing in the team that posts to Discord or causes side-effects.

**Sub-agent** prepares artifacts for one slice of the domain and hands them back. It never acts outbound.

## OpenClaw bootstrap files

| File | Who loads it | Purpose |
|---|---|---|
| `AGENTS.md` | everyone, including sub-agents | operating instructions, safety rules, memory workflow, handoff protocol |
| `SOUL.md` | main sessions | persona, values, boundaries |
| `IDENTITY.md` | main sessions | name, creature, vibe, emoji |
| `USER.md` | private main sessions | who the human is, authority matrix |
| `TOOLS.md` | everyone | what this workspace connects to (names only, never values) |
| `HEARTBEAT.md` | heartbeat runs | tiny checklist; `HEARTBEAT_OK` if quiet |
| `MEMORY.md` | private main sessions | ≤ 200 lines of durable facts |
| `memory/YYYY-MM-DD.md` | main sessions | daily append-only log (git-ignored) |
| `BOOTSTRAP.md` | first run only | one-time setup ritual; delete after |

**The sub-agent rule.** OpenClaw sub-agents receive only `AGENTS.md` and `TOOLS.md`. That is why every sub-agent `AGENTS.md` here restates the safety rules, the kill-switch check, and its cost budget, and why the audit fails any sub-agent that doesn't.

## Memory model

Four layers, cheapest to most expensive to read:

1. **Bootstrap files** — always loaded, so kept small and stable.
2. **Daily logs** — `memory/*.md`, raw, per deployment, never committed.
3. **`SHARED_KNOWLEDGE.json`** — company-level semantic index: facts, workforce map, ledger paths, canonical approval thresholds. Any agent that needs a cross-team fact reads this instead of another team's files.
4. **Ledgers** — SQLite per team; the only place operational state lives. Cross-team reads go through the ledger, never through another agent's memory.

Weekly, the coordinator compresses daily logs into `MEMORY.md`; the 200-line cap forces it to keep only what is durable.

## Coordination

- **Discord** is the human interface. Each team has a drafts / approvals / alerts (or equivalent) channel set defined in `config/discord-config.example.json`. Agents post; humans react.
- **Escalation path** is `sub-agent → coordinator → River (Chief of Staff) → Jane`. Time-critical incidents bypass River with River notified in parallel. Briefings are capped at ≈400 words with one decision per ask.
- **Cross-team handoffs** are typed: each one has a JSON Schema in the sending team's `schemas/` and an end-to-end flow in `workforce/CROSS-TEAM-HANDOFFS.md` (e.g. wholesale deal `won` → contract → deposit → reservation → routing → delivery → balance).
- **Routines** (`config/routines.example.sh`) document every scheduled run as a prompt with a schedule, so the cadence is reviewable in git rather than hidden in a scheduler UI.

## State machines

Every domain object has an explicit lifecycle in the team README (posts: `planned → … → published → archived`; contracts: `drafted → sent → signed → deposit_paid → …`). Every transition is one row in `ledger_state_transitions`. Failed variants (`qa_failed`, `publish_failed`, `execution_failed`) are states, not exceptions, so retries and escalations are visible.

## Why one SQLite file per team

- Zero infrastructure; lives next to the workspace; backed up with `.backup`.
- Clear ownership: one writer team, many readers.
- Queryable evidence: `scripts/ledger.sh metrics <team>` gives approval latency and time-in-state with no extra tooling.
- Easy to swap: the schema is plain SQL; move to Postgres when a team outgrows it.
