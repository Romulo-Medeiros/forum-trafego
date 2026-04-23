# Task: create-media-plan

**Owner:** @meta OR @google (depending on channel)
**Type:** Agent
**Duration:** 30-60 min wall-clock per channel

## Purpose
Build a channel-specific media plan ready to implement in the ad platform.

## Input
- Onboarding doc (`outputs/{client}/onboarding.md`)
- Budget envelope (monthly) for this channel
- Hooks + creatives from @criat (or commission if missing)
- Tracking GREEN from @tracker (or explicit "not-yet — launch blocked until")

## Output
- `outputs/{client}/media-plan-{channel}.md` with:
  - Objective + KPI target (CPA / CPL / ROAS)
  - Campaign structure (campaigns → ad sets → ads)
  - Audience layers
  - Budget per ad set + bidding strategy
  - DCT / RSA matrix
  - Tracking requirements (events, conversion actions)
  - Launch status: ALL PAUSED
  - Shield gate checklist

## Steps

### Meta channel
1. Confirm objective (Sales / Leads / Traffic — reframe Traffic to Sales if possible)
2. Pick budget structure (CBO vs ABO) — default CBO with 3 ad sets
3. Design audience layers (Advantage+, Interest cluster, LAL)
4. Request hooks + creative from @criat (if not delivered)
5. Build DCT matrix (3 primary texts × 3 creatives × 3 headlines)
6. Pick placements (Advantage+ Placements by default)
7. Pick bidding (Lowest cost first 7d, then Cost cap at 0.9× target)
8. Request tracking from @tracker (Purchase/Lead + events + CAPI + EMQ ≥6)
9. Document all ad sets in PAUSED state
10. Shield gate: policy check on hook + creative + LP, compliance OK

### Google channel
1. Pick channel mix (Search, Shopping, PMax, YT, Demand Gen)
2. Design campaign separation (brand / non-brand / shopping / PMax)
3. Keyword research (if Search/Shopping) — intent-scored
4. Negative keyword list (account + campaign)
5. Request RSA from @criat (15 headlines + 4 descriptions)
6. Pick bidding (Maximize Conv → tCPA after 30 conv / 30d → tROAS when revenue reliable)
7. Audience signals for PMax (customer list + site visitors + custom segments)
8. Request conversion tracking from @tracker (Purchase with transaction value + Enhanced Conv)
9. Document all campaigns in PAUSED state
10. Shield gate: policy check + LP compliance

## Acceptance Criteria
- [ ] Structure fits Meta's or Google's current best practice (not legacy tactics)
- [ ] At least 3 ad sets (Meta) or 2+ campaigns with proper separation (Google)
- [ ] Budget math respects learning phase (50 conv / adset / week for Meta)
- [ ] Tracking requirements documented to @tracker with exact event names
- [ ] All launch status PAUSED
- [ ] Shield gate items listed explicitly

## Veto Conditions
- Single ad set on Meta → VETO (not a test)
- PMax without negatives → VETO
- Brand + non-brand in same Google campaign → VETO
- Missing tracking requirements → VETO
- Any campaign ACTIVE before human approval → VETO

## Handoffs
- @tracker (event setup)
- @criat (if creatives missing)
- @maestro (Shield gate convening)
- human (launch activation)
