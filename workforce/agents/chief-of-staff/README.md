# ACME Bonsai — Chief of Staff Team

## Architecture Summary

Multi-agent OpenClaw system that runs ACME Bonsai's executive office: agenda preparation, weekly briefings, action-item follow-up, strategic-initiative tracking, and continuous health monitoring of every other OpenClaw workspace in the company. Discord is the human coordination layer. All briefings and escalations require River's review before they reach Jane. The system follows a "collect → synthesize → review → publish → follow-up → archive" pipeline.

Key principles:

- River coordinates; River does not decide for Jane
- Briefings hard-capped at one page (≈400 words)
- Honest traffic lights — no spin
- Every action item has an owner and a deadline
- Auditable — every agenda, decision, briefing, and initiative status logged to the executive ledger
- Agent-health monitoring is read-only; Magpie surfaces, never restarts

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | Chief of Staff | River 🦉 | Orchestrates the executive office | Routine + on-demand | Sub-agents + Jane |
| 2 | Briefing Synthesizer | Heron 🪶 | Compiles weekly cross-team digest into a single CEO briefing | Routine: Mon 7 AM; Fri 4 PM | River → Jane |
| 3 | Action-Item Tracker | Wren 🐦 | Pings owners on open action items; escalates the silent ones | Routine: every 12h | River |
| 4 | Agent Health Monitor | Magpie 🪞 | Polls every OpenClaw workspace for staleness, failed routines, missing heartbeats | Routine: every 4h | River |
| 5 | Initiative Tracker | Egret 🪿 | Maintains strategic initiative dashboard with weekly status | Routine: Sun 8 PM | River → Jane |

---

## Briefing State Machine

```
queued → drafting → coordinator_review → published → acknowledged → archived
              ↓                                ↓
           revising                       (held / retracted)
```

## Action Item State Machine

```
opened → in_progress → blocked? → done → archived
                                     ↓
                                  dropped (with reason)
```

## Initiative State Machine

```
proposed → active → on_hold → active → closed → archived
              ↓                              ↓
           cancelled                  (post-mortem if needed)
```

Health colors per initiative per week: `green` / `yellow` / `red`.

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Weekly CEO Briefing | Routine: Mon 7 AM | Heron → River | Jane acks in #exec-briefings |
| B. Mid-Week Briefing | Routine: Fri 4 PM | Heron → River | Jane acks in #exec-briefings |
| C. Action-Item Follow-Up | Routine: every 12h | Wren | River escalates silent owners |
| D. Agent-Health Sweep | Routine: every 4h | Magpie | River triages red flags |
| E. Strategic Initiative Update | Routine: Sun 8 PM | Egret | Sponsor approves color change before publish |
| F. Cross-Team Escalation | On-demand | River | Jane decides in #exec-actions |
| G. Meeting Agenda Prep | Before scheduled meeting | River + Heron | Jane approves agenda 24h before |
| H. Meeting Minutes & Actions | Immediately post-meeting | River + Wren | Jane confirms actions before publish |
| I. Emergency Stop | Any time | River | Jane or River sets `escalations_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Decisions | No decisions made on Jane's behalf without written delegation in the ledger |
| Briefings | Hard cap one page (≈400 words); every metric cites a ledger reference |
| Briefings | Never invent metrics — pull from each team's reported numbers verbatim |
| Action items | Every action item must have an owner and a deadline; missing either is a defect |
| Action items | Owners are pinged at +24h, +48h, then escalated to River at +72h |
| Initiatives | Health color set weekly by sponsor; River verifies but does not override |
| Initiatives | Initiatives unchanged > 14 days are flagged as potentially stalled |
| Agent health | Magpie surfaces anomalies; Magpie does NOT restart agents |
| Personnel | Sensitive personnel matters never enter shared Discord channels |
| External comms | No external-stakeholder communication without Jane's review |
| Operational | All state transitions logged to the executive ledger |
| Crisis | High-risk situations (legal, regulatory, financial, reputational) → immediate Jane ping |

---

## RACI Table

| Activity | River | Heron | Wren | Magpie | Egret | Jane (CEO) | Operating Exec |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Weekly briefing draft | C | R | — | — | C | I | I |
| Briefing publication | A | C | — | — | — | A (acks) | I |
| Action-item open | A | — | R | — | — | I | A (owner) |
| Action-item follow-up | A | — | R | — | — | I | A (owner) |
| Action-item completion | I | — | R | — | — | I | A (owner) |
| Agent-health sweep | A | — | — | R | — | I | I |
| Anomaly triage | A/R | — | — | C | — | I | I (if their agent) |
| Initiative status | C | — | — | — | R | I | A (sponsor) |
| Strategic decision | C | C | — | — | C | A/R | C |
| Emergency stop | R | I | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-exec-briefings` | Daily and weekly CEO briefings; meeting agendas and minutes | River + Heron post; Jane acks |
| `#acme-exec-actions` | Open action items, follow-ups, owner pings | Wren posts; owners and Jane act |
| `#acme-exec-initiatives` | Strategic initiative status updates and traffic-light changes | Egret posts; sponsors confirm |
| `#acme-exec-alerts` | Agent-health anomalies, ledger anomalies, emergency-stop events | Magpie + River post; Jane triages |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "escalations_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `escalations_enabled` is set to `false`:

1. River, Wren, and Egret queue outbound escalations locally (no Discord post)
2. Heron continues drafting briefings but does not publish them
3. Magpie continues polling but stops posting anomalies
4. All agents continue logging to the ledger
5. Discord alert posted to `#acme-exec-alerts`: "🛑 EXEC ESCALATIONS PAUSED: {reason}"

To resume: set `escalations_enabled: true`, post confirmation to Discord.

---

## Recommended File Tree

```
workforce/agents/chief-of-staff/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── agents/
│   ├── briefing-synthesizer/    # Heron
│   ├── action-item-tracker/     # Wren
│   ├── agent-health-monitor/    # Magpie
│   └── initiative-tracker/      # Egret
├── schemas/
│   ├── briefing-packet.schema.json
│   ├── action-item.schema.json
│   ├── meeting-agenda.schema.json
│   ├── initiative-status.schema.json
│   ├── agent-health-snapshot.schema.json
│   ├── escalation-routing.schema.json
│   └── exec-ledger.sql
├── prompts/
│   ├── weekly-briefing.md
│   ├── action-item-followup.md
│   ├── agent-health-sweep.md
│   ├── initiative-status.md
│   └── meeting-agenda.md
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
- Discord bot with permissions to post in the 4 designated channels
- Read access to every executive agent's ledger or status output
- SQLite database for the executive ledger (local to workspace; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Jane is the sole final approver; River may hold a defined delegation window for routine briefing publication
