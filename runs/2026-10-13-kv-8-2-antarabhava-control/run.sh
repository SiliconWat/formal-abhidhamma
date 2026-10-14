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
if $LEAN Antarabhava.lean; then echo "PASS  t1_no_room_for_the_reported_view · t2a/t2b (a mindless interval: INDEPENDENT) · model_t1_hypotheses · needs_a3_successor · needs_a3_immediate · needs_a122 · needs_a123"; else echo "FAIL"; exit 1; fi
# A break is applied to a copy that keeps the definitions and ONLY the theorem it targets (the run refuter's F4: on the
# whole file, a definition set to True also broke T2a, T2b and the model, so every break "failed" whether or not T1 needs
# it). Known-failure test, 2026-10-14: an unused hypothesis added to T1 and broken is now reported BLIND.
only() { python3 - "$1" "$2" <<'PY'
import re, sys
path, keep = sys.argv[1], sys.argv[2]
L = open(path, encoding="utf-8").read().split("\n")
starts = [i for i, l in enumerate(L) if l.startswith("theorem ")]
drop = set()
for i in starts:
    if L[i].split()[1] == keep: continue
    a = i
    if a > 0 and L[a - 1].rstrip().endswith("-/"):            # its docstring goes with it
        while a > 0 and not L[a - 1].lstrip().startswith("/--"): a -= 1
        a -= 1
    b = i + 1
    while b < len(L) and not re.match(r"(/--|/-!|theorem |end )", L[b]): b += 1
    drop.update(range(a, b))
open(path, "w", encoding="utf-8").write("\n".join(l for k, l in enumerate(L) if k not in drop))
PY
}
try() { T=$(mktemp -d); cp Antarabhava.lean "$T/"; only "$T/Antarabhava.lean" "$1"; cp "$T/Antarabhava.lean" "$T/kept.lean"
  if ! $LEAN "$T/kept.lean" >/dev/null 2>&1; then echo "ISOLATION BROKEN  $1 alone does not compile"; exit 1; fi
  sed -i.orig "$3" "$T/Antarabhava.lean"
  if cmp -s "$T/Antarabhava.lean" "$T/Antarabhava.lean.orig"; then echo "BREAK NOT APPLIED  $2"; exit 1; fi
  if $LEAN "$T/Antarabhava.lean" >/dev/null 2>&1; then echo "BLIND  $2"; exit 1; else echo "FAILS as required  $2 ($1 alone)"; fi; rm -rf "$T"; }
T1=t1_no_room_for_the_reported_view
try $T1 "A3's successor clause dropped: the rebirth citta may come first" 's/^def a3_successor (w : World) : Prop := .*/def a3_successor (w : World) : Prop := True/'
try $T1 "A3's immediacy dropped: a citta may lie between" 's/^def a3_immediate (w : World) : Prop := .*/def a3_immediate (w : World) : Prop := True/'
try $T1 "A122's proximity dropped: the death conditions nothing" 's/^def a122_death_to_rebirth (w : World) : Prop := .*/def a122_death_to_rebirth (w : World) : Prop := True ∧ w.patisandhi w.upapatti/'
try $T1 "A122's rebirth-linking dropped: what the death conditions need not be a rebirth" 's/^def a122_death_to_rebirth (w : World) : Prop := .*/def a122_death_to_rebirth (w : World) : Prop := w.prox w.cuti w.upapatti ∧ True/'
try $T1 "A123 dropped: consciousness without a citta" 's/^def a123_vinnana_is_citta (w : World) : Prop := .*/def a123_vinnana_is_citta (w : World) : Prop := True/'
try $T1 "the view without consciousness (the commentaries' report removed)" 's/^def with_mind (w : World) : Prop := .*/def with_mind (w : World) : Prop := True/'
try $T1 "the view with a rebirth-linking inside it (the later holders')" 's/  ∃ t, w.cuti < t ∧ w.antara t ∧ ∀ s, w.cuti < s → s ≤ t → ¬ w.patisandhi s/  ∃ t, w.cuti < t ∧ w.antara t/'
echo "all breaks fail as required"
