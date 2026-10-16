#!/bin/sh
# model/ — the one-World encoding for The Calculus of Moments, attempt 1 (a WORKING encoding; Protocol 2 freezes it).
# 1. Every file compiles. 2. TEETH: each definition `def aNN_… / c_… / k_…` has a forbidden-world theorem
#    `<def>_forbids_…` or `<id>_forbids_…`, and replacing the definition with `True` makes THAT theorem fail — checked on a
#    copy that keeps the definitions and only that theorem (isolated, per the Kv 8.2 run's lesson). A definition with no
#    forbidden world, or whose weakening still checks, fails this suite (Protocol 1 §7.2 and §9).
# Exit 0 only if all hold. LEAN=path/to/lean to override.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
FILES="Mind.lean"
for f in $FILES; do $LEAN "$f" >/dev/null 2>&1 || { echo "FAIL  $f does not compile"; $LEAN "$f"; exit 1; }; done
echo "PASS  compiles: $FILES"
python3 - "$LEAN" $FILES <<'PY'
import re, subprocess, sys, tempfile, os
lean, files = sys.argv[1], sys.argv[2:]
bad = 0; n = 0
for path in files:
    L = open(path, encoding="utf-8").read().split("\n")
    defs = [(i, re.match(r"def ((?:a\d+b?|c|k)_\w+) ", l).group(1)) for i, l in enumerate(L) if re.match(r"def (?:a\d+b?|c|k)_\w+ ", l)]
    thms = [(i, l.split()[1]) for i, l in enumerate(L) if l.startswith("theorem ")]
    def block(i):
        """Lines of the theorem starting at i, with its docstring: up to the next blank-line-separated top-level item."""
        a = i
        if a > 0 and L[a - 1].rstrip().endswith("-/"):
            while a > 0 and not L[a - 1].lstrip().startswith("/--"): a -= 1
            a -= 1
        b = i + 1
        while b < len(L) and not re.match(r"(/--|/-!|theorem |def |end )", L[b]): b += 1
        return range(a, b)
    for di, name in defs:
        ident = name.split("_")[0]
        mine = [t for t in thms if t[1].startswith(ident + "_forbids_") and name in "\n".join(L[r] for r in block(t[0]))]
        if not mine:
            print(f"NO TEETH  {name} — no forbidden-world theorem uses it"); bad += 1; continue
        for ti, tname in mine:
            n += 1
            drop = set()
            for oi, _ in thms:
                if oi != ti: drop.update(block(oi))
            kept = [l for k, l in enumerate(L) if k not in drop]
            with tempfile.TemporaryDirectory() as T:
                p = os.path.join(T, "Kept.lean")
                open(p, "w", encoding="utf-8").write("\n".join(kept))
                if subprocess.run([lean, p], capture_output=True).returncode:
                    print(f"ISOLATION BROKEN  {tname} alone does not compile"); bad += 1; continue
                weak = [re.sub(r":= .*$", ":= True", l) if l.startswith(f"def {name} ") else l for l in kept]
                if weak == kept: print(f"BREAK NOT APPLIED  {name}"); bad += 1; continue
                open(p, "w", encoding="utf-8").write("\n".join(weak))
                if subprocess.run([lean, p], capture_output=True).returncode:
                    print(f"FAILS as required  {name} := True  ({tname} alone)")
                else:
                    print(f"BLIND  {name} := True still lets {tname} check"); bad += 1
print(f"{'PASS' if not bad else 'FAIL'}  teeth: {n} forbidden worlds, {bad} problem(s)")
sys.exit(1 if bad else 0)
PY
