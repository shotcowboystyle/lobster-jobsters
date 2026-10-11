# Client Reporting Agent 📊

**Standalone template · Agency · Risk: medium · Channel: Discord**

Each week, the agent drafts a report for every client from that client's own data sources: GA4, Search Console, ad accounts, and the project tracker. It posts each draft to the client's account manager (AM). **The agent never sends anything to a client.** The AM reviews it, edits it, and sends it.

This workspace stands alone. It isn't part of the ACME Bonsai org chart. Copy it into any OpenClaw instance that serves several clients.

Adapted from Donely's [client-reporting-agent](https://github.com/charindithjaindu/donely-openclaw-agents/tree/main/agents/agency/client-reporting-agent) (MIT, see [`NOTICE`](NOTICE)). It has been hardened to this repo's standards: kill switch, approval policy, ledger, idempotency, runbook, and an explicit skills allowlist.

## What it does

- Monday 08:00 local time: for each client in `USER.md`, it pulls the last 7 days from that client's configured sources.
- It drafts a one-page report with a headline, traffic, SEO winners and losers, paid spend and ROAS (if configured), project progress (if configured), and one next-week action.
- It posts the draft to the AM's Discord channel, in a thread for that client, and records it as `am_review` in the ledger.
- The AM sends the report to the client outside the agent and marks the draft `sent_by_am`.

## Why the AM stays in the loop

An agency's main asset is client trust. An agent that sends drafts to clients on its own is a liability. This agent has no client-facing send capability: no email, SMS, or client messaging tools. The AM is the contractual voice, and the agent only produces drafts.

## Keeping each client's data separate

- Credentials are namespaced per client: `CLIENT_<SLUG>_<INTEGRATION>`.
- Every API call is scoped to the client being reported on. If a credential is missing, that source is skipped for that client only. The agent never falls back to another client's credentials.
- Putting one client's data in another client's report is forbidden, and no approval can allow it.
- The ledger stores only lifecycle metadata (client slug, week, status, keys). Client metrics stay in the draft.

## Setup

```bash
cp -R templates/client-reporting ~/.openclaw/workspaces/client-reporting
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  ~/.openclaw/workspaces/client-reporting/openclaw.json > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

1. List your clients and AMs in `USER.md`.
2. Put the names from `config/env.example` in your secrets manager, with each client's credentials under its slug.
3. Create the Discord channels in `config/discord-config.example.json`, one per AM.
4. Grant data skills: read each skill's `SKILL.md`, then add it by name to `skills` in `openclaw.json`. Only `discord` ships granted.
5. Initialize the ledger: `sqlite3 data/client-reporting-ledger.db < schemas/client-reporting-ledger.sql`
6. Create the routines in `config/routines.example.sh`.

Prefer Slack? Swap the `discord` skill for your Slack skill and rename the channels. The rules don't change.

## Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Workflow, hard rules, client isolation, state transitions, cost controls |
| `SOUL.md` / `IDENTITY.md` | Report voice and persona |
| `USER.md` | Authority matrix, schedule, client list, report sections |
| `TOOLS.md` | Data sources, per-client credential scheme, what it never calls |
| `HEARTBEAT.md` | Periodic checks |
| `openclaw.json` | Agent entry to merge into your global OpenClaw config |
| `config/` | Kill switch, approval policy, env names, Discord channels, routines |
| `schemas/` | Ledger SQL and the report-draft contract |
| `discord-templates/` | Draft card, missing-credential alert, run summary |
| `ops/runbook.md` | Weekly run, incidents, emergency stop |
