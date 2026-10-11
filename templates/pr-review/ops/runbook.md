# Runbook — PR Review Agent

## Daily

1. Confirm `config/emergency-stop.json` → `review_enabled` is `true` (or know why it isn't)
2. Check `SELECT * FROM v_stuck_reviews;` and the `failed` reviews in `#eng-alerts`
3. Act on any Secret-Detected alert: confirm with the PR author, rotate if real

## Weekly

1. Skim a sample of posted reviews: are annotations specific and few? Tune `max_changed_lines` or checks, not the hard rules
2. Confirm the GitHub App is installed only on allowlisted repos
3. Compress `memory/*.md` into `MEMORY.md` (under 200 lines, no diff contents)

## Adding a repository

1. Owner approves (`add_repository`)
2. Add it to `USER.md`, install the GitHub App on it
3. Redeploy; confirm the next PR there gets exactly one `COMMENT` review

## Emergency Stop

**Activate** (any maintainer or the owner, any time):

```sh
jq '.review_enabled = false | .reason = "REASON" | .stopped_by = "NAME" | .stopped_at = (now | todate)' \
  config/emergency-stop.json > /tmp/es.json && mv /tmp/es.json config/emergency-stop.json
```

Post the Emergency Stop template to `#eng-alerts`. For a hard stop, also suspend the GitHub App installation.

**Resume** (owner only): set `review_enabled` back to `true`, fill `resume_notes`, `resumed_by`, `resumed_at`, post confirmation.

## Incident Response

| Severity | Definition | First action |
|---|---|---|
| SEV-1 | Agent submitted APPROVE or REQUEST_CHANGES, pushed or edited a branch, reviewed a non-allowlisted repo, or echoed a secret value anywhere | Emergency stop; suspend the GitHub App installation; dismiss the review / revert the push; delete any message containing the secret and rotate it; notify the owner directly |
| SEV-2 | Agent followed instructions from PR content, fetched a URL from it, or posted duplicate reviews for one head SHA | Emergency stop; delete the offending output; fix the prompt or skill grant before resuming |
| SEV-3 | Single review failed after retries | Already alerted; re-trigger by pushing or re-delivering the webhook |

Every incident gets a `ledger_state_transitions` row with `reason` and a postmortem in `memory/YYYY-MM-DD.md` naming one corrective action.

## Ledger Operations

```sh
sqlite3 data/pr-review-ledger.db < schemas/pr-review-ledger.sql   # first run
sqlite3 -csv data/pr-review-ledger.db "SELECT * FROM ledger_state_transitions ORDER BY id DESC LIMIT 200;"
sqlite3 data/pr-review-ledger.db ".backup data/backup-$(date +%F).db"
```
