#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN ReportedView.lean; then echo "PASS  instant_contradicts_propagation · d3_bound · d3_moon_unseen · d9_rumble + non-vacuity"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp ReportedView.lean "$T/"; sed -i.orig "$2" "$T/ReportedView.lean"
  if cmp -s "$T/ReportedView.lean" "$T/ReportedView.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/ReportedView.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "instant with a zero distance allowed (d ≥ 0)"    's/(hd : 0 < d) : False/(hd : 0 ≤ d) : False/'
try "d3 with a 2-second reaction time allowed"         's/(fits : 17 \* tau ≤ 250) : d < 75000/(fits : 17 * tau ≤ 2000) : d < 75000/'
try "d9 with a 100 m channel allowed"                  's/(h : 1000 ≤ spread) : 2900 < dur/(h : 100 ≤ spread) : 2900 < dur/'
echo "all breaks fail as required"
