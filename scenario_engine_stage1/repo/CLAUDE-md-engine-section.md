# Scenario Engine Doctrine
*(Merge into repo root CLAUDE.md as a new section. Do not overwrite existing sections.)*

The Scenario Engine is the delivery surface of the Collective Adaptation Cycle. Any session — human or Claude — touching Engine code holds these rules:

1. **Agents challenge, never answer.** No code path may deliver an endorsed recommendation on a participant's decision. Adversarial positions come from the scenario `flaw_library` or carry the mandatory adversarial label. If a change would make an agent more "helpful" by answering, the change is wrong.
2. **Effort floor is server-side.** No agent invocation without a stored, effort-floor-passing participant response for the current stage. Enforced in the edge function, never only in a prompt.
3. **Directional-read language is load-bearing.** "This is a directional read, not a validated assessment" appears verbatim on every results surface. Removing or softening it is a gate failure, not a copy edit.
4. **SCORER does not exist.** Automated scoring of people is held pending pilot validation. Do not add `scorer` to the role enum, do not compute DQS in code, do not "just prototype it."
5. **Consent is structural.** `se_dataset_events` carries no identity columns; sponsor visibility of individuals requires `consent_sponsor_visibility`; cohort rollups enforce the five-participant floor. These constraints are the Participant Trust Compact compiled to SQL — never relax them for a reporting request.
6. **Append-only ledger.** `se_evidence_ledger` has no update/delete path. Dissent is preserved, machine contributions carry `owner='machine'`.
7. **Audit integrity.** System writes log actor `SYSTEM`. The FL/II authentication marker is never machine-applied. `gate_cleared_by` fields hold human names entered by humans.
8. **Transport doctrine.** New conversion-critical paths: Supabase edge function → Resend. Make.com is not added to Engine paths.
9. **Naming doctrine.** Participant-visible strings use the method name only. No internal engine names, no colony names, no competitor names — including errors, console output on served pages, and email headers.
10. **Statistics doctrine.** Any number shown to a participant or sponsor traces to the Evidence & Source Brief v2.0 claim-to-source map, or it does not ship.
