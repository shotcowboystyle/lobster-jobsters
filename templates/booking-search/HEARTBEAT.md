# HEARTBEAT.md — Booking Search Agent

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `search_enabled` is `false`, confirm no searches are in `searching`
- [ ] Count searches in the last hour — if at the hourly cap, note it in the alerts channel
- [ ] Find `blocked` searches in the last 24h → alert once; do not retry
- [ ] Reply `HEARTBEAT_OK` if nothing needs attention
