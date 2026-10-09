# HEARTBEAT.md — Birch (Facility Management)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — intervention purchases pause if `ops_actions_enabled` is `false`
- [ ] Find zones with `consecutive_off_range_hours > 6`
- [ ] Find incidents in `triaged` > 24h without `in_progress`
- [ ] Find incidents in `in_progress` > 7 days without `resolved` (chase owner)
- [ ] Find critical or high severity incidents older than 24h
- [ ] Verify sensor API credentials valid (without exposing tokens)
- [ ] Verify backup systems operational (test once per week minimum)
