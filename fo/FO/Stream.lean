import Mathlib.ModelTheory.Ultraproducts
import Mathlib.Order.Filter.Ultrafilter.Basic
import Mathlib.Tactic.FinCases

/-!
# fo/FO/Stream.lean — the first-order layer: the stream's language, its rows as sentences, and the instrument's controls

Founder 2026-10-16 (*"yes"*): the stream axioms are written as first-order SENTENCES of Mathlib's model theory, so a
sentence cannot say "finitely many" by its TYPE, and Łoś's theorem (`Ultraproduct.sentence_realize`) carries every
sentence true in a structure to its ultrapower. *The Calculus of Moments*, amendment 2 §2 (Q2′); a separate Lake
package on Mathlib v4.34.1, so the core encoding (`model/`) stays plain Lean with no Mathlib.

⛔ **No model of the texts' rows is built here.** Protocol 1 forbids any model search before Protocol 2 freezes the
encoding. This file holds (1) the language, (2) the rows as sentences, defined only, and (3) the instrument tested on
a structure the texts FORBID (the natural numbers: a stream with a first moment, `first_citta` in `model/Mind.lean`).

The translation is OURS: `before m n` reads the core's `S.lt (s.arise m) (s.arise n)`, and `prox` is the core's
`s.prox`. That each sentence says what its core definition says is owed to Protocol 2 (a meaning lemma per row).
-/

namespace FormalAbhidhamma.FO

open FirstOrder FirstOrder.Language Filter

/-- The relation symbols: `before m n` (m arises before n) and `prox m n` (m conditions n by proximity). -/
inductive Rel : ℕ → Type
  | before : Rel 2
  | prox : Rel 2

/-- The stream's language: two binary relations, no function symbols, no constants. -/
def L : Language := ⟨fun _ => Empty, Rel⟩

/-- `before` between the bound variables `i` and `j`. -/
def bef {n : ℕ} (i j : Fin n) : L.BoundedFormula Empty n :=
  Relations.boundedFormula₂ (show L.Relations 2 from Rel.before) (&i) (&j)

/-- `prox` between the bound variables `i` and `j`. -/
def prx {n : ℕ} (i j : Fin n) : L.BoundedFormula Empty n :=
  Relations.boundedFormula₂ (show L.Relations 2 from Rel.prox) (&i) (&j)

/-! ## The rows as sentences (defined only; no model). Bound variables are numbered outermost first. -/

/-- The arising order is a strict total order (OURS: the core reads the order from the clock; A1 makes it total). -/
def irrefl : L.Sentence := ∀' ∼(bef 0 0)
def trans : L.Sentence := ∀' ∀' ∀' ((bef 0 1 ⊓ bef 1 2) ⟹ bef 0 2)
def total : L.Sentence := ∀' ∀' (bef 0 1 ⊔ ((&0 =' &1) ⊔ bef 1 0))

/-- A3: m conditions n by proximity exactly when n arises after m and no moment arises between them. -/
def a3 : L.Sentence := ∀' ∀' (prx 0 1 ⇔ (bef 0 1 ⊓ ∼(∃' (bef 0 2 ⊓ bef 2 1))))

/-- C: every citta has an immediate predecessor that conditions it by proximity. -/
def c_row : L.Sentence := ∀' ∃' prx 1 0

/-- A77: the round is beginningless — before any moment, an earlier one arises. -/
def a77 : L.Sentence := ∀' ∃' bef 1 0

/-- The stream rows the core encodes so far (`model/Mind.lean`: A3 · C · A77, with the order they read). -/
def streamRows : L.Theory := {irrefl, trans, total, a3, c_row, a77}

/-! ## The instrument and its controls — on the natural numbers, a structure the texts forbid -/

/-- `before` as a Lean predicate on any structure for `L`. -/
def Before (M : Type) [L.Structure M] (a b : M) : Prop :=
  Structure.RelMap (show L.Relations 2 from Rel.before) ![a, b]

/-- The natural numbers as an `L`-structure: `before` is `<`, `prox` is "the next number". -/
instance natStructure : L.Structure ℕ where
  funMap := fun {_} f => Empty.elim f
  RelMap := fun {n} r xs =>
    match n, r, xs with
    | _, Rel.before, xs => xs 0 < xs 1
    | _, Rel.prox, xs => xs 1 = xs 0 + 1

/-- The ultrapower of the natural numbers over the hyperfilter (the ultrafilter extending the cofinite filter). -/
abbrev Star : Type := (↑(hyperfilter ℕ) : Filter ℕ).Product (fun _ : ℕ => ℕ)

/-- The class of a sequence in the ultrapower. -/
noncomputable def cls (f : ℕ → ℕ) : Star := @Quotient.mk' _ ((hyperfilter ℕ : Filter ℕ).productSetoid (fun _ : ℕ => ℕ)) f

instance : Nonempty Star := ⟨cls fun _ => 0⟩

/-- `before` in the ultrapower holds of two sequences exactly when it holds at almost every index. -/
theorem before_star (f g : ℕ → ℕ) :
    Before Star (cls f) (cls g) ↔ ∀ᶠ n in (hyperfilter ℕ : Filter ℕ), f n < g n := by
  have e : (![cls f, cls g] : Fin 2 → Star) = fun i => cls (![f, g] i) := by
    funext i; fin_cases i <;> rfl
  unfold Before
  rw [e]
  exact relMap_quotient_mk' (L := L) (s := (hyperfilter ℕ : Filter ℕ).productSetoid (fun _ : ℕ => ℕ))
    (show L.Relations 2 from Rel.before) ![f, g]

/-- (+) CONTROL — the instrument sees a presence: the ultrapower has a moment with infinitely many moments before it
    (the class of the identity sequence; every constant class lies before it, and they are all distinct). -/
theorem star_has_infinitely_many_before : ∃ b : Star, Set.Infinite {a : Star | Before Star a b} := by
  refine ⟨cls id, ?_⟩
  have hinj : Function.Injective (fun k : ℕ => cls (fun _ : ℕ => k)) := by
    intro j k hjk
    have : ∀ᶠ _n in (hyperfilter ℕ : Filter ℕ), j = k :=
      Quotient.exact (s := (hyperfilter ℕ : Filter ℕ).productSetoid (fun _ : ℕ => ℕ)) hjk
    exact this.exists.choose_spec
  refine Set.infinite_of_injective_forall_mem hinj fun k => ?_
  show Before Star (cls fun _ => k) (cls id)
  rw [before_star]
  refine mem_hyperfilter_of_finite_compl ?_
  show ({n : ℕ | k < n})ᶜ.Finite
  have : ({n : ℕ | k < n} : Set ℕ)ᶜ = {n | n ≤ k} := by ext n; simp
  rw [this]; exact Set.finite_le_nat k

/-- (−) CONTROL — the same instrument sees an absence: in the natural numbers every moment has finitely many before it. -/
theorem nat_finitely_many_before (b : ℕ) : Set.Finite {a : ℕ | Before ℕ a b} := by
  have : {a : ℕ | Before ℕ a b} = {a | a < b} := by ext a; rfl
  rw [this]; exact Set.finite_lt_nat b

/-- Transfer, for the constant ultrapower: the ultrapower and the natural numbers satisfy the same sentences. -/
theorem star_iff_nat (φ : L.Sentence) : Star ⊨ φ ↔ ℕ ⊨ φ := by
  rw [Ultraproduct.sentence_realize]
  exact eventually_const

/-- ⭐ **"Finitely many" is not first-order in the stream's language.** No sentence holds in exactly the structures in
    which every moment has finitely many moments before it: the natural numbers satisfy that property and the
    ultrapower does not, yet by Łoś they satisfy the same sentences. So a row that says "finitely many" can never be a
    `L.Sentence` — a property of the TYPE, which is why amendment 2's audit can be mechanical. -/
theorem finitely_many_before_is_not_first_order :
    ¬ ∃ φ : L.Sentence, ∀ (M : Type) [L.Structure M] [Nonempty M],
      (M ⊨ φ ↔ ∀ b : M, Set.Finite {a : M | Before M a b}) := by
  rintro ⟨φ, hφ⟩
  have hN : ℕ ⊨ φ := (hφ ℕ).2 nat_finitely_many_before
  have hS : Star ⊨ φ := (star_iff_nat φ).2 hN
  obtain ⟨b, hb⟩ := star_has_infinitely_many_before
  exact hb ((hφ Star).1 hS b)

end FormalAbhidhamma.FO
