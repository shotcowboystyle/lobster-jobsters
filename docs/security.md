# Security model

Agents here read untrusted text all day (customer DMs, comments, inbound email, web pages, supplier PDFs) and hold tools that move money, publish content, deploy code, and sign contracts. The design assumes the model *will* sometimes be steered by that text. The controls make steering expensive and reversible.

## 1. Humans approve every side-effect

Nothing leaves the workspace without a human reacting to an approval card. Injected text can make an agent *draft* a refund or a post; it cannot *send* one. `timeout_action` is `remind` or `hold`, never approve, so inattention fails safe.

Where: `config/approval-policy.json`, "Safety Rules" in every `AGENTS.md`, approval-card templates in `discord-templates/`.

## 2. Sub-agents can't act at all

Sub-agents return artifacts to the coordinator and write only their own `intake → drafted` ledger rows. Because OpenClaw gives sub-agents just `AGENTS.md` + `TOOLS.md`, those two files carry the full rule set — the audit's `subagent_safety` check fails any sub-agent that omits it.

## 3. Kill switches that don't depend on the agent

Both `emergency-stop.json` files are read by agents but written by humans. Flipping one requires no tool call, no bot, no network. The master switch overrides every team. Runbooks give the exact `jq` one-liner.

## 4. Bounded cost

Every sub-agent declares `Max N turns per …` and `Max N retry attempts`. Heartbeats are capped at twelve checks and must reply `HEARTBEAT_OK` when idle. A looping agent runs out of budget and reports rather than burning tokens or hammering an API.

## 5. Idempotency against duplicate harm

Every outbound side-effect carries a key like `acme-{post_id}-{platform}-{date}-{attempt}` and checks the ledger before acting. A retry after a timeout cannot double-publish or double-charge. Keys have a `UNIQUE` constraint where the schema stores them.

## 6. Evidence you can hand to someone

`ledger_state_transitions` is append-only by convention: `agent`, `from_status`, `to_status`, `reason`, `metadata` (JSON), `transitioned_at`. `scripts/ledger.sh transitions <team>` exports it as CSV. If an agent did something wrong, the row tells you which agent, under which reason, after which approval.

## 7. Secrets never enter the workspace

- `env.example` lists variable names only. `.env` is git-ignored and should live outside the workspace directory OpenClaw serves to the agent.
- `TOOLS.md` names services and env vars, never values.
- `scripts/validate.sh` greps for credential shapes (Stripe, GitHub, Slack, AWS, JWTs, Discord webhooks, private keys); CI additionally runs gitleaks over history.
- Discord bot tokens should be scoped to the listed channels only; the agent never needs guild-admin rights.

## 8. Supply chain

Skills are not vendored. Every agent's `openclaw.json` entry names its skills in an explicit `skills` allowlist (`[]` for none); an omitted list would expose every installed skill, so `scripts/validate.sh` rejects missing lists and wildcards. Review a skill's `SKILL.md` before granting it — a skill is a prompt, and a prompt can instruct the agent. The allowlist filters skill visibility, not shell access; `tools.deny` and sandboxing still apply.

## 9. High-risk content gates

Content-producing teams (CMO, Creative, CSM) carry explicit checklists that force human review for competitor mentions, health claims, pricing, inventory counts, legal language, testimonials, and anything political. These are in the team README and the QA prompts.

## 10. Agent config lives outside the agent's reach

Each agent's `openclaw.json` sets its workspace, which sub-agents it may spawn, and the tools it is denied (sub-agents lose `gateway`, `nodes`, `plugins`, `cron`, `sessions_spawn`, `subagents`). That file sits in the agent's own workspace, so treat it as a source, not the live config: copy-merge it into `~/.openclaw/openclaw.json` rather than `$include`-ing it, or an agent with `write` access could widen its own permissions. If you do use `$include`, run agents with a read-only workspace (`sandbox.workspaceAccess`).

## What you still have to do

- Run OpenClaw with sandboxed tool execution and least-privilege API tokens.
- Keep `.env` and `data/` outside any directory an agent can read as context.
- Log at the runtime level too; the ledger records intent and state, not raw tool I/O.
- Rotate Discord and API tokens if a workspace file is ever edited by an agent in a way you didn't expect.
- Do the quarterly kill-switch tabletop in `ops/exec-runbook.md`.

## Scrubbing before you publish your own fork

If you adapt this for a real company and later want to share it, the checklist that produced this repo:

1. Grep for the company name, owner name, domain, city, initials used as ID prefixes, Discord channel names, repo slugs, and emails.
2. Replace with fictional equivalents (this repo uses ACME Bonsai / Jane Founder / Harbor City / `acme-` prefixes).
3. Delete `memory/`, `data/`, vendored `skills/`, and any decisions log entries that describe your real build history.
4. Run `scripts/validate.sh` and a secret scanner over the full git history, not just the working tree.
