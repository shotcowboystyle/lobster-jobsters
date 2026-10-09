# Runbook — {{TEAM_NAME}} Team ({{PERSONA}})

Operating procedures for the {{COMPANY}} {{TEAM_SHORT}} team. Read alongside the workspace-level `ops/exec-runbook.md`.

## Daily

1. Confirm `config/emergency-stop.json` → `{{FLAG}}` is `true` (or know why it is not)
2. Review `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-approvals` for cards older than 24h
3. Check `SELECT * FROM v_stale_reviews;` in the ledger
4. Skim `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-alerts` for unresolved failures

## Weekly

1. Run `scripts/ledger.sh metrics {{TEAM_SLUG}}` — volume, time-in-state, approval latency
2. Compress `memory/*.md` into `MEMORY.md` (stay under 200 lines)
3. Verify nightly ledger backup exists and restores (`sqlite3 backup.db .tables`)
4. Review sub-agent cost-budget exhaustion events; tune budgets, not behavior

## Emergency Stop

**Activate** (any time, {{PERSONA}} or {{OWNER}}):

```sh
jq '.{{FLAG}} = false | .reason = "REASON" | .stopped_by = "NAME" | .stopped_at = (now | todate)' \
  config/emergency-stop.json > /tmp/es.json && mv /tmp/es.json config/emergency-stop.json
```

Then post to `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-alerts` using the Emergency Stop template. Agents keep drafting; nothing leaves the workspace.

**Resume** ({{OWNER}} only): set `{{FLAG}}` back to `true`, fill `resume_notes`, `resumed_by`, `resumed_at`, post confirmation.

The workspace-level `config/shared-emergency-stop.json` overrides this file. If `all_outbound_enabled` is `false`, this team is stopped regardless.

## Incident Response

| Severity | Definition | First action |
|---|---|---|
| SEV-1 | Outbound side-effect executed without approval, data exposure, financial error | Emergency stop, page {{OWNER}} directly, notify River |
| SEV-2 | Repeated execution failures, approval pipeline stalled > 48h | Hold affected items, alert channel, {{PERSONA}} triages |
| SEV-3 | Single failure with clean retry path | Retry per policy (max 3), log reason |

Every incident gets a `ledger_state_transitions` row with `reason` and a postmortem in `memory/YYYY-MM-DD.md` naming one corrective action.

## Ledger Operations

```sh
scripts/ledger.sh init {{TEAM_SLUG}}            # first run
scripts/ledger.sh transitions {{TEAM_SLUG}} 200 # evidence export (CSV)
sqlite3 data/{{TEAM_SLUG}}-ledger.db ".backup data/backup-$(date +%F).db"
```
