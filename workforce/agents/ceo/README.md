# ACME Bonsai — CEO Team (Apex)

## Architecture Summary

Multi-agent OpenClaw system that is the CEO's AI shadow. Apex thinks _with_ Jane, never _for_ her. The workspace produces four artifact types: weekly strategic questions (Compass), decision journal entries with outcome tracking (Almanac), long-form strategic memos on request (Atlas), and external-stakeholder communications with per-message approval (Envoy). All Discord channels in this workspace are Jane-only — no other humans participate.

Key principles:

- Apex frames decisions; Jane decides
- The decision is the asset; the reasoning is what compounds
- Atlas writes only on Jane's explicit ask — no scheduled memo drafting
- Envoy never sends without Jane's per-message approval
- No duplication of River's tactical work (briefings, action items, agent health, initiatives)
- Reversible decisions are spent cheaply; irreversible decisions get the full ceremony

---

## Agent Table

| #   | Agent                | Persona    | Mission                                                 | Trigger                              | Outputs To                  |
| --- | -------------------- | ---------- | ------------------------------------------------------- | ------------------------------------ | --------------------------- |
| 1   | CEO Shadow           | Apex 🪨    | Thinks with Jane; orchestrates the team                 | Jane-driven + routines               | Jane                        |
| 2   | Strategy Synthesizer | Compass 🧭 | One strategic question per week from cross-team signals | Routine: Sun 9 PM ET                 | Apex → Jane                 |
| 3   | Decision Journal     | Almanac 📓 | Captures decisions, reopens at outcome window           | Routine: daily 6 PM + Jane-on-demand | Apex → Jane                 |
| 4   | Memo Drafter         | Atlas 🗺️   | Drafts long-form strategic memos                        | On-demand only                       | Apex → Jane                 |
| 5   | External Comms       | Envoy 📨   | Drafts every outbound to external stakeholders          | On-demand only                       | Jane (per-message approval) |

---

## Artifact State Machines

**Strategic question:** `queued → researching → drafted → ceo_review → answered → archived` (with `deferred` as side state)

**Decision entry:** `captured → outcome_window_open → outcome_captured → archived` (with `outcome_inconclusive` as variant)

**Strategic memo:** `requested → drafting → ceo_review ↔ revising → approved → delivered → archived` (with `rejected`)

**External comm:** `queued → drafting → ceo_review ↔ revising → approved → sent → acknowledged → archived` (with `rejected`)

---

## Workflow Table

| Workflow                           | Trigger                              | Key Agents          | Human Checkpoint                                   |
| ---------------------------------- | ------------------------------------ | ------------------- | -------------------------------------------------- |
| A. Weekly Strategic Question       | Routine: Sun 9 PM ET                 | Compass → Apex      | Jane answers in #ceo-strategy (no SLA — strategic) |
| B. Decision Capture                | Daily 6 PM ET sweep + Jane-on-demand | Almanac             | Jane acks each decision entry                      |
| C. Outcome Window Check            | Daily 6 PM ET sweep                  | Almanac             | Jane records outcome + reflection                  |
| D. Strategic Memo Drafting         | Jane: "Atlas, draft me…"             | Atlas → Apex → Jane | Jane approves before any external delivery         |
| E. External Comm Drafting          | Jane: "Envoy, draft a note to…"      | Envoy → Apex → Jane | Jane approves per message before send              |
| F. Cross-Team Escalation Reception | Inbound from River                   | Apex                | Jane decides; Almanac captures the decision        |
| G. Emergency Stop                  | Any time                             | Apex                | Jane or Apex sets `external_comms_enabled: false`  |

---

## Guard Rails Table

| Category            | Rule                                                                                                                             |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Decisions           | Apex never makes a decision on Jane's behalf                                                                                     |
| Strategic questions | Cite ≥3 ledger references across ≥2 source teams                                                                                 |
| Strategic questions | Frame as a trade-off, not a tactic                                                                                               |
| Memos               | Cap 1,500 words unless Jane extends                                                                                              |
| Memos               | Drafted only on explicit ask — never scheduled                                                                                   |
| External comms      | Per-message approval required; idempotency keys on every send                                                                    |
| External comms      | No outbound when `external_comms_enabled` is `false`                                                                             |
| Personnel           | Sensitive personnel matters 1:1 with Jane only                                                                                   |
| Channels            | CEO Discord channels are Jane-only; no River, no operating coordinators                                                          |
| Operational         | All state transitions logged to the CEO ledger                                                                                   |
| Tactical            | Apex does not produce weekly briefings, action-item rollups, agent-health snapshots, or initiative dashboards (River owns those) |

---

## RACI Table

| Activity                  | Apex | Compass | Almanac | Atlas | Envoy |     Jane (CEO)      |       River       |
| ------------------------- | :--: | :-----: | :-----: | :---: | :---: | :-----------------: | :---------------: |
| Weekly strategic question |  A   |    R    |    —    |   —   |   —   |     A (answers)     |         I         |
| Decision capture          |  A   |    —    |    R    |   —   |   —   |      I (acks)       | I (if cross-team) |
| Outcome window check      |  A   |    —    |    R    |   —   |   —   |     A (records)     |         —         |
| Strategic memo draft      |  A   |    —    |    C    |   R   |   —   | A/R (decides scope) |         —         |
| Memo publish              |  A   |    —    |    —    |   R   |   —   |         A/R         |         —         |
| External comm draft       |  A   |    —    |    —    |   —   |   R   |   A (per-message)   |         —         |
| External comm send        |  I   |    —    |    —    |   —   |   R   |         A/R         |         —         |
| Cross-team escalation     |  A   |    —    |    C    |   —   |   —   |         A/R         |   R (escalates)   |
| Emergency stop            |  R   |    I    |    I    |   I   |   I   |         A/R         |         I         |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel               | Purpose                                                         | Who Acts                          |
| --------------------- | --------------------------------------------------------------- | --------------------------------- |
| `#acme-ceo-strategy`  | Compass weekly questions; Apex's strategic notes                | Apex + Compass post; Jane answers |
| `#acme-ceo-decisions` | Almanac decision-entry confirmations and outcome captures       | Almanac posts; Jane acks          |
| `#acme-ceo-memos`     | Atlas memo drafts + Envoy external-comm drafts                  | Atlas + Envoy post; Jane approves |
| `#acme-ceo-alerts`    | Ledger anomalies, outbound send failures, emergency-stop events | All sub-agents post; Jane triages |

All four channels are Jane-only. River escalates to Jane via `#acme-exec-alerts` (in the Chief of Staff workspace), not directly into CEO channels.

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "external_comms_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `external_comms_enabled` is `false`:

1. Envoy refuses all outbound sends; drafts continue
2. Atlas drafts continue but cannot transition to `approved` → `delivered`
3. Compass and Almanac continue normally (internal work only)
4. Discord alert posted to `#acme-ceo-alerts`: "🛑 CEO EXTERNAL COMMS PAUSED: {reason}"

To resume: set `external_comms_enabled: true`, post confirmation to Discord.

---

## Idempotency Strategy

Every Envoy outbound carries an idempotency key:

- Format: `acme-ceo-{comm_id}-{channel}-{attempt}` (e.g., `acme-ceo-c-2026-06-27-investor-update-email-1`)
- Before send: check the `external_comms` table for an existing entry with the same key
- If `sent`: skip; if `failed`: increment attempt, retry (max 3)

---

## Recommended File Tree

```
workforce/agents/ceo/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── BOOTSTRAP.md                 # legacy — left in place; harmless
├── agents/
│   ├── strategy-synthesizer/    # Compass
│   ├── decision-journal/        # Almanac
│   ├── memo-drafter/            # Atlas
│   └── external-comms/          # Envoy
├── schemas/
│   ├── strategic-question.schema.json
│   ├── decision-entry.schema.json
│   ├── strategic-memo.schema.json
│   ├── external-comm.schema.json
│   ├── outcome-capture.schema.json
│   ├── stakeholder-record.schema.json
│   └── ceo-ledger.sql
├── prompts/
│   ├── weekly-strategic-question.md
│   ├── decision-capture.md
│   ├── memo-drafting.md
│   └── external-comm-drafting.md
├── config/
│   ├── emergency-stop.json
│   ├── approval-policy.json
│   ├── discord-config.example.json
│   ├── env.example
│   └── routines.example.sh
├── ops/
│   └── runbook.md
└── discord-templates/
    └── message-templates.md
```

---

## Deployment Assumptions

- Claude Desktop with Claude Code Routines enabled
- Discord bot with permissions to post in the 4 Jane-only channels
- Email provider for Envoy (per-message confirmation via webhook)
- Read access to every operating team's ledger for Compass synthesis
- SQLite database for the CEO ledger (local; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Jane is the sole approver — no delegated authority in this workspace
