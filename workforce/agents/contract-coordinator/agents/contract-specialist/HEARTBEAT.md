# HEARTBEAT.md — Sage (Contract Specialist)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `contracts_enabled` is `false`, do not send envelopes
- [ ] For every `contract_sent` envelope, poll DocuSign status if last poll > 6h ago
- [ ] Send first reminder for envelopes pending > 48h with no buyer view
- [ ] Raise an `escalation-packet` (kind = `signature_expired`) for envelopes pending > 5d
- [ ] Verify DocuSign credentials are valid (without exposing tokens)
- [ ] Confirm all envelopes in `completed` state have a matching `contract_signed` ledger transition
