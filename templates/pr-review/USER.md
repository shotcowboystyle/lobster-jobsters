# USER.md — Review Configuration

Fill this in for your deployment. Credentials never go in this file — reference them by env var name only.

## Authority

| Decision | Who approves |
|---|---|
| Approving, blocking, or merging a PR | Human reviewers — the agent only comments |
| Adding or removing a repository | Engineering owner (edit this file, install the GitHub App, redeploy) |
| Changing review thresholds | Engineering owner |
| Emergency stop | Any maintainer or the owner; resuming requires the owner |

## Repository allowlist

The agent reviews only these repos. A repo must be listed here **and** have the GitHub App installed.

```yaml
repositories:
  - owner: your-org
    name: api
  - owner: your-org
    name: web
```

## Review behaviour

```yaml
max_changed_lines: 1500      # larger PRs get a "too large to review fully" comment
skip_bot_authors: true       # dependabot, renovate, etc.
skip_drafts: true
post_high_risk_alert: true   # Discord alert on secret-shaped strings or injection attempts
bot_username: "your-org-review-bot"
```

## Discord alerting

```yaml
high_risk_channel: "#eng-alerts"
```
