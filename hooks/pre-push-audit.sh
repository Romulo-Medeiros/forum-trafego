#!/usr/bin/env bash
# pre-push-audit.sh
# Blocks `git push` when the push includes a lockfile change whose packages
# have vulnerabilities at CVSS ≥ 7.0 (high/critical).
#
# Install as: .git/hooks/pre-push or via the global Claude Code hook config.
# Exit 0 = allow, Exit 1 = block.

set -euo pipefail

# Find repo root
REPO=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$REPO" ]]; then
  exit 0
fi
cd "$REPO"

# Only trigger if a lockfile is in the staged-to-push range
STAGED=$(git diff --name-only @{u}..HEAD 2>/dev/null || echo "")
LOCK_CHANGED=0
if echo "$STAGED" | grep -Eq '(package-lock\.json|pnpm-lock\.yaml|yarn\.lock|composer\.lock|Gemfile\.lock|Pipfile\.lock|poetry\.lock)'; then
  LOCK_CHANGED=1
fi

if [[ $LOCK_CHANGED -eq 0 ]]; then
  exit 0
fi

# Run audit depending on which package manager
AUDIT_FAILED=0
if [[ -f pnpm-lock.yaml ]] && command -v pnpm >/dev/null 2>&1; then
  echo "pre-push-audit: running pnpm audit --audit-level=high"
  if ! pnpm audit --audit-level=high --prod 2>&1 | tee /tmp/forum-trafego-audit.log; then
    AUDIT_FAILED=1
  fi
elif [[ -f package-lock.json ]] && command -v npm >/dev/null 2>&1; then
  echo "pre-push-audit: running npm audit --audit-level=high --production"
  if ! npm audit --audit-level=high --omit=dev 2>&1 | tee /tmp/forum-trafego-audit.log; then
    AUDIT_FAILED=1
  fi
elif [[ -f yarn.lock ]] && command -v yarn >/dev/null 2>&1; then
  echo "pre-push-audit: running yarn npm audit --severity=high"
  if ! yarn npm audit --severity=high 2>&1 | tee /tmp/forum-trafego-audit.log; then
    AUDIT_FAILED=1
  fi
else
  echo "pre-push-audit: no lockfile tool available; skipping" >&2
  exit 0
fi

if [[ $AUDIT_FAILED -eq 1 ]]; then
  cat >&2 <<EOF

─────────── PUSH BLOCKED — DEPENDENCY AUDIT ───────────
 Lockfile changed AND vulnerabilities found at CVSS ≥ 7.0.
 See /tmp/forum-trafego-audit.log for details.

 To unblock:
   1. Update the vulnerable dependency (preferred), OR
   2. Add a documented exception in deps-security/exceptions.md
      with CVE, reason, and review date, then retry.

 Bypass (emergency only — creates audit trail):
   SKIP_AUDIT=1 git push
────────────────────────────────────────────────────────
EOF
  [[ "${SKIP_AUDIT:-0}" == "1" ]] && exit 0
  exit 1
fi

exit 0
