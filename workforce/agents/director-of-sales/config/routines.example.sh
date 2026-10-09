#!/usr/bin/env bash
# ACME Bonsai Director of Sales Team (Cash) — Claude Code Routines Setup
#
# All times are Eastern (America/New_York).

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Lead Intake
# Schedule: Daily — 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   All four sub-agents pull new leads from their channels (website forms,
#   referrals, walk-ins, partner referrals, inbound emails). For each:
#   create lead row; qualify against stream-specific criteria. Post
#   summary to #acme-sales-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Daily Open Quote Follow-Up
# Schedule: Daily — 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Sub-agents identify open quotes sent > 3 days ago without buyer
#   response. Send gentle follow-up. Quotes > 7 days surface to Cash for
#   decision (nudge / extend / archive). Post summary to
#   #acme-sales-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Daily Event Booking Confirmation
# Schedule: Daily — 9:30 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Max identifies event bookings within 14 days. For each:
#   confirm inventory reserved with Tally; confirm delivery scheduled
#   with Cedar; verify rental agreement signed; verify deposit cleared.
#   Flag any gap to Cash. Post summary to #acme-sales-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Daily Subscription Renewal Scan
# Schedule: Daily — 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Sophia scans subscription contracts. For each within 60-day renewal
#   window: confirm sponsor outreach started. For each within 30-day
#   window: check renewal proposal sent. For each at risk: flag churn-risk
#   to Cash. Post summary to #acme-sales-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Daily Walk-In Follow-Up
# Schedule: Daily — 10:30 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Lily follows up with yesterday's walk-in customers who didn't buy.
#   Sends care tip + open invitation back. Identifies cross-stream
#   opportunities (subscription, event rental) and routes to
#   appropriate sub-agent.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Weekly Pipeline Review
# Schedule: Weekly — Monday 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Cash compiles weighted pipeline across all four streams. Computes
#   forecast for current week + month + quarter. Identifies stalled
#   opportunities > 30 days. Posts to #acme-sales-pipeline
#   for Jane review.

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Weekly Wholesale Pipeline Nudge
# Schedule: Weekly — Monday 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Wade nudges every wholesale opportunity in negotiation > 14 days.
#   For each: tailored follow-up referencing prior touch. Stalled > 30
#   days escalate to Cash for strategy reset.

# ─────────────────────────────────────────────────────────────
# ROUTINE 8: Weekly Subscription Renewal Outreach
# Schedule: Weekly — Monday 11:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Sophia opens renewal sponsor outreach for any subscription within
#   60 days of expiration. Drafts personalized renewal proposal for
#   Cash review. Flags any churn-risk contract for Cash + Jane.

# ─────────────────────────────────────────────────────────────
# ROUTINE 9: Weekly Revenue + Pipeline Report
# Schedule: Weekly — Friday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Cash compiles weekly revenue + pipeline report: closed deals by
#   stream, weighted pipeline, conversion rate by stage, churn this
#   week, top wins/losses. Posts to #acme-sales-pipeline.
#   Cross-posts summary to Sterling (CFO) for weekly close.

# ─────────────────────────────────────────────────────────────
# ROUTINE 10: Monthly Cohort + LTV Refresh
# Schedule: Monthly — Day 1 at 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Cash refreshes customer cohort analysis: cohort revenue by month,
#   subscription churn cohorts, wholesale repeat-buyer rate, event
#   client cross-stream conversion. Updates LTV estimates per stream.
#   Posts findings to #acme-sales-pipeline.

echo "This file documents the 10 Claude Code Routines for the ACME Bonsai Director of Sales team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
