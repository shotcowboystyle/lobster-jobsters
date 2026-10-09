#!/usr/bin/env bash
# ACME Bonsai Chief of Staff Team — Claude Code Routines Setup
#
# These routines run on Anthropic's cloud infrastructure via Claude Code Routines.
# They keep working even when your laptop is closed.
#
# To set up:
#   1. Go to claude.ai/code/routines (or Claude Desktop sidebar → Routines → New → Remote)
#   2. Create one routine per section below
#   3. Attach the openclaw-agents repository to each routine
#   4. Add the Discord connector to each routine
#   5. Set the schedule trigger as noted
#
# All times are Eastern (America/New_York).

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Weekly CEO Briefing
# Schedule: Weekly — Monday 7:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Heron compiles the weekly cross-team digest. Pull each executive team's
#   reported metrics from their workspace (CMO weekly report, CFO weekly,
#   COO inventory, CTO release notes, Sales pipeline, Customer Service queue,
#   Creative Director output, Contract Coordinator deal flow). Distill into
#   a single ≤400-word briefing led by the decision Jane needs to make.
#   River reviews; publish to #acme-exec-briefings.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Mid-Week Briefing
# Schedule: Weekly — Friday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Heron compiles a shorter mid-week briefing focused on this week's
#   outcomes and any blockers for next week. Same length budget.
#   River reviews; publish to #acme-exec-briefings.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Action-Item Follow-Up Sweep
# Schedule: Every 12 hours (9 AM, 9 PM ET)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Wren scans the executive ledger for open action items. For each item:
#   ping owner at +24h after deadline, +48h again, escalate to River at +72h.
#   Post a summary roll-up to #acme-exec-actions.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Agent Health Sweep
# Schedule: Every 4 hours (continuous)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Magpie polls every executive workspace under workforce/agents/.
#   For each: confirm bootstrap files exist, check last-modified time on
#   daily memory log, check emergency-stop status if applicable, scan the
#   ledger for recent _failed transitions. Post green/yellow/red snapshot
#   to #acme-exec-alerts only if status differs from previous sweep.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Strategic Initiative Status
# Schedule: Weekly — Sunday 8:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Egret refreshes the initiative dashboard. For each active initiative,
#   request the sponsor's traffic-light status. Flag initiatives unchanged
#   > 14 days. Post the dashboard to #acme-exec-initiatives.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Meeting Agenda Prep
# Schedule: Daily — 6:00 PM ET (preps next-day's meetings)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   River pulls tomorrow's meetings from Jane's calendar. For each meeting,
#   draft an agenda with attendees, objective, decisions needed, and prior
#   action items. Post draft agendas to #acme-exec-briefings for
#   Jane's approval 24h ahead of the meeting.

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Daily Health Check
# Schedule: Daily — 6:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Verify emergency-stop.json status. Check executive ledger integrity.
#   Verify all 4 sub-agents have run their last expected cycle. Verify
#   Discord bot connectivity. Report status.

echo "This file documents the 7 Claude Code Routines for the ACME Bonsai Chief of Staff team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
