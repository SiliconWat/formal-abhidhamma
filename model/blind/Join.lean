import Cond

namespace FormalAbhidhamma.Model

open FormalAbhidhamma.Relata

structure Joined (S : Scale) where
  w : CondW S
  s : Stream S
  mom : Nat → Option s.M

def j_readings_are_the_moments (S : Scale) (j : Joined S) : Prop :=
  ∀ i m a, j.mom i = some m → j.w.occs[i]? = some a → a.kind = .nama ∧ a.rise = j.s.arise m ∧ a.fall = j.s.close m

def a3_proximity_is_the_streams_prox (S : Scale) (j : Joined S) : Prop :=
  ∀ i k, (Condition.anantara, i, k) ∈ j.w.holds ↔ ∃ m n, j.mom i = some m ∧ j.mom k = some n ∧ j.s.prox m n

abbrev joccs : List (Occ Z) := [⟨.nama, 0, 3, 0, none, none, none⟩, ⟨.nama, 4, 7, 1, none, none, none⟩, ⟨.nama, 8, 11, 2, none, none, none⟩]

abbrev jw (h : List (Condition × Nat × Nat)) : Joined Z := { w := ⟨joccs, h⟩, s := jstream, mom := fun i => some i }

end FormalAbhidhamma.Model
