# HEARTBEAT.md — Garrison (Controls & Compliance)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — filing sends pause if `finance_actions_enabled` is `false`
- [ ] Find compliance deadlines within 14 days still in `tracked` (not yet `due_soon`)
- [ ] Find compliance deadlines within 3 days still in `tracked` (urgent)
- [ ] Find compliance deadlines past `due_date` not yet `filed` → escalate
- [ ] Find exceptions > 24h since detection still in `detected` (not yet `documented`)
- [ ] Find critical or high severity exceptions older than 7 days without resolution
- [ ] Verify tax service / filing API credentials valid (without exposing tokens)
