#!/bin/sh
# Capture step 2: the mātikā and the 24 conditions as generated data (scripts/matika.py). The checks must PASS — the texts'
# own counts (22 · 100 · 42 · 24; 24 samantapaṭṭhāna) — and each deliberate break must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Matika.lean; then echo "PASS  22 triads of three · 100 Abhidhamma dyads · 42 Suttanta dyads · numbered in order · 24 conditions · 6 methods × 4 directions = 24 samantapaṭṭhāna"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Matika.lean "$T/"; sed -i.orig "$2" "$T/Matika.lean"
  if cmp -s "$T/Matika.lean" "$T/Matika.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Matika.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "a triad dropped (the 22nd)" '/^  ⟨22, "Tikamātikā"/d'
try "a dyad given a third member" 's/^  ⟨1, "Hetugocchakaṃ", \[\(.*\)\]⟩/  ⟨1, "Hetugocchakaṃ", [\1, "x"]⟩/'
try "a Suttanta dyad dropped" '/^  ⟨142, /d'
try "a condition dropped (the last)" 's/, "avigatapaccayo"\]/]/'
try "a direction dropped from the generator" 's/def directions : List Direction := \[.anuloma, .paccaniya, .anulomaPaccaniya, .paccaniyanuloma\]/def directions : List Direction := [.anuloma, .paccaniya, .anulomaPaccaniya]/'
echo "all breaks fail as required"
