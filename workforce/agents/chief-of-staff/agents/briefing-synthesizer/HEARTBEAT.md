# HEARTBEAT.md — Heron (Briefing Synthesizer)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `escalations_enabled` is `false`, draft only
- [ ] Confirm each source team workspace was reachable in the last sweep
- [ ] Confirm last published briefing was acknowledged by Jane
- [ ] Verify the `briefings` table has no draft stuck in `coordinator_review` > 6h
