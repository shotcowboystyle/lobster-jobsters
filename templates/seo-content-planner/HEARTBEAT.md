# HEARTBEAT.md — SEO Content Planner

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — if `planner_enabled` is `false`, confirm no calendar write is queued
- [ ] Find briefs in `user_review` > 72h → one reminder in `#seo-drafts`
- [ ] Find briefs `confirmed` but not `carded` (failed calendar write) → retry once or alert
- [ ] Reply `HEARTBEAT_OK` if nothing needs attention
