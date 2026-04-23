# hooks/ — forum-trafego security hooks

Three hooks scoped to this squad. All three are portable to any Claude Code project.

## `pre-tool-secrets-scan.sh`
**When:** PreToolUse on Write/Edit/MultiEdit/NotebookEdit
**Does:** Scans the content about to be written for API keys and secrets. Blocks if any pattern matches. Also hard-blocks writing to `.env*` (except `.env.example`).
**Exit:** 2 (block) on hit. 0 otherwise.

## `stop-hook-self-critique.sh`
**When:** SessionStop (Claude Code stop hook)
**Does:** If >2 code-ish files changed without validation evidence (tsc/test/lint) in the session transcript, prints a reminder. Advisory by default.
**Exit:** 0 (advisory).

## `pre-push-audit.sh`
**When:** `git push` (install as `.git/hooks/pre-push`)
**Does:** If the push includes a lockfile change and dependency audit reports CVSS ≥ 7.0 vulnerabilities, blocks the push. Bypass via `SKIP_AUDIT=1 git push` (emergency only).
**Exit:** 1 (block) or 0 (allow).

## Install

### As a Claude Code hook (per-project)
Add to `.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit|NotebookEdit",
        "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/hooks/pre-tool-secrets-scan.sh" }]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/hooks/stop-hook-self-critique.sh" }]
      }
    ]
  }
}
```

### As a global hook (for all projects)
Install in `~/.claude/hooks/forum-trafego/` and reference from `~/.claude/settings.json`.

### As a git hook
```bash
ln -s "$PWD/hooks/pre-push-audit.sh" .git/hooks/pre-push
chmod +x hooks/pre-push-audit.sh
```

## Philosophy

**Block > Alert > Document.** The hooks that matter are blocking (secrets, dep vulns). Advisory hooks (self-critique) are for discipline nudges, not enforcement.

Derived from the global `~/.claude/rules/pedro-valerio/` enforcement model: "A melhor coisa é você impossibilitar caminhos."
