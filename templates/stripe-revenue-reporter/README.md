# Stripe Revenue Reporter 💰

**Standalone template · Finance · Risk: low · Channel: Discord**

Posts yesterday's Stripe revenue to your team channel every morning, and runs the same report for any date range on request. **Read-only.** No refunds, no charges, no PII.

This workspace stands alone. It isn't part of the ACME Bonsai org chart. Copy it into any OpenClaw instance that has a Stripe account to report on.

Adapted from Donely's [stripe-revenue-reporter](https://github.com/charindithjaindu/donely-openclaw-agents/tree/main/agents/finance/stripe-revenue-reporter) (MIT, see [`NOTICE`](NOTICE)). It has been hardened to this repo's standards: kill switch, approval policy, ledger, idempotency, runbook, and an explicit skills allowlist.

## What it does

- Daily 09:00 local time: gross, net, refunds, failed payments, MRR delta, and top customers by net revenue for yesterday.
- On request ("show me last week", "what did April look like"): the same report for that range, replied inline.
- If Stripe returns an error or partial data, it skips the digest and says so. It never posts numbers it can't stand behind.

## Why read-only matters

A revenue reporter that can also refund or charge turns every prompt injection into a money movement. This agent has no Stripe write path: a restricted key with read scopes only, and no write skill granted. If you ever need refunds, retries, or customer messaging, build a separate agent with its own approval gates.

## Privacy

- Digests never contain card numbers, BIN, last-4, or full email addresses. Customer names only.
- Nothing from Stripe is cached. Every report queries fresh.
- The ledger stores run lifecycle only (period, status, keys). Revenue figures live in the posted digest, not the ledger.

## Setup

```bash
cp -R templates/stripe-revenue-reporter ~/.openclaw/workspaces/stripe-revenue-reporter
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  ~/.openclaw/workspaces/stripe-revenue-reporter/openclaw.json > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

1. In Stripe → Developers → API keys → **Create restricted key**. Grant **read** on Charges, Refunds, Customers, Subscriptions, Invoices. Nothing else.
2. Fill in `USER.md`: channel, schedule, currency.
3. Put the names from `config/env.example` in your secrets manager.
4. Create the Discord channels in `config/discord-config.example.json`.
5. Grant a Stripe read skill: read its `SKILL.md`, confirm it only calls read endpoints, then add it by name to `skills` in `openclaw.json`. Only `discord` ships granted.
6. Initialize the ledger: `sqlite3 data/stripe-revenue-reporter-ledger.db < schemas/stripe-revenue-reporter-ledger.sql`
7. Create the routine in `config/routines.example.sh`.

Prefer Slack or Telegram? Swap the `discord` skill for your Slack or Telegram skill and rename the channel. The rules don't change.

## Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Workflow, hard rules, state transitions, cost controls |
| `SOUL.md` / `IDENTITY.md` | Digest voice and persona |
| `USER.md` | Authority matrix, channel, schedule, presentation |
| `TOOLS.md` | Restricted-key requirement, skills, what it never calls |
| `HEARTBEAT.md` | Periodic checks |
| `openclaw.json` | Agent entry to merge into your global OpenClaw config |
| `config/` | Kill switch, approval policy, env names, Discord channels, routines |
| `schemas/` | Ledger SQL and the digest contract |
| `discord-templates/` | Daily digest, partial-data skip notice, emergency stop |
| `ops/runbook.md` | Daily check, incidents, emergency stop |
