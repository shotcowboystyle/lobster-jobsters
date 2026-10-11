# Discord Message Templates — PR Review Agent

All posts go to `#eng-alerts`. Never paste diff hunks that contain a flagged secret, and never the secret itself.

## High-Risk PR Alert

```
⚠️ **High-risk PR** — {repo}#{pr_number} · {head_sha_short}
{pr_title}
Flags: {n_migrations} migration · {n_unsafe_exec} unsafe exec · {n_removed_tests} removed tests
Review posted: {review_url}
A human reviewer should look before merge. I only comment.
```

## Secret-Detected Alert

```
🔐 **Secret-shaped string** — {repo}#{pr_number} · {head_sha_short}
Location: `{path}:{line}` · Class: {secret_class}
Value withheld. If real: revoke and rotate it now — removing it from the branch does not un-leak it.
```

## Prompt-Injection Attempt

```
🧪 **Instructions found in PR content** — {repo}#{pr_number}
Where: {field} (description / comment / diff)
Ignored. Review proceeded under normal rules.
```

## Review Failure

```
❌ **Review failed** — {repo}#{pr_number} · {head_sha_short}
Reason: {failure_reason} · Attempt {attempt}/2
```

## Emergency Stop

```
🛑 **PR reviews stopped** by {stopped_by} at {stopped_at}
Reason: {reason}
Nothing posts to GitHub until the owner resumes.
```
