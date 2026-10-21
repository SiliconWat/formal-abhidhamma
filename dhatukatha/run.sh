#!/bin/sh
# Capture, the Dhātukathā (first naya, sections 1–3): the CST's stated counts are GENERATED data (dhatukatha.py); the manual's classification (Check.lean) must REPRODUCE every one of them,
# and each deliberate break must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
command -v "$LEAN" >/dev/null 2>&1 || LEAN="$HOME/.elan/bin/lean"
B=$(mktemp -d); trap 'rm -rf "$B"' EXIT
# the generator reads the CST (private tipitaka-mcp): in CI, where neither exists, the committed data is compiled and checked as it stands
if [ -d ../../tipitaka-mcp ]; then python3 dhatukatha.py --check || { echo "FAIL  the generated files are stale"; exit 1; }; else echo "NOTE  CST not available here: the generated data is not re-read"; fi
$LEAN -o "$B/Dhatukatha.olean" Dhatukatha.lean || { echo "FAIL  Dhatukatha.lean"; exit 1; }
if LEAN_PATH="$B" $LEAN Check.lean; then echo "PASS  the manual's classification (22 kinds of dhamma into 5 aggregates, 12 bases, 18 elements) reproduces all 175 stated counts of sections 1–6 (160 of them without any item tuned to the counts), included and not"; else echo "FAIL  Check.lean"; exit 1; fi
try() { F="${3:-Check.lean}"; T=$(mktemp -d); cp Dhatukatha.lean Check.lean "$T/"; sed -i.orig "$2" "$T/$F"
  if cmp -s "$T/$F" "$T/$F.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  ( cd "$T" && $LEAN -o Dhatukatha.olean Dhatukatha.lean >/dev/null 2>&1 && LEAN_PATH="$T" $LEAN Check.lean >/dev/null 2>&1 ) && { echo "BLIND  $1 — still checks"; exit 1; } || echo "FAILS as required  $1"; rm -rf "$T"; }
try "feeling filed under the form aggregate" 's/  | .vedana => some 1 | .sanna => some 2/  | .vedana => some 0 | .sanna => some 2/'
try "the mind-consciousness element merged into the mind-element" 's/| .manoD => 15 | .manoV => 16/| .manoD => 15 | .manoV => 15/'
try "nibbāna filed under the mind base" 's/  | .subtle | .vedana | .sanna | .sankhara | .nibbana => 11/  | .subtle | .vedana | .sanna | .sankhara => 11\n  | .nibbana => 10/'
try "the subtle matter taken out of the form aggregate" 's/  | .nibbana => none/  | .nibbana | .subtle => none/'
try "cessation (the third truth) given no dhamma" 's/| "sacca_nirodha" => \[.nibbana\]/| "sacca_nirodha" => []/'
try "the life faculty given only its material half" 's/| "ind8" => \[.subtle, .sankhara\]/| "ind8" => [.subtle]/'
try "name-and-form without form" 's/| "namarupa" => \[.vedana, .sanna, .sankhara\] ++ allRupa/| "namarupa" => [.vedana, .sanna, .sankhara]/'
try "a stated count tampered with (rūpakkhandha in 10 bases, not 11)" 's/(1, 11, 11), (4, 1, 7)/(1, 10, 11), (4, 2, 7)/' Dhatukatha.lean
echo "all breaks fail as required"
