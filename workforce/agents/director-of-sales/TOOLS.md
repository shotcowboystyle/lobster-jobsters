# TOOLS.md — Director of Sales Team (Cash)

Local environment specifics for Cash and the four sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Sales team channels + customer-facing outreach | `DISCORD_BOT_TOKEN` + channel IDs | All |
| Email provider | Quotes, follow-ups, renewal pitches | `EMAIL_PROVIDER_API_KEY` | All sub-agents |
| SMS provider | Time-sensitive nudges (quote sent, booking reminder) | `SMS_PROVIDER_API_KEY` | All sub-agents |
| Stripe | Deposits, first-month subscription payments | `STRIPE_SECRET_KEY` | All sub-agents (via Sterling's flow) |
| SQLite | Sales ledger (CRM) | `SALES_LEDGER_DB_PATH` | All (read + write) |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-sales-drafts` | `DISCORD_CHANNEL_DRAFTS` | Wade, Lily, Sophia, Max |
| `#acme-sales-approvals` | `DISCORD_CHANNEL_APPROVALS` | Cash |
| `#acme-sales-pipeline` | `DISCORD_CHANNEL_PIPELINE` | Cash |
| `#acme-sales-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## Sales Ledger (CRM)

- File: `data/sales-ledger.db` (SQLite)
- Schema: `schemas/sales-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Tracks leads, opportunities, quotes, closed deals, subscription contracts, event bookings, local sales, customer accounts, sales actions

## Cross-Team Coordination

- **CFO (Sterling + Margin)**: pricing floor checks; weekly revenue report; billing setup for subscriptions
- **COO (Tally)**: inventory commitment confirmation before quote; allocation on deal close
- **COO (Cedar)**: delivery + rental + subscription installation scheduling
- **CMO**: marketing-sourced lead handoff; customer success stories
- **Customer Service Manager**: onboarding hand-off for new wholesale + subscription clients
- **Contract Coordinator (Rowan)**: wholesale deals routed for contract execution (full pipeline: contract send → deposit → reservation → routing → delivery → balance)

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `sales_actions_enabled` (boolean)
- Activated by: Jane or Cash (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the sales ledger
sqlite3 data/sales-ledger.db < schemas/sales-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly/monthly procedures and incident response
