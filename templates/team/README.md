# {{TEAM_NAME}} — {{COMPANY}}

OpenClaw workspace for the {{COMPANY}} {{TEAM_NAME}} ({{TEAM_SHORT}}) team. Coordinator: **{{PERSONA}} {{EMOJI}}**.

## Architecture Summary

{{PERSONA}} coordinates a small set of specialist sub-agents. Discord is the human coordination layer. Every outbound action requires explicit human approval per `config/approval-policy.json`. The pipeline is `intake → drafted → review → approved → executed → archived`.

Key principles:

- No autonomous outbound action — every side-effect requires approval at the level defined in the approval policy
- Safe failure mode — when uncertain: draft, flag, pause, escalate
- Auditable — every state transition is logged to the team ledger
- Idempotent — every outbound side-effect carries an idempotency key `{{TEAM_SLUG}}-{entity_id}-{action}-{date}-{attempt}`

## Agent Table

| # | Agent | Mission | Trigger | Outputs To |
|---|-------|---------|---------|------------|
| 1 | {{PERSONA}} (coordinator) | Owns the {{TEAM_SHORT}} domain, routes work, approves within authority | Routines + Discord mentions | Sub-agents, {{OWNER}} |

Add one row per sub-agent created with `scripts/new-agent.sh sub {{TEAM_SLUG}} <slug> ...`.

## Work Item State Machine

```
intake → drafted → review → approved → executed → archived
                      ↓          ↓          ↓
                  rejected     held    execution_failed → (retry ≤ 3 → executed | escalate)
```

## Guard Rails

| Category | Rule |
|---|---|
| Operational | No outbound action without explicit human approval |
| Operational | Check `config/emergency-stop.json` (`{{FLAG}}`) before any side-effect |
| Approval | Timeout → remind, then hold. Never auto-approve |
| Data | No credential access from prompts; tokens managed externally |
| Data | All state transitions logged to `data/{{TEAM_SLUG}}-ledger.db` |

## RACI

| Activity | {{PERSONA}} | Sub-agents | {{OWNER}} (human) |
|---|:---:|:---:|:---:|
| Intake triage | R | — | I |
| Drafting | A | R | I |
| Approval within authority | R | — | I |
| Approval above threshold | I | — | A/R |
| Emergency stop | R | — | R |

## Discord Channels

| Channel | Purpose |
|---|---|
| `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-drafts` | Drafts, review results, routine summaries |
| `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-approvals` | Approval cards, decisions, execution confirmations |
| `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-alerts` | Failures, escalations, emergency stop |

## Emergency Stop

`config/emergency-stop.json` → `{{FLAG}}: false` halts every outbound action for this team. The workspace-level `config/shared-emergency-stop.json` overrides this file when `all_outbound_enabled` is `false`. Procedure in `ops/runbook.md`.

## Files

```
agents/{{TEAM_SLUG}}/
├── README.md  SOUL.md  IDENTITY.md  AGENTS.md  USER.md  HEARTBEAT.md  MEMORY.md  TOOLS.md
├── agents/<sub-agent>/           # one OpenClaw sub-workspace per specialist
├── config/                       # emergency-stop, approval-policy, discord-config, env, routines
├── schemas/{{TEAM_SLUG}}-ledger.sql
├── ops/runbook.md
└── discord-templates/message-templates.md
```
