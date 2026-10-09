# HEARTBEAT.md — Oakley (Order Management Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outbound + execution queues if `outbound_replies_enabled` is `false`
- [ ] Find order issues in `investigating` > 24h without resolution proposal
- [ ] Find resolution_proposed > 48h without customer acceptance
- [ ] Find refunds in `csm_approved` not yet processed > 24h
- [ ] Find refunds in `ceo_approval_required` > 48h without decision
- [ ] Find pattern: ≥ 3 same `kind` in last 7 days not yet routed to operating team
- [ ] Find Stripe webhooks unacknowledged > 1h
- [ ] Verify cross-team ledger access (Cedar, Rowan, Sophia, Sterling)
