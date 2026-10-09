# TOOLS.md — Contract Coordinator Team

Local environment specifics for Rowan and the four sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| DocuSign | Wholesale agreement signing | `DOCUSIGN_*` | Sage |
| Stripe | Deposit + balance invoices | `STRIPE_*` | Finch |
| ACH (via Stripe ACH) | Deposit + balance invoices | `STRIPE_ACH_ENABLED` | Finch |
| Google Sheets | Canonical tree inventory sheet | `INVENTORY_SHEET_ID` | Grove |
| Google Maps Platform | Geocoding + Directions | `GOOGLE_MAPS_API_KEY` | Miles |
| Discord | Coordination + escalations | `DISCORD_BOT_TOKEN` + channel IDs | All |
| SQLite | Contract ledger | `CONTRACT_LEDGER_DB_PATH` | All (read + write) |

## DocuSign

- Template: `DOCUSIGN_TEMPLATE_ID_WHOLESALE` (standard wholesale purchase agreement)
- Auth: JWT via private key at `DOCUSIGN_PRIVATE_KEY_PATH`
- Webhooks → `payments-agent` is NOT subscribed; Sage polls envelope status on routine
- Reminder cadence: hard-coded +48h, +5d (Sage)

## Stripe

- Mode: live keys in production, test keys for local dev — set `STRIPE_SECRET_KEY` accordingly
- Webhook URL: `<host>/webhooks/stripe` — must validate `STRIPE_WEBHOOK_SECRET` signature
- Idempotency: every PaymentIntent created with `idempotency_key = acme-{contract_id}-(deposit|balance)-{attempt}`

## Google Sheets (Inventory)

- Sheet ID env: `INVENTORY_SHEET_ID`
- Authorized service account: see `env.example`
- Columns expected: `species`, `size`, `row_id`, `on_hand`, `reserved`, `safety_threshold`
- Concurrency: Grove writes atomic per-row updates only

## Google Maps Platform

- Required APIs enabled: Directions API, Geocoding API
- Geocode cache: per-buyer, 90 days, keyed by `(street, city, state, zip)`
- Directions calls: batched per route with `optimizeWaypoints=true`

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-contracts-drafts` | `DISCORD_CHANNEL_DRAFTS` | Rowan, Sage, Finch |
| `#acme-contracts-approvals` | `DISCORD_CHANNEL_APPROVALS` | Rowan only |
| `#acme-contracts-delivery` | `DISCORD_CHANNEL_DELIVERY` | Miles, Grove |
| `#acme-contracts-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## Contract Ledger

- File: `data/contract-ledger.db` (SQLite)
- Schema: `schemas/contract-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Every state transition writes to `contract_state_transitions` (agent, from, to, reason, metadata)

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `contracts_enabled` (boolean)
- Activated by: Rowan or Jane (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the contract ledger
sqlite3 data/contract-ledger.db < schemas/contract-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machine, RACI
- `ops/runbook.md` — daily/weekly procedures and incident response
