# HEARTBEAT.md — Wade (Wholesale Sales Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outbound pauses if `sales_actions_enabled` is `false`
- [ ] Find wholesale opportunities in `negotiation` > 14 days without follow-up
- [ ] Find wholesale opportunities stalled in same stage > 30 days
- [ ] Find wholesale quotes sent > 7 days without viewed/accepted
- [ ] Find won wholesale deals > 24h without Rowan handoff
- [ ] Find wholesale leads in `received` > 24h unqualified
- [ ] Verify email + Tally + Margin API access
