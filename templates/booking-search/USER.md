# USER.md — Booking Search Configuration

Per-instance config, not credentials. Provider keys live in your secrets manager.

## Authority

| Decision | Who approves |
|---|---|
| Choosing or changing the search provider skill | Owner |
| Changing caps or defaults | Owner |
| Booking or paying | The traveller, outside this agent |
| Emergency stop | Any user of the channel or the owner. Resuming requires the owner |

## Defaults

```yaml
default_currency: USD          # ISO code; falls back to the provider default if unset
default_adults: 2
default_rooms: 1
default_results_shown: 6       # 1–10
hourly_search_cap: 30
```

## Channel routing (optional)

Leave empty to answer everywhere the agent is connected.

```yaml
allowed_channels:
  - discord:#travel
```

## Behaviour

```yaml
suggest_alternate_dates: true  # when total_count = 0
score_floor: 7.0               # results below this are listed last
```
