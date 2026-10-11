# Runbook — Client Reporting Agent

## Weekly

1. Monday: confirm the Run Summary posted and `config/emergency-stop.json` → `reporting_enabled` is `true` (or you know why it isn't)
2. Check `SELECT * FROM v_stale_reviews;` and nudge AMs whose drafts are older than 48h
3. Review `source_skips` for the week. A recurring `missing_credential` means a client's setup is incomplete
4. Compress `memory/*.md` into `MEMORY.md` (stay under 200 lines, no client metrics)

## Adding a client

1. The owner approves (`add_client`)
2. Add the client block to `USER.md` and its AM channel to `config/discord-config.example.json`
3. Set `CLIENT_<SLUG>_*` in the secrets manager, using read-only credentials scoped to that client's properties
4. Redeploy, then confirm next Monday's draft for that client includes only its own data

## Emergency Stop

**Activate** (any AM or the owner, any time):

```sh
jq '.reporting_enabled = false | .reason = "REASON" | .stopped_by = "NAME" | .stopped_at = (now | todate)' \
  config/emergency-stop.json > /tmp/es.json && mv /tmp/es.json config/emergency-stop.json
```

Post the Emergency Stop template to `#reporting-alerts`. The agent keeps drafts local, and nothing posts.

**Resume** (owner only): set `reporting_enabled` back to `true`, fill in `resume_notes`, `resumed_by`, `resumed_at`, and post a confirmation.

## Incident Response

| Severity | Definition | First action |
|---|---|---|
| SEV-1 | A client's data appeared in another client's draft or thread, or anything was sent to a client by the agent | Emergency stop. Delete the affected Discord messages. Notify the owner directly. Rotate the affected client's credentials if a misrouting is suspected. If a client saw it, the owner decides on disclosure |
| SEV-2 | A whole weekly run failed, or a source failed for every client | Alert channel, fix the source or credentials, re-run (idempotency skips drafts already done) |
| SEV-3 | One source failed for one client | It's already skipped and noted in the draft. Fix before next week |

Every incident gets a `ledger_state_transitions` row with a `reason`, and a postmortem in `memory/YYYY-MM-DD.md` that names one corrective action.

## Ledger Operations

```sh
sqlite3 data/client-reporting-ledger.db < schemas/client-reporting-ledger.sql   # first run
sqlite3 -csv data/client-reporting-ledger.db "SELECT * FROM ledger_state_transitions ORDER BY id DESC LIMIT 200;"
sqlite3 data/client-reporting-ledger.db ".backup data/backup-$(date +%F).db"
```
