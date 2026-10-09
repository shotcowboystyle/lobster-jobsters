#!/usr/bin/env bash
# ACME Bonsai CEO Team (Apex) — Claude Code Routines Setup
#
# These routines run on Anthropic's cloud infrastructure via Claude Code Routines.
# They keep working even when your laptop is closed.
#
# All times are Eastern (America/New_York).
#
# Note: Apex's workspace is deliberately *quiet*. Most CEO work happens in
# Jane-driven sessions, not on cron. These routines exist only to surface
# patterns and prompt outcome capture — they never produce outbound work.

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Weekly Strategic Question
# Schedule: Weekly — Sunday 9:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Compass reads every operating team's ledger from the past 7 days.
#   Identifies one strategic pattern, drift, or second-order effect.
#   Frames it as a single trade-off question (≤200 words) and posts to
#   #acme-ceo-strategy. Jane answers when ready — no SLA.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Daily Decision Capture Sweep
# Schedule: Daily — 6:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Almanac scans today's session transcripts (Apex's daily logs + the
#   exec ledger transitions where source_team includes 'ceo'). For any
#   meaningful decision that isn't already journaled, drafts a decision
#   entry and posts to #acme-ceo-decisions for Jane's ack.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Outcome Window Check
# Schedule: Daily — 6:15 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Almanac scans decision entries with outcome_window_end <= today.
#   For each, opens the entry for Jane to record the actual outcome
#   and a one-line reflection. If Jane records, transition to
#   outcome_captured. If 7 days pass with no record, transition to
#   outcome_inconclusive.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Stale Memo / Comm Sweep
# Schedule: Daily — 7:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Apex flags Atlas memos stuck in ceo_review > 72h and Envoy comms
#   stuck in ceo_review > 24h. Posts a single roll-up to
#   #acme-ceo-alerts. Never auto-progresses; Jane decides.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Decision Pattern Surfacing
# Schedule: Weekly — Sunday 9:30 PM ET (after Compass)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Almanac scans the past 90 days of decision entries. Flags recurring
#   decision types (same question pattern multiple times) and recurring
#   trade-offs. Posts a brief pattern note to #acme-ceo-strategy
#   as supplemental context for the week's strategic question.

# Note: NO routines for Atlas memo drafting or Envoy external comms.
# Both are exclusively on-demand from Jane.

echo "This file documents the 5 Claude Code Routines for the ACME Bonsai CEO team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
