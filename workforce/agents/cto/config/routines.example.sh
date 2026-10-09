#!/usr/bin/env bash
# ACME Bonsai CTO Team (Allen) — Claude Code Routines Setup
#
# All times are Eastern (America/New_York).

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Infra Health Check
# Schedule: Daily — 6:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Bastion pulls uptime + p95 latency + error rate from Sentry + Better
#   Uptime. Verifies DNS, SSL certs (alert if expiring < 30 days), backup
#   last-run timestamp (alert if > 26h), and CDN cache hit rate. Posts
#   summary to #acme-tech-drafts. Alerts in
#   #acme-tech-alerts on any breach.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Daily Security + Dependency Scan
# Schedule: Daily — 7:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Bastion runs dependency vulnerability scan (npm audit / pip audit /
#   GitHub Dependabot). Identifies new high/critical findings. Opens
#   security_finding row for each. Posts summary to
#   #acme-tech-drafts. Alerts in #acme-tech-alerts
#   on high/critical findings.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Daily Backend Health Check
# Schedule: Daily — 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Forge verifies DB connection pool health, slow query log (queries
#   > 1s), API endpoint p50/p95/p99 latency, Stripe webhook delivery
#   rate, background job queue depth. Posts summary to
#   #acme-tech-drafts. Alerts in #acme-tech-alerts
#   on degradation.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Daily Feature Intake Triage
# Schedule: Daily — 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Allen reviews new feature requests in `intake` from yesterday.
#   For each: classify (frontend / backend / infra / full-stack),
#   estimate effort + cost, identify Jane-approval items (> 40h
#   or > $3K). Posts triaged list to #acme-tech-drafts.
#   Posts Jane-approval items to #acme-tech-approvals.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Weekly Tech Debt Review
# Schedule: Weekly — Monday 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Allen reviews tech_debt_entries with status `logged` or `deferred`.
#   For each: confirm/update interest rate (cost of carrying debt),
#   decide schedule for this quarter / defer with rationale / drop.
#   Posts updated debt register to #acme-tech-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Weekly Release Planning
# Schedule: Weekly — Monday 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Allen + Bastion plan releases for the next 7 days. For each:
#   verify staging QA pass, backup plan, rollback plan, deploy window
#   (NOT Friday, NOT before Marketing campaigns). Posts release plan
#   to #acme-tech-releases.

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Weekly Platform Report
# Schedule: Weekly — Friday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Allen compiles weekly report: uptime % vs target (99.9%),
#   incidents this week + MTTR, releases shipped, top 3 tech-debt
#   items, security findings closed, performance trend. Posts to
#   #acme-tech-drafts; cross-posts to Sterling (CFO) for
#   weekly close.

# ─────────────────────────────────────────────────────────────
# ROUTINE 8: Monthly Security + SLO Audit
# Schedule: Monthly — Day 1 at 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Bastion + Allen review past month: uptime SLO actual vs 99.9%,
#   security findings opened vs closed, MTTR distribution per
#   incident severity, dependency posture, SSL cert expirations,
#   backup restore test results. Identify systemic patterns. Posts
#   to #acme-tech-approvals for Jane review.

echo "This file documents the 8 Claude Code Routines for the ACME Bonsai CTO team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
