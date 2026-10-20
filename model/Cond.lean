/-
  model/Cond.lean — the COND part of the one World: what conditions what, as the 24 conditions' relata and timing.
  FIRST BATCH (2026-10-20): A78's relata (what each condition relates, by the Saṅgaha's six-way grouping, `matika/Relata.lean`)
  · A83 co-nascence · A84 mutuality · A87's COND half pre-nascence · A88 post-nascence · A96 association · A97 dissociation ·
  A98 presence · A99 absence · A100 disappearance · A101 non-disappearance.
  Not yet: the conditions that need the stream's order or the taxonomy (A79 root · A80 object · A81 predominance · A85 support ·
  A86 decisive support · A89 repetition · A90 kamma · A91 result · A92 nutriment · A93 faculty · A94 jhāna · A95 path · A82
  contiguity · A3/C/A112/A122 proximity, which live in Mind.lean and need the joint link).
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything.

  A world has occurrences (each mind or matter, with the clock readings of its arising and its ceasing) and a list of
  conditioning facts: this condition, from this occurrence, to that. The clock is ANY scale (Mind.lean's `Scale`).
  ⚠️ The groupings come from the Saṅgaha (`Relata.sangaha`, the known answer); the Paṭṭhāna's own clauses give the same groups
  for 22 of the 24 on the concept-free reading (`matika/` `the_22_without_concepts`), and object and decisive support take a
  concept; this file therefore admits a concept as the SOURCE of the two (kind `pannatti`), nowhere else.
  The relata are not rows' words alone: each row lists its relata and `Relata` carries the reading; a row-listed pair that the
  grouping admits is a PERMISSION (it goes to the occurrence list, not here).
-/
import Mind
import Relata
namespace FormalAbhidhamma.Model
open FormalAbhidhamma.Relata

/-- One occurrence: mind or matter, and the clock readings of its arising and its ceasing. -/
structure Occ (S : Scale) where
  kind : Kind
  rise : S.T
  fall : S.T

/-- A world's conditioning: its occurrences, and the facts `(c, i, j)`: condition c from occurrence i to occurrence j. -/
structure CondW (S : Scale) where
  occs : List (Occ S)
  holds : List (Condition × Nat × Nat)

/-- Which pairs of kinds a group admits (source, target). A concept is admitted as the source of 'concepts, mind and matter → mind'. -/
def admits : Group → Kind → Kind → Bool
  | .namaToNama, .nama, .nama => true
  | .namaToNamarupa, .nama, .nama => true
  | .namaToNamarupa, .nama, .rupa => true
  | .namaToRupa, .nama, .rupa => true
  | .rupaToNama, .rupa, .nama => true
  | .allToNama, .nama, .nama => true
  | .allToNama, .rupa, .nama => true
  | .allToNama, .pannatti, .nama => true
  | .namarupaToNamarupa, .nama, .nama => true
  | .namarupaToNamarupa, .nama, .rupa => true
  | .namarupaToNamarupa, .rupa, .nama => true
  | .namarupaToNamarupa, .rupa, .rupa => true
  | _, _, _ => false

/-- The occurrences of a fact, or none. -/
def ends {S : Scale} (w : CondW S) (i j : Nat) : Option (Occ S × Occ S) :=
  match w.occs[i]?, w.occs[j]? with | some a, some b => some (a, b) | _, _ => none

/-- Every fact `(c, i, j)` holds `c` from an occurrence the world has to one it has. -/
def facts_between_occurrences {S : Scale} (w : CondW S) (c : Condition) (p : Occ S → Occ S → Prop) : Prop :=
  ∀ f ∈ w.holds, f.1 = c → ∃ a b, ends w f.2.1 f.2.2 = some (a, b) ∧ p a b

/-- A78 (L1/L4; the Paṭṭhāna's niddesa and the Saṅgaha ch. 8, `matika/Relata.lean`): every conditioning fact relates the kinds its condition's group admits. -/
def a78_relata {S : Scale} (w : CondW S) : Prop :=
  ∀ f ∈ w.holds, ∃ a b, ends w f.2.1 f.2.2 = some (a, b) ∧ admits (sangaha f.1) a.kind b.kind = true

/-- A83 (L1, co-nascence): the related arise together. -/
def a83_co_nascent {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .sahajata fun a b => a.rise = b.rise

/-- A84 (L1/L3, mutuality): each is the other's condition, and they arise together. ⚠️ "symmetric, so not a partial order" is OURS and not here. -/
def a84_mutual {S : Scale} (w : CondW S) : Prop :=
  (facts_between_occurrences w .annamanna fun a b => a.rise = b.rise) ∧
  ∀ f ∈ w.holds, f.1 = .annamanna → (Condition.annamanna, f.2.2, f.2.1) ∈ w.holds

/-- A87, the COND half (L1, pre-nascence): the condition arose before the conditioned and has not ceased when it arises. -/
def a87_pre_born {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .purejata fun a b => S.lt a.rise b.rise ∧ ¬ S.lt a.fall b.rise

/-- A88 (L1/L2/L5, post-nascence): the conditioned (a body) arose before the conditioning citta and has not ceased when that arises. -/
def a88_post_born {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .pacchajata fun a b => S.lt b.rise a.rise ∧ ¬ S.lt b.fall a.rise

/-- A96 (L1, association): the related are mind, and arise and cease together (the four marks, A30). -/
def a96_associated {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .sampayutta fun a b => a.kind = .nama ∧ b.kind = .nama ∧ a.rise = b.rise ∧ a.fall = b.fall

/-- A97 (L1, dissociation): the related are one mind and one matter. -/
def a97_dissociated {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .vippayutta fun a b => a.kind ≠ b.kind

/-- A98 (L1, presence) and A101 (non-disappearance): the related exist together — neither has ceased before the other arises. -/
def a98_present {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .atthi fun a b => ¬ S.lt a.fall b.rise ∧ ¬ S.lt b.fall a.rise
def a101_not_disappeared {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .avigata fun a b => ¬ S.lt a.fall b.rise ∧ ¬ S.lt b.fall a.rise

/-- A99 (L1, absence) and A100 (disappearance): the condition has just ceased, and is not later than the conditioned's arising: it arose first and has ceased by then. -/
def a99_absent {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .natthi fun a b => S.lt a.rise b.rise ∧ ¬ S.lt b.rise a.fall
def a100_gone {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .vigata fun a b => S.lt a.rise b.rise ∧ ¬ S.lt b.rise a.fall

/-! ## Forbidden worlds (whole-number scale) -/

abbrev o (k : Kind) (r f : Int) : Occ Z := ⟨k, r, f⟩
abbrev cw (os : List (Occ Z)) (h : List (Condition × Nat × Nat)) : CondW Z := ⟨os, h⟩

/-- A root (a mind-only condition) from a matter occurrence. -/
abbrev rootFromMatter : CondW Z := cw [o .rupa 0 5, o .nama 0 5] [(.hetu, 0, 1)]
theorem a78_forbids_rootFromMatter : ¬ a78_relata rootFromMatter := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.hetu, 0, 1) (by simp [rootFromMatter, cw])
  simp [ends, rootFromMatter, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; simp [admits, sangaha] at hk

/-- Co-nascence between occurrences that arise at different readings. -/
abbrev notTogether : CondW Z := cw [o .nama 0 5, o .nama 1 5] [(.sahajata, 0, 1)]
theorem a83_forbids_notTogether : ¬ a83_co_nascent notTogether := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.sahajata, 0, 1) (by simp [notTogether, cw]) rfl
  simp [ends, notTogether, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; simp at hk

/-- Mutuality in one direction only. -/
abbrev oneWay : CondW Z := cw [o .nama 0 5, o .nama 0 5] [(.annamanna, 0, 1)]
theorem a84_forbids_oneWay : ¬ a84_mutual oneWay := by
  intro h; exact absurd (h.2 (.annamanna, 0, 1) (by simp [oneWay, cw]) rfl) (by simp [oneWay, cw])

/-- Pre-nascence from an occurrence that has already ceased. -/
abbrev preCeased : CondW Z := cw [o .rupa 0 2, o .nama 5 9] [(.purejata, 0, 1)]
theorem a87_forbids_preCeased : ¬ a87_pre_born preCeased := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.purejata, 0, 1) (by simp [preCeased, cw]) rfl
  simp [ends, preCeased, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; exact hk.2 (by decide)

/-- Post-nascence where the conditioning citta arose first. -/
abbrev postWrongOrder : CondW Z := cw [o .nama 0 9, o .rupa 5 9] [(.pacchajata, 0, 1)]
theorem a88_forbids_postWrongOrder : ¬ a88_post_born postWrongOrder := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.pacchajata, 0, 1) (by simp [postWrongOrder, cw]) rfl
  simp [ends, postWrongOrder, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; exact absurd hk.1 (by decide)

/-- Association between occurrences that cease at different readings. -/
abbrev assocUnequal : CondW Z := cw [o .nama 0 5, o .nama 0 6] [(.sampayutta, 0, 1)]
theorem a96_forbids_assocUnequal : ¬ a96_associated assocUnequal := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.sampayutta, 0, 1) (by simp [assocUnequal, cw]) rfl
  simp [ends, assocUnequal, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; simp at hk

/-- Dissociation between two mind occurrences. -/
abbrev dissocMindMind : CondW Z := cw [o .nama 0 5, o .nama 0 5] [(.vippayutta, 0, 1)]
theorem a97_forbids_dissocMindMind : ¬ a97_dissociated dissocMindMind := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.vippayutta, 0, 1) (by simp [dissocMindMind, cw]) rfl
  simp [ends, dissocMindMind, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; exact hk rfl

/-- Presence between occurrences, one of which has ceased before the other arises. -/
abbrev notPresent : CondW Z := cw [o .nama 0 2, o .rupa 5 9] [(.atthi, 0, 1)]
theorem a98_forbids_notPresent : ¬ a98_present notPresent := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.atthi, 0, 1) (by simp [notPresent, cw]) rfl
  simp [ends, notPresent, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; exact hk.1 (by decide)

abbrev notPresent2 : CondW Z := cw [o .nama 0 2, o .rupa 5 9] [(.avigata, 0, 1)]
theorem a101_forbids_notPresent2 : ¬ a101_not_disappeared notPresent2 := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.avigata, 0, 1) (by simp [notPresent2, cw]) rfl
  simp [ends, notPresent2, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; exact hk.1 (by decide)

/-- Absence from an occurrence that has not ceased when the conditioned arises. -/
abbrev notAbsent : CondW Z := cw [o .nama 0 9, o .nama 5 9] [(.natthi, 0, 1)]
theorem a99_forbids_notAbsent : ¬ a99_absent notAbsent := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.natthi, 0, 1) (by simp [notAbsent, cw]) rfl
  simp [ends, notAbsent, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; exact hk.2 (by decide)

abbrev notGone : CondW Z := cw [o .nama 0 9, o .nama 5 9] [(.vigata, 0, 1)]
theorem a100_forbids_notGone : ¬ a100_gone notGone := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.vigata, 0, 1) (by simp [notGone, cw]) rfl
  simp [ends, notGone, cw, o] at he
  obtain ⟨rfl, rfl⟩ := he; exact hk.2 (by decide)

end FormalAbhidhamma.Model
