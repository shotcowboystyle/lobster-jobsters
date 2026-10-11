# TOOLS.md — Client Reporting Agent

## Skills

`openclaw.json` grants only `discord`. Data access comes from skills you install and grant yourself: read each skill's `SKILL.md` (it's a prompt that will instruct this agent), confirm it's read-only, then add its name to `skills`.

| Source | Access | Optional per client |
|---|---|---|
| GA4 | Read-only metrics | No |
| Google Search Console | Read-only search performance | No |
| Google Ads | Read-only campaigns and spend | Yes |
| Meta Ads | Read-only campaigns and spend | Yes |
| Linear / Asana / ClickUp | Read-only issue activity | Yes |
| Discord | Post drafts to AM channels (internal only) | — |

## Per-client credentials

Namespaced by client slug, and resolved at runtime from the host's secret manager:

- `CLIENT_<SLUG>_GA4_SERVICE_ACCOUNT_JSON`
- `CLIENT_<SLUG>_GSC_SERVICE_ACCOUNT_JSON`
- `CLIENT_<SLUG>_GOOGLE_ADS_REFRESH_TOKEN`
- `CLIENT_<SLUG>_META_ADS_TOKEN`
- `CLIENT_<SLUG>_TRACKER_TOKEN`

Shared: `DISCORD_BOT_TOKEN`. Never commit a credential to `USER.md` or any workspace file.

## What this agent never calls

- Any client-facing email, SMS, or messaging API. The AM sends.
- Any write API on GA4, Search Console, ad platforms, or trackers.
- Any credential belonging to a client other than the one being reported on.
