/-
  model/Link.lean — the MIND link of MAT: matter placed in a stream, by the mind-moment and the sub-moment at which it
  arises. FIRST BATCH (2026-10-20): A120 and A118's common core (which sub-moments mind-born matter may arise at) · A64
  and A67 (kamma-born matter from rebirth-linking on; mind-born matter not at the rebirth-linking citta; which cittas
  produce matter). Not yet: K (the death count is OURS: A4's 17 with "ceases with the death citta" makes it include the death
  citta, a DECLARED CHOICE the founder owes) · A4 in stream terms (the same counting choice) · A118's literal scope (a VARIANT).
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model, and no world
  here satisfies the rows (each world below is FORBIDDEN).

  A `Link` is a stream (Mind.lean, any clock scale, any type of moments) with occurrences of matter. Each occurrence has an
  origin (Tax.lean), the mind-moment at which it arises, and which of that moment's three sub-moments. Nothing here fixes
  whether the stream is discrete (Q1) or standard (Q2); the proximity relation is the stream's.
  `rebirth m`: m is a rebirth-linking citta. `produces m`: m is a citta that can produce matter (A64 excludes the immaterial
  resultants and the ten sense-consciousnesses; WHICH moments those are is the PROC/TAX link's). `embodied m`: the being
  whose moment m is has matter (A13: the immaterial have none).

  Q2′ (amendment 2): these definitions quantify over the stream's moments and occurrences and compare readings of the clock
  with `lt`; the audit marks them first-order in form, except A64's "at or before" reading of rebirth, which is a
  disjunction over the order and stays first-order.
-/
import Mind
import Tax
namespace FormalAbhidhamma.Model
open FormalAbhidhamma

/-- The three sub-moments of a mind-moment (A40). -/
inductive Phase | arise | stand | dissolve deriving DecidableEq, Repr

/-- Matter placed in a stream. -/
structure Link (S : Scale) where
  s : Stream S
  K : Type
  origin : K → Origin
  mom : K → s.M
  phase : K → Phase
  rebirth : s.M → Prop
  produces : s.M → Prop
  embodied : s.M → Prop

/-- A120 (L2/L3/L5, `kala/AXIOMS.md`; Vism XX §700 `e0102n.mul.xml`): mind-born matter arises only at a citta's arising sub-moment
    (*nāpi ṭhitikkhaṇe vā bhaṅgakkhaṇe vā uppajjati*). -/
def a120_mind_born_at_arising (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.phase k = .arise

/-- A120, the other half: kamma-born matter arises at all three sub-moments of every citta of an embodied being (*tīsu tīsu
    khaṇesu*, Buddhaghosa's own voice). -/
def a120_kamma_born_at_all_three (S : Scale) (l : Link S) : Prop :=
  ∀ m, l.embodied m → ∀ p : Phase, ∃ k, l.origin k = .kamma ∧ l.mom k = m ∧ l.phase k = p

/-- A118, the COMMON CORE (Protocol 1 correction 1): in the course of existence no mind-born matter arises at a citta's
    dissolution-moment. ⛔ The literal scope (no matter at all, Ānanda) and the formless-only scope (the *apare*) are VARIANTS and
    are not encoded here; never with A120 at base. -/
def a118_core (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.phase k ≠ .dissolve

/-- A64 (L4, ch. 6 §29–36, `abh07t.nrf.xml:2189`): kamma produces matter from rebirth-linking on — every kamma-born occurrence arises at a
    rebirth-linking citta or after one. -/
def a64_kamma_from_rebirth (S : Scale) (l : Link S) : Prop :=
  ∀ k, l.origin k = .kamma → ∃ r, l.rebirth r ∧ (r = l.mom k ∨ S.lt (l.s.arise r) (l.s.arise (l.mom k)))

/-- A64 and A67 (L4, `:2193`, `abh07t.nrf.xml:2321–2329`): mind-born matter arises from the first bhavaṅga on — never at the rebirth-linking
    citta itself (A67: from the second citta). -/
def a67_mind_born_not_at_rebirth (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → ¬ l.rebirth (l.mom k)

/-- A64 (L4, `:2197`): only cittas that produce matter produce it (all but the immaterial resultants and the ten sense-consciousnesses). -/
def a64_mind_born_only_by_producers (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.produces (l.mom k)

/-! ## Forbidden worlds (whole-number scale; one occurrence each) -/

/-- One moment 0 (arise 0, stand 1, dissolve 2, close 3); one occurrence at moment 0 with origin o and phase p. -/
abbrev one (o : Origin) (p : Phase) (rb pr em : Prop) : Link Z :=
  { s := ⟨Unit, fun _ => (0 : Int), fun _ => (1 : Int), fun _ => (2 : Int), fun _ => (3 : Int), fun _ _ => False⟩,
    K := Unit, origin := fun _ => o, mom := fun _ => (), phase := fun _ => p,
    rebirth := fun _ => rb, produces := fun _ => pr, embodied := fun _ => em }

/-- Mind-born matter arising at a citta's standing sub-moment. -/
abbrev mindBornStanding : Link Z := one .citta .stand False True True
theorem a120_forbids_mindBornStanding : ¬ a120_mind_born_at_arising Z mindBornStanding := by
  intro h; have := h () rfl; exact absurd this (by decide)

/-- An embodied citta whose standing sub-moment has no kamma-born matter (only an arising one). -/
abbrev kammaOnlyAtArising : Link Z := one .kamma .arise True True True
theorem a120_forbids_kammaOnlyAtArising : ¬ a120_kamma_born_at_all_three Z kammaOnlyAtArising := by
  intro h; obtain ⟨k, _, _, hp⟩ := h () trivial Phase.stand; cases hp

/-- Mind-born matter arising at a citta's dissolution-moment. -/
abbrev mindBornDissolving : Link Z := one .citta .dissolve False True True
theorem a118_forbids_mindBornDissolving : ¬ a118_core Z mindBornDissolving := by
  intro h; exact h () rfl rfl

/-- Kamma-born matter in a stream with no rebirth-linking citta. -/
abbrev kammaNoRebirth : Link Z := one .kamma .arise False True True
theorem a64_forbids_kammaNoRebirth : ¬ a64_kamma_from_rebirth Z kammaNoRebirth := by
  intro h; obtain ⟨r, hr, _⟩ := h () rfl; exact hr

/-- Mind-born matter arising at the rebirth-linking citta itself. -/
abbrev mindBornAtRebirth : Link Z := one .citta .arise True True True
theorem a67_forbids_mindBornAtRebirth : ¬ a67_mind_born_not_at_rebirth Z mindBornAtRebirth := by
  intro h; exact h () rfl trivial

/-- Mind-born matter produced by a citta that does not produce it (an immaterial resultant or a sense-consciousness). -/
abbrev mindBornByNonProducer : Link Z := one .citta .arise False False True
theorem a64_forbids_mindBornByNonProducer : ¬ a64_mind_born_only_by_producers Z mindBornByNonProducer := by
  intro h; exact h () rfl

end FormalAbhidhamma.Model
