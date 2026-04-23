# R04 — Secrets Vault (NON-NEGOTIABLE)

## Rule

Zero secrets appear in:
- logs
- HTTP response bodies
- client-side code
- git history (current or past)
- error traces shown to the user

Secrets live ONLY in:
- server env vars (platform dashboard: Vercel, Supabase, Railway, etc.)
- a dedicated vault (1Password, Bitwarden, AWS Secrets Manager)
- local `.env` files that are gitignored

## When to apply

Any code manipulating API keys, tokens, passwords, OAuth credentials, or third-party secrets.

## If a secret leaks

1. **Rotate immediately** — treat the old one as burned
2. Find every place it might be cached (CI logs, third-party webhook logs, Sentry)
3. Document the rotation in the project's `incident-log.md`
4. Add a test or hook that would have caught it (see `hooks/pre-tool-secrets-scan.sh`)

## Rules

- `.env*` in `.gitignore` ALWAYS (except `.env.example` which has no real values)
- Never `console.log` a request body that might carry a token
- Never include a secret in an error message returned to a user
- Never commit a credential even briefly — `git reset` does not erase from the remote
- Prefer short-lived tokens over long-lived ones

## Violation = Kim VETO

A single leaked production secret can cost more than the entire campaign it was supposed to enable. No trade-off.
