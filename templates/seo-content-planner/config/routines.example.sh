#!/usr/bin/env bash
# SEO Content Planner — Scheduled Routines
#
# Each block documents one routine (OpenClaw cron / Claude Code Routine). Times are in
# briefing_timezone from USER.md. Create each routine in your runtime and paste the prompt verbatim.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Weekly SEO Briefing
# Schedule: Weekly — Monday 9:00 AM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run the Weekly briefing workflow in AGENTS.md: last 7 days vs prior 7 from
#   Search Console and GA4. Post three opportunities (rank 6-20, rising impressions,
#   content gap), one risk, and one win to #seo-briefings. Never invent data;
#   say so if a source returned nothing. Check config/emergency-stop.json first;
#   draft-only if planner_enabled is false.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Brief Review Reminder
# Schedule: Daily — 3:00 PM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Find briefs in user_review for more than 72h. Post one reminder per brief in
#   #seo-drafts. Never confirm a brief or write a calendar card on the user's behalf.

echo "This file documents the scheduled routines for the SEO Content Planner."
echo "Create each routine in your agent runtime's scheduler and paste the prompt text."
