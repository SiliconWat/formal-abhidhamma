#!/bin/sh
# Capture step 2: the mātikā and the 24 conditions as generated data (scripts/matika.py). The checks must PASS — the texts'
# own counts (22 · 100 · 42 · 24; 24 samantapaṭṭhāna) — and each deliberate break must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Matika.lean; then echo "PASS  22 triads of three · 100 Abhidhamma dyads · 42 Suttanta dyads · numbered in order · 24 conditions · 6 methods × 4 directions = 24 samantapaṭṭhāna"; else echo "FAIL"; exit 1; fi
if $LEAN Relata.lean; then echo "PASS  relata: every condition defined · the open-side rule · the Saṅgaha's 6·5·1·1·2·9 · every condition read in detail · the full read moves only result · 22 placements without concepts under both readings · the two concept placements by reading · the collective commentary unseats predominance"; else echo "FAIL relata"; exit 1; fi
try() { F="${3:-Matika.lean}"; T=$(mktemp -d); cp "$F" "$T/"; sed -i.orig "$2" "$T/$F"
  if cmp -s "$T/$F" "$T/$F.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/$F" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "a triad dropped (the 22nd)" '/^  ⟨22, "Tikamātikā"/d'
try "a dyad given a third member" 's/^  ⟨1, "Hetugocchakaṃ", \[\(.*\)\]⟩/  ⟨1, "Hetugocchakaṃ", [\1, "x"]⟩/'
try "a Suttanta dyad dropped" '/^  ⟨142, /d'
try "a condition dropped (the last)" 's/, "avigatapaccayo"\]/]/'
try "a direction dropped from the generator" 's/def directions : List Direction := \[.anuloma, .paccaniya, .anulomaPaccaniya, .paccaniyanuloma\]/def directions : List Direction := [.anuloma, .paccaniya, .anulomaPaccaniya]/'
try "relata: §428's result clause removed" '/, 6093, .detailFull⟩/d' Relata.lean
try "relata: hetu's conditioned matter dropped" 's/⟨.hetu, \[.nama\], \[.nama, .rupa\]/⟨.hetu, [.nama], [.nama]/' Relata.lean
try "relata: the Saṅgaha's pre-nascence placed mind → mind" 's/  | .purejata => .rupaToNama/  | .purejata => .namaToNama/' Relata.lean
try "relata: the person read as a designation given matter instead" 's/⟨.upanissaya, \[.pannatti\], \[\], false, true, false, .unstated, 165, .personDesignation⟩/⟨.upanissaya, [.nama, .rupa], [], false, true, false, .unstated, 165, .personDesignation⟩/' Relata.lean
try "relata: the collective commentary's predominance concept removed" '/, 7817, .commentaryCollective⟩/{/⟨.adhipati/d;}' Relata.lean
try "relata: the commentary's 'some concept' on decisive support removed" 's/⟨.upanissaya, \[.pannatti\], \[.nama\], false, false, false, .unstated, 8057, .commentary⟩/⟨.upanissaya, [.nama], [.nama], false, false, false, .unstated, 8057, .commentary⟩/' Relata.lean
try "relata: decisive support's matter removed (niddesa and detailed section)" '/⟨.upanissaya, \[.rupa\], \[\]/d; s/⟨.upanissaya, \[.nama, .rupa\], \[.nama\]/⟨.upanissaya, [.nama], [.nama]/' Relata.lean
try "relata: a detailed-section proximity clause given matter" 's/⟨.anantara, \[.nama\], \[.nama\], false, false, false, .unstated, 5685/⟨.anantara, [.nama, .rupa], [.nama], false, false, false, .unstated, 5685/' Relata.lean
try "relata: proximity's open 'whatever dhammas' marked definite" 's/⟨.anantara, \[.nama, .rupa\], \[.nama\], true, false, true, .ceased, 97/⟨.anantara, [.nama, .rupa], [.nama], false, false, true, .ceased, 97/' Relata.lean
try "relata: the commentary's concept on the object removed" 's/⟨.arammana, \[.pannatti\], \[.nama\], false, false, false, .unstated, 7889/⟨.arammana, [.nama], [.nama], false, false, false, .unstated, 7889/' Relata.lean
try "relata: a full-read clause filed under the open-side rule" 's/, 6093, .detailFull⟩/, 6093, .detail⟩/' Relata.lean
try "relata: a full-read association clause given matter (it must move a placement)" 's/⟨.sampayutta, \[.nama\], \[.nama\], false, false, false, .unstated, 6237, .detailFull⟩/⟨.sampayutta, [.nama], [.nama, .rupa], false, false, false, .unstated, 6237, .detailFull⟩/' Relata.lean
echo "all breaks fail as required"
