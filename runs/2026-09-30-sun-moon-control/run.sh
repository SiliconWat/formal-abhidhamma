#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN SunMoon.lean; then echo "PASS  d1_ratio_below_two · d2_disc_too_small · d3_never_total + non-vacuity"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp SunMoon.lean "$T/"; sed -i.orig "$2" "$T/SunMoon.lean"
  if cmp -s "$T/SunMoon.lean" "$T/SunMoon.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/SunMoon.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "D1 without the stack bound (sun anywhere above)"  's/theorem d1_ratio_below_two (hm hs : Nat) (h0 : 42000 ≤ hm) (h1 : hs ≤ hm + 100)/theorem d1_ratio_below_two (hm hs : Nat) (h0 : 42000 ≤ hm) (h1 : hs ≤ hm * 400)/'
try "D2 with the disc at 4,000 yojanas"               's/theorem d2_disc_too_small (hs : Nat) (h0 : 42000 ≤ hs)/theorem d2_disc_too_small (hs : Nat) (h0 : 4000 ≤ hs)/'
try "D3 with the discs' sizes swapped (moon 50, sun 49)" 's/: 49 \* hs < 50 \* hm := by/: 50 * hs < 49 * hm := by/'
echo "all breaks fail as required"
