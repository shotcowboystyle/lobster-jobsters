# Discord Message Templates

Standard message templates used by agents when posting to Discord channels.

---

## #social-drafts

### Weekly Calendar Delivery

```
📅 **Weekly Content Calendar — Week of {{week_start}}**

{{#each entries}}
**{{day_of_week}} {{date}}**
{{#each day_posts}}
- {{platform_emoji}} | {{vertical}} | "{{theme}}" | Assets: {{asset_needs}}
{{/each}}
{{/each}}

📝 **Strategy Notes:** {{strategy_notes}}
⏳ Awaiting operator approval before briefs are generated.
{{#if placeholders}}
⚠️ **Placeholders needing input:** {{placeholders}}
{{/if}}
```

Platform emojis: IG = 📸, FB = 📘

### Post Brief Delivery

```
📋 **Post Brief — {{post_id}}**

**Platform:** {{platform}} | **Vertical:** {{vertical}}
**Scheduled:** {{scheduled_date}}
**Theme:** {{theme}}

**Key Messages:**
{{#each key_messages}}
• {{this}}
{{/each}}

**Visual Direction:** {{visual_direction}}
**CTA:** {{cta_direction}}
**Tone:** {{tone_reminder}}
{{#if placeholders}}
⚠️ **Placeholders:** {{placeholders}}
{{/if}}
```

### Draft Caption Delivery

```
✍️ **Draft Caption — {{post_id}}** (revision {{revision_number}})

**Platform:** {{platform}} | **Vertical:** {{vertical}}
**Scheduled:** {{scheduled_date}}

---
{{caption_text}}
---

{{#if hashtags}}
**Hashtags:** {{hashtags}}
{{/if}}
{{#if placeholders}}
⚠️ **Placeholders:** {{placeholders}}
{{/if}}

Sending to Brand QA for review...
```

### QA Pass

```
✅ **QA Pass — {{post_id}}**

All checks passed. Sending to approval queue.
{{#if high_risk_flags}}
⚠️ **Flags for human attention:** {{high_risk_flags}}
{{/if}}
```

### QA Fail

```
❌ **QA Failed — {{post_id}}**

**Issues:**
{{#each issues}}
• {{this}}
{{/each}}

**Revision Instructions:** {{revision_instructions}}

Returning to Copywriter for revision.
```

---

## #social-approvals

### Approval Card

```
📋 **Approval Request — {{post_id}}**

**Platform:** {{platform_emoji}} {{platform}}
**Vertical:** {{vertical}}
**Scheduled Date:** {{scheduled_date}}
**QA Status:** {{qa_status_emoji}} {{qa_status}}

---

{{caption_text}}

---

{{#if hashtags}}
**Hashtags:** {{hashtags}}
{{/if}}
**Visual Asset:** {{visual_asset_status_emoji}} {{visual_asset_status}}
{{#if placeholders}}
⚠️ **Unresolved Placeholders:** {{placeholders}}
{{/if}}
{{#if qa_flags}}
⚠️ **QA Flags:** {{qa_flags}}
{{/if}}

---

**Actions:**
✅ `approve` — send to Publisher for scheduling
✏️ `edit <notes>` — return to Copywriter with revision notes
⏸️ `hold` — park for later decision
❌ `reject` — archive, do not publish
```

### Approval Timeout Reminder

```
⏰ **Reminder — {{post_id}}**

This approval request has been waiting for {{hours_waiting}} hours.
Scheduled date: {{scheduled_date}}

Please respond with: `approve`, `edit <notes>`, `hold`, or `reject`
```

### Publish Success

```
✅ **Published — {{post_id}}**

**Platform:** {{platform_emoji}} {{platform}}
**Post ID:** {{platform_post_id}}
**Published at:** {{published_at}}

Post is now live and entering monitoring phase.
```

### Publish Failure

```
❌ **Publish Failed — {{post_id}}**

**Platform:** {{platform_emoji}} {{platform}}
**Error:** {{error_message}}
**Attempt:** {{attempt}} of 3
**Idempotency Key:** {{idempotency_key}}

{{#if retriable}}
Next retry in {{retry_delay}}. Operator: {{suggested_action}}
{{else}}
⚠️ **Non-retriable error.** Manual intervention required.
{{/if}}
```

### Emergency Stop Alert

```
🛑 **PUBLISHING PAUSED**

All outbound publishing has been stopped.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

Drafting and planning continue normally. No posts will be published until the stop is lifted.

To resume: set `publishing_enabled: true` in `config/emergency-stop.json`
```

### Emergency Resume Alert

```
✅ **PUBLISHING RESUMED**

Publishing has been re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved posts will now proceed to publishing.
```

---

## #social-engagement

### Engagement Alert (Actionable)

```
💬 **Engagement Alert — {{post_id}}**

**Type:** {{alert_type}} | **Classification:** 🟡 Actionable
**Platform:** {{platform_emoji}} {{platform}}
**From:** @{{commenter_handle}}
**Their message:**
> {{comment_text}}

**Context:** {{vertical}} post — "{{post_theme}}"
**Suggested Action:** Queue for reply draft

📊 **Post Metrics (current):**
Likes: {{likes}} | Comments: {{comments}} | Saves: {{saves}} | Reach: {{reach}}
```

### Engagement Alert (Negative)

```
🔴 **Negative Engagement — {{post_id}}**

**Type:** {{alert_type}} | **Classification:** 🔴 Negative
**Platform:** {{platform_emoji}} {{platform}}
**From:** @{{commenter_handle}}
**Their message:**
> {{comment_text}}

⚠️ **Requires operator attention.** Reply draft will be generated but flagged for sensitivity review.
```

### Engagement Alert (Crisis)

```
🚨 **CRISIS ALERT — {{post_id}}**

**Classification:** 🔴 Crisis
**Platform:** {{platform_emoji}} {{platform}}
**Details:** {{description}}

**Immediate actions needed:**
1. Review the situation in the platform directly
2. Consider activating emergency stop if needed
3. Do NOT respond via automated systems

@here — Operator attention required immediately.
```

### Reply Draft

```
💬 **Reply Draft — {{post_id}}**

**Replying to:** @{{commenter_handle}}
**Their message:**
> {{original_comment}}

**Drafted reply:**
> {{drafted_reply}}

**Context:** {{vertical}} — {{classification}}
{{#if placeholders}}
⚠️ **Placeholders:** {{placeholders}}
{{/if}}
{{#if flags}}
⚠️ **Flags:** {{flags}}
{{/if}}

**Actions:**
✅ `approve` — operator posts reply manually
✏️ `edit <revised text>` — modify the reply
❌ `skip` — do not reply
```

---

## #social-reports

### Weekly Report

```
📊 **Weekly Performance Report — {{week_start}} to {{week_end}}**

### Publishing Summary
- Published: {{total_published}} posts ({{instagram_count}} IG, {{facebook_count}} FB)
- Failed: {{failed_count}} | Rejected: {{rejected_count}} | Held: {{held_count}}
- Avg draft-to-publish: {{avg_hours}}h

### Top Performer
🏆 {{top_post_id}}
{{top_post_caption_preview}}
Engagement rate: {{top_engagement_rate}}% | Reach: {{top_reach}}

### Vertical Breakdown
| Vertical | Posts | Avg Engagement |
|----------|-------|---------------|
{{#each vertical_performance}}
| {{vertical}} | {{posts}} | {{avg_engagement_rate}}% |
{{/each}}

### Platform Comparison
| Platform | Avg Engagement | Avg Reach |
|----------|---------------|-----------|
| Instagram | {{ig_engagement}}% | {{ig_reach}} |
| Facebook | {{fb_engagement}}% | {{fb_reach}} |

### Recommendations
{{#each recommendations}}
{{@index}}. {{this}}
{{/each}}

### System Health
- Publish failures: {{publish_failures}}
- Approval timeouts: {{approval_timeouts}}
- Incidents: {{incidents}}
```
