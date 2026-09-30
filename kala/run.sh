#!/bin/sh
# Kāla (exploratory, not pre-registered): the theorems must CHECK; each deliberate break must FAIL.
# Exit 0 only if all hold. Needs Lean 4 (LEAN=path/to/lean to override). Axiom IDs: AXIOMS.md.
set -u
cd "$(dirname "$0")"
LEAN="${LEAN:-lean}"
build() { ( cd "$1" && $LEAN -o Axioms.olean Axioms.lean && LEAN_PATH=. $LEAN Time.lean ); }
T0=$(mktemp -d); cp Axioms.lean Time.lean "$T0/"
if build "$T0"; then echo "PASS  7 theorems + a model: gapless · mind has no between · matter can have one · no time after the last moment · space ends with the stream · beginningless · nibbāna is not a moment; the ω* arahant model satisfies every axiom"
else echo "FAIL  the build"; rm -rf "$T0"; exit 1; fi
rm -rf "$T0"
try() { # $1 label, $2 file, $3 sed expression
  T=$(mktemp -d); cp Axioms.lean Time.lean "$T/"; sed -i.orig "$3" "$T/$2"
  if cmp -s "$T/$2" "$T/$2.orig"; then echo "BREAK NOT APPLIED  $1 — the sed matched nothing"; rm -rf "$T"; exit 1; fi
  if build "$T" >/dev/null 2>&1; then echo "BLIND  $1 — the break still checks"; rm -rf "$T"; exit 1
  else echo "FAILS as required  $1"; fi
  rm -rf "$T"
}
try "A1 dropped: two moments may share a tick"          Axioms.lean 's/one_at_a_time : ∀ a b, tick a = tick b → a = b/one_at_a_time : True/'
try "C dropped: conditionality made vacuous"             Axioms.lean 's/def Conditioned (s : Stream) : Prop := ∀ m, ∃ p, s.succ p = some m/def Conditioned (s : Stream) : Prop := True/'
try "A3 dropped: a later moment need not be reached"     Axioms.lean 's/continues : ∀ m m., tick m < tick m. → ∃ n, succ m = some n/continues : True/'
try "K moved: last kamma-born matter one moment later"   Time.lean   's/(h₁ : k₁.birth ≤ N - 16)/(h₁ : k₁.birth ≤ N - 15)/'
try "A4 changed: matter lasts 18 moments"                Axioms.lean 's/def lifespan : Int := 17/def lifespan : Int := 18/'
try "A8 broken: nibbāna made a kind of dhamma"           Time.lean   's/(Object.nibbana : Object M) ≠ Object.dhamma m/(Object.dhamma m : Object M) ≠ Object.dhamma m/'
echo "all breaks fail as required"
