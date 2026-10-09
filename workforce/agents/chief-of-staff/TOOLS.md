# TOOLS.md — Chief of Staff Team

Local environment specifics for River and the four sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Executive channels + escalations | `DISCORD_BOT_TOKEN` + channel IDs | All |
| Google Calendar | Jane's calendar (read) for meeting prep | `GOOGLE_CALENDAR_*` | River + Heron |
| GitHub Issues | Cross-team action-item home (optional) | `GITHUB_TOKEN` | Wren |
| SQLite | Executive ledger | `EXEC_LEDGER_DB_PATH` | All (read + write) |
| Filesystem | Polls every `workforce/agents/<name>/` for health snapshots | n/a | Magpie |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-exec-briefings` | `DISCORD_CHANNEL_BRIEFINGS` | River, Heron |
| `#acme-exec-actions` | `DISCORD_CHANNEL_ACTIONS` | Wren |
| `#acme-exec-initiatives` | `DISCORD_CHANNEL_INITIATIVES` | Egret |
| `#acme-exec-alerts` | `DISCORD_CHANNEL_ALERTS` | Magpie, River |

## Executive Ledger

- File: `data/exec-ledger.db` (SQLite)
- Schema: `schemas/exec-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Every state transition writes to `ledger_state_transitions`

## Agent Workspaces Monitored

Magpie polls (read-only) the following workspaces every 4 hours:

- `workforce/agents/cmo/`
- `workforce/agents/ceo/`
- `workforce/agents/cfo/`
- `workforce/agents/coo/`
- `workforce/agents/cto/`
- `workforce/agents/creative-director/`
- `workforce/agents/customer-service-manager/`
- `workforce/agents/director-of-sales/`
- `workforce/agents/contract-coordinator/`

For each: confirm presence of bootstrap files, last-modified time on the daily memory log, presence of an `emergency-stop.json` if applicable, and any recent `_failed` state transitions in their ledger.

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `escalations_enabled` (boolean)
- Activated by: Jane or River (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the executive ledger
sqlite3 data/exec-ledger.db < schemas/exec-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly procedures and incident response
