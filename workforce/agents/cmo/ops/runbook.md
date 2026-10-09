# ACME Bonsai Social Marketing — Operations Runbook

## Overview

This runbook covers daily and weekly operations for the ACME Bonsai Claude Desktop social marketing team.

---

## Daily Operations

### Morning (8:00 AM ET)

1. Check #social-approvals for any pending approvals from yesterday
2. Review daily draft output in #social-drafts (auto-generated at 8 AM)
3. Review any overnight engagement alerts in #social-engagement
4. Check system health (daily health check runs at 6 AM)

### Throughout the Day

1. Monitor #social-approvals for new approval cards
2. Act on approval cards: approve, edit, hold, or reject
3. Monitor #social-engagement for actionable engagement alerts
4. Review and approve/edit/skip reply drafts
5. Respond to any escalations

### Evening

1. Check for any unanswered approval cards
2. Review engagement summary for the day
3. Note any content ideas or directives for tomorrow

---

## Weekly Operations

### Monday Morning

1. Review the weekly content calendar delivered to #social-drafts (auto-generated at 7 AM)
2. Approve, edit, or reject the calendar
3. Note any special events, promotions, or priorities for the week
4. Review last week's performance report from #social-reports (delivered Sunday 6 PM)

### Sunday Evening

1. Review the weekly performance report in #social-reports
2. Note optimization recommendations for next week
3. Add any operator directives for next week's planning

---

## Approval Handling

### Approval Actions

| Action | What Happens | When to Use |
|--------|-------------|-------------|
| `approve` | Post sent to Publisher for scheduling | Content is ready as-is |
| `edit <notes>` | Post returns to Copywriter with your notes | Content needs changes |
| `hold` | Post parked; reminder in 48h | Need more info or timing isn't right |
| `reject` | Post archived, not published | Content shouldn't be published |

### Approval Best Practices

- Review within 12 hours when possible
- Check all [PLACEHOLDER] items — fill in or confirm before approving
- Verify visual asset is attached/ready before approving
- If QA flags are present, review them carefully
- Never approve a post you haven't read fully

### Approval Timeouts

- 12 hours: reminder posted
- 24 hours: escalated, post set to "held"
- Timeouts NEVER auto-approve

---

## Common Failures

### Publish Failure

1. Check error message in #social-approvals
2. Common causes:
   - Image format not supported → re-export as JPEG/PNG
   - Token expired → refresh Meta page access token
   - Rate limit → wait for reset (usually 1 hour)
   - Network error → automatic retry in 5 minutes
3. System retries automatically (up to 3 attempts)
4. After 3 failures: manual intervention required

### Meta Token Expiration

1. Symptoms: auth errors in publish attempts
2. Solution: generate new long-lived page access token
3. Update token in `~/.claude/credentials/` (NOT in workspace)
4. Verify with a test API call

### Routine Failure

1. If a routine doesn't run, its output simply doesn't appear in Discord
2. Check routine status at `claude.ai/code/routines` or in the Claude Desktop sidebar under Routines
3. Trigger manually: click "Run now" on the routine, or send an HTTP POST to its API endpoint
4. Missing daily drafts? Trigger the "Daily Draft Generation" routine manually
5. Missing weekly calendar? Trigger the "Weekly Planning" routine manually

### Bot Not Posting to Discord

1. Check Discord bot status and permissions
2. Verify channel IDs in discord-config.json
3. Check bot token validity
4. Verify bot has permission to post in all 4 channels

---

## Incident Response

### Severity Levels

| Level | Examples | Response Time |
|-------|---------|--------------|
| Low | Single post formatting issue, minor metric gap | Next business day |
| Medium | Publish failure (retriable), engagement spike | Within 4 hours |
| High | Auth failure, multiple publish failures, negative viral engagement | Within 1 hour |
| Critical | Crisis, emergency stop needed, data breach, platform ban | Immediately |

### Incident Steps

1. Assess severity
2. If critical: activate emergency stop immediately
3. Investigate root cause
4. Resolve or escalate
5. Log incident in post ledger
6. Post resolution to #social-approvals

---

## Emergency Stop

### Activating Emergency Stop

Edit `config/emergency-stop.json`:

```json
{
  "publishing_enabled": false,
  "reason": "Describe why publishing is paused",
  "stopped_by": "Your name",
  "stopped_at": "2026-04-19T12:00:00Z"
}
```

**What stops:**

- All publish jobs
- All scheduling

**What continues:**

- Planning and drafting (pipeline stays warm)
- Engagement monitoring
- Reply drafting (but replies are not posted)

### Resuming Publishing

Edit `config/emergency-stop.json`:

```json
{
  "publishing_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": "Describe why publishing is resumed",
  "resumed_by": "Your name",
  "resumed_at": "2026-04-19T14:00:00Z"
}
```

---

## Rolling Back Posting Automation

### Pause All Publishing

1. Activate emergency stop (see above)
2. All queued posts remain in their current state

### Disable Specific Routines

1. Go to `claude.ai/code/routines` or Claude Desktop sidebar → Routines
2. Find the routine (e.g., "Daily Draft Generation" or "Weekly Planning")
3. Disable the schedule trigger (or delete the routine)

### Disable All Routines

1. Go to `claude.ai/code/routines`
2. Disable or delete all 7 CMO routines

### Full System Pause

1. Activate emergency stop
2. Disable all routines at `claude.ai/code/routines`
3. Post notice in #social-approvals
4. To resume: re-enable routines + lift emergency stop

---

## Onboarding a New Human Approver

1. Add their Discord user ID to `config/discord-config.example.json` under `approvers`
2. Update `config/approval-policy.json` with their permissions
3. Grant them access to the 4 Discord channels:
   - #social-drafts (read)
   - #social-approvals (read + write)
   - #social-engagement (read + write)
   - #social-reports (read)
4. Brief them on:
   - Approval actions (approve, edit, hold, reject)
   - Brand voice basics (share SOUL.md)
   - Emergency stop procedure
   - Escalation contacts
5. Have them shadow the primary approver for 1 week
6. Start with reply approvals before graduating to post approvals

---

## Metrics to Track

### Content Performance

- Engagement rate by vertical
- Engagement rate by platform
- Best-performing content types
- Post reach trends
- Save rate (indicates high-value content)

### Operational Health

- Draft-to-publish cycle time
- Approval response time
- Publish success rate
- QA pass rate
- Routine reliability

### System Health

- API error rate
- Token refresh frequency
- Incident frequency and severity
- Emergency stop activations
