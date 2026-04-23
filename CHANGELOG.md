# Changelog

## [1.0.0] — 2026-04-23

Initial release. Lean fork of `trafego-pago` v6.0.

### Scope
- 5 agents: maestro, meta, google, criat, tracker
- 6 tasks: client-onboarding, create-media-plan, setup-tracking, daily-check, optimize-campaign, weekly-report
- 2 workflows: wf-new-campaign, wf-daily-optimization
- 3 checklists: pre-launch, tracking-setup, weekly-review
- 2 data files: utm-convention, niche-benchmarks
- 3 security hooks: pre-tool-secrets-scan, stop-hook-self-critique, pre-push-audit
- 5 rules: R01, R04, R12, R-SC, git-remote

### Removed from parent squad
- 6 agents (radar, offer, hook, conver, lens, shield) — responsibilities merged or considered out-of-scope
- 14 tasks — kept only the daily-loop essentials
- 6 workflows — kept only new-campaign and daily-optimization
- skills/ library — agents are now self-contained
- GTM container templates — ~2MB of reference files (reintroduce per-client as needed)
- mcp/ pre-wiring — MCPs are opt-in when needed
- templates/ niche blueprints — consolidated into `data/niche-benchmarks.yaml`

### Philosophy
Lean means smaller surface area for the same operational loop. If we miss a capability, we add it — but only when a real run demands it.
