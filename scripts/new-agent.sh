#!/usr/bin/env bash
# Scaffold a new team workspace or sub-agent workspace from templates/.
#
#   scripts/new-agent.sh team <team-slug> --name "Chief Revenue Officer" --short CRO \
#       --persona Harbor --emoji ⚓ --creature "pelican" --flag outreach_enabled
#
#   scripts/new-agent.sh sub <team-slug> <sub-slug> --persona Reef --role "Partnerships Agent" \
#       --emoji 🪸 --creature "coral"
#
# Company name, owner, and channel prefix default to the values in workforce/SHARED_KNOWLEDGE.json.
# Every generated file passes scripts/validate.sh and scripts/audit.py out of the box.
set -euo pipefail
ROOT="${WORKFORCE_ROOT:-workforce}"
TPL="$(cd "$(dirname "$0")/.." && pwd)/templates"

KIND="${1:-}"; shift || true
case "$KIND" in team|sub) ;; *) sed -n '2,12p' "$0"; exit 2 ;; esac

TEAM_SLUG="${1:?team slug required}"; shift
SUB_SLUG=""
if [[ "$KIND" == "sub" ]]; then SUB_SLUG="${1:?sub-agent slug required}"; shift; fi

NAME="" SHORT="" PERSONA="" EMOJI="🤖" CREATURE="AI assistant" FLAG="" ROLE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;      --short) SHORT="$2"; shift 2 ;;
    --persona) PERSONA="$2"; shift 2 ;; --emoji) EMOJI="$2"; shift 2 ;;
    --creature) CREATURE="$2"; shift 2 ;; --flag) FLAG="$2"; shift 2 ;;
    --role) ROLE="$2"; shift 2 ;;
    *) echo "unknown flag: $1" >&2; exit 2 ;;
  esac
done
for s in "$TEAM_SLUG" "$SUB_SLUG"; do
  [[ -z "$s" || "$s" =~ ^[a-z0-9-]+$ ]] || { echo "slugs must be lowercase letters, digits, hyphens: $s" >&2; exit 2; }
done

COMPANY=$(jq -r '.business // "ACME"' "$ROOT/SHARED_KNOWLEDGE.json" 2>/dev/null || echo ACME)
OWNER=$(jq -r '.facts.ceo.name // "Owner"' "$ROOT/SHARED_KNOWLEDGE.json" 2>/dev/null | awk '{print $1}')
CHANNEL_PREFIX=$(printf '%s' "$COMPANY" | awk '{print tolower($1)}' | tr -cd 'a-z0-9-')
DATE=$(date +%Y-%m-%d)

render() {  # render <src> <dst>
  mkdir -p "$(dirname "$2")"
  sed -e "s|{{COMPANY}}|$COMPANY|g" -e "s|{{OWNER}}|$OWNER|g" -e "s|{{CHANNEL_PREFIX}}|$CHANNEL_PREFIX|g" \
      -e "s|{{TEAM_NAME}}|$NAME|g" -e "s|{{TEAM_SLUG}}|$TEAM_SLUG|g" -e "s|{{TEAM_SHORT}}|$SHORT|g" \
      -e "s|{{PERSONA}}|$PERSONA|g" -e "s|{{EMOJI}}|$EMOJI|g" -e "s|{{CREATURE}}|$CREATURE|g" \
      -e "s|{{FLAG}}|$FLAG|g" -e "s|{{ROLE}}|$ROLE|g" -e "s|{{SUB_SLUG}}|$SUB_SLUG|g" \
      -e "s|{{COORDINATOR}}|$COORDINATOR|g" -e "s|{{DATE}}|$DATE|g" "$1" > "$2"
}

if [[ "$KIND" == "team" ]]; then
  : "${NAME:?--name required}" "${PERSONA:?--persona required}"
  SHORT="${SHORT:-$(printf '%s' "$NAME" | awk '{for(i=1;i<=NF;i++) printf toupper(substr($i,1,1))}')}"
  FLAG="${FLAG:-${TEAM_SLUG//-/_}_actions_enabled}"
  COORDINATOR="$PERSONA"
  DEST="$ROOT/agents/$TEAM_SLUG"
  [[ -e "$DEST" ]] && { echo "already exists: $DEST" >&2; exit 1; }
  while IFS= read -r src; do
    rel="${src#"$TPL/team/"}"; rel="${rel//TEAM_SLUG/$TEAM_SLUG}"
    render "$src" "$DEST/$rel"
  done < <(find "$TPL/team" -type f)
  chmod +x "$DEST"/config/*.sh
  echo "created team workspace: $DEST"
  echo "next: add the team to $ROOT/README.md, $ROOT/SHARED_KNOWLEDGE.json (workforce + ledgers), and CROSS-TEAM-HANDOFFS.md"
else
  : "${PERSONA:?--persona required}" "${ROLE:?--role required}"
  TEAM_DIR="$ROOT/agents/$TEAM_SLUG"
  [[ -d "$TEAM_DIR" ]] || { echo "no such team: $TEAM_DIR" >&2; exit 1; }
  NAME=$(grep -m1 -oE '^# .*' "$TEAM_DIR/README.md" | sed 's/^# //; s/ — .*//')
  COORDINATOR=$(grep -m1 -oE '\*\*Name:\*\*[^—(]*' "$TEAM_DIR/IDENTITY.md" | sed 's/\*\*Name:\*\* *//; s/ *$//')
  FLAG=$(jq -r 'to_entries[] | select(.key | endswith("_enabled")) | .key' "$TEAM_DIR/config/emergency-stop.json")
  DEST="$TEAM_DIR/agents/$SUB_SLUG"
  [[ -e "$DEST" ]] && { echo "already exists: $DEST" >&2; exit 1; }
  while IFS= read -r src; do render "$src" "$DEST/${src#"$TPL/sub-agent/"}"; done < <(find "$TPL/sub-agent" -type f)
  echo "created sub-agent workspace: $DEST"
  echo "next: add $PERSONA to the roster table in $TEAM_DIR/AGENTS.md and $TEAM_DIR/README.md"
fi
echo "then run: scripts/validate.sh && scripts/audit.py --strict"
