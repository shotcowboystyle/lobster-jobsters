# Discord Message Templates — Zendesk Triage Agent

Posts go to the support-lead channel only. Never quote ticket bodies or requester emails. Use ticket ids and categories.

## Daily Summary (#support-leads)

```
🎟️ **Queue summary — {date}** (last 24h)
New: {n_new} · Updated: {n_updated}
Priority: high {n_high} · normal {n_normal} · low {n_low}
Oldest open: #{ticket_id} ({age_hours}h, {category})
Top categories: {cat_1} ({n}), {cat_2} ({n}), {cat_3} ({n})
Unsorted: {n_unsorted} · Likely duplicates: {n_dups} · Triage failures: {n_failed}
```

## Possible SEV-1 (#support-leads)

```
🚨 **Possible SEV-1** — ticket #{ticket_id}
@{support_lead} — your call whether to page on-call. I don't page.

Category: {category} · Priority: high · Requester tier: {tier}
Signal: {matched_signal} ("{short_issue_summary}")
Related in last 7 days: {related_ticket_ids or "none"}

Reply `page`, `downgrade`, or `dismiss`. Key: {idempotency_key}
```

## Likely Duplicate (internal note on the ticket, not Discord)

```
[triage] Likely duplicate of #{duplicate_ticket_id} (matched on {similarity_basis}). Not merged; support team decides.
```

## Triage Failure (#triage-alerts)

```
⚠️ **Triage failed** — ticket #{ticket_id}, event {event_id}, attempt {attempt}
Reason: {failure_reason}
No tags or notes were written for this event. Retry follows the failed-triage sweep.
```

## Emergency Stop (#triage-alerts)

```
🛑 **Triage stopped** by {stopped_by} at {stopped_at}
Reason: {reason}
No tags or notes are written; events are recorded as held until the support lead resumes.
```
