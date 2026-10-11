# HEARTBEAT.md — Client Reporting Agent

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `reporting_enabled` is `false`, confirm nothing is queued to post
- [ ] Find drafts in `am_review` > 48h → remind the AM in that client's thread
- [ ] Find drafts in `failed` this week needing a retry or an alert
- [ ] Reply `HEARTBEAT_OK` if nothing needs attention
