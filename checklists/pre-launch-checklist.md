# Pre-Launch Checklist

Shield gate before any campaign moves from PAUSED to ACTIVE.

**Rule:** every item must be GREEN. One RED = NO LAUNCH.

## Tracking
- [ ] Purchase event fires from Pixel AND CAPI with SAME event_id (dedup GREEN)
- [ ] EMQ ≥ 6.0 on Purchase (Meta Events Manager Test Events)
- [ ] Enhanced Conversions ON (Google)
- [ ] Purchase value + currency non-null, non-zero
- [ ] Consent Mode v2 configured (if LGPD/GDPR region)
- [ ] UTM convention applied, preview URL built and tested

## Creative
- [ ] Every ad has final copy (no `{placeholder}` text left)
- [ ] Every creative in correct platform spec (aspect ratio, duration, file size)
- [ ] Text-on-image under 20% (Meta) — warn if over
- [ ] No em-dashes in final copy (AI flag)
- [ ] No banned words (unlock, unleash, game-changer, revolutionary, supercharge)
- [ ] Hook clearly visible in first 3s (video) or above-the-fold (static)

## Policy
- [ ] Restricted category check: health / finance / housing / employment / cripto — policy-check passed
- [ ] No before/after shots if health category
- [ ] No misleading claims (income promise, weight-loss timeline without disclaimer)
- [ ] Trademark respects (no competitor brand in ad copy)
- [ ] LP has privacy policy + terms visible

## Landing page
- [ ] LP load time < 3s on mobile (test on real device or WebPageTest)
- [ ] LP copy matches ad promise (no bait-and-switch)
- [ ] CTA above fold and repeated
- [ ] Forms fire Lead event
- [ ] Checkout flow fires InitiateCheckout + Purchase events
- [ ] Mobile tap targets ≥ 44px

## Platform structure
- [ ] Meta: ≥3 ad sets (not 1)
- [ ] Meta: budget allows 50 conv / ad set / week
- [ ] Google PMax: negatives list present, brand exclusion present, audience signals present
- [ ] Google Search: brand and non-brand separated
- [ ] All campaigns in PAUSED status (screenshot in deliverable)

## Budget + goals
- [ ] Budget envelope confirmed by human
- [ ] Target CPA / CPL / ROAS documented
- [ ] Learning-phase expectation communicated to client (first 7 days = data, not judgement)

## Governance
- [ ] Persona, offer, funnel, tracking, creative, media-plan — all 6 docs exist in `outputs/{client}/`
- [ ] Human has explicitly approved the activation
- [ ] Rollback plan exists (what to pause if costs runaway in first 24h)

---

**Go/no-go:** all boxes checked = human-approved launch. Anything unchecked = block + fix + re-gate.
