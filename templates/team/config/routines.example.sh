#!/usr/bin/env bash
# {{COMPANY}} {{TEAM_NAME}} Team ({{PERSONA}}) — Scheduled Routines
#
# Each block documents one routine (OpenClaw cron / Claude Code Routine). All times America/New_York.
# Create each routine in your runtime and paste the prompt verbatim.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Intake Triage
# Schedule: Daily — 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   {{PERSONA}} reviews new work items in `intake` since yesterday. For each:
#   classify, estimate effort, identify items above the approval threshold.
#   Posts the triaged list to #{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-drafts and
#   threshold items to #{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-approvals.
#   Check config/emergency-stop.json first; draft-only if {{FLAG}} is false.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Approval Timeout Sweep
# Schedule: Daily — 3:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   {{PERSONA}} finds items in `review` older than 24h. Posts one reminder per
#   item to #{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-approvals. Items older than 48h
#   move to `held` with reason "approval timeout" — never auto-approve.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Weekly Team Report
# Schedule: Weekly — Friday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   {{PERSONA}} compiles: items executed this week, items held/rejected and why,
#   execution failures + retries, time-in-review trend (scripts/ledger.sh metrics),
#   top 3 risks for next week. ≤ 400 words. Posts to
#   #{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-drafts; cross-posts summary to River (Chief of Staff).

echo "This file documents the scheduled routines for the {{COMPANY}} {{TEAM_NAME}} team."
echo "Create each routine in your agent runtime's scheduler and paste the prompt text."
