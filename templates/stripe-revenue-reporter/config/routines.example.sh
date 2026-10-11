#!/usr/bin/env bash
# Stripe Revenue Reporter — Scheduled Routines
#
# Each block documents one routine (OpenClaw cron / Claude Code Routine). Times are in
# digest_timezone from USER.md. Create each routine in your runtime and paste the prompt verbatim.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Revenue Digest
# Schedule: Daily — 9:00 AM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run the Daily Workflow in AGENTS.md for yesterday. Use read-only Stripe queries
#   only. If any query errors or returns partial data, skip the digest and post the
#   Partial Data notice to #revenue-alerts. Skip if this period is already posted.
#   No card digits, no full emails, nothing cached.
#   Check config/emergency-stop.json first; draft-only if digest_enabled is false.

echo "This file documents the scheduled routines for the Stripe Revenue Reporter."
echo "Create each routine in your agent runtime's scheduler and paste the prompt text."
