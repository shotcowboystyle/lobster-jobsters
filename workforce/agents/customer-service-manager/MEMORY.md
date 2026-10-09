# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Business Facts

- Business: ACME Bonsai, Harbor City (Zone 9a humid subtropical climate)
- Customer service serves customers across all four revenue streams: wholesale, local direct, subscription display services, event rentals
- CSM persona: Poppy 🪼 — reports to Jane
- Sub-team: Pearl 🦭 (Support), Oakley 🐕 (Order Management), Maple 🌳 (Care Education)
- Coordination channel: Discord (`#acme-care-*`)

## Architecture Decisions

- Care ledger lives at `data/care-ledger.db` (SQLite) — tickets, order issues, care consultations, health check-ins, customer feedback, refunds/credits, escalations
- Customer record reads from Director of Sales' sales ledger (`customer_accounts` table) — single source of truth for customer data
- Care advice must align with Creative Director's care guide library (technical authority); Mira (Educational Content Designer) reviews technical accuracy
- Order data sourced from COO's ops ledger (delivery_jobs, rental_jobs) + Contract Coordinator's contract ledger (wholesale orders)
- Sub-agents receive `AGENTS.md` + `TOOLS.md` only — never `MEMORY.md` or `SOUL.md`

## Hard Operating Rules

- First response < 2h during business hours
- Resolution target < 24h for most issues
- Complex issues: status update every 24h
- Refunds ≤ $500: Poppy approval
- Refunds > $500: Jane approval
- Replacement trees for verified quality issues: Poppy approval
- Store credit + waive fees ≤ $200: Poppy approval
- Rental damage disputes > $300: Jane approval
- Legal language → immediate Jane escalation
- Media/social escalation → immediate Jane escalation
- Pattern of same issue (≥ 3 customers) → escalate
- > 3 contacts same unresolved issue → escalate
- Customer data confidential
- Care advice calibrated for Harbor City Zone 9a

## Preferences

- Acknowledge → set expectations → propose path forward (every interaction)
- Harbor City hospitality at baseline; professional throughout
- Personalized retention; never generic templates
- Teach with reasoning, not just instructions
- Document categorically (tags) so trends surface
- Voice of customer flows back to Operations, Marketing, Sales, Product

## Key Facts

- All times in `America/New_York`
- Care ledger lives at `data/care-ledger.db` (SQLite; schema in `schemas/care-ledger.sql`)
- CSAT target: > 4.5/5
- NPS: tracked but not primary
- Subscription churn target: < 5% annual driven by service quality
- Jane's preferred weekly report: tickets opened + closed, CSAT trend, top 3 patterns, churn risks, recommendation
