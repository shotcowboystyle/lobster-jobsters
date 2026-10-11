#!/usr/bin/env bash
# Structural validation for every OpenClaw workspace in the repo.
# Exit non-zero on any failure. Run in CI and before every commit.
#
#   scripts/validate.sh [workforce]
set -uo pipefail
ROOT="${1:-workforce}"
fail=0
err() { echo "FAIL  $*"; fail=1; }
ok()  { echo "ok    $*"; }

# 1. Every JSON parses
while IFS= read -r f; do
  jq empty "$f" 2>/dev/null || err "invalid JSON: $f"
done < <(find "$ROOT" templates -name '*.json' 2>/dev/null)
ok "json parse"

# 2. Every ledger SQL loads into an in-memory SQLite db
while IFS= read -r f; do
  sqlite3 :memory: < "$f" >/dev/null 2>&1 || err "SQL does not load: $f"
done < <(find "$ROOT" -name '*.sql')
ok "sql load"

# 3. Every shell script passes bash -n
while IFS= read -r f; do
  bash -n "$f" || err "bash syntax: $f"
done < <(find "$ROOT" scripts -name '*.sh' 2>/dev/null)
ok "shell syntax"

# 4. Team workspaces have the required files
REQ_TEAM=(README.md SOUL.md IDENTITY.md AGENTS.md USER.md HEARTBEAT.md MEMORY.md config/emergency-stop.json config/approval-policy.json config/env.example)
for team in "$ROOT"/agents/*/; do
  for f in "${REQ_TEAM[@]}"; do
    [[ -f "$team$f" ]] || err "missing $f in $team"
  done
  # 5. Sub-agents only receive AGENTS.md + TOOLS.md at runtime, so AGENTS.md is mandatory;
  #    SOUL/IDENTITY are what make the persona reviewable by humans.
  for sub in "$team"agents/*/; do
    [[ -d "$sub" ]] || continue
    for f in AGENTS.md SOUL.md IDENTITY.md; do
      [[ -f "$sub$f" ]] || err "missing $f in $sub"
    done
  done
done
ok "required files"

# 5b. Every agent has an openclaw.json fragment registering exactly itself, with the
#     workspace path from the README quickstart; coordinators may spawn exactly their sub-agents.
oc_check() {  # oc_check <dir> <id> <workspace-suffix>
  local f="$1openclaw.json"
  [[ -f "$f" ]] || { err "missing openclaw.json in $1"; return; }
  jq -e --arg id "$2" --arg ws "$3" '.agents.entries | keys == [$id] and (.[$id].workspace | endswith($ws))' "$f" >/dev/null 2>&1 \
    || err "openclaw.json must register only agent '$2' with workspace ending '$3': $f"
}
for team in "$ROOT"/agents/*/; do
  t=$(basename "$team")
  oc_check "$team" "$t" "/workspaces/$t"
  want=()
  for sub in "$team"agents/*/; do
    [[ -d "$sub" ]] || continue
    s=$(basename "$sub")
    oc_check "$sub" "$t-$s" "/workspaces/$t/agents/$s"
    want+=("$t-$s")
  done
  [[ -f "${team}openclaw.json" ]] || continue
  have=$(jq -c --arg t "$t" '.agents.entries[$t].subagents.allowAgents // [] | sort' "${team}openclaw.json" 2>/dev/null)
  expect=$(printf '%s\n' ${want[@]+"${want[@]}"} | jq -R 'select(length > 0)' | jq -cs 'sort')
  [[ "$have" == "$expect" ]] || err "subagents.allowAgents must list exactly the team's sub-agents $expect: ${team}openclaw.json"
done
# Omitting `skills` means unrestricted, so every agent (and template) needs an explicit
# allowlist of skill names: no wildcards, no globs, `[]` for none.
while IFS= read -r f; do
  jq -e '.agents.entries | to_entries | all(.value.skills | type == "array" and all(.[]; type == "string" and test("^[a-z0-9][a-z0-9-]*$")))' "$f" >/dev/null 2>&1 \
    || err "every agent needs an explicit skills allowlist of names (no wildcards): $f"
done < <(find "$ROOT" templates -name openclaw.json 2>/dev/null)
while IFS= read -r d; do err "skills are granted via openclaw.json, not pinned: remove $d"; done < <(find "$ROOT" templates -type d -name .clawhub 2>/dev/null)
dupes=$(find "$ROOT" -name openclaw.json -exec jq -r '.agents.entries | keys[]' {} + 2>/dev/null | sort | uniq -d)
[[ -z "$dupes" ]] || err "duplicate OpenClaw agent ids: $dupes"
ok "openclaw config"

# 6. Size budgets from the OpenClaw memory model
while IFS= read -r f; do
  n=$(wc -l < "$f")
  (( n <= 200 )) || err "MEMORY.md over 200-line budget ($n): $f"
done < <(find "$ROOT" -name MEMORY.md)
while IFS= read -r f; do
  n=$(grep -c '^- \[' "$f" || true)
  (( n <= 12 )) || err "HEARTBEAT.md has $n checks (keep <= 12, heartbeats burn tokens): $f"
done < <(find "$ROOT" -name HEARTBEAT.md)
ok "size budgets"

# 7. Kill switch shape: exactly one *_enabled boolean plus audit fields
while IFS= read -r f; do
  jq -e 'to_entries | map(select(.key | endswith("_enabled"))) | length == 1 and all(.[]; .value | type == "boolean")' "$f" >/dev/null \
    || err "emergency-stop needs exactly one boolean *_enabled flag: $f"
  jq -e 'has("reason") and has("stopped_by") and has("stopped_at")' "$f" >/dev/null \
    || err "emergency-stop missing reason/stopped_by/stopped_at: $f"
done < <(find "$ROOT" -name 'emergency-stop.json' -o -name 'shared-emergency-stop.json')
ok "kill switch shape"

# 8. No unfilled scaffold placeholders
if grep -rnE '\{\{[A-Z_]+\}\}' "$ROOT" >/dev/null; then
  grep -rnE '\{\{[A-Z_]+\}\}' "$ROOT" | head -20
  err "unfilled {{PLACEHOLDER}} tokens remain"
fi
ok "placeholders"

# 9. Secrets: never commit real credentials. gitleaks if present, regex fallback otherwise.
if gitleaks version >/dev/null 2>&1; then
  gitleaks detect --no-git --source "$ROOT" --redact --exit-code 1 >/dev/null 2>&1 || err "gitleaks found secrets"
else
  if grep -rnE '(sk-(ant-)?[A-Za-z0-9_-]{20,}|sk_(live|test)_[A-Za-z0-9]{16,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,}|xox[abp]-[A-Za-z0-9-]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY|https://discord(app)?\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+|eyJ[A-Za-z0-9_-]{30,}\.[A-Za-z0-9_-]{30,})' "$ROOT" scripts templates 2>/dev/null; then
    err "secret-looking strings found"
  fi
fi
# .env files and SQLite databases must never be tracked
while IFS= read -r f; do err "must not be committed: $f"; done < <(find "$ROOT" \( -name '.env' -o -name '*.db' -o -name '*.sqlite' \) -type f)
ok "secrets"

# 10. Daily memory logs are per-deployment; the public repo ships none
while IFS= read -r f; do err "daily memory log committed: $f"; done < <(find "$ROOT" -path '*/memory/*.md' -type f)
ok "no memory logs"

(( fail == 0 )) && echo "VALIDATION PASSED" || { echo "VALIDATION FAILED"; exit 1; }
