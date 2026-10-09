# HEARTBEAT.md

# Periodic checks for the ACME Bonsai CTO team (Allen).
# Keep items minimal — heartbeat is for noticing problems, not doing work.

- [ ] Check `config/emergency-stop.json` — if `deploys_enabled` is `false`, queue release work locally
- [ ] Check uptime trailing 60 min — alert if < 99.9% for production endpoints
- [ ] Check API p95 latency — alert if > 500ms sustained 5 min
- [ ] Check error rate — alert if > 1% sustained 5 min
- [ ] Check open incidents in `triaged` > 1h without `mitigated`
- [ ] Check open incidents in `mitigated` > 24h without `resolved`
- [ ] Check open security findings (severity high/critical) > 24h without `patching`
- [ ] Check releases in `monitoring` past their watch window without `closed`
- [ ] Check feature requests in `intake` > 48h without triage
- [ ] Check tech-debt entries > 90 days in `logged` (un-triaged debt accumulates interest)
