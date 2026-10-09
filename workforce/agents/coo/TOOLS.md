# TOOLS.md — COO Team (Victor)

Local environment specifics for Victor and the four sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Ops team channels + customer-facing fulfillment notifications | `DISCORD_BOT_TOKEN` + channel IDs | All |
| Google Sheets | Canonical inventory sheet | `INVENTORY_SHEET_ID` | Tally |
| Google Calendar (read-only) | Workshop calendar | `GOOGLE_CALENDAR_*` | Hazel |
| Google Maps Platform | Route planning, ETAs | `GOOGLE_MAPS_API_KEY` | Cedar |
| Environmental sensors | Temp / humidity / light / watering | `SENSOR_API_KEY` | Birch |
| Email + SMS provider | Delivery confirmations, workshop reminders | `EMAIL_PROVIDER_API_KEY`, `SMS_PROVIDER_API_KEY` | Cedar + Hazel |
| SQLite | COO workflow ledger | `OPS_LEDGER_DB_PATH` | All (read + write) |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-ops-drafts` | `DISCORD_CHANNEL_DRAFTS` | Tally, Cedar, Hazel, Birch |
| `#acme-ops-approvals` | `DISCORD_CHANNEL_APPROVALS` | Victor |
| `#acme-ops-fulfillment` | `DISCORD_CHANNEL_FULFILLMENT` | Cedar, Hazel |
| `#acme-ops-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## COO Ledger

- File: `data/ops-ledger.db` (SQLite)
- Schema: `schemas/ops-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Tracks workflow state (inventory items, snapshots, delivery jobs, rental jobs, workshop events + registrations, facility incidents, environmental readings, ops actions)

## Inventory Sheet (Canonical)

- Sheet ID env: `INVENTORY_SHEET_ID`
- Authorized service account: see `env.example`
- Columns: `tree_id`, `species`, `size`, `location`, `health_grade`, `status`, `safety_threshold`, `reserved_for`, `last_health_check_at`
- Concurrency: Tally + Grove (Contract Coordinator) both write atomic per-row updates only
- The sheet is the canonical source of truth for tree counts; the ledger is the workflow source of truth for everything else

## Environmental Ranges

- File: `data/environmental-ranges.json`
- Owned by: Birch
- Per-species optimal ranges for temp, humidity, light
- Updated only when species-specific guidance changes

## Coordination With Other Teams

- **CFO (Sterling)**: weekly inventory snapshot feeds margin + close
- **Director of Sales**: inventory availability for commitments; rental + delivery scheduling
- **Customer Service Manager**: refunds, replacements, redelivery coordination
- **CMO**: sample inventory for photoshoots; workshop promotion coordination
- **Contract Coordinator (Rowan + Grove)**: Grove reserves wholesale inventory via the same sheet; coordinates pick lists for wholesale deliveries
- **Creative Director**: photography sessions for new inventory; event coverage

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `ops_actions_enabled` (boolean)
- Activated by: Jane or Victor (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the COO ledger
sqlite3 data/ops-ledger.db < schemas/ops-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly/monthly procedures and incident response
