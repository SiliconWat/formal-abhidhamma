#!/bin/sh
# Meru control: the theorems must CHECK; each break must FAIL. Needs Lean 4 (LEAN=… to override).
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
if $LEAN Meru.lean; then echo "PASS  d1_mass · d1b_chandrasekhar · d2_strength · d3_no_exemption + non-vacuity"; else echo "FAIL"; exit 1; fi
try() { T=$(mktemp -d); cp Meru.lean "$T/"; sed -i.orig "$2" "$T/Meru.lean"
  if cmp -s "$T/Meru.lean" "$T/Meru.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Meru.lean" >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "D1 at a 1 m yojana"                        's/(hy : 7000 ≤ y) (hρ : 2700 ≤ ρ) :\n    180000/X/; s/theorem d1_mass (y ρ : Nat) (hy : 7000 ≤ y)/theorem d1_mass (y ρ : Nat) (hy : 1 ≤ y)/'
try "D1b below the Chandrasekhar threshold"     's/(hy : 9600 ≤ y)/(hy : 9500 ≤ y)/'
try "D2 at the agent's 7 m (only 17 m+ holds)"  's/(hy : 18 ≤ y)/(hy : 17 ≤ y)/'
try "D3 gravity allowed to see ussada"          's/theorem d3_no_exemption (grav : List String → Prop)/theorem d3_no_exemption (grav : Clump → Prop)/; s/grav sineru.elems ↔ grav rock.elems/grav sineru ↔ grav rock/'
echo "all breaks fail as required"
