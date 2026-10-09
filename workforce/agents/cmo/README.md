# ACME Bonsai — Claude Desktop Social Marketing Team

## Architecture Summary

Multi-agent Claude Desktop system with 10 specialized agents orchestrated via Claude Code Routines. Discord is the human coordination layer. All publishing requires explicit human approval. The system follows a "draft → QA → approve → publish → monitor" pipeline.

Key principles:
- No autonomous publishing — every post requires human approval
- Safe failure mode — when uncertain, draft/flag/pause/escalate
- Vertical-aware messaging — wholesale, local, display, events each have distinct voice
- Auditable — every state transition logged to post ledger
- Idempotent publishing — deduplicated via idempotency keys

---

## Agent Table

| # | Agent | Mission | Trigger | Outputs To |
|---|-------|---------|---------|------------|
| 1 | Strategy Planner | Weekly content calendar across verticals | Routine: Monday 7am | Content Brief Agent |
| 2 | Content Brief | Expands calendar items into per-post briefs | After strategy approval | Platform Copywriter |
| 3 | Platform Copywriter | Writes platform-specific captions per vertical | Per brief | Brand QA |
| 4 | Creative Director | Generates asset/photo requests | Per brief | Human (photographer/designer) |
| 5 | Brand QA | Checks voice, compliance, factual accuracy | Per draft | Approval Coordinator or back to Copywriter |
| 6 | Approval Coordinator | Posts approval packets to Discord, tracks decisions | After QA pass | Publisher |
| 7 | Publisher | Executes Meta API publish after approval | After human approval | Engagement Monitor |
| 8 | Engagement Monitor | Tracks comments, DMs, engagement metrics | Routine: every 2 hours | Reply Drafter |
| 9 | Reply Drafter | Drafts reply suggestions for human review | Per engagement alert | Human via Discord |
| 10 | Weekly Analyst | Generates performance reports and optimization recs | Routine: Sunday 6pm | Human via Discord |

---

## Post State Machine

```
planned → drafted → qa_reviewing → qa_passed / qa_failed
                                      ↓            ↓
                              awaiting_approval   (back to copywriter)
                                      ↓
                              approved / rejected / held
                                 ↓         ↓         ↓
                            scheduled    archived   (parked)
                                 ↓
                            publishing
                                 ↓
                         published / publish_failed
                              ↓            ↓
                          monitoring    (retry → publishing or escalate)
                              ↓
                           archived
```

Statuses: `planned`, `drafted`, `qa_reviewing`, `qa_passed`, `qa_failed`, `awaiting_approval`, `approved`, `rejected`, `held`, `scheduled`, `publishing`, `published`, `publish_failed`, `monitoring`, `archived`

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Weekly Planning | Routine: Monday 7am | Strategy Planner | Calendar review in #social-drafts |
| B. Daily Drafting | Routine: daily 8am | Content Brief → Copywriter | — (feeds into QA) |
| C. Asset Requests | Per brief with visual needs | Creative Director | Photographer/designer fulfills |
| D. Brand QA | Per draft completion | Brand QA | QA failures flagged in #social-drafts |
| E. Approval | After QA pass | Approval Coordinator | Human approves in #social-approvals |
| F. Publishing | After approval | Publisher | Publish success/fail in #social-approvals |
| G. Engagement Monitoring | Routine: every 2h | Engagement Monitor | Alerts in #social-engagement |
| H. Reply Drafting | Per engagement alert | Reply Drafter | Human reviews in #social-engagement |
| I. Weekly Reporting | Routine: Sunday 6pm | Weekly Analyst | Report in #social-reports |
| J. Incident/Failure | On publish_failed or crisis | All agents pause | Operator alert in #social-approvals |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Content | Never invent prices, inventory, availability, testimonials, or business results |
| Content | Use [PLACEHOLDER] for missing facts; flag for human review |
| Content | No fake urgency, clickbait, excessive punctuation, or spammy CTAs |
| Content | Vertical voice must match audience (wholesale ≠ local ≠ display ≠ events) |
| Operational | No publishing without explicit human approval |
| Operational | No reply posting without human review |
| Operational | No deletion or editing of published posts without approval |
| Operational | No outreach beyond Instagram and Facebook Pages |
| Approval | Timeout after 24h → escalate, never auto-approve |
| Approval | Rejected posts archived, not silently retried |
| Data | No credential access from prompts; tokens managed externally |
| Data | All state transitions logged to post ledger |
| Platform | Instagram uses container+publish flow (not scheduled_publish_time) |
| Platform | Facebook uses unpublished + scheduled_publish_time flow |
| Crisis | No auto-posting during detected crisis; pause and escalate |
| Crisis | High-risk content (competitors, politics, health claims) → mandatory human review flag |

---

## RACI Table

| Activity | Strategy Planner | Copywriter | Brand QA | Approval Coord | Publisher | Engagement Mon | Reply Drafter | Weekly Analyst | Human Operator | Human Approver |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Content calendar creation | R | — | — | — | — | — | — | C | A | — |
| Post brief creation | — | R | — | — | — | — | — | — | I | — |
| Caption drafting | — | R | — | — | — | — | — | — | I | — |
| Brand/compliance QA | — | — | R | — | — | — | — | — | I | — |
| Approval decision | — | — | — | I | — | — | — | — | — | A/R |
| Publishing execution | — | — | — | — | R | — | — | — | I | — |
| Engagement monitoring | — | — | — | — | — | R | — | — | I | — |
| Reply drafting | — | — | — | — | — | — | R | — | I | — |
| Reply approval | — | — | — | — | — | — | — | — | — | A/R |
| Weekly reporting | — | — | — | — | — | — | — | R | A | — |
| Emergency stop | — | — | — | — | — | — | — | — | R | R |
| Incident response | — | — | — | — | — | — | — | — | R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| #social-drafts | Weekly calendars, post briefs, draft captions, QA results | Agents post; operators review |
| #social-approvals | Approval cards, approve/reject/hold/edit actions, publish confirmations | Agents post; approvers act |
| #social-engagement | Engagement alerts, reply drafts, DM notifications | Agents post; operators review and approve replies |
| #social-reports | Weekly performance reports, optimization recommendations | Weekly Analyst posts; operators review |

---

## Emergency Stop Design

The system uses a file-based kill switch:

**File:** `config/emergency-stop.json`
```json
{
  "publishing_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null
}
```

When `publishing_enabled` is set to `false`:
1. Publisher agent refuses all publish jobs
2. Approval Coordinator stops sending to Publisher
3. All agents continue drafting/planning (pipeline stays warm)
4. Discord alert posted to #social-approvals: "⚠️ PUBLISHING PAUSED: {reason}"
5. To resume: set `publishing_enabled: true`, post confirmation to Discord

**Activation:** Human operator edits the file or runs:
```sh
claude exec publisher -- echo '{"publishing_enabled":false,"reason":"...","stopped_by":"operator","stopped_at":"2026-04-19T12:00:00Z"}' > config/emergency-stop.json
```

---

## Idempotency Strategy

Every publish job gets an idempotency key: `acme-{post_id}-{platform}-{scheduled_date}-{attempt}`

Example: `acme-post-2026-04-21-ig-wholesale-001-instagram-2026-04-21-1`

Before publishing, the Publisher checks the post ledger for an existing entry with the same idempotency key. If found and status is `published`, skip. If found and status is `publish_failed`, increment attempt counter and retry (max 3 attempts).

---

## High-Risk Content Detection Checklist

The Brand QA agent flags content for mandatory human escalation if ANY of these are detected:

- [ ] Mentions competitor by name
- [ ] Contains health or wellness claims about plants
- [ ] References pricing, discounts, or sale events
- [ ] Contains inventory quantities or "limited" / "last" / "only X left"
- [ ] References shipping timelines or delivery promises
- [ ] Mentions partnerships or collaborations not confirmed by operator
- [ ] Contains any political, religious, or controversial cultural reference
- [ ] Uses customer names or testimonials
- [ ] References other businesses by name (non-tagged)
- [ ] Contains claims about sustainability, sourcing, or certifications
- [ ] Post is a response to negative feedback or complaint
- [ ] Contains any legal language (terms, guarantees, warranties)

---

## Recommended File Tree

```
workforce/
├── README.md                          # This file
├── IDENTITY.md                        # Agent team identity
├── SOUL.md                            # Brand persona + boundaries
├── AGENTS.md                          # Operating instructions
├── USER.md                            # Operator profile
├── HEARTBEAT.md                       # Periodic check tasks
├── MEMORY.md                          # Curated long-term memory
├── agents/                              # Each agent is its own OpenClaw sub-workspace
│   ├── strategy-planner/
│   │   ├── IDENTITY.md
│   │   ├── SOUL.md
│   │   ├── AGENTS.md
│   │   ├── USER.md
│   │   └── HEARTBEAT.md
│   ├── content-brief/                   # same 5-file layout per agent
│   ├── platform-copywriter/
│   ├── creative-director/
│   ├── brand-qa/
│   ├── approval-coordinator/
│   ├── publisher/
│   ├── engagement-monitor/
│   ├── reply-drafter/
│   └── weekly-analyst/
├── schemas/
│   ├── campaign-brief.schema.json
│   ├── post-brief.schema.json
│   ├── draft-caption.schema.json
│   ├── creative-request.schema.json
│   ├── qa-result.schema.json
│   ├── approval-packet.schema.json
│   ├── publish-job.schema.json
│   ├── engagement-alert.schema.json
│   ├── reply-draft.schema.json
│   ├── weekly-report.schema.json
│   ├── incident-packet.schema.json
│   ├── content-calendar.schema.json
│   └── post-ledger.sql
├── prompts/
│   ├── weekly-planner.md
│   ├── vertical-wholesale.md
│   ├── vertical-local-sales.md
│   ├── vertical-display-service.md
│   ├── vertical-event-rentals.md
│   ├── asset-request.md
│   ├── qa-review.md
│   ├── engagement-review.md
│   ├── reply-drafting.md
│   └── weekly-report.md
├── config/
│   ├── discord-config.example.json
│   ├── env.example
│   ├── routines.example.sh
│   ├── approval-policy.json
│   └── emergency-stop.json
├── ops/
│   └── runbook.md
└── discord-templates/
    └── message-templates.md
```

---

## Deployment Assumptions

- Claude Desktop (Pro, Max, Team, or Enterprise plan) with Claude Code Routines enabled
- Discord bot with permissions to post in designated channels
- Meta Graph API access with valid long-lived page tokens
- Instagram Business/Creator account connected to Facebook Page
- SQLite database or JSONL file for post ledger (local to agent workspace)
- 7 Claude Code Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Human approvers have Discord access and understand approval actions
