# HEARTBEAT.md — Horizon (FP&A)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — report posts queue if `finance_actions_enabled` is `false`
- [ ] Recompute runway if cash position last updated > 7 days ago
- [ ] Runway < 90 days → immediate Jane alert
- [ ] Find published forecasts > 60 days old without refresh
- [ ] Find forecasts in `cfo_review` > 72h without Sterling action
- [ ] Verify cross-team ledger access (read-only) is functioning
