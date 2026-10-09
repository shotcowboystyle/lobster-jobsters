# HEARTBEAT.md — Pearl (Support Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outbound replies queue if `outbound_replies_enabled` is `false`
- [ ] Find new tickets > 1h old without triage (approaching 2h SLA)
- [ ] Find tickets in `received` without first response (during business hours)
- [ ] Find tickets containing legal-trigger words ("lawyer", "lawsuit", "consumer protection") not yet escalated
- [ ] Find tickets with `contact_count > 3` not yet escalated
- [ ] Find tickets without category tag applied
- [ ] Verify email + SMS + chat + phone provider access
