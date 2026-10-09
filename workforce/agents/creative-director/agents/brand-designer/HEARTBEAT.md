# HEARTBEAT.md — Hana (Brand Designer)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — publication queues if `publish_assets_enabled` is `false`
- [ ] Find deliverables in `revising` > 24h without owner response
- [ ] Find brand drift signals open > 48h without remediation
- [ ] Find brand assets in `staging` > 7 days without Masahiko approval
- [ ] Find templates in library > 12 months old (consider freshness review)
- [ ] Verify Figma + asset storage API access
