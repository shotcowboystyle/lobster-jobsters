# SEO Content Planner 📝

**Standalone template · Marketing · Risk: medium · Channel: Discord**

Plans SEO content from real Search Console and GA4 data. It drafts briefs that writers can finish in one sitting, and it adds confirmed briefs to your content calendar. **The agent never publishes anything.** Every brief is a proposal until a human confirms it, and publishing always stays with the team.

This workspace stands alone. It isn't part of the ACME Bonsai org chart. Copy it into any OpenClaw instance that runs a content team.

Adapted from Donely's [seo-content-planner](https://github.com/charindithjaindu/donely-openclaw-agents/tree/main/agents/marketing/seo-content-planner) (MIT, see [`NOTICE`](NOTICE)). It has been hardened to this repo's standards: kill switch, approval policy, ledger, idempotency, runbook, and an explicit skills allowlist.

## What it does

- Monday 09:00 local time: pulls the last 7 days from Search Console and GA4, then posts a briefing with three opportunities, one risk (the biggest declining page), and one win.
- On request: drafts an editor-ready brief with target keyword, intent, H1, 5–8 H2s, internal links, competitor links to outrank, word count, and meta description.
- On confirmation: adds the brief as a card in the calendar's `Drafts` column, once, keyed by an idempotency key.

## Why it never publishes

Publishing is a brand decision. This agent has no CMS, social, newsletter, or ad API access. Its only write path is a card in the calendar's `Drafts` column, and only after a human confirms the brief. Editing a card in any other column needs explicit approval.

## Competitor pages are untrusted

The agent reads the text of top-ranking competitor pages to find gaps. That text is data, never instructions: anything that looks like an instruction gets ignored and flagged. Fetches respect `robots.txt`, are capped per brief, and only go to URLs that came from the SERP data.

## Setup

```bash
cp -R templates/seo-content-planner ~/.openclaw/workspaces/seo-content-planner
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  ~/.openclaw/workspaces/seo-content-planner/openclaw.json > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

1. Set the property, calendar database, channel, and schedule in `USER.md`.
2. Put the names from `config/env.example` in your secrets manager.
3. Create the Discord channels in `config/discord-config.example.json`.
4. Grant data skills: read each skill's `SKILL.md`, then add it by name to `skills` in `openclaw.json`. Only `discord` ships granted.
5. Initialize the ledger: `sqlite3 data/seo-content-planner-ledger.db < schemas/seo-content-planner-ledger.sql`
6. Create the routines in `config/routines.example.sh`.

Prefer Slack or Telegram? Swap the `discord` skill for yours and rename the channels. The rules don't change.

## Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Workflows, hard rules, state transitions, cost controls |
| `SOUL.md` / `IDENTITY.md` | Voice, brief structure, persona |
| `USER.md` | Authority matrix, property, calendar, schedule, defaults |
| `TOOLS.md` | Data sources, credentials, what it never calls |
| `HEARTBEAT.md` | Periodic checks |
| `openclaw.json` | Agent entry to merge into your global OpenClaw config |
| `config/` | Kill switch, approval policy, env names, Discord channels, routines |
| `schemas/` | Ledger SQL, brief and weekly-briefing contracts |
| `discord-templates/` | Briefing, brief card, calendar confirmation, alerts |
| `ops/runbook.md` | Weekly run, incidents, emergency stop |
