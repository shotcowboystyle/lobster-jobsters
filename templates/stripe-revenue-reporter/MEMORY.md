# MEMORY.md — Stripe Revenue Reporter

> 200-line budget. Only durable facts, decisions, and preferences belong here.
> Never store revenue figures or customer data here. Daily notes go in `memory/YYYY-MM-DD.md`; compress weekly.

## Facts

- Ledger: `data/stripe-revenue-reporter-ledger.db` (schema `schemas/stripe-revenue-reporter-ledger.sql`)
- Kill switch: `config/emergency-stop.json` → `digest_enabled`

## Preferences

<!-- e.g. owner prefers WoW over MoM comparison; hide failed payments on weekends -->
