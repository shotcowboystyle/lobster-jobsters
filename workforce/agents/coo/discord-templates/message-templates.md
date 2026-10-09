# Discord Message Templates — COO Team (Victor)

Standard message templates used by Victor, Tally, Cedar, Hazel, and Birch.

---

## #acme-ops-drafts

### Daily Inventory Summary

```
🌲 **Inventory Reconciliation — {{date}}**

**Total on hand:** {{totals.total_count}}
**Available:** {{totals.available_count}}
**Reserved:** {{totals.reserved_count}}
**Quarantined:** {{totals.quarantined_count}}
**Sick:** {{totals.sick_count}}

{{#if at_threshold_items}}
**At safety threshold:**
{{#each at_threshold_items}}
- {{species}} {{size}}: {{available}} available (threshold: {{safety_threshold}})
{{/each}}
{{/if}}

**Trailing 30d mortality:** {{mortality_trailing_30d.rate_pct}}% ({{#if mortality_trailing_30d.above_threshold}}⚠️ above 2% threshold{{/if}})
```

### Daily Environmental Summary

```
🏡 **Environmental Check — {{date}}**

{{#each zones}}
**{{zone}}**: temp {{temperature_f}}°F | humidity {{humidity_pct}}% | light {{light_lux}} lux | {{in_range_emoji}} {{status}}
{{#if off_range_metrics}}
  ⚠️ off-range: {{off_range_metrics}} ({{consecutive_off_range_hours}}h)
{{/if}}
{{/each}}

{{#if alerts}}
**Alerts:** see #acme-ops-alerts
{{/if}}
```

### Weekly Route Proposal

```
🚚 **Routes — Week of {{week_of}}**

{{#each routes}}
**Route {{route_id}}** — {{delivery_date}}, {{stop_count}} stops, {{total_miles}} mi
Van capacity: {{van_capacity_used_pct}}% | Drive: {{total_drive_minutes}} min

{{#each stops}}
{{stop_order}}. {{customer_name}} — {{address}} — ETA {{eta}}
{{/each}}

Google Maps: {{google_maps_directions_url}}
{{/each}}

**Actions:** `approve` / `edit <notes>` / `hold` / `reject`
```

### Weekly Workshop Calendar

```
🎓 **Workshop Calendar — Rolling 3 Months**

{{#each workshops}}
- {{scheduled_at}} | **{{title}}** ({{kind}}) — {{registrations_count}}/{{capacity_max}} | instructor: {{instructor_name}} {{instructor_confirmed_emoji}} | materials: {{materials_ready_pct}}%
{{/each}}

{{#if at_risk}}
**At-risk sessions:**
{{#each at_risk}}
- {{workshop_id}}: {{title}} on {{scheduled_at}} — only {{registrations_count}}/{{capacity_min}} registered
{{/each}}
{{/if}}
```

### Weekly Inventory Snapshot

```
🌲 **Weekly Inventory Snapshot — {{as_of}}**

**By species/size:**
| Species | Size | On hand | Reserved | Available | Floor |
|---------|------|---------|----------|-----------|-------|
{{#each by_species_size}}
| {{species}} | {{size}} | {{on_hand}} | {{reserved}} | {{available}} | {{safety_threshold}} {{at_threshold_emoji}} |
{{/each}}

**Health distribution:** A: {{health.grade_a}} | B: {{health.grade_b}} | C: {{health.grade_c}} | Quarantine: {{health.quarantine}}

**Mortality (trailing 30d):** {{mortality.rate_pct}}% ({{mortality.lost_count}}/{{mortality.denominator}})

Shared with Sterling (CFO) for weekly close and Sales for pipeline planning.
```

---

## #acme-ops-approvals

### Inventory Shortfall Escalation

```
🐙 **Inventory Shortfall — {{tree_id_request}}**

**Requested:** {{species}} {{size}} × {{quantity_requested}} for {{channel}} commitment ({{linked_ref}})
**Reservable:** {{quantity_reservable}}
**Short:** {{quantity_short}}

**Tally proposed substitute:** {{substitute_summary}}

**Victor recommends:** {{recommended_action}}

**Options:**
1. Partial fulfill ({{quantity_reservable}} only)
2. Substitute (accept Tally's proposal)
3. Pause until restock
4. Reject the commitment

Reply with: `1`, `2`, `3`, or `4`.
```

### Rental Damage Dispute Escalation

```
🐙 **Rental Damage Dispute — {{rental_id}}**

**Customer:** {{customer_name}}
**Event:** {{event_date}}
**Items damaged:** {{items_damaged}}
**Estimated repair:** ${{estimated_repair_usd}} (> $300 threshold)
**Deposit:** ${{deposit_usd}}

**Victor recommends:** {{recommended_action}}

**Actions:** `approve_assessment` / `waive` / `edit <notes>`
```

### Facility Intervention Approval

```
🐙 **Intervention Approval — {{incident_id}}**

**Kind:** {{kind}}
**Severity:** {{severity}}
**Affected zone:** {{affected_zone}}
**Estimated cost:** ${{estimated_cost_usd}} (> $1K threshold)
**Vendor required:** {{vendor_required}}

**Mitigation plan:** {{mitigation_plan}}

**Victor recommends:** {{recommended_action}}

**Actions:** `approve` / `reject <reason>`
```

### Workshop Cancellation Approval

```
🐙 **Workshop Cancellation — {{workshop_id}}**

**Workshop:** {{title}} on {{scheduled_at}}
**Registrations:** {{registrations_count}}/{{capacity_min}} ({{registration_status}})
**Reason:** {{cancellation_reason}}

**Affected registrants:** {{registrants_to_notify}}

**Victor recommends:** {{recommended_action}}

**Actions:** `approve` / `reschedule <new_date>` / `reject <reason>`
```

---

## #acme-ops-fulfillment

### Delivery Confirmation

```
🚚 **Delivery Confirmation — {{delivery_id}}**

Hi {{customer_name}},

Your bonsai delivery is scheduled for {{scheduled_window_start}} – {{scheduled_window_end}} on {{delivery_date}}.

**Trees:** {{tree_summary}}
**Address:** {{address_short}}

Reply YES to confirm or contact us to reschedule.

— ACME Bonsai
```

### Workshop Reminder (48h)

```
🎓 **Workshop Reminder — {{workshop_title}}**

Hi {{attendee_name}},

Your workshop is in 48 hours: {{scheduled_at}} at {{location}}.

**What to bring:** {{materials_to_bring}}
**Instructor:** {{instructor_name}}

We can't wait to see you!

— Hazel
```

### Rental Pickup Notice

```
🚚 **Pickup Reminder — {{rental_id}}**

Hi {{customer_name}},

Pickup is scheduled for {{return_window_start}} – {{return_window_end}}.

**Trees rented:** {{tree_summary}}
**Pickup address:** {{venue_address_short}}

Reply YES to confirm.

— ACME Bonsai
```

---

## #acme-ops-alerts

### Mortality Alert

```
🚨 **MORTALITY THRESHOLD EXCEEDED**

**Trailing 30d mortality:** {{rate_pct}}% (threshold: 2.0%)
**Trees lost:** {{lost_count}} of {{denominator}}

@Jane — surfacing immediately. Full snapshot in #acme-ops-drafts.

Recommended next step: Tally + Birch root-cause analysis.
```

### Environmental Failure

```
🚨 **ENVIRONMENTAL FAILURE — {{zone}}**

**Off-range metrics:** {{off_range_metrics}}
**Duration:** {{consecutive_off_range_hours}}h (threshold: 6h)
**Current readings:** temp {{temperature_f}}°F | humidity {{humidity_pct}}% | light {{light_lux}} lux

Incident opened: {{incident_id}}
Birch's mitigation plan: {{mitigation_plan}}

@Victor — review now.
```

### Missed Delivery

```
❌ **Delivery Failed — {{delivery_id}}**

**Customer:** {{customer_name}}
**Window:** {{scheduled_window}}
**Reason:** {{failure_reason}}

Cedar drafting customer apology + remediation. Awaiting Victor decision: `reschedule` / `expedite` / `refund`.
```

### Emergency Stop Active

```
🛑 **OPS ACTIONS PAUSED**

All deliveries, rental dispatches, workshop confirmations, and intervention purchases are stopped.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

Internal monitoring (inventory, environmental, safety) continues. To resume: set `ops_actions_enabled: true` in `config/emergency-stop.json`.
```

### Emergency Stop Resumed

```
✅ **OPS ACTIONS RESUMED**

Outbound ops actions re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved actions will now proceed.
```
