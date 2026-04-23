# Task: weekly-report

**Owner:** @maestro (synthesis); @meta + @google (data feed)
**Type:** Agent
**Duration:** 45-90 min per client

## Purpose
Weekly strategic digest: what worked, what didn't, what to change, what to escalate.

## Input
- 7-day campaign data per channel
- Daily-check logs from the week
- Target vs actual (CPA, ROAS, spend, conversions, pipeline value)
- Creative performance (winners, losers, fatigue signals)
- Tracking health summary
- Client context updates (new product? price change? seasonal?)

## Output
- `outputs/{client}/weekly-report-{YYYY-WW}.md`:
  - Executive summary (3 bullets: biggest win, biggest miss, biggest decision needed)
  - Performance table (per channel per campaign)
  - Creative digest (top 3 winners, top 3 to kill, fatigue alerts)
  - Recommended actions (per channel, per priority)
  - HITL decisions needed (budget shifts, kills, new tests)
  - Next week plan

## Steps
1. Pull 7-day data per channel (spend, CPA, ROAS, conversions, ROAS by campaign)
2. Compare vs target vs previous week vs 4-week trailing
3. Identify 3 biggest levers (top-spending campaigns)
4. Creative analysis: winners (keep scaling), fatigue (request @criat refresh), clear losers (kill)
5. Tracking sanity: EMQ trend, any broken events, postback health (Hotmart/Stripe)
6. Draft recommendations in priority order (highest ROI first)
7. Flag HITL decisions explicitly (what, why, cost of inaction)
8. Sketch next week plan (1-2 tests, 1-2 scales, 1-2 kills)
9. Write executive summary LAST (once the analysis is done, write the tldr)

## Acceptance Criteria
- [ ] Executive summary is 3 bullets, each <20 words
- [ ] Every recommendation has expected impact (not just "optimize X")
- [ ] HITL decisions are specific (amount, target, timeline)
- [ ] Next week plan is concrete (tests, scales, kills with names)
- [ ] No "we should keep monitoring" lines (always decide or explicitly defer with reason)

## Veto Conditions
- Report without decisions → VETO (it's a digest, not a diary)
- Creative "winners" without >30 conversions → VETO (noise)
- Recommendation without expected impact → VETO
- Hiding bad news in long paragraphs → VETO (exec summary must surface misses)

## Handoffs
- human (HITL decisions + next-week approval)
- @criat (fatigue refresh requests, new hook angles)
- @tracker (tracking issues flagged during analysis)
- @meta/@google (next-week test briefs)
