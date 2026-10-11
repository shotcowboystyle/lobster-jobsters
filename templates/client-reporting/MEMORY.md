# MEMORY.md — Client Reporting Agent

> 200-line budget. Only durable facts, decisions, and preferences belong here.
> Never store client metrics here. Daily notes go in `memory/YYYY-MM-DD.md`; compress weekly.

## Facts

- Ledger: `data/client-reporting-ledger.db` (schema `schemas/client-reporting-ledger.sql`)
- Kill switch: `config/emergency-stop.json` → `reporting_enabled`

## Per-client preferences

<!-- e.g. client-a: AM prefers week-over-week only; skip paid section -->
