# Discord Message Templates — Booking Search Agent

Replies never include guest personal data. Booking links go to the provider; the traveller books there.

## Result Summary (travel channel)

```
🏨 **{resolved_destination}** · {checkin} → {checkout} · {adults} adults{, children} · {rooms} room(s)
Not the place you meant? Say so and I'll search again.

1. **{name}** — {price_display} · {review_score}/10 ({review_count}) · {feature}
   {url}
2. ...

Showing {n_shown} of {total_count}. I don't book — use the link.
```

## No Results (travel channel)

```
No hotels for {resolved_destination}, {checkin} → {checkout}, {guests}.
Try: {alternate_dates} · fewer guests · a nearby area.
```

## Provider Blocked (travel channel + alerts channel)

```
⚠️ The search provider is limiting requests right now ({reason}).
I've stopped and won't retry around it. Try again later.
```

## Hourly Cap Reached (travel channel)

```
Search is busy — the hourly limit ({hourly_search_cap}) is reached. Try again after {reset_time}.
```

## Emergency Stop (alerts channel)

```
🛑 **Search stopped** by {stopped_by} at {stopped_at}
Reason: {reason}
No searches run until the owner resumes.
```
