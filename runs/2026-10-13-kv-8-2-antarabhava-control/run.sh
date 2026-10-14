#!/bin/sh
# Kv 8.2 — a known-answer control under the A389 conventions (PREREG pushed 2026-10-14T00:22:20Z, OTS). Every registered
# definition and theorem statement must appear VERBATIM in Antarabhava.lean, the theorems must CHECK, and each deliberate
# break must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
python3 - <<'PY' || exit 1
import re
reg = open("PREREG.md", encoding="utf-8").read().split("```lean", 1)[1].split("```", 1)[0]
src = open("Antarabhava.lean", encoding="utf-8").read()
chunks = re.findall(r"(?m)^(def [\s\S]*?)(?=\n\n|\n/-)", reg) + re.findall(r"(theorem [\s\S]*?:= by)", reg)
chunks += re.findall(r"(?m)^(structure World where[\s\S]*?)(?=\n\n)", reg)
moved = [c.split("\n")[0] for c in chunks if c not in src]
if not chunks or moved:
    print("STATEMENT MOVED", moved or "nothing registered was found"); raise SystemExit(1)
print(f"VERBATIM  {len(chunks)} registered definitions and statements unchanged")
PY
if $LEAN Antarabhava.lean; then echo "PASS  t1_no_room_for_the_reported_view · t2a_mindless_interval_admitted · t2b_mindless_interval_not_forced · model_t1_hypotheses"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Antarabhava.lean "$T/"; sed -i.orig "$2" "$T/Antarabhava.lean"
  if cmp -s "$T/Antarabhava.lean" "$T/Antarabhava.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Antarabhava.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "A3's successor clause dropped: the rebirth citta may come first" 's/^def a3_successor (w : World) : Prop := .*/def a3_successor (w : World) : Prop := True/'
try "A3's immediacy dropped: a citta may lie between" 's/^def a3_immediate (w : World) : Prop := .*/def a3_immediate (w : World) : Prop := True/'
try "A122's proximity dropped: the death conditions nothing" 's/^def a122_death_to_rebirth (w : World) : Prop := .*/def a122_death_to_rebirth (w : World) : Prop := True ∧ w.patisandhi w.upapatti/'
try "A122's rebirth-linking dropped: what the death conditions need not be a rebirth" 's/^def a122_death_to_rebirth (w : World) : Prop := .*/def a122_death_to_rebirth (w : World) : Prop := w.prox w.cuti w.upapatti ∧ True/'
try "A123 dropped: consciousness without a citta" 's/^def a123_vinnana_is_citta (w : World) : Prop := .*/def a123_vinnana_is_citta (w : World) : Prop := True/'
try "the view without consciousness (the commentaries' report removed)" 's/^def with_mind (w : World) : Prop := .*/def with_mind (w : World) : Prop := True/'
try "the view with a rebirth-linking inside it (the later holders')" 's/  ∃ t, w.cuti < t ∧ w.antara t ∧ ∀ s, w.cuti < s → s ≤ t → ¬ w.patisandhi s/  ∃ t, w.cuti < t ∧ w.antara t/'
echo "all breaks fail as required"
