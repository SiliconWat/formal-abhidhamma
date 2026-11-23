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
# the sixth method (association), pre-registered 2026-11-22: the registered rule's tally, held as a theorem (a FINDING, 17 of 55)
if [ -d ../../tipitaka-mcp ]; then python3 sampayoga.py --check || { echo "FAIL  Sampayoga data stale"; exit 1; }; fi
$LEAN -o "$B/Sampayoga.olean" Sampayoga.lean || { echo "FAIL  Sampayoga.lean"; exit 1; }
LEAN_PATH="$B" $LEAN -o "$B/Check.olean" Check.lean >/dev/null 2>&1 || { echo "FAIL  Check.lean (as a module)"; exit 1; }
if LEAN_PATH="$B" $LEAN CheckSampayoga.lean >/dev/null; then echo "PASS  the sixth method: the registered association rule's tally holds (17 of 55 unseen rows — a finding, runs/2026-11-22-dhatukatha-association)"; else echo "FAIL  CheckSampayoga.lean"; exit 1; fi
# run 2 (pre-registered 2026-11-22, 49ea7a4): A130/A131 with the Dhammasaṅgaṇī's element ranges reproduce all 38 in-scope rows; each break must fail
if [ -d ../../tipitaka-mcp ]; then python3 ranges.py --check || { echo "FAIL  Ranges.lean stale"; exit 1; }; fi
$LEAN -o "$B/Ranges.olean" Ranges.lean || { echo "FAIL  Ranges.lean"; exit 1; }
if LEAN_PATH="$B" $LEAN CheckSampayoga2.lean >/dev/null; then echo "PASS  the sixth method: A130/A131 with the Dhammasaṅgaṇī's ranges reproduce all 38 in-scope rows (run dhatukatha-association-2)"; else echo "FAIL  CheckSampayoga2.lean"; exit 1; fi
ctl() { T=$(mktemp -d); cp $2 ../lean-toolchain "$T/"; ( cd "$T" && eval "$3" ) && echo "PASS  harness control ($1): the unbroken copy checks under its chain" || { echo "HARNESS BLIND  $1"; exit 1; }; rm -rf "$T"; }
ctl "run 2" "Sampayoga.lean Ranges.lean CheckSampayoga2.lean" '$LEAN -o Sampayoga.olean Sampayoga.lean >/dev/null 2>&1 && $LEAN -o Ranges.olean Ranges.lean >/dev/null 2>&1 && LEAN_PATH="$PWD" $LEAN CheckSampayoga2.lean >/dev/null 2>&1'
ctl "run 3" "Sampayoga.lean SampayogaMatrix.lean Classes.lean CheckSampayoga3.lean" '$LEAN -o Sampayoga.olean Sampayoga.lean >/dev/null 2>&1 && LEAN_PATH="$PWD" $LEAN -o SampayogaMatrix.olean SampayogaMatrix.lean >/dev/null 2>&1 && $LEAN -o Classes.olean Classes.lean >/dev/null 2>&1 && LEAN_PATH="$PWD" $LEAN CheckSampayoga3.lean >/dev/null 2>&1'
brk2() { T=$(mktemp -d); cp Sampayoga.lean Ranges.lean CheckSampayoga2.lean ../lean-toolchain "$T/"; sed -i.orig "$2" "$T/$3"
  if cmp -s "$T/$3" "$T/$3.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  ( cd "$T" && $LEAN -o Sampayoga.olean Sampayoga.lean >/dev/null 2>&1 && $LEAN -o Ranges.olean Ranges.lean >/dev/null 2>&1 && LEAN_PATH="$T" $LEAN CheckSampayoga2.lean >/dev/null 2>&1 ) && { echo "BLIND  $1 — still checks"; exit 1; } || echo "FAILS as required  $1"; rm -rf "$T"; }
brk2 "every formation given all seven elements (the first run's uniform range)" 's/| (k, E) =>/| (k, _E) => let E := all7;/' CheckSampayoga2.lean
brk2 "a formation's own aggregate not partly associated" 's/(if k == .formation then 1 else 0, 1, 1)/(0, 1, 1)/' CheckSampayoga2.lean
brk2 "consciousness not dissociated from the other consciousnesses" 's/(1, 10, 10 + 7 - e)/(1, 10, 10)/' CheckSampayoga2.lean
brk2 "the Dhammasaṅgaṇī's range for concentration widened to the mind-element" 's/("samādhindriyaṃ", \[6\])/("samādhindriyaṃ", [5, 6])/' Ranges.lean
# run 3 (pre-registered 2026-11-22, 02ac634), BLIND: the Dhammasaṅgaṇī's class definitions and lists predict all 8 unseen matrix rows; each break must fail
if [ -d ../../tipitaka-mcp ]; then python3 classes.py --check && python3 sampayoga_matrix.py --check >/dev/null || { echo "FAIL  Classes / SampayogaMatrix stale"; exit 1; }; fi
LEAN_PATH="$B" $LEAN -o "$B/SampayogaMatrix.olean" SampayogaMatrix.lean || { echo "FAIL  SampayogaMatrix.lean"; exit 1; }
$LEAN -o "$B/Classes.olean" Classes.lean || { echo "FAIL  Classes.lean"; exit 1; }
if LEAN_PATH="$B" $LEAN CheckSampayoga3.lean >/dev/null; then echo "PASS  the sixth method's matrix, BLIND: all 8 unseen rows predicted from the Dhammasaṅgaṇī (run dhatukatha-association-3)"; else echo "FAIL  CheckSampayoga3.lean"; exit 1; fi
brk3() { T=$(mktemp -d); cp Sampayoga.lean SampayogaMatrix.lean Classes.lean CheckSampayoga3.lean ../lean-toolchain "$T/"; sed -i.orig "$2" "$T/$3"
  if cmp -s "$T/$3" "$T/$3.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  ( cd "$T" && $LEAN -o Sampayoga.olean Sampayoga.lean >/dev/null 2>&1 && LEAN_PATH="$T" $LEAN -o SampayogaMatrix.olean SampayogaMatrix.lean >/dev/null 2>&1 && $LEAN -o Classes.olean Classes.lean >/dev/null 2>&1 && LEAN_PATH="$T" $LEAN CheckSampayoga3.lean >/dev/null 2>&1 ) && { echo "BLIND  $1 — still checks"; exit 1; } || echo "FAILS as required  $1"; rm -rf "$T"; }
brk3 "the resultants given one element, not seven" 's/("vipaka", "allFour", \[0, 1, 2, 3, 4, 5, 6\])/("vipaka", "allFour", [6])/' Classes.lean
brk3 "rapture set aside read as a feeling set aside" 's/("piti_sahagata", "formationAside"/("piti_sahagata", "feelingAside"/' Classes.lean
brk3 "a feeling set aside not partly associated (dhamma base and element)" 's/| ("feelingAside", E)   => ((1, 0, 0), (0, 1, 1)/| ("feelingAside", E)   => ((1, 0, 0), (0, 0, 0)/' CheckSampayoga3.lean
brk3 "equanimity given body-consciousness too" 's/("upekkha_sahagata", "feelingAside", \[0, 1, 2, 3, 5, 6\])/("upekkha_sahagata", "feelingAside", [0, 1, 2, 3, 4, 5, 6])/' Classes.lean
# run 4 (pre-registered 2026-11-22, 5e11514): run 3's rule over every §5 class a stated criterion admits (classes4.py) — 5 blind class-rows, 11 seen; each break must fail
if [ -d ../../tipitaka-mcp ]; then python3 classes4.py --check && python3 sampayoga_matrix4.py --check >/dev/null || { echo "FAIL  Classes4 / SampayogaMatrix4 stale"; exit 1; }; fi
LEAN_PATH="$B" $LEAN -o "$B/SampayogaMatrix4.olean" SampayogaMatrix4.lean || { echo "FAIL  SampayogaMatrix4.lean"; exit 1; }
$LEAN -o "$B/Classes4.olean" Classes4.lean || { echo "FAIL  Classes4.lean"; exit 1; }
if LEAN_PATH="$B" $LEAN CheckSampayoga4.lean >/dev/null; then echo "PASS  the sixth method's matrix, by a stated scope: all 5 registered-blind class-rows and the 11 seen reproduced — a consistency check, not a blind test (run dhatukatha-association-4, REFUTER)"; else echo "FAIL  CheckSampayoga4.lean"; exit 1; fi
ctl "run 4" "Sampayoga.lean SampayogaMatrix4.lean Classes4.lean CheckSampayoga4.lean" '$LEAN -o Sampayoga.olean Sampayoga.lean >/dev/null 2>&1 && LEAN_PATH="$PWD" $LEAN -o SampayogaMatrix4.olean SampayogaMatrix4.lean >/dev/null 2>&1 && $LEAN -o Classes4.olean Classes4.lean >/dev/null 2>&1 && LEAN_PATH="$PWD" $LEAN CheckSampayoga4.lean >/dev/null 2>&1'
brk4() { T=$(mktemp -d); cp Sampayoga.lean SampayogaMatrix4.lean Classes4.lean CheckSampayoga4.lean ../lean-toolchain "$T/"; sed -i.orig "$2" "$T/$3"
  if cmp -s "$T/$3" "$T/$3.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  ( cd "$T" && $LEAN -o Sampayoga.olean Sampayoga.lean >/dev/null 2>&1 && LEAN_PATH="$T" $LEAN -o SampayogaMatrix4.olean SampayogaMatrix4.lean >/dev/null 2>&1 && $LEAN -o Classes4.olean Classes4.lean >/dev/null 2>&1 && LEAN_PATH="$T" $LEAN CheckSampayoga4.lean >/dev/null 2>&1 ) && { echo "BLIND  $1 — still checks"; exit 1; } || echo "FAILS as required  $1"; rm -rf "$T"; }
brk4 "savitakkasavicārā given mind-consciousness only (vitakka's mind-element dropped)" 's/("savitakkasavicara", "formationAside", \[5, 6\])/("savitakkasavicara", "formationAside", [6])/' Classes4.lean
brk4 "savitakkasavicārā read as all four (its set-aside ignored)" 's/("savitakkasavicara", "formationAside"/("savitakkasavicara", "allFour"/' Classes4.lean
brk4 "hīnā given every consciousness element" 's/("hina", "allFour", \[6\])/("hina", "allFour", [0, 1, 2, 3, 4, 5, 6])/' Classes4.lean
brk4 "A132(d) dropped: an all-four class partly associated, as a single dhamma is" 's/| ("allFour", E)        => ((0, 0, 0), (0, 0, 0)/| ("allFour", E)        => ((0, 0, 0), (0, 1, 1)/' CheckSampayoga4.lean
brk4 "a class tied to the wrong §5 line (hīnā on L1381) — after the refuter, finding 4" 's/("hina", 1393)/("hina", 1381)/' Classes4.lean
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
