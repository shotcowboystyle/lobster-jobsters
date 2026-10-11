# Zendesk Triage Agent 🎟️

**Standalone template · Customer support · Risk: medium · Channel: Discord**

Triages incoming Zendesk tickets. It categorises them, assesses priority, applies tags, and suggests an assignee in an internal note. It flags possible duplicates and posts a daily queue summary for the support lead. **Internal only: the agent never replies to customers, never closes tickets, and never assigns them.**

This workspace stands alone. It isn't part of the ACME Bonsai org chart. Copy it into any OpenClaw instance that fronts a Zendesk queue.

Adapted from Donely's [zendesk-triage-agent](https://github.com/charindithjaindu/donely-openclaw-agents/tree/main/agents/customer-support/zendesk-triage-agent) (MIT, see [`NOTICE`](NOTICE)). It has been hardened to this repo's standards: kill switch, approval policy, ledger, idempotency, runbook, and an explicit skills allowlist.

## What it does

- On every new ticket, and on updates that change customer-facing content, it classifies the ticket into a category from `USER.md`, assesses priority by the configured rules, applies `triaged`, `category:<x>`, and `priority:<y>` tags, and writes an internal note suggesting an assignee.
- It checks the last 7 days for duplicates and links any likely match in an internal note.
- Daily at 09:00 local time, it posts a queue summary to Discord: new tickets, priority breakdown, oldest open ticket, top three categories.
- It surfaces possible SEV-1 tickets to the support lead. The lead decides whether to page anyone.

## Why "internal only" carries weight

The agent has no public-reply capability. It can't be talked into answering a customer, because that tool isn't in its allowlist. The Zendesk service-user role must forbid it too: no public comments, status changes, merges, or assignments. That's defense in depth. Ticket text is untrusted input, so instructions inside a ticket are just data to triage.

## Setup

```bash
cp -R templates/zendesk-triage ~/.openclaw/workspaces/zendesk-triage
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  ~/.openclaw/workspaces/zendesk-triage/openclaw.json > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

1. In Zendesk (Admin, then Roles), create a custom role that allows reading tickets, writing tags, and writing internal notes. It must forbid status changes, public replies, merges, and assignment. Create a service user with that role and generate an API token.
2. Configure categories, suggested assignees, and priority signals in `USER.md`.
3. Put the names from `config/env.example` in your secrets manager.
4. Create the Discord channels in `config/discord-config.example.json`.
5. Grant the Zendesk skills: read each skill's `SKILL.md`, then add it by name to `skills` in `openclaw.json`. Only `discord` ships granted.
6. Initialize the ledger: `sqlite3 data/zendesk-triage-ledger.db < schemas/zendesk-triage-ledger.sql`
7. Point the Zendesk `ticket.created` / `ticket.updated` webhook at the agent, and create the routines in `config/routines.example.sh`.

Prefer Slack? Swap the `discord` skill for your Slack skill and rename the channels. The rules don't change.

## Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Triage workflow, daily summary, hard rules, state transitions, cost controls |
| `SOUL.md` / `IDENTITY.md` | Internal voice and persona |
| `USER.md` | Authority matrix, categories, assignees, priority rules, summary schedule |
| `TOOLS.md` | Skills, the Zendesk role it needs, credentials, what it never calls |
| `HEARTBEAT.md` | Periodic checks |
| `openclaw.json` | Agent entry to merge into your global OpenClaw config |
| `config/` | Kill switch, approval policy, env names, Discord channels, routines |
| `schemas/` | Ledger SQL and the triage-note contract |
| `discord-templates/` | Daily summary, possible SEV-1, duplicate, emergency stop |
| `ops/runbook.md` | Daily checks, incidents, emergency stop |
