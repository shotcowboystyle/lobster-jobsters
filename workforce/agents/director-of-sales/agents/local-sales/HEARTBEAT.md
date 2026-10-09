# HEARTBEAT.md — Lily (Local Sales Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outbound follow-ups pause if `sales_actions_enabled` is `false`
- [ ] Find purchasers from past 24h missing care guidance
- [ ] Find local sales in `recommended` > 7 days without purchase or no_purchase decision
- [ ] Find cross-stream opportunities identified > 48h without routing
- [ ] Find local leads in `received` > 48h unqualified
- [ ] Verify Stripe + email + Tally API access
