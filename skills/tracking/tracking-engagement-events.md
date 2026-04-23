---
id: tracking-engagement-events
name: Engagement Events + EMQ Optimization
category: tracking
version: 1.0.0
last_updated: 2026-04-22
loaded_by: [tracker]
---

# Engagement Events + Advanced Matching + EMQ Optimization

## Overview
Mandatory event catalog for every client tracking implementation. Raises Meta Event Match Quality (EMQ) from baseline 3-5 to target >=8.0 through comprehensive engagement signals + Advanced Matching fields. This skill is **NON-NEGOTIABLE** for any tracker setup — no client ships without these events + matching signals wired up.

## When to load (triggers)
- Any new client tracking setup
- EMQ score below 6.0 in Meta Events Manager
- Improving existing tracking (audit + expansion)
- Building GTM containers for new nicho
- Any *setup-tracking, *optimize-emq, or *audit-tracking run

## Core concepts

### EMQ Score (0-10)
Meta calculates per-event match quality based on how many signals Meta can use to link the event to a real user. Higher EMQ = better ad delivery + lower CPA + better Advantage+ modeling.

Tiers:
- 0-3 = critical low (event effectively useless — Meta can't match to a user)
- 4-6 = baseline (most accounts here by default)
- 7-8 = target (our squad standard — all clients must reach this)
- 9-10 = excellent (requires checkout platform data + full profile)

### 15 EMQ signals (collect ALL possible)

| Signal | Priority | Source | Plaintext/Hashed |
|---|---|---|---|
| fbp | MANDATORY | cookie `_fbp` (auto-gen) | plaintext |
| fbc | MANDATORY | cookie `_fbc` (from fbclid) | plaintext |
| client_user_agent | MANDATORY | navigator.userAgent | plaintext |
| client_ip_address | MANDATORY | server headers | plaintext |
| external_id | HIGH | localStorage UUID (persistent) | SHA-256 |
| em (email) | HIGH | form/checkout capture | SHA-256 |
| ph (phone) | HIGH | form/checkout capture | SHA-256 |
| fn (firstName) | MED | form/checkout | SHA-256 |
| ln (lastName) | MED | form/checkout | SHA-256 |
| ct (city) | MED | form/IP geo enrichment | SHA-256 |
| st (state) | MED | form/IP geo | SHA-256 |
| zp (zip/CEP) | MED | form | SHA-256 |
| country | LOW | IP geo (auto) | SHA-256 ISO-2 |
| db (DOB) | LOW | form (if asked) | SHA-256 YYYYMMDD |
| ge (gender) | LOW | form (if asked) | SHA-256 m/f |

Also include UTM params in custom_data (not EMQ but improves attribution).

## MANDATORY event catalog per client

### Standard events (10)
- `PageView` — automatic on every page
- `ViewContent` — when main offer/product is visible
- `Lead` — form submit (email/phone/name captured)
- `InitiateCheckout` — CTA clicked going to payment platform
- `AddPaymentInfo` — user selects payment method (optional for redirect-only flows)
- `Purchase` — thank-you page, with value + currency + transaction_id
- `Contact` — WhatsApp/phone/email click
- `CompleteRegistration` — free signup (non-paid conversion)
- `Search` — internal search (if site has search)
- `Subscribe` — recurring subscription started

### Custom engagement events (MINIMUM required)
- `Scroll_25`, `Scroll_50`, `Scroll_75`, `Scroll_100` — viewport progress
- `TimeOnPage_30s`, `TimeOnPage_60s`, `TimeOnPage_180s` — session depth
- `Video_Play`, `Video_25`, `Video_50`, `Video_75`, `Video_Complete` — per video (auto-detect VTurb/YouTube/Vimeo/native)
- `Button_Click` — CTAs + primary buttons (with label in custom_data)
- `Section_View` — key sections (hero, offer, pricing, FAQ) visible 50%+
- `OutboundClick` — external domain links

## Key frameworks / heuristics

### Implementation minimum checklist (BLOCKING for launch)
- [ ] `fbp` + `fbc` cookies set on first page load
- [ ] `external_id` persisted to localStorage (UUID v4)
- [ ] `client_user_agent` + `client_ip_address` included in CAPI payload
- [ ] All MANDATORY standard events wired up (PageView, ViewContent, InitiateCheckout, Purchase minimum)
- [ ] `initAllTrackers()` or equivalent called in DOMContentLoaded -> activates scroll/time/video/button/section/outbound
- [ ] Advanced Matching `setUserData()` called when form/checkout captures user data
- [ ] SHA-256 hashing done CLIENT-SIDE before sending to server (defense in depth)
- [ ] CAPI endpoint auto-hashes any raw fields that slipped through
- [ ] Geo enrichment from edge headers (Vercel: `x-vercel-ip-*`) server-side
- [ ] EMQ test: fire test event, verify >=6.0 in Meta Events Manager Test Events
- [ ] No PII in custom_data — only in user_data (hashed)

### EMQ-raising tactics per level
- **EMQ 0-3**: missing fbp/fbc — add cookie bootstrap + fbclid capture
- **EMQ 4-5**: missing external_id — add localStorage UUID
- **EMQ 6-7**: missing Advanced Matching — capture email/phone in forms/checkout
- **EMQ 8-9**: add city/state/country from geo enrichment
- **EMQ 10**: add db/ge (date of birth/gender) from profile data

### Event_id deduplication protocol
For every event:
1. Generate UUID v4 client-side
2. Fire browser pixel with `fbq('track', name, params, { eventID: uuid })`
3. POST to CAPI with same `event_id` field
4. Meta merges within 48h window — zero double-counting

### Scroll/time event budget
- Scroll: 4 events per page per session (25/50/75/100) -> max
- Time: 3 events per session (30/60/180s)
- Video: 5 events per video (play/25/50/75/complete)
- Button_Click: deduped per session (same button only fires once)

This prevents Meta rate limiting + keeps signal meaningful.

### Signal priority when budget is limited
If the client has zero time/budget for full rollout, ship in this order (each layer builds EMQ):
1. **Layer 1 (1h work)**: fbp + fbc cookies + PageView + Purchase — minimum viable tracking, EMQ ~4
2. **Layer 2 (2h work)**: Lead + InitiateCheckout + external_id in localStorage — EMQ ~6
3. **Layer 3 (3h work)**: Advanced Matching (em, ph, fn, ln from form) — EMQ ~7.5
4. **Layer 4 (1h work)**: Scroll/Time/Video engagement events — lifts signal density (EMQ ~8)
5. **Layer 5 (2h work)**: Geo enrichment (ct, st, country from server) — EMQ ~8.5+

Never skip Layer 1-3. Layer 4-5 are the squad STANDARD for any client going live.

### Storage locations for persistent signals
| Signal | Storage | TTL | Reset trigger |
|---|---|---|---|
| fbp | cookie `_fbp` | 90 days | cross-domain visit |
| fbc | cookie `_fbc` | 90 days | new fbclid arrives |
| external_id | localStorage `aiox_eid` | permanent | manual clear |
| session_id | sessionStorage `aiox_sid` | tab close | new session |
| fired_events | sessionStorage `aiox_fired` | tab close | dedup scroll/time per session |

## Concrete examples

### Example 1: VTurb VSL tracking (like downsell-heropass)
VTurb smartplayer doesn't expose events. Pattern: poll `currentTime` vs `duration` at 1s interval, emit Video_25/50/75/Complete on threshold crossings. Reference: `hero-academy-lowtickets/shared/pixel-meta.js` `initVideoTracker`.

### Example 2: Adding Advanced Matching from form
```javascript
form.addEventListener('submit', async (e) => {
  const email = form.querySelector('[name="email"]').value;
  const phone = form.querySelector('[name="phone"]').value;
  const name = form.querySelector('[name="name"]').value;
  await window.setUserData({ email, phone, firstName: name.split(' ')[0], lastName: name.split(' ').slice(1).join(' ') });
  window.trackMetaEvent('Lead', { content_name: 'newsletter-optin' });
});
```
After this, ALL subsequent events (including Purchase on thank-you) auto-include hashed Advanced Matching.

### Example 3: Thank-you purchase with value from redirect
Checkout platform redirects to: `/obrigado?product=lt1-console-creator&value=47&order_id=XYZ`
Thank-you LP calls `window.trackPurchase_FromQuery()` -> parses query, fires Purchase with value + transaction_id.

## Anti-patterns (10)
- Firing `Purchase` without transaction_id (Meta will dedupe incorrectly)
- Sending raw email in custom_data (leak!) — must be hashed in user_data only
- Skipping event_id -> browser + CAPI double-count (15-30% overcount typical)
- Tracking every scroll pixel instead of milestones (spam -> rate limit)
- Using Math.random() for event_id (not unique enough — use crypto.randomUUID)
- Not capturing fbclid from landing URL (loses attribution for paid traffic)
- Hardcoding pixel ID in multiple files (use env var + single export)
- Hashing fbp/fbc/IP/user_agent — these MUST go raw, hashing breaks matching
- Firing engagement events (Scroll_50, TimeOnPage_60s) to CAPI only — needs browser Pixel too so Meta can build audiences
- Copy-pasting external_id generation across files — single source of truth in shared/pixel-meta.js

## Platform specs / constraints
- Meta Pixel max 40 custom parameters per event
- CAPI rate limit: 1000 events/min/dataset (default; higher on request)
- event_id max 40 chars (UUID v4 = 36 chars — OK)
- Advanced Matching fields must be normalized before hashing: trim + lowercase
- Phone must be digits-only with country code (ex: `5511988887777` for BR mobile)
- DOB format for hashing: `YYYYMMDD`
- Country: ISO-2 lowercase (`br`, `us`, `gb`)

## References
- Reference implementation: `apps/hero-academy-lowtickets/shared/pixel-meta.js` (dispatcher with all trackers)
- CAPI with server-side hashing: `apps/hero-academy-lowtickets/api/capi-event.js`
- Deploy guide: `apps/hero-academy-lowtickets/TRACKING-DEPLOY.md`
- Related skills (local): `gtm-implementation`, `meta-pixel-capi`, `server-side-tagging`, `consent-mode`, `end-to-end-tracking`
- Meta docs: Events Manager -> Match Quality (EMQ details + diagnostic)
