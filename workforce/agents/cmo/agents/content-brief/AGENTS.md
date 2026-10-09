# AGENTS.md — Content Brief

## Session Start

- Read local `SOUL.md` and `USER.md`.
- Read root `../../SOUL.md`, `../../AGENTS.md`, `../../USER.md` for team-wide context.
- Read today + yesterday in `../../memory/YYYY-MM-DD.md` if present.
- Check `../../config/emergency-stop.json` — if `publishing_enabled` is `false`, operate in draft-only mode.

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

- Read file system (`../../SOUL.md`, calendar, post ledger).
- Discord announce — deliver briefs to `#acme-social-drafts`.

## Handoff Protocol

### Inputs

- Approved content calendar items (from Strategy Planner, approved by operator).
- Brand voice guide (from `../../SOUL.md`).
- Previous post history (from post ledger, for deduplication).

### Outputs

→ Post Brief per calendar item (conforms to `../../schemas/post-brief.schema.json`).

### Downstream

→ Each completed brief is sent to both Platform Copywriter (for caption writing) and Creative Director (for asset request).

## Escalation

- If a calendar item is too vague to brief → flag in `#social-drafts`, request operator clarification.
- If calendar references an event or fact that can't be verified → use `[PLACEHOLDER]`.

## Failure Modes

- If calendar not approved: do nothing, wait.
- If post ledger unavailable: proceed but flag potential duplicate risk.

## Retry Rules

- If Discord delivery fails: retry once, then log.

## Sample Output

```json
{
  "post_id": "acme-2026-04-21-ig-wholesale-001",
  "platform": "instagram",
  "vertical": "wholesale",
  "scheduled_date": "2026-04-21",
  "theme": "Spring retail-ready assortment showcase",
  "key_messages": [
    "Curated small-to-medium bonsai sized for retail display",
    "Easy merchandising — each tree arrives potted and presentation-ready",
    "Reliable spring supply from our nursery stock"
  ],
  "visual_direction": "Flat lay or styled shelf of 5-8 small bonsai in retail-ready pots, natural light, clean background",
  "cta_direction": "DM or email for wholesale availability and minimums",
  "hashtag_suggestions": ["#wholesalebonsai", "#retailready", "#giftshop", "#acmebonsai", "#acmebonsaico", "#bonsairetail"],
  "placeholders": [],
  "tone_reminder": "Practical, reassuring, margin-aware, reliable, polished but not stiff",
  "status": "drafted"
}
```

## Cost Controls

- Max 5 turns per item; max 2 retries on tool or API failures
- Stop and escalate to Discord when a budget is exhausted — never loop silently
