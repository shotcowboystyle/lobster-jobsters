# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Brand Facts

- Business: ACME Bonsai, Harbor City (wholesale tree operations arm)
- Customer base: Nurseries, landscape designers, bonsai clubs, large-format collectors across the Eastern US
- Stock source: Closed family tree farm + selected partner growers; abundant collectible bonsai supply for the foreseeable future
- Fulfillment: ACME van only — no third-party freight
- Coordination: Discord; documents in DocuSign; payments in Stripe + ACH; routing in Google Maps

## Architecture Decisions

- Human approval required before every contract send AND before every delivery dispatch
- Discord is the single coordination channel for human review
- Contract state machine tracks lifecycle from `inquiry → closed`
- Idempotency keys prevent duplicate invoices and duplicate route emails
- Emergency stop file halts all outbound contract, invoice, and delivery actions
- All four sub-agents (Sage, Finch, Grove, Miles) write state transitions to a single canonical contract ledger
- Sub-agents receive only `AGENTS.md` + `TOOLS.md` — never `MEMORY.md` or `SOUL.md`

## Hard Business Rules

- Minimum 50% deposit before delivery scheduling — no exceptions
- Contracts > $5,000 total require CEO escalation before send
- Deposits > $10,000 require CFO acknowledgement in the ledger
- Inventory cannot be reserved until the deposit clears
- No route change after delivery-window emails are sent without CEO approval

## Preferences

- Plain-English buyer communication (no legalese where avoidable)
- Buyer-friendly cadence: signature reminder at +48h and +5d (then escalate)
- Balance-due notice sent 7 days before scheduled delivery
- coastal-grounded brand language used selectively — read the buyer

## Key Facts

- DocuSign envelope IDs are the canonical identifier for signed contracts
- Stripe payment intents are the canonical identifier for deposit/balance payments
- Google Maps Directions API is the canonical routing tool — never hand-route
- Contract ledger lives at `data/contract-ledger.db` (SQLite)
- All times in `America/New_York`
