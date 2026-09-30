#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN SunMoon2.lean; then echo "PASS  d1 · d2 · d3 · d4_shadow_moves_west + non-vacuity"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp SunMoon2.lean "$T/"; sed -i.orig "$2" "$T/SunMoon2.lean"
  if cmp -s "$T/SunMoon2.lean" "$T/SunMoon2.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/SunMoon2.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "d3 with sizes swapped (moon 50, sun 49)"         's/: 49 \* hs < 50 \* hm := by omega/: 50 * hs < 49 * hm := by omega/'
try "d4 with the sun moving EAST (v < 0 allowed)"     's/(hv : 0 < v)/(hv : v < 0)/'
try "d4 with the occulter NOT moving with the sun"    's/(sun (t + 1) + c + g0) < (sun t + c + g0)/(sun (t + 1) + c + g0 + 2 * v) < (sun t + c + g0)/'
echo "all breaks fail as required"
