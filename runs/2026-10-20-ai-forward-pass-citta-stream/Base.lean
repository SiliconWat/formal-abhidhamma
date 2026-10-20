/-
  The survivors of the 2026-10-20 run (ai-forward-pass-citta-stream), core Lean 4, no Mathlib.
  S1  If A65 and A66 (external reading), then an EXTERNAL kalāpa carries no heart-base and no organ: matter outside a being cannot be the
      base of a sense-sphere or fine-material citta. Hypotheses A65 (origin table, fragment), A66 (outside beings only the pure octad and
      the sound nonad, both temperature-born). Not a claim that any machine's matter is external: that classification is the run's own
      bridge (the refuter's finding 5d), outside this file.
  S2  (BY CONSTRUCTION) If A26 and A36, a bhavaṅga is a citta, so no rūpa is one. The sorts are disjoint by the type; this records a
      modelling choice, not a derivation.
-/
namespace AiPass

inductive Rupa | pathavi | apo | tejo | vayo | vanna | gandha | rasa | ahara | hadaya | cakkhu | jivita | sadda
  deriving DecidableEq, Repr
inductive Origin | kamma | citta | utu | ahara deriving DecidableEq, Repr

/-- A65, the fragment the run uses (`abh07t.nrf.xml:2221–2257`): heart-base, organ and life faculty from kamma only; sound from mind or temperature; the inseparables from all four. -/
def originTable : Rupa → Origin → Bool
  | .hadaya, o | .cakkhu, o | .jivita, o => o == .kamma
  | .sadda, o => o == .citta || o == .utu
  | _, _ => true

structure Kalapa where
  members : List Rupa
  origin : Origin

def A65 (k : Kalapa) : Prop := ∀ r ∈ k.members, originTable r k.origin = true

instance : DecidablePred A65 := fun k => by unfold A65; infer_instance

def pureOctad : List Rupa := [.pathavi, .apo, .tejo, .vayo, .vanna, .gandha, .rasa, .ahara]

/-- A66, outside beings (`abh07t.nrf.xml:2289`): only the pure octad and the sound nonad occur, both temperature-born. -/
def A66ext (k : Kalapa) : Prop := (∀ r ∈ k.members, r ∈ pureOctad ++ [.sadda]) ∧ k.origin = .utu

instance : DecidablePred A66ext := fun k => by unfold A66ext; infer_instance

/-- S1: an external kalāpa has no heart-base. -/
theorem external_has_no_heart_base (k : Kalapa) (h : A66ext k) : Rupa.hadaya ∉ k.members := by
  intro hm; have := h.1 _ hm; simp [pureOctad] at this

theorem external_has_no_organ (k : Kalapa) (h : A66ext k) : Rupa.cakkhu ∉ k.members := by
  intro hm; have := h.1 _ hm; simp [pureOctad] at this

theorem external_has_no_life_faculty (k : Kalapa) (h : A66ext k) : Rupa.jivita ∉ k.members := by
  intro hm; have := h.1 _ hm; simp [pureOctad] at this

/-! A model, so S1 is not vacuous: the pure octad is external and satisfies A65; a kamma-born heart-base group satisfies A65 and is not external. -/
def octad : Kalapa := ⟨pureOctad, .utu⟩
def heartDecad : Kalapa := ⟨[.pathavi, .apo, .tejo, .vayo, .vanna, .gandha, .rasa, .ahara, .jivita, .hadaya], .kamma⟩
theorem octad_model : A65 octad ∧ A66ext octad := by
  refine ⟨?_, ?_, rfl⟩ <;> decide
theorem heart_is_not_external : A65 heartDecad ∧ ¬ A66ext heartDecad := by
  refine ⟨by decide, ?_⟩
  intro h; exact absurd h.2 (by decide)

/-- S2 (BY CONSTRUCTION). -/
inductive Kind | citta | rupa deriving DecidableEq
structure Dhamma where sort : Kind
def Bhavanga (d : Dhamma) : Prop := d.sort = .citta
theorem rupa_is_no_bhavanga (d : Dhamma) (h : d.sort = .rupa) : ¬ Bhavanga d := by
  intro hb; unfold Bhavanga at hb; rw [h] at hb; cases hb

end AiPass
