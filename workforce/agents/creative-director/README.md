# ACME Bonsai — Creative Director Team (Masahiko)

## Architecture Summary

Multi-agent OpenClaw system that owns visual identity, brand consistency, photography, and design assets across every ACME Bonsai touchpoint — website, social media, email, packaging, signage, wholesale catalogs, subscription pitch decks, event collateral, workshop materials, care guides. Discord is the human coordination layer. The creative ledger holds workflow state; the brand asset library holds delivered finals; the brand system holds the canonical style guide.

Key principles:

- Less is more; restraint signals confidence
- Every element earns its place
- Consistency across touchpoints matters more than any single piece
- Honest photography — never enhance trees beyond truth
- Educational content technically verified before publication
- Zero tolerance for typos in published work

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | Creative Director | Masahiko 🦌 | Orchestrates the team; protects brand integrity | Routine + on-demand | Sub-agents + Jane |
| 2 | Brand Designer | Hana 🌸 | Visual identity, marketing assets, templates, compliance | Daily brief intake | CMO + Pixel + Sales |
| 3 | Photography | Iris 📷 | Product / lifestyle / event photography, library | Daily inventory coverage + per request | All teams |
| 4 | Educational Content | Mira 📘 | Care guides, workshop materials, instructional graphics | Per request + weekly library review | CMO + Hazel + Customer Service |

---

## State Machines

**Creative brief:** `intake → triaged → assigned → in_production → in_review → approved → delivered → archived` (rejected / revising as side states)

**Design deliverable:** `drafted → cd_review → revising → cd_review → approved → delivered → archived` (rejected as side state)

**Photo shoot:** `requested → scheduled → captured → editing → cd_review → approved → archived` (rescheduled / cancelled / rejected as side states)

**Care guide:** `drafted → technical_review → cd_review → revising → approved → published → archived` (rejected as side state)

**Brand system update:** `proposed → impact_analysis → cd_review → ceo_review → approved → published → archived` (rejected as side state)

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Daily Brief Intake Triage | Routine: 9 AM ET | Masahiko | Jane on > $2K items |
| B. Daily Photography Production | Routine: 10 AM ET | Iris | Masahiko reviews proofs |
| C. Daily Brand Asset Audit | Routine: 11 AM ET | Hana | Masahiko on drift signals |
| D. Per-Brief Design | On assigned brief | Hana / Mira | Masahiko reviews each draft |
| E. Per-Inventory Photo Shoot | New inventory from Tally | Iris | Masahiko approves library entry |
| F. Per-Care-Guide Drafting | On request from CMO / Hazel | Mira | Care Education reviews; Masahiko approves |
| G. Weekly Asset Library Audit | Routine: Mon 10 AM ET | Hana | Masahiko reviews drift |
| H. Weekly Production Capacity Review | Routine: Mon 11 AM ET | Masahiko | Jane on conflicting priorities |
| I. Weekly Creative Output Report | Routine: Fri 4 PM ET | Masahiko | Cross-posted to CMO + DoS + Jane |
| J. Monthly Brand Consistency Audit | Routine: Day 1 at 10 AM ET | Masahiko + Hana | Jane on brand drift findings |
| K. Brand System Update | Per proposal | Masahiko | Jane on major changes |
| L. Emergency Stop | Any time | Masahiko | Jane or Masahiko sets `publish_assets_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Budget | Project > $2,000 → Jane approval |
| Identity | Rebranding or major identity change → Jane approval |
| Legal | IP / copyright concern → Jane approval (legal route) |
| Style guide | Changes require Masahiko's authorization; major changes require Jane |
| Photography | Honest representation — no misleading tree enhancement |
| Photography | Customer spaces / events require signed release before publication |
| Educational | Technical accuracy verified by Care Education (CSM team) before publication |
| Quality | Zero tolerance for typos in published work |
| Brand compliance | Every asset uses approved palette + typography + logo treatment |
| Brand compliance | No unauthorized font / color / style additions |
| Accessibility | Sufficient color contrast; color-blind-friendly accents |
| Operational | All state transitions logged to the creative ledger |
| Confidentiality | Customer assets confidential; do not reuse without permission |
| Personnel | Sensitive matters: 1:1 Jane only |

---

## RACI Table

| Activity | Masahiko | Hana | Iris | Mira | Jane | Cross-Team |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|
| Brief intake triage | A/R | C | C | C | I | A (CMO / DoS) |
| Brand-asset design | A | R | — | — | I | I |
| Photography session | A | — | R | — | I | C (Tally inventory) |
| Care guide drafting | A | — | — | R | I | C (Care Education) |
| Brand compliance enforcement | A/R | R | — | — | I | I |
| Asset library management | A | R | C | C | — | — |
| Photo release management | A | — | R | — | I | A (Jane on customer) |
| Brand system update | A | C | C | C | A (major) | — |
| Project > $2K commitment | A | C | C | C | A/R | — |
| Cross-team conflicting priorities | A | — | — | — | A/R | — |
| Emergency stop | R | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-creative-drafts` | Brief intake, design drafts, photo proofs, care guide drafts | All sub-agents post; Masahiko reviews |
| `#acme-creative-approvals` | CEO escalations: > $2K, rebranding, IP, conflicting priorities | Masahiko posts; Jane acts |
| `#acme-creative-library` | Asset library updates, brand system changes, template releases | Hana posts; Masahiko approves |
| `#acme-creative-alerts` | Brand drift, off-brand publications, missed deadlines, emergency-stop | All agents post; Masahiko triages |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "publish_assets_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `publish_assets_enabled` is `false`:

1. Hana refuses to publish brand assets to external surfaces; drafts continue
2. Mira refuses to publish care guides; drafts continue
3. Iris continues capturing + editing; archives finals locally without publishing
4. Discord alert posted to `#acme-creative-alerts`: "🛑 CREATIVE PUBLICATION PAUSED: {reason}"

To resume: set `publish_assets_enabled: true`, post confirmation to Discord.

---

## Idempotency Strategy

Every outbound side-effect carries an idempotency key:

- Asset publish to web: `acme-creative-{asset_id}-publish-web-{attempt}`
- Asset publish to social: `acme-creative-{asset_id}-publish-social-{attempt}`
- Care guide publication: `acme-creative-{guide_id}-publish-{attempt}`
- Photo release request to customer: `acme-creative-{shoot_id}-release-{attempt}`

Before publish, check the ledger for an existing entry with the same key.

---

## Recommended File Tree

```
workforce/agents/creative-director/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── agents/
│   ├── brand-designer/                # Hana
│   ├── photography-agent/             # Iris
│   └── educational-content-designer/  # Mira
├── schemas/
│   ├── creative-brief.schema.json
│   ├── design-deliverable.schema.json
│   ├── photo-shoot.schema.json
│   ├── care-guide.schema.json
│   ├── brand-asset.schema.json
│   ├── brand-system-update.schema.json
│   ├── revision-cycle.schema.json
│   └── creative-ledger.sql
├── prompts/
│   ├── brief-triage.md
│   ├── design-review.md
│   ├── photography-session.md
│   └── care-guide-drafting.md
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
- Figma (or equivalent) for design source files
- Adobe Lightroom / Photoshop (or equivalent) for photo editing
- File storage (S3, Dropbox, Google Drive) for asset library
- Email + e-sign provider for photo release management
- SQLite database for the creative ledger (local; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Masahiko holds delegated authority within thresholds; Jane is final approver for anything above
