# TOOLS.md — Booking Search Agent

## Skills

`openclaw.json` ships with `skills: []`. Grant exactly one hotel search skill backed by an official or affiliate API whose terms permit automated queries. Before granting it: read its `SKILL.md` (it's a prompt that will instruct this agent), confirm it exposes search only (no booking, hold, or payment calls), and confirm it doesn't scrape or solve bot challenges. Add `discord` too if the agent answers in Discord.

## Expected search contract

Inputs:

| Field | Required | Default | Notes |
|---|---|---|---|
| `location` | yes | — | City, country, region, landmark, hotel, or airport name |
| `checkin` | yes | — | `YYYY-MM-DD` |
| `checkout` | yes | — | `YYYY-MM-DD` |
| `adults` | no | 2 | |
| `children` | no | 0 | |
| `childrenAges` | when children > 0 | — | List of ages |
| `rooms` | no | 1 | |
| `currency` | no | provider default | ISO code |

Output: see `schemas/search-result.schema.json`. Query echo, resolved destination, `total_count`, and a `hotels` list (name, url, address, distance, review score/label/count, price, room). If your provider's shape differs, map it to this contract in your reply logic; don't change the presentation rules.

## Credentials

- `HOTEL_SEARCH_API_KEY` — the provider key, read-only/search scope where the provider supports it
- `DISCORD_BOT_TOKEN` — only if answering in Discord

Never commit a credential to `USER.md` or any workspace file.

## What this agent never calls

- Any booking, reservation, hold, or payment API.
- Any host other than the granted provider's API.
- Scrapers, headless browsers, or challenge solvers.
- CRM, email, SMS, or messaging APIs beyond the channel reply.
