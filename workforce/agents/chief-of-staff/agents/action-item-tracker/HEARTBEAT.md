# HEARTBEAT.md — Wren (Action-Item Tracker)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `escalations_enabled` is `false`, queue follow-ups locally
- [ ] Find action items >24h overdue with no +24h follow-up sent
- [ ] Find action items >48h overdue with no +48h follow-up sent
- [ ] Find action items >72h overdue with no escalation sent to River
- [ ] Find action items in `opened` state without owner or deadline (defects)
- [ ] Find action items in `in_progress` without `outcome_statement` (defects)
