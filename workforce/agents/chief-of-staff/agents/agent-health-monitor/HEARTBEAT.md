# HEARTBEAT.md — Magpie (Agent Health Monitor)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `escalations_enabled` is `false`, log only
- [ ] Verify `MONITORED_WORKSPACE_ROOT` is reachable
- [ ] Verify previous sweep's snapshot was persisted
- [ ] Confirm no monitored workspace was excluded by accident
