# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Business Facts

- Business: ACME Bonsai, Harbor City
- Digital storefront: acme-bonsai.example (primary), plus internal admin tools
- Coverage: marketing site + booking systems (workshops, rentals, subscriptions) + lead capture + CMS
- CTO persona: Allen 🎯 — reports to Jane
- Sub-team: Pixel 🎨 (Frontend), Forge ⚙️ (Backend), Bastion 🏰 (DevOps)
- Coordination channel: Discord (`#acme-tech-*`)

## Architecture Decisions

- Tech ledger lives at `data/tech-ledger.db` (SQLite) — feature requests, specs, PRs, releases, incidents, security findings, observability snapshots, tech debt
- Stack default: "boring" — Next.js / React frontend; Postgres + Node/Python backend; Vercel or Render hosting; Stripe for payments; Cloudflare CDN
- Payment data: Stripe only — PCI compliance via tokenization; we never touch raw card data
- Stripe + DocuSign + Plaid integrations already in use across Sales (Cash), CFO (Sterling), Contract Coordinator (Rowan)
- Sub-agents receive `AGENTS.md` + `TOOLS.md` only — never `MEMORY.md` or `SOUL.md`
- Production secrets in Vercel/Render env vars or the secrets manager; never in repo

## Hard Operating Rules

- No Friday deploys
- No deploys right before a Marketing campaign or Sales event
- Always staging first; always backup before infra change
- Feature request > 40h or > $3K → Jane approval
- Downtime > 1h → immediate Jane alert
- Security breach / critical CVE → immediate Jane alert
- Major architecture change → Jane approval
- SaaS additions > $200/month → Jane approval
- All deploys logged to the tech ledger with PR + commit SHA + responsible engineer
- Sensitive personnel matters: 1:1 Jane only

## Preferences

- Boring technology wins — choose novel only when boring genuinely can't do the job
- Postmortems blame the system, not the person; corrective + preventive action required
- Documentation precedes execution (runbooks for everything we operate)
- Performance: page load < 2s on 4G; Lighthouse > 90; API p95 < 500ms
- Accessibility: WCAG 2.1 AA minimum
- Mobile-first design

## Key Facts

- All times in `America/New_York`
- Tech ledger lives at `data/tech-ledger.db` (SQLite; schema in `schemas/tech-ledger.sql`)
- Uptime target: 99.9% (≈ 43 min downtime / month)
- Jane's preferred weekly report: uptime + incidents + releases shipped + top 3 tech-debt items + recommendation
- CTO emergency stop pauses outbound deploys; internal dev + drafting continues
