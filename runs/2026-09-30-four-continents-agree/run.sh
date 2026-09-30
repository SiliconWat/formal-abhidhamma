#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN FourContinents.lean; then echo "PASS  d2_table_forces_equal_days · d3_sunrise_north · d6b_ring_too_wide + non-vacuity"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp FourContinents.lean "$T/"; sed -i.orig "$2" "$T/FourContinents.lean"
  if cmp -s "$T/FourContinents.lean" "$T/FourContinents.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/FourContinents.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "d2 with one noon NOT the day's midpoint"        's/(m₂ : g₂ = g₃) :/(m₂ : g₂ ≤ g₃) :/'
try "d3 with the observer AT Meru (R_o = 0 allowed)" 's/(hRo : 0 < Ro)/(hRo : 0 ≤ Ro)/'
try "d6b with the June path at the ring's own radius" 's/> 727725 ^ 2/> 836707 ^ 2/'
echo "all breaks fail as required"
