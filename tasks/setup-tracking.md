# Task: setup-tracking

**Owner:** @tracker (EXCLUSIVE)
**Type:** Agent
**Duration:** 2-6h wall-clock per client (first-time)

## Purpose
Install end-to-end tracking (GTM + Pixel + CAPI + GA4 + UTM + consent) for a new client until EMQ ≥ 6.0 and every funnel event dedupes correctly.

## Input
- Site access (GTM container ID, admin access, or dev contact)
- Pixel ID (Meta), Measurement ID (GA4), Conversion ID (Google Ads)
- Checkout platform (Hotmart, Stripe, shopping cart, etc.)
- Funnel map (pages that represent each event stage)
- Consent legal context (LGPD, GDPR, neither)

## Output
- GTM container deployed with:
  - 🔵 Meta Ads folder (Pixel + CAPI tags with event_id dedup)
  - 🟠 GA4 folder (config + events)
  - 🟢 Google Ads folder (conversions + Enhanced Conv)
  - 🟣 TikTok (if applicable)
  - ⚫ Consent Mode v2 bridge
- `outputs/{client}/tracking.md`:
  - Event map (event → trigger → platforms)
  - UTM convention for this client
  - EMQ score evidence (Meta Events Manager Test Events screenshot)
  - Dedup validation (browser + server = 1 count)
  - Consent mode validation
  - Access documentation (who has what)

## Steps
1. **Audit:** current tags, fires, duplicates, fragility. Document what's broken.
2. **Design:** event map (PageView, ViewContent, Lead, AddToCart, InitiateCheckout, AddPaymentInfo, Purchase). One event_id per transaction.
3. **Container build:** all tags inside GTM, no hardcoded tags in page source.
4. **Hashed user data:** email + phone hashed client-side for enhanced matching (Meta + Google).
5. **CAPI:** server-side Purchase + Lead firing with event_id matching the Pixel event. No orphan server events.
6. **Checkout bridge:** Hotmart postback → CAPI Purchase (if Hotmart). Stripe webhook → CAPI Purchase (if Stripe).
7. **UTM plan:** apply `utm-convention.yaml`. Document per-channel values.
8. **Consent Mode v2:** configure Google + Meta. Tags only fire after user consent.
9. **Validate:** Test Events (Meta) EMQ ≥ 6.0, Google Ads conversion diagnostics GREEN.
10. **Dedup validation:** simulate 1 real purchase, confirm 1 row in Meta, deduped.
11. **Document:** everything in `outputs/{client}/tracking.md`.
12. **Handoff:** return GREEN to @maestro + @meta/@google.

## Acceptance Criteria
- [ ] EMQ ≥ 6.0 on Purchase event (Meta)
- [ ] Deduplication validated (Meta Events Manager shows "Browser and Server")
- [ ] All events fire with event_id set
- [ ] Enhanced Conversions ON (Google)
- [ ] Consent Mode v2 configured (if LGPD/GDPR)
- [ ] Purchase carries value + currency (not null, not zero)
- [ ] UTM convention documented and shared with @meta + @google
- [ ] No hardcoded tags outside GTM

## Veto Conditions
- EMQ < 6.0 → VETO launch
- Missing event_id on CAPI → VETO
- Purchase value=0 or currency missing → VETO
- Consent mode not configured for LGPD region → VETO
- Tags hardcoded outside container → VETO (rot guaranteed)

## Handoffs
- @meta (tracking GREEN, EMQ score, events firing)
- @google (conversion actions GREEN, Enhanced Conv on)
- @maestro (tracking blocker if site access missing, legal consent issue, or dev dependency)
