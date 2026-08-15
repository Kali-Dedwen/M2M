# Scenario Engine — Results Templates v1.0

**Status: GATE-CLEARED — Founder GO received August 15, 2026 (FL/II). Every block below is verbatim: the system fills `{placeholders}` and changes nothing else. Any future copy change requires a new clearance and a version bump.** `template_version: RT-1.0` · `directional_lang_version: DL-1.0` — both are pinned into `se_results` at send time so the record shows exactly what shipped.

Non-negotiable copy rules (inherited from the suite doctrine):
- The directional-read sentence survives every surface, verbatim.
- Statistics only with attribution per Evidence & Source Brief v2.0.
- No competitor names. Method name only; no internal engine names.
- Consent, export, and retention language appears on every participant-facing result (Participant Trust Compact).
- Signature convention: "Kevin A. Smith" — formal contexts "Dr. Kevin A. Smith, Hon. D.H.L."; results emails use the brand sender, not a personal signature.

---

## 1. Participant results email

**From:** M2M — Model 2 Message, Inc. `results@model2message.net` (Resend, verified domain)
**Subject:** `Your readiness read — {scenario_title}`

**Body (HTML, Navy/Gold suite tokens, square corners; plain-text alternative required):**

> **{display_name} — here is your read.**
>
> You ran one live disruption: *{scenario_title}*. Below is where your responses landed across the six dimensions the Collective Adaptation Cycle measures.
>
> **This is a directional read, not a validated assessment.** It reflects one scenario, one sitting, and your own picks — it is a mirror, not a grade.
>
> {bands_table}
> *(one row per dimension: dimension name · STRONG / MIXED / WEAK)*
>
> **One 30-day action:** {thirty_day_action}
> *(selected from the gate-cleared action library keyed to the weakest band — never generated free-form)*
>
> **Where a read like this usually goes next.** Two hours with a facilitator tells you where you actually stand: one real decision from your business, run human-only and AI-assisted, with a disruption in the middle — and a readiness profile you keep.
> **[Book the Adaptive Readiness Stress Test]** → `model2message.net/stress-test?src=engine`
> *A pathway recommendation follows the evidence review — never the other way around.*
>
> ---
> *Your data: this result was emailed to you because you opted in. {dataset_line} You can request export or deletion of your session data at any time: reply to this email or write to privacy@model2message.net. Results are retained {retention_period} unless you ask otherwise.*
>
> Model 2 Message, Inc. · Winston-Salem, NC · model2message.net

`{dataset_line}` variants (exact strings):
- consent_dataset = true → `An anonymized record of your bands — with no name, email, or organization attached — contributes to M2M readiness research.`
- consent_dataset = false → `Nothing from this session enters any research dataset.`

## 2. Sponsor rollup email (cohorts only, aggregate only)

**Subject:** `{cohort_name} — readiness rollup, week of {week_of}`

> **{sponsor_org} — cohort rollup.**
>
> {participants} participants · {completed_sessions} completed sessions.
> Overall reads: {strong} strong · {mixed} mixed · {weak} weak.
>
> **These are directional reads, not validated assessments**, and they are aggregate by design: individual results belong to the individuals. Participants who consented to named visibility appear in your facilitated debrief only.
>
> The cohort's most common weak dimension: **{top_weak_dimension}** — worth a conversation about what the {package_type_label} pathway does with exactly that.
>
> Questions on the rollup or the next cohort window: reply here.

**Hard rule:** this template renders only from `v_se_cohort_rollup`, which enforces a five-participant floor. Below the floor, no rollup sends — the system emails the sponsor the small-cohort holding line instead: `This cohort is below the size at which we report aggregates. Individual privacy holds even when the math would be easy to reverse.`

## 3. After-action screen (in-product, end of session)

> **The read, not the grade.**
> This is a directional read, not a validated assessment. It reflects what you chose under time pressure, contradiction, and a failing machine — the conditions that don't show up on a résumé.
>
> {bands_table}
>
> **What strong operators do next:** pick the weakest dimension and pressure-test it against a *real* decision — yours, not ours. That's what the Stress Test is for.
> **[Take this to a real decision →]** `/stress-test?src=engine`
> **[Email me my read]** *(visible only when consent_results_email = true; otherwise shows the one-tap consent line first)*

## 4. HUMAN_REQUIRED holding message (Stage 2)

> That response is with a human reviewer — the system flags anything it isn't certain clears our standard. Your session continues; nothing you've entered is lost.

## 5. Refusal template — answer-seeking (Stage 2, the G0/G2 line)

> The Engine doesn't answer that — that decision is yours to make, and making it is the entire exercise. What it can do: pressure-test your frame, show you what you haven't considered, and keep the record. Give me your first-pass call and I'll push on it.

## 6. Safety refusal (Stage 2, G6)

> That's outside what this session is for — and it deserves a person, not a scenario engine. {routing_line: qualified-human contact per the safety boundary}. Your session is paused and will be here when you're ready.

## 7. Consent screen (Stage 1, before first session — three independent toggles, all default OFF)

> **Before you start — three choices, all yours:**
> ☐ Email me my results when I finish.
> ☐ Contribute my *anonymized* bands (no name, email, or organization) to M2M readiness research.
> ☐ If I'm part of a sponsored cohort, my sponsor may see my *named* result in the facilitated debrief. *(Aggregate cohort numbers never identify you regardless.)*
>
> You can change any of these, or request export or deletion of your data, at any time. No score is permanent; every read is dated, contextual, and challengeable.
