# TOOLS.md — CEO Team (Apex)

Local environment specifics for Apex and the four sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Jane-only CEO channels | `DISCORD_BOT_TOKEN` + channel IDs | All |
| Email (Postmark / SES / Resend) | Envoy external-comm send | `EMAIL_PROVIDER_API_KEY` | Envoy |
| SQLite | CEO ledger | `CEO_LEDGER_DB_PATH` | All (read + write) |
| Filesystem (read-only) | Cross-team ledger queries for Compass | n/a | Compass |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-ceo-strategy` | `DISCORD_CHANNEL_STRATEGY` | Compass, Apex |
| `#acme-ceo-decisions` | `DISCORD_CHANNEL_DECISIONS` | Almanac |
| `#acme-ceo-memos` | `DISCORD_CHANNEL_MEMOS` | Atlas, Envoy |
| `#acme-ceo-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## CEO Ledger

- File: `data/ceo-ledger.db` (SQLite)
- Schema: `schemas/ceo-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Every state transition writes to `ledger_state_transitions`

## Cross-Team Ledgers Read by Compass

Read-only access for the weekly synthesis routine:

- `workforce/agents/cmo/data/post-ledger.db`
- `workforce/agents/cfo/data/finance-ledger.db` (when CFO ships)
- `workforce/agents/coo/data/ops-ledger.db` (when COO ships)
- `workforce/agents/cto/data/tech-ledger.db` (when CTO ships)
- `workforce/agents/director-of-sales/data/sales-ledger.db` (when DoS ships)
- `workforce/agents/creative-director/data/creative-ledger.db` (when CD ships)
- `workforce/agents/customer-service-manager/data/care-ledger.db` (when CSM ships)
- `workforce/agents/contract-coordinator/data/contract-ledger.db`
- `workforce/agents/chief-of-staff/data/exec-ledger.db`

For ledgers not yet shipped, Compass reads the team's most recent `memory/YYYY-MM-DD.md` and weekly summaries from their `memory/` directory.

## Stakeholder Address Book

- File: `data/stakeholder-records.jsonl` (one JSON line per stakeholder)
- Schema: `schemas/stakeholder-record.schema.json`
- Owned by: Envoy
- Updated whenever a new external recipient is added; nothing here without Jane's prior approval

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `external_comms_enabled` (boolean)
- Activated by: Jane or Apex (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Self-Improving Skill (third-party)

The `skills/self-improving/` skill is installed in this workspace from clawic.com. It is not modified by this team and not part of the OpenClaw bootstrap files. It runs alongside the standard memory architecture.

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the CEO ledger
sqlite3 data/ceo-ledger.db < schemas/ceo-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly procedures and incident response
