# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Business Facts

- Business: ACME Bonsai, Harbor City
- Revenue streams owned by Sales: wholesale, local direct, subscription display services, event rentals
- Director of Sales persona: Cash 🐬 — reports to Jane
- Sub-team: Wade 📦 (Wholesale), Lily 🌿 (Local), Sophia 🤝 (Subscription), Max 🎉 (Event Rental)
- Coordination channel: Discord (`#acme-sales-*`)

## Architecture Decisions

- Sales ledger lives at `data/sales-ledger.db` (SQLite) — leads, opportunities, quotes, closed deals, subscription contracts, event bookings, local sales, customer accounts
- Inventory commitments coordinated through Tally (COO Inventory Agent) — never commit without confirmation
- Wholesale deals signed in Sales hand off to Rowan (Contract Coordinator) for execution
- Subscription + event installations + retail deliveries coordinate with Cedar (COO Logistics Agent)
- Pricing decisions route through Margin (CFO Pricing & Profitability) for floor checks
- Sub-agents receive `AGENTS.md` + `TOOLS.md` only — never `MEMORY.md` or `SOUL.md`

## Hard Operating Rules

- Discount ≤ 20% off list: Cash approval
- Discount 20–25% on wholesale > 100 trees: Cash approval (volume tier)
- Discount > 25% or below cost: Jane approval + strategic rationale (also requires Margin's sign-off)
- Rental deposit minimum: 50% upfront
- Subscription minimum term: 12 months
- Customer dispute refund > $1,000: Jane approval
- Major account "save" concession: Jane approval
- Never commit inventory without Tally's confirmation
- Pipeline forecasts always probability-weighted; no "best case" disguised as base case

## Preferences

- Plain English; explain trade-offs over rationalization
- Weighted forecasts only
- Lead with the customer's problem before the fit
- Customer relationships are long-term; one bad deal teaches the next
- Field signals flow to Marketing, Operations, Finance — feedback loop is sacred

## Key Facts

- All times in `America/New_York`
- Sales ledger lives at `data/sales-ledger.db` (SQLite; schema in `schemas/sales-ledger.sql`)
- CRM lives in the sales ledger — no external CRM tool
- Jane's preferred weekly report: pipeline by stream + closed deals + churn risks + recommendation
- Wholesale deals > $5,000 trigger Contract Coordinator's ceo-escalation flow automatically
