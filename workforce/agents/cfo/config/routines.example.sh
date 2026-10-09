#!/usr/bin/env bash
# ACME Bonsai CFO Team (Sterling) — Claude Code Routines Setup
#
# All times are Eastern (America/New_York).

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Reconciliation
# Schedule: Daily — 7:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Ledger reconciles bank + accounting system for yesterday's activity.
#   Posts a daily reconciliation summary to #acme-finance-drafts.
#   Flags any unmatched lines for Sterling's review.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: AR Aging Sweep
# Schedule: Daily — 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Ledger generates an AR aging report. Sends gentle reminders for
#   invoices 7+ days past due, escalates 30+ days past due to Sterling
#   in #acme-finance-approvals.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Daily Compliance Check
# Schedule: Daily — 7:30 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Garrison scans the compliance-deadline tracker. Flags any deadline
#   within 14 days as due_soon. Posts a daily summary to
#   #acme-finance-drafts. Escalates undocumented exceptions
#   > 24h to Sterling.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Weekly Cash + Runway Refresh
# Schedule: Weekly — Monday 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Horizon pulls cash position from banking + AR + AP forecast.
#   Refreshes the 13-week cash model. Computes runway. Posts to
#   #acme-finance-reports. If runway < 90 days, alerts
#   Jane in #acme-finance-alerts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Weekly Margin Snapshot
# Schedule: Weekly — Monday 10:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Margin computes gross margin per channel (retail / wholesale /
#   subscription / event rental / workshops). Flags any channel below
#   floor or trending down > 2 weeks. Posts to
#   #acme-finance-reports.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Weekly Exception Audit
# Schedule: Weekly — Friday 4:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Garrison reviews the week's exceptions (discounts, refunds, write-offs,
#   off-policy spend). Posts a roll-up to #acme-finance-reports
#   with owner attribution. Escalates material items to Sterling.

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Monthly Close Kickoff
# Schedule: Monthly — Day 1 at 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Ledger opens the monthly close package, lists tasks, assigns owners.
#   Posts opening checklist to #acme-finance-drafts. Close
#   target: Day 5 by 6 PM ET.

# ─────────────────────────────────────────────────────────────
# ROUTINE 8: Monthly Forecast Refresh
# Schedule: Monthly — Day 6 at 9:00 AM ET (after close)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Horizon refreshes the monthly forecast using the just-closed actuals.
#   Updates 13-week cash, full-year P&L projection, runway. Posts draft
#   to #acme-finance-drafts for Sterling's review.

# ─────────────────────────────────────────────────────────────
# ROUTINE 9: Quarterly Re-Forecast
# Schedule: Quarterly — First Monday at 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Horizon produces the quarterly re-forecast: revised annual P&L,
#   capital allocation review, scenario set (base / upside / downside).
#   Sterling reviews before posting to Jane in
#   #acme-finance-approvals.

echo "This file documents the 9 Claude Code Routines for the ACME Bonsai CFO team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
