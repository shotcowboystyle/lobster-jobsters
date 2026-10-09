# Discord Message Templates — CTO Team (Allen)

Standard message templates used by Allen, Pixel, Forge, and Bastion.

---

## #acme-tech-drafts

### Daily Feature Triage Summary

```
🎯 **Feature Triage — {{date}}**

**New `triaged` today:** {{triaged_count}}
{{#each by_domain}}
- {{domain}}: {{count}}
{{/each}}

**Routed to Jane (>40h or >$3K):** {{ceo_route_count}}
**Deferred:** {{deferred_count}}
**Rejected:** {{rejected_count}}

{{#if rejected_count}}
**Rejected — reasons:**
{{#each rejected_summary}}
- {{feature_id}}: {{rationale}}
{{/each}}
{{/if}}
```

### Spec Draft for Review

```
⚙️ **Spec Draft — {{spec_id}}** (feature: {{feature_id}})

**Owner:** {{owner}}
**Summary:** {{summary}}

**Data model changes:** {{data_model_changes_count}}
**API changes:** {{api_changes_count}} ({{breaking_count}} breaking)
**UI changes:** {{ui_changes_count}}
**Infra changes:** {{infra_changes_count}}

**Estimated:** {{estimated_hours}}h / ${{estimated_cost_usd}}

**Dependencies:** {{dependencies}}

**Actions:** `accept` / `edit <notes>` / `reject <reason>`
```

### Daily Backend Health

```
⚙️ **Backend Health — {{date}}**

**DB:** connection pool {{db_pool_status}} | slow queries {{slow_query_count}} (>1s) | replication lag {{replication_lag_ms}}ms
**APIs (p95):** {{p95_latency_ms}}ms | error rate {{error_rate_pct}}%
**Stripe webhooks:** delivery {{stripe_delivery_pct}}% | retries {{stripe_retry_count}}
**Background jobs:** queue depth {{queue_depth}} | failed last 24h {{failed_jobs_24h}}

{{#if alerts}}
⚠️ Alerts posted in #acme-tech-alerts
{{/if}}
```

### Weekly Tech Debt Register

```
🎯 **Tech Debt Register — Week of {{week_of}}**

**Total tracked:** {{total_count}}
**By priority:** high {{high_count}} | medium {{medium_count}} | low {{low_count}}
**Scheduled this quarter:** {{scheduled_count}}
**Deferred this quarter:** {{deferred_count}}
**Cumulative interest paid this week:** ${{interest_paid_week_usd}}

**Top 3 by interest rate:**
{{#each top_three}}
{{@index}}. {{debt_id}}: {{title}} — {{interest_rate_pct_monthly}}%/mo, principal {{principal_estimate_hours}}h
{{/each}}
```

### Weekly Platform Report

```
🎯 **Weekly Platform Report — Week of {{week_of}}**

**Decision needed:** {{headline_recommendation}}

**Uptime:** {{uptime_pct}}% (target 99.9%) {{slo_emoji}}
**API p95 latency:** {{p95_ms}}ms (target <500ms) {{latency_emoji}}
**Error rate:** {{error_rate_pct}}% (target <1%) {{error_emoji}}

**Releases shipped:** {{releases_count}}
**Incidents:** SEV-1 {{sev1_count}} | SEV-2 {{sev2_count}} | SEV-3+ {{sev3_plus_count}}
**Median MTTR:** {{median_mttr_minutes}} min

**Security:** {{security_findings_opened}} opened | {{security_findings_closed}} closed
**Tech debt:** {{debt_resolved_count}} resolved | top item: {{top_debt_summary}}

**Allen recommends:** {{recommendation}}

Cross-posted summary sent to Sterling (CFO).
```

---

## #acme-tech-approvals

### Large Feature Approval Request

```
🎯 **Approval Needed — Large Feature** ({{feature_id}})

**Title:** {{title}}
**Requester:** {{requester}} ({{requester_team}})
**Purpose:** {{purpose}}

**Estimated:** {{estimated_hours}}h / ${{estimated_cost_usd}} (threshold: 40h / $3K)
**Priority:** {{priority}}
**Deadline:** {{deadline}}

**Allen recommends:** {{recommendation}}

**Actions:** `approve` / `defer <until>` / `reject <reason>` / `edit <notes>`
```

### Major Release Approval

```
🎯 **Approval Needed — Major Release** ({{release_id}})

**Title:** {{title}}
**Kind:** {{kind}}
**Scheduled:** {{scheduled_at}}
**Deploy window check:** {{deploy_window_check}}
**Backup verified:** {{backup_verified}} ({{backup_verified_at}})
**Staging QA:** {{staging_qa_status}}
**Rollback plan:** documented ✅

**Changes:**
- {{pr_count}} PRs
- Features: {{feature_ids_summary}}

**Allen recommends:** {{recommendation}}

**Actions:** `approve` / `hold <reason>` / `reject <reason>`
```

### SaaS Addition Approval

```
🎯 **Approval Needed — SaaS Addition** > $200/mo

**Service:** {{service_name}}
**Monthly cost:** ${{monthly_cost_usd}}
**Purpose:** {{purpose}}
**Owner agent:** {{owner_agent}}
**Alternatives considered:** {{alternatives_summary}}

**Allen recommends:** {{recommendation}}

**Cross-coordination:** Sterling (CFO) informed for budget tracking.

**Actions:** `approve` / `reject <reason>` / `edit <notes>`
```

### Rollback Approval

```
🚨 **Approval Needed — Production Rollback** ({{release_id}})

**Release:** {{title}}
**Deployed at:** {{deployed_at}}
**Reason for rollback:** {{rollback_reason}}
**Customer impact estimate:** {{customer_impact_estimate}}

**Idempotency key:** {{rollback_idempotency_key}}

**Allen recommends:** {{recommendation}}

@Jane — review now.

**Actions:** `approve` / `reject <reason>`
```

### Security Risk Acceptance

```
🎯 **Approval Needed — Security Risk Acceptance** ({{finding_id}})

**Finding:** {{summary}}
**Severity:** {{severity}}
**CVE:** {{cve_id}}
**Affected:** {{affected_components}}

**Patch available:** {{patch_available}}
**Reason for deferral:** {{deferral_rationale}}
**Review date:** {{review_date}}

**Allen + Jane must both approve.**

**Actions:** `approve` / `reject <reason>`
```

---

## #acme-tech-releases

### Weekly Release Plan

```
🏰 **Release Plan — Week of {{week_of}}**

{{#each releases}}
**{{release_id}}** — {{title}}
- Kind: {{kind}}
- Scheduled: {{scheduled_at}}
- PRs: {{pr_ids}}
- Deploy window check: {{deploy_window_check}} {{deploy_window_emoji}}
- Backup verified: {{backup_verified}} ({{backup_age_hours}}h ago)
- Staging QA: {{staging_qa_status}}
- Approval path: {{approval_path}}
{{/each}}

**Actions:** `approve all` / `approve <release_id>` / `hold <release_id>` / `reject <release_id>`
```

### Deploy Started

```
🏰 **Deploy Started — {{release_id}}**

**Title:** {{title}}
**Environment:** {{deploy_environment}}
**Commit SHA:** `{{commit_sha}}`
**Deployer:** {{deployer}}
**Idempotency key:** {{idempotency_key}}

Monitoring window: {{monitoring_window_hours}}h.
```

### Deploy Completed

```
🏰 **Deploy Completed — {{release_id}}**

**Title:** {{title}}
**Environment:** {{deploy_environment}}
**Duration:** {{deploy_duration_minutes}} min
**Commit SHA:** `{{commit_sha}}`

**Baseline error rate:** {{error_rate_baseline_pct}}%
**Baseline p95 latency:** {{p95_latency_baseline_ms}}ms

Watching for {{monitoring_window_hours}}h.
```

### Monitoring Window Closed

```
🏰 **Release Closed — {{release_id}}** ✅

**Title:** {{title}}
**Monitoring window:** {{monitoring_window_hours}}h
**Error rate delta:** {{error_rate_delta_pct}}% (vs baseline)
**Latency delta:** {{latency_delta_pct}}% (vs baseline)

Clean window — release archived.
```

### Auto-Rollback Triggered

```
🚨 **AUTO-ROLLBACK TRIGGERED — {{release_id}}**

**Title:** {{title}}
**Trigger:** error rate exceeded baseline + 2% for 5 min
**Post-deploy error rate:** {{error_rate_post_deploy_pct}}%
**Baseline:** {{error_rate_baseline_pct}}%

Rollback in progress with key `{{rollback_idempotency_key}}`. Incident opened.

@Allen @Jane
```

---

## #acme-tech-alerts

### SEV-1 Incident

```
🚨 **SEV-1 INCIDENT — {{incident_id}}**

**Title:** {{title}}
**Detected:** {{detected_at}}
**Detection:** {{detection_source}}
**Affected surfaces:** {{affected_surfaces}}
**User impact estimate:** {{user_impact_estimate}}

**Owner:** {{owner}}
**Triage notes:** {{triage_notes}}

@Jane @Allen — emergency response active.
```

### Security Finding (High/Critical)

```
🔴 **Security Finding — {{finding_id}}**

**Severity:** {{severity}} (CVSS {{cvss_score}})
**Kind:** {{kind}}
**CVE:** {{cve_id}}
**Summary:** {{summary}}
**Affected:** {{affected_components}}

**Patch available:** {{patch_available}}
**Exploit in wild:** {{exploit_in_wild}}
**Patch target:** {{patch_target_date}}

@Allen — triage.
```

### Uptime Breach

```
⚠️ **Uptime Breach — {{endpoint}}**

**Down detected:** {{down_detected_at}}
**Duration so far:** {{minutes_down}} min
**Trailing 60-min uptime:** {{trailing_60min_uptime_pct}}% (target 99.9%)

Incident {{incident_id}} opened.
```

### Latency Breach

```
⚠️ **Latency Breach — {{endpoint}}**

**Current p95:** {{current_p95_ms}}ms (target <500ms)
**Sustained:** {{sustained_minutes}} min
**Affected endpoints:** {{affected_endpoints}}

@Forge — investigate.
```

### Emergency Stop Active

```
🛑 **DEPLOYS PAUSED**

All production deploys are stopped. Internal dev + drafting continues.
**Reason:** {{reason}}
**Stopped by:** {{stopped_by}}
**At:** {{stopped_at}}

To resume: set `deploys_enabled: true` in `config/emergency-stop.json`.
```

### Emergency Stop Resumed

```
✅ **DEPLOYS RESUMED**

Production deploys re-enabled.
**Resumed by:** {{resumed_by}}
**At:** {{resumed_at}}
**Notes:** {{resume_notes}}

Queued approved releases will now proceed in scheduled order.
```
