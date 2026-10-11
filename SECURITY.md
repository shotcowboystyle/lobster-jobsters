# Security

## Reporting

If you find a problem that could cause an agent built from these workspaces to leak data, act without approval, or be steered by untrusted content, please open a [private security advisory](https://github.com/shotcowboystyle/lobster-jobsters/security/advisories/new) rather than a public issue. Expect an acknowledgement within a week.

In scope: prompt-injection paths in `AGENTS.md`/`SOUL.md`/prompts, approval-policy gaps, kill-switch bypasses, ledger integrity, secrets in tracked files, and tooling bugs in `scripts/`.

## Threat model (short version)

These workspaces assume the agent reads untrusted content (customer DMs, comments, inbound email, web pages) and has tools that can cause real-world side-effects. The controls, and where they live:

| Threat | Control | Where |
|---|---|---|
| Prompt injection via inbound content | Humans approve every outbound side-effect; agents draft only | `config/approval-policy.json`, `AGENTS.md` safety rules |
| Agent runs away (loops, floods, spends) | Per-sub-agent cost controls; retry caps; heartbeat budgets | each sub-agent `AGENTS.md`, `HEARTBEAT.md` |
| Need to stop everything now | Two-tier kill switch, file-based so it works even if the agent's tools don't | `config/emergency-stop.json`, `workforce/config/shared-emergency-stop.json` |
| Duplicate side-effects on retry | Idempotency keys checked against the ledger | `AGENTS.md` handoff protocol, ledger schema |
| "Who did what, when, why?" | Append-only state-transition log per team | `schemas/*-ledger.sql` → `ledger_state_transitions` |
| Credential leakage | Secrets never in the workspace; `env.example` names only; gitleaks in CI | `.gitignore`, `scripts/validate.sh`, `.github/workflows/ci.yml` |
| Sub-agent skips the rules | Sub-agents only load `AGENTS.md` + `TOOLS.md`, so rules are restated there | audit check `subagent_safety` |
| Supply-chain risk from skills | Explicit per-agent skill allowlist by name, no wildcards; skills not vendored | `openclaw.json` `skills`, `scripts/validate.sh` |

Full write-up: [docs/security.md](docs/security.md).

## What this repo does not do

It ships no runtime, so it cannot enforce anything by itself. The controls are only as strong as the OpenClaw configuration they run under: sandbox tools, scope Discord bot permissions to the listed channels, and keep `.env` out of the workspace directory.
