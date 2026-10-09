# Governance

Who may do what, how approval works, and how the repo enforces it.

## Approval policy

Each team's `config/approval-policy.json` is the contract between agents and humans. Every rule has:

| field | meaning |
|---|---|
| `requires_approval` | `true` for anything with a side-effect |
| `approvers` | roles that may decide (`ceo`, `cfo`, team slug, …) |
| `min_approvers` | usually 1; 2 for security risk acceptance and the like |
| `timeout_hours` / `timeout_action` | what happens when nobody answers: `remind` or `hold`. **Never auto-approve.** |
| `allowed_actions` | `approve`, `edit`, `hold`, `defer`, `reject` |
| `threshold_*` | numeric gates (`threshold_usd`, `threshold_hours`, `threshold_usd_monthly`) |
| `notes` | the human-readable rationale |

Rules with `requires_approval: false` (only `emergency_stop`) must list `authorized_actors`.

Canonical thresholds across the company are indexed in `workforce/SHARED_KNOWLEDGE.json → approval_thresholds_canonical`, so two teams cannot drift on, say, what counts as a large refund.

## Authority matrix

Every team `USER.md` states exactly what the human owner approves for that team and what the coordinator approves alone. Example (CTO):

- Owner: features > 40h or > $3K, architecture changes, SaaS > $200/mo, production rollbacks, data destruction, legal/compliance posture
- Coordinator: everything else, with a spec

## RACI

Team READMEs carry a RACI table per activity (Responsible / Accountable / Consulted / Informed) across coordinator, sub-agents, human operator, and human approver. Emergency stop is always R for both humans and the coordinator.

## Kill switches

Two tiers, both plain JSON files so a human can flip them with a text editor even if every agent tool is broken:

```json
// workforce/agents/<team>/config/emergency-stop.json
{ "publishing_enabled": true, "reason": null, "stopped_by": null, "stopped_at": null,
  "resume_notes": null, "resumed_by": null, "resumed_at": null }

// workforce/config/shared-emergency-stop.json
{ "all_outbound_enabled": true, ... }
```

Rules:

- Exactly one boolean `*_enabled` flag per file (the validator enforces this).
- Agents check the team file **and** the shared file before any side-effect, every session start, and on every heartbeat.
- `false` stops outbound only. Drafting, QA, planning continue so the pipeline stays warm.
- Activation is immediate by coordinator or owner. Resumption is owner-only and must fill `resume_notes`.
- Quarterly tabletop: flip the master switch, confirm every team halts, flip it back.

## Decision log

Cross-team decisions are recorded twice: as a row in the CEO ledger's `decision_entries` (owned by Almanac, the decision-journal agent) and as a summary in `workforce/team-memory/exec-decisions-log.md`. Each entry carries an outcome window; when it arrives, Almanac reopens the decision and the owner records what actually happened.

## Enforcement in the repo

| mechanism | runs | catches |
|---|---|---|
| `scripts/validate.sh` | CI, pre-commit | missing files, bad JSON/SQL/shell, oversize memory/heartbeat, malformed kill switch, leftover `{{PLACEHOLDER}}`, secrets, committed `.env`/`*.db`/daily logs |
| `scripts/audit.py --strict` | CI | the twelve governance controls per team + persona collisions |
| `scripts/ledger.sh demo` | CI | the metrics queries still work against the transition schema |
| gitleaks action | CI | credentials in any commit |
| PR template | every PR | thresholds and handoffs are stated, not implied |

## Adding a rule

1. Add it to the team's `approval-policy.json` with `notes` explaining the threshold.
2. Reference the rule name in the relevant prompt and in the approval-card template.
3. If it's company-wide, add it to `SHARED_KNOWLEDGE.json → approval_thresholds_canonical`.
4. Run the audit.
