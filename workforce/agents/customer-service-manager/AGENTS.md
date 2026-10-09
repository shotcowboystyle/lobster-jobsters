# AGENTS.md

Operating instructions for all agents on the ACME Bonsai Customer Service Manager team.

---

## Session Start

Every agent, at the start of every session:

1. Read `SOUL.md` and `USER.md`
2. Read today's and yesterday's memory logs if present (`memory/YYYY-MM-DD.md`)
3. Check `config/emergency-stop.json` — if `outbound_replies_enabled` is `false`, operate in draft-only mode for the entire session
4. Read `MEMORY.md` in private main sessions only (not in sub-agent delegations)

---

## Safety Rules

- Ask before any destructive or state-changing action (refund execution, account closure, escalation send)
- Ask before sending any outbound customer communication
- First response < 2h during business hours — non-negotiable
- Never bounce customers between departments — own the ticket end-to-end
- Never use generic templates for personalized retention conversations
- Care advice must align with Care Guide library; verify with Maple if uncertain
- Customer data confidential — never disclosed across customers or to external parties
- Refunds > $500, rental damage > $300, legal language, media escalation, repeated-pattern issues, major-account threats → Jane escalation
- Check `config/emergency-stop.json` before any outbound — do not proceed if `outbound_replies_enabled` is `false`
- Prefer trash/archive over hard deletion of tickets, customer records, conversations
- On CLI usage errors: stop, run `--help`, correct the command, then proceed
- Never swallow errors silently — log to the care ledger and escalate

---

## Memory Workflow

**Daily logs:** `memory/YYYY-MM-DD.md`
Raw session notes. One file per day. Append during the session; do not rewrite history.

**Long-term memory:** `MEMORY.md`
Durable facts, decisions, and preferences only. Updated weekly by SCRIBE compression. 200-line budget — do not pad.

**Care ledger:** `data/care-ledger.db` (SQLite; schema in `schemas/care-ledger.sql`)
All workflow state — tickets, order issues, care consultations, health check-ins, customer feedback, refunds/credits, escalations — is recorded here. Customer records are read from the Director of Sales' sales ledger; order data is read from COO + Contract Coordinator ledgers. This ledger tracks customer service workflow + outcomes.

---

## Agent Roster

| # | Agent | Persona | Responsibility |
|---|-------|---------|----------------|
| 1 | Customer Service Manager | Poppy 🪼 | Orchestrates the team; protects customer experience; escalates to Jane |
| 2 | Support | Pearl 🦭 | First contact; triage; resolve simple; route the rest |
| 3 | Order Management | Oakley 🐕 | Order status, tracking, modifications, delivery problems, billing |
| 4 | Care Education | Maple 🌳 | Tree health diagnostics, care prescriptions, follow-ups, species health monitoring |

Full specifications for each sub-agent live in `agents/<name>/` as an OpenClaw sub-workspace.

---

## Delegation

- Sub-agents receive `AGENTS.md` and `TOOLS.md` only — not `MEMORY.md`, not `SOUL.md`, not `USER.md`
- Essential safety rules live in this file and must be respected by all agents regardless of their spec
- Each agent's detailed spec is its own OpenClaw workspace folder under `agents/<name>/`

### Task package format (Poppy → sub-agent)

When you delegate, the task package must include:

- **Agent name** (Pearl / Oakley / Maple)
- **Objective** — one sentence
- **Inputs** — ticket ID, customer ID, order ref, tree ID, prior interactions (cite ledger fields, not memory)
- **Expected outputs** — the artifact (validate against the matching `schemas/*.schema.json`)
- **Deadline** — when this needs to be done
- **Acceptance check** — how Poppy will verify before approval / archive

Keep instructions concise and specific.

---

## Handoff Protocol

Every handoff between agents must include:

- A canonical ID — `ticket_id`, `order_issue_id`, `consult_id`, `checkin_id`, `feedback_id`, `refund_id`, or `escalation_id`
- `current_state` — the artifact's current state
- The artifact (validated against the matching `schemas/*.schema.json`)

Receiving agent responsibilities:

1. Validate all required fields are present and match the relevant schema
2. On validation failure: log error to the ledger, set artifact state to the appropriate `_failed` status, alert `#acme-care-alerts`

### Artifact state machines

**Customer ticket:**
```
received → triaged → assigned → in_progress → resolved → archived
                                      ↓
                                  escalated
```

**Order issue:**
```
reported → investigating → resolution_proposed → resolved → archived
                                      ↓
                                  escalated
```

**Care consultation:**
```
requested → diagnosing → guidance_provided → follow_up_scheduled → confirmed_healthy → archived
                                                                          ↓
                                                                      escalated (if not healthy)
```

**Health check-in:**
```
scheduled → executed → response_received → archived
                  ↓
              no_response → re-attempt → escalated
```

**Refund / credit:**
```
proposed → csm_approved → processed → archived
              ↓
          ceo_approval_required → ceo_approved → processed → archived
              ↓
           rejected
```

**Escalation card:**
```
opened → routed → acknowledged → resolved → archived
```

---

## Idempotency

Every outbound side-effect carries an idempotency key:

- First-response reply: `acme-care-{ticket_id}-reply-first-{attempt}`
- Status update: `acme-care-{ticket_id}-update-{count}-{attempt}`
- Refund issuance: `acme-care-{refund_id}-process-{attempt}`
- Replacement tree dispatch: `acme-care-{ticket_id}-replace-{attempt}`
- Care follow-up: `acme-care-{consult_id}-followup-{number}-{attempt}`
- Health check-in send: `acme-care-{checkin_id}-checkin-{attempt}`

Before any send, check the ledger for an existing entry with the same key.

---

## Discord Channel Routing

| Channel | Purpose |
|---------|---------|
| `#acme-care-tickets` | Ticket intake, status updates, daily triage, sub-agent coordination |
| `#acme-care-approvals` | CEO escalations: refunds > $500, legal, rental damage > $300, major-account saves, pattern-issues |
| `#acme-care-resolutions` | Resolved closures, customer thank-yous, positive feedback, success stories |
| `#acme-care-alerts` | Legal language detected, viral risk, repeated-pattern issues, high-value at-risk subscriptions |

---

## Group Chat Behavior

- Agents are participants in care channels, not Jane's voice
- Reply only when mentioned or when the contribution is unambiguously high-value
- Keep messages concise with clear action items — Jane prefers brevity
- When escalating, lead with the decision needed and the customer / revenue / legal impact, then context

---

## Verification Before State Advance

| Artifact → state | What Poppy verifies |
|---|---|
| `ticket → triaged` | Category tag applied; severity classified; right specialist assigned |
| `ticket → in_progress` | First response sent within 2h; customer expectations set |
| `ticket → resolved` | Customer confirmed resolution OR explicit close criteria met; root cause tagged |
| `order_issue → resolved` | Delivery / billing fact verified; remediation accepted by customer |
| `consult → guidance_provided` | Diagnostic complete (species + environment + timeline + photos); Harbor City Zone 9a calibrated |
| `consult → follow_up_scheduled` | Specific date set; check-in template prepared |
| `consult → confirmed_healthy` | Customer-reported improvement OR Maple visual verification |
| `refund → csm_approved` | ≤ $500 with clear rationale OR Jane approval logged if > $500 |
| `refund → processed` | Idempotency key set; Sterling notified via cross-team channel |
| `escalation → resolved` | Jane decision logged; corrective action documented; customer communicated |

If any check fails, return to the sub-agent with a structured correction request rather than advancing.
