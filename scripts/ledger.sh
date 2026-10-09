#!/usr/bin/env bash
# Ledger tooling: the per-team SQLite ledger is the evidence trail for every agent action.
#
#   scripts/ledger.sh init <team>              create data/<ledger>.db from schemas/*.sql
#   scripts/ledger.sh transitions <team> [N]   export last N (default 500) state transitions as CSV
#   scripts/ledger.sh metrics <team>           operational metrics: volume, time-in-state, approval latency
#   scripts/ledger.sh demo                     self-check against a throwaway ledger
#
# <team> is a directory under workforce/agents/. Databases live in <team>/data/ and are git-ignored.
set -euo pipefail
ROOT="${LEDGER_ROOT:-workforce/agents}"

team_dir() { local d="$ROOT/$1"; [[ -d "$d" ]] || { echo "no team: $1" >&2; exit 2; }; echo "$d"; }
db_path()  { local d; d=$(team_dir "$1"); echo "$d/data/$(basename "$(ls "$d"/schemas/*.sql | head -1)" .sql).db"; }
trans_table() { sqlite3 "$1" "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%state_transitions' LIMIT 1;"; }
# schemas differ slightly: from_status/to_status vs from_state/to_state, transitioned_at vs created_at
col() { sqlite3 "$1" "PRAGMA table_info($2);" | awk -F'|' -v want="$3" '$2 ~ want {print $2; exit}'; }

cmd_init() {
  local d db; d=$(team_dir "$1"); db=$(db_path "$1")
  mkdir -p "$d/data"
  for f in "$d"/schemas/*.sql; do sqlite3 "$db" < "$f"; done
  echo "initialized $db"
}

cmd_transitions() {
  local db t; db=$(db_path "$1"); t=$(trans_table "$db")
  local ts; ts=$(col "$db" "$t" '_at$')
  sqlite3 -header -csv "$db" "SELECT * FROM $t ORDER BY $ts DESC LIMIT ${2:-500};"
}

cmd_metrics() {
  local db t; db=$(db_path "$1"); t=$(trans_table "$db")
  local from to ts ent; from=$(col "$db" "$t" '^from_'); to=$(col "$db" "$t" '^to_'); ts=$(col "$db" "$t" '_at$')
  ent=$(col "$db" "$t" '^entity_type$'); [[ -n "$ent" ]] || ent="'all'"
  echo "## Transitions by type and target state"
  sqlite3 -header -column "$db" "SELECT $ent AS entity_type, $to AS to_state, COUNT(*) AS n FROM $t GROUP BY 1,2 ORDER BY 1,3 DESC;"
  echo; echo "## Transitions by agent"
  sqlite3 -header -column "$db" "SELECT agent, COUNT(*) AS n FROM $t GROUP BY 1 ORDER BY 2 DESC;"
  echo; echo "## Mean hours spent in each state (time until the next transition of the same entity)"
  local eid; eid=$(col "$db" "$t" '_id$'); [[ "$eid" == "id" ]] && eid=$(sqlite3 "$db" "PRAGMA table_info($t);" | awk -F'|' '$2 ~ /_id$/ && $2 != "id" {print $2; exit}')
  sqlite3 -header -column "$db" "
    WITH s AS (
      SELECT $to AS state, $ts AS entered,
             LEAD($ts) OVER (PARTITION BY $eid ORDER BY $ts) AS left_at
      FROM $t)
    SELECT state, COUNT(*) AS n,
           ROUND(AVG((julianday(left_at) - julianday(entered)) * 24), 2) AS mean_hours
    FROM s WHERE left_at IS NOT NULL GROUP BY state ORDER BY mean_hours DESC;"
  echo; echo "## Approval latency (awaiting/pending review -> approved), hours"
  sqlite3 -header -column "$db" "
    WITH s AS (
      SELECT $eid AS eid, $to AS state, $ts AS at,
             LEAD($to) OVER (PARTITION BY $eid ORDER BY $ts) AS next_state,
             LEAD($ts) OVER (PARTITION BY $eid ORDER BY $ts) AS next_at
      FROM $t)
    SELECT COUNT(*) AS approvals,
           ROUND(AVG((julianday(next_at) - julianday(at)) * 24), 2) AS mean_hours,
           ROUND(MAX((julianday(next_at) - julianday(at)) * 24), 2) AS max_hours
    FROM s WHERE (state LIKE '%awaiting%' OR state LIKE '%review%' OR state LIKE '%pending%')
      AND next_state LIKE '%approved%';"
}

cmd_demo() {
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  ROOT="$tmp"
  mkdir -p "$tmp/demo/schemas"
  cat > "$tmp/demo/schemas/demo-ledger.sql" <<'SQL'
CREATE TABLE IF NOT EXISTS ledger_state_transitions (
  id INTEGER PRIMARY KEY AUTOINCREMENT, entity_type TEXT NOT NULL, entity_id TEXT NOT NULL,
  from_status TEXT, to_status TEXT NOT NULL, agent TEXT NOT NULL, reason TEXT, metadata TEXT,
  transitioned_at TEXT NOT NULL DEFAULT (datetime('now')));
INSERT INTO ledger_state_transitions (entity_type, entity_id, from_status, to_status, agent, transitioned_at) VALUES
 ('post','p1',NULL,'drafted','copywriter','2026-01-01 08:00:00'),
 ('post','p1','drafted','awaiting_approval','qa','2026-01-01 09:00:00'),
 ('post','p1','awaiting_approval','approved','human','2026-01-01 12:00:00'),
 ('post','p2',NULL,'drafted','copywriter','2026-01-02 08:00:00'),
 ('post','p2','drafted','awaiting_approval','qa','2026-01-02 08:30:00'),
 ('post','p2','awaiting_approval','approved','human','2026-01-02 09:30:00');
SQL
  cmd_init demo >/dev/null
  local out; out=$(cmd_metrics demo)
  echo "$out"
  # self-check: p1 waited 3h, p2 waited 1h -> mean 2.0, max 3.0
  grep -qE '^2 +2\.0 +3\.0' <<<"$out" || { echo "DEMO FAILED: approval latency wrong" >&2; exit 1; }
  [[ $(cmd_transitions demo 2 | wc -l) -eq 3 ]] || { echo "DEMO FAILED: csv export" >&2; exit 1; }
  echo; echo "DEMO OK"
}

case "${1:-}" in
  init)        cmd_init "$2" ;;
  transitions) cmd_transitions "$2" "${3:-500}" ;;
  metrics)     cmd_metrics "$2" ;;
  demo)        cmd_demo ;;
  *) sed -n '2,9p' "$0"; exit 2 ;;
esac
