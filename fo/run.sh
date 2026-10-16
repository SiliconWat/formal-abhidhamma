#!/bin/sh
# fo/run.sh — the first-order layer's checks (founder 2026-10-16). Builds FO.Stream on Mathlib v4.34.1, requires every
# theorem to depend on no sorryAx, then applies each BREAK to a copy and requires it to FAIL, with its first error inside
# the theorem it targets (a break that fails somewhere else proves nothing about its target).
set -u; cd "$(dirname "$0")"
export PATH="$HOME/.elan/bin:$PATH"
lake build FO.Stream >/dev/null 2>&1 || { echo "FAIL: FO.Stream does not build"; exit 1; }

printf 'import FO.Stream\nopen FormalAbhidhamma.FO\n#print axioms star_has_infinitely_many_before\n#print axioms nat_finitely_many_before\n#print axioms star_iff_nat\n#print axioms finitely_many_before_is_not_first_order\n' > FO/RunAxioms.lean
out=$(lake env lean FO/RunAxioms.lean 2>&1); rm -f FO/RunAxioms.lean
n=$(printf '%s\n' "$out" | grep -c "depends on axioms")
if [ "$n" -ne 4 ] || printf '%s' "$out" | grep -q sorryAx; then echo "FAIL: axioms check"; printf '%s\n' "$out"; exit 1; fi
echo "ok   4 theorems, no sorryAx"

python3 - <<'PY' || exit 1
import re, subprocess, os
src = open("FO/Stream.lean", encoding="utf-8").read()
def span(text, name):
    lines = text.split("\n")
    start = next(i for i, l in enumerate(lines) if re.match(rf"theorem {name}\b", l))
    end = next((i for i in range(start + 1, len(lines)) if re.match(r"(theorem|def|noncomputable def|instance|abbrev|end) ", lines[i])), len(lines))
    return start + 1, end
BREAKS = [
    ("principal", "star_has_infinitely_many_before",
     "the ultrapower over a PRINCIPAL ultrafilter is ℕ again, so no moment has infinitely many before it",
     lambda s: s.replace("hyperfilter ℕ", "(pure 0 : Ultrafilter ℕ)")),
    ("infinite", "finitely_many_before_is_not_first_order",
     "swap 'finitely many' for 'infinitely many': both ℕ and the ultrapower then lack the property, and the argument breaks",
     lambda s: s.replace("(M ⊨ φ ↔ ∀ b : M, Set.Finite {a : M | Before M a b})", "(M ⊨ φ ↔ ∀ b : M, Set.Infinite {a : M | Before M a b})")),
]
bad = 0
for tag, target, why, f in BREAKS:
    broken = f(src)
    assert broken != src, f"break {tag} changed nothing"
    open("FO/Break.lean", "w", encoding="utf-8").write(broken)
    r = subprocess.run(["lake", "env", "lean", "FO/Break.lean"], capture_output=True, text=True)
    os.remove("FO/Break.lean")
    errs = [int(m.group(1)) for m in re.finditer(r"FO/Break\.lean:(\d+):\d+: error", r.stdout + r.stderr)]
    lo, hi = span(broken, target)
    if not errs:
        print(f"FAIL break {tag}: it BUILT — the target does not depend on what was broken"); bad += 1
    elif not lo <= errs[0] <= hi:
        print(f"FAIL break {tag}: first error at line {errs[0]}, outside {target} (lines {lo}–{hi})"); bad += 1
    else:
        print(f"ok   break {tag}: fails in {target} (line {errs[0]}) — {why}")
raise SystemExit(1 if bad else 0)
PY
