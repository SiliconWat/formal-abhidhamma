#!/bin/sh
# Capture step 2: the mātikā and the 24 conditions as generated data (scripts/matika.py). The checks must PASS — the texts'
# own counts (22 · 100 · 42 · 24; 24 samantapaṭṭhāna) — and each deliberate break must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Matika.lean; then echo "PASS  22 triads of three · 100 Abhidhamma dyads · 42 Suttanta dyads · numbered in order · 24 conditions · 6 methods × 4 directions = 24 samantapaṭṭhāna"; else echo "FAIL"; exit 1; fi
if $LEAN Relata.lean; then echo "PASS  relata: every condition defined · the Saṅgaha's 6·5·1·1·2·9 · the niddesa gives 23 of 24 placements (vipāka differs) · with the detailed section, all 24"; else echo "FAIL relata"; exit 1; fi
try() { F="${3:-Matika.lean}"; T=$(mktemp -d); cp "$F" "$T/"; sed -i.orig "$2" "$T/$F"
  if cmp -s "$T/$F" "$T/$F.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/$F" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "a triad dropped (the 22nd)" '/^  ⟨22, "Tikamātikā"/d'
try "a dyad given a third member" 's/^  ⟨1, "Hetugocchakaṃ", \[\(.*\)\]⟩/  ⟨1, "Hetugocchakaṃ", [\1, "x"]⟩/'
try "a Suttanta dyad dropped" '/^  ⟨142, /d'
try "a condition dropped (the last)" 's/, "avigatapaccayo"\]/]/'
try "a direction dropped from the generator" 's/def directions : List Direction := \[.anuloma, .paccaniya, .anulomaPaccaniya, .paccaniyanuloma\]/def directions : List Direction := [.anuloma, .paccaniya, .anulomaPaccaniya]/'
try "relata: the detailed section's vipāka clause removed" '/⟨.vipaka, \[.nama\], \[.nama, .rupa\], .co, 6093, .panhavara⟩/d' Relata.lean
try "relata: hetu's conditioned matter dropped" 's/⟨.hetu, \[.nama\], \[.nama, .rupa\]/⟨.hetu, [.nama], [.nama]/' Relata.lean
try "relata: the Saṅgaha's pre-nascence placed mind → mind" 's/  | .purejata => .rupaToNama/  | .purejata => .namaToNama/' Relata.lean
try "relata: decisive support's matter and person clauses removed" '/⟨.upanissaya, \[.rupa\]/d; /⟨.upanissaya, \[.pannatti\]/d' Relata.lean
echo "all breaks fail as required"
