#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Breath.lean; then echo "PASS  d1_swoon_breathless_sleep_breathes + d1_model · d2_broad_reading_contradicts · d3_not_a_function_of_type · d5_seven_days_needs_nonoxidative_heat"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Breath.lean "$T/"; sed -i.orig "$2" "$T/Breath.lean"
  if cmp -s "$T/Breath.lean" "$T/Breath.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Breath.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "A114 without the swoon (the non-percipient reading only)" 's/def L : List St := \[.womb, .submerged, .swoon,/def L : List St := [.womb, .submerged,/'
try "D2 without the swoon's javanas"                          's/(javana_runs : ∃ c, occurs c ∧ MP c)/(javana_runs : True)/'
try "D3 with sleep's citta types not found in a swoon"         's/(hsub : ∀ t, t ∈ types .asleep → t ∈ types .swoon)/(hsub : True)/'
try "D5 with a non-oxidative heat term of 80 W (kamma-born fire)" 's/(pk : Pk = 0)/(pk : Pk = 80)/'
echo "all breaks fail as required"
