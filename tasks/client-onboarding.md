# Task: client-onboarding

**Owner:** @maestro
**Type:** Agent (orchestrated — delegates to @criat, @tracker, @meta/@google)
**Duration:** 20-40 min wall-clock (assumes client intake form filled)

## Purpose
Intake a new client, sketch persona, decide funnel, commission a first campaign plan.

## Input
- Client business summary (what they sell, to whom, at what ticket)
- Access to: website, current ads (if any), CRM, sales data (if any)
- Business goals (revenue target, timeline, constraints)

## Output
- `outputs/{client}/onboarding.md` with:
  - Persona sketch (1-page)
  - Funnel decision + rationale (short / medium / long)
  - Channel split (Meta / Google / other %)
  - First-campaign blueprint (briefs per agent)
  - Timeline + next-step owners
- Handoffs to @criat (hooks), @tracker (setup-tracking), @meta/@google (media plan)

## Steps
1. **Intake:** collect business summary, ticket, persona raw signals (reviews, DMs, existing creatives)
2. **Persona sketch:** 1-page — demographics, pains, desires, objections, level of awareness (Schwartz 1-5)
3. **Funnel decision:** apply `funnel_decision_matrix` from maestro — pick short/medium/long
4. **Channel split:** apply `channel_split_heuristic` from maestro
5. **Budget envelope:** confirm with human (monthly envelope, per-client, per-channel)
6. **Briefs:**
   - @criat: 5 hooks (hook_grid), 3 video briefs (30s), 1 LP copy (if no LP)
   - @tracker: setup-tracking full
   - @meta OR @google (or both): create-media-plan
7. **Timeline:** target launch date, Shield gate date, first-review date
8. **Handoff:** `outputs/{client}/onboarding.md` committed. Agents take their slice.

## Acceptance Criteria
- [ ] Persona sketch has at least 1 specific pain and 1 specific desire (not generic)
- [ ] Funnel decision names ticket + consciousness + vertical as rationale (no hand-waving)
- [ ] Tracker task dispatched (tracking must finish before launch, not after)
- [ ] All agents have a concrete brief (not "figure it out")
- [ ] Timeline respects PAUSED-by-default (launch date = human activation, not automatic)

## Veto Conditions
- Proceeding without persona → VETO
- Picking a channel before funnel → VETO
- Launching without @tracker in the plan → VETO
- Skipping Shield gate in the timeline → VETO

## Handoffs
- @criat (hooks + briefs)
- @tracker (setup-tracking)
- @meta and/or @google (create-media-plan)
- human (budget confirmation, launch activation)
