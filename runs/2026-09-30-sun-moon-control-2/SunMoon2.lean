/-
  Sun–moon control 2 (PREREG pushed 2026-09-30T17:20:22Z; OTS-stamped). Window A0; axioms A16, A17, A18.
  d1–d3 as in run 1 (the stack from abh01a.att.xml:8353). d4 is NEW, from the text's own words
  (SN-a s0301a.att.xml:2123): Rāhu cannot stop the mansion and "moves along with it" (saheva gacchati).
-/
namespace FormalAbhidhamma.SunMoon2

theorem d1_ratio_below_two (hm hs : Nat) (h0 : 42000 ≤ hm) (h1 : hs ≤ hm + 100) : hs < 2 * hm := by omega
theorem d2_disc_too_small (hs : Nat) (h0 : 42000 ≤ hs) : 50 * 800 < hs := by omega
theorem d3_never_total (hm hs : Nat) (h0 : 42000 ≤ hm) (h1 : hs ≤ hm + 100) : 49 * hs < 50 * hm := by omega

/-- d4. Positions east-positive, one step per tick. The sun's disc moves WEST by v > 0 each tick (its daily
    motion); an occulter that "moves along with it" keeps a fixed offset c; its shadow falls at a ground point
    that tracks the occulter (offset g0). Then the shadow moves WEST every tick. Measured: eclipse umbrae
    sweep WEST→EAST (2017-08-21: Oregon → South Carolina). -/
theorem d4_shadow_moves_west (sun : Nat → Int) (v c g0 : Int) (hv : 0 < v)
    (hsun : ∀ t, sun (t + 1) = sun t - v) (t : Nat) :
    (sun (t + 1) + c + g0) < (sun t + c + g0) := by
  have := hsun t
  omega

example : 49 * 42050 < 50 * 42000 := d3_never_total 42000 42050 (by decide) (by decide)
example : ∃ sun : Nat → Int, ∀ t, sun (t + 1) = sun t - 1 :=
  ⟨fun t => -(t : Int), fun t => by show -(((t + 1 : Nat)) : Int) = -((t : Nat) : Int) - 1; omega⟩

end FormalAbhidhamma.SunMoon2
