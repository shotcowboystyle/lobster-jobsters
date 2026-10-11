# Runbook — Zendesk Triage Agent

## Daily

1. Confirm the Daily Summary posted and `config/emergency-stop.json` → `triage_enabled` is `true` (or you know why it isn't)
2. Review `unsorted` tickets. If one category keeps catching the same kind of ticket, update `USER.md`
3. Check `SELECT status, COUNT(*) FROM triage_records WHERE created_at > datetime('now', '-1 day') GROUP BY status;`
4. Skim `#triage-alerts` for unresolved failures

## Weekly

1. Count `corrected` records. A rising rate means the categories or priority signals need tuning
2. Confirm the Zendesk service-user role still forbids public replies, status changes, merges, and assignment
3. Compress `memory/*.md` into `MEMORY.md` (stay under 200 lines, no ticket content)

## Emergency Stop

**Activate** (any support team member, any time):

```sh
jq '.triage_enabled = false | .reason = "REASON" | .stopped_by = "NAME" | .stopped_at = (now | todate)' \
  config/emergency-stop.json > /tmp/es.json && mv /tmp/es.json config/emergency-stop.json
```

Post the Emergency Stop template to `#triage-alerts`. The agent records events as `held` and writes nothing to Zendesk.

**Resume** (support lead only): set `triage_enabled` back to `true`, fill in `resume_notes`, `resumed_by`, `resumed_at`, and post a confirmation. Held events go back to `received` and are triaged in order.

## Incident Response

| Severity | Definition | First action |
|---|---|---|
| SEV-1 | The agent posted a public reply, changed a status, merged, assigned, or acted on instructions inside a ticket | Emergency stop. Revoke the Zendesk API token. Notify the support lead directly. Audit the service-user role: it should have made this impossible |
| SEV-2 | Mass mis-triage (wrong priority on many tickets), or the webhook stopped delivering | Emergency stop, fix the rules or webhook, re-triage the affected events |
| SEV-3 | One ticket mis-triaged or one write failed | The support lead corrects it (`corrected`), or the failed-triage sweep retries it |

Every incident gets a `ledger_state_transitions` row with a `reason`, and a postmortem in `memory/YYYY-MM-DD.md` that names one corrective action.

## Ledger Operations

```sh
sqlite3 data/zendesk-triage-ledger.db < schemas/zendesk-triage-ledger.sql   # first run
sqlite3 -csv data/zendesk-triage-ledger.db "SELECT * FROM ledger_state_transitions ORDER BY id DESC LIMIT 200;"
sqlite3 data/zendesk-triage-ledger.db ".backup data/backup-$(date +%F).db"
```
