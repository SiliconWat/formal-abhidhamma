/-
  The object-life budget (PREREG pushed 2026-10-01T05:13:34Z; OTS-stamped). Window both; axioms A4, A24, A37, A40, A41,
  A42, A63, A87. Survivors only, in MIND-MOMENTS throughout (the refuter caught the agent mixing sub-moments with moments).
  D5 and D6 survive as philosophy and are not here; D4's comparison with tissue mechanics and c is arithmetic only.
-/
namespace FormalAbhidhamma.Budget

inductive Grade where
  | veryGreat | great | slight | verySlight | none
  deriving DecidableEq, Repr

/-- The grade of an object with life L that enters after p past moments (A41's stages: 2 vibrations, 5 to determining,
    7 javanas, 2 registrations; slight needs determining at least twice). -/
def gradeL (L p : Nat) : Grade :=
  if p + 16 ≤ L then .veryGreat
  else if p + 14 ≤ L then .great
  else if p + 8 ≤ L then .slight
  else if p + 2 ≤ L then .verySlight
  else .none

def rank : Grade → Nat
  | .none => 0 | .verySlight => 1 | .slight => 2 | .great => 3 | .veryGreat => 4

/-- D1. The grade depends only on the life LEFT at entry, L − p — the Vibhāvinī's own definition (`abh07t.nrf.xml:4821`:
    16 · 15–14 · 13–8 · 7–2 moments left). So the 16 / 17 dispute moves the PAST-moment ranges, not the grades.
    ⚠️ BY CONSTRUCTION (refuter): any grade built from tests p + c ≤ L is shift-invariant. -/
theorem d1_life_left_decides (L p k : Nat) : gradeL (L + k) (p + k) = gradeL L p := by
  have e : ∀ c, (p + k + c ≤ L + k ↔ p + c ≤ L) := fun c => by omega
  simp only [gradeL, e]

/-- D1, the two readings side by side: the Saṅgaha's 17 with entry after one past moment, and the 16-holders' entry at the
    arising phase (p = 0; Vibhāvinī `:4845`, Ledi `e0301n.nrf.xml:2761`) — both leave 16 moments and both admit a very-great
    process. -/
theorem d1_both_readings_admit_very_great : gradeL 17 1 = .veryGreat ∧ gradeL 16 0 = .veryGreat := by decide

/-- D2. Depth is monotone in strength: if a stronger object enters no later (p antitone in strength — Ledi `:2657`,
    *dubbala dubbalatara dubbalatamānukkamena*), its grade is no lower. Checked for every p, p′ ≤ 20 with L = 17. -/
theorem d2_depth_monotone :
    (List.range 21).all (fun p => (List.range 21).all (fun q =>
      !(decide (p ≤ q)) || decide (rank (gradeL 17 q) ≤ rank (gradeL 17 p)))) = true := by decide

/-- D3, arithmetic. With τ ≤ 200 fs (A24 and a snap ≤ 0.4 s — our conversion), the javanas end by 15τ ≤ 3,000 fs = 3 ps
    after the object arises: before any measured neural onset (≈ 56 ms in occipital cortex). -/
theorem d3_budget_in_picoseconds (τ : Nat) (h : τ ≤ 200) : 15 * τ ≤ 3000 := by omega

/-- D4, arithmetic for the Vibhāvinī's *anukkamena* relay (`abh07t.nrf.xml:4857`) from eye to heart-base (d ≈ 0.25 m,
    `:5769`) within the 14 moments a five-door process allows. Units: nanometres and femtoseconds (c = 300 nm/fs), and for
    tissue nanometres and picoseconds (bone ≤ 4 nm/ps). At A24's count (τ ≤ 200 fs) even light covers only 0.84 mm; at the
    Anuṭīkā's (τ ≤ 2×10⁻⁸ s = 20,000 ps) a mechanical relay covers ≤ 1.12 mm. Both short of 250 mm: COLLIDES. -/
theorem d4_relay_cannot_reach_the_heart (τfs τps : Nat) (h1 : τfs ≤ 200) (h2 : τps ≤ 20000) :
    300 * 14 * τfs < 250000000 ∧ 4 * 14 * τps < 250000000 := by omega

end FormalAbhidhamma.Budget
