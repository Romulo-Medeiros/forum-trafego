# Git Remote — forum-trafego

## Rule

This repo has a single remote, `origin`, pointing to
`https://github.com/Romulo-Medeiros/forum-trafego.git`.

- `git push` and `git pull` go to `origin`.
- Only the `main` branch exists publicly by default.
- Feature branches are short-lived; delete after merge.

## How to apply

1. **Push:** `git push origin <branch>` (or `git push` when upstream is set).
2. **Pull:** `git pull --ff-only origin main`.
3. Never push to any other remote unless explicitly added for a specific integration (mirrors, deployment targets) and documented here.
4. Respect the `pre-push-audit.sh` hook — it blocks pushes if lockfile vulns CVSS ≥ 7.0 are detected.

## Branching

- `main` — deployable.
- `feature/<kebab>` — new capability.
- `fix/<kebab>` — bug fix.
- `chore/<kebab>` — maintenance.

Delete branches after merge. No long-lived feature branches.

## Force-push policy

- `--force` NEVER on `main`.
- `--force-with-lease` on your own short-lived branch is OK.
- Rewriting history on `main` is a red-alert event.
