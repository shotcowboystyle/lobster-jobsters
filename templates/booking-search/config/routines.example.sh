#!/usr/bin/env bash
# Booking Search Agent — Scheduled Routines
#
# This agent is on-demand: searches run only when a user asks. Nothing searches on a schedule.
# The one routine below is a usage check. Create it in your runtime and paste the prompt verbatim.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Usage Check
# Schedule: Daily — 9:00 AM
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Count yesterday's searches by status (answered, no_results, blocked, failed)
#   and the peak searches in any hour vs hourly_search_cap. Post one line to
#   #search-alerts. Do not run any search. If any search was blocked, say so and
#   remind the owner that blocks are waited out, never bypassed.

echo "This file documents the scheduled routines for the Booking Search Agent."
echo "Create each routine in your agent runtime's scheduler and paste the prompt text."
