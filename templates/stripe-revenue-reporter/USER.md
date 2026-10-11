# USER.md — Revenue Digest Configuration

Fill this in for your deployment. Credentials never go in this file. Reference them by env var name only.

## Authority

| Decision | Who approves |
|---|---|
| Changing the digest channel or its audience | Owner |
| Changing schedule, currency, or sections | Owner |
| Emergency stop | Owner or finance lead. Resuming requires the owner |
| Any Stripe write (refund, charge, capture, modify) | Nobody. Out of scope for this agent |
| Posting customer PII | Nobody. Forbidden |

## Channel

```yaml
digest_channel: "#revenue"
alerts_channel: "#revenue-alerts"
```

## Schedule

```yaml
digest_cron: "0 9 * * *"     # 09:00 every day
digest_timezone: "America/New_York"
```

## Presentation

```yaml
currency: USD
currency_symbol: "$"
top_customers_count: 5
include_failed_payments: true
include_mrr: true
comparison: week_over_week   # week_over_week | month_over_month
```
