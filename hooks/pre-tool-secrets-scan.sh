#!/usr/bin/env bash
# pre-tool-secrets-scan.sh
# Scans Write/Edit inputs for accidental secrets before file write.
# Exit 2 = block (Claude Code hook convention).
#
# Triggers: Write, Edit, MultiEdit, NotebookEdit
# Scope: content field of the tool input

set -euo pipefail

# Read JSON payload from stdin (Claude Code hook contract)
PAYLOAD="$(cat)"

TOOL_NAME="$(printf '%s' "$PAYLOAD" | jq -r '.tool_name // empty')"
FILE_PATH="$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.file_path // .tool_input.path // empty')"
CONTENT="$(printf '%s' "$PAYLOAD" | jq -r '.tool_input.content // .tool_input.new_string // empty')"

# Only gate write-class tools
case "$TOOL_NAME" in
  Write|Edit|MultiEdit|NotebookEdit) ;;
  *) exit 0 ;;
esac

# Allow .env.example (template, no real values)
if [[ "$FILE_PATH" == *.env.example ]]; then
  exit 0
fi

# Hard block: .env* write
if [[ "$FILE_PATH" == *.env || "$FILE_PATH" == *.env.* ]] && [[ "$FILE_PATH" != *.env.example ]]; then
  echo "BLOCKED: Do not write .env files via the agent. Edit them manually." >&2
  exit 2
fi

# Patterns to detect in content
HITS=0

scan() {
  local label="$1"; shift
  local pattern="$1"; shift
  if printf '%s' "$CONTENT" | grep -Eq "$pattern"; then
    echo "SECRET SCAN HIT [$label] in $FILE_PATH" >&2
    HITS=$((HITS+1))
  fi
}

scan "AWS access key"            'AKIA[0-9A-Z]{16}'
scan "AWS secret-like"            '(?i)aws(.{0,20})?(secret|access)_?key.{0,5}=.{0,5}[A-Za-z0-9/+=]{30,}'
scan "Google API key"             'AIza[0-9A-Za-z\-_]{35}'
scan "Stripe live key"            'sk_live_[0-9a-zA-Z]{24,}'
scan "Stripe restricted key"      'rk_live_[0-9a-zA-Z]{24,}'
scan "Supabase service role-ish"  'eyJhbGciOi[A-Za-z0-9\-_\.]+(service_role|role.:.service_role)'
scan "OpenAI key"                 'sk-[A-Za-z0-9]{32,}'
scan "Anthropic key"              'sk-ant-[A-Za-z0-9\-_]{40,}'
scan "Meta System User token"     'EAA[A-Za-z0-9]{100,}'
scan "Slack bot token"            'xox[baprs]-[0-9a-zA-Z\-]{10,}'
scan "Generic password= pattern"  '(?i)password\s*=\s*["'\''][^"'\'' ]{6,}["'\'']'
scan "Private key block"          '-----BEGIN (RSA |OPENSSH |DSA |EC |PGP )?PRIVATE KEY-----'

if [[ $HITS -gt 0 ]]; then
  echo "" >&2
  echo "BLOCKED: $HITS secret pattern(s) detected in content about to be written to $FILE_PATH." >&2
  echo "Rotate the credential immediately if it was real, and remove from this payload before retrying." >&2
  exit 2
fi

exit 0
