# HEARTBEAT.md

# Periodic checks for the ACME Bonsai Director of Sales team (Cash).
# Keep items minimal — heartbeat is for noticing problems, not doing work.

- [ ] Check `config/emergency-stop.json` — if `sales_actions_enabled` is `false`, queue outbound actions locally
- [ ] Check open quotes > 7 days without buyer response
- [ ] Check opportunities in `negotiation` > 30 days (stalled)
- [ ] Check subscription contracts within 60-day renewal window without sponsor outreach
- [ ] Check subscription contracts in `renewing` > 14 days unresolved
- [ ] Check event bookings within 14 days without confirmed inventory + delivery
- [ ] Check rental deposits unpaid past quote acceptance > 48h
- [ ] Check pipeline forecast vs trailing 4-week actuals — alert if variance > 15%
- [ ] Check leads in `received` > 24h unqualified
