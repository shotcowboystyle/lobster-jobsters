# TOOLS.md — {{TEAM_NAME}} Team ({{PERSONA}})

Local environment specifics for {{PERSONA}} and the sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to. Never put credential values here — only the env var names.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Team channels + escalations | `DISCORD_BOT_TOKEN` + channel IDs | All |
| SQLite | Team ledger (workflow state) | `{{TEAM_SLUG}}_LEDGER_DB_PATH` | All (read + write) |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-drafts` | `DISCORD_CHANNEL_DRAFTS` | {{PERSONA}}, sub-agents |
| `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-approvals` | `DISCORD_CHANNEL_APPROVALS` | {{PERSONA}} |
| `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## Ledger

- File: `data/{{TEAM_SLUG}}-ledger.db` (SQLite, git-ignored)
- Schema: `schemas/{{TEAM_SLUG}}-ledger.sql`
- Init: `scripts/ledger.sh init {{TEAM_SLUG}}` from the repo root
- Evidence export: `scripts/ledger.sh transitions {{TEAM_SLUG}}`

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `{{FLAG}}` (boolean)
- Activated by: {{OWNER}} or {{PERSONA}} (per `approval-policy.json` rule `emergency_stop`)

## Local Dev Quick Reference

```bash
for f in config/*.json; do jq empty "$f" && echo "OK $f"; done
sqlite3 data/{{TEAM_SLUG}}-ledger.db < schemas/{{TEAM_SLUG}}-ledger.sql
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```
