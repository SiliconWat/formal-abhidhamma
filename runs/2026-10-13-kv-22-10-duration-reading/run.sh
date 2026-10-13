#!/bin/sh
# Kv 22.10 on the duration reading — the second /prove run (PREREG pushed 2026-10-13T21:51:14Z, OTS). Every registered
# DEFINITION and theorem statement must appear VERBATIM in Khanika2.lean (the first run checked theorem heads only — its
# refuter, F9), the theorems must CHECK, and each deliberate break must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
python3 - <<'PY' || exit 1
import re
reg = open("PREREG.md", encoding="utf-8").read().split("```lean", 1)[1].split("```", 1)[0]
src = open("Khanika2.lean", encoding="utf-8").read()
chunks = re.findall(r"(?m)^(def [\s\S]*?)(?=\n\n|\n/-)", reg) + re.findall(r"(theorem [\s\S]*?:= by)", reg)
chunks += re.findall(r"(?m)^(structure World where[\s\S]*?)(?=\n\n)", reg)
moved = [c.split("\n")[0] for c in chunks if c not in src]
if not chunks or moved:
    print("STATEMENT MOVED", moved or "nothing registered was found"); raise SystemExit(1)
print(f"VERBATIM  {len(chunks)} registered definitions and statements unchanged")
PY
if $LEAN Khanika2.lean; then echo "PASS  t1_mulatika_line_refutes · t2_pitaka_cell_turns_on_the_count · t3_permission_alone_open"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Khanika2.lean "$T/"; sed -i.orig "$2" "$T/Khanika2.lean"
  if cmp -s "$T/Khanika2.lean" "$T/Khanika2.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Khanika2.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "A119 dropped from T1: matter may arise at any sub-moment" 's/^def premises_t1 (k : Int) (w : World) : Prop := premises_common k w ∧ a119_matter_at_arising w/def premises_t1 (k : Int) (w : World) : Prop := premises_common k w/'
try "A3's predecessor citta dropped: a gap may precede the consciousness" 's/^def a3_predecessor (k : Int) (w : World) : Prop := .*/def a3_predecessor (k : Int) (w : World) : Prop := True/'
try "A118 dropped: matter may arise at a dissolution sub-moment" 's/^def a118_not_at_dissolution (k : Int) (w : World) : Prop := .*/def a118_not_at_dissolution (k : Int) (w : World) : Prop := True/'
try "A116 dropped: the base need not be present when the consciousness arises" 's/^def a116_unbroken_base (w : World) : Prop := .*/def a116_unbroken_base (w : World) : Prop := True/'
try "A87 weakened: the base merely not born AFTER the consciousness (≤)" 's/^def a87_purejata (w : World) : Prop := ∀ e c, w.pre e c → w.birth e < w.birth c/def a87_purejata (w : World) : Prop := ∀ e c, w.pre e c → w.birth e ≤ w.birth c/'
try "A117 weakened: a mind-moment of ONE sub-moment allowed" 's/^def a117_two_submoments (k : Int) : Prop := 2 ≤ k/def a117_two_submoments (k : Int) : Prop := 1 ≤ k/'
echo "all breaks fail as required"
