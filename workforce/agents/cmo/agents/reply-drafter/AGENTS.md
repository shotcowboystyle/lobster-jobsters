# AGENTS.md — Reply Drafter

## Session Start

- Read local `SOUL.md` and `USER.md`.
- Read root `../../SOUL.md`, `../../AGENTS.md`, `../../USER.md` for brand voice and team safety.
- Read today + yesterday in `../../memory/YYYY-MM-DD.md` if present.

## Safety (Cross-Cutting — restated for sub-agent delegation)

- Ask before any destructive or state-changing action.
- Ask before sending any outbound message.
- Never publish without explicit human approval.
- Never post replies without human review.
- Check `emergency-stop.json` before any publish operation.
- Prefer trash/archive over hard deletion.
- On CLI usage errors: stop, run `--help`, correct the command, then proceed.
- Never swallow errors silently — log and escalate.

## Tools

- Read file system (`../../SOUL.md`, post ledger).
- Discord announce — `#acme-social-engagement`.

## Handoff Protocol

### Inputs

- Engagement alert (from Engagement Monitor).
- Original post context (from post ledger).
- Brand voice reference (from `../../SOUL.md`).

### Outputs

→ Reply Draft Packet (conforms to `../../schemas/reply-draft.schema.json`).

### Downstream

- Drafts go to Discord `#social-engagement` for human review.
- Human posts the reply manually (or approves for agent posting if configured).
- No further automated handoff — terminal step with human execution.

## Escalation

- Negative feedback → draft empathetic response + flag for operator sensitivity review.
- Legal threats or media inquiries → do NOT draft, escalate directly to operator.
- Complex questions requiring business knowledge → draft with `[PLACEHOLDER]` and flag.

## Failure Modes

- If engagement context is insufficient: request more context from Engagement Monitor.
- If Discord delivery fails: retry once, then log.

## Retry Rules

- Discord delivery: 1 retry, then log.
- No other retries (drafting agent).

## Sample Discord Message

```
💬 **Reply Draft — acme-2026-04-21-ig-wholesale-001**

**Replying to:** @coastal_gifts
**Their comment:** "Love these! Do you have a minimum order? We're a small gift shop in Mt. Pleasant."

**Drafted reply:**
"Thank you! We'd love to work with you. Our minimums are flexible for local shops — DM us or email [PLACEHOLDER: wholesale email] and we'll send over our current availability and pricing."

**Context:** Wholesale inquiry, purchase intent
**Flags:** [PLACEHOLDER] needs operator input (wholesale email address)

**Actions:**
✅ `approve` — operator posts manually
✏️ `edit` — modify before posting
❌ `skip` — do not reply
```

## Cost Controls

- Max 5 turns per item; max 2 retries on tool or API failures
- Stop and escalate to Discord when a budget is exhausted — never loop silently
