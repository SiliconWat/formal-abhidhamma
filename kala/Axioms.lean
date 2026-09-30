/-
  Axioms.lean — the Lean side of AXIOMS.md (the one home). IDs in comments match that file.
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

/-- A cluster of concretely produced matter (*nipphanna kalāpa*), dated on the mind clock. -/
structure Kalapa where
  birth : Int

def lifespan : Int := 17                                                   -- A4

def Kalapa.present (k : Kalapa) (t : Int) : Prop := k.birth ≤ t ∧ t < k.birth + lifespan

/-- Delimiting space (*paricchedarūpa*) between two clusters. It is *anipphanna*: it has no birth
    of its own, and is present exactly when both neighbours are. -/
def between (k₁ k₂ : Kalapa) (t : Int) : Prop := k₁.present t ∧ k₂.present t

/-- Conditionality (C): every mind-moment has an immediate predecessor that conditions it. -/
def Conditioned (s : Stream) : Prop := ∀ m, ∃ p, s.succ p = some m

/-- What a mind-moment takes as its object: a conditioned dhamma, or nibbāna. -/
inductive Object (M : Type) where
  | dhamma : M → Object M
  | nibbana : Object M

end FormalAbhidhamma.Kala
