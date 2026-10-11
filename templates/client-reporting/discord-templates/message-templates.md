# Discord Message Templates — Client Reporting Agent

Drafts go only to the client's own thread in its AM's channel. The alerts channel never carries client metrics.

## Draft Card (AM channel, client thread)

```
📊 **Weekly report draft — {client_name}** · week of {week_start}
@{am} — review, edit, and send to the client yourself. I don't send.

**{headline}**

**Traffic** — {traffic_summary}
• {metric}: {value} ({delta} vs {comparison})

**SEO** — {seo_summary}
▲ {query}: {prior_position} → {position}
▼ {query}: {prior_position} → {position}

**Paid** — {paid_summary}
**Projects** — {projects_summary}

**Next week:** {next_action}

Skipped sources: {sources_skipped or "none"}
Reply `sent`, `redraft: <notes>`, or `discard`. Key: {idempotency_key}
```

## Missing Credential Alert (alerts channel)

```
⚠️ **Source skipped** — client `{client_slug}`, source `{source}`, reason `{reason}`
The draft went out without this section. No other client's credentials were used.
Fix: set `CLIENT_{SLUG}_{INTEGRATION}` in the secrets manager.
```

## Run Summary (alerts channel)

```
📋 **Weekly run — {week_start}**
Drafted: {n_drafted} · Skipped (already existed): {n_existing} · Failed: {n_failed}
Source skips: {n_skips} (details in client threads)
Waiting on AM > 48h from last week: {n_stale}
```

## Emergency Stop (alerts channel)

```
🛑 **Reporting stopped** by {stopped_by} at {stopped_at}
Reason: {reason}
Drafts stay local; nothing posts until the owner resumes.
```
