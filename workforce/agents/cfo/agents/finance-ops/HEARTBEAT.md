# HEARTBEAT.md — Ledger (Finance Operations)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — pause invoice / refund / vendor payment sends if `finance_actions_enabled` is `false`
- [ ] Reconcile bank + accounting balances for prior day
- [ ] Find AR invoices > 30 days past due
- [ ] Find AP bills due in < 3 days that aren't scheduled
- [ ] Find finance_actions in `failed` status without Sterling decision
- [ ] Find monthly close in `cfo_review` past Day 4
- [ ] Verify accounting + banking + Stripe API credentials valid (without exposing tokens)
