# Booking Search Agent 🏨

**Standalone template · Travel · Risk: low · Channel: Discord (or any chat channel)**

Answers natural-language hotel questions ("hotels in Lisbon next weekend, 2 adults") with the top results from a **sanctioned hotel search provider**: price, review score, distance, one distinguishing feature, and a booking link. Research only — it never books, holds, pays, or enters guest details.

Standalone: not part of the ACME Bonsai org chart. Copy it into any OpenClaw instance.

Adapted from Donely's [booking-search-agent](https://github.com/charindithjaindu/donely-openclaw-agents/tree/main/agents/travel/booking-search-agent) (MIT, see [`NOTICE`](NOTICE)), hardened to this repo's standards: kill switch, approval policy, ledger, dedupe keys, search caps, runbook, explicit skills allowlist.

## Why the upstream scraper isn't included

Upstream bundles a Node CLI that scrapes booking.com and **auto-solves its AWS WAF bot challenge**. That is anti-bot circumvention: it works against the site's access controls, likely breaches its terms, and can break or get your IP blocked at any time. This repo also ships no runtime code. So this template is provider-agnostic: you grant a search skill backed by an official or affiliate hotel API whose terms permit automated queries. The workflow, presentation rules, and output contract are kept from upstream.

## What it does

- Parses the request into location, dates, guests, rooms, currency; asks once only when something is genuinely ambiguous.
- Searches via the granted provider skill, then confirms the resolved destination back to the user ("Paris, Île-de-France, France", not "Paris, Texas").
- Summarizes 5–8 hotels plus the total result count. Missing fields show as "not listed", never guessed.
- Reuses a recent identical search instead of re-querying (dedupe key per normalized query per hour).
- On a provider block, rate limit, or CAPTCHA: stops and tells the user. No retries around it.

## Setup

```bash
cp -R templates/booking-search ~/.openclaw/workspaces/booking-search
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  ~/.openclaw/workspaces/booking-search/openclaw.json > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

1. Pick a provider whose terms allow automated search. Install its skill, read its `SKILL.md`, confirm it is search-only (no booking endpoints), then add its name to `skills` in `openclaw.json`. Ships with `[]`.
2. Put the provider key named in `config/env.example` in your secrets manager.
3. Set defaults in `USER.md`.
4. Initialize the ledger: `sqlite3 data/booking-search-ledger.db < schemas/booking-search-ledger.sql`

## Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Workflow, hard rules, failure modes, state transitions, cost controls |
| `SOUL.md` / `IDENTITY.md` | Presentation voice and persona |
| `USER.md` | Authority matrix and search defaults |
| `TOOLS.md` | Expected search-skill contract, what it never calls |
| `HEARTBEAT.md` | Periodic checks |
| `openclaw.json` | Agent entry to merge into your global OpenClaw config |
| `config/` | Kill switch, approval policy, env names, Discord channel, routines |
| `schemas/` | Ledger SQL and the search-result contract |
| `discord-templates/` | Result summary, blocked, no-results replies |
| `ops/runbook.md` | Daily check, incidents, emergency stop |
