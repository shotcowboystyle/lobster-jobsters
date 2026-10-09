# HEARTBEAT.md — Miles (Delivery Router)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `contracts_enabled` is `false`, halt buyer-facing emails
- [ ] Identify contracts in `inventory_reserved` with delivery date inside 7d that have no route assigned
- [ ] Identify routes in `approved` state with no per-buyer ETA emails sent
- [ ] Identify routes in `emailed_buyers` state that have not yet dispatched on the planned date
- [ ] Verify Google Maps API key validity (without exposing tokens)
- [ ] Check geocode cache hit rate; flag if < 70% over the last 7 days (rising API spend)
