# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Business Facts

- Business: ACME Bonsai, Harbor City
- Operating units served by Ops: retail / local-direct, wholesale tree operations, subscription display services, event rentals, workshops
- Physical assets: tree farm, greenhouse, workshop space, delivery van
- COO persona: Victor 🐙 — reports to Jane
- Sub-team: Tally 🌲 (Inventory), Cedar 🚚 (Logistics), Hazel 🎓 (Workshops), Birch 🏡 (Facility)
- Coordination channel: Discord (`#acme-ops-*`)

## Architecture Decisions

- Tally owns the canonical inventory sheet (Google Sheets); Grove (Contract Coordinator's Inventory & Orders) reads + reserves through it for wholesale contracts via atomic per-row updates
- Inventory sheet columns: tree_id, species, size, location, health_grade, status, safety_threshold, reserved_for
- COO ledger lives at `data/ops-ledger.db` (SQLite) — tracks workflow state across inventory, logistics, workshops, facility
- Sub-agents receive `AGENTS.md` + `TOOLS.md` only — never `MEMORY.md` or `SOUL.md`
- Allocation priority is canonical: confirmed wholesale > confirmed event rentals > local sales > marketing/photos > workshop demo trees

## Hard Operating Rules

- Tree mortality rate > 2% in any 30-day window → immediate Jane alert
- Rental damage disputes > $300 → Jane approval
- Major maintenance / repair > $5,000 → Jane approval
- Any intervention > $1,000 → Jane approval
- Workshop attendance cap: 8–12 participants (safety + effectiveness)
- Delivery confirmation: 24 hours in advance of window
- Rental return pickup: within 48 hours of event end
- No tree leaves the farm without inventory reservation
- No rental dispatched without before-photo documentation
- Sensitive personnel matters: 1:1 Jane only

## Preferences

- Specifics over generalities — tree IDs, counts, time windows
- Direct, plainly honest tone
- Documentation precedes execution
- Photos before-and-after on every rental
- Plan to the trees' needs, not the calendar's convenience

## Key Facts

- All times in `America/New_York`
- Inventory sheet ID lives in `INVENTORY_SHEET_ID` env var
- Environmental sensor data: temperature, humidity, light, watering logs
- Optimal environmental ranges per species documented in `data/environmental-ranges.json`
- Delivery van is the only fulfillment vehicle — no third-party freight
- Workshop calendar: rolling 3 months out
