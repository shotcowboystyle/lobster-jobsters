# Tech Stack Reference — ACME Bonsai

Canonical technology stack for every team. CTO (Allen + Pixel + Forge + Bastion) owns implementation; other teams reference for integration + cross-team coordination.

If you're an agent unsure what tool the company uses for X, this file is the answer. If you're adding a new tool, propose via Allen's feature triage with budget impact.

---

## Hosting + Infrastructure

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Web hosting | Vercel (or Render) | Bastion (CTO) | Production deploys via Vercel API |
| CDN + WAF + DNS | Cloudflare | Bastion (CTO) | Cache hit rate target > 70% |
| Primary database | Postgres (managed) | Forge (CTO) | Connection pool, read replica when needed |
| Workflow ledgers (per team) | SQLite | All teams | Per-team `data/*-ledger.db` |
| Secrets management | 1Password (or equivalent) | Bastion (CTO) | Never in repo; never in env files committed |
| Source code | GitHub (`your-org/storefront` + `your-org/lobster-jobsters`) | All | Branch protection on main |
| CI / CD | GitHub Actions | Bastion (CTO) | Required PR review + CI pass + staging deploy |

## Application Layer

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Frontend | Next.js / React | Pixel (CTO) | Mobile-first; Lighthouse > 90 target |
| Design tokens | Figma | Pixel + Hana (CD) | Design system canonical in Figma |
| Component library | Storybook | Pixel (CTO) | Documentation for shared components |
| Backend API | Node / Python | Forge (CTO) | Boring stack; well-documented patterns |
| CMS (content) | Headless CMS or Next.js routes | Pixel + Forge (CTO) | Marketing publishes without developer help |
| Email API integration | Postmark / SES / Resend | All sub-agents send through this | Per-team `EMAIL_PROVIDER_API_KEY` |
| SMS API | Twilio | All sub-agents send through this | Per-team `SMS_PROVIDER_API_KEY` |

## Payments + Financial

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Payment processing | Stripe (PCI compliant via tokenization) | Forge (CTO) + Finch (CC) + Sterling (CFO) | Never store card data; idempotency keys on PaymentIntents |
| ACH | Stripe ACH (or direct ACH provider) | Finch (CC) + Sterling (CFO) | Used for wholesale large deposits |
| Banking | Plaid (or direct bank connection) | Sterling (CFO) | Read-only for cash position |
| Accounting | QuickBooks Online (or Xero) | Sterling (CFO) | State of record for financials |
| Tax / filings | Avalara (or TaxJar) | Garrison (CFO) | Sales tax + 1099 + W-2 + state filings |
| Subscriptions | Stripe Subscriptions | Sophia (DoS) + Sterling (CFO) | Set up on contract signing |

## Sales + CRM

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| CRM | In-house (sales ledger SQLite) | Cash (DoS) | Single source of truth for customer accounts |
| Lead intake | Website forms + email + phone + walk-in + referral | All DoS sub-agents | Routed via Pearl (CSM) for initial triage on some channels |
| Contract signing | DocuSign | Sage (CC) | Wholesale contracts via DocuSign templates |
| Quote generation | Custom in-app | All DoS sub-agents | Stored as `quote` artifacts in sales ledger |

## Operations

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Inventory sheet | Google Sheets (canonical for tree counts) | Tally (COO) + Grove (CC) | Atomic per-row updates only |
| Workshop calendar | Google Calendar | Hazel (COO) | Read-only access for other teams |
| Delivery routing | Google Maps Platform (Directions + Geocoding APIs) | Cedar (COO) + Miles (CC) | Geocode cache 90d |
| Environmental sensors | Per-device API | Birch (COO) | Temperature, humidity, light, soil moisture per zone |
| Driver assignment | In-app via ops ledger | Cedar (COO) + Miles (CC) | Van capacity tracking |

## Creative + Marketing

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Social media publishing | Meta Graph API (Instagram + Facebook) | CMO Publisher | Container + publish flow for IG; scheduled_publish_time for FB |
| Asset library | S3 (or Dropbox / Drive) | Hana (CD) | Brand asset library; final assets only |
| Brand system | Figma + version-controlled docs | Hana + Masahiko (CD) | Style guide canonical in Figma + PDF export |
| Photo editing | Adobe Lightroom + Photoshop | Iris (CD) | Spot retouch only — never enhance trees |
| Photo release | DocuSign | Iris (CD) | Customer venue / event releases |
| Marketing analytics | Google Analytics + Meta insights | CMO Engagement Monitor + Weekly Analyst | Conversion tracking |

## Customer Service

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Email inbox | Postmark or equivalent (shared via tooling) | Pearl (CSM) | Per-ticket threading |
| SMS gateway | Twilio | All CSM sub-agents | Idempotency on every send |
| Chat (website) | Custom Next.js component | Pearl (CSM) + Pixel (CTO) | Triage to ticket if not resolved in-chat |
| Phone | Office phone forwarded to CSM | Pearl (CSM) | Recorded with consent for training |
| Status page | Better Uptime or equivalent | Bastion (CTO) | Public status for transparency |

## Monitoring + Observability

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Error tracking | Sentry | Bastion (CTO) + Forge + Pixel | Real-time alerting |
| Uptime monitoring | Better Uptime | Bastion (CTO) | Synthetic checks every 1 min |
| Performance | Lighthouse CI | Pixel (CTO) | Per-PR performance budget |
| Logs | Vercel + custom logging | Bastion (CTO) | Structured JSON logs to durable storage |
| Backups | Automated Postgres backups | Bastion (CTO) | Nightly; weekly restore test |

## Coordination

| Layer | Tool | Owner | Notes |
|---|---|---|---|
| Internal coordination | Discord | All | Per-team channel structure |
| Calendar | Google Calendar | Jane (admin) | Shared exec + per-team calendars |
| Task management | GitHub Issues | Jane (admin) | Cross-team issues tracked here |
| Document storage | Per-workspace Git + `data/` directories | Per-team | Ledger DBs + asset libraries |
| Process automation | Claude Code Routines | All coordinators | Per-team `config/routines.example.sh` |

## Third-Party Services Cost Tracking

Per `approval-policy` rules, new SaaS additions > $200/mo require Jane approval. Existing recurring software costs tracked by Sterling (CFO Garrison + Margin) via monthly close + weekly margin snapshot.

## Stack Principles

- **Boring infrastructure wins** — battle-tested tools rarely fail in new + interesting ways
- **Single source of truth per domain** — each team's ledger is canonical for its workflow state
- **Idempotency keys** on every outbound side-effect
- **PCI compliance via Stripe tokenization** — never touch raw card data
- **HTTPS only**; no plaintext secrets
- **No deploys**: Friday, pre-campaign, or during emergency stop
- **Backup before infra changes**; rollback plan documented before every prod deploy
- **Tests for critical paths**: checkout, booking, payment

## Updates to This File

Tech stack changes are proposed via Allen's feature triage (Bastion / Forge / Pixel implement). SaaS additions > $200/mo route to Jane. Major architecture changes (platform migration, schema migration affecting customer data) require Jane approval.

Document changes in `exec-decisions-log.md` so future agents know when + why a change happened.
