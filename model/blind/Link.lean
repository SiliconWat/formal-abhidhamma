import Mind

import Tax

namespace FormalAbhidhamma.Model

open FormalAbhidhamma

inductive Phase | arise | stand | dissolve deriving DecidableEq, Repr

structure Link (S : Scale) where
  s : Stream S
  K : Type
  origin : K → Origin
  mom : K → s.M
  phase : K → Phase
  rebirth : s.M → Prop
  produces : s.M → Prop
  embodied : s.M → Prop
  
  death : s.M → Prop := fun _ => False
  
  concrete : K → Bool := fun _ => true
  
  ceaseMom : K → s.M
  ceasePhase : K → Phase
  
  cessation : s.M → Prop := fun _ => False
  
  parinibbana : s.M → Prop := fun _ => False
  fruition : s.M → Prop := fun _ => False
  
  sense : s.M → Prop := fun _ => False
  base : s.M → Option K := fun _ => none
  object : s.M → Option K := fun _ => none

inductive Steps {M : Type} (prox : M → M → Prop) : Nat → M → M → Prop
  | zero (m : M) : Steps prox 0 m m
  | succ {n : Nat} {m a b : M} : Steps prox n m a → prox a b → Steps prox (n + 1) m b

def a120_mind_born_at_arising (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.phase k = .arise

def a120_kamma_born_at_all_three (S : Scale) (l : Link S) : Prop :=
  ∀ m, l.embodied m → (¬ ∃ d n, l.death d ∧ n ≤ 16 ∧ Steps l.s.prox n m d) → ∀ p : Phase, ∃ k, l.origin k = .kamma ∧ l.mom k = m ∧ l.phase k = p

def a118_core (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.phase k ≠ .dissolve

def a64_kamma_from_rebirth (S : Scale) (l : Link S) : Prop :=
  ∀ k, l.origin k = .kamma → ∃ r, l.rebirth r ∧ (r = l.mom k ∨ S.lt (l.s.arise r) (l.s.arise (l.mom k)))

def a67_mind_born_not_at_rebirth (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → ¬ l.rebirth (l.mom k)

def a64_mind_born_only_by_producers (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.produces (l.mom k)

def a64_phases (S : Scale) (l : Link S) : Prop :=
  ∀ k, (l.origin k = .citta → l.phase k = .arise) ∧ (l.origin k = .utu → l.phase k = .stand) ∧ (l.origin k = .ahara → l.phase k = .stand)

def a4_life_in_the_stream (S : Scale) (l : Link S) : Prop :=
  ∀ k, l.concrete k = true →
    (l.phase k = .arise → (Steps l.s.prox 16 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .dissolve) ∨ ¬ ∃ n, Steps l.s.prox 16 (l.mom k) n) ∧
    (l.phase k = .stand → (Steps l.s.prox 17 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .arise) ∨ ¬ ∃ n, Steps l.s.prox 17 (l.mom k) n) ∧
    (l.phase k = .dissolve → (Steps l.s.prox 17 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .stand) ∨ ¬ ∃ n, Steps l.s.prox 17 (l.mom k) n)

def k_kamma_born_stops (S : Scale) (l : Link S) : Prop :=
  ∀ d b, l.death d → Steps l.s.prox 16 b d → ∀ k, l.origin k = .kamma →
    ¬ (l.mom k = b ∧ l.phase k ≠ .arise) ∧ ∀ n, 1 ≤ n → n ≤ 16 → ¬ Steps l.s.prox n b (l.mom k)

abbrev one (o : Origin) (p : Phase) (rb pr em : Prop) : Link Z :=
  { s := ⟨Unit, fun _ => (0 : Int), fun _ => (1 : Int), fun _ => (2 : Int), fun _ => (3 : Int), fun _ _ => False⟩,
    K := Unit, origin := fun _ => o, mom := fun _ => (), phase := fun _ => p,
    rebirth := fun _ => rb, produces := fun _ => pr, embodied := fun _ => em, ceaseMom := fun _ => (), ceasePhase := fun _ => .dissolve }

abbrev chainLink (o : Origin) (m : Nat) (p : Phase) (cm : Nat) (cp : Phase) (dm : Nat) : Link Z :=
  { s := chain, K := Unit, origin := fun _ => o, mom := fun _ => m, phase := fun _ => p,
    rebirth := fun _ => False, produces := fun _ => True, embodied := fun _ => True,
    death := fun d => d = dm, ceaseMom := fun _ => cm, ceasePhase := fun _ => cp }

def Phase.at (S : Scale) (s : Stream S) (m : s.M) : Phase → S.T
  | .arise => s.arise m | .stand => s.stand m | .dissolve => s.dissolve m

def k_ceases_with_death (S : Scale) (l : Link S) : Prop :=
  ∀ d b, l.death d → Steps l.s.prox 16 b d → ∀ k, l.origin k = .kamma →
    ¬ S.lt (l.s.stand b) (Phase.at S l.s (l.mom k) (l.phase k)) →
    ¬ S.lt (Phase.at S l.s (l.ceaseMom k) (l.ceasePhase k)) (l.s.stand b) → l.ceaseMom k = d

def k_mind_nutriment_stop (S : Scale) (l : Link S) : Prop :=
  ∀ d, l.death d → ∀ k, (l.origin k = .citta ∨ l.origin k = .ahara) → ¬ S.lt (l.s.arise d) (Phase.at S l.s (l.mom k) (l.phase k))

def present_at_arising (S : Scale) (l : Link S) (k : l.K) (m : l.s.M) : Prop :=
  S.lt (l.phase k |>.at S l.s (l.mom k)) (l.s.arise m) ∧ ¬ S.lt (l.ceasePhase k |>.at S l.s (l.ceaseMom k)) (l.s.arise m)

def a116_prenascent_unceased_base (S : Scale) (l : Link S) : Prop :=
  ∀ m, l.sense m → ∃ k, l.base m = some k ∧ present_at_arising S l k m

def a87_organ_and_object_already_arisen (S : Scale) (l : Link S) : Prop :=
  ∀ m, l.sense m → (∃ k, l.base m = some k ∧ present_at_arising S l k m) ∧ (∃ k, l.object m = some k ∧ present_at_arising S l k m)

def a122_death_then_rebirth (S : Scale) (l : Link S) : Prop := ∀ d n, l.death d → l.s.prox d n → l.rebirth n

def a122_rebirth_after_death (S : Scale) (l : Link S) : Prop := ∀ r, l.rebirth r → ∃ d, l.death d ∧ l.s.prox d r

def a58_begins_with_rebirth (S : Scale) (l : Link S) : Prop := ∀ m, ∃ r, l.rebirth r ∧ (r = m ∨ S.lt (l.s.arise r) (l.s.arise m))

def a47_unbroken (S : Scale) (l : Link S) : Prop := ∀ m, ¬ l.death m → ∃ n, l.s.prox m n

def a111_emerges_by_fruition (S : Scale) (l : Link S) : Prop := ∀ m n, l.cessation m → l.s.prox m n → l.fruition n

def a111_no_death_within (S : Scale) (l : Link S) : Prop := ∀ m n, l.cessation m → l.s.prox m n → ¬ l.death m ∧ ¬ l.death n

def a111_life_persists (S : Scale) (l : Link S) : Prop := ∀ m, l.cessation m → l.embodied m ∧ ¬ l.parinibbana m

def a56_death_followed_unless_final (S : Scale) (l : Link S) : Prop := ∀ d, l.death d → ¬ l.parinibbana d → ∃ n, l.s.prox d n

def a56_final_ends (S : Scale) (l : Link S) : Prop := ∀ d, l.parinibbana d → l.death d ∧ ∀ n, ¬ l.s.prox d n

end FormalAbhidhamma.Model
