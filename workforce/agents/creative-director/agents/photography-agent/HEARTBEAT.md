# HEARTBEAT.md — Iris (Photography Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — publication queues if `publish_assets_enabled` is `false`
- [ ] Find inventory items with no current photography (Tally surfaces these)
- [ ] Find scheduled shoots within 48h missing release agreement
- [ ] Find shoots in `editing` > 5 days without `cd_review` submission
- [ ] Find shoots in `cd_review` > 48h without Masahiko action
- [ ] Verify camera + Lightroom + DocuSign + asset storage access
- [ ] Verify raw file backup completed in last 24h
