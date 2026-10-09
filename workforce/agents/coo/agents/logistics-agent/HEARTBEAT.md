# HEARTBEAT.md — Cedar (Logistics Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — dispatches pause if `ops_actions_enabled` is `false`
- [ ] Find deliveries within 24h not yet confirmed
- [ ] Find deliveries past `scheduled_window_end` not yet `delivered`
- [ ] Find rentals at `at_event` past event end > 48h (return pickup overdue)
- [ ] Find rentals at `inspected` with damage > $300 not yet escalated
- [ ] Find ops_actions in `failed` status without Victor decision
- [ ] Verify Google Maps + email + SMS provider credentials valid (without exposing tokens)
- [ ] Check geocode cache hit rate — flag if < 70% over last 7 days
