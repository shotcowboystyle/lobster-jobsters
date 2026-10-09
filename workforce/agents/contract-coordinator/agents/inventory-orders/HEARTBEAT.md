# HEARTBEAT.md — Grove (Inventory & Orders)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `contracts_enabled` is `false`, halt outward transitions
- [ ] Reconcile inventory sheet vs. `inventory_reservations` ledger — flag any drift
- [ ] Recompute available-per-species/size and flag any item at or below safety threshold
- [ ] Identify reservations with `hold_until` expiring inside 48h that aren't yet routed — alert Rowan
- [ ] For routes in `approved` state with no pick list yet, generate the pick list
- [ ] Verify Google Sheets API token validity (without exposing tokens)
