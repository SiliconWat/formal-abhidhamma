#!/bin/sh
# Kāla (exploratory, not pre-registered): the theorems must CHECK; each deliberate break must FAIL.
# Exit 0 only if all hold. Needs Lean 4 (LEAN=path/to/lean to override). Axiom IDs: AXIOMS.md.
set -u
cd "$(dirname "$0")"
LEAN="${LEAN:-lean}"
FILES="Axioms.lean Time.lean Vithi.lean Patthana.lean"
build() { ( cd "$1" && $LEAN -o Axioms.olean Axioms.lean && for f in Time Vithi Patthana; do LEAN_PATH=. $LEAN $f.lean || exit 1; done ); }
T0=$(mktemp -d); cp $FILES "$T0/"
if build "$T0"; then echo "PASS  7 theorems + a model: gapless · mind has no between · matter can have one · no time after the last moment · space ends with the stream · beginningless · nibbāna is not a moment; the ω* arahant model satisfies every axiom"
      echo "PASS  Vithi: the very-great sum fills the life · the grades by past moments (1 | 2–3 | 4–9 | 10–15 | 16) · javanas at the object's moments 9–15 · 16 with the Saṅgaha's entry admits no very-great process, 16 with arising-entry fills the life · (BY CONSTRUCTION) no process outlives its object"
      echo "PASS  Patthana: twenty-four · the model is well-timed · conditioning is not antisymmetric · it runs forward, within a moment and backward · proximity alone is a strict order · (BY CONSTRUCTION) post-nascence supports a present body"
else echo "FAIL  the build"; rm -rf "$T0"; exit 1; fi
rm -rf "$T0"
try() { # $1 label, $2 file, $3 sed expression
  T=$(mktemp -d); cp $FILES "$T/"; sed -i.orig "$3" "$T/$2"
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
try "A4 = 16 under the Saṅgaha's entry convention (p = 1): the very-great sum no longer fills the life" Axioms.lean 's/def lifespan : Int := 17/def lifespan : Int := 16/'
try "A41 changed: six javanas"                           Vithi.lean  's/def javanas       : Nat := 7/def javanas       : Nat := 6/'
try "A42 changed: one determining is enough for a slight object" Vithi.lean 's/def minDetermining : Nat := 2/def minDetermining : Nat := 1/'
try "A84 dropped: mutuality made one-way"                 Patthana.lean '/^  \[⟨.annamanna, feeling/s/⟨.annamanna, perception, feeling⟩/⟨.sahajata, citta0, eyeCons⟩/'
try "A3's tick dropped: a successor need not come later"  Axioms.lean 's/tick_succ : ∀ m n, succ m = some n → tick n = tick m + 1/tick_succ : True/'
try "A88 changed: post-nascence without presence"         Patthana.lean 's/decide (e.dst.rise < e.src.rise) \&\& e.dst.present e.src.rise/decide (e.dst.rise < e.src.rise)/'
echo "all breaks fail as required"
