# TOOLS.md — CTO Team (Allen)

Local environment specifics for Allen and the three sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Tech team channels + escalations | `DISCORD_BOT_TOKEN` + channel IDs | All |
| GitHub | Source code, PRs, Actions / CI | `GITHUB_TOKEN` | All |
| Vercel (or Render) | Hosting + deploy pipeline | `VERCEL_TOKEN` | Bastion |
| Cloudflare | CDN + WAF + DNS | `CLOUDFLARE_API_KEY` | Bastion |
| Stripe | Payments (PCI compliance via tokenization) | `STRIPE_SECRET_KEY` | Forge |
| Sentry | Error tracking + alerting | `SENTRY_DSN` | All |
| Better Uptime (or equivalent) | Synthetic monitoring + status page | `BETTER_UPTIME_API_KEY` | Bastion |
| Postgres (managed) | Primary database | `DATABASE_URL` | Forge |
| 1Password (or equivalent secrets manager) | Secrets / credentials | n/a (CLI) | Bastion |
| SQLite | Tech ledger (workflow state) | `TECH_LEDGER_DB_PATH` | All (read + write) |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-tech-drafts` | `DISCORD_CHANNEL_DRAFTS` | Allen, Pixel, Forge, Bastion |
| `#acme-tech-approvals` | `DISCORD_CHANNEL_APPROVALS` | Allen |
| `#acme-tech-releases` | `DISCORD_CHANNEL_RELEASES` | Bastion |
| `#acme-tech-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## Tech Ledger

- File: `data/tech-ledger.db` (SQLite)
- Schema: `schemas/tech-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Tracks workflow state — feature requests, specs, PRs, releases, incidents, security findings, observability snapshots, tech debt entries

## GitHub Repositories

Primary repositories under monitoring:

- `your-org/storefront` — main website + storefront
- `your-org/lobster-jobsters` — this workspace
- Plus any future repos as added (admin tooling, mobile, etc.)

Branch protection on `main`:

- Required PR review (Allen or sub-agent)
- Required CI pass
- Required staging deploy on PR
- No direct pushes to `main`

## Cross-Team Coordination

- **CMO (marketing)**: primary site customer; CMS publishing tools; landing pages; conversion tracking
- **Director of Sales (Cash)**: lead capture forms; booking systems; subscription + rental flows; CRM integration
- **Creative Director (when shipped)**: design system; brand consistency; photography integration
- **COO (Tally + Cedar + Hazel + Birch)**: admin tooling; inventory integration; workshop booking; delivery scheduling
- **CFO (Sterling + Margin)**: payment integration; financial reporting; software spend tracking
- **Customer Service Manager (when shipped)**: contact forms; live chat; help center; bug intake
- **Contract Coordinator (Rowan)**: DocuSign integration; contract status surfacing

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `deploys_enabled` (boolean)
- Activated by: Jane or Allen (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the tech ledger
sqlite3 data/tech-ledger.db < schemas/tech-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly/monthly procedures and incident response
