# Task: daily-check

**Owner:** @meta AND @google (one per channel)
**Type:** Agent
**Duration:** 15-30 min per client per channel

## Purpose
Daily tactical review of live campaigns. Catch anomalies early, apply auto-tier fixes, flag domain issues to specialists.

## Input
- Live campaigns (from platform API or UI)
- Yesterday's metrics snapshot
- Target CPA / CPL / ROAS (from media-plan)
- 3-day and 7-day trend data

## Output
- `outputs/{client}/daily-check-{channel}-{date}.md`:
  - Per-campaign status (GREEN / YELLOW / RED)
  - Anomalies detected + probable root cause
  - Actions taken (auto-tier)
  - Actions flagged for HITL
  - Actions flagged for specialists (@criat fatigue, @tracker event issue, @maestro strategic)

## Steps (Meta)
1. Pull campaign metrics (spend, CPM, CTR, CPC, freq, purchases, CPA, ROAS)
2. Compare vs target + vs yesterday + vs 3d avg
3. Spot signals per `daily_check_signals` in meta agent
4. Action per signal:
   - Freq >2.5 + CTR dropping → creative fatigue → flag @criat
   - CPM spike >30% → audience overlap → pause duplicate ad set (HITL)
   - Pacing drift >15% → audit delivery (disapproved ads? budget cap?)
   - Purchase events <1 + spend >R$200 → tracking suspect → flag @tracker
5. Apply auto-tier: pause under-performers, shift small budget (<10%)
6. Document + handoff flags

## Steps (Google)
1. Pull metrics (impression share, CTR, QS, conversions, CPA, ROAS, lost-IS-budget, lost-IS-rank)
2. Search-term report scan: irrelevant terms → add negatives (auto-tier)
3. QS drops → flag to revisit ad copy / LP relevance
4. IS lost to budget → flag @maestro (underfunded)
5. IS lost to rank → bid or QS issue
6. PMax: check asset group distribution (>80% in one = rebalance)
7. Document + handoff

## Acceptance Criteria
- [ ] Every live campaign assessed (no skipping)
- [ ] Each anomaly has probable cause and routed action
- [ ] No decisions on single-day noise (3-day trend minimum unless pacing-anomaly)
- [ ] Auto-tier actions within scope (pause, <10% budget shift, negatives)
- [ ] HITL actions clearly flagged (scale >20%, kill, audience exit)

## Veto Conditions
- Budget change >20% without @maestro approval → VETO
- Scaling on single day of good CPA → VETO
- Adding negatives that would hurt brand terms → VETO
- Declaring tracking broken without asking @tracker to validate → VETO

## Handoffs
- @criat (creative fatigue flags)
- @tracker (event firing / dedup suspect)
- @maestro (strategic: underfunded, market shift, client conflict)
- human (HITL actions: scale, kill, activate)
