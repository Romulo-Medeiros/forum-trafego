# R01 — Security Isolation (NON-NEGOTIABLE)

## Rule

- Service-role keys (Supabase, admin API keys) NEVER live in the frontend.
- Allowed locations: server-only environments (API routes, Server Actions, serverless functions, CI scripts).
- Client code uses public (anon) keys only.
- Writes from the browser are forbidden unless RLS with `auth.uid()` is active.
- RLS is mandatory on every new table: `ALTER TABLE x ENABLE ROW LEVEL SECURITY;`
- Server-side input validation with Zod (or equivalent) BEFORE hitting the database.
- Secure headers: `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: strict-origin-when-cross-origin`, CSP.

## When to apply

Any code touching auth, session, keys, or data access.

## Checklist at review

- [ ] No `SUPABASE_SERVICE_ROLE_KEY` or equivalent anywhere the browser can reach
- [ ] Every DB mutation goes through a server route or Server Action
- [ ] New tables have RLS enabled
- [ ] User input is validated server-side before hitting the DB
- [ ] Security headers present

## Violation = Kim VETO

No pressure of deadline or complexity justifies violating this rule.
