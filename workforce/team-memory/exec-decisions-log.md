# Executive Decisions Log — ACME Bonsai

Cross-team durable decisions log. Per-team Almanac (CEO Decision Journal) entries are authoritative for the individual decision; this file is the cross-team-visible index of decisions that affect multiple teams.

Format: most recent at top. Each entry: date, decision, owner, scope, status, link to Almanac.

> The entries below are worked examples. Replace them with your own company's decisions when you adopt this workforce.

---

## 2026-06-27 — All cross-team escalations route through River

**Decision:** Establish the rule that cross-team escalations to Jane route through River (Chief of Staff) for executive briefing + context preservation. Operating coordinators do not direct-ping Jane except in time-critical situations (SEV-1 incidents, downtime > 1h, runway < 90 days, legal language, viral risk).

**Owner:** Jane Founder

**Scope:** Cross-team coordination across all 10 workspaces

**Status:** Active — encoded in `ops/exec-runbook.md`

**Affected teams:** All — Chief of Staff workspace owns the routing pattern

**Rationale:** Protect Jane's time + attention. Briefings ≤ 400 words. Single decision per ask. River sees everything; Jane sees what's actionable.

**Exceptions:** Time-critical incidents bypass River and go direct to Jane. River is notified in parallel.

**Linked Almanac decision:** `dec-2026-06-27-001`

---

## 2026-06-27 — Persona uniqueness rule enforced

**Decision:** Every agent persona (name + creature + emoji + workspace) is unique across the entire workforce. No two agents share a name, creature, or emoji. Conflicts found during build are resolved by renaming.

**Owner:** Jane Founder

**Scope:** All 35+ named personas

**Status:** Complete — zero conflicts remaining (enforced by `scripts/audit.py`)

**Rationale:** Persona uniqueness prevents confusion in coordination — every agent is unambiguously identifiable + memorable. Voice + personality differentiation aids both internal team coordination and customer-facing distinctiveness.

**Linked Almanac decision:** `dec-2026-06-27-002`

---

## 2026-06-27 — Per-team emergency stop + master kill switch architecture

**Decision:** Every team has a `config/emergency-stop.json` with a team-specific flag (publishing_enabled / contracts_enabled / finance_actions_enabled / ops_actions_enabled / deploys_enabled / publish_assets_enabled / sales_actions_enabled / outbound_replies_enabled / external_comms_enabled / escalations_enabled). Workspace-level `config/shared-emergency-stop.json` with `all_outbound_enabled` flag overrides any team-level "on" setting.

**Owner:** Jane Founder

**Scope:** All 10 teams + workspace root

**Status:** Active — encoded in workspace config + `ops/exec-runbook.md`

**Affected teams:** All

**Rationale:** Two-tier kill switch enables both surgical (team-specific) and total (workspace-wide) pause. Master kill switch reserved for SEV-A workforce-critical events (regulatory, data breach, mass customer harm). Team-level kills for team-specific incidents.

**Test cadence:** Quarterly tabletop exercise to verify all agents detect + halt outbound correctly.

**Linked Almanac decision:** `dec-2026-06-27-003`

---

## 2026-06-27 — Tally + Grove shared inventory sheet pattern

**Decision:** The inventory spreadsheet is the canonical source of truth for tree counts. Tally (COO Inventory) is the primary owner; Grove (Contract Coordinator Inventory & Orders) writes to the same sheet for wholesale reservations. Both use atomic per-row updates.

**Owner:** Jane Founder

**Scope:** Inventory data; affects COO + Contract Coordinator + CSM + DoS + CD photography

**Status:** Active — encoded in COO + Contract Coordinator workspaces

**Affected teams:** COO, Contract Coordinator, DoS (availability checks), CSM (replacement coordination), CD (photography coverage)

**Rationale:** Single canonical inventory sheet prevents reservation conflicts. Atomic per-row updates allow concurrent writers without locking. Cross-team coordinators read the same data so customer-facing commitments don't conflict.

**Linked Almanac decision:** `dec-2026-06-27-004`

---

## How to Add an Entry

For decisions affecting ≥ 2 teams or company-level direction:

1. Almanac drafts an entry in CEO ledger (`decision_entries` table)
2. Jane acks
3. River (or affected coordinator) appends a summary here with:
   - Date
   - Decision (one paragraph)
   - Owner
   - Scope
   - Status
   - Affected teams
   - Rationale
   - Linked Almanac decision_id
4. Outcome window arrives → Almanac reopens → Jane records actual outcome → update status here

**Decisions to include here:**
- Cross-team policy changes
- Brand voice changes
- Major pricing changes
- ICP changes
- Tech stack changes affecting > 1 team
- Org structure changes
- New workspace additions

**Decisions NOT to include here:**
- Single-team operational decisions (those stay in team's MEMORY.md)
- Routine approvals within authority
- Daily operational decisions
