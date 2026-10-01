#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN OutsideWorld.lean; then echo "PASS  d0_no_first_member + d0_model · d1_chsh_local_bound · d3ii_crossing_beams (conditional) · d5b_ladder · d5_light_bounds_the_moment"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp OutsideWorld.lean "$T/"; sed -i.orig "$2" "$T/OutsideWorld.lean"
  if cmp -s "$T/OutsideWorld.lean" "$T/OutsideWorld.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/OutsideWorld.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "D0 with a parent that may share the birth (≤ for <)"    's/(h : ∀ k, b (parent k) < b k)/(h : ∀ k, b (parent k) ≤ b k)/'
try "D1 with the PR-box sign (non-local correlations)"       's/- s a'"'"' \* s b'"'"' = 2 ∨/+ s a'"'"' * s b'"'"' = 2 ∨/'
try "D5b with the agent's arithmetic (36³·36·7³ = 16,003,008)" 's/36 ^ 3 \* 7 ^ 3 = 16003008/36 ^ 3 * 36 * 7 ^ 3 = 16003008/'
try "D5 with a production that may wait four sub-moments"     's/(sub : τ ≤ 3 \* τg)/(sub : τ ≤ 4 * τg)/'
echo "all breaks fail as required"
