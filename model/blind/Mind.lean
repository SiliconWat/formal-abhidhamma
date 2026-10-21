namespace FormalAbhidhamma.Model

structure Scale where
  T : Type
  lt : T → T → Prop
  add : T → T → T
  zero : T
  lt_irrefl : ∀ a, ¬ lt a a
  lt_trans : ∀ a b c, lt a b → lt b c → lt a c
  lt_total : ∀ a b, lt a b ∨ a = b ∨ lt b a
  add_assoc : ∀ a b c, add (add a b) c = add a (add b c)
  add_comm : ∀ a b, add a b = add b a
  add_zero : ∀ a, add a zero = a
  add_lt_left : ∀ a b c, lt b c → lt (add a b) (add a c)

abbrev Z : Scale where
  T := Int
  lt := fun a b => a < b
  add := fun a b => a + b
  zero := 0
  lt_irrefl := fun a h => Int.lt_irrefl a h
  lt_trans := fun _ _ _ h₁ h₂ => Int.lt_trans h₁ h₂
  lt_total := fun a b => Int.lt_trichotomy a b
  add_assoc := Int.add_assoc
  add_comm := Int.add_comm
  add_zero := Int.add_zero
  add_lt_left := fun a _ _ h => Int.add_lt_add_left h a

structure Stream (S : Scale) where
  M : Type
  arise : M → S.T
  stand : M → S.T
  dissolve : M → S.T
  close : M → S.T
  prox : M → M → Prop

def a1_never_together (S : Scale) (s : Stream S) : Prop := ∀ m n, m ≠ n → ¬ S.lt (s.arise n) (s.close m) ∨ ¬ S.lt (s.arise m) (s.close n)

def a117_arising_and_dissolution (S : Scale) (s : Stream S) : Prop := ∀ m, S.lt (s.arise m) (s.dissolve m) ∧ S.lt (s.dissolve m) (s.close m)

def a40_three_equal (S : Scale) (s : Stream S) : Prop := ∀ m, ∃ d, S.lt S.zero d ∧ s.stand m = S.add (s.arise m) d ∧ s.dissolve m = S.add (s.stand m) d ∧ s.close m = S.add (s.dissolve m) d

def a3_no_moment_between (S : Scale) (s : Stream S) : Prop := ∀ m n, s.prox m n ↔ (S.lt (s.arise m) (s.arise n) ∧ ∀ k, ¬ (S.lt (s.arise m) (s.arise k) ∧ S.lt (s.arise k) (s.arise n)))

def c_every_citta_has_a_proximate (S : Scale) (s : Stream S) : Prop := ∀ n, ∃ m, s.prox m n

def a77_beginningless (S : Scale) (s : Stream S) : Prop := ∀ n, ∃ m, S.lt (s.arise m) (s.arise n)

end FormalAbhidhamma.Model
