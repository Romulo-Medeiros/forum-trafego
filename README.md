# forum-trafego — Lean Paid Traffic Squad

> Condensed edition of `trafego-pago` v6. Same operational DNA, ~85% less surface area.

## What this is

A streamlined squad for agencies running paid traffic (Meta Ads + Google Ads) across multiple clients. Built for **speed of onboarding and daily execution**, not for extensibility.

- **5 agents** instead of 11
- **6 tasks** instead of 20
- **2 workflows** instead of 8
- **Safety-first**: PAUSED-by-default launches, pre-push security audits, self-critique gate after every non-trivial change

## Agents

| Agent | Role | Tier |
|-------|------|------|
| `maestro` | Orchestrator. Routes work, picks funnel, allocates budget. Does not execute tactical work. | 0 |
| `meta` | Meta Ads (+ TikTok patterns). Structure, audiences, bidding, scaling, policy. | 1 |
| `google` | Google Ads. Search, Shopping, PMax, YouTube. Keyword + bidding strategy. | 1 |
| `criat` | Creative + performance copy. Hooks, ad copy, video briefs, static briefs. | 1 |
| `tracker` | GTM, Pixel, CAPI, UTM, end-to-end tracking. **Exclusive owner** of tracking. | 2 |

## Commands

- `*client-onboarding` — New-client intake, persona sketch, funnel choice, first-campaign plan
- `*create-media-plan {channel}` — Build a media plan for Meta or Google
- `*setup-tracking` — GTM container + Pixel/CAPI + UTM convention
- `*daily-check` — Daily tactical review per channel (delegates to meta/google)
- `*optimize-campaign` — Root-cause diagnosis + action plan
- `*weekly-report` — Weekly strategic digest

## Workflows

- `wf-new-campaign` — End-to-end: onboarding → media plan → tracking → pre-launch → launch
- `wf-daily-optimization` — Daily loop: read metrics → diagnose → act → handoff

## Safety hooks (globally installed via `hooks/`)

- `pre-tool-secrets-scan.sh` — scans content about to be written for API keys/secrets
- `stop-hook-self-critique.sh` — reminds QA check after >2 code file changes without validation
- `pre-push-audit.sh` — blocks push if lockfile changed with vulns CVSS ≥ 7.0

## Rules (`.claude/rules/`)

- `R01-security-isolation.md` — service_role keys stay server-side
- `R04-secrets-vault.md` — no secrets in logs/responses/commits
- `R12-commit-discipline.md` — Conventional Commits, atomic, scoped
- `R-SC-self-critique.md` — post-change checklist (tests, tsc, naming, security)
- `git-remote.md` — this repo pushes to origin (Romulo-Medeiros/forum-trafego)

## Quick start

```bash
# 1. Configure env
export META_ADS_ACCESS_TOKEN=...
export META_ADS_ACCOUNT_ID=act_...

# 2. Activate maestro
# (from Claude Code: /ForumTrafego:maestro)

# 3. First client onboarding
# maestro: *client-onboarding "Cliente Y, infoproduto R$ 497, lançamento"
```

## Delta vs. trafego-pago

| Dimension | trafego-pago | forum-trafego | Reduction |
|-----------|--------------|---------------|-----------|
| Agents | 11 | 5 | −55% |
| Tasks | 20 | 6 | −70% |
| Workflows | 8 | 2 | −75% |
| Data files | 8 | 2 | −75% |
| Skills (local) | 53 | 0 | −100% |
| GTM containers | yes (~2MB) | removed | −100% |
| MCPs pre-wired | 11 | 0 (opt-in) | −100% |

Exact line/byte reductions documented in `CHANGELOG.md` after first commit.

## Philosophy

> "Lean is what you remove, not what you add." — forum-trafego v1
