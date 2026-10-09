# HEARTBEAT.md — Envoy (External Communications)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — refuse sends if `external_comms_enabled` is `false`
- [ ] Find comms in `ceo_review` > 24h — surface in stale roll-up
- [ ] Find comms in `approved` not sent within 6h — flag for retry decision
- [ ] Find comms in `failed` status without Jane decision — surface
- [ ] Verify email provider credentials valid (without exposing tokens)
- [ ] Confirm stakeholder records file is readable + parseable
