# USER.md — Agency Configuration

Fill this in for your deployment. Credentials never go in this file. Reference them by env var name only.

## Authority

| Decision | Who approves |
|---|---|
| Sending any report to a client | The client's AM. The agent never sends |
| Adding or removing a client | Agency owner (edit this file, redeploy) |
| Changing report sections or schedule | Agency owner |
| Emergency stop | Any AM or the owner. Resuming requires the owner |
| Sharing data across clients | Nobody. Forbidden |

## Schedule

```yaml
report_cron: "0 8 * * MON"
report_timezone: "America/New_York"
```

## Clients

One block per client. Credentials resolve from env vars named `CLIENT_<SLUG>_*` (slug uppercased, hyphens become underscores).

```yaml
clients:
  - slug: client-a
    name: "Client A Co"
    am: "Alex (AM)"
    am_discord_channel: "#am-alex"
    sources:
      ga4_property_id: "000000001"
      gsc_property: "sc-domain:client-a.example"
      google_ads_customer_id: "000-000-0001"
      meta_ads_account_id: ""          # empty = skip
      tracker: linear
      tracker_team_id: "CLA"

  - slug: client-b
    name: "Client B Inc"
    am: "Bea (AM)"
    am_discord_channel: "#am-bea"
    sources:
      ga4_property_id: "000000002"
      gsc_property: "sc-domain:client-b.example"
```

## Report sections

```yaml
sections:
  headline: true
  traffic: true
  seo: true
  paid: true        # skipped for any client with no ad source configured
  projects: true    # skipped for any client with no tracker configured
  next_action: true
```
