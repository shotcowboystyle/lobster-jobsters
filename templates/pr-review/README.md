# PR Review Agent 🔍

**Standalone template · Engineering · Risk: medium · Channel: Discord**

First-pass review on every new GitHub pull request in an allowlist of repositories. Summarizes the change, flags risky lines, posts **one** `COMMENT` review. **It never approves, never requests changes, never pushes.** A human still reviews and decides.

This is a standalone workspace, not part of the ACME Bonsai org chart. Drop it into any OpenClaw instance that reviews code.

Adapted from Donely's [pr-review-agent](https://github.com/charindithjaindu/donely-openclaw-agents/tree/main/agents/engineering/pr-review-agent) (MIT, see [`NOTICE`](NOTICE)), hardened to this repo's standards: kill switch, approval policy, ledger, idempotency, runbook, explicit skills allowlist.

## What it does

- On `pull_request.opened` / `synchronize` in an allowlisted repo: skip drafts, bot authors, and oversized PRs; otherwise read the diff.
- Summarize the change in 2–4 sentences: what, why (from the PR description), which surfaces.
- Run risk checks per hunk: missing tests, schema migrations, secret-shaped literals, unsafe eval/exec, removed tests, unbounded loops, leftover debug code.
- Post one review comment (`COMMENT` type) with inline annotations; record it in the ledger keyed by repo + PR + head SHA.
- Alert the Discord high-risk channel when secret-shaped strings appear — without echoing the secret.

## Why a human still reviews

The agent does the boring 30% of review so the human can spend time on the interesting 70%. It cannot approve, block, or push. Repo policy stays human-driven.

## Security model

- `APPROVE` and `REQUEST_CHANGES` are not in its vocabulary; only `COMMENT`.
- PR titles, descriptions, comments, and diffs are **untrusted input**. The agent never fetches URLs found in them and never follows instructions written in them.
- The repo allowlist is enforced twice: GitHub App installation and `USER.md`. Both must agree.
- GitHub App installation token only (short-lived), never a personal access token.

## Setup

```bash
cp -R templates/pr-review ~/.openclaw/workspaces/pr-review
jq -s 'reduce .[] as $c ({}; . * $c)' ~/.openclaw/openclaw.json \
  ~/.openclaw/workspaces/pr-review/openclaw.json > /tmp/openclaw.json \
  && mv /tmp/openclaw.json ~/.openclaw/openclaw.json
```

1. Create a GitHub App with `pull_requests: read+write` and `contents: read`; install it on each repo to cover.
2. List the same repos in `USER.md`.
3. Put names from `config/env.example` in your secrets manager.
4. Create the Discord channel in `config/discord-config.example.json`.
5. Read the `github` and `discord` skills' `SKILL.md` before merging the config — they are granted in `openclaw.json`.
6. Initialize the ledger: `sqlite3 data/pr-review-ledger.db < schemas/pr-review-ledger.sql`
7. Point the GitHub webhook (or your runtime's poller) at the agent; see `config/routines.example.sh`.

Prefer Slack? Swap the `discord` skill for your Slack skill and rename the channel; the rules don't change.

## Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Trigger, workflow, hard rules, state transitions, cost controls |
| `SOUL.md` / `IDENTITY.md` | Reviewer voice and persona |
| `USER.md` | Authority matrix, repo allowlist, review thresholds |
| `TOOLS.md` | Skills, token scope, secret patterns, what it never calls |
| `HEARTBEAT.md` | Periodic checks |
| `openclaw.json` | Agent entry to merge into your global OpenClaw config |
| `config/` | Kill switch, approval policy, env names, Discord channel, routines |
| `schemas/` | Ledger SQL and the review-comment contract |
| `discord-templates/` | High-risk PR alert, secret-detected alert |
| `ops/runbook.md` | Daily checks, incidents, emergency stop |
