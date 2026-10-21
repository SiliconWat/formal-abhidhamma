#!/usr/bin/env python3
"""blind.py — the BLIND copy of the encoding (Protocol 1 §7.3): every model file with its comments, its forbidden worlds and its theorems removed, so a reader that loads no doctrine
sees only the definitions and the vocabulary they use. Writes model/blind/<File>.lean and prints how many definitions each holds.
  blind.py            write the copies      blind.py --check   exit 1 if a copy is stale     (the reader's plain English goes to model/BLIND.md, written by hand from the reader's report)"""
import glob, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "blind")
FILES = ["Mind", "Tax", "Proc", "Mat", "Link", "Cond", "Clocks", "Join", "Cosmos", "Status", "Occurs"]
WORLD_TYPES = re.compile(r"^abbrev \w+ : (Mat|Proc|Link Z|CondW Z|Cosmos|Status|Reck Z Z|Joined Z|Tax|Stream Z|Process|Occ Z|Option [A-Za-z.]+)\b")

def strip_comments(t):
    t = re.sub(r"/-.*?-/", "", t, flags=re.S)          # block comments and docstrings
    t = re.sub(r"(?m)--.*$", "", t)                     # line comments
    return t

def blocks(t):
    """Split into top-level blocks: a block starts at a line with no indent and a keyword, and runs to the next such line."""
    out, cur = [], []
    for l in t.split("\n"):
        if re.match(r"^(def|theorem|abbrev|structure|inductive|instance|namespace|end|open|import|private|@\[|set_option|variable)\b", l) or re.match(r"^@\[", l):
            if cur: out.append("\n".join(cur)); cur = []
        cur.append(l)
    if cur: out.append("\n".join(cur))
    return out

def blind(path):
    t = strip_comments(open(path, encoding="utf-8").read())
    keep = []
    for b in blocks(t):
        s = b.lstrip()
        if re.match(r"^(@\[[^\]]*\] )?(private )?theorem\b", s): continue       # forbidden-world theorems and helper lemmas
        if WORLD_TYPES.match(s) and not re.match(r"^abbrev (eight|okKalapa|okMat|okCosmos|okStatus)\b", s): continue   # forbidden worlds
        if s.startswith("abbrev ok"): continue
        keep.append(b.rstrip())
    return re.sub(r"\n{3,}", "\n\n", "\n\n".join(x for x in keep if x.strip())) + "\n"

def build():
    res = {}
    for f in FILES:
        res[f] = blind(os.path.join(HERE, f + ".lean"))
    return res

if __name__ == "__main__":
    res = build(); os.makedirs(OUT, exist_ok=True)
    if sys.argv[1:] == ["--check"]:
        bad = [f for f, t in res.items() if not os.path.exists(os.path.join(OUT, f + ".lean")) or open(os.path.join(OUT, f + ".lean"), encoding="utf-8").read() != t]
        print("blind copies are current" if not bad else f"STALE: {bad}"); sys.exit(1 if bad else 0)
    for f, t in res.items():
        open(os.path.join(OUT, f + ".lean"), "w", encoding="utf-8").write(t)
        print(f"{f:8} {len(t.splitlines()):5} lines, {len(re.findall(r'(?m)^def ', t)):3} defs")
