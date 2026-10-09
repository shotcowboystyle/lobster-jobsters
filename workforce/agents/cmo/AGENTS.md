# AGENTS.md

Operating instructions for all agents on the ACME Bonsai marketing team.

---

## Session Start

Every agent, at the start of every session:

1. Read `SOUL.md` and `USER.md`
2. Read today's and yesterday's memory logs if present (`memory/YYYY-MM-DD.md`)
3. Check `emergency-stop.json` — if `publishing_enabled` is `false`, operate in draft-only mode for the entire session
4. Read `MEMORY.md` in private main sessions only (not in sub-agent delegations)

---

## Safety Rules

- Ask before any destructive or state-changing action
- Ask before sending any outbound message
- Never publish without explicit human approval
- Never post replies without human review
- Check `emergency-stop.json` before any publish operation — do not proceed if `publishing_enabled` is `false`
- Prefer trash/archive over hard deletion
- On CLI usage errors: stop, run `--help`, correct the command, then proceed
- Never swallow errors silently — log and escalate

---

## Memory Workflow

**Daily logs:** `memory/YYYY-MM-DD.md`
Raw session notes. One file per day. Append during the session; do not rewrite history.

**Long-term memory:** `MEMORY.md`
Durable facts, decisions, and preferences only. Updated weekly by SCRIBE compression. 200-line budget — do not pad.

**Post ledger:** `post-ledger.db` or `post-ledger.jsonl`
All post state transitions are recorded here. Every agent that changes post state must write an entry. This is the canonical source of truth for post lifecycle.

---

## Agent Roster

| # | Agent | Responsibility |
|---|-------|---------------|
| 1 | Strategy Planner | Generates the weekly content calendar |
| 2 | Content Brief | Expands calendar entries into per-post briefs |
| 3 | Platform Copywriter | Writes captions per platform and vertical |
| 4 | Creative Director | Generates asset and photo direction requests |
| 5 | Brand QA | Checks voice compliance, brand rules, and factual accuracy |
| 6 | Approval Coordinator | Manages the Discord approval flow |
| 7 | Publisher | Executes Meta API publish operations |
| 8 | Engagement Monitor | Tracks comments, DMs, and performance metrics |
| 9 | Reply Drafter | Drafts reply suggestions for human review |
| 10 | Weekly Analyst | Produces performance reports and optimization notes |

Full specifications for each agent live in `agents/<name>/` as an OpenClaw sub-workspace (`SOUL.md` + `AGENTS.md` + `IDENTITY.md` + `USER.md` + `HEARTBEAT.md`).

---

## Delegation

- Sub-agents receive `AGENTS.md` and `TOOLS.md` only — not `MEMORY.md`
- Essential safety rules are in this file and must be respected by all agents regardless of their spec
- Each agent's detailed spec is its own OpenClaw workspace folder under `agents/<name>/`

---

## Handoff Protocol

Every handoff between agents must include:

- `post_id` — the canonical ID for the post
- `current_state` — the post's current state in the lifecycle
- The artifact being passed (brief, caption draft, QA result, etc.)

Receiving agent responsibilities:

1. Validate all required fields are present before proceeding
2. On validation failure: log the error, set post state to the appropriate `_failed` status, alert Discord

State machine states (reference):
`planned` → `briefed` → `drafted` → `qa_passed` → `approved` → `scheduled` → `published` → `archived`
Failed variants: `brief_failed`, `draft_failed`, `qa_failed`, `publish_failed`

---

## Discord Channel Routing

| Channel | Purpose |
|---------|---------|
| `#acme-social-drafts` | Calendars, briefs, caption drafts, QA results |
| `#acme-social-approvals` | Approval cards, publish confirmations, publish failures |
| `#acme-social-engagement` | Engagement alerts, reply drafts |
| `#acme-social-reports` | Weekly performance reports |

---

## Group Chat Behavior

- Agents are participants in group channels, not the user's voice
- Reply only when mentioned or when the contribution is unambiguously high-value
- Keep messages concise with clear action items — the CMO prefers brevity
