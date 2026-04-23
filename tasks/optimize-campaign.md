# Task: optimize-campaign

**Owner:** @meta OR @google (channel specialist)
**Type:** Agent
**Duration:** 30-90 min per optimization cycle

## Purpose
Root-cause diagnosis + action plan when a campaign misses target. This is NOT a daily check — it's the response to a 3-day negative trend or a significant anomaly.

## Input
- Campaign in question (name, channel, current metrics, trend)
- Target metrics (CPA, ROAS, CPL)
- 7-day and 14-day history
- Creative inventory
- Tracking health (from @tracker)

## Output
- `outputs/{client}/optimize-{campaign}-{date}.md`:
  - Root cause hypothesis (ranked)
  - Actions (kill / scale-horizontal / creative refresh / audience swap / bid change / pause)
  - Expected outcome per action
  - Rollback trigger (when to revert)
  - Handoffs

## Diagnosis framework (3-layer)

**Layer 1: is the metric real?**
- Tracking: EMQ still ≥6? CAPI dedup working? Purchase value correct? → if no, @tracker first
- Attribution: window right? first-touch vs last-touch mismatch?
- Volume: enough data? < 30 conversions = statistical noise

**Layer 2: creative or audience?**
- Frequency >2.5 + CTR dropping → **creative fatigue** — refresh via @criat
- Frequency OK but CTR never good → **hook/offer misfit** — revisit persona with @maestro
- CTR good but CPA bad → **LP or offer misfit** — conversion downstream, not ad
- Audience fatigue: new-to-audience metric drops → **audience saturation** — horizontal scale via LAL layers

**Layer 3: platform dynamics?**
- Meta learning reset (budget changed >20%): wait 50 conv before re-judging
- Google QS drop: LP relevance, ad copy, CTR all feed QS
- CPM spike industry-wide: seasonality (Q4, Black Friday)

## Steps
1. **Confirm target and current delta** (don't optimize ghosts)
2. **Run 3-layer diagnosis** top-down (tracking first, always)
3. **Rank hypotheses** with evidence
4. **Design actions** — smallest first (change 1 variable)
5. **Predict outcome + rollback** for each
6. **Execute auto-tier actions**; stage HITL actions for @maestro/human
7. **Schedule re-evaluation** (72h minimum to avoid single-day noise)

## Acceptance Criteria
- [ ] Tracking health confirmed before any creative/audience change
- [ ] At least 2 hypotheses considered (not just the obvious one)
- [ ] Action list has ONE variable change per action (A/B testable)
- [ ] Rollback trigger defined per action
- [ ] Re-eval date set

## Veto Conditions
- Changing 3+ variables at once → VETO (un-attributable result)
- Optimizing on < 30 conversions → VETO (noise, not signal)
- Skipping tracking check → VETO
- Killing a campaign with < 7 days of data → VETO (premature)

## Handoffs
- @tracker (if Layer 1 fails)
- @criat (if creative fatigue)
- @maestro (if offer/persona misfit or strategic shift)
- human (kill/scale-vertical decisions)
