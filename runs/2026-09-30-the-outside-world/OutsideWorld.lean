/-
  The outside world (PREREG pushed 2026-10-01T05:13:38Z; OTS-stamped). Window A0; axioms A4, A5, A15, A61, A64, A65,
  A66, A67, A113. Survivors only, each with the premises the refuter marked OURS. Comparisons with measurements
  (Hensen 2015's S = 2.42 ± 0.20; ¹⁹⁸Au half-lives 2.6949 ± 0.0009 d vs 2.6953 ± 0.0008 d at 19 K; ATLAS 2017) are NOT
  DERIVATIONS and are not here.
-/
namespace FormalAbhidhamma.OutsideWorld

def iter {K : Type} (f : K → K) : Nat → K → K
  | 0, k => k
  | n + 1, k => iter f n (f k)

/-- D0. A64 + A15 + Vism XX `e0102n.mul.xml:6037`, `:6065` (each temperature produces "another octad"): every external
    kalāpa has a producer born strictly earlier. ⚠️ That each has exactly ONE parent (`parent : K → K`) is OURS (refuter).
    ⇒ a lineage that never passes through a body goes back without bound: it has no first member. -/
theorem d0_no_first_member {K : Type} (b : K → Int) (parent : K → K) (h : ∀ k, b (parent k) < b k) :
    ∀ n k, b (iter parent n k) + n ≤ b k := by
  intro n
  induction n with
  | zero => intro k; simp [iter]
  | succ n ih => intro k; have := ih (parent k); have := h k; simp only [iter]; omega

/-- Non-vacuity for D0: the integers, each born one unit after its parent. -/
theorem d0_model : ∀ k : Int, (k - 1) < k := by intro k; omega

/-- D1. CHSH's arithmetic: for definite values ±1 fixed locally, a·b + a·b′ + a′·b − a′·b′ = ±2, so |S| ≤ 2.
    ⚠️ The premises that make the texts' world such a model — definite values (the *sabhāva* gloss `abh07t.nrf.xml:5817` is
    epistemic, *upalabbhanato*), a purely local relay (R11 at `e0104n.att.xml:497` is a finite relay; only R9's magnet, said of
    SOUND, is at a distance), and free settings — are ALL OURS (refuter). Superdeterministic and retrocausal exits stay open. -/
theorem d1_chsh_local_bound :
    ∀ a a' b b' : Bool,
      let s : Bool → Int := fun x => if x then 1 else -1
      s a * s b + s a * s b' + s a' * s b - s a' * s b' = 2 ∨
      s a * s b + s a * s b' + s a' * s b - s a' * s b' = -2 := by
  intro a a' b b'; cases a <;> cases a' <;> cases b <;> cases b' <;> decide

/-- D3ii, CONDITIONAL on two premises in no text (refuter): one colour value per site, and light as a relay through octads
    (the texts' sight ruling is *asampatta*; their relay is for sound). Then two crossing beams of 2-valued colour cannot
    both leave unaltered: the site's colour cannot record both. -/
theorem d3ii_crossing_beams (f : Bool → Bool → Bool) :
    ∃ x y x' y', (x ≠ x' ∨ y ≠ y') ∧ f x y = f x' y' := by
  cases h1 : f false false <;> cases h2 : f false true <;> cases h3 : f true false
  all_goals first
    | exact ⟨false, false, false, true, Or.inr Bool.false_ne_true, h1.trans h2.symm⟩
    | exact ⟨false, false, true, false, Or.inl Bool.false_ne_true, h1.trans h3.symm⟩
    | exact ⟨false, true, true, false, Or.inl Bool.false_ne_true, h2.trans h3.symm⟩

/-- D5b. The Sammohavinodanī's ladder (`abh02a.att.xml:6333`): 36 paramāṇu = aṇu; 36 = tajjārī; 36 = rathareṇu;
    36 = likkhā; then 7 likkhā = ūkā; 7 = dhaññamāsa; 7 = aṅgula. Paramāṇu per aṅgula and aṇu per aṅgula.
    (The agent wrote 36³·36·7³ = 16,003,008; the refuter: that product is 576,108,288; 16,003,008 is 36³·7³.) -/
theorem d5b_ladder : 36 ^ 4 * 7 ^ 3 = 576108288 ∧ 36 ^ 3 * 7 ^ 3 = 16003008 := by decide

/-- D5. A113 (motion is arising at another place) with A4's standing phase: if light steps one paramāṇu ℓ per production
    (H-step, OURS) and a production waits at most one standing sub-moment (τ ≤ 3·τ_g, R2), then c·τ ≤ 3ℓ — light's speed
    bounds the moment from ABOVE (≈ 3×10⁻¹⁹ s with ℓ ≈ 3.3×10⁻¹¹ m from an aṅgula ≈ 1.9 cm, an anchor of OURS that the
    ladder's own sunbeam-mote rung misses by 10³). Compatible with A24's lower bound on the rate: EXTENDS. -/
theorem d5_light_bounds_the_moment (c τg ℓ τ : Nat) (step : c * τg ≤ ℓ) (sub : τ ≤ 3 * τg) : c * τ ≤ 3 * ℓ := by
  have h1 : c * τ ≤ c * (3 * τg) := Nat.mul_le_mul_left c sub
  have h2 : c * (3 * τg) = 3 * (c * τg) := by rw [← Nat.mul_assoc, Nat.mul_comm c 3, Nat.mul_assoc]
  omega

end FormalAbhidhamma.OutsideWorld
