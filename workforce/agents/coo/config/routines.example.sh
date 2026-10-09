#!/usr/bin/env bash
# ACME Bonsai COO Team (Victor) — Claude Code Routines Setup
#
# All times are Eastern (America/New_York).

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Environmental Check
# Schedule: Daily — 6:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Birch pulls overnight environmental sensor readings (temp, humidity,
#   light, watering logs). Compares to per-species optimal ranges. Posts
#   summary to #acme-ops-drafts. Alerts in
#   #acme-ops-alerts if any reading was off-range > 6h.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Daily Inventory Reconciliation + Health Scan
# Schedule: Daily — 7:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Tally syncs the inventory sheet, recomputes reservable counts per
#   species/size, flags any item at safety threshold. Runs health scan:
#   checks last_health_check_at, computes mortality rate over trailing
#   30 days. Alerts Jane immediately in #acme-ops-alerts
#   if mortality > 2%. Posts daily summary to #acme-ops-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Daily Delivery Confirmation Sweep
# Schedule: Daily — 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Cedar identifies deliveries scheduled for the next 24h. For each
#   without a customer confirmation, sends confirmation email + SMS
#   with delivery window. Logs to #acme-ops-fulfillment.
#   Flags any unable-to-reach customer to Victor.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Daily Workshop Reminder Sweep
# Schedule: Daily — 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Hazel identifies workshops in the next 48h. For each registrant
#   without a reminder, sends reminder email + SMS. Logs to
#   #acme-ops-fulfillment. Flags any workshop under minimum
#   registration to Victor.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Weekly Route Review
# Schedule: Weekly — Monday 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Cedar pulls next week's deliveries + rental returns. Groups by
#   region, optimizes routes via Google Maps Directions. Posts proposed
#   routes to #acme-ops-drafts for Victor's review before
#   any buyer-facing communication.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Weekly Workshop Calendar Refresh
# Schedule: Weekly — Sunday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Hazel refreshes the rolling 3-month workshop calendar. Confirms
#   instructor availability for next 4 weeks. Coordinates with CMO for
#   promotion 4-6 weeks ahead. Posts updated calendar to
#   #acme-ops-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Weekly Safety Walkthrough
# Schedule: Weekly — Friday 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Birch performs structured safety walkthrough checklist. Documents
#   findings. Opens facility_incident for any item needing attention.
#   Posts summary to #acme-ops-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 8: Weekly Inventory Snapshot for CFO + Sales
# Schedule: Weekly — Friday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Tally generates a weekly inventory snapshot: counts by species/size,
#   health distribution, allocation status, mortality rate. Posts to
#   #acme-ops-drafts and provides reference for CFO weekly
#   close + Sales pipeline planning.

# ─────────────────────────────────────────────────────────────
# ROUTINE 9: Monthly Equipment Inspection
# Schedule: Monthly — Day 1 at 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Birch performs structured equipment inspection: HVAC, watering
#   systems, greenhouse fans, lights, sensors, van. Documents condition,
#   identifies items needing repair/replacement. Opens
#   facility_incident for any > $1K item; escalates to Jane in
#   #acme-ops-approvals.

echo "This file documents the 9 Claude Code Routines for the ACME Bonsai COO team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
