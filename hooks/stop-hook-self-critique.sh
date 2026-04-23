#!/usr/bin/env bash
# stop-hook-self-critique.sh
# Emits a reminder to run self-critique when the session changed >2 code-ish
# files without evidence of validation (tsc, tests, lint).
#
# Advisory by default (exit 0 with stderr message).
# Switch to `exit 2` to make it BLOCKING.

set -euo pipefail

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_ROOT" 2>/dev/null || exit 0

# Count staged or modified code-ish files
CHANGED=$(git status --porcelain 2>/dev/null \
  | awk '{print $2}' \
  | grep -Ei '\.(ts|tsx|js|jsx|py|go|rs|md|yaml|yml|sh)$' \
  | wc -l | tr -d ' ')

if [[ "${CHANGED:-0}" -lt 3 ]]; then
  exit 0
fi

# Look for validation evidence: recent test/tsc/eslint output in session
TRANSCRIPT_GLOB="$HOME/.claude/projects/*/transcripts/*.jsonl"
RECENT_TX=$(ls -t $TRANSCRIPT_GLOB 2>/dev/null | head -1 || echo "")

VALIDATED=0
if [[ -n "$RECENT_TX" && -r "$RECENT_TX" ]]; then
  if tail -500 "$RECENT_TX" 2>/dev/null | grep -Eq '(tsc|vitest|jest|playwright|eslint|pytest|go test|cargo test)'; then
    VALIDATED=1
  fi
fi

if [[ $VALIDATED -eq 0 ]]; then
  cat >&2 <<EOF

─────────── SELF-CRITIQUE REMINDER (forum-trafego) ───────────
 $CHANGED code-ish files changed in this session.
 No validation command detected (tsc / tests / lint).

 Before you say 'done', run:
   1. tsc / test / lint for the stack you touched
   2. Self-critique: R01/R04 security, R12 commit discipline, R-SC
   3. Preview the feature in a browser if it's UI

 Advisory only (exit 0). Switch to BLOCKING in hooks/ if you want to enforce.
──────────────────────────────────────────────────────────────
EOF
fi

exit 0
