# HEARTBEAT.md — Atlas (Memo Drafter)

# Periodic checks. Keep minimal — heartbeat is for noticing, not doing.

- [ ] Check `config/emergency-stop.json` — block external `approved → delivered` transitions if `external_comms_enabled` is `false`
- [ ] Find memos in `ceo_review` > 72h — surface in stale-memo roll-up
- [ ] Find memos in `revising` > 7d with no Jane-direct redraft request — surface for hold/reject decision
- [ ] Confirm last delivered memo has a logged `delivered_at` and `delivery_channel`
