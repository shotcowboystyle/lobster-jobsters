# ACME Bonsai Creative Director Team (Masahiko) — Operations Runbook

## Overview

This runbook covers daily, weekly, and monthly operations for the ACME Bonsai creative team — Masahiko (Creative Director), Hana (Brand Designer), Iris (Photography), Mira (Educational Content).

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check `#acme-creative-alerts` for overnight brand drift / missed deadlines / off-brand publications
2. Review brief intake triage (Masahiko, 9 AM)
3. Review daily photography production status (Iris, 10 AM)
4. Review brand asset drift scan (Hana, 11 AM)

### Throughout the Day

1. Deliverables surface in `#acme-creative-drafts` for Masahiko review
2. Photo proofs surface for review
3. Care guide drafts route through technical review then to Masahiko
4. Brand drift findings route through Hana → Masahiko
5. Masahiko escalates above-threshold items to Jane

### Evening (6:00 PM ET)

1. Day-end check on deliverables awaiting review
2. Note tomorrow's must-confirm photo shoots
3. Verify next-morning routines armed

---

## Weekly Operations

### Monday Morning

1. **10:00 AM**: Hana runs weekly asset library audit
2. **11:00 AM**: Masahiko runs production capacity review; escalates conflicts to Jane

### Friday Afternoon

1. **4:00 PM**: Masahiko runs weekly creative output report; cross-posts summary to CMO + DoS + Jane

---

## Monthly Operations

### Day 1 (10:00 AM ET)

1. Masahiko + Hana run comprehensive brand consistency audit across all touchpoints (website, social, email, packaging, signage, catalogs, presentations)
2. Identify systemic drift
3. Report findings to `#acme-creative-approvals` for Jane

---

## Approval Decisions

### Deliverables

| Scenario | Approval Path |
|----------|--------------|
| Standard deliverable | Masahiko |
| Off-brand attempt | Masahiko (typically reject; escalate if requester insists) |
| Custom branding for specific buyer | Jane (may require brand-system update) |

### Photo shoots

| Scenario | Approval Path |
|----------|--------------|
| Standard inventory shoot | Iris executes; Masahiko reviews proofs |
| Customer venue / event | Iris obtains release (Masahiko approves request wording) |
| Lifestyle shoot with models | Jane approves model arrangement; releases via Iris |

### Care guides

| Scenario | Approval Path |
|----------|--------------|
| Standard care guide | Care Education technical review → Masahiko brand review |
| New species not previously covered | Care Education (with subject matter expert if needed) → Masahiko |

### Creative projects

| Scenario | Approval Path |
|----------|--------------|
| ≤ $2,000 budget | Masahiko |
| > $2,000 budget | Jane |
| Rebranding / identity change | Jane |

### Brand system updates

| Scope | Approval Path |
|-------|--------------|
| Minor adjustment | Masahiko |
| Addition / major change / rebranding | Masahiko + Jane |

---

## Common Failures

### Brand Drift on Published Content

1. Hana's daily drift scan flags off-brand element
2. Severity classification (low / medium / high)
3. Low: open revision task for next-touch update
4. Medium: contact publisher team for fix within 48h
5. High: open hotfix; escalate to Masahiko + Jane if rebrand-level

### Off-Brand Publication by Cross-Team

1. Masahiko flags in `#acme-creative-alerts`
2. Coordinate with publisher team for takedown if customer-facing
3. Document in revision_cycle ledger entry
4. If recurring: propose brand-system clarification

### Missed Deadline

1. Owner flags before deadline arrives
2. Masahiko renegotiates with requester OR pulls from production capacity
3. If endemic: production capacity review escalation to Jane

### Photo Release Missing for Scheduled Shoot

1. Iris cannot dispatch
2. Reschedule or cancel
3. If customer cannot or will not sign: cancel; refund any deposit (Sterling); document for future-shoot policy

### Care Guide Technical Review Rejected

1. Care Education identifies factual error or unverified claim
2. Mira corrects; resubmits
3. If subject matter outside Care Education expertise: route to external expert (Jane approves engagement)

### Brand System Drift Over Time

1. Monthly consistency audit identifies systemic drift
2. Masahiko proposes brand-system update OR retrofit campaign
3. Jane approves; implementation across affected touchpoints scheduled

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single off-palette pixel on social, minor typo (caught pre-publish) | Next business day |
| Medium | Off-brand publication caught within 24h, brand drift accumulating | Within 4 hours |
| High | Off-brand publication going viral, IP/copyright issue, large-budget project failure | Within 1 hour |
| Critical | Customer photo published without release, misleading tree photo published, rebrand crisis | Immediately |

### Incident Steps

1. Assess severity
2. If critical: takedown immediately if possible; legal flag if IP issue
3. Investigate root cause
4. Resolve or escalate to Jane
5. Log incident outcome
6. Post resolution to `#acme-creative-alerts`

---

## Emergency Stop

### Activating

Edit `config/emergency-stop.json`:

```json
{
  "publish_assets_enabled": false,
  "reason": "Describe why publication is paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-06-28T12:00:00Z"
}
```

**What stops:**

- All asset publication (web, social, email)
- Care guide publication
- Outbound photo release requests

**What continues:**

- Capture + edit
- Drafting
- Library archive
- Ledger writes
- Internal review

### Resuming

```json
{
  "publish_assets_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "Describe why publication is resumed",
  "resumed_by": "Your name",
  "resumed_at": "2026-06-28T14:00:00Z"
}
```

---

## Metrics to Track

### Production Output

- Deliverables delivered per week by kind
- Photo shoots completed per week
- Care guides published per quarter
- Average time-from-brief-intake to delivered
- Revision rounds per deliverable (target: ≤ 2)

### Brand Health

- Brand drift incidents per month (target: trending down)
- Asset library size and growth rate
- Coverage: % of active inventory with current photography
- Care guide library: % of common care topics covered
- Touchpoint consistency score (monthly audit)

### Team Capacity

- Hana / Iris / Mira utilization (target: 80-90%)
- Backlogged briefs > 7 days old
- Rejected briefs and reasons
- Jane-escalation rate

### System Health

- Creative ledger integrity check
- Asset library hygiene (duplicates, missing metadata)
- DocuSign release agreement turnaround
- Routine on-time rate
- Emergency stop activations
