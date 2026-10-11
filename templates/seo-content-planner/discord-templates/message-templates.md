# Discord Message Templates — SEO Content Planner

## Weekly Briefing (#seo-briefings)

```
📝 **SEO briefing — week of {week_start}**

**Opportunities**
1. `{keyword}`: #{position}, impressions {impressions_7d} ({delta} WoW). {why}
2. …
3. …

**Risk:** {url} sessions {sessions_7d} vs {sessions_prior_7d}. {likely_cause}
**Win:** {url} sessions {sessions_7d} vs {sessions_prior_7d}

Missing sources: {sources_missing or "none"}
Reply `brief: <keyword>` for a full brief.
```

## Brief Card (#seo-drafts)

```
📝 **Brief — `{target_keyword}`** ({search_intent}) · {brief_id}

**H1:** {h1}
**H2s:** {h2s}
**Internal links:** {internal_links}
**Outrank:** {competitor_url} (#{position}) — gap: {gap}
**Words:** {word_count} · **Meta:** {meta_description}
Data: #{current_position}, impressions {impressions_7d} vs {impressions_prior_7d}
Notes: {notes or "none"}

Reply `confirm` to add to the calendar (Drafts), `revise: <notes>`, or `reject`.
```

## Calendar Confirmation (#seo-drafts)

```
✅ Added to calendar (Drafts): {calendar_card_url}
Brief {brief_id} · confirmed by {confirmed_by} · key {idempotency_key}
```

## Alert (#seo-alerts)

```
⚠️ **{kind}** — {detail}
kind: source_failed | calendar_write_failed | competitor_text_flagged | robots_disallowed
Nothing was published. {next_step}
```

## Emergency Stop (#seo-alerts)

```
🛑 **Planner stopped** by {stopped_by} at {stopped_at}
Reason: {reason}
No calendar writes or posts until the marketing lead resumes.
```
