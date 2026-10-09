# Discord Message Templates — CEO Team (Apex)

Standard message templates used by Apex, Compass, Almanac, Atlas, and Envoy.

---

## #acme-ceo-strategy

### Weekly Strategic Question

```
🧭 **Strategic Question — Week of {{week_of}}**

{{headline}}

**Trade-off:**
- If we choose A: {{trade_off.if_we_choose_a}}
- If we choose B: {{trade_off.if_we_choose_b}}
{{#if trade_off.third_path}}
- Third path: {{trade_off.third_path}}
{{/if}}

**Context:** {{context}}

**Signals driving this question:**
{{#each source_signals}}
- {{team}}: {{signal}}  _(ref: {{ledger_reference}})_
{{/each}}

{{#if what_would_change_my_mind}}
**What would change the calculus:** {{what_would_change_my_mind}}
{{/if}}

No SLA — answer when you've thought it through. Reply `answer: <text>`, `defer <reason>`, or `drop <reason>`.
```

### Decision Pattern Note (Sunday 9:30 PM)

```
🧭 **Pattern Note — past 90 days**

**Recurring decision types:**
{{#each recurring_kinds}}
- {{kind}}: {{count}} entries
{{/each}}

**Recurring trade-offs:**
{{#each recurring_trade_offs}}
- {{trade_off_label}} ({{count}} decisions)
{{/each}}

Supplemental context for this week's question.
```

---

## #acme-ceo-decisions

### Decision Entry Draft

```
📓 **Decision Entry — {{decision_id}}**

**Headline:** {{headline}}
**Decided at:** {{decided_at}}
**Reversibility:** {{reversibility}}
**Horizon:** {{horizon}}

**Alternatives considered:**
{{#each alternatives_considered}}
- {{label}} — why not chosen: {{why_not_chosen}}
{{/each}}

**Choice made:** {{choice_made}}

**Rationale:** {{rationale}}

{{#if what_would_change_my_mind}}
**What would change your mind:** {{what_would_change_my_mind}}
{{/if}}

{{#if outcome_window_end}}
**Outcome window:** I'll reopen this entry on {{outcome_window_end}}.
{{/if}}

**Actions:** `ack` / `edit <notes>` / `drop <reason>`
```

### Outcome Window Reminder

```
📓 **Outcome Window Open — {{decision_id}}**

**Decision:** {{headline}}
**Made on:** {{decided_at}}
**Expected outcome:** {{expected_outcome}}

What actually happened? Reply with:
- `outcome <text>` plus one of: `better` / `as_expected` / `worse` / `different_axis`
- Plus a one-line reflection if you have one
- Or `inconclusive <reason>` if it's not clear yet
```

### Outcome Captured Confirmation

```
📓 **Outcome Captured — {{decision_id}}**

**Decision:** {{headline}}
**Outcome:** {{outcome_text}} ({{outcome_vs_expected}})
{{#if reflection_note}}
**Reflection:** {{reflection_note}}
{{/if}}
**Would decide again:** {{would_decide_again}}

Entry will archive in 30 days.
```

---

## #acme-ceo-memos

### Memo Draft for Review

```
🗺️ **Memo Draft — {{memo_id}}** ({{kind}})

**Headline:** {{headline}}
**Audience:** {{audience}}
**Word count:** {{word_count}} / {{soft_cap}}
**Revision round:** {{revision_round}}

---
{{body_markdown}}
---

**Supporting references:** {{supporting_references}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### External Comm Draft for Review

```
📨 **External Comm Draft — {{comm_id}}**

**To:** {{recipient.name}} ({{recipient.organization}}) <{{recipient.email}}>
**Stakeholder kind:** {{stakeholder_kind}}
**Channel:** {{channel}}
{{#if linked_memo_id}}
**Linked memo:** {{linked_memo_id}}
{{/if}}
{{#if prior_comm_history}}
**Prior comms in thread:** {{prior_comm_history}}
{{/if}}

**Subject:** {{subject}}

---
{{body_text}}
---

**Idempotency key:** {{idempotency_key}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### External Comm Sent Confirmation

```
📨 **External Comm Sent — {{comm_id}}**

**To:** {{recipient.name}} <{{recipient.email}}>
**Subject:** {{subject}}
**Sent at:** {{sent_at}}
**Provider message ID:** {{provider_message_id}}
```

### Stakeholder Record Add Request

```
📨 **Add Stakeholder — {{stakeholder_record_id}}**

**Name:** {{name}}
**Organization:** {{organization}}
**Email:** {{email}}
**Kind:** {{kind}}
**Relationship summary:** {{relationship_summary}}
**Cadence:** {{communication_cadence}}

**Actions:** `approve` to add / `reject <reason>` / `edit <notes>`
```

---

## #acme-ceo-alerts

### External Comm Send Failure

```
❌ **External Comm Failed — {{comm_id}}**

**To:** {{recipient.email}}
**Subject:** {{subject}}
**Reason:** {{failure_reason}}
**Idempotency key:** {{idempotency_key}}
**Attempt:** {{attempt}} of 3

Awaiting your decision: `retry`, `void`, or `redraft`.
```

### Stale Memo Roll-Up (Daily 7 PM)

```
⏰ **Stale Memos / Comms — {{date}}**

**Memos in ceo_review > 72h:**
{{#each stale_memos}}
- {{memo_id}} — {{headline}} ({{hours_in_review}}h waiting)
{{/each}}

**Comms in ceo_review > 24h:**
{{#each stale_comms}}
- {{comm_id}} — {{subject}} ({{hours_in_review}}h waiting)
{{/each}}

No auto-progress. Reply to each as appropriate.
```

### Emergency Stop Active

```
🛑 **CEO EXTERNAL COMMS PAUSED**

All Envoy outbound has been stopped. Atlas drafts continue but cannot transition to delivered.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

Compass and Almanac continue normally (internal-only).

To resume: set `external_comms_enabled: true` in `config/emergency-stop.json`
```

### Emergency Stop Resumed

```
✅ **CEO EXTERNAL COMMS RESUMED**

External comms re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved comms will now send.
```
