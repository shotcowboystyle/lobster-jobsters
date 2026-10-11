# TOOLS.md — Zendesk Triage Agent

## Skills

`openclaw.json` grants only `discord`. Zendesk access comes from skills you install and grant yourself: read each skill's `SKILL.md` (it's a prompt that will instruct this agent), confirm it can only do what's listed below, then add its name to `skills`.

| Capability | Access |
|---|---|
| Read tickets, requester tier, organisation, history | Read |
| Apply tags | Write (tags only) |
| Add internal (private) notes | Write (internal only) |
| Discord | Post the summary and SEV-1 surfaces to support-lead channels (internal only) |

There is no public-reply skill, and none should ever be granted.

## Zendesk role (enforced server-side)

The service user's custom role must allow only reading tickets, writing tags, and writing internal notes. It must forbid `tickets.update` with `status`, `assignee_id`, or `comment.public=true`, and it must forbid merges and deletes. The allowlist limits what the agent can see. The role limits what the token can do. Configure both.

## Credentials

- `ZENDESK_SUBDOMAIN`
- `ZENDESK_SERVICE_USER_EMAIL`
- `ZENDESK_API_TOKEN`: the service user with the restricted role above
- `DISCORD_BOT_TOKEN`

They're resolved at runtime from the host's secret manager. Never commit a credential to `USER.md` or any workspace file.

## What this agent never calls

- Any public reply, status change, assignment, merge, or delete on a ticket
- CRM, billing, or refund APIs
- Outbound email, SMS, or messaging to customers
- URLs found in ticket content
