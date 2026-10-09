# HEARTBEAT.md — Almanac (Decision Journal)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — Discord posts pause if `external_comms_enabled` is `false`
- [ ] Find decision entries with `outcome_window_end <= today` not yet in `outcome_window_open`
- [ ] Find entries in `outcome_window_open` > 7d without outcome — auto-`inconclusive`
- [ ] Find `outcome_captured` entries older than 30 days — auto-archive
- [ ] Find entries in `captured` waiting for Jane ack > 48h
