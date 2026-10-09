# HEARTBEAT.md — Pixel (Frontend Developer)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — build only if `deploys_enabled` is `false`
- [ ] Check trailing Lighthouse scores — alert if any < 90
- [ ] Check accessibility scan results — alert on any new violations
- [ ] Find PRs in `review` > 48h without action
- [ ] Find specs in `cto_review` > 24h without Allen action
- [ ] Verify design system not drifted (component library audit)
