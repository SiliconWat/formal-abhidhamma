/-
  Sun–moon control 3 (PREREG pushed 2026-09-30T18:26:11Z; OTS-stamped). Window A0; axioms A16, A17, A18
  + readings the agent ADDED from the neighbourhood (DERIVATION.md §0): B1 (s0103t.tik.xml:821, 49/50 are
  length, breadth AND height), B3 (s0103a.att.xml:825, new moon = the sun directly above the moon),
  B4 (s0103t.tik.xml:825, sunlight falls on the moon FROM ABOVE; full moon lags half the path),
  B6 (OURS: the silver-covered moon is opaque). Physics premises P1 (straight lines), P2 (phase law).
  d1–d3 of runs 1–2 are not repeated (SunMoon.lean, SunMoon2.lean). Every result is unit-free.
-/
namespace FormalAbhidhamma.SunMoon3

/-- D4, at the zenith only (the refuter's NARROWS). P2 with the sun above the moon (A16 + B4): the lit
    fraction seen from directly below is k = (1 − s)/2 with s = sin ε > 0, so k < ½ — never full.
    Scaled by S (s, S integers, 0 < s ≤ S). ⚠️ Lean checks only the SIGN step; the content is P2 + A16. -/
theorem d4_zenith_never_full (S s : Int) (hs : 0 < s) (hS : s ≤ S) : 2 * (S - s) < 2 * S := by
  omega

/-- D5. With the moon at hm, the sun at hs ≥ hm (A16: sun ABOVE), discs 49 and 50 (A17), an opaque moon
    (B6) centred under the sun at new moon (B3) hides more than 96% of the sun's disc: ((49·hs)/(50·hm))² > 0.96.
    ⭐ Holds for ANY stack with the sun above — independent of 42,000. Measured: most new moons eclipse nowhere. -/
theorem d5_monthly_annular (hm hs : Nat) (h0 : 0 < hm) (h1 : hm ≤ hs) :
    96 * (2500 * (hm * hm)) < 100 * (2401 * (hs * hs)) := by
  have h2 : hm * hm ≤ hs * hs := Nat.mul_le_mul h1 h1
  have h3 : 0 < hm * hm := Nat.mul_pos h0 h0
  omega

/-- D6. The sun circles Sineru once a day (B5) at r ≥ 42,000 (A14); its 50-yojana disc (A17) crosses its own
    width in t = 50·T/(2πr) < 17 s (T = 86,400 s; 2π > 6.28). Any smooth static optics scales disc and
    motion alike (P3), so t is fixed. Measured at the equator ≈ 128 s. Cross-multiplied, ×100. -/
theorem d6_crossing_under_17s (r : Nat) (h0 : 42000 ≤ r) : 50 * 86400 * 100 < 17 * 628 * r := by
  omega

/-- D6b (the refuter's CONTRAST). With the texts' own near-Meru path r ≥ 182,000 (s0103t.tik.xml:833) and
    height H = 42,000, the sun's zenith angular speed v/H exceeds FOUR times the rate that r = H would give
    (and r = H is the only radius reproducing 15°/h). -/
theorem d6b_zenith_rate (r : Nat) (h0 : 182000 ≤ r) : 4 * 42000 < r := by
  omega

/-- D7b. Rāhu's 200-yojana hand or mouth (s0301a.att.xml:2123) at Δ yojanas below the 50-yojana sun,
    0 < Δ ≤ 100 (the stack), casts at the ground (42,000 down) an umbra of width w = 200 + 150·42000/Δ
    ≥ 63,200. Cross-multiplied: 63200·Δ ≤ 200·Δ + 150·42000. Measured paths ≤ ≈ 270 km. -/
theorem d7b_umbra_wide (Δ : Nat) (h0 : 0 < Δ) (h1 : Δ ≤ 100) : 63200 * Δ ≤ 200 * Δ + 150 * 42000 := by
  omega

/-- Meru shadow (the refuter's finding 2, straight lines only). Sun and moon at heights h1, h2 ≤ 84,000,
    diametrically opposite across Meru's axis at full moon (B4: "half the path"): the segment between them
    crosses the axis (x = 0) at height (h1 + h2)/2, inside Meru (half-width 42,000 ≥ 0; height ≤ 84,000, A14).
    ⚠️ BY CONSTRUCTION in its geometry (the crossing point is the midpoint); the content is A14 + A16 + B4. -/
theorem meru_blocks_full_moon (h1 h2 : Nat) (a : h1 ≤ 84000) (b : h2 ≤ 84000) : h1 + h2 ≤ 2 * 84000 := by
  omega

/-- Non-vacuity: the texts' own stack (moon 42,000, sun 42,050) and Rāhu 100 yojanas below the sun. -/
example : 96 * (2500 * (42000 * 42000)) < 100 * (2401 * (42050 * 42050)) :=
  d5_monthly_annular 42000 42050 (by decide) (by decide)
example : 50 * 86400 * 100 < 17 * 628 * 42000 := d6_crossing_under_17s 42000 (by decide)
example : 63200 * 100 ≤ 200 * 100 + 150 * 42000 := d7b_umbra_wide 100 (by decide) (by decide)
example : 2 * (1000 - 1) < 2 * (1000 : Int) := d4_zenith_never_full 1000 1 (by decide) (by decide)

end FormalAbhidhamma.SunMoon3
