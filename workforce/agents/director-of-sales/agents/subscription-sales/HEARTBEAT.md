# HEARTBEAT.md — Sophia (Subscription Sales Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outbound pauses if `sales_actions_enabled` is `false`
- [ ] Find subscriptions in `active` within 60-day renewal window without outreach started
- [ ] Find subscriptions in `renewing` > 14 days unresolved
- [ ] Find subscriptions with churn-risk signals > 7 days without Cash escalation
- [ ] Find subscriptions signed > 7 days without Cedar installation scheduling
- [ ] Find subscriptions signed > 7 days without Sterling Stripe setup
- [ ] Find subscription leads in `received` > 48h unqualified
