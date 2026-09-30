#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN SunMoon3.lean; then echo "PASS  d4 · d5 · d6 · d6b · d7b · meru + non-vacuity"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp SunMoon3.lean "$T/"; sed -i.orig "$2" "$T/SunMoon3.lean"
  if cmp -s "$T/SunMoon3.lean" "$T/SunMoon3.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/SunMoon3.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "d4 with sunlight allowed edge-on (s = 0)"          's/(hs : 0 < s)/(hs : 0 ≤ s)/'
try "d5 with the sun allowed BELOW the moon"            's/(h1 : hm ≤ hs) :/(h1 : hs ≤ hm) :/'
try "d5 with the discs swapped (moon 50, sun 49)"       's/100 \* (2401 \* (hs \* hs)) := by/100 * (2304 * (hs * hs)) := by/'
try "d6 with the lower path allowed (r ≥ 40,000)"       's/(h0 : 42000 ≤ r) : 50/(h0 : 40000 ≤ r) : 50/'
try "d7b with Rāhu allowed far below (Δ ≤ 10,000)"      's/(h1 : Δ ≤ 100)/(h1 : Δ ≤ 10000)/'
try "meru with a disc allowed above the summit"         's/(b : h2 ≤ 84000)/(b : h2 ≤ 90000)/'
echo "all breaks fail as required"
