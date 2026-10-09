# ACME Bonsai — CFO Team (Sterling)

## Architecture Summary

Multi-agent OpenClaw system that runs ACME Bonsai's finance function: monthly close, budgets and forecasts, pricing and margin discipline, controls and compliance, and cash runway. Discord is the human coordination layer. The accounting system holds the financial state of record; this workspace holds workflow state (close packages, forecasts, exceptions, pricing decisions, compliance deadlines) in the CFO ledger.

Key principles:

- Cash first — runway is the most important number in the business
- Margin before vanity growth — revenue that destroys margin is a warning sign
- Early warning over late explanation — raise risks before they become emergencies
- Document all exceptions — discounting, refunds, write-offs, and deferred obligations are traceable
- Forecasts disclose their assumptions; aggregate metrics are decomposed by channel + customer

---

## Agent Table

| # | Agent | Persona | Mission | Trigger | Outputs To |
|---|-------|---------|---------|---------|------------|
| 1 | CFO | Sterling 🦅 | Orchestrates the team; protects cash, margin, integrity | Routine + on-demand | Sub-agents + Jane |
| 2 | Finance Operations | Ledger 📊 | AP/AR, reconciliations, expense coding, monthly close mechanics | Daily routines + close cycle | Horizon, Sterling |
| 3 | FP&A | Horizon 📈 | Budgets, forecasts, scenarios, cash runway, KPI dashboards | Weekly runway + monthly forecast | Sterling → Jane |
| 4 | Controls & Compliance | Garrison 🛡️ | Policy, documentation, deadlines, audit readiness | Daily deadline check + weekly audit | Sterling |
| 5 | Pricing & Profitability | Margin 💰 | Unit economics, pricing decisions, channel profitability | Weekly snapshot + on-demand quote review | Sterling → Sales |

---

## Workflow Table

| Workflow | Trigger | Key Agents | Human Checkpoint |
|----------|---------|------------|------------------|
| A. Daily Reconciliation | Routine: daily 7 AM ET | Ledger | — (feeds close) |
| B. AR Aging Sweep | Routine: daily 8 AM ET | Ledger | Sterling reviews escalations |
| C. AP Schedule | Routine: daily 9 AM ET | Ledger | Sterling approves > $5K outside budget |
| D. Weekly Runway Refresh | Routine: Mon 8 AM ET | Horizon | Sterling reviews; Jane if runway < 90d |
| E. Monthly Close | Day 1–5 of month | Ledger → Horizon → Sterling | Jane approves package |
| F. Monthly Forecast | After close | Horizon | Sterling reviews; Jane approves |
| G. Quarterly Re-Forecast | First week of quarter | Horizon | Jane approves |
| H. Pricing Decision | On-demand | Margin → Sterling | Sterling approves ≤15%; Jane approves >15% / below cost |
| I. Weekly Margin Snapshot | Routine: Mon 10 AM ET | Margin | Sterling reviews; flags drift |
| J. Daily Compliance Check | Routine: daily 7:30 AM ET | Garrison | Sterling reviews escalations |
| K. Weekly Exception Audit | Routine: Fri 4 PM ET | Garrison | Sterling reviews; Jane on material items |
| L. Tax / Filing Cycle | Per deadline | Garrison → Sterling | Jane approves response |
| M. Emergency Stop | Any time | Sterling | Jane or Sterling sets `finance_actions_enabled: false` |

---

## Guard Rails Table

| Category | Rule |
|----------|------|
| Cash | Runway < 90 days → immediate Jane alert |
| Cash | Cash position reported to Jane weekly (Mon 8 AM) |
| AR | Invoice > 30 days past due → collections workflow |
| AP | No bill paid late without documented reason |
| Budget | Spend > $5K outside budget → Jane approval |
| Discounts | Discount > 15% off list → Sterling approval |
| Discounts | Discount below cost → Jane approval with strategic rationale |
| Close | Monthly close completes day 5 of following month with zero unexplained variances |
| Forecast | Every forecast discloses assumptions + sensitivity range |
| Compliance | Tax/regulatory deadlines acknowledged ≥ 14 days ahead |
| Compliance | Audit readiness verified continuously, not annually |
| Margin | Margin floors set per channel; violations flagged within 1 week |
| Exceptions | All exceptions documented within 24h of detection |
| Confidentiality | P&L, balance sheet, cap table never shared outside exec team without Jane approval |
| Personnel | Comp matters: 1:1 Jane only — never in shared channels |
| Operational | All state transitions logged to the finance ledger |

---

## RACI Table

| Activity | Sterling | Ledger | Horizon | Garrison | Margin | Jane | Source Team |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Daily reconciliation | I | R | — | — | — | — | — |
| AR collections | A | R | — | — | — | I | I (Sales) |
| AP scheduling | A | R | — | C | — | A (>$5K) | I |
| Monthly close | A | R | C | C | — | A (approves) | I |
| Forecast | A | C | R | — | C | A (approves) | C (all) |
| Runway refresh | A | — | R | — | — | I (alert <90d) | — |
| Pricing decision | A | — | C | — | R | A (>15%) | A (Sales) |
| Margin snapshot | A | — | — | — | R | I | I |
| Compliance deadlines | A | — | — | R | — | I | — |
| Tax / filing | A | C | — | R | — | A (approves) | — |
| Exception documentation | A | C | — | R | — | I | I |
| Cap allocation analysis | A/R | — | R | — | C | A (decides) | C |
| Emergency stop | R | I | I | I | I | A/R | I |

R=Responsible, A=Accountable, C=Consulted, I=Informed

---

## Discord Channel Layout

| Channel | Purpose | Who Acts |
|---------|---------|----------|
| `#acme-finance-drafts` | Close packages, forecast drafts, pricing analyses, variance reports for review | Ledger + Horizon + Margin post; Sterling reviews |
| `#acme-finance-approvals` | CEO escalations: large spend, discount below cost, banking, compliance items | Sterling posts; Jane acts |
| `#acme-finance-reports` | Weekly cash + AR aging + margin snapshots; monthly close summaries | Horizon + Margin + Sterling post; Jane reviews |
| `#acme-finance-alerts` | Runway threshold breaches, missed deadlines, ledger anomalies, emergency-stop | All agents post; Sterling triages |

---

## Emergency Stop Design

File-based kill switch at `config/emergency-stop.json`:

```json
{
  "finance_actions_enabled": true,
  "reason": null,
  "stopped_by": null,
  "stopped_at": null,
  "resume_notes": null,
  "resumed_by": null,
  "resumed_at": null
}
```

When `finance_actions_enabled` is `false`:

1. Ledger refuses invoice sends, refunds, and vendor payment authorizations
2. Margin can analyze but cannot publish pricing changes to Sales
3. Garrison can track deadlines but cannot send filings or responses
4. Horizon and Sterling continue drafting and reporting (internal)
5. Discord alert posted to `#acme-finance-alerts`: "🛑 FINANCE ACTIONS PAUSED: {reason}"

To resume: set `finance_actions_enabled: true`, post confirmation to Discord.

---

## Idempotency Strategy

Every outbound side-effect carries an idempotency key:

- Invoice send: `acme-fin-{invoice_id}-send-{attempt}`
- Refund: `acme-fin-{refund_id}-refund-{attempt}`
- Vendor payment: `acme-fin-{bill_id}-pay-{attempt}`
- Filing: `acme-fin-{compliance_id}-file-{attempt}`

Before send, check the relevant table for an existing entry with the same key.

---

## Recommended File Tree

```
workforce/agents/cfo/
├── README.md
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── HEARTBEAT.md
├── MEMORY.md
├── TOOLS.md
├── agents/
│   ├── finance-ops/             # Ledger
│   ├── fpa/                     # Horizon
│   ├── controls-compliance/     # Garrison
│   └── pricing-profitability/   # Margin
├── schemas/
│   ├── monthly-close.schema.json
│   ├── forecast.schema.json
│   ├── variance-report.schema.json
│   ├── pricing-decision.schema.json
│   ├── exception-log.schema.json
│   ├── compliance-deadline.schema.json
│   ├── cash-runway-snapshot.schema.json
│   └── finance-ledger.sql
├── prompts/
│   ├── monthly-close.md
│   ├── weekly-runway.md
│   ├── pricing-analysis.md
│   └── compliance-deadline.md
├── config/
│   ├── emergency-stop.json
│   ├── approval-policy.json
│   ├── discord-config.example.json
│   ├── env.example
│   └── routines.example.sh
├── ops/
│   └── runbook.md
└── discord-templates/
    └── message-templates.md
```

---

## Deployment Assumptions

- Claude Desktop with Claude Code Routines enabled
- Discord bot with permissions to post in the 4 designated channels
- Accounting system with API (QuickBooks Online, Xero, or equivalent)
- Banking API or read-only bank connection (Plaid or similar) for cash position
- Payment provider (Stripe + ACH) for refunds and merchant fees
- SQLite database for the CFO ledger (local; backed up nightly)
- Routines configured at `claude.ai/code/routines` (see `config/routines.example.sh`)
- Sterling holds delegated authority within thresholds; Jane is the final approver for anything above
