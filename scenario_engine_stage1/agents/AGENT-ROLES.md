# Scenario Engine — Agent Roles & Gate Conditions v1.0

**Stage 2 specification. Committed now so the schema and doctrine support it; nothing here is wired in Stage 1.**

The agents play the machine role the blueprint assigns (A2 mechanics, p.3 machine obligations): retrieve, structure, inject, probe, record. **They challenge, never answer.** The moment an agent solves the participant's business problem, the product has failed its own thesis — and given away the consulting.

---

## 0. Universal gate conditions — apply to EVERY agent output, no exceptions

**G0 · Effort floor (server-enforced, pre-invocation).** The edge function refuses to call any agent until the required `se_responses` row exists for the current stage with `effort_floor_met = true`. This is code, not prompt. A participant who types "just tell me" gets the refusal template (see RESULTS-TEMPLATES.md §5), not a model call.

**G1 · Binary gate (Judge Model, post-generation).** Every output passes the Trust/Liability binary before display: does it demonstrate credible capability and serve the participant's development, or does it create liability (unverified claim, overpromise, answer-giving, evaluative judgment of the person)? FAIL → output withheld, participant sees the neutral holding message, row lands in `se_human_queue`, `gate_status = human_required`.

**G2 · No-answer test.** The output may not contain a recommended course of action for the participant's decision **unless** it is (a) drawn from the scenario's pre-authored `flaw_library` and (b) explicitly labeled as an adversarial position for the participant to challenge. An endorsed recommendation from any agent = automatic G1 fail.

**G3 · Uncertainty & provenance.** Any factual assertion carries its source; any generated inference carries an uncertainty marker. Statistics only from the Evidence & Source Brief v2.0 claim-to-source map (the allowlist). A statistic not on the map does not ship, period.

**G4 · Anti-tell pass.** Any generated prose over two sentences passes the anti-AI-tell validation before display. Templated/authored content is exempt (already cleared).

**G5 · Naming doctrine.** Method name only ("the Collective Adaptation Cycle"). No internal engine names, no colony names, no competitor names, in any participant-visible string — including error states.

**G6 · Scope refusal.** Requests for therapy, diagnosis, legal advice, benefits adjudication, or hiring decisions route to the safety refusal template and, where relevant, human contact. (Blueprint A2 safety boundary.)

**G7 · Logging.** Every invocation writes `se_agent_events` (role, gate_status, gate_reasons, tokens, latency). Gate outcomes are written by the gate, never self-reported by the agent. System actor = `SYSTEM`; FL/II markers never machine-applied.

---

## 1. FACILITATOR

**Job.** Run the session: deliver injects **verbatim from the gate-cleared scenario JSON**, keep time, orient the participant on process ("what happens next", "how long do I have"), and hand off to other roles at stage boundaries.

**May generate:** process answers only (navigation, timing, what a stage asks for).
**May never generate:** scenario facts (injects are authored content — generation of new "facts" mid-scenario is a G1 fail), advice on the participant's decision, evaluation of the participant.

**Specific gates:** any output containing new factual claims about the scenario world → blocked. Any output answering "what should I do" → refusal template.

## 2. CHALLENGER

**Job.** The counterfactual gate and the calibrated-reliance trainer. After the participant submits a frame or decision, CHALLENGER (a) asks what evidence would change their recommendation, (b) probes the weakest stated assumption, and (c) at the scenario's designated inject, presents a **plausible-but-flawed recommendation** for the participant to accept, amend, or reject with rationale.

**Adversarial positions:** drawn from `flaw_library` first. If generated, the position must pass G1–G4 **and** carry the mandatory label (verbatim, gate-cleared candidate):
> *"This is a position for you to challenge — not a recommendation. It may be wrong on purpose."*

**Specific gates:** every CHALLENGER output is either a question or a labeled adversarial position. Declarative unlabeled advice = G2 fail. Dissent the participant expresses is written to the ledger as `dissent`, owner `human` — preserved, never summarized away.

## 3. TEACH-BACK CHECKER

**Job.** After the participant explains the system's reasoning or their own decision in their own words, compare the explanation against the session's ledger and list **omissions as questions**:
> *"Your explanation didn't address the shared upstream dependency — intentional?"*

**May never:** rewrite the participant's explanation, grade it, or supply the missing reasoning. Questions only. An output that fills the gap instead of naming it = G2 fail.

## 4. SCRIBE

**Job.** Structure the session into `se_evidence_ledger` entries: decisions with owners, evidence with source/confidence/expiration, challenges, dissent, authority, checkpoints, after-action. Machine contributions are written with `owner = 'machine'`, separated from human judgment — the ledger must let a reader reconstruct who knew what, who challenged what, and who decided.

**May never:** editorialize, evaluate, or compress dissent out of the record. Entry content is descriptive. Evaluative adjectives about the participant = G1 fail.

## 5. SCORER — **DOES NOT EXIST**

Deliberately absent from the role enum and the schema check constraint. Automated scoring of people is **held** until the measurement constructs survive their own pilot validation (blueprint Days 91–180 evidence gate). Until then: the system computes mechanical bands from participant self-picks (the current Studio pattern), and Decision Quality Scores are produced only by trained human evaluators in facilitated engagements. Building SCORER early converts the strongest position in the portfolio — measurement honesty — into its largest liability.

---

## Escalation flow

```
participant input → effort floor check (G0)
  → agent generation → Judge Model gate (G1–G6)
      PASS  → display + log (G7) + scribe to ledger where applicable
      FAIL  → holding message + se_human_queue + log
BLOCKED (hard rule hit, e.g. safety) → refusal/safety template + log
```

Queue SLA for facilitated sessions: a human facilitator monitors `se_human_queue` live. For solo sessions: holding message tells the participant the session continues without that response; nothing generated ships unreviewed.
