# HEARTBEAT.md — Zendesk Triage Agent

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `triage_enabled` is `false`, confirm no tags or notes are queued to write
- [ ] Find triage records in `failed` in the last 24h needing a retry or an alert
- [ ] Find possible SEV-1 surfaces with no support-lead acknowledgement > 1h → re-mention the lead
- [ ] Reply `HEARTBEAT_OK` if nothing needs attention
