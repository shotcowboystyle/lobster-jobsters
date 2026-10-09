# HEARTBEAT.md — Max (Event Rental Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outbound pauses if `sales_actions_enabled` is `false`
- [ ] Find event bookings with `event_date` within 14 days not in `confirmed`
- [ ] Find event bookings in `quoted` with deposit unpaid > 48h after quote acceptance
- [ ] Find event bookings in `quoted` with rental agreement unsigned > 48h
- [ ] Find event bookings within 7 days without day-before walkthrough check sent
- [ ] Find event bookings in `returned` > 7 days not yet `closed` (Cedar's reconciliation pending)
- [ ] Find post-event opportunities > 14 days without cross-stream routing
- [ ] Find event rental leads in `received` > 48h unqualified
