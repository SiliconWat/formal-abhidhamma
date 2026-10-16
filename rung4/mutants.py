#!/usr/bin/env python3
"""mutants.py — how blind is the key to rule-shaped errors?

Every single-point mutation of the cetasika rules (`arises` in sangaha/Rules.lean) is built and run against
the key in Lean (Check.lean and Canon.lean, as sangaha/run.sh runs them), and its generated table is printed
(rung4/Table.lean). Each mutant is NONCOMPILING, EQUIVALENT (same table: no key could catch it), KILLED or
SURVIVED. Then every PAIR of mutants in different clauses is combined (their columns are disjoint, so their
effects add) and checked against the key's projections in Python: a surviving pair is two rule errors that
cancel in every keyed figure. The Python verdict is cross-checked against Lean's on every single mutant.

  mutants.py list   [--system real|toy]     the mutant set, deterministic (fixed before any run)
  mutants.py run    [--system real|toy] [--out FILE.json]
  mutants.py control                        the toy system, whose outcomes are known by construction

Needs Lean on PATH (or LEAN=…). Standard library only.
"""
import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
def pinned_lean():
    """The binary lean-toolchain pins. A bare `lean` outside the repo resolves to elan's default toolchain, which
    cannot read .olean files built by the pinned one: every build then fails (found 2026-10-15)."""
    if os.environ.get("LEAN"):
        return os.environ["LEAN"]
    for elan in ("elan", os.path.expanduser("~/.elan/bin/elan")):
        try:
            return subprocess.run([elan, "which", "lean"], cwd=REPO, capture_output=True, text=True, check=True).stdout.strip()
        except (OSError, subprocess.CalledProcessError):
            continue
    return "lean"


LEAN = pinned_lean()

SYSTEMS = {
    "real": {
        "dir": os.path.join(REPO, "sangaha"), "copy_in": [os.path.join(REPO, "control", "Cetasika.lean")], "extra_path": [],
        "prebuild": ["Cetasika", "Citta", "AnswerKey"], "rules": "Rules", "func": "arises",
        "checks": ["Check.lean", "Canon.lean"], "table": os.path.join(HERE, "Table.lean"),
        # The key's projections (sangaha/AnswerKey.lean): every row total over 121 and over 89; the
        # column totals of vitakka, vicāra, pīti (indices 7, 8, 11 in `all`) over 121 and of every other
        # factor over 89; and the first wholesome citta's row exactly (Canon.lean fixes its 38).
        "projections": [("rows", "121", None), ("rows", "89", None),
                        ("cols", "121", [7, 8, 11]), ("cols", "89", [i for i in range(52) if i not in (7, 8, 11)])],
        "frozen": "firstKusala",
    },
    "toy": {
        "dir": os.path.join(HERE, "control"), "copy_in": [], "extra_path": [],
        "prebuild": ["ToyBase"], "rules": "ToyRules", "func": "arises",
        "checks": ["ToyCheck.lean"], "table": os.path.join(HERE, "control", "ToyTable.lean"),
        "projections": [("rows", "main", None), ("cols", "main", None)], "frozen": None,
    },
}

ATOMS = [r"\b[ct]\.\w+ (?:==|!=) \.\w+", r"\b[ct]\.\w+ ≤ \d+", r"!?isSense c\b",
         r"!?\b[ct]\.\w+\b(?! (?:==|!=|≤))"]


def clauses(src, func):
    """Spans of each clause's condition in `func`: (start, end) offsets into src, its expression with
    comments removed and whitespace collapsed, and the comments it carried."""
    m = re.search(rf"^def {func}\b[^\n]*:=\n", src, re.M)
    start, end = m.end(), src.index("\n\n", m.end())
    body = src[start:end]
    masked = re.sub(r"--[^\n]*", lambda c: " " * len(c.group()), body)
    out = []
    for mk in re.finditer(r"\bthen\b|\belse\b(?!\s+if\b)", masked):
        s = mk.end()
        nxt = re.search(r"\n\s*else\b", masked[s:])
        e = s + nxt.start() if nxt else len(body)
        expr = " ".join(masked[s:e].split())
        comments = re.findall(r"--[^\n]*", body[s:e])
        tag = re.search(r"§R\d+", " ".join(comments))
        out.append({"start": start + s, "end": start + e, "expr": expr, "comments": comments,
                    "clause": tag.group() if tag else f"clause{len(out) + 1}"})
    return out


def atoms(expr):
    seen, found = set(), []
    for pat in ATOMS:
        for m in re.finditer(pat, expr):
            if any(m.start() < e and s < m.end() for s, e in seen):
                continue
            seen.add((m.start(), m.end()))
            found.append((m.start(), m.end(), m.group()))
    return sorted(found)


def mutations(expr):
    """Single-point operators: the whole condition to false/true; each atom to true/false; == ↔ !=;
    each bound ±1; each negation dropped or added; each && ↔ ||."""
    out = []
    def put(label, new):           # one mutant per distinct rewrite: the first operator to produce it names it
        if new != expr and all(new != n for _, n in out):
            out.append((label, new))
    put("COND_FALSE", "false")
    put("COND_TRUE", "true")
    for s, e, a in atoms(expr):
        put(f"ATOM_TRUE[{a}]", expr[:s] + "true" + expr[e:])
        put(f"ATOM_FALSE[{a}]", expr[:s] + "false" + expr[e:])
        if " == " in a:
            put(f"REL_SWAP[{a}]", expr[:s] + a.replace(" == ", " != ") + expr[e:])
        elif " != " in a:
            put(f"REL_SWAP[{a}]", expr[:s] + a.replace(" != ", " == ") + expr[e:])
        elif " ≤ " in a:
            lhs, n = a.rsplit(" ≤ ", 1)
            if int(n) > 0:
                put(f"BOUND-1[{a}]", expr[:s] + f"{lhs} ≤ {int(n) - 1}" + expr[e:])
            put(f"BOUND+1[{a}]", expr[:s] + f"{lhs} ≤ {int(n) + 1}" + expr[e:])
        elif a.startswith("!"):
            put(f"NOT_DROP[{a}]", expr[:s] + a[1:] + expr[e:])
        else:
            put(f"NOT_ADD[{a}]", expr[:s] + "!" + a + expr[e:])
    for m in re.finditer(r"&&|\|\|", expr):
        put(f"CONN_SWAP@{m.start()}", expr[:m.start()] + ("||" if m.group() == "&&" else "&&") + expr[m.end():])
    return out


def mutant_list(system):
    cfg = SYSTEMS[system]
    path = os.path.join(cfg["dir"], cfg["rules"] + ".lean")
    src = open(path, encoding="utf-8").read()
    muts = []
    for k, cl in enumerate(clauses(src, cfg["func"])):
        for label, new in mutations(cl["expr"]):
            text = src[:cl["start"]] + " " + new + ("  " + " ".join(cl["comments"]) if cl["comments"] else "") + src[cl["end"]:]
            muts.append({"id": f"{cl['clause']}:{label}", "clause": k, "from": cl["expr"], "to": new, "text": text})
    return src, muts


def lean(args, cwd, path):
    env = dict(os.environ, LEAN_PATH=os.pathsep.join(path))
    return subprocess.run([LEAN] + args, cwd=cwd, env=env, capture_output=True, text=True)


def parse_tables(out, system):
    tables, name, frozen = {}, ("main" if system == "toy" else "121"), None
    for ln in out.splitlines():
        ln = ln.strip()
        if ln.startswith("#firstKusala"):
            frozen = int(ln.split()[1])
        elif ln.startswith("#"):
            name = ln[1:]
        elif ln and set(ln) <= {"0", "1"}:
            tables.setdefault(name, []).append([int(ch) for ch in ln])
    return tables, frozen


def evaluate(system, rules_text, work):
    """Build one rules text in `work` and return (compiled, lean_killed, tables, frozen_index)."""
    cfg = SYSTEMS[system]
    path = cfg["extra_path"] + ["."]
    open(os.path.join(work, cfg["rules"] + ".lean"), "w", encoding="utf-8").write(rules_text)
    if lean(["-o", cfg["rules"] + ".olean", cfg["rules"] + ".lean"], work, path).returncode != 0:
        return False, None, None, None
    killed = any(lean([c], work, path).returncode != 0 for c in cfg["checks"])
    r = lean([os.path.basename(cfg["table"])], work, path)
    tables, frozen = parse_tables(r.stdout, system)
    return True, killed, tables, frozen


def delta(a, b):
    return {k: [[y - x for x, y in zip(ra, rb)] for ra, rb in zip(a[k], b[k])] for k in a}


def projections_zero(d, cfg, frozen):
    for kind, table, cols in cfg["projections"]:
        m = d[table]
        idx = cols if cols is not None else range(len(m[0]))
        if kind == "rows" and any(sum(row) != 0 for row in m):
            return False
        if kind == "cols" and any(sum(row[j] for row in m) != 0 for j in idx):
            return False
    if frozen is not None and any(d["121"][frozen]):
        return False
    return True


def add(d1, d2):
    return {k: [[x + y for x, y in zip(r1, r2)] for r1, r2 in zip(d1[k], d2[k])] for k in d1}


def nonzero(d):
    return any(any(row) for m in d.values() for row in m)


def run(system, out_path=None, quiet=False):
    cfg = SYSTEMS[system]
    src, muts = mutant_list(system)
    work = tempfile.mkdtemp(prefix=f"rung4-{system}-")
    try:
        for f in os.listdir(cfg["dir"]):
            if f.endswith(".lean"):
                shutil.copy(os.path.join(cfg["dir"], f), work)
        shutil.copy(cfg["table"], work)
        for f in cfg["copy_in"]:          # build every dependency HERE, with the pinned binary: no .olean from the tree
            shutil.copy(f, work)
        path = cfg["extra_path"] + ["."]
        for f in cfg["prebuild"]:
            r = lean(["-o", f + ".olean", f + ".lean"], work, path)
            if r.returncode != 0:
                sys.exit(f"prebuild {f} failed:\n{r.stderr}{r.stdout}")
        ok, killed0, base, frozen = evaluate(system, src, work)
        if not ok or killed0:
            sys.exit("the UNMUTATED rules do not pass their own key: harness or tree is broken")
        results, deltas = [], {}
        for i, m in enumerate(muts):
            ok, killed, tables, _ = evaluate(system, m["text"], work)
            if not ok:
                cls = "NONCOMPILING"
            else:
                d = delta(base, tables)
                if not nonzero(d):
                    cls = "EQUIVALENT"
                else:
                    deltas[m["id"]] = (m["clause"], d)
                    py_killed = not projections_zero(d, cfg, frozen)
                    if py_killed != killed:
                        sys.exit(f"CROSS-CHECK FAILED on {m['id']}: Lean says killed={killed}, Python projections say {py_killed}")
                    cls = "KILLED" if killed else "SURVIVED"
            results.append({"id": m["id"], "from": m["from"], "to": m["to"], "class": cls})
            if not quiet:
                print(f"[{i + 1}/{len(muts)}] {cls:12s} {m['id']}", flush=True)
        ids = sorted(deltas)
        pairs, surviving = 0, []
        for a in range(len(ids)):
            for b in range(a + 1, len(ids)):
                (ca, da), (cb, db) = deltas[ids[a]], deltas[ids[b]]
                if ca == cb:
                    continue          # same clause: not additive, not tested
                pairs += 1
                d = add(da, db)
                if nonzero(d) and projections_zero(d, cfg, frozen):
                    surviving.append([ids[a], ids[b]])
        counts = {c: sum(r["class"] == c for r in results) for c in ("NONCOMPILING", "EQUIVALENT", "KILLED", "SURVIVED")}
        summary = {"system": system, "mutants": len(muts), **counts, "cross_clause_pairs": pairs,
                   "surviving_pairs": len(surviving), "surviving_pair_list": surviving,
                   "mutant_set_sha256": hashlib.sha256("\n".join(m["id"] + "\t" + m["to"] for m in muts).encode()).hexdigest()}
        if out_path:
            json.dump({"summary": summary, "mutants": results}, open(out_path, "w"), indent=1, ensure_ascii=False)
        return summary, results
    finally:
        shutil.rmtree(work, ignore_errors=True)


def control():
    """Known by construction (rung4/control/ToyRules.lean): every non-equivalent single mutant changes a
    row total, so all are KILLED; ATOM_TRUE on the tautology's t.x is EQUIVALENT; and negating R1's t.x
    together with dropping R3's negation swaps two columns, preserving every row and column total: that
    pair, and its mirror images, must SURVIVE."""
    summary, results = run("toy", quiet=True)
    cls = {r["id"]: r["class"] for r in results}
    survivors = {tuple(p) for p in summary["surviving_pair_list"]}
    checks = [
        ("no single mutant survives the toy key", summary["SURVIVED"] == 0),
        ("the tautology hides an EQUIVALENT mutant", cls.get("§R4:ATOM_TRUE[t.x]") == "EQUIVALENT"),
        ("the planted column swap survives as a pair", ("§R1:NOT_ADD[t.x]", "§R3:NOT_DROP[!t.x]") in survivors),
        ("a non-compensating pair is caught", ("§R1:COND_FALSE", "§R2:COND_FALSE") not in survivors),
        ("the Python projections agreed with Lean on every mutant", True),  # run() exits on any disagreement
    ]
    for name, good in checks:
        print(("PASS  " if good else "FAIL  ") + name)
    print(json.dumps({k: summary[k] for k in ("mutants", "EQUIVALENT", "KILLED", "SURVIVED", "cross_clause_pairs", "surviving_pairs")}))
    return 0 if all(g for _, g in checks) else 1


def main():
    p = argparse.ArgumentParser()
    p.add_argument("mode", choices=["list", "run", "control"])
    p.add_argument("--system", choices=list(SYSTEMS), default="real")
    p.add_argument("--out")
    a = p.parse_args()
    if a.mode == "control":
        sys.exit(control())
    if a.mode == "list":
        _, muts = mutant_list(a.system)
        for m in muts:
            print(f"{m['id']}\t{m['from']}  →  {m['to']}")
        print(f"# {len(muts)} mutants · sha256 {hashlib.sha256(chr(10).join(m['id'] + chr(9) + m['to'] for m in muts).encode()).hexdigest()}")
        return
    summary, _ = run(a.system, a.out)
    print(json.dumps(summary, ensure_ascii=False))


if __name__ == "__main__":
    main()
