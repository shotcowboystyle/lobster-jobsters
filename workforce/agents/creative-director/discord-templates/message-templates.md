# Discord Message Templates — Creative Director Team (Masahiko)

Standard message templates used by Masahiko, Hana, Iris, and Mira.

---

## #acme-creative-drafts

### Daily Brief Triage Summary

```
🦌 **Brief Triage — {{date}}**

**New triaged today:** {{triaged_count}}
{{#each by_kind}}
- {{kind}}: {{count}}
{{/each}}

**Routed to Jane (>$2K):** {{ceo_route_count}}
**Deferred:** {{deferred_count}}
**Rejected:** {{rejected_count}}

{{#if rejected_count}}
**Rejected — reasons:**
{{#each rejected_summary}}
- {{brief_id}}: {{rationale}}
{{/each}}
{{/if}}
```

### Deliverable Submitted for Review

```
🌸 **Deliverable — {{deliverable_id}}** ({{kind}})

**Brief:** {{brief_id}} — {{brief_title}}
**Owner:** {{owner}}
**Revision round:** {{revision_count}}

**Rationale:** {{rationale}}

**Brand system references:** {{brand_system_references}}

**Self-checklist:** {{self_checklist_summary}}

[Files]({{files_url}})

**Actions:** `approve` / `revising <feedback>` / `reject <reason>`
```

### Photo Proofs Ready

```
📷 **Photo Proofs — {{shoot_id}}** ({{kind}})

**Subject:** {{subject_summary}}
**Photographer:** {{photographer}}
**Captured at:** {{captured_at}}
**Honest representation:** {{honest_representation_check}}

[Edited files]({{edited_files_location}})

**Actions:** `approve` / `revising <feedback>` / `reject <reason>`
```

### Care Guide Ready for CD Review

```
📘 **Care Guide — {{guide_id}}** ({{kind}})

**Title:** {{title}}
**Audience:** {{target_audience}}
**Format:** {{format}}

**Technical review (Care Education):** {{technical_review_status}}
**Sections:** {{section_count}}

[Draft]({{guide_url}})

**Actions:** `approve` / `revising <feedback>` / `reject <reason>`
```

### Weekly Creative Output Report

```
🦌 **Weekly Creative Output — Week of {{week_of}}**

**Decision needed:** {{headline_recommendation}}

**Delivered this week:** {{delivered_count}}
{{#each by_kind}}
- {{kind}}: {{count}}
{{/each}}

**In-progress:** {{in_progress_count}}
**Brand drift signals (resolved):** {{drift_resolved_count}}
**Brand drift signals (open):** {{drift_open_count}}

**Next week's top 3 priorities:**
{{#each top_priorities}}
{{@index}}. {{title}} — owner {{owner}}, deadline {{deadline}}
{{/each}}

**Masahiko recommends:** {{recommendation}}

Cross-posted summary sent to CMO and Director of Sales.
```

---

## #acme-creative-approvals

### Large Project Approval

```
🦌 **Approval Needed — Large Creative Project** ({{brief_id}})

**Title:** {{title}}
**Requester:** {{requester}} ({{requester_team}})
**Purpose:** {{purpose}}
**Kind:** {{kind}}

**Estimated:** {{estimated_hours}}h / ${{estimated_cost_usd}} (>$2K threshold)
**Deadline:** {{deadline}}

**Masahiko recommends:** {{recommendation}}

**Actions:** `approve` / `defer` / `reject <reason>` / `edit <notes>`
```

### Rebranding Approval

```
🦌 **Approval Needed — Rebranding / Identity Change**

**Scope:** {{scope}}
**Rationale:** {{rationale}}
**Impact analysis:** {{impact_summary}}
**Estimated retrofit:** {{retrofit_hours}}h / ${{retrofit_cost_usd}}

**Masahiko recommends:** {{recommendation}}

**Actions:** `approve` / `reject <reason>` / `edit <notes>`
```

### Brand System Update Approval

```
🦌 **Approval Needed — Brand System Update** ({{update_id}})

**Kind:** {{kind}}
**Scope:** {{scope}}

**Current state:** {{current_state}}
**Proposed state:** {{proposed_state}}

**Affected touchpoints:** {{affected_touchpoints}}
**Affected existing assets:** {{affected_assets_count}}
**Estimated retrofit:** {{estimated_retrofit_hours}}h

**Approval path:** {{approval_path}}
**Masahiko + Jane must both approve.**

**Actions:** `approve` / `reject <reason>` / `edit <notes>`
```

### Conflicting Priorities Escalation

```
🦌 **Approval Needed — Conflicting Priorities**

**Conflict:** {{conflict_summary}}
**Affected briefs:** {{affected_brief_ids}}
**Affected deadlines:** {{affected_deadlines}}

**Options:**
{{#each options}}
{{@index}}. {{label}} — consequence: {{consequence}}
{{/each}}

**Masahiko recommends:** {{recommendation}}

**Actions:** Reply with option number, or `defer <reason>`.
```

---

## #acme-creative-library

### Asset Added to Library

```
🌸 **Asset Added — {{asset_id}}** ({{kind}})

**Title:** {{title}}
**Tags:** {{tags}}
**Source:** {{source_summary}}
**Version:** {{version}}

[Library entry]({{library_url}})
```

### Brand System Updated

```
🦌 **Brand System Published — {{update_id}}**

**Kind:** {{kind}}
**Scope:** {{scope}}
**Effective:** {{published_at}}

**What changed:** {{change_summary}}
**Action needed:** {{retrofit_briefs_summary}}

Reference: [Updated style guide]({{style_guide_url}})
```

### Weekly Asset Library Audit

```
🌸 **Asset Library Audit — Week of {{week_of}}**

**Total assets:** {{total_count}}
**Added this week:** {{added_this_week_count}}
**Archived this week:** {{archived_this_week_count}}

**By kind:**
{{#each by_kind}}
- {{kind}}: {{count}}
{{/each}}

**Hygiene:**
- Duplicates flagged: {{duplicate_flag_count}}
- Missing metadata: {{missing_metadata_count}}
```

---

## #acme-creative-alerts

### Brand Drift Detected

```
⚠️ **Brand Drift Detected — {{surface}}**

**Touchpoint:** {{touchpoint}}
**Drift kind:** {{drift_kind}} (off-palette / unauthorized font / missing logo treatment / low contrast / other)
**Severity:** {{severity}}

**Detected at:** {{detected_at}}
**Source:** {{detection_source}}

**Hana recommends:** {{recommended_action}}

@Masahiko — review.
```

### Off-Brand Publication

```
🔴 **Off-Brand Publication — {{asset_id}}**

**Where:** {{surface}}
**Published by:** {{publisher_team}}
**Issue:** {{issue_summary}}

**Recommended action:** {{recommended_action}}

@Masahiko + @Jane if rebrand-level
```

### Missed Deadline

```
⏰ **Deadline Missed — {{brief_id}}**

**Title:** {{title}}
**Requester:** {{requester}}
**Original deadline:** {{deadline}}
**Owner:** {{owner}}
**Current status:** {{status}}

**Hours overdue:** {{hours_overdue}}

**Masahiko's note:** {{recommendation}}
```

### Photo Release Missing

```
⚠️ **Photo Release Missing — {{shoot_id}}**

**Scheduled:** {{scheduled_at}}
**Venue:** {{venue_name}} ({{owner_kind}})
**Release status:** unsigned

Cannot dispatch shoot. Iris must obtain release before {{scheduled_at}}.
```

### Emergency Stop Active

```
🛑 **CREATIVE PUBLICATION PAUSED**

All asset publication (web, social, email) is stopped. Capture + edit + draft + library archive continue.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

To resume: set `publish_assets_enabled: true` in `config/emergency-stop.json`.
```

### Emergency Stop Resumed

```
✅ **CREATIVE PUBLICATION RESUMED**

Publication re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved assets will now publish.
```
