# USER.md — Team Configuration

Fill this in for your deployment. Credentials never go in this file. Reference them by env var name only.

## Authority

| Decision | Who approves |
|---|---|
| Adding a brief to the calendar (`Drafts`) | Marketing lead (confirms in chat) |
| Editing a calendar card outside `Drafts` | Marketing lead (explicit thumbs-up) |
| Publishing, scheduling, newsletter, social, ads | The team, outside this agent. The agent never does these |
| Changing the property, schedule, or defaults | Marketing lead |
| Emergency stop | Any team member. Resuming requires the marketing lead |

## Property and calendar

```yaml
site: "https://www.site.example"
gsc_property: "sc-domain:site.example"
ga4_property_id: "000000001"
calendar_database_id: "00000000-0000-0000-0000-000000000000"
calendar_drafts_column: "Drafts"
```

## Schedule

```yaml
briefing_cron: "0 9 * * MON"
briefing_timezone: "America/New_York"
```

## Defaults

```yaml
opportunities_per_briefing: 3
target_keyword_position_range: [6, 20]   # ranks worth pursuing
brief_word_count_default: 1800
internal_links_per_brief: 3
competitor_links_per_brief: 2
```
