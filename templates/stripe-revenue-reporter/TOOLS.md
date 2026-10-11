# TOOLS.md — Stripe Revenue Reporter

## Skills

`openclaw.json` grants only `discord`. Stripe access comes from a skill you install and grant yourself: read its `SKILL.md` (it's a prompt that will instruct this agent), confirm it only calls Stripe read endpoints, then add its name to `skills`.

| Source | Access |
|---|---|
| Stripe | Read-only: Charges, Refunds, Customers, Subscriptions, Invoices |
| Discord | Post the digest to the internal channel |

## Stripe key

Use a Stripe **restricted API key** with **read** scope on Charges, Refunds, Customers, Subscriptions, and Invoices, and nothing else. Never deploy a full secret key. If the key in use can write, stop and alert the owner.

## Credentials

Resolved at runtime from the host's secret manager:

- `STRIPE_RESTRICTED_KEY` — restricted, read-only
- `DISCORD_BOT_TOKEN`

Never commit a credential to `USER.md` or any workspace file.

## What this agent never calls

- Any Stripe write endpoint: charges, refunds, payouts, customers, subscriptions, invoices.
- Any CRM, billing, or accounting integration.
- Any email, SMS, or customer messaging API. The digest goes to the internal channel only.
