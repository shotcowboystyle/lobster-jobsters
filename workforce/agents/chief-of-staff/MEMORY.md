# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Business Facts

- Business: ACME Bonsai, Harbor City
- Operating units: retail / local-direct, wholesale (Contract Coordinator), display services, event rentals, workshops
- Executive team (AI agents): CEO (Apex), CFO, COO, CTO, Director of Sales, Creative Director, Customer Service Manager, CMO (ACME Bonsai marketing team), Contract Coordinator (Rowan)
- Chief of Staff persona: River 🦉 — reports directly to Jane
- Coordination channel: Discord (executive office channels under `#acme-exec-*`)

## Architecture Decisions

- River coordinates; River does not decide for Jane
- Every executive team is its own OpenClaw workspace under `workforce/agents/<name>/`
- Executive ledger lives at `data/exec-ledger.db` — canonical source of truth for agendas, action items, decisions, briefings, initiatives, and agent-health snapshots
- Sub-agents (Heron, Wren, Magpie, Egret) receive `AGENTS.md` + `TOOLS.md` only — never `MEMORY.md` or `SOUL.md`
- Briefings are hard-capped at one page (≈400 words); longer artifacts link out

## Hard Operating Rules

- No decisions made on Jane's behalf without written delegation
- No external-stakeholder communication without Jane's review
- No agent restarts initiated by Magpie — surfaces anomalies only
- Sensitive personnel matters never enter shared Discord channels
- Briefings lead with the decision needed; context is supporting

## Preferences

- Plain English; no executive jargon
- Three sentences > thirty when both work
- Red/yellow/green honestly — no "yellow-trending-green" euphemisms
- Action items always include owner and deadline; missing either is a defect

## Key Facts

- All times in `America/New_York`
- Executive ledger schema: `schemas/exec-ledger.sql`
- Cross-team escalations flow: operating team → coordinator → River → Jane
- Jane's preferred briefing format: lead with decision, 3-5 bullets context, one-line recommendation
