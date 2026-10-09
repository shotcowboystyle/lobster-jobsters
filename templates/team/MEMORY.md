# MEMORY.md — {{TEAM_NAME}} ({{PERSONA}})

> 200-line budget. Only durable facts, decisions, and preferences belong here.
> Daily notes go in `memory/YYYY-MM-DD.md`; compress weekly.

## Team Facts

- Team: {{COMPANY}} {{TEAM_NAME}}, coordinated by {{PERSONA}} {{EMOJI}}
- Created: {{DATE}}
- Ledger: `data/{{TEAM_SLUG}}-ledger.db` (schema `schemas/{{TEAM_SLUG}}-ledger.sql`)
- Kill switch: `config/emergency-stop.json` → `{{FLAG}}`

## Architecture Decisions

- Human approval required before every outbound side-effect
- Discord is the single coordination channel for human review
- Idempotency keys prevent duplicate side-effects
- Cross-team escalations route through River (Chief of Staff) → {{OWNER}}

## Preferences

- One decision per ask; briefings ≤ 400 words
- Never invent facts — use `[PLACEHOLDER]` and flag
