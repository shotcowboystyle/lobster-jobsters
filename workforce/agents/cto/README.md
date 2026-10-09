# ACME Bonsai — CTO Team (Allen)

## Architecture Summary

Multi-agent OpenClaw system that runs ACME Bonsai's digital storefront and supporting infrastructure: marketing site, booking systems (workshops, rentals, subscriptions), lead capture, CMS, payment integration, and internal admin tools. Discord is the human coordination layer. GitHub holds the source of truth for code; the hosting provider holds the source of truth for infrastructure; the tech ledger holds workflow state for feature requests, releases, incidents, security findings, and tech debt.

Key principles:

- Technology serves the business; we don't ship beautiful systems that don't move the numbers
- Boring infrastructure wins — battle-tested tools rarely fail in new and interesting ways
- Engineers are the asset; we protect their time, energy, and cognitive load
- Technical debt is a finance problem — interest rates explicit, paydown budgeted
- No Friday deploys, no pre-campaign deploys, no deploys without staging + backup
- Postmortems blame the system, not the person; corrective + preventive action always documented

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | CTO | Allen 🎯 | Orchestrates the team; protects platform integrity | Routine + on-demand | Sub-agents + Jane |
| 2 | Frontend | Pixel 🎨 | UI/UX implementation, responsive design, accessibility | Per feature + daily intake | Forge + Bastion |
| 3 | Backend | Forge ⚙️ | Database, APIs, payment integration, booking logic | Per feature + daily backend health | Pixel + Bastion |
| 4 | DevOps | Bastion 🏰 | Hosting, deployment, monitoring, security, backups | Daily infra + security; per release | Allen → Jane on incidents |

---

## State Machines

**Feature request:** `intake → triaged → specced → in_dev → in_review → in_staging → in_prod → archived` (rejected / deferred / rolled_back as side states)

**Pull request:** `drafted → review → approved → merged → deployed → closed` (rejected / abandoned as side states)

**Release:** `scheduled → in_staging → staging_qa → approved → deploying → deployed → monitoring → closed` (rejected / rolled_back / failed as side states)

**Incident:** `detected → triaged → mitigated → resolved → postmortem → archived` (escalated as side state)

**Security finding:** `detected → triaged → patching → patched → verified → archived` (deferred with documented risk acceptance)

**Tech debt:** `logged → triaged → scheduled → in_progress → resolved → archived` (deferred — interest accrues)

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Daily Infra Health | Routine: 6 AM ET | Bastion | Allen reviews escalations |
| B. Daily Security + Dependency Scan | Routine: 7 AM ET | Bastion | Allen on high/critical findings |
| C. Daily Backend Health | Routine: 8 AM ET | Forge | Allen on DB / API / error-rate drift |
| D. Daily Feature Intake Triage | Routine: 9 AM ET | Allen | Jane on > 40h or > $3K items |
| E. Per-Feature Spec | On triaged feature | Allen + sub-agent owner | Requester approves spec |
| F. Per-Feature Build | On specced feature | Pixel / Forge / Bastion | Allen on PR review |
| G. Per-Feature Staging QA | After PR merged | Pixel + Forge + Bastion | Requester approves |
| H. Release | After staging QA pass | Bastion | Allen approves; Jane on major release |
| I. Incident Response | On detection | Bastion → Allen | Jane on > 1h downtime / critical CVE |
| J. Weekly Tech Debt Review | Routine: Mon 9 AM ET | Allen | Decide scheduled / deferred per item |
| K. Weekly Release Planning | Routine: Mon 10 AM ET | Allen + Bastion | Jane if major release planned |
| L. Weekly Platform Report | Routine: Fri 4 PM ET | Allen | Cross-posted to Sterling (CFO) + Jane |
| M. Monthly Security + SLO Audit | Routine: Day 1 at 10 AM ET | Bastion + Allen | Jane on findings |
| N. Emergency Stop | Any time | Allen | Jane or Allen sets `deploys_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Deploy timing | No Friday deploys |
| Deploy timing | No deploys right before Marketing campaign or Sales event |
| Deploy hygiene | Staging deploy + QA before every prod deploy |
| Deploy hygiene | Backup verified before every prod deploy |
| Deploy hygiene | Rollback plan documented before every prod deploy |
| Security | No secrets in plaintext or in repository |
| Security | Payment data only in Stripe (PCI compliance via tokenization) |
| Security | No unpatched, known-vulnerable software in production |
| Security | High/critical CVEs patched within 24h or risk acceptance documented |
| API | No breaking API changes without migration plan + communication |
| Code | All non-trivial PRs reviewed before merge |
| Code | Tests for critical paths (checkout, booking, payment) |
| Approvals | Features > 40h or > $3K → Jane approval |
| Approvals | Major architecture changes → Jane approval |
| Approvals | SaaS additions > $200/month → Jane approval |
| Incidents | Downtime > 1h → immediate Jane alert |
| Incidents | Postmortems always include root cause + corrective + preventive action |
| Operational | All state transitions logged to the tech ledger |
| Personnel | Sensitive matters: 1:1 Jane only |

---

## RACI Table

| Activity | Allen | Pixel | Forge | Bastion | Jane | Requester |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|
| Feature intake triage | R | C | C | C | I | A (writes brief) |
| Spec drafting | A | R (frontend) | R (backend) | R (infra) | I | C |
| Code implementation | A | R / C | R / C | R / C | — | I |
| PR review | A/R | R | R | R | — | I |
| Staging QA | A | R | R | R | I | A (signs off) |
| Production deploy | A | I | I | R | A (if major) | I |
| Incident response | A/R | — | — | R | A (if > 1h) | I |
| Postmortem | A/R | C | C | R | I | I |
| Security patching | A | — | — | R | I (if critical) | — |
| Tech debt prioritization | A/R | C | C | C | A (budget) | — |
| Weekly platform report | A/R | C | C | C | A (acks) | — |
| Emergency stop | R | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-tech-drafts` | Feature intake, spec drafts, PR reviews, weekly platform report | All sub-agents post; Allen reviews |
| `#acme-tech-approvals` | CEO escalations: > 40h / > $3K, architecture changes, SaaS > $200/mo, rollbacks | Allen posts; Jane acts |
| `#acme-tech-releases` | Release plans, staging QA, prod deploy confirmations | Bastion posts; Allen + Jane review |
| `#acme-tech-alerts` | Incidents, security findings, uptime / latency / error-rate breaches | All agents post; Allen triages |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "deploys_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `deploys_enabled` is `false`:

1. Bastion refuses production deploys
2. Pixel, Forge continue building + reviewing in dev / staging
3. Existing services continue serving traffic; no infra changes
4. Discord alert posted to `#acme-tech-alerts`: "🛑 DEPLOYS PAUSED: {reason}"

To resume: set `deploys_enabled: true`, post confirmation to Discord.

---

## Idempotency Strategy

Every production-impacting action carries an idempotency key:

- Deploy: `acme-tech-{release_id}-deploy-{attempt}`
- Rollback: `acme-tech-{release_id}-rollback-{attempt}`
- Backup: `acme-tech-{date}-backup-{kind}-{attempt}`
- Customer notification on incident: `acme-tech-{incident_id}-notify-{attempt}`

Before any production-impacting action, check the ledger for an existing entry with the same key.

---

## Recommended File Tree

```
workforce/agents/cto/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── agents/
│   ├── frontend-developer/      # Pixel
│   ├── backend-developer/       # Forge
│   └── devops-agent/            # Bastion
├── schemas/
│   ├── feature-request.schema.json
│   ├── spec.schema.json
│   ├── pull-request.schema.json
│   ├── release.schema.json
│   ├── incident.schema.json
│   ├── security-finding.schema.json
│   ├── observability-snapshot.schema.json
│   ├── tech-debt-entry.schema.json
│   └── tech-ledger.sql
├── prompts/
│   ├── feature-triage.md
│   ├── release-planning.md
│   ├── incident-response.md
│   └── security-scan.md
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
- GitHub repository for code (PRs, Actions for CI)
- Vercel (or Render) for hosting
- Cloudflare for CDN + WAF
- Stripe for payments (PCI-compliant)
- Sentry (or equivalent) for error tracking + alerting
- Better Uptime (or equivalent) for synthetic monitoring + status page
- SQLite database for the tech ledger (local; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Allen holds delegated authority within thresholds; Jane is final approver for anything above
