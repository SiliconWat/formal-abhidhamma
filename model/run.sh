#!/bin/sh
# model/ — the one-World encoding for The Calculus of Moments, attempt 1 (a WORKING encoding; Protocol 2 freezes it).
# 1. Every file compiles (Tax.lean imports the generator and Proc.lean imports Tax.lean, so their oleans are built
#    first, in a scratch directory).
# 2. TEETH: each definition `def aNN_… / c_… / k_…` has a forbidden-world theorem `<id>_forbids_…` that uses it, and
#    replacing the WHOLE definition (every line of it) with `True` makes that theorem fail, checked on a copy that keeps the
#    definitions and only that theorem (isolated, per the Kv 8.2 run's lesson), with the FIRST error inside that theorem:
#    a weakening that breaks the file somewhere else proves nothing about its target (fo/run.sh's rule, 2026-10-16).
#    A definition with no forbidden world, or whose weakening still checks, fails this suite (Protocol 1 §7.2 and §9).
# Exit 0 only if all hold. LEAN=path/to/lean to override. `./run.sh --control` plants the three failures it must catch.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
command -v "$LEAN" >/dev/null 2>&1 || LEAN="$HOME/.elan/bin/lean"
FILES="Mind.lean Tax.lean Proc.lean Mat.lean Link.lean Cond.lean Clocks.lean Join.lean Cosmos.lean Status.lean"
B=$(mktemp -d); trap 'rm -rf "$B"' EXIT
export LEAN_PATH="$B"
( cd ../control && $LEAN -o "$B/Cetasika.olean" Cetasika.lean ) && ( cd ../sangaha && $LEAN -o "$B/Citta.olean" Citta.lean \
  && $LEAN -o "$B/Rules.olean" Rules.lean ) || { echo "FAIL  the generator does not build"; exit 1; }
# Proc.lean imports Tax.lean, so Tax's olean is built next (from model/, where the repo's toolchain is pinned)
$LEAN -o "$B/Tax.olean" Tax.lean || { echo "FAIL  Tax.lean does not build"; exit 1; }
# Link.lean imports Mind.lean and Tax.lean
$LEAN -o "$B/Mind.olean" Mind.lean || { echo "FAIL  Mind.lean does not build"; exit 1; }
# Cond.lean imports Relata.lean (the Paṭṭhāna relata, matika/)
( cd ../matika && $LEAN -o "$B/Relata.olean" Relata.lean ) || { echo "FAIL  Relata.lean does not build"; exit 1; }
# Join.lean imports Cond.lean
$LEAN -o "$B/Cond.olean" Cond.lean || { echo "FAIL  Cond.lean does not build"; exit 1; }
# Mat.lean imports Proc.lean, so Proc's olean is built too
$LEAN -o "$B/Proc.olean" Proc.lean || { echo "FAIL  Proc.lean does not build"; exit 1; }
CONTROL=0; [ "${1:-}" = "--control" ] && CONTROL=1
if [ $CONTROL = 1 ]; then
  # Planted, each of which the teeth test must report: a definition with no forbidden world (NO TEETH), one whose forbidden
  # world does not depend on it (BLIND), and one whose weakening breaks the file outside its theorem (FAILS ELSEWHERE).
  # And one it must PASS: a two-line definition, weakened whole (the old harness replaced only its first line, which
  # broke the file's syntax and was counted as a pass).
  cp Tax.lean "$B/Control.lean"
  cat >> "$B/Control.lean" <<'EOF'
namespace FormalAbhidhamma.Model
def a901_toothless (t : Tax) : Prop := t.kinds.length = 7
def a902_blind (t : Tax) : Prop := t.cets.length = 9
theorem a902_forbids_bare : ¬ (a902_blind bare ∧ False) := by intro h; exact h.2
def a903_two_lines (t : Tax) : Prop :=
  t.rupas.length = 3
theorem a903_forbids_bare : ¬ a903_two_lines bare := by unfold a903_two_lines; decide
def a904_used_elsewhere (t : Tax) : Prop := t.kinds.length = 1
example : a904_used_elsewhere bare ↔ bare.kinds.length = 1 := Iff.rfl
theorem a904_forbids_bare : ¬ a904_used_elsewhere bare := by unfold a904_used_elsewhere; decide
end FormalAbhidhamma.Model
EOF
  FILES="$B/Control.lean"
fi
for f in $FILES; do $LEAN "$f" >/dev/null 2>&1 || { echo "FAIL  $f does not compile"; $LEAN "$f"; exit 1; }; done
echo "PASS  compiles: $FILES"
python3 - "$LEAN" "$CONTROL" $FILES <<'PY'
import re, subprocess, sys, tempfile, os
lean, control, files = sys.argv[1], sys.argv[2] == "1", sys.argv[3:]
TOP = re.compile(r"(/--|/-!|/-|--|theorem |lemma |example |def |abbrev |structure |inductive |instance |class |end |namespace |section |open |variable |set_option |noncomputable |private |protected |@\[|#)")
bad = 0; n = 0; seen = set()
def block(L, i, docs=True):
    """Lines of the top-level item starting at line i: its docstring (if docs) and every line up to the next item."""
    a = i
    if docs and a > 0 and L[a - 1].rstrip().endswith("-/"):
        while a > 0 and not L[a - 1].lstrip().startswith("/--"): a -= 1
        a -= 1
    b = i + 1
    while b < len(L) and L[b].strip() and not TOP.match(L[b]): b += 1
    return range(a, b)
for path in files:
    L = open(path, encoding="utf-8").read().split("\n")
    defs = [(i, re.match(r"def ((?:a\d+b?|c|k)_\w+) ", l).group(1)) for i, l in enumerate(L) if re.match(r"def (?:a\d+b?|c|k)_\w+ ", l)]
    if control: defs = [d for d in defs if d[1].startswith("a90")]
    thms = [(i, l.split()[1]) for i, l in enumerate(L) if l.startswith("theorem ")]
    for di, name in defs:
        ident = name.split("_")[0]
        mine = [t for t in thms if t[1].startswith(ident + "_forbids_") and re.search(rf"\b{name}\b", "\n".join(L[r] for r in block(L, t[0])))]
        if not mine:
            print(f"NO TEETH  {name} — no forbidden-world theorem uses it"); bad += 1; seen.add("toothless"); continue
        for ti, tname in mine:
            n += 1
            drop = set()
            for oi, _ in thms:
                if oi != ti: drop.update(block(L, oi))
            body = set(block(L, di, docs=False))
            head = L[di][: L[di].index(":=") + 2] if ":=" in L[di] else None
            if head is None: print(f"BREAK NOT APPLIED  {name} — its first line has no ':='"); bad += 1; continue
            kept, weak = [], []
            for k, l in enumerate(L):
                if k in drop: continue
                kept.append(l)
                if k == di: weak.append(head + " True")
                elif k in body: continue
                else: weak.append(l)
            with tempfile.TemporaryDirectory() as T:
                p = os.path.join(T, "Kept.lean")
                open(p, "w", encoding="utf-8").write("\n".join(kept))
                if subprocess.run([lean, p], capture_output=True).returncode:
                    print(f"ISOLATION BROKEN  {tname} alone does not compile"); bad += 1; continue
                open(p, "w", encoding="utf-8").write("\n".join(weak))
                r = subprocess.run([lean, p], capture_output=True, text=True)
                errs = [int(m.group(1)) for m in re.finditer(r"Kept\.lean:(\d+):\d+: error", r.stdout + r.stderr)]
                start = next(k for k, l in enumerate(weak) if l.startswith(f"theorem {tname} ")) + 1
                end = start + len(block(weak, start - 1, docs=False)) - 1
                if not errs:
                    print(f"BLIND  {name} := True still lets {tname} check"); bad += 1; seen.add("blind")
                elif not start <= errs[0] <= end:
                    print(f"FAILS ELSEWHERE  {name} := True breaks line {errs[0]}, outside {tname} (lines {start}–{end})"); bad += 1; seen.add("elsewhere")
                else:
                    print(f"FAILS as required  {name} := True  ({tname} alone, line {errs[0]})")
if control:
    ok = seen == {"toothless", "blind", "elsewhere"} and n == 3 and bad == 3
    # a903 must PASS here: its whole two-line body is replaced, so the break lands in its theorem, as required
    print(f"{'PASS' if ok else 'FAIL'}  control: planted toothless, blind and fails-elsewhere reported; the two-line definition weakened whole and passed ({sorted(seen)}, {bad} problems)")
    sys.exit(0 if ok else 1)
print(f"{'PASS' if not bad else 'FAIL'}  teeth: {n} forbidden worlds, {bad} problem(s)")
sys.exit(1 if bad else 0)
PY
