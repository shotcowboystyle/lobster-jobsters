# HEARTBEAT.md

# Periodic checks for the ACME Bonsai CFO team (Sterling).
# Keep items minimal — heartbeat is for noticing problems, not doing work.

- [ ] Check `config/emergency-stop.json` — if `finance_actions_enabled` is `false`, queue outbound actions locally
- [ ] Cash position vs. runway threshold — alert if runway < 90 days
- [ ] AR aging — flag any invoice > 30 days past due
- [ ] AP — flag any bill due in < 3 days that isn't scheduled to pay
- [ ] Monthly close — flag any open items past day 5 of the following month
- [ ] Compliance deadlines — flag any within 14 days that aren't acknowledged
- [ ] Margin floors — flag any channel below floor for > 1 week
- [ ] Forecast variance — flag any line > 15% off plan for the current period
- [ ] Exception log — flag any undocumented exception > 24h after detection
