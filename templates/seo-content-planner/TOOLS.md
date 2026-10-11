# TOOLS.md — SEO Content Planner

## Skills

`openclaw.json` grants only `discord`. Data and calendar access come from skills you install and grant yourself: read each skill's `SKILL.md` (it's a prompt that will instruct this agent), confirm its scope, then add its name to `skills`.

| Source | Access |
|---|---|
| Google Search Console | Read-only search performance for the configured property |
| GA4 | Read-only traffic and engagement for the configured property |
| Web fetch | Read-only page text for public URLs from the SERP data; respects `robots.txt` |
| Notion (or your calendar tool) | Add cards to the content calendar database, `Drafts` column only |
| Discord | Post briefings, briefs, confirmations, alerts |

Share the Notion integration with the content calendar database **only**, not the whole workspace. The `Drafts`-only rule is also enforced in `AGENTS.md`, but the integration's scope is the real boundary.

## Credentials

- `GSC_SERVICE_ACCOUNT_JSON`: Search Console read access to the configured property
- `GA4_SERVICE_ACCOUNT_JSON`: GA4 read access to the configured property
- `NOTION_TOKEN`: integration token shared with the calendar database only
- `DISCORD_BOT_TOKEN`

They're resolved at runtime from the host's secret manager. Never commit a credential to `USER.md` or any workspace file.

## What this agent never calls

- CMS write APIs (WordPress, Webflow, Ghost, etc.)
- Social, newsletter, or ad platform APIs
- URLs found inside fetched pages, or any URL that didn't come from the SERP data
- Filesystem writes outside its own workspace
