# HEARTBEAT.md

# Periodic checks for the ACME Bonsai CEO team (Apex).
# Keep items minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `external_comms_enabled` is `false`, Envoy drafts only
- [ ] Check for Almanac decision entries with outcome windows that closed in the last 24h — surface for outcome capture
- [ ] Check for Compass strategic questions left un-answered > 14 days — gently surface
- [ ] Check for Atlas memo drafts left in `ceo_review` > 72h
- [ ] Check for Envoy outbound drafts left in `ceo_review` > 24h
- [ ] Check the decision journal index for the past 90 days — flag patterns (recurring decision types, recurring trade-offs)
