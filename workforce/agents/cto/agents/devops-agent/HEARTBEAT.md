# HEARTBEAT.md — Bastion (DevOps Engineer)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — refuse production deploys if `deploys_enabled` is `false`
- [ ] Check uptime trailing 60 min — alert if < 99.9% for production endpoints
- [ ] Check API p95 latency — alert if > 500ms sustained 5 min
- [ ] Check error rate — alert if > 1% sustained 5 min
- [ ] Check SSL cert expirations — alert if any < 30 days
- [ ] Check backup last completed — alert if > 26h
- [ ] Check security findings (severity high/critical) without `patching` > 24h
- [ ] Check releases in `monitoring` past their watch window without `closed`
- [ ] Verify hosting + CDN + Sentry + Better Uptime API access
