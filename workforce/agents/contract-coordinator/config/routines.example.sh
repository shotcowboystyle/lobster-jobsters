#!/usr/bin/env bash
# ACME Bonsai Contract Coordinator Team — Claude Code Routines Setup
#
# These routines run on Anthropic's cloud infrastructure via Claude Code Routines.
# They keep working even when your laptop is closed.
#
# To set up:
#   1. Go to claude.ai/code/routines (or use the Claude Desktop sidebar → Routines → New → Remote)
#   2. Create one routine per section below
#   3. Attach the openclaw-agents repository to each routine
#   4. Add the Discord connector to each routine
#   5. Set the schedule trigger as noted
#
# All times are Eastern (America/New_York).

# ─────────────────────────────────────────────────────────────
# ROUTINE 1: Daily Signature Sweep
# Schedule: Daily — 8:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run Sage's signature-status sweep. For every DocuSign envelope in
#   `contract_sent` state, poll the envelope status. Send reminder emails for
#   envelopes pending > 48h (first reminder) and > 5 days (escalate to Jane).
#   Log all transitions to the contract ledger. Report a summary to
#   #acme-contracts-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 2: Daily Payment Reconciliation
# Schedule: Daily — 8:30 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run Finch's payment reconciliation. Pull Stripe + ACH webhook events from
#   the last 24h. For every confirmed payment, transition the contract from
#   `deposit_invoiced` → `deposit_paid` (or `balance_paid` if applicable).
#   For every failed payment, flag in #acme-contracts-alerts.
#   Report a summary to #acme-contracts-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 3: Daily Inventory Snapshot
# Schedule: Daily — 9:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run Grove's inventory snapshot. Sync the inventory sheet, recompute
#   reserved-vs-available counts per species/size, and flag any item at or
#   below safety threshold in #acme-contracts-alerts. Report a
#   summary to #acme-contracts-drafts.

# ─────────────────────────────────────────────────────────────
# ROUTINE 4: Weekly Route Planning
# Schedule: Weekly — Sunday 5:00 PM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run Miles' weekly route planning. For every contract in `inventory_reserved`
#   with a delivery date inside the next 14 days, group by region and propose
#   one or more van routes. Deliver to #acme-contracts-delivery for
#   Coordinator review before any buyer email goes out.

# ─────────────────────────────────────────────────────────────
# ROUTINE 5: Balance-Due Notice Sweep
# Schedule: Daily — 9:30 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run Finch's balance-due sweep. For every contract with a scheduled
#   delivery date 7 days out and balance still unpaid, draft a balance-due
#   notice and post to #acme-contracts-drafts for Coordinator review
#   before send.

# ─────────────────────────────────────────────────────────────
# ROUTINE 6: Stalled Deal Triage
# Schedule: Every 12 hours (8 AM, 8 PM ET)
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Scan the contract ledger for contracts that have been in the same state
#   for > 72 hours. Post a stalled-deal summary to #acme-contracts-alerts
#   with recommended next action per contract (nudge buyer, escalate to Jane,
#   release inventory, etc.).

# ─────────────────────────────────────────────────────────────
# ROUTINE 7: Daily Health Check
# Schedule: Daily — 6:00 AM ET
# ─────────────────────────────────────────────────────────────
# Prompt:
#   Run system health check. Verify emergency-stop.json status. Check contract
#   ledger integrity. Verify DocuSign + Stripe + Google Maps token validity
#   (without exposing tokens). Check for stalled deals and unacknowledged
#   escalations. Report status.

echo "This file documents the 7 Claude Code Routines for the ACME Bonsai Contract Coordinator team."
echo "Create each routine at: claude.ai/code/routines"
echo "Or in Claude Desktop: Sidebar → Routines → New → Remote"
