# TOOLS.md — CFO Team (Sterling)

Local environment specifics for Sterling and the four sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Finance team channels | `DISCORD_BOT_TOKEN` + channel IDs | All |
| Accounting system | State of record (QBO / Xero / equivalent) | `ACCOUNTING_API_KEY` | Ledger |
| Banking (Plaid or direct) | Cash position, recent transactions | `BANKING_API_KEY` | Ledger + Horizon |
| Stripe | Refunds, merchant fees | `STRIPE_SECRET_KEY` | Ledger |
| Tax/filing service | Compliance filings (Avalara, TaxJar, or equivalent) | `TAX_SERVICE_API_KEY` | Garrison |
| SQLite | CFO workflow ledger | `FINANCE_LEDGER_DB_PATH` | All (read + write) |
| Filesystem (read-only) | Cross-team ledger queries for forecasting | n/a | Horizon |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-finance-drafts` | `DISCORD_CHANNEL_DRAFTS` | Ledger, Horizon, Margin |
| `#acme-finance-approvals` | `DISCORD_CHANNEL_APPROVALS` | Sterling |
| `#acme-finance-reports` | `DISCORD_CHANNEL_REPORTS` | Horizon, Margin, Sterling |
| `#acme-finance-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## CFO Ledger

- File: `data/finance-ledger.db` (SQLite)
- Schema: `schemas/finance-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Tracks workflow state only — the accounting system holds the financial state of record

## Cross-Team Ledgers Read by Horizon

Read-only access for forecasting and margin work:

- `workforce/agents/cmo/data/post-ledger.db` — marketing spend efficiency
- `workforce/agents/coo/data/ops-ledger.db` — inventory carrying, freight, workshop economics (when COO ships)
- `workforce/agents/director-of-sales/data/sales-ledger.db` — pipeline + closed deals (when DoS ships)
- `workforce/agents/customer-service-manager/data/care-ledger.db` — refunds, replacements (when CSM ships)
- `workforce/agents/cto/data/tech-ledger.db` — software + infra spend (when CTO ships)
- `workforce/agents/creative-director/data/creative-ledger.db` — creative vendor spend (when CD ships)
- `workforce/agents/contract-coordinator/data/contract-ledger.db` — wholesale deal flow, deposits, balance payments

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `finance_actions_enabled` (boolean)
- Activated by: Jane or Sterling (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the CFO ledger
sqlite3 data/finance-ledger.db < schemas/finance-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly procedures and incident response
