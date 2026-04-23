# R12 — Commit Discipline

## Rule

Every commit in this repo follows Conventional Commits.

Format:
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

## Types

- `feat`     — new feature
- `fix`      — bug fix
- `docs`     — documentation only
- `style`    — formatting, no logic change
- `refactor` — code restructure, no behavior change
- `perf`     — performance improvement
- `test`     — tests only
- `build`    — build system, dependencies
- `ci`       — CI config
- `chore`    — housekeeping
- `revert`   — revert previous commit

## Scope

Required. Use the agent name or the squad area:
- `maestro`, `meta`, `google`, `criat`, `tracker`
- `hooks`, `rules`, `docs`, `config`

## Rules

- ONE logical change per commit (not "fixed X and Y and Z")
- Imperative mood: "add", not "added" or "adds"
- Description ≤ 70 chars
- If the change is not obvious from code, write WHY in the body
- Never commit WIP that breaks the build
- Never commit with `--no-verify` unless the hook itself is broken (fix the hook, not the bypass)

## Branch naming

- `feature/<short-kebab>` — new capability
- `fix/<short-kebab>` — bug fix
- `chore/<short-kebab>` — maintenance
- `refactor/<short-kebab>` — restructure

## Examples

Good:
```
feat(tracker): add Hotmart postback CAPI bridge
fix(meta): pause ad set when frequency > 3.5
docs(readme): document EMQ gate requirement
chore(hooks): tighten secrets scan for Meta System User tokens
```

Bad:
```
update stuff
fix bug
WIP
misc changes
```

## Enforcement

- Conventional Commit linter recommended (commitlint or husky)
- Review check before merge
- Hook can block pushes violating format
