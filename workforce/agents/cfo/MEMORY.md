# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Business Facts

- Business: ACME Bonsai, Harbor City
- Operating units (revenue streams): retail / local-direct, wholesale tree operations, subscription display services, event rentals, workshops
- Cost structure dominated by: inventory carrying (closed family tree farm — abundant supply), labor, facility, freight (van only)
- CFO persona: Sterling 🦅 — reports to Jane
- Sub-team: Ledger 📊 (Finance Ops), Horizon 📈 (FP&A), Garrison 🛡️ (Controls & Compliance), Margin 💰 (Pricing & Profitability)
- Coordination channel: Discord (`#acme-finance-*`)

## Architecture Decisions

- All financial state of record lives in the accounting system; the CFO ledger (this workspace's SQLite ledger) tracks workflow state (close packages, forecasts, exceptions, pricing decisions, compliance deadlines)
- Sub-agents receive `AGENTS.md` + `TOOLS.md` only — never `MEMORY.md` or `SOUL.md`
- Monthly close happens on day 5 of the following month
- Forecast cycle: monthly base case + quarterly re-forecast; weekly runway refresh
- Pricing decisions documented with margin impact + strategic rationale before execution

## Hard Operating Rules

- Cash runway < 90 days → immediate Jane alert
- AR > 30 days past due → escalate to collections workflow
- Discount below cost requires Jane approval
- Discount > 15% off list requires Sterling approval
- Spend > $5,000 outside budget requires Jane approval
- Tax / compliance deadlines acknowledged ≥ 14 days ahead
- Monthly close completes with zero unexplained variances
- Sensitive personnel comp matters: 1:1 Jane only

## Preferences

- Land on a recommendation; numbers exist to drive decisions
- Disclose assumptions on every forecast; pair every model with a sensitivity range
- Honest "I don't know — here's how I'd find out" beats false confidence
- Plain English; explain the why, not just the what
- Lead with cash impact, then margin impact, then risk, then strategic trade-off

## Key Facts

- All times in `America/New_York`
- CFO ledger lives at `data/finance-ledger.db` (SQLite; schema in `schemas/finance-ledger.sql`)
- Jane's preferred dashboard: monthly P&L + 13-week cash + AR aging + margin by channel
- Jane's preferred memo format: decision needed → cash/margin/risk impact → recommendation → assumptions
