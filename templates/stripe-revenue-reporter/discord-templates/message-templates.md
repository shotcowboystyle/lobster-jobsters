# Discord Message Templates — Stripe Revenue Reporter

The digest goes only to the digest channel. The alerts channel never carries revenue figures. No message ever contains card digits or full email addresses.

## Daily Digest (digest channel)

```
Yesterday — {date}
  Gross:   {symbol}{gross}  ({gross_change_pct} {comparison})
  Net:     {symbol}{net}
  Refunds: {symbol}{refunds_total} ({refunds_count} events)
  Failed:  {symbol}{failed_total} ({failed_count} attempts) — {customers_needing_retry} customer(s) need a retry
  MRR:     {symbol}{mrr}  ({mrr_delta_signed})
  Top:     {customer_name} ({symbol}{net}), …
Key: {idempotency_key}
```

On-demand ranges use the same layout with `{period_start} – {period_end}` in place of `Yesterday — {date}`.

## Partial Data Notice (alerts channel)

```
⚠️ **Digest skipped** — period {period_start} – {period_end}
Reason: {failure_reason}
No numbers were posted because some Stripe data was missing or errored.
Reply `rerun` once Stripe is healthy.
```

## Key Scope Warning (alerts channel)

```
🛑 **Not running** — the configured Stripe key is not restricted to read-only scopes.
Replace it with a restricted read-only key. Nothing was queried.
```

## Emergency Stop (alerts channel)

```
🛑 **Revenue digest stopped** by {stopped_by} at {stopped_at}
Reason: {reason}
Nothing posts until the owner resumes.
```
