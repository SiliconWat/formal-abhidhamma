#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Budget.lean; then echo "PASS  d1_life_left_decides (BY CONSTRUCTION) · d1_both_readings_admit_very_great · d2_depth_monotone · d3_budget_in_picoseconds · d4_relay_cannot_reach_the_heart"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Budget.lean "$T/"; sed -i.orig "$2" "$T/Budget.lean"
  if cmp -s "$T/Budget.lean" "$T/Budget.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Budget.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "D1 with the 16-holders entering after one past moment" 's/gradeL 16 0 = .veryGreat/gradeL 16 1 = .veryGreat/'
try "D2 with a non-monotone ladder (late objects ranked very great)" 's/else if p + 8 ≤ L then .slight/else if p + 8 ≤ L then .veryGreat/'
try "D3 with the ṭīkā's slower count (τ ≤ 2×10⁷ fs)"       's/(h : τ ≤ 200) : 15 \* τ ≤ 3000/(h : τ ≤ 20000000) : 15 * τ ≤ 3000/'
try "D4 with a 1 m relay budget at a slow snap (τ ≤ 2×10⁵ fs)" 's/(h1 : τfs ≤ 200)/(h1 : τfs ≤ 200000)/'
echo "all breaks fail as required"
