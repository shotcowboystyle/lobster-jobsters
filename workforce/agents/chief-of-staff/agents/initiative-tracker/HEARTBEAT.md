# HEARTBEAT.md — Egret (Initiative Tracker)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `escalations_enabled` is `false`, draft only
- [ ] Find initiatives in `active` with `days_since_last_change > 14` — flag stall
- [ ] Find initiatives in `closed` for ≥ 30 days — archive
- [ ] Find sponsor pings unanswered past 7:45 PM Sunday — apply default carry-forward + stall flag
- [ ] Find initiatives in `proposed` > 7 days awaiting Jane decision
