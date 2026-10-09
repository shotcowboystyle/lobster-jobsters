# HEARTBEAT.md — {{PERSONA}} ({{TEAM_SHORT}})

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `{{FLAG}}` is `false`, confirm nothing outbound is queued to send
- [ ] Find items in `review` > 24h without a decision → remind in `#{{CHANNEL_PREFIX}}-{{TEAM_SLUG}}-approvals`
- [ ] Find `execution_failed` items needing retry or escalation
- [ ] Reply `HEARTBEAT_OK` if nothing needs attention
