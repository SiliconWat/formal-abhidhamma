/-
  Sun–moon control (PREREG pushed 2026-09-30T16:57:15Z). Window A0. Axioms A16, A17 + the line the
  pre-registration MISSED: `abh01a.att.xml:8353` — moon BELOW, sun ABOVE, one yojana between; 100 yojanas
  from the moon's lower edge to the sun's upper edge. Heights in yojanas; every result is unit-free.
  hm = the moon disc's height, hs = the sun's: 42000 ≤ hm ≤ hs ≤ hm + 100 (the texts' stack).
-/
namespace FormalAbhidhamma.SunMoon

/-- D1 (corrected). The texts' distance ratio hs/hm is below 2 — against a measured ≈ 389. -/
theorem d1_ratio_below_two (hm hs : Nat) (h0 : 42000 ≤ hm) (h1 : hs ≤ hm + 100) : hs < 2 * hm := by
  omega

/-- D2. Apparent diameter of the sun's 50-yojana disc at ≥ 42000 yojanas is below 1/800 rad (≈ 4.3′);
    measured ≈ 32′ > 1/109 rad. As a cross-multiplication: 50/hs < 1/800. -/
theorem d2_disc_too_small (hs : Nat) (h0 : 42000 ≤ hs) : 50 * 800 < hs := by
  omega

/-- D3 (corrected). With the moon below and the sun at most 100 yojanas higher, the moon's apparent size
    is ALWAYS smaller than the sun's: θm/θs = (49·hs)/(50·hm) < 1 — annular eclipses only, never total.
    Measured θm/θs ranges 0.92–1.08; 8 April 2024 was total. -/
theorem d3_never_total (hm hs : Nat) (h0 : 42000 ≤ hm) (h1 : hs ≤ hm + 100) : 49 * hs < 50 * hm := by
  omega

/-- Non-vacuity: the texts' own stack satisfies the hypotheses (moon at 42000, sun 50 higher). -/
example : 49 * 42050 < 50 * 42000 := d3_never_total 42000 42050 (by decide) (by decide)

end FormalAbhidhamma.SunMoon
