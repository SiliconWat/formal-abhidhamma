#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Gap.lean; then echo "PASS  d1_count_is_not_the_day + d1_model · d3_oxygen_budget · d4_stationary_state_cannot_keep_a_schedule"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Gap.lean "$T/"; sed -i.orig "$2" "$T/Gap.lean"
  if cmp -s "$T/Gap.lean" "$T/Gap.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Gap.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "D1 with no day-gap across cessation (Δ may be 1)"   's/(wide : 1 < Δ)/(wide : 1 ≤ Δ)/'
try "D3 with twice the oxygen store"                     's/(store : 250 \* t ≤ 2000)/(store : 250 * t ≤ 4000)/'
try "D4 with a body that changes through the gap"        's/(stat : f s₀ = s₀)/(stat : True)/'
echo "all breaks fail as required"
