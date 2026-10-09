# HEARTBEAT.md — Tally (Inventory Agent)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — outward `allocated` transitions pause if `ops_actions_enabled` is `false`
- [ ] Find inventory items with `last_health_check_at` > 24h (need Birch's visit)
- [ ] Find species/size pairs at or below safety threshold
- [ ] Find reservations with `hold_until` expiring within 48h
- [ ] Recompute trailing 30d mortality rate — alert if > 2%
- [ ] Verify inventory sheet API credentials valid (without exposing tokens)
- [ ] Detect drift: sheet vs `inventory_items` ledger entry count
