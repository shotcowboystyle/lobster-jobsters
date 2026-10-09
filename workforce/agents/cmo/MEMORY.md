# MEMORY.md

> 200-line budget. Updated weekly by SCRIBE compression.
> Only durable facts, decisions, and preferences belong here.

## Brand Facts

- Business: ACME Bonsai, Harbor City
- Stock source: Closed tree farm, abundant collectible bonsai for foreseeable future
- Verticals: wholesale, local direct sales, subscription display services, event rentals
- Social channels: Instagram, Facebook Pages
- Coordination: Discord

## Architecture Decisions

- Human approval required before every publish action
- Discord is the single coordination channel for all human review
- Post state machine tracks lifecycle from planned → archived
- Idempotency keys prevent duplicate publishing
- Emergency stop file halts all outbound publishing

## Preferences

- Vertical voices must remain distinct
- Never invent facts — use [PLACEHOLDER]
- Understated elegance over hype

## Key Facts

- Instagram requires container creation + publish (no direct scheduled_publish_time)
- Facebook supports unpublished + scheduled_publish_time flow
- Meta tokens managed outside agent workspace
