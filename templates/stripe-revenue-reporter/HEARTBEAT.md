# HEARTBEAT.md — Stripe Revenue Reporter

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `digest_enabled` is `false`, confirm nothing is queued to post
- [ ] Confirm yesterday's digest run is `posted` or `skipped_partial_data` (not stuck in `running`)
- [ ] Find `failed` or `skipped_partial_data` runs in the last 3 days → alert the owner once
- [ ] Reply `HEARTBEAT_OK` if nothing needs attention
