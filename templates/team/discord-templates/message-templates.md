# Discord Message Templates — {{TEAM_NAME}} ({{PERSONA}})

Agents fill the `{placeholders}`; never invent a value — use `[PLACEHOLDER]` and flag.

## Approval Card

```
🔔 **Approval Needed — {work_item_id}**

**Type:** {kind}
**Summary:** {one-line summary}
**Amount:** {amount or n/a}
**Policy rule:** {rule} → approver: {approver}
**Deadline:** {timeout_hours}h (then: {timeout_action})

React ✅ approve · ✏️ edit · ⏸️ hold · ❌ reject
Idempotency key: {idempotency_key}
```

## Execution Confirmation

```
✅ **Executed — {work_item_id}**
**Approved by:** {approver} at {decided_at}
**Executed at:** {executed_at}
**Idempotency key:** {idempotency_key}
```

## Execution Failure

```
❌ **Execution Failed — {work_item_id}**
**Error:** {error}
**Attempt:** {attempt} of 3
Next retry in {minutes} minutes, or escalating to {{PERSONA}} if attempts exhausted.
```

## Emergency Stop Active

```
🛑 **{{TEAM_SHORT}} outbound paused — Emergency Stop Active**
Reason: {reason}
Stopped by: {stopped_by} at {stopped_at}
Drafting continues; nothing leaves the workspace until {{OWNER}} resumes.
```

## Weekly Report (≤ 400 words)

```
📊 **{{TEAM_SHORT}} Weekly — {week}**
Executed: {n} · Held/Rejected: {n} · Failures: {n}
Mean approval latency: {hours}h
Top risks next week: 1. {risk} 2. {risk} 3. {risk}
Decision needed from {{OWNER}}: {one decision or "none"}
```
