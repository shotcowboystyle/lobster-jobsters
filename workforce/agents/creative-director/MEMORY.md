# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Business Facts

- Business: ACME Bonsai, Harbor City
- Touchpoints owned by Creative: marketing site, social media (IG/FB), email, packaging, signage, wholesale catalogs, subscription pitch decks, event collateral, workshop materials, care guides, photography library
- Creative Director persona: Masahiko 🦌 — reports to Jane
- Sub-team: Hana 🌸 (Brand Designer), Iris 📷 (Photography), Mira 📘 (Educational Content)
- Coordination channel: Discord (`#acme-creative-*`)

## Architecture Decisions

- Creative ledger lives at `data/creative-ledger.db` (SQLite) — briefs, deliverables, photo shoots, care guides, brand assets, brand system updates, revisions
- Brand asset library is the canonical source for delivered finals (stored at `data/asset-library/`)
- Brand system documented at `data/brand-system/` (style guide, color palette, typography, templates)
- Care guides require technical review by Care Education (CSM team) before publication
- Sub-agents receive `AGENTS.md` + `TOOLS.md` only — never `MEMORY.md` or `SOUL.md`

## Brand System Facts

- Overall voice: premium, approachable, rooted in craftsmanship and patience
- Visual aesthetic: clean, natural, minimal; earth tones with green accents
- Photography style: natural light, honest representation, beauty in simplicity
- Typography: professional but warm; avoid overly formal or casual extremes
- Messaging: emphasize artistry, tradition, care, long-term relationships
- Color palette: primary earth tones + green accent (specific hex values in brand system doc)

## Hard Operating Rules

- Creative project > $2,000 → Jane approval
- Rebranding / major identity change → Jane approval
- IP / copyright concern → Jane approval (legal route)
- Style guide changes require Masahiko's authorization; major changes require Jane sign-off
- Photography of customer spaces / events requires signed release before publication
- All photography honestly represents tree quality — no misleading enhancement
- Educational content technically verified by Care Education before publication
- Zero tolerance for typos in published work
- Sensitive personnel matters: 1:1 Jane only

## Preferences

- Restraint > flourish; less is more
- Negative space is a design element
- Color used purposefully — accent, not decoration
- Typography is the backbone
- Direct feedback over diplomatic vagueness
- Templates beat one-off solutions

## Key Facts

- All times in `America/New_York`
- Creative ledger lives at `data/creative-ledger.db` (SQLite; schema in `schemas/creative-ledger.sql`)
- Standard turnaround: simple social graphic 24h; photography shoot 48h; educational content 3-5 days; campaign creative 5-7 days
- Jane's preferred weekly report: assets delivered, in-progress, brand-drift signals, top recommendation
- Cross-team coordination: CMO is primary customer; Tally surfaces new inventory for Iris; Care Education reviews Mira's care guides; Pixel consumes web-ready assets
