# Runbook — Booking Search Agent

## Daily

1. Read the Daily Usage Check line in `#search-alerts`
2. Confirm `config/emergency-stop.json` → `search_enabled` is `true` (or you know why it isn't)
3. Any `blocked` searches? Check the provider's status page and your quota. Wait it out; never bypass

## Changing the search provider

1. Owner approves (`add_search_provider`)
2. Read the new skill's `SKILL.md` and the provider's terms: search-only, automated queries permitted, no scraping or challenge solving
3. Swap the skill name in `openclaw.json`, set `HOTEL_SEARCH_API_KEY`, re-merge into the global config
4. Run one known search and check the reply matches `schemas/search-result.schema.json`

## Emergency Stop

**Activate** (anyone using the channel, or the owner):

```sh
jq '.search_enabled = false | .reason = "REASON" | .stopped_by = "NAME" | .stopped_at = (now | todate)' \
  config/emergency-stop.json > /tmp/es.json && mv /tmp/es.json config/emergency-stop.json
```

Post the Emergency Stop template to `#search-alerts`. No searches run.

**Resume** (owner only): set `search_enabled` back to `true`, fill `resume_notes`, `resumed_by`, `resumed_at`, post confirmation.

## Incident Response

| Severity | Definition | First action |
|---|---|---|
| SEV-1 | Any booking, hold, or payment attempt, or guest personal data sent to a provider | Emergency stop. Revoke the provider key. Notify the owner directly. Check the provider account for any reservation and cancel it |
| SEV-2 | Provider block, rate limit, or CAPTCHA | Stop searching (already automatic). Wait for the provider; check quota. Never bypass. Resume when it clears |
| SEV-3 | One failed or partial search | It's recorded as `failed` and the user was told. No action unless it repeats |

Every incident gets a `ledger_state_transitions` row with a `reason`, and a postmortem in `memory/YYYY-MM-DD.md` that names one corrective action.

## Ledger Operations

```sh
sqlite3 data/booking-search-ledger.db < schemas/booking-search-ledger.sql   # first run
sqlite3 data/booking-search-ledger.db "SELECT status, COUNT(*) FROM searches WHERE created_at > datetime('now','-1 day') GROUP BY status;"
sqlite3 data/booking-search-ledger.db ".backup data/backup-$(date +%F).db"
```
