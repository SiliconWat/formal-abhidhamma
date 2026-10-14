#!/bin/sh
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Bridge.lean; then echo "PASS  d2_proximity_forbids_density + d2_model · d3 (BY CONSTRUCTION) · d4_bound_is_one_submoment · d5_packing + d5_model · d6 windows + counts · d7_ladder · d7_sizes · d7_count_collision + d7_model · d8_product_moves · d8_period_two"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Bridge.lean "$T/"; sed -i.orig "$2" "$T/Bridge.lean"
  if cmp -s "$T/Bridge.lean" "$T/Bridge.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Bridge.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "D2 with A3 weakened to a bare successor (no 'nothing between')"  's/(a3 : ∀ m, ImmSucc lt m (s m))/(a3 : ∀ m, lt m (s m))/'
try "D4 claiming the agent's 51ε bound"                                's/(meas : d ≤ T) : ε ≤ T/(meas : d ≤ T) : 51 * ε ≤ T/'
try "D5 with kalāpas allowed to pervade (no spacing)"                 's/| a :: b :: t => a + c ≤ b ∧ Spaced c (b :: t)/| a :: b :: t => a ≤ b ∧ Spaced c (b :: t)/'
try "D6 with a life of 48 sub-moments"                                 's/def present (t i : Int) : Prop := i ≤ t ∧ t ≤ i + 50/def present (t i : Int) : Prop := i ≤ t ∧ t ≤ i + 47/'
try "D7 with a nucleus of 8 nucleons"                                  's/(gold : inside = 197)/(gold : inside = 8)/'
try "D8 without A5's non-pervasion"                                    's/(a5 : ∀ p q, copresent p q → p ≠ q → place p ≠ place q)/(a5 : True)/'
echo "all breaks fail as required"
