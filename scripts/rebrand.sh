#!/usr/bin/env bash
# Rebrand the example workforce from "ACME Bonsai" / "Jane Founder" to your company.
#
# Usage:
#   scripts/rebrand.sh --company "Northwind Plants" --slug northwind \
#       --owner "Sam Rivera" --owner-first Sam --domain northwindplants.com \
#       [--city "Portland"] [--dir workforce]
#
# Replacements are applied longest-match-first across every text file under --dir.
# Re-running is safe: once the placeholders are gone there is nothing left to replace.
set -euo pipefail

COMPANY="" SLUG="" OWNER="" OWNER_FIRST="" DOMAIN="" CITY="" DIR="workforce"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --company)     COMPANY="$2"; shift 2 ;;
    --slug)        SLUG="$2"; shift 2 ;;
    --owner)       OWNER="$2"; shift 2 ;;
    --owner-first) OWNER_FIRST="$2"; shift 2 ;;
    --domain)      DOMAIN="$2"; shift 2 ;;
    --city)        CITY="$2"; shift 2 ;;
    --dir)         DIR="$2"; shift 2 ;;
    -h|--help)     sed -n '2,10p' "$0"; exit 0 ;;
    *) echo "unknown flag: $1" >&2; exit 2 ;;
  esac
done
[[ -n "$COMPANY" && -n "$SLUG" ]] || { echo "--company and --slug are required" >&2; exit 2; }
[[ "$SLUG" =~ ^[a-z0-9-]+$ ]] || { echo "--slug must be lowercase letters, digits, hyphens" >&2; exit 2; }
[[ -d "$DIR" ]] || { echo "no such dir: $DIR" >&2; exit 2; }

SLUG_US="${SLUG//-/_}"
HASHTAG="${SLUG//-/}"
export COMPANY SLUG SLUG_US HASHTAG OWNER OWNER_FIRST DOMAIN CITY DIR

python3 - <<'PY'
import os, pathlib
env = os.environ
pairs = [
    ("acme-bonsai.example", env["DOMAIN"]),
    ("ACME Bonsai", env["COMPANY"]),
    ("#acmebonsaico", "#" + env["HASHTAG"]),
    ("#acmebonsai", "#" + env["HASHTAG"]),
    ("acme_", env["SLUG_US"] + "_"),
    ("acme-", env["SLUG"] + "-"),
    ('"acme"', '"' + env["SLUG"] + '"'),
    ("ACME van", env["COMPANY"] + " van"),
    ("ACME", env["COMPANY"]),
]
if env["OWNER"]:
    pairs.append(("Jane Founder", env["OWNER"]))
if env["OWNER_FIRST"]:
    pairs += [("Jane's", env["OWNER_FIRST"] + "'s"), ("Jane", env["OWNER_FIRST"]),
              ("jane@", env["OWNER_FIRST"].lower() + "@")]
if env["CITY"]:
    pairs += [("Harbor City", env["CITY"]), ("#harborcity", "#" + env["CITY"].lower().replace(" ", ""))]
pairs = [(a, b) for a, b in pairs if b]  # skip empties (e.g. no --domain)

changed = 0
for p in pathlib.Path(env["DIR"]).rglob("*"):
    if not p.is_file() or p.suffix in {".db", ".png", ".jpg"}:
        continue
    try:
        t = p.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue
    o = t
    for a, b in pairs:
        t = t.replace(a, b)
    if t != o:
        p.write_text(t, encoding="utf-8")
        changed += 1
print(f"rebranded {changed} files under {env['DIR']}")
PY

echo "Next: rewrite $DIR/team-memory/ (brand voice, ICP, market brief) for your business,"
echo "then run scripts/validate.sh and scripts/audit.py."
