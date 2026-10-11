# Architecture

How a 53-agent company is organized so that no single agent can hurt the business and every action is traceable.

## Three layers

```
Company workspace  (workforce/)
│  SOUL.md · IDENTITY.md · SHARED_KNOWLEDGE.json · team-memory/ · CROSS-TEAM-HANDOFFS.md
│  config/shared-emergency-stop.json  ← master kill switch
│
├── Team workspace  (workforce/agents/<team>/)         × 10
│   │  coordinator persona · AGENTS.md · approval-policy · emergency-stop · ledger · runbook
│   │
│   └── Sub-agent workspace  (agents/<team>/agents/<sub>/)   × 43
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
| `openclaw.json` | the gateway, never the agent | this agent's `agents.entries` block, merged into the global config |

## Registering agents with OpenClaw

Every team and sub-agent directory has an `openclaw.json` that is a fragment of the global `~/.openclaw/openclaw.json`, containing exactly one `agents.entries.<id>` block:

| field | coordinator | sub-agent |
|---|---|---|
| id (entry key) | `<team>` | `<team>-<sub>` |
| `workspace` | `~/.openclaw/workspaces/<team>` | `~/.openclaw/workspaces/<team>/agents/<sub>` |
| `name`, `identity` | persona name + emoji from `IDENTITY.md` | same |
| `subagents.allowAgents` | exactly its team's sub-agent ids | — |
| `tools.deny` | — | `gateway`, `nodes`, `plugins`, `cron`, `sessions_spawn`, `subagents` |

Model, sandbox, and heartbeat are left to your `agents.defaults`; add them per entry if a role needs something different. `scripts/validate.sh` checks that every agent has a fragment, ids match directories, workspace paths match, and each coordinator's `allowAgents` lists exactly its sub-agents.

Two ways to merge, after copying teams to `~/.openclaw/workspaces/`:

```bash
# Copy-merge (recommended). jq's `*` deep-merges objects; your existing keys are kept.
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  $(find ~/.openclaw/workspaces -name openclaw.json) > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

```json5
// Live include in ~/.openclaw/openclaw.json. Included files deep-merge in order;
// keys next to $include override them. Paths must resolve inside ~/.openclaw.
{
  $include: [
    "./workspaces/cfo/openclaw.json",
    "./workspaces/cfo/agents/fpa/openclaw.json",
    // … one per agent: find ~/.openclaw/workspaces -name openclaw.json
  ],
  agents: { defaults: { /* your defaults */ } },
}
```

Prefer copy-merge in production: with `$include`, an agent that can write to its own workspace can rewrite its own tool policy (see [security](security.md#10-agent-config-lives-outside-the-agents-reach)).

A multi-agent fleet has no implicit default agent, so add top-level `bindings` to route inbound messages, e.g. `{ agentId: "cfo", match: { channel: "discord", guildId: "…" } }` using the ids in each team's `config/discord-config.example.json`. Fragments don't ship bindings because they need your real channel ids.

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
