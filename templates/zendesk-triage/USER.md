# USER.md — Support Team Configuration

Fill this in for your deployment. Credentials never go in this file. Reference them by env var name only.

## Authority

| Decision | Who approves |
|---|---|
| Replying to customers | Support team. The agent never replies |
| Assigning, closing, solving, or merging tickets | Support team. The agent never does any of these |
| Paging on-call for a possible SEV-1 | Support lead |
| Changing categories, assignees, or priority rules | Support lead (edit this file, redeploy) |
| Emergency stop | Any support team member. Resuming requires the support lead |
| Refunds or billing changes | Out of scope for this agent entirely |

## Zendesk

```yaml
zendesk_subdomain: "your-subdomain"          # your-subdomain.zendesk.com
service_user_email: "triage-bot@support.example"
```

## Categories and suggested assignees

The agent suggests an assignee and never assigns.

```yaml
categories:
  billing:
    description: "Charges, invoices, refunds, plan changes"
    suggested_assignee: "@finn"
  technical:
    description: "Bugs, errors, integration issues"
    suggested_assignee: "@dana"
  account:
    description: "Login, SSO, permissions, seats"
    suggested_assignee: "@morgan"
  feature_request:
    description: "Asks for new functionality"
    suggested_assignee: "@morgan"
  unsorted:
    description: "Catch-all when none of the above apply"
    suggested_assignee: "@support-lead"
```

## Priority rules

```yaml
high_priority_signals:
  - "outage"
  - "down"
  - "data loss"
  - "data missing"
  - "cannot access"
  - "billed twice"
free_tier_default_priority: low
paid_tier_default_priority: normal
```

## Daily summary

```yaml
summary_discord_channel: "#support-leads"
summary_cron: "0 9 * * *"
summary_timezone: "America/New_York"
```
