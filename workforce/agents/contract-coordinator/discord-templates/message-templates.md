# Discord Message Templates — Contract Coordinator Team

Standard message templates used by Rowan, Sage, Finch, Grove, and Miles when posting to Discord channels.

---

## #acme-contracts-drafts

### Qualified Inquiry Summary

```
🌱 **Qualified Inquiry — {{contract_id}}**

**Buyer:** {{buyer_legal_name}} ({{buyer_state}})
**Trees:** {{line_item_count}} items, est. {{total_usd}}
**Delivery window:** {{delivery_earliest}} → {{delivery_latest}}
**Deposit:** {{deposit_pct}}% via {{deposit_method}}
{{#if high_risk_flags}}
⚠️ **High-risk flags:** {{high_risk_flags}}
{{/if}}

Ready for Sage to draft the wholesale agreement.
```

### Contract Draft Ready for Coordinator Review

```
📄 **Contract Draft Ready — {{contract_id}}**

**Buyer:** {{buyer_legal_name}}
**Total:** ${{total_usd}}
**Deposit:** ${{deposit_usd}} ({{deposit_pct}}%)
**Delivery:** {{delivery_window}}
**Template:** {{template_id}}

DocuSign envelope is staged. Awaiting Rowan's approval before send.

**Actions:**
✅ `approve` — send envelope to buyer
✏️ `edit <notes>` — return to Sage with revision notes
⏸️ `hold` — park for later decision
❌ `reject` — archive, do not send
```

### Deposit Invoice Draft

```
💸 **Deposit Invoice Draft — {{contract_id}}**

**Buyer:** {{buyer_legal_name}}
**Amount:** ${{amount_usd}} (50% of ${{total_usd}})
**Method:** {{method}}
**Due:** {{due_date}}
{{#if cfo_acknowledgement_required}}
⚠️ **CFO acknowledgement required** (amount > $10,000)
{{/if}}

Awaiting Rowan's approval before send.

**Actions:**
✅ `approve` — issue invoice to buyer
✏️ `edit <notes>` — adjust terms
⏸️ `hold` — park for later decision
```

### Daily Signature Sweep Summary

```
🔄 **Daily Signature Sweep — {{date}}**

**Sent today:** {{sent_count}}
**Awaiting signature:** {{pending_count}}
**Reminders sent (+48h):** {{reminder_48h_count}}
**Escalated (+5d):** {{escalated_count}}
**Completed today:** {{completed_count}}

{{#if escalations}}
⚠️ **Escalations posted to #acme-contracts-approvals:** {{escalations}}
{{/if}}
```

---

## #acme-contracts-approvals

### CEO Escalation Card

```
🚨 **Escalation — {{escalation_id}}** ({{kind}})

**Decision needed:** {{decision_needed}}

**Options:**
{{#each options}}
{{@index}}. {{label}} — {{consequence}}
{{/each}}

**Context:** {{context}}

**Rowan recommends:** {{recommended_action}}

**Ledger refs:** {{ledger_references}}

**Reply with:** `1`, `2`, `3`, etc. — or `defer <reason>`
```

### CEO Escalation Timeout Reminder

```
⏰ **Reminder — {{escalation_id}}**

This escalation has been waiting for {{hours_waiting}} hours.
**Decision needed:** {{decision_needed}}
**Rowan recommends:** {{recommended_action}}
```

### Contract Sent Confirmation

```
✅ **Contract Sent — {{contract_id}}**

**Buyer:** {{buyer_legal_name}}
**Envelope:** {{docusign_envelope_id}}
**Sent at:** {{sent_at}}

Sage will monitor signature status and send reminders at +48h and +5d.
```

### Inventory Shortfall

```
🟡 **Inventory Shortfall — {{contract_id}}**

**Requested:** {{requested_summary}}
**Reservable:** {{reservable_summary}}
**Short:** {{short_summary}}

**Substitute available:** {{substitute_summary}}

**Rowan recommends:** {{recommended_action}}

**Options:**
1. Partial fulfill (reserved quantity only, refund difference)
2. Substitute (accept Grove's proposed substitute)
3. Pause (hold contract until restock)
4. Reject (cancel contract, refund deposit)
```

---

## #acme-contracts-delivery

### Route Plan for Review

```
🚐 **Route Plan — {{route_id}}**

**Delivery date:** {{delivery_date}}
**Van capacity used:** {{van_capacity_used_pct}}%
**Stops:** {{stop_count}}
**Total miles:** {{total_miles}}
**Total drive time:** {{total_drive_minutes}} min
**Departure:** {{departure_time}}
**Return:** {{return_time}}

**Stops:**
{{#each stops}}
{{stop_order}}. {{buyer_name}} — {{address}} — ETA {{eta}} ({{miles_from_prev}} mi, {{drive_minutes_from_prev}} min from previous)
{{/each}}

**Google Maps:** {{google_maps_directions_url}}

Awaiting Rowan's approval before per-buyer ETA emails go out.

**Actions:**
✅ `approve` — Miles drafts per-buyer emails
✏️ `edit <notes>` — adjust the route
⏸️ `hold` — park for later decision
```

### Per-Buyer ETA Email Draft

```
✉️ **ETA Email Draft — {{contract_id}}**

**Buyer:** {{buyer_name}} ({{buyer_email}})
**Stop:** {{stop_order}} of {{stop_count}}
**Delivery window:** {{delivery_window_start}} → {{delivery_window_end}}
**Items:** {{items_summary}}
**Balance due:** ${{balance_due_usd}} by {{balance_due_date}}

---
{{body_text}}
---

Awaiting Rowan's approval before send.
```

### Pick List

```
📋 **Pick List — {{pick_list_id}}**

**Route:** {{route_id}}
**Loading date:** {{loading_date}}
**Loading window:** {{loading_window}}
**Van:** {{van_id}}

**Items (walk order):**
{{#each items}}
- Row {{inventory_row}} | {{species}} {{size}} ×{{quantity}} → Stop {{stop_order}} ({{buyer_name}})
{{/each}}

Total items: {{total_items}}
```

---

## #acme-contracts-alerts

### Payment Failure

```
❌ **Payment Failed — {{contract_id}}**

**Kind:** {{kind}} (deposit / balance)
**Amount:** ${{amount_usd}}
**Method:** {{method}}
**Reason:** {{failure_reason}}
**Idempotency key:** {{idempotency_key}}

Contract has been transitioned to `{{new_state}}`. Awaiting Rowan's decision.
```

### Signature Timeout

```
⏰ **Signature Pending Too Long — {{contract_id}}**

**Buyer:** {{buyer_legal_name}}
**Envelope:** {{docusign_envelope_id}}
**Sent:** {{sent_at}}
**Days waiting:** {{days_waiting}}

Escalation packet posted to #acme-contracts-approvals.
```

### Safety Threshold Alert

```
📉 **Inventory at Safety Threshold**

The following species/size pairs are at or below safety threshold:

{{#each items}}
- {{species}} {{size}}: {{on_hand}} on hand, {{reserved}} reserved, {{available}} available (threshold: {{threshold}})
{{/each}}

Coordinator may want to pause new reservations for these items until restock.
```

### Emergency Stop Active

```
🛑 **CONTRACTS PAUSED**

All outbound contract, invoice, and delivery actions have been stopped.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

Drafting and review continue normally. No contracts, invoices, or delivery emails will go out until the stop is lifted.

To resume: set `contracts_enabled: true` in `config/emergency-stop.json`
```

### Emergency Stop Resumed

```
✅ **CONTRACTS RESUMED**

Outbound contract operations have been re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved actions will now proceed.
```

### Ledger Anomaly

```
🟡 **Ledger Anomaly Detected**

**Contract:** {{contract_id}}
**Current state:** {{state}}
**Last transition:** {{last_transition_at}} ({{hours_since_last_transition}}h ago)
**Expected next action:** {{expected_next_action}}

This deal appears stalled. Recommended next step: {{recommended_next_step}}
```
