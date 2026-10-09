# Evidence and benchmarking

An agent workforce you can't measure is one you can't trust with more authority. Everything measurable here comes from the ledgers, which agents already write as part of doing their jobs.

## The evidence trail

Every team ledger has a transitions table:

```sql
CREATE TABLE ledger_state_transitions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_type TEXT NOT NULL,        -- post, contract, refund, release, ...
    entity_id TEXT NOT NULL,
    from_status TEXT,
    to_status TEXT NOT NULL,
    agent TEXT NOT NULL,              -- which persona made the change
    reason TEXT,                      -- why (free text, or approval rule name)
    metadata TEXT,                    -- JSON: idempotency key, approver, Discord message id, ...
    transitioned_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

Conventions that make it evidence rather than a log:

- **Append-only.** Agents insert; nobody updates or deletes. Corrections are new transitions with a `reason`.
- **Agent is the persona slug**, never "system". The human approver appears in `metadata` and in the `approvals` table where present.
- **Idempotency key in `metadata`** for every outbound transition, so the key can be traced to the external artifact (post id, payment id, envelope id).
- **Failed variants are states.** `publish_failed`, `execution_failed`, `qa_failed` show up with their `reason`, so retries and escalations are counted, not hidden.

Export for an auditor, incident review, or a customer dispute:

```bash
scripts/ledger.sh transitions cmo 1000 > evidence-cmo-$(date +%F).csv
sqlite3 workforce/agents/cmo/data/post-ledger.db ".backup evidence-cmo-$(date +%F).db"
```

## Operational metrics

`scripts/ledger.sh metrics <team>` computes, from the transitions table alone:

| metric | question it answers |
|---|---|
| transitions by entity type and target state | what volume is each pipeline carrying, and where does it end up? |
| transitions by agent | is one persona doing all the work, or none? |
| mean hours in each state | where do items sit? (`awaiting_approval` tells you about humans, `drafted` about agents) |
| approval latency (awaiting/review → approved) | how fast do humans unblock the pipeline; what's the worst case? |

Run it weekly (the runbooks schedule it) and paste the summary into the weekly report. Trend it in `MEMORY.md`, not in a dashboard you'll stop looking at.

## Benchmarking an agent before you trust it

There is no LLM eval harness in this repo on purpose — the right harness depends on your runtime. What the workspaces give you is the **spec to test against**:

1. **Handoff schemas** (`schemas/*.schema.json`). Feed an agent a realistic input and validate its output against the schema with any JSON Schema validator. Pass rate per agent is your first number.
2. **Cost controls** (`AGENTS.md → Cost Controls`). Count turns and tool calls per task in your runtime logs; anything over budget is a failure even if the output was fine.
3. **Guard-rail checklists** (team README → High-Risk Content Detection, Guard Rails). Build a small set of adversarial inputs per checklist item (competitor mention, invented price, injected instruction) and confirm the agent flags rather than acts.
4. **Kill-switch compliance.** Flip `emergency-stop.json`, run every routine once, confirm zero outbound attempts in the ledger.
5. **Approval latency under load.** Measured by `ledger.sh metrics` once you're running for real — if humans are the bottleneck, that's a staffing number, not an agent one.

Record results in the team's `MEMORY.md` under a `## Benchmarks` heading with the date and model, so a model upgrade can be compared to the last run.

## Governance audit as a regression test

`scripts/audit.py --strict` is the structural benchmark: twelve controls per team, persona-collision check, exit 1 on any failure. It runs in CI so a PR that removes a kill-switch check or a cost budget fails before merge. `--json` emits machine-readable output for tracking over time.

## Agent-health monitoring at runtime

The Chief of Staff workspace includes **Magpie 🪞**, a read-only agent-health monitor that sweeps every workspace's bootstrap files and ledger, writes `agent_health_snapshots` to the executive ledger, and posts to Discord only when something changed since the last sweep. That is the runtime counterpart of this document: the repo audits the spec; Magpie audits the behavior.
