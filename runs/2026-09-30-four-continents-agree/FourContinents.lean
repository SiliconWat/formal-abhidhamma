/-
  Four-continents agree-control — the FIRST agree-control (PREREG pushed 2026-09-30T21:03:28Z; OTS-stamped). Window A0;
  axiom A22 (DN-a `s0103a.att.xml:833`) + readings the agent ADDED (DERIVATION.md §1). Survivors after the refuter only.
-/
namespace FormalAbhidhamma.FourContinents

/-- D2, as the REFUTER re-derived it from the table itself (A22, no added reading): four sunrise instants split the
    day into gaps g₀…g₃ (Σ = τ); each continent's day is two consecutive gaps, and "noon" is its exact midpoint
    (*ṭhitamajjhanhika*, `s0103t.tik.xml:837`), so consecutive gaps are equal. Then every day is half the circuit:
    12-hour days all year — true only at the equinoxes or on the equator; measured solstice day lengths differ. -/
theorem d2_table_forces_equal_days (g₀ g₁ g₂ g₃ τ : Nat) (circuit : g₀ + g₁ + g₂ + g₃ = τ)
    (m₀ : g₀ = g₁) (m₁ : g₁ = g₂) (m₂ : g₂ = g₃) :
    2 * (g₀ + g₁) = τ ∧ 2 * (g₁ + g₂) = τ ∧ 2 * (g₂ + g₃) = τ ∧ 2 * (g₃ + g₀) = τ := by
  omega

/-- D3. On the texts' own flat plane (Vism VII: a layered slab; heights from one ocean datum), Meru at the origin, the
    observer at (0, −R_o), the sun at (R_s sin Δ, −R_s cos Δ, h); at the texts' sunrise Δ = 90° (cos Δ = 0), the
    northward component of the line of sight is R_o − R_s·0 = R_o > 0: sunrise is always NORTH of east.
    ⚠️ BY CONSTRUCTION once the coordinates are fixed; the content is the configuration (A22 + R4). Measured sunrise at
    7°N runs 23.6° south to 23.6° north of east; the texts' runs 30.8°–56.5° north, every day of the year. -/
theorem d3_sunrise_north (Ro Rs c : Int) (hRo : 0 < Ro) (rise : c = 0) : 0 < Ro - Rs * c := by
  subst rise; omega

/-- D6b — refutes OUR OWN candidate (Yugandhara as the sun's night-maker is OURS; the refuter): for the equinox 90° rule
    at Sīhaḷadīpa the ring would need radius g = R_o R_s / √(R_o² + R_s²) ≈ 209,177 yojanas, above the near-Meru path
    R_s = 181,931¼, which it would then block all June. Scaled ×4 to integers: (XY)² > T²(X² + Y²). -/
theorem d6b_ring_too_wide : (1100875 * 1287450) ^ 2 > 727725 ^ 2 * (1100875 ^ 2 + 1287450 ^ 2) := by
  decide

/-- Non-vacuity: the table's equal quarters (τ = 24 hours, 6 each). -/
example : 2 * (6 + 6) = 24 ∧ 2 * (6 + 6) = 24 ∧ 2 * (6 + 6) = 24 ∧ 2 * (6 + 6) = 24 :=
  d2_table_forces_equal_days 6 6 6 6 24 (by decide) rfl rfl rfl

end FormalAbhidhamma.FourContinents
