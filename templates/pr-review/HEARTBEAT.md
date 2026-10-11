# HEARTBEAT.md — PR Review Agent

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `review_enabled` is `false`, confirm nothing is queued to post
- [ ] Find reviews stuck in `reviewing` > 1h → mark `failed` with reason, alert
- [ ] Find `failed` reviews in the last 24h needing a retry or an alert
- [ ] Reply `HEARTBEAT_OK` if nothing needs attention
