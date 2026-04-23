# R-SC — Self-Critique (MUST)

## Rule

Before declaring any task "done", run a self-critique pass. Silently is fine; skipping is not.

## When to apply

Any implementation task that touched:
- code (≥1 file)
- config (schema, env, YAML)
- database (migration, policy, seed)
- user-facing content that affects conversion (copy, offer, pricing)

## Pre-delivery checklist

### Technical (code)
- [ ] Does it compile? (`tsc` / `python -m py_compile` / `go build` / etc.)
- [ ] Do the tests pass? (`npm test` / `pytest` / `go test` — actually run them)
- [ ] Does naming match conventions? (camelCase TS, PascalCase components, snake_case SQL)
- [ ] Any `console.log` / `print` / `TODO` / `XXX` left behind?
- [ ] Any catch block swallowing errors without context?
- [ ] Imports via alias (`@/`), not deep relative (`../../../`)?

### Security (inviolable)
- [ ] No service_role key reachable from the browser? (R01)
- [ ] Any input from user validated server-side with Zod? (R01)
- [ ] RLS enabled on every new table? (R01)
- [ ] Zero secrets in logs / responses / commits? (R04)
- [ ] Cookies secure? (httpOnly, secure in prod, sameSite)

### Performance
- [ ] I/O is async? (no blocking calls)
- [ ] Independent queries in `Promise.all` rather than sequential await?
- [ ] Timeouts on external calls?
- [ ] Large list rendering virtualized if > 200 items?

### Commit
- [ ] Conventional Commit format? (R12)
- [ ] One logical change per commit?
- [ ] Commit message answers "why" if "what" is not obvious?

### Ads-specific (this squad)
- [ ] Any campaign created is in PAUSED state?
- [ ] Any tracking change validated end-to-end (Pixel + CAPI dedup, EMQ ≥ 6)?
- [ ] Any LP change preserves conversion events?
- [ ] Any copy change passes banned-words scan? (no em-dash, no unlock/unleash/game-changer)

## If any item fails

Do NOT declare done. Fix, re-verify, then declare done.

## Why

Silent skipping of self-critique creates:
- broken builds merged
- secrets leaked to logs
- campaigns launched unpaused
- copy with AI-flag em-dashes

These are all recoverable individually but corrosive collectively. R-SC is the 30-second habit that catches them before the commit.
