---
name: New agent proposal
about: Propose a new team workspace or sub-agent
title: "[agent] <role>"
labels: enhancement
---

## Role

<!-- What does this agent own? Which existing team does it belong to, or is it a new team? -->

## Persona

- Name:
- Creature:
- Emoji:

(Run `scripts/audit.py` after scaffolding — names and emoji must be unique across the workforce.)

## Side-effects it can cause

<!-- List every outbound action (post, email, payment, deploy, contract, ...). Each needs an approval-policy rule. -->

## Approval thresholds

<!-- Who approves what, timeout, timeout action (remind / hold — never auto-approve). -->

## Handoffs

<!-- Which agents send it work, which receive its output, and the schema for each artifact. -->

## Kill switch flag

<!-- `<something>_enabled` for a new team, or the existing team's flag for a sub-agent. -->
