/-
  Order without a gap (PREREG pushed 2026-10-01T05:13:56Z; OTS-stamped). Window both; axioms A3, A7, A47, A64, A67, A111,
  A112, A114. Survivors only. D3's comparisons with measured physiology (apnoea records, the naked mole-rat, calorimetry)
  are NOT DERIVATIONS; only their arithmetic is here. D2 was narrowed to a conditional the texts themselves reject
  (Ledi `e0301n.nrf.xml:5677`: three-origin matter arises even in cessation) and is not formalised.
-/
namespace FormalAbhidhamma.Gap

/-- D1. Two reckonings across cessation, both the texts': the ORDER of cittas (Mūlaṭīkā `abh03t.tik.xml:4309`, read by
    Dhammapāla as Buddhaghosa's sense, `e0104n.att.xml:3573`: no interval) and DAY-RECKONING (Vism-ṭīkā `:3569`:
    "there IS a temporal interval, of seven days etc."; Vibhāvinī `abh07t.nrf.xml:6653`; A7 designates time on the sun's and
    moon's turning too). If the last citta before cessation is immediately followed by the first after it (A112), while
    day-reckoning records Δ > 1 units between them, then the count of cittas is not a clock of the day: no unit-step rule
    maps one to the other. ⭐ Lean found that the citta count's own unit step (A3's tick rule) is NOT needed — the first build
    flagged it unused: the separation follows from the proximity link (A112) and the day-gap alone. -/
theorem d1_count_is_not_the_day (M : Type) (succ : M → Option M) (tr : M → Int)
    (m₀ m₁ : M) (link : succ m₀ = some m₁) (Δ : Int) (gap : tr m₁ - tr m₀ = Δ) (wide : 1 < Δ) :
    ¬ (∀ m n, succ m = some n → tr n = tr m + 1) := by
  intro unit
  have := unit m₀ m₁ link
  omega

/-- Non-vacuity for D1: moments are integers; the count steps by one; day-reckoning jumps by Δ across the pair (0, 1). -/
theorem d1_model (Δ : Int) :
    let tr : Int → Int := fun k => if k ≤ 0 then k else k + Δ - 1
    tr 1 - tr 0 = Δ := by
  simp only []; split <;> split <;> omega

/-- D3, arithmetic only. At a resting O₂ consumption of 250 mL/min and a body store of 2,000 mL (textbook values, not the
    texts'), a breathless human body warmed only by oxidation lasts at most 8 minutes — against MN 50's "until that night's
    end" and the commentaries' seven days. -/
theorem d3_oxygen_budget (t : Nat) (store : 250 * t ≤ 2000) : t ≤ 8 := by omega

def iter {S : Type} (f : S → S) : Nat → S → S
  | 0, s => s
  | k + 1, s => iter f k (f s)

/-- D4 (as narrowed: a test design's premise, not a verdict). If the body's dynamics are autonomous (no external cue — the
    refuter: a dawn or a moon phase could carry the schedule) and its state is stationary through the gap, then an emergence
    predicate on that state fires at step 0 or never: a schedule needs a carrier. A64 says the body is NOT stationary. -/
theorem d4_stationary_state_cannot_keep_a_schedule {S : Type} (f : S → S) (E : S → Bool) (s₀ : S) (stat : f s₀ = s₀) :
    ∀ k, E (iter f k s₀) = E s₀ := by
  intro k
  induction k with
  | zero => rfl
  | succ k ih => simp only [iter, stat]; exact ih

end FormalAbhidhamma.Gap
