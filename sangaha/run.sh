#!/bin/sh
# Rung 2: the 89/121 at layer L2. The checks must PASS; each deliberate break must FAIL.
# Exit 0 only if all hold. Needs Lean 4 (LEAN=path/to/lean to override).
set -u
cd "$(dirname "$0")"
LEAN="${LEAN:-lean}"; export LEAN_PATH="../control:."
build() { for f in Citta Rules AnswerKey; do $LEAN -o $f.olean $f.lean || return 1; done; }
( cd ../control && $LEAN -o Cetasika.olean Cetasika.lean ) || exit 1
build || { echo "build failed"; exit 1; }
if $LEAN Check.lean; then echo "PASS  12 theorems: 89 · 121 · distinct · both profiles · per-factor counts and absences · ch. 3 feelings and roots · the keci reading"
else echo "FAIL  the checks"; exit 1; fi
if $LEAN Canon.lean; then echo "PASS  4 theorems (rung 3): canon names 29 · all 29 inside the Saṅgaha's set · L2 adds exactly the nine 'ye vā pana' · 38"
else echo "FAIL  the canon checks"; exit 1; fi

# run cittuppada-against-the-manual (pre-registered 2026-11-22, ea0376d): the 23 fully written lists against the Saṅgaha
if [ -d ../../tipitaka-mcp ]; then python3 ../canon/allcanon.py --check || { echo "FAIL  CanonAll.lean stale"; exit 1; }; fi
$LEAN -o CanonAll.olean CanonAll.lean || { echo "FAIL  CanonAll.lean"; exit 1; }
if $LEAN CheckCanonAll.lean >/dev/null; then echo "PASS  3 theorems: all 23 written lists inside the Saṅgaha's set · the Saṅgaha adds only where the list is open · the first-citta control"
else echo "FAIL  CheckCanonAll.lean"; exit 1; fi
B4=$(mktemp -d)
brk4() { cp Citta.lean Rules.lean CanonAll.lean CheckCanonAll.lean "$B4/"; sed -i.orig "$2" "$B4/$3"
  if cmp -s "$B4/$3" "$B4/$3.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  ( cd "$B4" && $LEAN -o Citta.olean Citta.lean >/dev/null 2>&1 && $LEAN -o Rules.olean Rules.lean >/dev/null 2>&1 && $LEAN -o CanonAll.olean CanonAll.lean >/dev/null 2>&1 && $LEAN CheckCanonAll.lean >/dev/null 2>&1 ) && { echo "BLIND  $1 — still checks"; exit 1; } || echo "FAILS as required  $1"; }
export LEAN_PATH="../control:$B4"
brk4 "conceit added to the first wholesome list (a factor the manual denies there)" 's/⟨1569, \(.*\), \[/⟨1569, \1, [mana, /' CanonAll.lean
brk4 "the first wholesome list's open clause removed" 's/\(⟨1569, .*\), true, 0⟩/\1, false, 0⟩/' CanonAll.lean
brk4 "the doubt citta built with greed as its root" 's/\(⟨3721, { jati := .akusala, bhumi := .kama, vedana := .upekkha, root := \).mohaDoubt/\1.lobha/' CanonAll.lean
export LEAN_PATH="../control:."; rm -rf "$B4"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
breaks=0
try() { # $1 label, $2 file, $3 sed expression
  cp Citta.lean Rules.lean AnswerKey.lean Check.lean Canon.lean "$T/"
  sed -i.orig "$3" "$T/$2"
  if cmp -s "$T/$2" "$T/$2.orig"; then echo "BREAK NOT APPLIED  $1 — the sed matched nothing"; exit 1; fi
  if ( cd "$T" && LEAN_PATH="$OLDPWD/../control:." && export LEAN_PATH && for f in Citta Rules AnswerKey; do $LEAN -o $f.olean $f.lean >/dev/null 2>&1 || exit 0; done; $LEAN Check.lean >/dev/null 2>&1 && $LEAN Canon.lean >/dev/null 2>&1 ); then
    echo "BLIND  $1 — the break still checks"; exit 1
  else echo "FAILS as required  $1"; breaks=$((breaks+1)); fi
}
try "R4 without its doubt clause"          Rules.lean     's/!isSense c \&\& c.root != .mohaDoubt /!isSense c /'
try "R6 pīti allowed in the 4th jhāna"     Rules.lean     's/c.vedana == .somanassa \&\& c.jhana ≤ 3/c.vedana == .somanassa \&\& c.jhana ≤ 4/'
try "R16 abstinences in functionals too"   Rules.lean     's/(c.bhumi == .kama \&\& c.jati == .kusala)/(c.bhumi == .kama \&\& c.jati != .vipaka)/'
try "key: smile-producing 12 → 13"         AnswerKey.lean 's/\[10, 11, 12\]/[10, 11, 13]/'
try "key: adhimokkha 78 → 77"              AnswerKey.lean 's/(adhimokkha, 78)/(adhimokkha, 77)/'
try "generator: fine-material jhānas 1–4"  Citta.lean     's/\[1, 2, 3, 4, 5\].map fun n =>$/[1, 2, 3, 4].map fun n =>/'
try "generator: smile with equanimity"     Citta.lean     's/{ jati := .kiriya, bhumi := .kama, vedana := .somanassa, root := .none }/{ jati := .kiriya, bhumi := .kama, vedana := .upekkha, root := .none }/'
try "canon: chanda counted as named"      Canon.lean     's/vitakka, vicara, viriya, piti,  /vitakka, vicara, viriya, piti, chanda,/'
try "roots: knowledge adds no root"        Rules.lean     's/if c.knowing then 3 else 2/if c.knowing then 2 else 2/'
echo "$breaks of 9 deliberate breaks fail, as required"
