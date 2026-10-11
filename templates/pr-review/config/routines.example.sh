#!/usr/bin/env bash
# PR Review Agent — Triggers and Scheduled Routines
#
# Reviews are webhook-driven: point a GitHub webhook (pull_request: opened, synchronize;
# issue_comment: created) at your runtime, verified with GITHUB_WEBHOOK_SECRET. Polling works too.
# The one scheduled routine below is a safety net. Create it in your runtime and paste the prompt.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Stale Check
# Schedule: Daily — 9:00 AM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Find reviews stuck in `reviewing` for more than 1h and mark them `failed` with
#   reason "stuck". List `failed` reviews from the last 24h in #eng-alerts with repo,
#   PR number, and reason. Never post a PR review from this routine and never approve.
#   Check config/emergency-stop.json first; post nothing if review_enabled is false.

echo "This file documents the triggers and scheduled routines for the PR Review Agent."
echo "Configure the webhook and create the routine in your agent runtime."
