# Handoff: Scenario Engine — Stage 1 (Rails) — FINAL

**FINAL v1.0 · Founder GO 08-15-2026 · Ready for Claude Code execution.**

Paste this brief to Claude Code inside the `Kali-Dedwen/M2M` repository. It is self-sufficient — no other conversation context is needed. Companion files travel in this bundle: `SPEC.md` (architecture), `sql/schema.sql` (data model), `agents/AGENT-ROLES.md` (Stage-2 spec, NOT wired in this stage), `templates/RESULTS-TEMPLATES.md` (copy), `repo/CLAUDE-md-engine-section.md` (doctrine merge).

## Overview
Convert the existing Scenario Studio from a standalone localStorage walkthrough into the authenticated, persistent, consent-governed **Stage 1 of the Scenario Engine** — the delivery surface of the Collective Adaptation Cycle. Stage 1 is rails only: auth, persistence, consent, results email, dataset events, CTA routing. **No agents, no model calls, zero LLM spend in this stage.** Agent wiring is Stage 2 and requires a separate Founder GO.

## About the design files
`M2M Scenario Studio - Standalone.html` remains final visual truth for its surfaces (deploy-ready, dependency-free). The infographic (`M2M_Infographic_dc.html`) is design reference for suite typography and the CAC stage language. New surfaces (consent screen, results email HTML) match the token set below exactly. Suite surfaces use SQUARE corners and flat panels.

## Fidelity
High-fidelity. Do not restyle the Studio. Extend it.

## Tasks, in priority order

### 1. Apply the schema — as a governed migration
- `sql/schema.sql` goes through the repo's migration flow: reviewed migration file, **dry-run against a branch/staging database first**, production apply only on explicit Founder GO in the PR thread. Do not apply blind.
- Note the deliberate constraints before proposing "fixes": the evidence ledger has **no update/delete policies** (append-only by design); `scorer` is **absent** from the agent role enum (held pending pilot validation); `se_dataset_events` has **no identity columns** (structural anonymity); the cohort rollup view enforces a **five-participant floor**. These are doctrine, not oversights.

### 2. Gate the Engine route behind magic-link auth
- Serve the Studio at `/engine`, behind the platform's existing magic-link mechanism (same as assessment.model2message.net).
- **Remove the built-in courtesy access-code screen entirely on this route** — magic link is the real gate, and the courtesy code contains a string that must not appear on external surfaces. Do not replace it with a new code.
- On first authenticated visit, upsert `se_participants` from the auth user (display_name prompt if absent).

### 3. Consent screen before first session
- Render the three-toggle consent block from `templates/RESULTS-TEMPLATES.md §7`, verbatim (gate-cleared). All toggles default OFF. Persist to `se_participants`. Re-editable from a small "your data" link in the footer of every Engine surface.

### 4. Session persistence with degraded mode
- On session start: insert `se_sessions` (scenario_id from the seeded invisible-dependency scenario row, `src` from query param, mode `solo`).
- Each stage pick/response: insert `se_responses`. Keep the existing localStorage key (`m2m-scenario-studio-v1`) as the **offline/degraded fallback**: if Supabase is unreachable, the run completes locally and syncs on reconnect with `degraded_mode = true`. Degraded operation is a product feature (the method trains for exactly this) — never block a run on connectivity. Never clear the localStorage key.

### 5. Seed the scenario
- Insert the invisible-dependency scenario into `se_scenarios` from the Studio's existing content: stages JSON (six injects, verbatim), the six scoring dimensions, empty flaw_library (Stage 2 fills it). Status `gate_cleared` **only after** the Founder confirms the seeded content matches the shipped Studio verbatim — record their name and date in `gate_cleared_by` / `gate_cleared_at`. Leave `draft` until then. Never populate `gate_cleared_by` programmatically.

### 6. Results edge function — `se-results-dispatch`
- Trigger: session completion.
- Compute bands from participant picks (current Studio logic, ported server-side). Write `se_results` with `template_version` / `directional_lang_version` pinned.
- If `consent_results_email`: render the participant template (§1) and send via **Resend** (existing sovereign SMTP; sender `results@model2message.net`; store the Resend message id). **Not Make.com — no exceptions.**
- If `consent_dataset`: insert `se_dataset_events` (bands, tier, slug, coarse region only). Confirm at code-review time that no identity column exists on the insert path.
- Fire-and-forget failure posture for the email leg (log, retry queue optional); never fail the session on email failure.

### 7. Wire the doors
- After-action screen: render §3 copy; primary CTA → `/stress-test?src=engine`.
- Add `engine` to the accepted `?src=` attribution values in the stress-test webhook payload.
- Sponsor rollup (§2) ships as a **manually-triggered** edge function in Stage 1 (Founder or facilitator invokes per cohort); scheduled digests are Stage 3.

### 8. Merge the doctrine
- `repo/CLAUDE-md-engine-section.md` → MERGE into the repo root `CLAUDE.md` as a new section titled "Scenario Engine Doctrine" (do NOT overwrite existing sections).

## Design tokens
- Navy: `#0F2A4F` (deep), `#1E3A5F` (site primary), `#16233A` (ink panels)
- Gold: `#C9A22C` (accent), `#A88620` (gold on light)
- Paper `#FAF9F5` · body ink `#26334A` · muted `#5A6B82` / `#8593A8`
- Type: Inter (headings 700–800, letter-spacing −0.01/−0.02em), JetBrains Mono for kickers/labels (uppercase, tracking 0.14–0.2em)
- Suite surfaces: square corners, flat panels. Buttons: gold fill `#C9A22C`, ink text `#16233A`, no border.

## Copy rules (non-negotiable)
- "**This is a directional read, not a validated assessment**" survives every surface, verbatim.
- Statistics only with attribution per the Evidence & Source Brief v2.0 claim-to-source map.
- Method name only ("the Collective Adaptation Cycle"); no internal engine names, no colony names, no competitor names — including error states and console strings on served pages.
- Templates in `templates/RESULTS-TEMPLATES.md` are GATE-CLEARED (Founder GO 08-15-2026): wire them VERBATIM behind the `RT-1.0` version pin. Do not edit copy; copy changes require a new clearance and version bump.
- System-initiated audit writes use actor `SYSTEM`. The FL/II marker is never machine-applied, anywhere, for any reason.

## Acceptance checklist
- [ ] `/engine` unreachable without magic link; courtesy access-code screen removed on this route
- [ ] Consent toggles default OFF, persist, and are re-editable
- [ ] Full run persists sessions + responses; airplane-mode run completes locally and syncs with `degraded_mode = true`
- [ ] Completion writes `se_results` with pinned template versions
- [ ] Opt-in participant receives Resend email; message id stored; opted-out participant receives nothing
- [ ] `se_dataset_events` rows appear ONLY for consented participants and contain no identity fields
- [ ] Ledger table rejects UPDATE/DELETE from all non-superuser roles
- [ ] Cohort rollup returns nothing for cohorts under five participants
- [ ] After-action CTA lands on `/stress-test?src=engine` and `src` reaches the booking payload
- [ ] Existing site pages, styles, and the standalone Studio at its current home untouched
- [ ] No Make.com calls anywhere in the new paths

## Explicitly out of scope (do not build, even if tempting)
Agent invocations of any kind · anything importing an LLM SDK · automated scoring · scheduled sponsor digests · facilitator console · new visual design systems. Stage 2 has its own GO.
