#!/usr/bin/env python3
"""Governance scorecard for every team workspace under workforce/agents.

Checks the controls that make an agent safe to run unattended, and prints a
markdown table (or JSON with --json). Exit 1 with --strict if any check fails.

    scripts/audit.py [--root workforce] [--json] [--strict]
"""
import argparse, json, pathlib, re, sys

CHECKS = [
    ("kill_switch",     "config/emergency-stop.json exists with one boolean *_enabled flag"),
    ("stop_in_agents",  "AGENTS.md tells agents to check the kill switch"),
    ("approval_policy", "approval-policy.json: every rule has approvers and no auto-approve on timeout"),
    ("authority_matrix","USER.md states what the human approves"),
    ("ledger_schema",   "ledger SQL has a *_state_transitions table with agent/from/to/reason/timestamp"),
    ("idempotency",     "idempotency keys documented for outbound side-effects"),
    ("cost_controls",   "every sub-agent AGENTS.md has turn/retry budgets"),
    ("subagent_safety", "every sub-agent AGENTS.md restates safety rules (sub-agents only load AGENTS+TOOLS)"),
    ("heartbeat_tiny",  "HEARTBEAT.md checks the kill switch and stays <= 12 items"),
    ("memory_budget",   "MEMORY.md within 200 lines"),
    ("env_example",     "config/env.example present, no real-looking secrets"),
    ("runbook",         "ops/runbook.md covers emergency stop and incident response"),
]

SECRET_RE = re.compile(r"(sk_(live|test)_[A-Za-z0-9]{16,}|ghp_[A-Za-z0-9]{30,}|AKIA[0-9A-Z]{16}|xox[abp]-[A-Za-z0-9-]{20,})")


def read(p: pathlib.Path) -> str:
    try:
        return p.read_text(encoding="utf-8")
    except (FileNotFoundError, IsADirectoryError):
        return ""


def audit_team(team: pathlib.Path) -> dict:
    r = {}
    stop = team / "config/emergency-stop.json"
    try:
        d = json.loads(read(stop))
        flags = [k for k, v in d.items() if k.endswith("_enabled") and isinstance(v, bool)]
        r["kill_switch"] = len(flags) == 1 and {"reason", "stopped_by", "stopped_at"} <= set(d)
    except json.JSONDecodeError:
        r["kill_switch"] = False

    agents_md = read(team / "AGENTS.md")
    r["stop_in_agents"] = "emergency-stop" in agents_md

    try:
        pol = json.loads(read(team / "config/approval-policy.json"))
        rules = pol.get("approval_policy", pol).get("rules", {})
        ok = bool(rules)
        for rule in rules.values():
            if rule.get("requires_approval", True):
                ok &= bool(rule.get("approvers"))
            else:
                ok &= bool(rule.get("authorized_actors"))
            ok &= rule.get("timeout_action") not in ("approve", "auto_approve", "auto-approve")
        r["approval_policy"] = ok
    except json.JSONDecodeError:
        r["approval_policy"] = False

    user_md = read(team / "USER.md").lower()
    r["authority_matrix"] = "approver" in user_md or "authority" in user_md or "approves" in user_md

    sql = "\n".join(read(p) for p in team.glob("schemas/*.sql"))
    m = re.search(r"CREATE TABLE IF NOT EXISTS \w*state_transitions\s*\((.*?)\);", sql, re.S)
    cols = m.group(1).lower() if m else ""
    r["ledger_schema"] = all(c in cols for c in ("agent", "reason")) and (
        ("from_status" in cols and "to_status" in cols) or ("from_state" in cols and "to_state" in cols)
    ) and ("_at " in cols or "timestamp" in cols)

    blob = agents_md + read(team / "README.md")
    r["idempotency"] = "idempoten" in blob.lower()

    subs = [p for p in (team / "agents").glob("*/") if p.is_dir()]
    sub_agents = [read(s / "AGENTS.md") for s in subs]
    r["cost_controls"] = bool(subs) and all(
        re.search(r"(cost controls|max \d+ (turns|retr))", a, re.I) for a in sub_agents
    )
    r["subagent_safety"] = bool(subs) and all(re.search(r"^#+ .*safety", a, re.I | re.M) for a in sub_agents)

    hb = read(team / "HEARTBEAT.md")
    r["heartbeat_tiny"] = "emergency-stop" in hb and hb.count("\n- [") <= 12

    r["memory_budget"] = len(read(team / "MEMORY.md").splitlines()) <= 200

    env = read(team / "config/env.example")
    r["env_example"] = bool(env) and not SECRET_RE.search(env)

    rb = read(team / "ops/runbook.md").lower()
    r["runbook"] = "emergency stop" in rb and "incident" in rb
    return r


def persona_conflicts(root: pathlib.Path) -> list[str]:
    """Names and emoji must be unique across the whole workforce."""
    seen: dict[str, str] = {}
    conflicts = []
    for ident in root.rglob("IDENTITY.md"):
        txt = read(ident)
        name = re.search(r"\*\*Name:\*\*\s*([^\n—(-]+)", txt)
        emoji = re.search(r"\*\*Emoji:\*\*\s*(\S+)", txt)
        where = str(ident.parent.relative_to(root))
        if where == ".":
            continue  # company identity is not an agent persona
        for kind, mt in (("name", name), ("emoji", emoji)):
            if not mt:
                continue
            key = f"{kind}:{mt.group(1).strip()}"
            # the CMO team deliberately uses role names for its sub-agents; skip generic roles
            if kind == "name" and " " in mt.group(1).strip() and not re.match(r"^[A-Z][a-z]+$", mt.group(1).split()[0]):
                continue
            if key in seen and seen[key].split("/")[0] != where.split("/")[0]:
                conflicts.append(f"{key} used by {seen[key]} and {where}")
            seen.setdefault(key, where)
    return conflicts


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default="workforce")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--strict", action="store_true")
    a = ap.parse_args()
    root = pathlib.Path(a.root)
    teams = sorted(p for p in (root / "agents").glob("*/") if p.is_dir())
    results = {t.name: audit_team(t) for t in teams}
    conflicts = persona_conflicts(root)

    if a.json:
        print(json.dumps({"teams": results, "persona_conflicts": conflicts}, indent=2))
    else:
        keys = [k for k, _ in CHECKS]
        print("| team | " + " | ".join(keys) + " | score |")
        print("|---|" + "---|" * (len(keys) + 1))
        for name, r in results.items():
            score = sum(r[k] for k in keys)
            print(f"| {name} | " + " | ".join("✓" if r[k] else "✗" for k in keys) + f" | {score}/{len(keys)} |")
        print()
        for k, desc in CHECKS:
            print(f"- `{k}` — {desc}")
        print()
        print("Persona conflicts:", "none" if not conflicts else "")
        for c in conflicts:
            print(f"  - {c}")

    failed = any(not v for r in results.values() for v in r.values()) or bool(conflicts)
    return 1 if (a.strict and failed) else 0


if __name__ == "__main__":
    sys.exit(main())
