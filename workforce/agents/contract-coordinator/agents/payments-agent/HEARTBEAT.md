# HEARTBEAT.md — Finch (Payments Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `contracts_enabled` is `false`, do not issue invoices
- [ ] Reconcile Stripe + ACH webhook events from the last 24h against ledger entries
- [ ] Flag any `deposit_invoiced` invoice > 72h unpaid for Coordinator nudge
- [ ] Flag any `delivered` contract with `balance_paid` not transitioned within 48h
- [ ] Verify Stripe webhook signing secret is current
- [ ] Confirm sum of `payments.amount_usd paid` matches `contracts.deposit_usd + balance_usd` for every `closed` contract
