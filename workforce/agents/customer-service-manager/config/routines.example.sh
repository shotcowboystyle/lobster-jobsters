#!/usr/bin/env bash
# ACME Bonsai Customer Service Manager Team (Poppy) — Claude Code Routines Setup
#
# All times are Eastern (America/New_York).

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Ticket Intake Triage
# Schedule: Daily — 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Pearl pulls new tickets from email, SMS, chat, social, phone log
#   since last sweep. For each: classify (general / order / care);
#   apply category tags; route to specialist (Oakley for orders;
#   Maple for care; Pearl resolves general); send first response
#   within 2h SLA. Posts daily summary to #acme-care-tickets.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Daily Order Issue Sweep
# Schedule: Daily — 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Oakley sweeps open order issues. Pulls delivery status from Cedar
#   (COO); pulls wholesale contract status from Rowan (Contract
#   Coordinator); pulls billing from Sterling (CFO). For each open
#   issue: investigate, propose resolution, communicate proactively.
#   Posts summary to #acme-care-tickets.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Daily Care Consultation Follow-Ups
# Schedule: Daily — 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Maple reviews care consultations with follow-up dates today or
#   past. For each: send check-in (idempotency key); record response
#   if received. Identifies any species pattern (3+ customers same
#   species + same symptom) and flags to Tally (COO Inventory) and
#   Poppy. Posts summary to #acme-care-tickets.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Daily Proactive Customer Health Check
# Schedule: Daily — 11:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Poppy scans customer accounts (via DoS sales ledger):
#   - Subscriptions with CSAT dropping > 0.5 points
#   - Subscriptions with no activity > 30 days
#   - Wholesale buyers with overdue feedback
#   - Recent purchasers > 14 days post-delivery without care check-in
#   For each at-risk: open health_check_in. For major accounts at risk:
#   alert in #acme-care-alerts; brief Jane.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Weekly Trending Issues Analysis
# Schedule: Weekly — Monday 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Poppy reviews last 7 days of tickets + order issues + care
#   consultations. Identifies trending categories, root causes,
#   patterns affecting multiple customers. Posts analysis to
#   #acme-care-tickets. Escalates pattern-issues to Jane
#   in #acme-care-approvals with proposed corrective action
#   and operating team owner.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Weekly Customer Health Report
# Schedule: Weekly — Friday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Poppy compiles weekly customer health report: tickets opened +
#   resolved, CSAT trend, top 3 patterns, churn risks, success stories,
#   recommendation. Posts to #acme-care-tickets; cross-posts
#   summary to Jane + CMO + Director of Sales.

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Monthly Voice-of-Customer Report
# Schedule: Monthly — Day 1 at 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Poppy compiles voice-of-customer report: themes from customer
#   feedback this month; product / operational / service gaps; bright
#   spots; recommended operational changes. Posts to
#   #acme-care-approvals for Jane + operating teams.

echo "This file documents the 7 Claude Code Routines for the ACME Bonsai Customer Service Manager team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
