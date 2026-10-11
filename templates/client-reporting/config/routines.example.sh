#!/usr/bin/env bash
# Client Reporting Agent — Scheduled Routines
#
# Each block documents one routine (OpenClaw cron / Claude Code Routine). Times are in
# report_timezone from USER.md. Create each routine in your runtime and paste the prompt verbatim.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Weekly Client Reports
# Schedule: Weekly — Monday 8:00 AM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run the Weekly Workflow in AGENTS.md for every client in USER.md, one client
#   at a time, with that client's credentials only. Post each draft to the client's AM
#   thread and record it as am_review. Skip clients whose draft for this week
#   already exists. Finish with the Run Summary in #reporting-alerts.
#   Check config/emergency-stop.json first; draft-only if reporting_enabled is false.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: AM Review Reminder
# Schedule: Daily — 3:00 PM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Find report_drafts in am_review for more than 48h. Post one reminder in each
#   client's thread mentioning the AM. Never mark anything sent and never auto-approve.

echo "This file documents the scheduled routines for the Client Reporting Agent."
echo "Create each routine in your agent runtime's scheduler and paste the prompt text."
