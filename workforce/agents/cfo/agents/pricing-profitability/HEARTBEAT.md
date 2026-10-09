# HEARTBEAT.md — Margin (Pricing & Profitability)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — publishing approved pricing changes pauses if `finance_actions_enabled` is `false`
- [ ] Find channels below margin floor for > 1 week
- [ ] Find cost inputs > 30 days old (stale)
- [ ] Find pricing decisions in `cfo_review` > 24h without Sterling action
- [ ] Find approved discounts past their `expiry_date` still in `in_effect`
- [ ] Verify per-channel revenue + COGS data current
