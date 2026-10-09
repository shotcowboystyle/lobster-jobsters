# ACME Bonsai CTO Team (Allen) — Operations Runbook

## Overview

This runbook covers daily, weekly, and monthly operations for the ACME Bonsai engineering team — Allen (CTO), Pixel (Frontend), Forge (Backend), Bastion (DevOps).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-tech-alerts` for overnight incidents / security findings / breaches
2. Review daily infra health check (Bastion, 6 AM) — uptime, SSL, backup, CDN
3. Review daily security + dependency scan (Bastion, 7 AM)
4. Review daily backend health check (Forge, 8 AM) — DB, APIs, Stripe, jobs
5. Review feature intake triage (Allen, 9 AM) — Jane-approval items routed

### Throughout the Day

1. Spec drafts surface in `#acme-tech-drafts` for Allen review
2. PR reviews route between Pixel / Forge / Bastion
3. Release plans surface in `#acme-tech-releases` for Allen + Jane approval
4. Incidents surface in `#acme-tech-alerts` — Bastion triages
5. Allen escalates above-threshold items to Jane

### Evening (6:00 PM ET)

1. Check for releases entering monitoring windows tonight
2. Verify next-morning routines armed
3. Note items rolling to tomorrow

---

## Weekly Operations

### Monday Morning

1. **9:00 AM**: Allen runs tech debt review — prioritize for the week
2. **10:00 AM**: Allen + Bastion run release planning — verify deploy windows, backup status, conflicts

### Friday Afternoon

1. **4:00 PM**: Allen runs weekly platform report; cross-posts to Sterling

---

## Monthly Operations

### Day 1 (10:00 AM ET)

1. Bastion + Allen run monthly security + SLO audit
2. Uptime SLO actual vs 99.9%; MTTR distribution; dependency posture; backup restore test
3. Identify systemic patterns; post to `#acme-tech-approvals` for Jane

---

## Approval Decisions

### Features

| Effort | Cost | Approval Path |
|--------|------|--------------|
| ≤ 40h | ≤ $3K | Allen |
| > 40h | OR > $3K | Jane |

### Releases

| Kind | Approval Path |
|------|--------------|
| Standard (post-staging-QA, valid window, backup verified) | Allen |
| Major (architecture, platform migration, schema migration) | Jane |
| Hotfix (skip planning routine; still requires backup + rollback) | Allen for non-major; Jane if affecting prod schema |

### SaaS additions

| Monthly cost | Approval Path |
|--------------|--------------|
| ≤ $200/mo | Allen + CFO informed |
| > $200/mo | Jane |

### Production data / destructive ops

| Scenario | Approval Path |
|----------|--------------|
| Table drop, mass delete, destructive migration | Jane |
| Restore from backup | Allen + Jane |
| Secret rotation | Allen (Bastion executes) |

### Security risk acceptance

- Deferring a high/critical finding requires both Allen + Jane approval with documented rationale + review date.

---

## Common Failures

### Production Deploy Failed (mid-deploy)

1. Bastion automatically halts deploy attempts after 3 failures
2. Status: `deploying → failed`
3. If partial deploy: trigger rollback immediately
4. Open incident; Allen assesses severity
5. Investigate: provider error, env vars, dependency conflict, infra issue

### Auto-Rollback Triggered

1. Bastion executes rollback with stored plan
2. Verify previous deployment serving traffic
3. Open SEV-2 incident (or SEV-1 if customers were impacted during deploy)
4. Allen + Jane briefed immediately
5. Postmortem within 24h on what caused the auto-trigger

### Production Downtime

1. Bastion's auto-alert fires
2. SEV-1 if production fully down or > 50% degraded
3. Jane ping immediate
4. Triage → mitigate (often rollback) → resolve → postmortem
5. If downtime > 1h: Jane additional alert regardless of severity

### Security Breach Detected

1. Bastion opens finding immediately
2. If exploit-in-wild + high/critical CVE in our stack: incident opened
3. Jane alert immediate
4. Patch or mitigate at edge ASAP
5. Customer notification if data potentially exposed (requires Jane approval on wording)
6. Postmortem mandatory

### Friday Deploy Attempted

1. Bastion's pre-deploy check fails
2. Release stays in `approved`; surfaces to Allen for reschedule
3. Hard rule: no Friday deploys

### Marketing Campaign Conflict

1. CMO's calendar shows campaign launch within 4h
2. Bastion's pre-deploy check fails
3. Release stays in `approved`; reschedule after campaign
4. Hotfix exception: requires Allen + Jane approval

### Secret Exposed in Public Repo

1. Bastion opens finding immediately as `secret_exposure`
2. SEV-2 incident opened (or SEV-1 if production credential)
3. Rotate secret immediately (Bastion executes)
4. Audit access logs (Forge + Bastion)
5. Customer notification if data potentially exposed (requires Jane)
6. Postmortem: how did secret reach repo; preventive action

### CMS Down (Marketing blocked)

1. Forge investigates: DB, application, deploy
2. Open incident — likely SEV-2 (Marketing can't publish; not customer-facing)
3. Coordinate with CMO on Marketing schedule impact
4. Mitigate; postmortem

---

## Incident Response Workflow

### Severity Decision Tree

```
Is production fully down? → SEV-1
Is > 50% of traffic degraded? → SEV-1
Are key flows broken (checkout, booking)? → SEV-2
Is > 25% of customers affected? → SEV-2
Is partial impact / non-critical flow? → SEV-3
Is it cosmetic or internal-only? → SEV-4
```

### Response Time SLA

| SEV | First triage | First mitigation | Communication frequency |
|-----|--------------|------------------|------------------------|
| SEV-1 | < 5 min | < 15 min | Every 15 min |
| SEV-2 | < 15 min | < 1 hour | Every 30 min |
| SEV-3 | < 1 hour | < 4 hours | Hourly |
| SEV-4 | Next business day | Per priority | Daily |

### Communication

- SEV-1 + downtime > 1h: Jane direct ping (not channel)
- All severities: post to `#acme-tech-alerts`
- Cross-post incident summary to `#acme-exec-alerts` (Chief of Staff workspace) so River knows
- Customer notification: SEV-1 / downtime > 30 min / payment-affecting / data-affecting → required (idempotency key + Allen approval before send)

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "deploys_enabled": false,
  "reason": "Describe why deploys are paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-06-27T12:00:00Z"
}
```

**What stops:**

- All production deploys
- Bastion refuses deploy actions
- Pixel + Forge continue building + reviewing in dev / staging

**What continues:**

- Existing services serving traffic
- Internal dev work
- Incident response (with explicit re-arm needed for emergency-patch deploys)
- Monitoring, security scanning, ledger writes

### Resuming

```json
{
  "deploys_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "Describe why deploys are resumed",
  "resumed_by": "Your name",
  "resumed_at": "2026-06-27T14:00:00Z"
}
```

---

## Backup Strategy

- Nightly automated backup of production database (Bastion verifies)
- Weekly backup restore test to non-production environment (Bastion verifies + documents)
- Pre-deploy backup verification: every production deploy checks backup completed < 26h
- Retention: 30 days for nightly; 1 year for monthly snapshots

---

## Metrics to Track

### Uptime + Performance

- Uptime % (target: 99.9% = ≈ 43 min downtime / month)
- API p95 latency (target: < 500ms)
- Error rate (target: < 1%)
- Page load time (target: < 2s on 4G)
- Lighthouse scores (target: > 90 across performance / accessibility / SEO)

### Incident Health

- Incident count by SEV per week + month
- Median MTTR by SEV
- Postmortem-published-within-5-days rate (target: 100%)
- Corrective actions completed on time

### Release Health

- Releases shipped per week
- Rollback rate (target: < 5%)
- Friday deploys attempted (target: 0)
- Mean time from PR merged to deployed
- Deploy window violations

### Security Health

- Security findings opened vs closed by severity
- Mean time from finding-detected to patched (target: < 24h critical, < 7 days medium)
- Risk acceptance count (with documented rationale)
- Dependency posture (% deps up to date)
- SSL cert expirations within 30 days (target: 0 unaddressed)

### Engineering Health

- Tech debt principal hours
- Tech debt interest paid this quarter
- Average PR cycle time
- Test coverage
- Engineer time spent on toil vs features

### System Health

- Tech ledger integrity check
- Routine on-time rate
- Cross-team handoff completion rate
- Emergency stop activations
