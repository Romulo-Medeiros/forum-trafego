# Tracking Setup Checklist

Complete before declaring tracking GREEN.

## GTM container
- [ ] Container installed on every page (head + noscript body)
- [ ] Folders present: 🔵 Meta Ads, 🟠 GA4, 🟢 Google Ads, ⚫ Outros
- [ ] Tag naming convention applied (`{order} | {icon} | {event} | {action}`)
- [ ] Preview mode works without errors

## Meta Pixel + CAPI
- [ ] Pixel base tag fires on all pages
- [ ] Events fire with event_id (UUID or transaction_id)
- [ ] CAPI: each Pixel event has matching server event, same event_id
- [ ] Purchase event carries value + currency + contents array
- [ ] Hashed user_data present (em, ph, fn, ln) when available
- [ ] EMQ ≥ 6.0 on Purchase
- [ ] EMQ ≥ 5.0 on Lead
- [ ] Dedup validated: Meta Events Manager → "Browser and Server"

## Google Ads
- [ ] Conversion actions created (Purchase minimum)
- [ ] Enhanced Conversions ON with hashed email field
- [ ] Transaction-specific value setting ON
- [ ] Conversion diagnostics: GREEN (not "unverified", not "recording issues")

## GA4
- [ ] Measurement ID fires on all pages (page_view)
- [ ] Recommended events: view_item, begin_checkout, purchase with transaction_id
- [ ] DebugView shows events in real time
- [ ] No duplicate transactions (same transaction_id should not arrive twice)

## UTM
- [ ] utm-convention.yaml values adopted for this client
- [ ] Preview URLs built and tested for each ad
- [ ] Redirect chains preserve UTMs (check Hotmart, bitly, redirectors)

## Consent (if LGPD/GDPR)
- [ ] Cookie banner installed with accept + reject + settings
- [ ] Google Consent Mode v2 configured (granular consent types)
- [ ] Meta consent relay configured
- [ ] Tags respect consent state (fire AFTER accept, not before)

## Checkout / Postback integrations
- [ ] Hotmart postback configured (if applicable) → serverless → CAPI Purchase
- [ ] Stripe webhook configured (if applicable) → CAPI Purchase
- [ ] Subscription renewals: tracked separately, do NOT re-fire Purchase

## Documentation
- [ ] `outputs/{client}/tracking.md` lists every event, trigger, destination
- [ ] Access documented (who has GTM admin, Meta Business admin, Google Ads admin)
- [ ] Screenshots attached: EMQ score, dedup "Browser and Server", Consent state

---

**Green = launch OK. Any RED = launch blocked.**
