# ACME Bonsai — Executive Runbook (Cross-Team)

This runbook covers procedures that span multiple teams. Per-team runbooks live in each workspace under `ops/runbook.md` and handle team-internal operations. This file handles inter-team coordination, joint incident response, and master operations.

---

## Daily Cross-Team Cadence

| Time | Event | Owner | Cross-Team |
|---|---|---|---|
| 6:00 AM | CTO infra health (Bastion) | CTO | Allen surfaces uptime/security to all if breach |
| 6:00 AM | COO environmental check (Birch) | COO | Tally health correlation |
| 7:00 AM | COO inventory + health scan (Tally) | COO | Surfaces new inventory to Iris (CD); species patterns to Maple (CSM) |
| 7:00 AM | CFO daily reconciliation (Ledger) | CFO | Reconciles Stripe + bank |
| 7:30 AM | CFO compliance check (Garrison) | CFO | Tax + regulatory deadlines |
| 8:00 AM | CMO daily draft generation begins | CMO | Strategy → Brief → Copy → QA |
| 8:00 AM | CSM ticket triage (Pearl) | CSM | Routes to Oakley / Maple |
| 8:00 AM | CFO AR aging + AP scheduling (Ledger) | CFO | Coordinates with DoS for payment status |
| 8:00 AM | COO delivery confirmation sweep (Cedar) | COO | Customer-facing communications |
| 8:00 AM | DoS lead intake (all sub-agents) | DoS | Routes to Wade / Lily / Sophia / Max |
| 9:00 AM | CSM order issue sweep (Oakley) | CSM | Reads Cedar + Rowan + Sterling ledgers |
| 9:00 AM | CTO feature triage (Allen) | CTO | Routes Jane-approval items |
| 9:00 AM | CD brief triage (Masahiko) | CD | Routes to Hana / Iris / Mira |
| 9:30 AM | DoS open-quote follow-up | DoS | All sub-agents |
| 10:00 AM | CSM care follow-ups (Maple) | CSM | Coordinates with Tally on species patterns |
| 11:00 AM | CSM proactive customer health (Poppy) | CSM | Surfaces major-account at-risk to Jane |

---

## Weekly Cross-Team Cadence

| Day | Time | Event | Owner | Cross-Team |
|---|---|---|---|---|
| Mon | 7:00 AM | CMO weekly content calendar | CMO Strategy Planner | Reviewed by Jane |
| Mon | 7:00 AM | CoS weekly CEO briefing (Heron) | Chief of Staff | Pulls from all team ledgers; cross-posts to Jane |
| Mon | 8:00 AM | CFO weekly runway + cash (Horizon) | CFO | Runway < 90d → immediate Jane alert |
| Mon | 8:00 AM | DoS pipeline review (Cash) | DoS | Cross-posts to Sterling for revenue forecasting |
| Mon | 8:00 AM | COO route review (Cedar) | COO | Coordinates with Sales for delivery commitments |
| Mon | 9:00 AM | CTO tech debt review (Allen) | CTO | Jane briefed on top 3 |
| Mon | 9:00 AM | CSM trending issues (Poppy) | CSM | Routes patterns to operating teams; escalates to Jane |
| Mon | 10:00 AM | CTO release planning (Allen + Bastion) | CTO | Verifies deploy windows vs CMO campaigns + Sales events |
| Mon | 10:00 AM | CFO margin snapshot (Margin) | CFO | Cross-posts to DoS on channel performance |
| Mon | 10:00 AM | CD weekly asset library audit (Hana) | CD | Identifies brand drift |
| Mon | 10:00 AM | Wholesale pipeline nudge (Wade) | DoS | — |
| Mon | 11:00 AM | Subscription renewal outreach (Sophia) | DoS | Coordinates with Poppy on at-risk |
| Fri | 4:00 PM | CMO weekly performance report | CMO | Cross-posts to Jane + DoS |
| Fri | 4:00 PM | CFO exception audit (Garrison) | CFO | — |
| Fri | 4:00 PM | DoS weekly revenue + pipeline | DoS | Cross-posts to Sterling (CFO) for weekly close |
| Fri | 4:00 PM | CTO weekly platform report | CTO | Cross-posts to Sterling for software spend |
| Fri | 4:00 PM | CSM weekly customer health | CSM | Cross-posts to Jane + CMO + DoS |
| Fri | 4:00 PM | CD weekly creative output | CD | Cross-posts to CMO + DoS |
| Fri | 4:00 PM | CoS mid-week briefing (Heron) | Chief of Staff | Cross-posts to Jane |
| Sun | 5:00 PM | CC weekly route planning (Miles) | Contract Coordinator | Coordinates with Cedar (COO) on van availability |
| Sun | 6:00 PM | CoS initiative sponsor pings (Egret) | Chief of Staff | Cross-team sponsors |
| Sun | 8:00 PM | CoS initiative dashboard (Egret) | Chief of Staff | — |
| Sun | 9:00 PM | CEO weekly strategic question (Compass) | CEO | Reads all team ledgers |
| Sun | 9:30 PM | CEO pattern note (Almanac) | CEO | — |

---

## Monthly Cross-Team Cadence

| Day | Time | Event | Owner | Cross-Team |
|---|---|---|---|---|
| Day 1 | 9:00 AM | DoS cohort + LTV refresh | DoS Cash | Cross-posts to Sterling |
| Day 1 | 9:00 AM | CFO monthly close kickoff (Ledger) | CFO | Day 5 target; coordinates with all teams for actuals |
| Day 1 | 10:00 AM | COO monthly equipment inspection (Birch) | COO | > $1K items to Jane |
| Day 1 | 10:00 AM | CTO monthly security + SLO audit (Bastion + Allen) | CTO | — |
| Day 1 | 10:00 AM | CD monthly brand consistency audit | CD | Jane on systemic drift |
| Day 1 | 10:00 AM | CSM monthly voice-of-customer | CSM | Cross-posts to Jane + all operating teams |
| Day 6 | 9:00 AM | CFO monthly forecast refresh (Horizon) | CFO | After close; Sterling approves; Jane acks |

---

## Joint Incident Response

### Severity Decision Tree

| Cross-Team Severity | Definition | Coordinator | Response Time |
|---|---|---|---|
| **SEV-A Workforce-Critical** | Master kill switch needed (regulatory event, data breach, mass customer harm) | Jane or Apex | Immediate (< 5 min) |
| **SEV-B Multi-Team Major** | Affects ≥ 2 operating teams (CMO + CSM viral incident; CTO + CSM payment failure) | River | < 30 min joint response |
| **SEV-C Cross-Team Routine** | Single-team owner, but needs cross-team coordination | Owning team coordinator | Per team SLA |

### SEV-A Response Procedure

1. **Detect** — Any agent or human detects workforce-critical event
2. **Alert** — Immediate post to `#acme-exec-alerts` (Chief of Staff workspace) + direct ping to Jane
3. **Activate master kill switch** — Jane or Apex sets `config/shared-emergency-stop.json` `all_outbound_enabled = false`
4. **Convene** — Jane + River + affected team coordinators on Discord voice (immediate)
5. **Triage** — Identify scope, root cause, immediate mitigation
6. **Communicate** — Customer-facing communication (if needed) requires Jane per-message approval; consider engaging legal counsel for regulatory events
7. **Resolve** — Each team executes per their domain ownership
8. **Stand down** — Jane or Apex sets `all_outbound_enabled = true` with `resume_notes`
9. **Postmortem** — Within 5 business days, joint postmortem with all involved coordinators; Almanac journals the decision; Egret tracks corrective actions

### SEV-B Response Procedure

1. **Detect** — Cross-team trigger (e.g., CSM detects viral risk; CTO detects payment integration failure)
2. **Alert** — Post to `#acme-exec-alerts` + ping affected team coordinators
3. **Convene** — River coordinates affected teams (Discord channel or voice as needed)
4. **Assess** — Joint scope assessment; classify severity per team's SEV scale (SEV-1/2/3 within team)
5. **Action plan** — Each team's coordinator commits to specific actions with timing
6. **Execute** — Teams operate in parallel; River monitors progress
7. **Communicate** — Customer-facing requires CSM Poppy + originating coordinator approval; major customer impact escalates to Jane
8. **Close** — All teams confirm resolution; postmortem if SEV-1 within any team

### SEV-C Cross-Team Routine

Handled per the owning team's runbook; this file just documents that cross-team coordination is needed. Example: COO Tally surfaces species pattern → Maple (CSM) consulted → Mira (CD) updates care guide → done.

---

## Master Kill Switch — `config/shared-emergency-stop.json`

### When to Activate

- Regulatory event (legal subpoena, regulatory action, court order)
- Mass customer harm (data exposure, payment fraud, food/safety incident)
- Reputational crisis at workforce-wide level
- Cybersecurity breach affecting customer data
- Jane's personal judgment that "stop everything" is needed

### How to Activate

```bash
# Edit workforce/config/shared-emergency-stop.json
{
  "all_outbound_enabled": false,
  "reason": "Brief description of why",
  "stopped_by": "Jane Founder",
  "stopped_at": "2026-06-28T12:00:00Z"
}
```

### What Stops

Every team's outbound flows pause regardless of per-team emergency-stop state:

- **CMO Publisher**: refuses Meta API publish
- **Contract Coordinator (Sage)**: refuses DocuSign envelope send
- **Contract Coordinator (Finch)**: refuses invoice / refund send
- **Contract Coordinator (Miles)**: refuses route email send
- **COO Cedar**: refuses delivery dispatch + customer confirmations
- **COO Hazel**: refuses workshop confirmations + reminders
- **CTO Bastion**: refuses production deploys
- **CEO Envoy**: refuses external comm send
- **CSM Pearl + Oakley + Maple**: refuses customer-facing replies
- **CSM Poppy**: refuses proactive outreach
- **CD Hana + Mira**: refuses asset publication

### What Continues

- Internal drafting + triage + investigation
- All ledger writes (state transitions logged)
- Internal Discord coordination
- Monitoring (CTO Bastion infra; COO Birch environmental; CSM Pearl ticket intake)
- Cross-team escalations (drafted; sent if/when stop is lifted, or by Jane-direct override)

### How to Deactivate

```bash
# Edit workforce/config/shared-emergency-stop.json
{
  "all_outbound_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "What changed; what was resolved",
  "resumed_by": "Jane Founder",
  "resumed_at": "2026-06-28T14:00:00Z"
}
```

After deactivation, per-team emergency stops still apply if independently set. Each team should sweep queued actions and proceed in order.

### Test Procedure (Quarterly)

- Quarterly: announce a "tabletop exercise" — activate master kill switch in a non-production simulation
- Verify all teams' agents detect + halt outbound correctly
- Document any drift or missed agents in `team-memory/exec-decisions-log.md`
- Jane approves the test; River coordinates

---

## Cross-Team Conflict Resolution

When two teams' authority overlaps (e.g., DoS Sophia + CSM Poppy both involved in subscription save), use this order:

1. **Try to resolve at the working level** — coordinators talk; agree on plan
2. **If can't resolve in 1h**: escalate to River for joint coordination
3. **If can't resolve in 4h**: escalate to Jane for decision
4. **Document outcome** in `team-memory/exec-decisions-log.md` so the pattern is precedent for next time

Common conflict types:
- **Inventory commitment vs availability** — Tally is final authority; coordinator who needs the trees works with her
- **Pricing vs margin** — Margin (CFO) is final authority on floor; Cash (DoS) escalates if disagreement
- **Deploy window vs campaign timing** — Bastion (CTO) is final authority on deploy safety; CMO escalates if blocked
- **Brand drift vs cross-team need** — Masahiko (CD) is final authority on brand; other team escalates if blocked
- **Customer save vs commercial terms** — Jane on major-account concessions; Poppy + Sophia + Cash coordinate

---

## Cross-Team Reporting Cadence to Jane

| Frequency | Report | Owner | Format |
|---|---|---|---|
| Daily | Briefing card (if anything to surface) | River → Jane | Discord post in `#acme-exec-briefings` |
| Weekly | CEO briefing (Mon 7 AM) | Heron → Jane | ≤ 400 words |
| Weekly | Mid-week briefing (Fri 4 PM) | Heron → Jane | ≤ 400 words |
| Weekly | Pipeline + revenue (Fri 4 PM) | Cash → Jane + Sterling | Cross-posted |
| Weekly | Platform health (Fri 4 PM) | Allen → Jane | Cross-posted to Sterling |
| Weekly | Customer health (Fri 4 PM) | Poppy → Jane + CMO + DoS | Cross-posted |
| Weekly | Creative output (Fri 4 PM) | Masahiko → CMO + DoS | Cross-posted |
| Weekly | Cash + runway (Mon 8 AM) | Horizon → Sterling → Jane (if < 90d) | Immediate alert if breach |
| Sunday | Strategic question (9 PM) | Compass → Jane | One question, no SLA on answer |
| Sunday | Initiative dashboard (8 PM) | Egret → Jane | Traffic-light per initiative |
| Daily | Decision capture (6 PM) | Almanac → Jane | Per-decision ack |

---

## Jane's Decision Workflow

When Jane decides anything cross-team:

1. **Decision happens** — in conversation, in Discord reply, in meeting
2. **Almanac captures** — at end of day, Almanac drafts `decision_entry` with reversibility + outcome window
3. **Jane acks** — confirms decision text + reasoning
4. **Egret tracks** — if decision opens a strategic initiative
5. **Affected teams notified** — River posts cross-team brief to relevant `#acme-*-tickets` or `*-drafts` channels
6. **Outcome window arrives** — Almanac reopens; Jane records actual outcome
7. **Pattern surfaced** — Almanac's weekly pattern note may flag recurring decision types

---

## Cross-Team Glossary Pointer

For canonical terminology used across teams, see `team-memory/glossary.md`.

For brand voice everyone uses, see `team-memory/brand-voice.md`.

For ICP everyone targets, see `team-memory/icp-profile.md`.

For market context, see `team-memory/market-brief.md`.

For tech stack reference, see `team-memory/tech-stack.md`.

For decisions log, see `team-memory/exec-decisions-log.md`.
