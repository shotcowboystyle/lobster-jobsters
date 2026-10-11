#!/usr/bin/env bash
# Zendesk Triage Agent — Scheduled Routines
#
# Per-ticket triage runs from the Zendesk ticket.created / ticket.updated webhook, not a schedule.
# Each block below documents one routine (OpenClaw cron / Claude Code Routine). Times are in
# summary_timezone from USER.md. Create each routine in your runtime and paste the prompt verbatim.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Queue Summary
# Schedule: Daily — 9:00 AM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run the Daily Summary in AGENTS.md: tickets created or updated in the last
#   24h, breakdown by priority, oldest open ticket, top three categories, and
#   triage failures. Post it to #support-leads using the Daily Summary template.
#   Check config/emergency-stop.json first; if triage_enabled is false, post only
#   the stop notice.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Failed Triage Sweep
# Schedule: Hourly
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Find triage_records in failed or held. Retry failed ones whose attempt < 2 with
#   a fresh idempotency key; alert in #triage-alerts for the rest. Never close,
#   assign, or reply to a ticket.

echo "This file documents the scheduled routines for the Zendesk Triage Agent."
echo "Create each routine in your agent runtime's scheduler and paste the prompt text."
