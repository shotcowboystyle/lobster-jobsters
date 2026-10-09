# HEARTBEAT.md — Hazel (Workshop Coordinator)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — confirmations + reminders pause if `ops_actions_enabled` is `false`
- [ ] Find workshops within 7 days without materials checklist 100% complete
- [ ] Find workshops within 14 days without instructor confirmed
- [ ] Find workshops within 14 days under `capacity.min` registrations
- [ ] Find registrations missing 48h reminder
- [ ] Find workshops in `debrief` > 7 days without `closed` (survey pending)
- [ ] Find workshops in `closed` with demo trees not returned to inventory
