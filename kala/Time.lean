/-
  Kāla — time as a designation on one stream's order, the space between matter, and the end of a
  stream. Formalizes the 2026-09-30 thread (memory §abhidhamma-mode). EXPLORATORY: this file is NOT
  covered by PREREGISTRATION.md, which fixed the counts check only.

  Tiers (spelled out, never [C]/[S]):
    A1  one mind-moment at a time in a stream ............ commentarial exposition
    A3  anantara: each moment conditions its successor ... Piṭaka (Paṭṭhāna, condition 4)
    A4  matter lasts 17 mind-moments ..................... commentarial
    K   the last kamma-born matter arises at the 17th
        moment before death, counting death, and ceases
        with it ...................................... commentarial
    C   conditionality: every moment has a predecessor ... Paṭṭhāna (anantara) + Vism XVII §584
    The model (Stream, Kalapa, Object) is ours. A proof assistant checks that conclusions follow from
    these definitions; it says nothing about whether nature agrees.
-/
namespace FormalAbhidhamma.Kala

/-- A stream (*santāna*): its mind-moments, the immediate-successor map σ (partial: the arahant's
    final moment conditions nothing), and a clock τ. τ is the designation (*kāla-paññatti*): a function
    ON the moments, never itself a moment — so time and mind share a shape and are not one thing. -/
structure Stream where
  Moment : Type
  succ : Moment → Option Moment
  tick : Moment → Int
  tick_succ : ∀ m n, succ m = some n → tick n = tick m + 1
  one_at_a_time : ∀ a b, tick a = tick b → a = b                    -- A1
  continues : ∀ m m', tick m < tick m' → ∃ n, succ m = some n        -- A3: a later moment means m conditions a next

/-- I. Succession is gapless: nothing lies between a moment and its successor. -/
theorem gapless (s : Stream) (m n : s.Moment) (h : s.succ m = some n) :
    ¬ ∃ x : s.Moment, s.tick m < s.tick x ∧ s.tick x < s.tick n := by
  intro ⟨x, h1, h2⟩
  have := s.tick_succ m n h
  omega

/-- II. Mind has no between: a between needs two things present at once, and a stream is never two
    at once. Follows from A1 alone. -/
theorem mind_has_no_between (s : Stream) (t : Int) :
    ¬ ∃ a b : s.Moment, a ≠ b ∧ s.tick a = t ∧ s.tick b = t := by
  intro ⟨a, b, hne, ha, hb⟩
  exact hne (s.one_at_a_time a b (by rw [ha, hb]))

/-- A cluster of concretely produced matter (*nipphanna kalāpa*), dated on the mind clock. -/
structure Kalapa where
  birth : Int

def lifespan : Int := 17                                                   -- A4

def Kalapa.present (k : Kalapa) (t : Int) : Prop := k.birth ≤ t ∧ t < k.birth + lifespan

/-- Delimiting space (*paricchedarūpa*) between two clusters. It is *anipphanna*: it has no birth
    of its own, and is present exactly when both neighbours are. -/
def between (k₁ k₂ : Kalapa) (t : Int) : Prop := k₁.present t ∧ k₂.present t

/-- II. Matter can have a between: two distinct clusters co-present. (The asymmetry's other half —
    without this witness, `mind_has_no_between` would contrast with nothing.) -/
theorem matter_can_have_a_between : ∃ k₁ k₂ : Kalapa, k₁ ≠ k₂ ∧ between k₁ k₂ 5 := by
  refine ⟨⟨0⟩, ⟨5⟩, ?_, ?_⟩
  · intro h; injection h with h; omega
  · simp only [between, Kalapa.present, lifespan]; omega

/-- III. Parinibbāna, for one stream: nothing is reckoned after a moment that conditions no next. -/
theorem no_time_after_the_last_moment (s : Stream) (last : s.Moment) (h : s.succ last = none) :
    ¬ ∃ m : s.Moment, s.tick last < s.tick m := by
  intro ⟨m, hm⟩
  obtain ⟨n, hn⟩ := s.continues last m hm
  rw [h] at hn
  cases hn

/-- III. The stream's space ends with it: if the last kamma-born matter arises no later than the
    17th moment before death, counting death (K), no between survives past death at N.
    ⭐ Lean found that ONE neighbour's bound suffices (the first build flagged the second as unused):
    a between is present only while BOTH neighbours are, so it ends when EITHER does. -/
theorem space_ends_with_the_stream (N : Int) (k₁ k₂ : Kalapa) (h₁ : k₁.birth ≤ N - 16) :
    ∀ t, N < t → ¬ between k₁ k₂ t := by
  intro t ht ⟨⟨_, a⟩, _⟩
  simp only [lifespan] at a
  omega

/-- Conditionality (C): every mind-moment has an immediate predecessor that conditions it. -/
def Conditioned (s : Stream) : Prop := ∀ m, ∃ p, s.succ p = some m

/-- Run 2's derivation: a conditioned stream has no first moment. A first moment would be a dhamma
    with no condition. (SN 15's own wording is epistemic — "not discerned"; this is what the
    conditionality axiom adds.) -/
theorem beginningless (s : Stream) (hc : Conditioned s) :
    ¬ ∃ first : s.Moment, ∀ m, s.tick first ≤ s.tick m := by
  intro ⟨f, hf⟩
  obtain ⟨p, hp⟩ := hc f
  have h1 := s.tick_succ p f hp
  have h2 := hf p
  omega

/-- What a mind-moment takes as its object: a conditioned dhamma, or nibbāna. -/
inductive Object (M : Type) where
  | dhamma : M → Object M
  | nibbana : Object M

/-- III. Nibbāna is never a moment: it can be the OBJECT of a moment (the path-moment), and it is
    not in the domain of any clock. ⚠️ This holds BY CONSTRUCTION — the type does the work. That is
    the honest content of "not produced" here: the model has no way to build nibbāna from moments. -/
theorem nibbana_is_not_a_moment {M : Type} (m : M) : (Object.nibbana : Object M) ≠ Object.dhamma m := by
  intro h
  cases h

/-! ## The control: the axioms are satisfiable (a model), so no theorem above is vacuous.
    An arahant's stream, order type ω*: moments …, −2, −1, 0; the moment 0 conditions nothing. -/

def arSucc (m : {i : Int // i ≤ 0}) : Option {i : Int // i ≤ 0} :=
  if h : m.val < 0 then some ⟨m.val + 1, by omega⟩ else none

def arahant : Stream where
  Moment := {i : Int // i ≤ 0}
  succ := arSucc
  tick m := m.val
  tick_succ := by
    intro m n h
    unfold arSucc at h
    by_cases hm : m.val < 0
    · rw [dite_eq_left hm] at h
      cases h
      rfl
    · rw [dite_eq_right hm] at h
      cases h
  one_at_a_time := by
    intro a b h
    exact Subtype.ext h
  continues := by
    intro m m' h
    change m.val < m'.val at h
    have hm : m.val < 0 := by have := m'.property; omega
    exact ⟨⟨m.val + 1, by omega⟩, by unfold arSucc; rw [dite_eq_left hm]⟩

theorem arahant_is_conditioned : Conditioned arahant := by
  intro m
  have hlt : m.val - 1 < 0 := by have := m.property; omega
  refine ⟨⟨m.val - 1, by omega⟩, ?_⟩
  change arSucc ⟨m.val - 1, _⟩ = some m
  unfold arSucc
  rw [dite_eq_left hlt]
  congr 1
  exact Subtype.ext (by simp)

theorem arahant_ends : arahant.succ ⟨0, by decide⟩ = none := by
  change arSucc ⟨0, by decide⟩ = none
  unfold arSucc
  rw [dite_eq_right (by decide)]

/-- The model has a final moment AND no first one: ends without having begun. -/
example : ¬ ∃ m : arahant.Moment, arahant.tick ⟨0, by decide⟩ < arahant.tick m :=
  no_time_after_the_last_moment arahant ⟨0, by decide⟩ arahant_ends
example : ¬ ∃ first : arahant.Moment, ∀ m, arahant.tick first ≤ arahant.tick m :=
  beginningless arahant arahant_is_conditioned

end FormalAbhidhamma.Kala
