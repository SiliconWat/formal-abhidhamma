#!/bin/sh
# fo/run.sh — the first-order layer's checks (founder 2026-10-16) and A424's chain theorem (2026-10-18). Builds every
# module on Mathlib v4.34.1, requires every theorem to depend on no sorryAx, then applies each BREAK to a copy and
# requires it to FAIL, with its first error inside the theorem it targets (a break that fails somewhere else proves
# nothing about its target).
set -u; cd "$(dirname "$0")"
export PATH="$HOME/.elan/bin:$PATH"
for m in FO.Stream FO.Chain; do
  lake build "$m" >/dev/null 2>&1 || { echo "FAIL: $m does not build"; lake build "$m" 2>&1 | tail -20; exit 1; }
done

THMS="FormalAbhidhamma.FO.star_has_infinitely_many_before FormalAbhidhamma.FO.nat_finitely_many_before
FormalAbhidhamma.FO.star_iff_nat FormalAbhidhamma.FO.finitely_many_before_is_not_first_order
FormalAbhidhamma.FO.Chain.finite_chain_spans_infinitesimal FormalAbhidhamma.FO.Chain.finite_chain_standard_part_zero
FormalAbhidhamma.FO.Chain.ordinary_duration_needs_a_long_step FormalAbhidhamma.FO.Chain.infinitely_many_steps_make_a_unit
FormalAbhidhamma.FO.Chain.cessation_step_is_not_infinitesimal"
{ printf 'import FO.Stream\nimport FO.Chain\n'; for t in $THMS; do printf '#print axioms %s\n' "$t"; done; } > FO/RunAxioms.lean
out=$(lake env lean FO/RunAxioms.lean 2>&1); rm -f FO/RunAxioms.lean
want=$(printf '%s\n' $THMS | wc -l | tr -d ' ')
n=$(printf '%s\n' "$out" | grep -c "depends on axioms")
if [ "$n" -ne "$want" ] || printf '%s' "$out" | grep -q sorryAx; then echo "FAIL: axioms check ($n of $want)"; printf '%s\n' "$out"; exit 1; fi
echo "ok   $want theorems, no sorryAx"

python3 - <<'PY' || exit 1
import re, subprocess, os
def span(text, name):
    lines = text.split("\n")
    start = next(i for i, l in enumerate(lines) if re.match(rf"theorem {name}\b", l))
    end = next((i for i in range(start + 1, len(lines)) if re.match(r"(theorem|def|noncomputable def|instance|abbrev|end|/--) ", lines[i])), len(lines))
    return start + 1, end
BREAKS = [
    ("FO/Stream.lean", "principal", "star_has_infinitely_many_before",
     "the ultrapower over a PRINCIPAL ultrafilter is ℕ again, so no moment has infinitely many before it",
     lambda s: s.replace("hyperfilter ℕ", "(pure 0 : Ultrafilter ℕ)")),
    ("FO/Stream.lean", "infinite", "finitely_many_before_is_not_first_order",
     "swap 'finitely many' for 'infinitely many': both ℕ and the ultrapower then lack the property, and the argument breaks",
     lambda s: s.replace("(M ⊨ φ ↔ ∀ b : M, Set.Finite {a : M | Before M a b})", "(M ⊨ φ ↔ ∀ b : M, Set.Infinite {a : M | Before M a b})")),
    ("FO/Chain.lean", "one-long-step", "finite_chain_spans_infinitesimal",
     "exempt the first step from being infinitesimal (A112's cessation inside the chain): the chain's span is no longer forced",
     lambda s: s.replace("(h : ∀ i, Infinitesimal (d i)) :\n    Infinitesimal (∑ i, d i) :=",
                         "(h : ∀ i, i.val ≠ 0 → Infinitesimal (d i)) :\n    Infinitesimal (∑ i, d i) :=")),
    ("FO/Chain.lean", "no-ordinary-step", "cessation_step_is_not_infinitesimal",
     "make the long step infinitesimal too (ε for 1): then the span IS infinitesimal, and the theorem must not prove otherwise",
     lambda s: s.replace("¬ Infinitesimal ((1 : ℝ*) + ε) := by", "¬ Infinitesimal ((ε : ℝ*) + ε) := by")),
    ("FO/Chain.lean", "finitely-many", "infinitely_many_steps_make_a_unit",
     "ε · 1000 for ε · ω: a finite multiple of an infinitesimal cannot make the unit",
     lambda s: s.replace("theorem infinitely_many_steps_make_a_unit : ε * ω = 1 ∧ stdPart (ε * ω) = 1 :=",
                         "theorem infinitely_many_steps_make_a_unit : ε * 1000 = 1 ∧ stdPart (ε * 1000) = 1 :=")),
]
bad = 0
for path, tag, target, why, f in BREAKS:
    src = open(path, encoding="utf-8").read()
    broken = f(src)
    assert broken != src, f"break {tag} changed nothing"
    bpath = path.replace(".lean", "Break.lean")
    open(bpath, "w", encoding="utf-8").write(broken)
    r = subprocess.run(["lake", "env", "lean", bpath], capture_output=True, text=True)
    os.remove(bpath)
    errs = [int(m.group(1)) for m in re.finditer(re.escape(bpath) + r":(\d+):\d+: error", r.stdout + r.stderr)]
    lo, hi = span(broken, target)
    if not errs:
        print(f"FAIL break {tag}: it BUILT — the target does not depend on what was broken"); bad += 1
    elif not lo <= errs[0] <= hi:
        print(f"FAIL break {tag}: first error at line {errs[0]}, outside {target} (lines {lo}–{hi})"); bad += 1
    else:
        print(f"ok   break {tag}: fails in {target} (line {errs[0]}) — {why}")
raise SystemExit(1 if bad else 0)
PY
