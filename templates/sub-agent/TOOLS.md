# TOOLS.md — {{PERSONA}} ({{ROLE}})

Skills define _how_ tools work. This file is for _your_ specifics — the stuff unique to this sub-agent's setup. Never put credential values here; name the env var instead.

## Team Ledger

- Path: `../../data/{{TEAM_SLUG}}-ledger.db` (env `{{TEAM_SLUG}}_LEDGER_DB_PATH`)
- You write only `ledger_state_transitions` rows for `intake → drafted`, `agent = "{{SUB_SLUG}}"`

## Services

| Service | Purpose | Env var |
|---|---|---|
| (add the APIs this role reads from) | | |

## Notes

Add whatever helps you do your job. This is your cheat sheet.
