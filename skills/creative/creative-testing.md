---
id: creative-testing
name: Creative Testing Frameworks
category: creative
version: 1.0.0
last_updated: 2026-04-22
loaded_by: [criat, meta, google]
---

# Creative Testing Frameworks

## Overview
Creative testing separates winners from noise. Without structured testing, you either scale fluke winners (regression to mean kills ROAS) or kill latent winners too early (sample too small). This skill covers DCT (Dynamic Creative Testing) vs manual A/B, minimum budget per variant for statistical significance, primary and secondary metrics by objective, winner declaration rules, and the iteration cycle where winners become new controls.

## When to load
Loaded by `criat`, `meta`, `google` agents when:
- Launching a new creative concept batch
- Diagnosing inconclusive test results
- Scaling a winner (new control for iteration)
- Setting testing budget and timeline
- Auditing an account's historical testing hygiene

## Core concepts

### Why testing fails without discipline
- **Sample too small:** 200 impressions per variant can't distinguish 5% vs 7% CTR
- **Too many variables:** 5 variants × 3 audiences = 15 cells, no significance anywhere
- **Premature winner:** day 2 "winner" at 30% confidence scales, then fails day 7
- **Testing cosmetics:** blue vs green button as main test = learning nothing

### Test types by goal
- **Concept test:** which angle/hook wins with this audience?
- **Iteration test:** can we improve on the winner by changing X?
- **Scaling test:** does winner hold at 3x budget / new audience / placement?
- **Fatigue test:** when does winner stop working? (frequency threshold)

## Key frameworks / heuristics

### DCT (Dynamic Creative Testing) — Meta

How it works: single adset, Meta mixes combinations (up to 10 images/videos + 5 headlines + 5 texts + 5 descriptions + 5 CTAs). Meta auto-selects delivery.

**Pros:** Fast, large combination volume, low setup friction.
**Cons:** Opaque (won't reveal exact winner combo), can't pause/scale specific variant, hard to learn directional insight.

**When to use:** Need winner FAST, don't care about "why." Many combinations where manual would be huge matrix. Broad audience where you trust Meta's mixing.

### Manual A/B (separate adsets per variant)

How it works: each variant gets own adset, identical targeting, equal daily budget, run 3-7 days min for significance.

**Pros:** Full visibility (know winner + why), clean pause/scale, directional learnings transfer elsewhere.
**Cons:** Slower (3-7 days), costs more per variant, audience overlap risk at small scale.

**When to use:** Testing structural concepts (angle A vs B). Need learning, not just winner. Post-iteration refinement on known winner.

### Minimum budget per variant

**Rule of thumb:**
- CTR/hook rate decisions: ~1000 impressions per variant min
- CPA decisions: ~50 conversions per variant min for 80% confidence
- ROAS decisions: ~30 purchases per variant min

**Budget calc:**
```
Variants × Conversions needed × CPA target = Total budget

Example: 3 × 50 × R$<cpm> = R$<total_budget> total <!-- example -->
Split 3 = R$2.000 per variant / 5 days = R$400/day per variant <!-- example -->
```

If budget can't support minimum, reduce variants (3→2) or extend timeline (5d→10d).

### Primary metrics by objective

| Objective | Primary | Secondary (leading) |
|---|---|---|
| Conversions (low-ticket) | CPA | CTR, CVR, hook rate |
| Purchase / ROAS | ROAS | AOV, hook rate, CTR |
| Traffic | CPC | CTR, hook rate |
| Video views | Cost per ThruPlay | Hook rate, hold rate |
| Brand awareness | CPM + recall lift | Hook rate, reach/freq |
| Lead gen | Cost per lead | CTR, form completion |

**Leading metrics (video):**
- Hook rate: 3s views / impressions (stopping power)
- Hold rate: 15s views / 3s views (retention quality)
- ThruPlay rate: 95%+ completion / impressions

### Declaring winner — statistical significance

95% confidence standard. Use calculator (inputs: variant A sample + conv, variant B sample + conv). Lift must be directionally large AND statistically supported.

**Minimum practical thresholds:**
- CTR diff ≥20% relative (1.5% vs 1.8%)
- CPA diff ≥15% relative at equal sample size
- ROAS diff ≥10% relative with sufficient revenue

**When NOT to declare winner:**
- <7 days of data (weekend/payday cyclical noise)
- <minimum conversion sample
- Audience overlap not controlled
- Bid strategy differences (CBO vs ABO, auto vs cap)

### Rollout protocol

Once winner declared:
1. Kill losers (pause, keep data)
2. Duplicate winner → new adset at 20-50% higher budget (not 3x immediately)
3. Monitor fatigue (frequency 3.0 yellow, 5.0 red on 7-day window)
4. Queue iteration before current winner fatigues
5. Winner = new control for next iteration test

### Iteration cycle

```
W1: Concept — 3 angles → Winner: Angle B (-35% CPA)
W2: Iteration — B + 3 hooks → Winner: B + Hook 2 (+18% CTR)
W3: Iteration — B + H2 + 2 CTAs → Winner +12% CVR
W4: Scaling — 3x budget → pass/rollback
W5+: Fatigue watch, plan concept refresh
```

### Account testing hygiene
- 20-30% of budget in testing, 70-80% proven winners
- Never 100% in one winner (fatigue + single point of failure)
- Document every test: hypothesis, variants, metrics, decision
- Kill zombie tests (>10 days without decision — inconclusive IS a result)

## Concrete examples

### Test plan — new SaaS account

```
HYPOTHESIS: problem-aware audience responds to "CPA fatigue" angle

TEST: Concept (manual A/B)
  A: "Your CPA is rising — but not because of auction"
  B: "3 creatives killing your ROAS (and you don't know)"
  C: "Data reveal — the real CPA killer in 2025"

AUDIENCE: e-commerce owners, LAL 1% | PLACEMENT: Meta Feed+Reels
BUDGET: R$600/day total (R$200/variant) | DURATION: 7 days <!-- example -->
PRIMARY: CPA | SECONDARY: CTR, hook rate, CVR

WINNER CRITERIA: min 50 conv/variant; CPA diff ≥15% at 95% conf;
CTR ≥1.2%; hook rate ≥20%

ROLLOUT: Week 2 → winner + 3 hook iterations
```

### Winner declaration log

```
Test: Q2-Concept-01 | Ended: 2026-04-15
Variants:
  A: "fatigue" — CPA R$38 | CTR 1.4% | Conv 82 <!-- example -->
  B: "3 mistakes" — CPA R$52 | CTR 1.1% | Conv 54 <!-- example -->
  C: "data reveal" — CPA R$41 | CTR 1.3% | Conv 71 <!-- example -->

Winner: A | Confidence: 97% | Lift: -25% CPA vs B, -7% vs C

Decision:
  - Scale A to R$500/day (was R$200) <!-- example -->
  - Queue iteration: A + new hooks (4 variants)
  - Archive B
  - Keep C as backup

Learnings:
  - "Fatigue" resonates vs "mistakes" framing
  - Hook rate 26% → concept has legs for multiple iterations
```

## Anti-patterns (5+)

1. **Testing cosmetics as main test.** Font color, button shape = micro-lift. Test angles/hooks.
2. **Kill variant at day 2.** Noise. Give 5-7 days or sample minimum.
3. **Multiple concurrent variables.** Audience + copy + creative = no attribution.
4. **Ignoring audience overlap.** Same user sees both = contamination.
5. **Declaring winner on CTR alone.** High CTR + terrible CVR = cheap clicks.
6. **No kill rule.** Running 30 days "to be sure" = opportunity cost.
7. **Scale winner 5x immediately.** Economic instability. 1.5-2x, verify, repeat.
8. **No documentation.** 6 months later re-testing what was learned. Build a log.
9. **Budget too small for significance.** R$100/day × 3 × 5d ≈ 50 conv = noise. <!-- example -->
10. **Treating DCT as granular learning.** Meta gives winners, not insights. Manual A/B for directional.

## Platform specs / constraints
- **Meta DCT:** 10 images/videos, 5 headlines, 5 texts, 5 descriptions, 5 CTAs per adset
- **Meta CBO:** distributes across adsets — use when comparing adsets within campaign
- **Google PMax:** creative testing internal (platform rotates); use asset performance report
- **TikTok ACO:** like Meta DCT with fewer inputs (5 videos, 5 texts)

## References
- Meta Blueprint — Dynamic Creative Testing docs
- Motion App — creative testing playbooks + case studies
- Jon Loomer — Meta testing frameworks blog
- VWO / Optimizely — sample size calculators
- Varos benchmarks — vertical healthy hook/hold/CPA
