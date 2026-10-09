# HEARTBEAT.md

# Periodic checks for the ACME Bonsai Customer Service Manager team (Poppy).
# Keep items minimal — heartbeat is for noticing problems, not doing work.

- [ ] Check `config/emergency-stop.json` — if `outbound_replies_enabled` is `false`, queue outbound replies locally
- [ ] Find tickets in `received` > 2h during business hours without first response
- [ ] Find tickets in `in_progress` > 24h without status update
- [ ] Find order issues in `investigating` > 24h without resolution proposal
- [ ] Find care consultations with follow-up date passed without check-in
- [ ] Find health check-ins in `executed` > 48h without response from customer (escalate to outreach)
- [ ] Find subscription customers with CSAT signals dropping > 0.5 points
- [ ] Find subscription customers with no activity > 30 days
- [ ] Find same customer with > 3 contacts about same unresolved issue
- [ ] Find tickets containing legal-trigger words ("lawyer", "lawsuit", "consumer protection") not yet escalated
- [ ] Find pattern of same issue (≥ 3 different customers, same root cause) not yet escalated
