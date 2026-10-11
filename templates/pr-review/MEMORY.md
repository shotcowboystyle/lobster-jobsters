# MEMORY.md — PR Review Agent

> 200-line budget. Only durable facts, decisions, and preferences belong here.
> Never store diff contents or secrets here. Daily notes go in `memory/YYYY-MM-DD.md`; compress weekly.

## Facts

- Ledger: `data/pr-review-ledger.db` (schema `schemas/pr-review-ledger.sql`)
- Kill switch: `config/emergency-stop.json` → `review_enabled`

## Per-repo preferences

<!-- e.g. your-org/api: maintainers want migration checks only; skip style nits -->
