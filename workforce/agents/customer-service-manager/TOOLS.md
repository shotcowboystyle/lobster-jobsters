# TOOLS.md — Customer Service Manager Team (Poppy)

Local environment specifics for Poppy and the three sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Care team channels + cross-team coordination | `DISCORD_BOT_TOKEN` + channel IDs | All |
| Email provider | Customer-facing replies | `EMAIL_PROVIDER_API_KEY` | All sub-agents |
| SMS provider | Time-sensitive nudges, check-ins | `SMS_PROVIDER_API_KEY` | All sub-agents |
| Stripe | Refund execution (via Sterling's flow) | `STRIPE_SECRET_KEY` | Oakley |
| SQLite | Care workflow ledger | `CARE_LEDGER_DB_PATH` | All (read + write) |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-care-tickets` | `DISCORD_CHANNEL_TICKETS` | Poppy, Pearl, Oakley, Maple |
| `#acme-care-approvals` | `DISCORD_CHANNEL_APPROVALS` | Poppy |
| `#acme-care-resolutions` | `DISCORD_CHANNEL_RESOLUTIONS` | All |
| `#acme-care-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## Care Ledger

- File: `data/care-ledger.db` (SQLite)
- Schema: `schemas/care-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Tracks workflow state — tickets, order issues, care consultations, health check-ins, customer feedback, refunds/credits, escalations

## Cross-Team Coordination (read access)

- **Director of Sales (Cash + customer accounts)**: customer records, account context, opportunity status (Cash's sales ledger)
- **COO (Cedar)**: delivery jobs, rental jobs (Cedar's ops ledger)
- **COO (Tally)**: inventory + tree health + species recurring issues
- **Contract Coordinator (Rowan)**: wholesale contracts + buyer context
- **CFO (Sterling + Margin)**: refund execution + payment data
- **Creative Director (Mira)**: care guide library — technical authority for care advice
- **CMO**: customer success stories + reputation context

## Care Advice Authority

- Care guides live in `workforce/agents/creative-director/data/asset-library/` (kind: care_guide_pdf)
- Technical authority: Maple consults Mira (Educational Content Designer); Mira verifies via Care Education review on the CD team
- For new care patterns: open `customer_feedback` entry → routes to Mira for care guide update consideration

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `outbound_replies_enabled` (boolean)
- Activated by: Jane or Poppy (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the care ledger
sqlite3 data/care-ledger.db < schemas/care-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly procedures and incident response
