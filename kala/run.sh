#!/bin/sh
# Kāla (exploratory, not pre-registered): the theorems must CHECK; each deliberate break must FAIL.
# Exit 0 only if all hold. Needs Lean 4 (LEAN=path/to/lean to override).
set -u
cd "$(dirname "$0")"
LEAN="${LEAN:-lean}"
if $LEAN Time.lean; then echo "PASS  7 theorems + a model: gapless · mind has no between · matter can have one · no time after the last moment · space ends with the stream · beginningless · nibbāna is not a moment; the ω* arahant model satisfies every axiom"
else echo "FAIL  Time.lean"; exit 1; fi
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
try() { # $1 label, $2 sed expression
  cp Time.lean "$T/Time.lean"; sed -i.orig "$2" "$T/Time.lean"
  if cmp -s "$T/Time.lean" "$T/Time.lean.orig"; then echo "BREAK NOT APPLIED  $1 — the sed matched nothing"; exit 1; fi
  if $LEAN "$T/Time.lean" >/dev/null 2>&1; then echo "BLIND  $1 — the break still checks"; exit 1
  else echo "FAILS as required  $1"; fi
}
try "A1 dropped: two moments may share a tick"      's/one_at_a_time : ∀ a b, tick a = tick b → a = b/one_at_a_time : True/'
try "C dropped: conditionality made vacuous"         's/def Conditioned (s : Stream) : Prop := ∀ m, ∃ p, s.succ p = some m/def Conditioned (s : Stream) : Prop := True/'
try "A3 dropped: a later moment need not be reached" 's/continues : ∀ m m., tick m < tick m. → ∃ n, succ m = some n/continues : True/'
try "K moved: last kamma-born matter one moment later" 's/(h₁ : k₁.birth ≤ N - 16)/(h₁ : k₁.birth ≤ N - 15)/'
try "A4 changed: matter lasts 18 moments"            's/def lifespan : Int := 17/def lifespan : Int := 18/'
try "nibbāna made a kind of dhamma"                  's/  | nibbana : Object M/  | nibbana : Object M\
abbrev Object.nibbana'"'"' {M : Type} [Inhabited M] : Object M := .dhamma default/; s/(Object.nibbana : Object M) ≠ Object.dhamma m/(Object.dhamma m : Object M) ≠ Object.dhamma m/'
echo "all breaks fail as required"
