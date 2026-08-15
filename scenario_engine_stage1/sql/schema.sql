-- ============================================================================
-- M2M SCENARIO ENGINE — SCHEMA v1.0
-- Governed migration. Do NOT apply blind: run as a reviewed migration through
-- the repo's migration flow, dry-run first, Founder GO before production apply.
-- Prefix: se_  (scenario engine)
-- Audit: system writes log actor SYSTEM via the canonical audit write pattern
-- (SKL-026). FL/II markers are NEVER machine-applied.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- COHORTS — a sponsored or scheduled group. Self-serve sessions have no cohort.
-- ---------------------------------------------------------------------------
create table if not exists se_cohorts (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  sponsor_org   text,                              -- lender, prime, chamber, enterprise
  package_type  text not null check (package_type in
                  ('self_serve','stress_test','main_street_studio',
                   'growth_cohort','executive_lab','veteran_cohort','ecosystem')),
  status        text not null default 'draft' check (status in
                  ('draft','active','completed','archived')),
  starts_at     timestamptz,
  ends_at       timestamptz,
  created_at    timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- PARTICIPANTS — one row per authenticated human. Consent is explicit,
-- per-purpose, and defaults FALSE (Participant Trust Compact is a product
-- requirement, not a policy page).
-- ---------------------------------------------------------------------------
create table if not exists se_participants (
  id                         uuid primary key default gen_random_uuid(),
  auth_user_id               uuid not null unique references auth.users(id),
  cohort_id                  uuid references se_cohorts(id),
  display_name               text not null,
  email                      text not null,
  org_name                   text,
  org_size_tier              text check (org_size_tier in
                               ('micro','small','growth','enterprise','public_sector')),
  consent_results_email      boolean not null default false,
  consent_dataset            boolean not null default false,  -- anonymized benchmark feed
  consent_sponsor_visibility boolean not null default false,  -- named visibility to sponsor
  created_at                 timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- SCENARIOS — versioned, gate-cleared content. Injects are AUTHORED, not
-- generated: agents deliver from this JSON verbatim. gate_cleared_by records
-- the human who cleared it; never populated by the system.
-- ---------------------------------------------------------------------------
create table if not exists se_scenarios (
  id                  uuid primary key default gen_random_uuid(),
  slug                text not null,
  version             int  not null default 1,
  title               text not null,
  method_week         int,                          -- A5 curriculum week, null = standalone
  stages              jsonb not null,               -- ordered injects: key, t_offset, content, response_type required
  scoring_dimensions  jsonb not null,               -- the six after-action dimensions
  flaw_library        jsonb not null default '[]',  -- pre-authored adversarial positions for CHALLENGER
  status              text not null default 'draft' check (status in
                        ('draft','gate_cleared','retired')),
  gate_cleared_at     timestamptz,
  gate_cleared_by     text,                          -- human name; NEVER system-populated
  unique (slug, version)
);

-- ---------------------------------------------------------------------------
-- SESSIONS — one run of one scenario by one participant.
-- degraded_mode: run completed with client-side fallback (localStorage) and
-- synced later. Degraded operation is a feature, not a failure.
-- ---------------------------------------------------------------------------
create table if not exists se_sessions (
  id             uuid primary key default gen_random_uuid(),
  participant_id uuid not null references se_participants(id),
  scenario_id    uuid not null references se_scenarios(id),
  cohort_id      uuid references se_cohorts(id),
  mode           text not null default 'solo' check (mode in ('solo','facilitated','presenter')),
  src            text,                               -- ?src= attribution: engine, studio, onepager, linkedin, deck
  baseline_kind  text check (baseline_kind in ('human_only','ai_assisted','orchestrated')),
  degraded_mode  boolean not null default false,
  started_at     timestamptz not null default now(),
  completed_at   timestamptz
);

-- ---------------------------------------------------------------------------
-- RESPONSES — participant inputs per stage. effort_floor_met is computed
-- server-side and is the PRECONDITION for any Stage-2 agent invocation.
-- ---------------------------------------------------------------------------
create table if not exists se_responses (
  id               uuid primary key default gen_random_uuid(),
  session_id       uuid not null references se_sessions(id),
  stage_key        text not null,
  response_type    text not null check (response_type in
                     ('frame','decomposition','decision','teachback',
                      'counterfactual','dissent','recovery','pick')),
  content          text not null,
  effort_floor_met boolean not null default false,
  submitted_at     timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- AGENT EVENTS — every model invocation (Stage 2+). Feeds LLM usage metering.
-- gate_status is written by the Judge Model gate, never by the agent itself.
-- ---------------------------------------------------------------------------
create table if not exists se_agent_events (
  id           uuid primary key default gen_random_uuid(),
  session_id   uuid not null references se_sessions(id),
  agent_role   text not null check (agent_role in
                 ('facilitator','challenger','teachback_checker','scribe')),
                 -- 'scorer' deliberately ABSENT: held until pilot validation
  input_hash   text not null,
  output       text not null,
  gate_status  text not null check (gate_status in ('pass','human_required','blocked')),
  gate_reasons jsonb not null default '[]',
  model        text not null,
  tokens_in    int,
  tokens_out   int,
  latency_ms   int,
  created_at   timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- EVIDENCE LEDGER — append-only. Mirrors blueprint A7 fields: owner, source,
-- confidence, expiration, machine contribution separated from human judgment,
-- dissent preserved. NO update/delete policies exist by design.
-- ---------------------------------------------------------------------------
create table if not exists se_evidence_ledger (
  id                 uuid primary key default gen_random_uuid(),
  session_id         uuid not null references se_sessions(id),
  entry_type         text not null check (entry_type in
                       ('decision','evidence','challenge','dissent',
                        'authority','checkpoint','outcome','after_action')),
  owner              text not null check (owner in ('human','machine')),
  content            text not null,
  source_attribution text,
  confidence         text check (confidence in ('low','medium','high')),
  expires_at         timestamptz,
  created_at         timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- RESULTS — the directional read as delivered. template_version pins the
-- gate-cleared copy in force at send time (auditability of what shipped).
-- ---------------------------------------------------------------------------
create table if not exists se_results (
  id                        uuid primary key default gen_random_uuid(),
  session_id                uuid not null unique references se_sessions(id),
  bands                     jsonb not null,   -- {dimension: strong|mixed|weak}
  overall_band              text not null check (overall_band in ('strong','mixed','weak')),
  thirty_day_action         text,
  template_version          text not null,
  directional_lang_version  text not null,
  emailed_at                timestamptz,
  email_message_id          text,             -- Resend message id
  sponsor_included          boolean not null default false,
  created_at                timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- DATASET EVENTS — the Benchmark Authority feed. STRUCTURALLY anonymous:
-- no participant_id, no session_id, no email, no org name. Written only when
-- consent_dataset = true, by the results edge function.
-- ---------------------------------------------------------------------------
create table if not exists se_dataset_events (
  id            uuid primary key default gen_random_uuid(),
  package_type  text not null,
  org_size_tier text,
  scenario_slug text not null,
  bands         jsonb not null,
  overall_band  text not null,
  degraded_mode boolean not null,
  region        text,               -- coarse only (state/country), never finer
  occurred_on   date not null default current_date
);

-- ---------------------------------------------------------------------------
-- HUMAN-REQUIRED QUEUE — gate failures land here for human review.
-- ---------------------------------------------------------------------------
create table if not exists se_human_queue (
  id             uuid primary key default gen_random_uuid(),
  agent_event_id uuid not null references se_agent_events(id),
  status         text not null default 'open' check (status in ('open','resolved','discarded')),
  resolved_by    text,               -- human name; never system-populated
  resolution     text,
  created_at     timestamptz not null default now(),
  resolved_at    timestamptz
);

-- ===========================================================================
-- ROW LEVEL SECURITY
-- ===========================================================================
alter table se_cohorts         enable row level security;
alter table se_participants    enable row level security;
alter table se_scenarios       enable row level security;
alter table se_sessions        enable row level security;
alter table se_responses       enable row level security;
alter table se_agent_events    enable row level security;
alter table se_evidence_ledger enable row level security;
alter table se_results         enable row level security;
alter table se_dataset_events  enable row level security;
alter table se_human_queue     enable row level security;

-- Participants: read/write own row only
create policy p_self on se_participants
  for select using (auth.uid() = auth_user_id);
create policy p_self_upd on se_participants
  for update using (auth.uid() = auth_user_id);

-- Sessions/responses/ledger/results: participant sees own, via join
create policy s_own on se_sessions for select using (
  participant_id in (select id from se_participants where auth_user_id = auth.uid()));
create policy s_own_ins on se_sessions for insert with check (
  participant_id in (select id from se_participants where auth_user_id = auth.uid()));
create policy s_own_upd on se_sessions for update using (
  participant_id in (select id from se_participants where auth_user_id = auth.uid()));

create policy r_own on se_responses for select using (
  session_id in (select id from se_sessions where participant_id in
    (select id from se_participants where auth_user_id = auth.uid())));
create policy r_own_ins on se_responses for insert with check (
  session_id in (select id from se_sessions where participant_id in
    (select id from se_participants where auth_user_id = auth.uid())));

create policy l_own on se_evidence_ledger for select using (
  session_id in (select id from se_sessions where participant_id in
    (select id from se_participants where auth_user_id = auth.uid())));
-- Ledger inserts: service role only. NO update/delete policy = append-only.

create policy res_own on se_results for select using (
  session_id in (select id from se_sessions where participant_id in
    (select id from se_participants where auth_user_id = auth.uid())));

-- Scenarios: gate-cleared readable by any authenticated user
create policy sc_read on se_scenarios for select
  using (status = 'gate_cleared' and auth.role() = 'authenticated');

-- agent_events, dataset_events, human_queue, cohorts: service role only
-- (no anon/auth policies; edge functions use service key).

-- ===========================================================================
-- SPONSOR VIEW — AGGREGATE ONLY. Sponsors never see individual rows unless
-- consent_sponsor_visibility = true, and even then only through a separate,
-- explicitly-built surface (out of Stage-1 scope). This view cannot leak
-- identity: minimum cohort size enforced.
-- ===========================================================================
create or replace view v_se_cohort_rollup as
select
  c.id as cohort_id,
  c.name,
  c.sponsor_org,
  c.package_type,
  count(distinct s.participant_id)                          as participants,
  count(distinct s.id) filter (where s.completed_at is not null) as completed_sessions,
  count(*) filter (where r.overall_band = 'strong')         as strong,
  count(*) filter (where r.overall_band = 'mixed')          as mixed,
  count(*) filter (where r.overall_band = 'weak')           as weak
from se_cohorts c
join se_sessions s  on s.cohort_id = c.id
left join se_results r on r.session_id = s.id
group by c.id, c.name, c.sponsor_org, c.package_type
having count(distinct s.participant_id) >= 5;   -- k-anonymity floor

-- LLM usage rollup, consistent with existing v_llm_usage pattern
create or replace view v_se_llm_usage as
select date_trunc('day', created_at) as day,
       agent_role, model,
       count(*) as calls,
       sum(tokens_in)  as tokens_in,
       sum(tokens_out) as tokens_out,
       count(*) filter (where gate_status = 'human_required') as gate_escalations
from se_agent_events
group by 1,2,3;
