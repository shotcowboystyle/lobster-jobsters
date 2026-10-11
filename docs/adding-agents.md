# Adding agents

## A new sub-agent on an existing team

```bash
scripts/new-agent.sh sub cfo tax --persona Keel --role "Tax & Filings Agent" --emoji ⚖️ --creature "sea turtle"
```

This creates `workforce/agents/cfo/agents/tax/` with the six sub-agent files plus `openclaw.json` (agent id `cfo-tax`), pre-wired to the CFO coordinator (Sterling), the CFO kill-switch flag, and the CFO Discord channels, and adds `cfo-tax` to `subagents.allowAgents` in `workforce/agents/cfo/openclaw.json`. Then:

1. **Make the role real.** Replace the generic Triggers, Handoff Contract, and State Transitions in `AGENTS.md` with the actual inputs, outputs, and schema names. Add a prompt in the team's `prompts/` if the task is non-trivial.
2. **Add a schema** for any new artifact in the team's `schemas/` and a table or columns in the ledger SQL if the artifact has a lifecycle.
3. **Set the budget.** Edit `Cost Controls` to numbers that fit the task; the defaults (5 turns, 2 retries) are a floor, not a recommendation.
4. **Register it.** Add a row to the roster in the team `AGENTS.md` and the agent table in the team `README.md`.
5. **Wire approvals.** If the agent's output leads to a side-effect, name the `approval-policy.json` rule in its Handoff Contract.
6. **Tune its OpenClaw entry.** `openclaw.json` denies infra and spawning tools by default; set its `skills` allowlist (`[]` unless the role needs a named skill), add `model` or tighter `tools.deny` (e.g. `message` for agents that never post) if the role needs them. Re-merge it into your global config.
7. Run `scripts/validate.sh && scripts/audit.py --strict`.

## A new team

```bash
scripts/new-agent.sh team cro --name "Chief Revenue Officer" --persona Harbor --emoji ⚓ --creature pelican --flag outreach_enabled
```

You get a complete team workspace that already passes validation and scores 12/12. The work is in making it specific:

| file | what to change |
|---|---|
| `SOUL.md` | domain values; what this team defends and refuses |
| `USER.md` | the real authority matrix — list the decisions the owner keeps |
| `config/approval-policy.json` | one rule per side-effect type, real thresholds, rationale in `notes` |
| `schemas/<slug>-ledger.sql` | replace `work_items` with the domain's actual entities; keep `ledger_state_transitions` as-is |
| `README.md` | state machine, agent table, RACI, guard rails for this domain |
| `config/routines.example.sh` | the real cadence |
| `ops/runbook.md` | domain-specific incident severities |
| `openclaw.json` | agent id `<team>`; list the coordinator's `skills` by name; add `model` if it needs a non-default one |

Then connect it to the company:

- `workforce/README.md` — org chart and persona table
- `workforce/SHARED_KNOWLEDGE.json` — `workforce.operating_layer`, `ledgers`, and any new canonical thresholds
- `workforce/CROSS-TEAM-HANDOFFS.md` — every flow that enters or leaves this team
- `workforce/ops/exec-runbook.md` — if the team has its own SEV definitions

Add sub-agents with `scripts/new-agent.sh sub cro ...`.

## Picking a persona

- One name, one creature, one emoji, unique across the whole workforce. `scripts/audit.py` reports collisions.
- Names are short, pronounceable in a Discord mention, and not shared with a human on the team.
- The creature is a mnemonic for the role's temperament (Garrison the tortoise for compliance; Pixel the peregrine for frontend). Write one sentence about why in `IDENTITY.md`.
- Coordinators get a stronger presence than sub-agents; sub-agents should feel like specialists, not mascots.

## Writing a good `AGENTS.md`

It is the only file a sub-agent is guaranteed to see, so it must stand alone:

1. Role, one paragraph, who it reports to.
2. Session start: which files to read, which kill switches to check.
3. Safety rules, restated even if they duplicate the coordinator's.
4. Triggers table.
5. Handoff contract: inputs, outputs, schema names.
6. State transitions it writes, and which it does not.
7. Where its output surfaces (via the coordinator).
8. Tools it may use.
9. Cost controls.

If a rule matters, it goes here, not in `SOUL.md`.

## Granting a skill

Every agent's `openclaw.json` entry carries an explicit `skills` allowlist. Omitting it means *every* installed skill is visible, so `scripts/validate.sh` rejects a missing list, wildcards, and globs:

```json
"cto-devops-agent": { "skills": ["github"], ... }
```

Use `[]` for none. A non-empty list is the agent's final set; it does not merge with `agents.defaults.skills`. Do not copy skill files into the repo. Read a skill's `SKILL.md` before granting it — it is a prompt, and prompts instruct agents. The allowlist controls visibility only; it is not a shell boundary, so keep `tools.deny` tight too.

## Removing an agent

Delete the directory, remove its id from the coordinator's `subagents.allowAgents` in `openclaw.json` and its entry from your global OpenClaw config, remove it from the roster tables and `SHARED_KNOWLEDGE.json`, and add an entry to `team-memory/exec-decisions-log.md` saying why. Keep its ledger rows; they are evidence.
