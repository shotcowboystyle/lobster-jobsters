# HEARTBEAT.md

# Periodic checks for the ACME Bonsai Contract Coordinator team.
# Keep items minimal — heartbeat is for noticing problems, not doing work.

- [ ] Check `config/emergency-stop.json` status — if `contracts_enabled` is `false`, post the active reason to `#acme-contracts-alerts`
- [ ] Check for DocuSign envelopes pending signature > 48h with no reminder sent
- [ ] Check for DocuSign envelopes pending signature > 5 days — escalate to Jane
- [ ] Check for unpaid deposits > 72h since invoice sent — flag Finch to nudge buyer
- [ ] Check for contracts in `inventory_reserved` state with a delivery date inside 24h that have no route assigned
- [ ] Check for inventory species/size at or below safety threshold — flag Grove
- [ ] Check for contracts > $5,000 total that have not received CEO acknowledgement
- [ ] Check the contract ledger for any state transition older than 72h with no follow-on action (stalled deals)
