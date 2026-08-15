# M2M Scenario Engine — Build Specification v1.0

**The delivery surface of the Collective Adaptation Cycle.**
Internal working name: Scenario Engine. External surface label: uses the method name only ("The Collective Adaptation Cycle") under the AXIOM platform umbrella — the public product name remains deferred per the Naming Gate. No internal engine or colony names appear in any participant-facing surface, ever.

Status: FINAL — RATIFIED FOR BUILD, Founder GO received August 15, 2026.
Results templates (RT-1.0) gate-cleared by Founder GO, August 15, 2026 — treat as verbatim. Scenario seed remains `draft` until the Founder confirms verbatim match with the shipped Studio (runtime check, see README task 5).

---

## 1. What this is

A session-based, cohort-aware, agentic scenario engine that runs the Collective Adaptation Cycle curriculum (blueprint annex A5) on the existing M2M stack: Supabase (auth, data, edge functions, RLS), Resend (results delivery), Vercel (hosting, drivenbydesign1-tech-tiil), magic-link auth (same mechanism as assessment.model2message.net), Judge Model gating on all automated output, and the SKL-026 audit-write pattern for the evidence ledger.

It extends the existing Scenario Studio (six timed injects, after-action read) into:
- persistent, authenticated sessions,
- consent-governed results delivery to participants and aggregate rollups to sponsors,
- an anonymized readiness dataset (the Benchmark Authority feed),
- and — in Stage 2 — bounded agent roles that challenge, never answer.

## 2. What this is not (enforced in code, not just copy)

- Not an answer-generating chatbot. The effort floor is enforced server-side: no agent invocation until the required participant input exists for that stage.
- Not a validated assessment. All automated output carries the directional-read language. Validated Decision Quality Scores (0–100, double-scored) exist only in facilitated engagements with a human evaluator, until pilot validation says otherwise.
- Not a fourth platform. It is the practice field the three lanes deliver on. Every after-action routes to a facilitated door (`/stress-test?src=engine`).
- Not a Make.com dependency. All new conversion-critical paths run Supabase edge function → Resend.

## 3. The four structural rules (from ratified counsel)

1. **The agent challenges, never answers.** Agents inject, probe, contradict (labeled), check teach-backs, and scribe. They never solve the participant's business problem. Rule enforced by gate conditions in `agents/AGENT-ROLES.md`.
2. **Directional read until the pilot validates.** Language survives every surface: screen, email, sponsor rollup, PDF export.
3. **Every session ends at a door.** After-action → routed facilitated pathway + Stress Test CTA with `?src=engine`.
4. **The data compounds.** Consented completions write anonymized rows to the benchmark dataset. Consent is opt-in, per the Participant Trust Compact; the dataset table structurally cannot hold identity.

## 4. Stages

| Stage | Scope | Gate |
|---|---|---|
| **1 — Rails** (this handoff) | Auth, persistence, consent, results email, dataset events, CTA routing. **No agents.** | Ships now; acceptance checklist in README.md |
| **2 — Agents** | FACILITATOR, CHALLENGER, TEACH-BACK CHECKER, SCRIBE on the invisible-dependency scenario only, behind effort floor + Judge Model gate. Friendly-participant runs. | Founder GO after Stage-1 acceptance; design gate on prototype feel |
| **3 — Curriculum** | A5 weeks as scenario sequences, cohort management, facilitator console, sponsor digests. | Blueprint Days 31–90 usability + construct review gate |
| **Scoring** | SCORER agent / automated DQS | **Held.** Human-scored until pilot validation (blueprint Days 91–180 evidence gate). No exceptions. |

## 5. Files in this package

- `README.md` — Stage-1 task brief (Claude Code handoff format, self-sufficient)
- `sql/schema.sql` — full data model, RLS, views, audit hooks
- `agents/AGENT-ROLES.md` — Stage-2 agent role definitions + gate conditions (committed now so the schema supports them; not wired in Stage 1)
- `templates/RESULTS-TEMPLATES.md` — gate-cleared-candidate copy for all automated outputs
- `repo/CLAUDE-md-engine-section.md` — doctrine section to MERGE into repo CLAUDE.md

## 6. Audit integrity rule (non-negotiable)

System-initiated writes log with actor `SYSTEM` via the canonical audit pattern. **The FL/II authentication marker is never machine-applied.** It appears only where a real Founder action is recorded with its date. This spec exists downstream of the Surface C remediation; do not reintroduce the defect class.

## 7. Cost & telemetry

All model calls (Stage 2+) log tokens/latency to `se_agent_events`, surfaced through the existing `v_llm_usage` metering pattern. Stage 1 has zero model spend.
