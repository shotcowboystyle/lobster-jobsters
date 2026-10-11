# Runbook — SEO Content Planner

## Weekly

1. Monday: confirm the briefing posted and `config/emergency-stop.json` → `planner_enabled` is `true` (or you know why it isn't)
2. Check `SELECT * FROM v_stale_reviews;` for briefs waiting on the user
3. Review `competitor_fetches` where `outcome = 'injection_flagged'`. Repeated flags from one domain are worth a note in `MEMORY.md`
4. Compress `memory/*.md` into `MEMORY.md` (stay under 200 lines)

## Emergency Stop

**Activate** (anyone on the team, any time):

```sh
jq '.planner_enabled = false | .reason = "REASON" | .stopped_by = "NAME" | .stopped_at = (now | todate)' \
  config/emergency-stop.json > /tmp/es.json && mv /tmp/es.json config/emergency-stop.json
```

Post the Emergency Stop template to `#seo-alerts`. The agent keeps drafting locally, and nothing is written or posted.

**Resume** (marketing lead only): set `planner_enabled` back to `true`, fill in `resume_notes`, `resumed_by`, `resumed_at`, and post a confirmation.

## Incident Response

| Severity | Definition | First action |
|---|---|---|
| SEV-1 | Anything published, scheduled, or posted externally, or a calendar card created or edited outside `Drafts` without approval | Emergency stop. Revert or unpublish by hand. Notify the marketing lead. Revoke the calendar token if its scope was wider than the calendar database |
| SEV-2 | The agent acted on instructions found in competitor text, or reported numbers that no source returned | Emergency stop. Pull the affected briefs back to `drafted`. Review the agent's prompts and skills |
| SEV-3 | A data source or calendar write failed | Retry per the cost controls, then alert. Fix credentials before next Monday |

Every incident gets a `ledger_state_transitions` row with a `reason`, and a postmortem in `memory/YYYY-MM-DD.md` that names one corrective action.

## Ledger Operations

```sh
sqlite3 data/seo-content-planner-ledger.db < schemas/seo-content-planner-ledger.sql   # first run
sqlite3 -csv data/seo-content-planner-ledger.db "SELECT * FROM ledger_state_transitions ORDER BY id DESC LIMIT 200;"
sqlite3 data/seo-content-planner-ledger.db ".backup data/backup-$(date +%F).db"
```
