# Contributing

Thanks for helping make agent workspaces that are safe to run unattended.

## What to contribute

- **New teams or sub-agents** for roles ACME Bonsai doesn't cover (legal, HR, procurement, support engineering, …). Scaffold with `scripts/new-agent.sh`, then make the prompts real.
- **Better prompts, schemas, runbooks** for existing agents.
- **New audit checks** in `scripts/audit.py` that prove a safety property.
- **Fixes** to tooling or docs.

## Ground rules

1. **Fictional company only.** Everything is ACME Bonsai, Jane Founder, Harbor City. No real customers, vendors, prices, phone numbers, addresses, Discord IDs, or repo names.
2. **No secrets, ever.** `env.example` names variables; never values. CI runs gitleaks.
3. **No vendored skills, no wildcard grants.** Name each skill an agent may use in its `openclaw.json` `skills` allowlist.
4. **No daily memory logs or ledgers.** `memory/*.md`, `data/`, and `*.db` are git-ignored on purpose.
5. **Every team scores 12/12.** Run `scripts/validate.sh && scripts/audit.py --strict` before opening a PR.
6. **Sub-agents restate safety rules and have cost controls.** They only receive `AGENTS.md` + `TOOLS.md` at runtime.
7. **Persona uniqueness.** No two agents in the workforce share a name or an emoji. The audit enforces it.

## Workflow

```bash
git checkout -b feat/<team-or-change>
scripts/new-agent.sh team <slug> --name "..." --persona ... --emoji ... --creature ...
# edit prompts, schemas, runbook
scripts/validate.sh && scripts/audit.py --strict
scripts/ledger.sh init <slug>   # confirm the ledger schema loads
```

Open a PR using the template. Describe the role, the approval thresholds you chose and why, and which cross-team handoffs the new agent participates in (update `workforce/CROSS-TEAM-HANDOFFS.md`).

## Style

- Markdown files follow the existing OpenClaw bootstrap conventions (`# FILE.md — Persona (Role)` headings, bullet-first sections).
- Keep `HEARTBEAT.md` tiny and `MEMORY.md` under 200 lines.
- Prefer tables for rosters, triggers, channels, and RACI.
- Scripts: bash with `set -euo pipefail`, Python 3 stdlib only, `jq` and `sqlite3` as the only external tools.
