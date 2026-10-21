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

inductive StepsFree {M : Type} (blocked : M → Prop) (prox : M → M → Prop) : Nat → M → M → Prop
  | zero (m : M) : StepsFree blocked prox 0 m m
  | succ {n : Nat} {m a b : M} : StepsFree blocked prox n m a → prox a b → ¬ blocked a → StepsFree blocked prox (n + 1) m b

def a24_rate (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m n, StepsFree z.cessation z.s.prox 1000000000000 m n → R.lt (z.f (z.s.arise n)) (R.add (z.f (z.s.arise m)) z.snap)

def a112_night_week_order (S R : Scale) (z : Reck S R) : Prop := R.lt R.zero z.snap ∧ R.lt z.snap z.night ∧ ¬ R.lt z.week z.night

def a47_unbroken_on_the_clock (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m n, ¬ z.cessation m → z.s.prox m n → ¬ R.lt (z.f (z.s.close m)) (z.f (z.s.arise n))

abbrev reck (f : Int → Int) (cess : Nat → Prop) (night week snap : Int) : Reck Z Z :=
  { s := cchain, f := f, cessation := cess, night := night, week := week, snap := snap }

end FormalAbhidhamma.Model
