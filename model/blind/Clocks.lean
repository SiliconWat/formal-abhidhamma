import Mind

namespace FormalAbhidhamma.Model

structure Reck (S R : Scale) where
  s : Stream S
  f : S.T → R.T
  cessation : s.M → Prop
  night : R.T
  week : R.T
  snap : R.T

def a7_reckoning_keeps_order (S R : Scale) (z : Reck S R) : Prop := ∀ a b, S.lt a b → ¬ R.lt (z.f b) (z.f a)

def a112_cessation_step (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m n, z.cessation m → z.s.prox m n →
    ¬ R.lt (z.f (z.s.arise n)) (R.add (z.f (z.s.close m)) z.night) ∧ ¬ R.lt (R.add (z.f (z.s.close m)) z.week) (z.f (z.s.arise n))

def a24_no_night (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m, R.lt (z.f (z.s.close m)) (R.add (z.f (z.s.arise m)) z.night)

def a24_rate (S R : Scale) (z : Reck S R) : Prop :=
  ∀ x, ∃ l : List z.s.M, l.Nodup ∧ 1000000000000 ≤ l.length ∧
    ∀ m ∈ l, ¬ R.lt (z.f (z.s.arise m)) x ∧ R.lt (z.f (z.s.arise m)) (R.add x z.snap)

abbrev reck (f : Int → Int) (cess : Nat → Prop) (night week snap : Int) : Reck Z Z :=
  { s := cchain, f := f, cessation := cess, night := night, week := week, snap := snap }

end FormalAbhidhamma.Model
