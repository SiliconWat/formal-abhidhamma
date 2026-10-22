/-
  model/Join.lean — the JOIN of COND and MIND: a conditioning world's occurrences, where they are cittas, ARE moments of a stream, and the
  condition of proximity (*anantara*) holds exactly between a moment and the moment that is its proximate successor in that stream.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything.

  A `Joined` world is a `CondW` (Cond.lean) with a stream (Mind.lean) and a partial map `mom` from occurrence indices to the stream's moments. An
  occurrence with no moment is matter (or a mind-state of no stream the world models). Rows: A3 and C, as conditioning facts — the
  proximity condition is the stream's own successor relation (`prox`), not a free relation — and C's second clause, that matter does
  not arise by proximity (a proximity fact never ends in matter, from Cond's A78).
-/
import Cond
namespace FormalAbhidhamma.Model
open FormalAbhidhamma.Relata

/-- A conditioning world with a stream; `mom i` is the moment occurrence i is, when it is a citta. -/
structure Joined (S : Scale) where
  w : CondW S
  s : Stream S
  mom : Nat → Option s.M

/-- The occurrence carries its moment's own clock readings: it arises when the moment arises and ceases when the moment closes. -/
def j_readings_are_the_moments (S : Scale) (j : Joined S) : Prop :=
  ∀ i m a, j.mom i = some m → j.w.occs[i]? = some a → a.kind = .nama ∧ a.rise = j.s.arise m ∧ a.fall = j.s.close m

/-- A3 and C as conditioning facts (L1/L2): proximity holds from one occurrence to another exactly when they are moments of the stream and the
    second is the first's proximate successor. So every moment's predecessor conditions it (C), and nothing else does by proximity. -/
def a3_proximity_is_the_streams_prox (S : Scale) (j : Joined S) : Prop :=
  ∀ i k, (Condition.anantara, i, k) ∈ j.w.holds ↔ ∃ m n, j.mom i = some m ∧ j.mom k = some n ∧ j.s.prox m n

/-! ## Forbidden worlds (whole-number scale) -/

/-- The chain of moments (arise 4n, close 4n + 3) and a world with an occurrence for each of the first three. -/
abbrev jstream : Stream Z :=
  ⟨Nat, fun n => (4 * n : Int), fun n => (4 * n + 1 : Int), fun n => (4 * n + 2 : Int), fun n => (4 * n + 3 : Int), fun m n => n = m + 1⟩
abbrev joccs : List (Occ Z) := [⟨.nama, 0, 3, 0, none, none, none, none⟩, ⟨.nama, 4, 7, 1, none, none, none, none⟩, ⟨.nama, 8, 11, 2, none, none, none, none⟩]
abbrev jw (h : List (Condition × Nat × Nat)) : Joined Z := { w := ⟨joccs, h⟩, s := jstream, mom := fun i => some i }

/-- A proximity fact between a moment and the moment after the next (0 to 2). -/
abbrev skipsOne : Joined Z := jw [(.anantara, 0, 2)]
theorem a3_forbids_skipsOne : ¬ a3_proximity_is_the_streams_prox Z skipsOne := by
  intro h
  obtain ⟨m, n, hm, hn, hp⟩ := (h 0 2).mp (by simp [skipsOne, jw])
  simp [skipsOne, jw] at hm hn
  subst hm; subst hn; simp at hp

/-- A moment that is another's proximate successor with no proximity fact between them (1 follows 0). -/
abbrev missingFact : Joined Z := jw []
theorem a3_forbids_missingFact : ¬ a3_proximity_is_the_streams_prox Z missingFact := by
  intro h
  have := (h 0 1).mpr ⟨0, 1, rfl, rfl, rfl⟩
  simp [missingFact, jw] at this

/-- An occurrence that is the stream's moment 0 but arises at the wrong reading (1, not 0). -/
abbrev wrongReading : Joined Z :=
  { w := ⟨[⟨.nama, 1, 3, 0, none, none, none, none⟩], []⟩, s := jstream, mom := fun _ => some 0 }
theorem j_forbids_wrongReading : ¬ j_readings_are_the_moments Z wrongReading := by
  intro h
  have := (h 0 0 _ rfl rfl).2.1
  simp at this

/-- A3 and C, the labels (refuter 2, finding 3): two mind occurrences carry one `cit` label exactly when they are one and the same moment of the stream. -/
def a3_cit_labels_are_moments (S : Scale) (j : Joined S) : Prop :=
  ∀ i k a b m n, j.w.occs[i]? = some a → j.w.occs[k]? = some b → j.mom i = some m → j.mom k = some n → (a.cit = b.cit ↔ m = n)

/-- A3 and C, no moment without an occurrence (refuter 2, finding 3): every moment of the stream is some occurrence of the world. -/
def a3_every_moment_has_an_occurrence (S : Scale) (j : Joined S) : Prop := ∀ m, ∃ i, i < j.w.occs.length ∧ j.mom i = some m

/-- Two different moments given the same label. -/
abbrev sameLabel : Joined Z :=
  { w := ⟨[⟨.nama, 0, 3, 7, none, none, none, none⟩, ⟨.nama, 4, 7, 7, none, none, none, none⟩], []⟩, s := jstream, mom := fun i => some i }
theorem a3_forbids_sameLabel : ¬ a3_cit_labels_are_moments Z sameLabel := by
  intro h
  have := (h 0 1 _ _ 0 1 rfl rfl rfl rfl).mp rfl
  exact absurd this (by decide)

/-- The stream has more moments than the world has occurrences. -/
theorem a3_forbids_unreachedMoment : ¬ a3_every_moment_has_an_occurrence Z missingFact := by
  intro h
  obtain ⟨i, hi, hm⟩ := h 5
  simp [missingFact, jw] at hi hm
  omega

end FormalAbhidhamma.Model
