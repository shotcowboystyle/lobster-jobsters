# Cross-Team Handoffs — ACME Bonsai

End-to-end choreography across team boundaries. Each flow names the artifact, the source agent + ledger entry, the destination agent + ledger entry, and the state transitions on both sides.

This is the canonical reference for inter-team coordination. Per-team `AGENTS.md` files describe handoffs from their own perspective; this file shows them whole.

---

## Flow A: Wholesale Deal — Lead to Delivery

**Path:** DoS (Wade) → Contract Coordinator (Rowan + sub-agents)

```
Lead arrives
  ↓ DoS lead → DoS opportunity → DoS quote → DoS won
  ↓
  Handoff to Rowan via contract_request artifact
  ↓
Sage (Contract Specialist): DocuSign envelope sent → signed
Finch (Payments Agent): deposit invoiced → paid
Grove (Inventory & Orders): inventory reserved
Miles (Delivery Router): route planned → delivered
Finch: balance invoiced → paid
  ↓
Contract closed
```

**Source artifact:** `closed_deal` with `outcome = won`, `stream = wholesale` (DoS sales ledger)
**Hand-off artifact:** `contract-request` posted to Contract Coordinator inbox
**Destination workflow:** Contract Coordinator's full state machine (see `agents/contract-coordinator/README.md`)

**Cross-team escalations on this flow:**
- Wholesale deal > $5K → CEO escalation via `escalation-packet` (Rowan owns; Jane approves before contract send)
- Inventory shortfall → Grove → Rowan → Jane (with Tally substitution proposal)
- Deposit failure → Finch → Rowan; Jane decides via `escalation-packet`
- Signature timeout (> 5 days) → Sage → Rowan; reminder sent or void

---

## Flow B: Subscription — Signup to Renewal

**Path:** DoS (Sophia) → COO (Cedar) + CFO (Sterling) → CSM (Poppy + Pearl)

```
Subscription inquiry → DoS opportunity → quote → signed
  ↓
  Hand-off to Cedar: installation scheduling
  Hand-off to Sterling: Stripe subscription setup
  ↓
Cedar: install completed (delivery_job)
Sterling: billing setup via Margin's pricing approval
  ↓
Active subscription
  ↓
Daily CSM scan (Poppy):
  - Post-install check-in (Pearl)
  - Monthly satisfaction signal monitoring (Maple for tree health)
  - 60-day renewal window: Sophia outreach
  ↓
Renewal proposal → renewed (or churned if save fails)
```

**Source artifact:** `subscription_contract` with `status = signed` (DoS sales ledger)
**Hand-off artifacts:**
- To Cedar: `delivery_job` with `kind = subscription_install` (COO ops ledger)
- To Sterling: Stripe subscription via finance ledger
**Continuous monitoring:**
- CSM Maple monitors tree health
- CSM Poppy monitors CSAT + activity signals
- DoS Sophia owns renewal commercials

**Cross-team escalations on this flow:**
- Subscription < 12-month term → Jane approval (DoS approval policy)
- CSAT dip or churn risk → Poppy alerts Sophia + Cash; major-account save → Jane (CSM approval policy)
- Tree health decline persistent → Maple → Tally (species pattern check)

---

## Flow C: Event Rental — Booking to Return

**Path:** DoS (Max) → COO (Cedar)

```
Event inquiry → DoS opportunity → quote → deposit_paid → confirmed
  ↓
  Hand-off to Cedar's rental cycle
  ↓
Cedar (rental_job):
  scheduled → outbound (with before photos)
  → at_event
  → return_pickup (with after photos)
  → inspected
  → closed (if no damage) OR damaged
  ↓
Max post-event:
  - Cross-stream opportunity capture (event planner → wholesale; venue → subscription; client → local)
```

**Source artifact:** `event_booking` with `status = confirmed` (DoS sales ledger)
**Hand-off artifact:** `rental_job` (COO ops ledger) with linked `booking_id`
**Tally**: reserves rental tree inventory; releases on close

**Cross-team escalations on this flow:**
- Inventory conflict at booking time → Tally → Cedar → Max (Cash if escalated)
- Rental damage > $300 → Cedar's damage assessment → Jane via approval policy
- Day-of issue → Cedar → Max → Jane if customer-facing

---

## Flow D: Local Sale — Walk-In to Care Follow-Up

**Path:** DoS (Lily) → COO (Tally + Cedar) → CSM (Maple)

```
Walk-in customer → consultation → recommended → purchased
  ↓
  Tally: tree allocation
  Cedar: delivery scheduled (if applicable)
  ↓
Delivered
  ↓
14 days post-delivery:
  CSM Maple opens post_care_consult health check-in
  ↓
Customer responds → tree healthy / care guidance / problem
  - Healthy: archive
  - Care needed: Maple consultation
  - Problem: ticket opened (Pearl triage)
```

**Source artifact:** `local_sale` with `status = purchased` (DoS sales ledger)
**Hand-off artifacts:**
- To Tally: inventory allocation
- To Cedar: `delivery_job` with `kind = retail` (if delivery)
- To Maple: `health_check_in` with `kind = post_delivery` (CSM care ledger)

**Cross-team escalations on this flow:**
- Damaged tree at delivery → Cedar → Oakley (CSM) → Tally (replacement)
- Tree health decline post-purchase → Maple → consultation flow

---

## Flow E: Workshop — Calendar to Follow-Up

**Path:** COO (Hazel) + Mira (CD) + Care Education (CSM Maple) + Tally (COO)

```
Workshop proposed → calendar
  ↓
  Hazel: materials checklist + instructor confirmation
  Mira: handout materials (technically reviewed by Maple)
  Iris (CD): event coverage scheduled
  Tally: demo trees reserved
  ↓
Registration_open → confirmed (min capacity met)
  ↓
Day-of:
  Hazel: space setup with Birch
  Mira's handouts distributed
  Iris: event coverage
  ↓
Workshop runs → debrief
  ↓
Hazel: attendance recorded, demo trees back to Tally
Hazel + Mira: survey + care follow-up (Maple's care guide library)
```

**Cross-team coordination on this flow:**
- Materials gap < 1 week before → escalate to Victor (COO)
- Under minimum registration < 2 weeks before → Hazel → Victor + CMO promotion coordination → Jane on cancellation
- Demo tree health post-workshop → Tally
- Workshop content updates → Mira (technical review by Maple)

---

## Flow F: Marketing Publication

**Path:** CMO (full team) → CSM (Engagement Monitor → Reply Drafter) + Customer Service

```
CMO Strategy Planner → Content Brief → Platform Copywriter → Brand QA → Approval Coordinator
  ↓ (Jane approves)
  Publisher: Meta API publish (Instagram + Facebook)
  ↓
CMO Engagement Monitor (every 2h):
  - New comment / DM / reaction spike
  ↓
  Routine engagement: Reply Drafter
  Negative engagement: alert Pearl (CSM Support)
  Crisis: alert Poppy + Jane (CSM + Executive)
```

**Cross-team escalations on this flow:**
- Negative comment / DM → Engagement Monitor → Pearl (CSM); Pearl owns customer thread
- Viral / media risk → Engagement Monitor → Poppy + CMO + Jane (immediate)
- Brand drift in published asset → Hana (CD Brand Designer) → CMO + Masahiko

---

## Flow G: Production Deploy

**Path:** CTO (Allen + Forge + Pixel + Bastion) → all teams (notification)

```
Feature request → CTO triage (Allen)
  ↓
Spec → PR (Forge/Pixel) → review → merged
  ↓
Release scheduled (Bastion) → staging QA → approved
  ↓
Deploy window check (NOT Friday, NOT pre-campaign)
  ↓
Production deploy → monitoring window (24h)
  ↓
  - Clean: closed
  - Auto-rollback if error rate > baseline + 2% sustained 5 min: incident opened
```

**Cross-team coordination:**
- Deploy window awareness: Bastion checks CMO calendar for campaigns; DoS calendar for sales events
- Stripe / payment changes: Sterling (CFO) informed for billing reconciliation
- DocuSign / Stripe webhook changes: notify Sage + Finch (Contract Coordinator)
- Care guide CMS changes: notify Mira (CD)
- Customer-facing UI changes: notify Pearl (CSM)

**Cross-team escalations on this flow:**
- Production downtime > 1h → Jane (immediate)
- SEV-1 incident → Jane + cross-post to River's `#acme-exec-alerts`
- Major architecture change → Jane

---

## Flow H: Customer Service Pattern → Operational Fix

**Path:** CSM (Pearl / Oakley / Maple) → Poppy → operating team owner → Jane

```
≥ 3 customers same issue in 7 days (or species health pattern in 30 days)
  ↓
  Pattern detected by Oakley (order issue) / Maple (species health) / Pearl (general)
  ↓
Poppy weekly trending analysis identifies + opens customer_feedback entry routed to operating team
  ↓
escalation_card opened with kind = pattern_issue_root_cause
  ↓
  Jane approves response strategy
  Operating team commits to corrective action with deadline
  ↓
Track until pattern resolves (typically 30 days)
```

**Common pattern destinations:**
- Delivery issues → Cedar (COO)
- Inventory / species issues → Tally (COO)
- Billing issues → Sterling (CFO)
- Wholesale issues → Rowan (Contract Coordinator)
- Website issues → Allen (CTO)
- Brand / messaging issues → Masahiko (Creative Director) + CMO
- Sales process issues → Cash (DoS)

---

## Flow I: External Stakeholder Communication

**Path:** CEO Apex (Atlas + Envoy) → CEO ledger → external

```
Jane requests memo or external comm
  ↓
Atlas drafts memo (if applicable)
  ↓
Envoy wraps as external_comm
  ↓
Jane reviews + per-message approval
  ↓
Envoy sends via configured channel (email / letter)
  ↓
Provider acknowledges → status = sent
  ↓
Optional: stakeholder response captured
```

**Cross-team coordination:**
- Investor update with financials → Sterling (CFO) provides numbers
- Bank communication → Sterling (CFO) coordinates
- Press / media → CMO + Masahiko (CD) coordinate brand voice
- Legal → CEO direct (legal counsel engaged outside workspace)

**No outbound without Jane's per-message approval. Period.**

---

## Flow J: Strategic Initiative Lifecycle

**Path:** Operating exec → CEO Compass weekly question → CEO Almanac decision → Egret tracking

```
Operating exec proposes initiative
  ↓
Compass surfaces in weekly strategic question (Sun 9 PM)
  ↓
Jane answers → decision captured by Almanac with reversibility + outcome window
  ↓
Initiative opens in CoS Egret tracker (status: proposed)
  ↓
Sponsor (operating exec) commits → status: active
  ↓
Weekly traffic-light check (Egret, Sun 6-8 PM)
  ↓
Outcome window arrives (Almanac reopens decision entry)
  ↓
  Jane records actual outcome + reflection
  ↓
Initiative status: closed → archived
Decision: outcome_captured
```

---

## Flow K: Master Emergency Stop

**Triggered:** Any team detects a critical issue requiring all-workforce halt

```
Detector → alert in #acme-{team}-alerts
  ↓
Jane or any coordinator with authority sets:
  workforce/config/shared-emergency-stop.json: all_outbound_enabled = false
  ↓
Every team's local emergency-stop check now fails:
  - CMO Publisher refuses publish
  - Cedar refuses delivery dispatch
  - Hazel refuses workshop confirmations
  - Finch refuses invoice / refund sends
  - Sage refuses contract sends
  - Bastion refuses production deploys
  - Envoy refuses external comm sends
  - All others halt outbound
  ↓
Drafting + ledger writes + internal monitoring continues
  ↓
Resolution → unset master kill switch
  ↓
Per-team emergency stops still apply if independently set
```

See `ops/exec-runbook.md` for full master emergency stop procedure.

---

## Ledger Read Map (Cross-Team Queries)

| Team | Reads From |
|---|---|
| Chief of Staff (River) | All ledgers (for briefings + initiatives + agent health) |
| CEO (Apex / Compass) | All ledgers (for strategic synthesis) |
| CFO (Horizon) | CMO + COO + DoS + CSM + CTO + Contract Coordinator (for revenue + spend) |
| CFO (Margin) | DoS + Contract Coordinator + COO (for unit economics) |
| Director of Sales (Cash) | COO Tally (inventory availability) |
| Customer Service Manager (Poppy) | DoS (customer records) + COO (orders + inventory) + Contract Coordinator (wholesale) + CFO (billing) + CD (care guides) |
| Contract Coordinator (Rowan) | COO Tally + Cedar (inventory + delivery) + DoS Wade (handoff source) + CFO Sterling (payment) |
| Creative Director (Iris) | COO Tally (new inventory needing photography) |
| Creative Director (Mira) | CSM Maple (care advice expertise back-channel) |

---

## Discord Channel Map

Each team has 4 channels in the pattern `#acme-{team}-{purpose}`:

- `drafts` / `tickets` — work products surfaced for review
- `approvals` / `approvals` — CEO escalations
- `{stream}` / `reports` / `library` / `pipeline` — team-specific publishing
- `alerts` — incidents, breaches, kill-switch events

Cross-posted escalations appear in:
- `#acme-exec-briefings` (Chief of Staff workspace) — for executive visibility
- `#acme-exec-alerts` (Chief of Staff workspace) — for cross-team incidents
- `#acme-ceo-strategy` (CEO workspace) — for strategic-question candidates
- `#acme-ceo-alerts` (CEO workspace) — for executive-level alerts
