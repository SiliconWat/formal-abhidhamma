#!/bin/sh
# Kv 22.10 known-answer control — the first /prove run (PREREG pushed 2026-10-13T20:04:02Z, OTS). Every registered
# statement must appear VERBATIM in Khanika.lean (a moved statement is a new run), the theorems must CHECK, and each
# deliberate break must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
python3 - <<'PY' || exit 1
import re
reg = open("PREREG.md", encoding="utf-8").read().split("```lean", 1)[1].split("```", 1)[0]
src = open("Khanika.lean", encoding="utf-8").read()
heads = re.findall(r"(theorem [\s\S]*?:= by)", reg)
moved = [h.split("\n")[0] for h in heads if h not in src]
if not heads or moved:
    print("STATEMENT MOVED", moved or "no registered theorem found"); raise SystemExit(1)
print(f"VERBATIM  {len(heads)} registered statements unchanged")
PY
if $LEAN Khanika.lean; then echo "PASS  t1_aligned_view_refuted · t2_counter_does_not_follow · t3_duration_view_open"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Khanika.lean "$T/"; sed -i.orig "$2" "$T/Khanika.lean"
  if cmp -s "$T/Khanika.lean" "$T/Khanika.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Khanika.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "A87 weakened: the base merely not born AFTER (≤), so co-nascence is allowed" 's/(a87_purejata : ∀ e c, w.pre e c → w.birth e < w.birth c)/(a87_purejata : ∀ e c, w.pre e c → w.birth e ≤ w.birth c)/'
try "A98 dropped: the base need not be present when the consciousness arises" 's/(a98_atthi : ∀ e c, w.pre e c → w.present e (w.birth c))/(a98_atthi : True)/'
try "A115 dropped: no consciousness need ever arise" 's/(a115_occurs : ∃ e c, w.pre e c)/(a115_occurs : True)/'
try "A117 weakened: a mind-moment of ONE sub-moment" 's/(a117_two_submoments : 2 ≤ k)/(a117_two_submoments : 1 ≤ k)/'
try "T2's world made permanent: the counter's countermodel must carry a non-permanent dhamma" 's/def shortLife : Bool → Int → Prop := fun d t => (if d then 1 else 0) ≤ t ∧ t ≤ 1/def shortLife : Bool → Int → Prop := fun _ _ => True/'
echo "all breaks fail as required"
