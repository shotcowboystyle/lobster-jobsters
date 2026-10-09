# Discord Message Templates — Chief of Staff Team

Standard message templates used by River, Heron, Wren, Magpie, and Egret.

---

## #acme-exec-briefings

### Weekly Briefing

```
🪶 **Weekly CEO Briefing — {{week_of}}**

**Decision needed:** {{headline_decision}}

{{summary}}

**Key metrics:**
{{#each key_metrics}}
- {{label}}: {{value}}  _(source: {{source_team}}, ref: {{ledger_reference}})_
{{/each}}

**Open blockers:**
{{#each open_blockers}}
- {{label}} — owner: {{owner}}  _(ref: {{ledger_reference}})_
{{/each}}

**River recommends:** {{recommended_action}}

Reply `ack` to acknowledge.
```

### Meeting Agenda for Review

```
📋 **Agenda — {{title}}**

**When:** {{scheduled_for}} ({{duration_minutes}} min)
**Attendees:** {{attendees}}
**Objective:** {{objective}}

**Items:**
{{#each items}}
{{@index}}. **{{topic}}** ({{minutes}} min) — owner: {{owner}}
    Outcome: {{outcome_statement}}
{{#if prior_action_item_ids}}
    Prior action items: {{prior_action_item_ids}}
{{/if}}
{{/each}}

**Actions:**
✅ `approve` — agenda locks
✏️ `edit <notes>` — revise
⏸️ `hold` — defer
```

---

## #acme-exec-actions

### Action-Item Opened

```
🐦 **Action Item Opened — {{action_item_id}}**

**Title:** {{title}}
**Owner:** {{owner}}
**Deadline:** {{deadline}}
**Outcome:** {{outcome_statement}}

{{#if originating_meeting_id}}
From meeting: {{originating_meeting_id}}
{{/if}}
{{#if originating_briefing_id}}
From briefing: {{originating_briefing_id}}
{{/if}}
```

### 24h Follow-Up

```
⏰ **Follow-up — {{action_item_id}}**

**Owner:** {{owner}}
**Title:** {{title}}
**Was due:** {{deadline}} ({{hours_overdue}}h ago)

Reply with status: `in_progress` / `blocked <reason>` / `done <note>` / `drop <reason>`
```

### 72h Escalation to River

```
🚨 **Escalation — {{action_item_id}}**

**Owner:** {{owner}} — silent for {{hours_overdue}}h
**Title:** {{title}}
**Outcome:** {{outcome_statement}}

River: please decide — `reassign`, `drop`, `extend`, or `escalate to Jane`.
```

### Daily Roll-Up

```
🐦 **Open Action Items — {{date}}**

**Total open:** {{total_open}}
**Overdue:** {{overdue_count}}

**By owner:**
{{#each by_owner}}
- {{owner}}: {{open}} open ({{overdue}} overdue)
{{/each}}

**Top 3 oldest:**
{{#each top_oldest}}
{{@index}}. {{action_item_id}} — {{title}} ({{age_days}}d old, owner: {{owner}})
{{/each}}
```

---

## #acme-exec-initiatives

### Sponsor Status Ping

```
🪿 **Status check — {{initiative_id}}**

**Initiative:** {{name}}
**Previous color:** {{previous_health_color}}
**Days since last change:** {{days_since_last_change}}

**Current milestones:**
{{#each milestones}}
- {{name}} ({{target_date}}): {{status}}
{{/each}}

**Sponsor:** {{sponsor}}

Reply by 7:45 PM ET with new color and one-line why. Use `green` / `yellow` / `red`.
```

### Weekly Initiative Dashboard

```
🪿 **Initiative Dashboard — week of {{week_of}}**

{{#each initiatives}}
**{{name}}** — {{health_color_emoji}} {{health_color}} (was {{previous_health_color}})
Sponsor: {{sponsor}} | Status: {{status}} | Days since last change: {{days_since_last_change}}
{{#if stall_flag}}⚠️ stalled{{/if}}
{{summary}}
{{/each}}
```

Health emojis: green = 🟢, yellow = 🟡, red = 🔴

### New Initiative Proposed

```
🪿 **New Initiative Proposed — {{initiative_id}}**

**Name:** {{name}}
**Sponsor:** {{sponsor}}
**Summary:** {{summary}}

**Success criteria:**
{{#each success_criteria}}
- {{this}}
{{/each}}

Jane: `approve` to activate, `reject` to cancel, `edit <notes>` to revise.
```

---

## #acme-exec-alerts

### Agent Health Status Change

```
🪞 **Agent Health Update — {{snapshot_id}}**

**Overall:** {{overall_status_emoji}} {{overall_status}}

{{#if delta.degraded}}
**Degraded:**
{{#each delta.degraded}}
- {{this}}
{{/each}}
{{/if}}
{{#if delta.improved}}
**Improved:**
{{#each delta.improved}}
- {{this}}
{{/each}}
{{/if}}
{{#if delta.new_alerts}}
**New alerts:**
{{#each delta.new_alerts}}
- {{this}}
{{/each}}
{{/if}}

Full snapshot in the executive ledger: {{snapshot_id}}.
```

### Cross-Team Escalation (River → Jane)

```
🚨 **Escalation — {{escalation_id}}**

**From:** {{source_team}}
**Kind:** {{kind}}

**Decision needed:** {{decision_needed}}

**Options:**
{{#each options}}
{{@index}}. {{label}} — {{consequence}}
{{/each}}

**Context:** {{context}}

**River recommends:** {{recommended_action}}

**Ledger refs:** {{ledger_references}}

Reply with `1`, `2`, `3`, etc. — or `defer <reason>`.
```

### Emergency Stop Active

```
🛑 **EXEC ESCALATIONS PAUSED**

All outbound briefings, action-item pings, initiative updates, and health alerts have been stopped.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

Drafting and ledger writes continue normally. No outbound posts until the stop is lifted.

To resume: set `escalations_enabled: true` in `config/emergency-stop.json`
```

### Emergency Stop Resumed

```
✅ **EXEC ESCALATIONS RESUMED**

Outbound exec communications have been re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued briefings and pings will now proceed.
```
