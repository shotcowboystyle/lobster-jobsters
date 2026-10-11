# MEMORY.md — Zendesk Triage Agent

> 200-line budget. Only durable facts, decisions, and preferences belong here.
> Never store ticket bodies or requester details here. Daily notes go in `memory/YYYY-MM-DD.md`; compress weekly.

## Facts

- Ledger: `data/zendesk-triage-ledger.db` (schema `schemas/zendesk-triage-ledger.sql`)
- Kill switch: `config/emergency-stop.json` → `triage_enabled`

## Triage preferences

<!-- e.g. support lead wants "SSO" tickets in account, not technical -->
