# HEARTBEAT.md

# Periodic checks for the ACME Bonsai COO team (Victor).
# Keep items minimal — heartbeat is for noticing problems, not doing work.

- [ ] Check `config/emergency-stop.json` — if `ops_actions_enabled` is `false`, queue outbound actions locally
- [ ] Check environmental conditions outside optimal ranges > 6 hours
- [ ] Check inventory items in `quarantined` > 14 days without resolution
- [ ] Check tree mortality rate over trailing 30 days — alert if > 2%
- [ ] Check deliveries scheduled within 24h that are not yet confirmed with customer
- [ ] Check rentals at `at_event` past their event end > 48h (return pickup overdue)
- [ ] Check workshops within 7 days that don't have materials checklist + instructor confirmation
- [ ] Check facility incidents in `triaged` > 24h without `in_progress`
- [ ] Check inventory safety thresholds — any species/size at or below threshold
