import Mathlib.Analysis.Real.Hyperreal

/-!
# fo/FO/Chain.lean — what a finite chain of steps spans on a hyperreal clock (roadmap A424, owed item 1)

The founder's sentence (2026-10-16): *"Each moment of the citta stream is an infinitesimal point within a causal monad,
forming a hyperfinite grid whose total hyperreal duration resolves into conventional reality through the standard part
map."* The session's stronger version, offered the same day: each citta lasts an infinitesimal but POSITIVE time
(A40: three equal sub-moments of positive length), so the cittas that a finite chain of proximity (A3) reaches all fall
within one instant of ordinary time; duration itself is a designation laid on the stream (A7); and across cessation a
single step of proximity spans days (A112).

This file proves the mathematical core of that version and nothing about the texts:

- `finite_chain_spans_infinitesimal` — if every step of a FINITE chain lasts an infinitesimal time, the whole chain
  does too, so its standard part is 0 (`finite_chain_standard_part_zero`): a finite chain reaches only a *galaxy*, which
  lies inside one *monad* of time.
- `ordinary_duration_needs_a_long_step` — so a finite chain that spans an ordinary duration has a step that is not
  infinitesimal.
- `infinitely_many_steps_make_a_unit` — the other side: ω steps of length ε = ω⁻¹ make exactly one ordinary unit, so an
  ordinary duration made of infinitesimal steps needs infinitely many of them.
- `cessation_step_is_not_infinitesimal` — one step of ordinary length (A112's cessation, read on this clock) among
  infinitesimal ones, and the span is no longer infinitesimal: across cessation the hypothesis fails, not the theorem.

⛔ **Not a model of the rows.** Protocol 1 forbids any model search before Protocol 2 freezes the encoding. These are
CONDITIONAL theorems about any list of durations on Mathlib's hyperreals; the stream rows, the clock (`model/Mind.lean`
`Scale`) and the founder's Thesis H (amendment 2) are not used. Whether a step's duration IS infinitesimal is the
founder's reading (H₂), never a row. Physics: none — no measurement returns an infinitesimal (A424's reading).

`Infinitesimal` is Mathlib's convention made explicit: `x` is infinitesimal when its Archimedean class lies above the
ordinary numbers' (`0 < ArchimedeanClass.mk x`; for the ordinary numbers it is 0, and `mk 0 = ⊤`).
-/

namespace FormalAbhidhamma.FO.Chain

open Hyperreal ArchimedeanClass

/-- `x` is infinitesimal: smaller in absolute value than every positive ordinary number. -/
def Infinitesimal (x : ℝ*) : Prop := 0 < mk x

theorem infinitesimal_add {x y : ℝ*} (hx : Infinitesimal x) (hy : Infinitesimal y) : Infinitesimal (x + y) :=
  lt_of_lt_of_le (lt_min hx hy) (min_le_mk_add x y)

/-- A finite chain of steps, each of infinitesimal duration, spans an infinitesimal duration. -/
theorem finite_chain_spans_infinitesimal (n : ℕ) (d : Fin n → ℝ*) (h : ∀ i, Infinitesimal (d i)) :
    Infinitesimal (∑ i, d i) :=
  Finset.sum_induction d Infinitesimal (fun _ _ => infinitesimal_add) (by simp [Infinitesimal]) (fun i _ => h i)

/-- …so its ordinary duration (its standard part) is zero. -/
theorem finite_chain_standard_part_zero (n : ℕ) (d : Fin n → ℝ*) (h : ∀ i, Infinitesimal (d i)) :
    stdPart (∑ i, d i) = 0 :=
  stdPart_eq_zero.mpr (finite_chain_spans_infinitesimal n d h).ne'

/-- …and so a finite chain that spans more than an infinitesimal has at least one step that is not infinitesimal. -/
theorem ordinary_duration_needs_a_long_step (n : ℕ) (d : Fin n → ℝ*) (h : ¬ Infinitesimal (∑ i, d i)) :
    ∃ i, ¬ Infinitesimal (d i) := by
  by_contra hc
  push Not at hc
  exact h (finite_chain_spans_infinitesimal n d hc)

/-- The other side: ω steps of length ε = ω⁻¹ span exactly one ordinary unit, whose standard part is 1. -/
theorem infinitely_many_steps_make_a_unit : ε * ω = 1 ∧ stdPart (ε * ω) = 1 :=
  ⟨epsilon_mul_omega, by rw [epsilon_mul_omega]; simp⟩

/-- One step of ordinary length among infinitesimal ones: the span is not infinitesimal. -/
theorem cessation_step_is_not_infinitesimal : ¬ Infinitesimal ((1 : ℝ*) + ε) := by
  intro h
  have h1 : stdPart ((1 : ℝ*) + ε) = 1 := by rw [stdPart_add_eq_left archimedeanClassMk_epsilon_pos]; simp
  have h0 : stdPart ((1 : ℝ*) + ε) = 0 := stdPart_eq_zero.mpr h.ne'
  rw [h0] at h1
  exact zero_ne_one h1

end FormalAbhidhamma.FO.Chain
