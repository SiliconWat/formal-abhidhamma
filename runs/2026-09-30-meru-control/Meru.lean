/-
  Meru control (pre-registered: PREREG.md, pushed 2026-09-30T16:28:55Z). Window A0; axioms A14, A6, A9
  (kala/AXIOMS.md) + the run's ADDED hypotheses: H-y yojana ≥ some length (metres), H-ρ rock density
  ≥ 2700 kg/m³, H-oct the inseparable eight (manual: Saṅgaha ch. 6). Units: SI, natural numbers.
  Mass of the 84k × 84k × 168k solid (above + below the water, AN 7.66): M = 2ρL³, L = 84000·y.
-/
namespace FormalAbhidhamma.Meru

/-- D1. At a yojana ≥ 7 km, Sineru outweighs 180,000 Earths (M⊕ = 5.97e24 kg). COLLIDES with the ephemerides. -/
theorem d1_mass (y ρ : Nat) (hy : 7000 ≤ y) (hρ : 2700 ≤ ρ) :
    180000 * (597 * 10^22) ≤ 2 * ρ * (84000 * y)^3 := by
  have h1 : (84000 * 7000)^3 ≤ (84000 * y)^3 := Nat.pow_le_pow_left (Nat.mul_le_mul_left _ hy) 3
  have h2 : 2 * 2700 * (84000 * 7000)^3 ≤ 2 * ρ * (84000 * y)^3 :=
    Nat.mul_le_mul (Nat.mul_le_mul_left _ hρ) h1
  exact Nat.le_trans (by decide) h2

/-- D1b (refuter-corrected: the limit for cold matter is Chandrasekhar's ≈ 1.4 M☉ = 2.7846e30 kg, not
    TOV). At a yojana ≥ 9.6 km, Sineru exceeds it. -/
theorem d1b_chandrasekhar (y ρ : Nat) (hy : 9600 ≤ y) (hρ : 2700 ≤ ρ) :
    27846 * 10^26 < 2 * ρ * (84000 * y)^3 := by
  have h1 : (84000 * 9600)^3 ≤ (84000 * y)^3 := Nat.pow_le_pow_left (Nat.mul_le_mul_left _ hy) 3
  have h2 : 2 * 2700 * (84000 * 9600)^3 ≤ 2 * ρ * (84000 * y)^3 :=
    Nat.mul_le_mul (Nat.mul_le_mul_left _ hρ) h1
  exact Nat.lt_of_lt_of_le (by decide) h2

/-- D2. Self-gravity stress σ ≈ Gρ²L² exceeds 1 GPa (strong rock) for any yojana ≥ 18 m.
    G = 6674 / 10^14. ⭐ Lean-found: the agent's "any yojana > 7 m" is the SPHEROID (size) threshold;
    against rock STRENGTH the collision starts at ≈ 17.1 m (the break at 17 m fails below). -/
theorem d2_strength (y ρ : Nat) (hy : 18 ≤ y) (hρ : 2700 ≤ ρ) :
    10^9 * 10^14 < 6674 * ρ^2 * (84000 * y)^2 := by
  have h1 : (84000 * 18)^2 ≤ (84000 * y)^2 := Nat.pow_le_pow_left (Nat.mul_le_mul_left _ hy) 2
  have h2 : 6674 * 2700^2 * (84000 * 18)^2 ≤ 6674 * ρ^2 * (84000 * y)^2 :=
    Nat.mul_le_mul (Nat.mul_le_mul_left _ (Nat.pow_le_pow_left hρ 2)) h1
  exact Nat.lt_of_lt_of_le (by decide) h2

/-- D3. If gravity depends only on a clump's elements (the modelling hypothesis — ⚠️ ours, not a reading
    of the text), and every clump carries the inseparable eight (H-oct), Sineru gravitates iff Earth rock
    does. A congruence: the CONTENT is the hypothesis that gravity factors through the eight. -/
structure Clump where
  elems : List String
  ussada : Nat                       -- predominance; the break below lets gravity see it

def oct : List String := ["pathavī", "āpo", "tejo", "vāyo", "vaṇṇa", "gandha", "rasa", "ojā"]

theorem d3_no_exemption (grav : List String → Prop) (sineru rock : Clump)
    (hs : sineru.elems = oct) (hr : rock.elems = oct) : grav sineru.elems ↔ grav rock.elems := by
  rw [hs, hr]

/-- Non-vacuity: the hypotheses are satisfiable (the commentarial yojana and granite). -/
example : 180000 * (597 * 10^22) ≤ 2 * 2700 * (84000 * 12000)^3 := d1_mass 12000 2700 (by decide) (by decide)
example : ∃ s r : Clump, s.elems = oct ∧ r.elems = oct ∧ s.ussada ≠ r.ussada := ⟨⟨oct, 1⟩, ⟨oct, 2⟩, rfl, rfl, by decide⟩

end FormalAbhidhamma.Meru
