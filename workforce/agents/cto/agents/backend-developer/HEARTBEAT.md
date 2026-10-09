# HEARTBEAT.md — Forge (Backend Developer)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — build only if `deploys_enabled` is `false`
- [ ] Check DB connection pool — alert if utilization > 80% sustained 5 min
- [ ] Check slow query log — alert if > 5 queries > 1s in last hour
- [ ] Check Stripe webhook delivery rate — alert if < 99% trailing 24h
- [ ] Check background job queue depth — alert if > 100 jobs pending > 10 min
- [ ] Check failed jobs last 24h — alert if > 10
- [ ] Find PRs in `review` > 48h without action
- [ ] Find specs in `cto_review` > 24h without Allen action
