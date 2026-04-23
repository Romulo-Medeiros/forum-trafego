---
id: hotmart-sck-tracking
name: Hotmart SCK Tracking (UTM to sck collapse)
category: tracking
version: 1.0.0
last_updated: 2026-04-22
loaded_by: [tracker]
---

# Hotmart SCK Tracking

## Overview
Hotmart identifies traffic source via the `sck` query parameter on every checkout URL. Without `sck`, every paid lead arrives as "direct" in Hotmart Sales reports and all ads attribution is lost. This skill enforces four responsibilities that together restore full attribution across multi-page funnels:

1. **UTM Persist** — cookies survive the multi-page flow so a user who landed via Meta ad on day 1 still carries `utm_*` on day 3.
2. **SCK collapse** — UTMs compressed into a single pipe-separated string (`facebook|cpc|launch|video-ugc|kit`).
3. **Link rewrite** — every Hotmart CTA on the page gets `?sck=...` appended automatically.
4. **Click ID preservation** — `fbclid`, `gclid`, `ttclid` forwarded from landing to Hotmart so Meta/Google/TikTok can close the attribution loop.

Implementation reference: `apps/hero-academy-lowtickets/shared/hotmart-sck.js`.

## When to load (MANDATORY triggers)
- Client checkout platform is **Hotmart** (infoproduto, course, ebook, any digital product).
- Client runs **paid traffic** AND routes to Hotmart (Meta/Google/TikTok → LP → Hotmart).
- Multi-page funnels ending at Hotmart (lead → nurture email → VSL → Hotmart checkout).
- Launches where attribution MUST link ad spend to Hotmart sales (Lens needs `sck` to join).

## When NOT to load
- Client uses **Stripe** exclusively — Stripe uses `client_reference_id` instead. Load `stripe-client-reference` skill (if exists) or adapt.
- Client uses **Kiwify** — similar pattern (`sck`), but platform-specific quirks. Adapt this skill or create `kiwify-sck-tracking`.
- Client uses **Eduzz** — Eduzz relays `utm_*` natively through redirect, no collapse needed.
- Organic-only traffic and no Lens join requirement (rare, usually still worth it).

## Core concepts

### SCK format (agency standard)
Default is **5 fields, pipe-separated**:

```
{utm_source}|{utm_medium}|{utm_campaign}|{utm_content}|{utm_term}
```

Example: `facebook|cpc|lt1-launch-apr26|ad-video-ugc-gain|kit-console-creator`

Shorter variants when informational density is less critical:
- 3 fields: `{utm_source}|{utm_campaign}|{utm_content}`
- 2 fields: `{utm_source}|{utm_campaign}`
- 1 field: `{utm_campaign}`

**Rule of thumb:** start with 5 fields — parsing less is trivial, reconstructing more is impossible once it's lost.

### UTM Persist
- First visit with `utm_*` in URL → write each to cookie (90d, SameSite=Lax).
- Later page loads without UTMs → SCK rebuilt from cookies → attribution stays correct.
- Window: **90 days** matches the Meta `_fbc` cookie window → attribution window consistency.
- Cookie names MUST match what `pixel-meta.js` reads: `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, `utm_term` (no custom prefix).

### Link rewrite
- Match all `<a href>` whose URL hits a Hotmart domain: `hotmart.com`, `pay.hotmart`, `hotmart.com.br`.
- Append `?sck=<built>` preserving any existing query params.
- If `?sck=` is already on the URL (manually set for a specific campaign), **do not overwrite** — respect the manual value.
- **MutationObserver re-runs rewrite** on DOM changes — handles SPA lazy mounts, jQuery/React CTAs injected post-load, exit-intent popups.

### Click ID preservation
- `fbclid` — Facebook Click ID (required for Meta `_fbc` matching in Events Manager).
- `gclid` — Google Click ID (required for Google Ads attribution; Google auto-tagging).
- `ttclid` — TikTok Click ID.
- Copied from URL OR cookie → to the rewritten Hotmart URL.
- Allows Hotmart to relay the click ID in post-purchase webhooks so Meta/Google/TikTok CAPI can close the loop.

## Key frameworks / heuristics

### Implementation checklist (BLOCKING for Hotmart clients)
- [ ] `hotmart-sck.js` included in `<head>` or `<body>` BEFORE `pixel-meta.js` (load order matters — UTM Persist runs first).
- [ ] SCK format matches agency standard (5-field default) OR deviation documented with justification.
- [ ] Cookies set on first UTM-carrying visit (test: land with `?utm_source=test&utm_campaign=x`, refresh on a page without params → cookies persist).
- [ ] All Hotmart CTAs get `?sck=` on click (test: open devtools, inspect `<a href>` of every Hotmart link after page load + after dynamic CTAs mount).
- [ ] Click IDs (fbclid/gclid/ttclid) preserved in rewritten URL when present on landing.
- [ ] Hotmart Dashboard → Sales → "Origem da venda" shows `sck` populated (test with real traffic — purchase a low-value sandbox product and verify). <!-- example: R$ 1 or equivalent test SKU -->
- [ ] No double-encoding — pipes in `sck` are raw `|`, not `%7C` (Hotmart dashboard parses raw pipes; `%7C` won't roundtrip).
- [ ] Both `hotmart-sck.js` and `pixel-meta.js` read the **same cookies** (utm_source etc.) — zero divergence.

### SCK format decision tree
- Client has >=5 campaign dimensions (niche × angle × stage × format × offer) → 5-field.
- Client has 3 dimensions → 3-field.
- Client is solo (1-2 campaigns at a time) → 1-field (`{utm_campaign}`) may suffice.
- If unsure → start with 5-field. You can shorten later; you can't reconstruct.

### Hotmart-specific params beyond SCK
- `xcod` — extra tracking code (optional, 1 additional dimension). Useful for publisher-ID on affiliate-heavy flows.
- `off` — offer code (if Hotmart product has multiple offers, this selects which offer the checkout shows).
- `checkoutMode` — 2-step vs 1-step checkout (value `2` vs `10`). A/B candidate for conversion.
- Configure client-side when the client's Hotmart setup uses them.

### Shared-cookie discipline with pixel-meta.js
- `hotmart-sck.js` writes UTMs to cookies → `pixel-meta.js` reads them in `getUtmParams()`.
- Load order: **hotmart-sck.js BEFORE pixel-meta.js**. If reversed, first PageView CAPI call on a non-UTM page sends empty UTMs even though cookies exist.
- Pixel script reads URL first, then falls back to cookies — consistent with how Meta expects `_fbc` behavior.

## Concrete examples

### Example 1: Landing with Meta Ads traffic
<!-- example URLs below use <CLIENT_LP_DOMAIN> placeholder — substitute per-client -->
**URL landed:**
```
https://<CLIENT_LP_DOMAIN>/?utm_source=facebook&utm_medium=cpc
  &utm_campaign=lt1-launch&utm_content=video-ugc&utm_term=kit&fbclid=abc123
```

**Cookies set (90d, SameSite=Lax):**
```
utm_source=facebook
utm_medium=cpc
utm_campaign=lt1-launch
utm_content=video-ugc
utm_term=kit
fbclid=abc123
```

**CTA original:** `https://pay.hotmart.com/<PRODUCT_ID>` <!-- example: Hotmart checkout URL pattern -->

**CTA rewritten:** `https://pay.hotmart.com/<PRODUCT_ID>?sck=facebook|cpc|lt1-launch|video-ugc|kit&fbclid=abc123` <!-- example -->

### Example 2: Multi-page nurture flow
- **Day 1:** user lands with full UTMs → cookies persist (90d).
- **Day 3:** user opens nurture email → clicks link to VSL page (no UTMs on that URL) → cookies still valid.
- **Day 3:** VSL page reads cookies → SCK built correctly → CTA on VSL points to Hotmart with full `?sck=` → Hotmart Sales shows this purchase attributed to `facebook|cpc|lt1-launch|video-ugc|kit`.

### Example 3: Direct traffic (no UTM, no cookies)
**URL:** `https://<CLIENT_LP_DOMAIN>/` (cold, no params, first visit ever) <!-- example placeholder -->

**SCK built:** `direct|direct|direct|direct|direct` (configurable via `data-fallback`; agency default = `direct`).

**Hotmart sees:** attribution = direct/organic. Lens correctly classifies this as non-paid.

### Example 4: Manual SCK override
```
<!-- example: manually-set sck overrides script-generated value -->
<a href="https://pay.hotmart.com/<PRODUCT_ID>?sck=influencer-campaign-20260422"> <!-- example -->
  Comprar agora
</a>
```
The script **does NOT overwrite** this — respects the manually-set `sck`. Useful for affiliate/influencer overrides.

## Anti-patterns (8)
1. **Building SCK only from URL** (ignoring cookie persist) — breaks multi-page flows and email-nurture funnels.
2. **Using `;` or `,` as separator** — Hotmart dashboard parses `|` natively; other separators need post-processing that nobody configures.
3. **Forgetting click IDs** — loses Meta/Google/TikTok attribution in Hotmart webhook event.
4. **Hardcoding SCK at build-time** — impossible to reflect real-time traffic source; every buyer looks identical.
5. **Using `window.location.search.split` directly** — breaks with URL-encoded params, multiple `&`, missing values. Use `URLSearchParams` always.
6. **Double-encoding pipes** to `%7C` — Hotmart reads the raw `|` in the dashboard label; `%7C` won't parse back without custom decode.
7. **Overwriting existing `?sck=`** — kills manual overrides used by affiliate/influencer links.
8. **Mismatched cookie names between hotmart-sck.js and pixel-meta.js** — two scripts persist to different cookie keys, CAPI fires with stale URLs while SCK uses fresh ones. Always `utm_source` etc., no prefix.

## Platform specs / constraints
- Hotmart `sck` **max length: 255 chars**. If the 5-field format exceeds this due to long campaign names, shorten the field values (not the separator structure).
- Pipes are **raw `|`** — no URL encoding. Hotmart's dashboard reads them as-is.
- Cookie persistence default: **90 days**, matches `_fbc`.
- Cookie attributes: `SameSite=Lax`, `path=/`. **Required** so cookie survives the top-level navigation from ad click.
- Hotmart dashboard reads SCK in: **Sales → Report → "Origem da venda"** (sometimes "Source"). Shows the raw SCK string; Lens reads it via the API join on order ID.
- Webhook payload: Hotmart forwards SCK in purchase webhook → n8n workflow → CAPI Purchase event with SCK as `custom_data.source`.

## References
- **Reference implementation:** `apps/hero-academy-lowtickets/shared/hotmart-sck.js` (vanilla JS, ~200 lines, no framework deps).
- **Pattern shares cookies with:** `apps/hero-academy-lowtickets/shared/pixel-meta.js` (`getUtmParams()` reads cookies as fallback).
- **Related skills (local):** `utm-naming-convention`, `meta-pixel-capi`, `end-to-end-tracking`.
- **Hotmart docs:** `developers.hotmart.com/docs/en/` → Checkout → Tracking (search "sck" parameter).
