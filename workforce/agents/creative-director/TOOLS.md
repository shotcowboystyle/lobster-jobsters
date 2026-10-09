# TOOLS.md — Creative Director Team (Masahiko)

Local environment specifics for Masahiko and the three sub-agents. Skills define _how_ tools work; this file documents _what_ this workspace connects to.

## External Services

| Service | Purpose | Env var | Owner |
|---|---|---|---|
| Discord | Creative team channels + cross-team handoffs | `DISCORD_BOT_TOKEN` + channel IDs | All |
| Figma | Design source files | `FIGMA_API_KEY` | Hana + Mira |
| Adobe Lightroom / Photoshop | Photo editing pipelines | (CLI tools) | Iris |
| File storage (S3 / Dropbox / Drive) | Brand asset library | `ASSET_STORAGE_API_KEY` | All |
| Email provider | Photo release requests | `EMAIL_PROVIDER_API_KEY` | Iris |
| E-sign provider (DocuSign) | Photo release agreements | `DOCUSIGN_*` | Iris |
| SQLite | Creative workflow ledger | `CREATIVE_LEDGER_DB_PATH` | All (read + write) |

## Discord Channels

| Channel handle | Channel ID env | Posters |
|---|---|---|
| `#acme-creative-drafts` | `DISCORD_CHANNEL_DRAFTS` | Masahiko, Hana, Iris, Mira |
| `#acme-creative-approvals` | `DISCORD_CHANNEL_APPROVALS` | Masahiko |
| `#acme-creative-library` | `DISCORD_CHANNEL_LIBRARY` | Hana, Masahiko |
| `#acme-creative-alerts` | `DISCORD_CHANNEL_ALERTS` | All |

## Creative Ledger

- File: `data/creative-ledger.db` (SQLite)
- Schema: `schemas/creative-ledger.sql`
- Backup: nightly via `ops/runbook.md` procedure
- Tracks workflow state — briefs, deliverables, photo shoots, care guides, brand assets, brand system updates, revision cycles

## Brand Asset Library

- Location: `data/asset-library/` (or S3 bucket per env)
- Organization: `{kind}/{year}-{month}/{asset_id}.{ext}`
- Metadata in ledger: tags, version, approval status, usage history
- Final assets only; drafts live separately

## Brand System

- Location: `data/brand-system/`
- Files: `style-guide.pdf`, `color-palette.json`, `typography.json`, `templates/`, `logo-variants/`
- Version-controlled; changes require Masahiko authorization + cd_review

## Cross-Team Coordination

- **CMO**: primary customer; produces most creative briefs (campaigns, social content, email)
- **Director of Sales (Cash)**: catalogs, presentation materials for subscription pitches, event mockups
- **COO (Tally)**: surfaces new inventory needing photography (daily routine integration)
- **COO (Birch + Hazel)**: signage and workshop space design
- **CTO (Pixel)**: web-ready assets (hero images, product photos, icons, page layout mockups)
- **Customer Service Manager (Care Education)**: technical review of every care guide before publication
- **Contract Coordinator (Rowan)**: wholesale catalog assets for buyer-facing material

## Emergency Stop

- File: `config/emergency-stop.json`
- Flag: `publish_assets_enabled` (boolean)
- Activated by: Jane or Masahiko (per `approval-policy.json` rule `emergency_stop`)
- Effect: see `ops/runbook.md` "Emergency Stop" section

## Local Dev Quick Reference

```bash
# Validate every JSON in this workspace
for f in schemas/*.json config/*.json; do jq empty "$f" && echo "OK $f"; done

# Initialize the creative ledger
sqlite3 data/creative-ledger.db < schemas/creative-ledger.sql

# Tail the latest daily log
ls -t memory/ | head -1 | xargs -I{} tail -f memory/{}
```

## Related

- `AGENTS.md` — operating instructions for the whole team
- `README.md` — architecture, state machines, RACI
- `ops/runbook.md` — daily/weekly procedures and incident response
