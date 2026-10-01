#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Shape.lean; then echo "PASS  d2_prenascence_rises · d2_postnascence_rises · d4_link_within_a_sort"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Shape.lean "$T/"; sed -i.orig "$2" "$T/Shape.lean"
  if cmp -s "$T/Shape.lean" "$T/Shape.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Shape.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "D2 with post-nascence at the same exercise time (the synchronic cycle)" 's/(later : c.t < body.t)/(later : c.t ≤ body.t)/'
try "D4 with no material event in the gap (N may be 0)"                    's/(hN : 1 ≤ N)/(hN : 0 ≤ N)/'
echo "all breaks fail as required"
