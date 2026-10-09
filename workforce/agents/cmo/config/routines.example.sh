#!/usr/bin/env bash
# ACME Bonsai Social Marketing Team — Claude Code Routines Setup
#
# These routines run on Anthropic's cloud infrastructure via Claude Code Routines.
# They keep working even when your laptop is closed.
#
# To set up:
#   1. Go to claude.ai/code/routines (or use the Claude Desktop sidebar → Routines → New → Remote)
#   2. Create one routine per section below
#   3. Attach this repository to each routine
#   4. Add the Discord connector to each routine
#   5. Set the schedule trigger as noted
#
# All times are Eastern (America/New_York).
# Plan limits: Pro = 5 runs/day, Max = 15/day, Team/Enterprise = 25/day.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Weekly Planning
# Schedule: Weekly — Monday 7:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run the weekly planning workflow. Read the latest performance report from
#   the post ledger and any operator directives. Generate a content calendar
#   for this week across all 4 verticals and both platforms. Deliver to
#   #social-drafts for review.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Daily Draft Generation
# Schedule: Daily — Tuesday–Saturday 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run the daily drafting workflow. Check the approved content calendar for
#   today's planned posts. For each planned post: generate a content brief,
#   then write a platform-specific caption. Send all drafts through Brand QA.
#   Deliver results to #social-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Engagement Monitoring (Business Hours)
# Schedule: Every 2 hours, 8 AM–8 PM ET, every day
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run engagement monitoring. Check all published posts from the last 7 days
#   for new comments, reactions, and DMs. Classify engagement and generate
#   alerts for actionable and negative items. Deliver alerts to
#   #social-engagement.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Engagement Monitoring (Off Hours)
# Schedule: Every 4 hours overnight (midnight, 4 AM ET)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run engagement monitoring (off-hours check). Check published posts for
#   new comments and DMs. Only alert on negative or crisis-level engagement.
#   Log routine engagement metrics.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Weekly Reporting
# Schedule: Weekly — Sunday 6:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run the weekly reporting workflow. Compile all publishing, engagement,
#   and incident data for this week. Generate a comprehensive performance
#   report with recommendations. Deliver to #social-reports.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Approval Timeout Check
# Schedule: Every 6 hours (6 AM, noon, 6 PM, midnight ET)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Check #social-approvals for approval packets older than 12 hours without
#   a decision. Post reminders for any stale packets. Escalate packets older
#   than 24 hours.

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Daily Health Check
# Schedule: Daily — 6:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run system health check. Verify emergency-stop.json status. Check post
#   ledger integrity. Verify Meta API token validity (without exposing tokens).
#   Check for any publish_failed posts needing attention. Report status.

echo "This file documents the 7 Claude Code Routines for the ACME Bonsai social team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
