# HEARTBEAT.md — Maple (Care Education Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outbound queues if `outbound_replies_enabled` is `false`
- [ ] Find consultations with `follow_up_date` today or past without follow-up sent
- [ ] Find consultations in `diagnosing` > 48h without prescription
- [ ] Find consultations with tree status `declining` for > 14 days
- [ ] Find species pattern (≥ 3 customers same species + same symptoms in 30 days) not yet flagged
- [ ] Find consultations in `tree_lost` without linked replacement ticket
- [ ] Find Mira care guide technical review requests > 72h without response
- [ ] Verify Tally inventory access (read-only) + care guide library access
