#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN RateOfMind.lean; then echo "PASS  d2_moment_bound · d5_spacing · d9_citta_faster · d8_serial + non-vacuity"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp RateOfMind.lean "$T/"; sed -i.orig "$2" "$T/RateOfMind.lean"
  if cmp -s "$T/RateOfMind.lean" "$T/RateOfMind.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/RateOfMind.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "d2 with the ṭīkā's weaker rate (≥ 2·10¹⁰)"   's/(many : 2000000000000 ≤ N)/(many : 20000000000 ≤ N)/'
try "d5 with no javana required (n ≥ 0)"          's/(javana : 7 ≤ n)/(javana : 0 ≤ n)/'
try "d9 with a zero-length citta allowed"         's/(h : 0 < τ) : τ < 17/(h : 0 ≤ τ) : τ < 17/'
echo "all breaks fail as required"
