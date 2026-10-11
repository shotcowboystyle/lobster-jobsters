# MEMORY.md — Booking Search Agent

> 200-line budget. Only durable facts, decisions, and preferences belong here.
> Never store guest names, contact details, or payment data. Daily notes go in `memory/YYYY-MM-DD.md`; compress weekly.

## Facts

- Ledger: `data/booking-search-ledger.db` (schema `schemas/booking-search-ledger.sql`)
- Kill switch: `config/emergency-stop.json` → `search_enabled`
- Search provider skill: <!-- name it here once granted -->

## Preferences

<!-- e.g. team prefers free-cancellation options listed first -->
