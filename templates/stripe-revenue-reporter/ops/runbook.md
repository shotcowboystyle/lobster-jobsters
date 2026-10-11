# Runbook — Stripe Revenue Reporter

## Daily

1. Confirm today's digest posted, or that a Partial Data notice explains why not
2. Check `SELECT * FROM v_unposted_runs;`. Repeated skips on the same query mean a Stripe scope or API problem
3. Confirm `config/emergency-stop.json` → `digest_enabled` is `true` (or you know why it isn't)

## Monthly

1. In Stripe, confirm the restricted key still has read-only scopes and nothing else
2. Confirm the digest channel's member list matches who should see revenue
3. Compress `memory/*.md` into `MEMORY.md` (stay under 200 lines, no figures)

## Emergency Stop

**Activate** (owner or finance lead, any time):

```sh
jq '.digest_enabled = false | .reason = "REASON" | .stopped_by = "NAME" | .stopped_at = (now | todate)' \
  config/emergency-stop.json > /tmp/es.json && mv /tmp/es.json config/emergency-stop.json
```

Post the Emergency Stop template to `#revenue-alerts`. Nothing posts.

**Resume** (owner only): set `digest_enabled` back to `true`, fill in `resume_notes`, `resumed_by`, `resumed_at`, and post a confirmation.

## Incident Response

| Severity | Definition | First action |
|---|---|---|
| SEV-1 | Any Stripe write call was made, or a message contained card digits or a full email address | Emergency stop. Delete the affected Discord messages. Revoke and reissue the Stripe key. In Stripe's logs, review every request made with that key. Notify the owner directly |
| SEV-2 | A digest posted wrong numbers, or the digest has been skipped 3 days running | Post a correction (or the reason), fix the query or scope, re-run |
| SEV-3 | One day skipped for partial data | Already announced. Re-run once Stripe is healthy |

Every incident gets a `ledger_state_transitions` row with a `reason`, and a postmortem in `memory/YYYY-MM-DD.md` that names one corrective action.

## Ledger Operations

```sh
sqlite3 data/stripe-revenue-reporter-ledger.db < schemas/stripe-revenue-reporter-ledger.sql   # first run
sqlite3 -csv data/stripe-revenue-reporter-ledger.db "SELECT * FROM ledger_state_transitions ORDER BY id DESC LIMIT 200;"
sqlite3 data/stripe-revenue-reporter-ledger.db ".backup data/backup-$(date +%F).db"
```
