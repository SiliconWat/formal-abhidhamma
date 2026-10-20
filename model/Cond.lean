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
import Tax
import Relata
namespace FormalAbhidhamma.Model
open FormalAbhidhamma.Relata

/-- One occurrence: mind or matter, and the clock readings of its arising and its ceasing. -/
structure Occ (S : Scale) where
  kind : Kind
  rise : S.T
  fall : S.T
  /-- the citta it belongs to (a mental state) or is originated by (mind-born matter): occurrences with one `cit` are of one citta -/
  cit : Nat := 0
  /-- the citta-type, for a mind occurrence -/
  citta : Option FormalAbhidhamma.Citta := none
  /-- the kind of matter, for a matter occurrence -/
  rupa : Option FormalAbhidhamma.Model.Rupa := none
  /-- the origin, for a matter occurrence -/
  born : Option FormalAbhidhamma.Model.Origin := none

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

abbrev o (k : Kind) (r f : Int) : Occ Z := { kind := k, rise := r, fall := f }
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

/-! ## Batch 2 — the conditions whose relata are tied to one citta, a result, an origin or a sense -/

def sameCittaTogether {S : Scale} (a b : Occ S) : Prop := a.cit = b.cit ∧ a.rise = b.rise

/-- A79 (Piṭaka, `abh03m7.mul.xml:45`): a root conditions the states associated with it and the matter they originate — those of its own citta, arising with it. -/
def a79_root_scope {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .hetu sameCittaTogether

/-- A81 (`:57–61`): a predominant conditions its associated states and the matter they originate (its own citta, together); whatever is esteemed as OBJECT conditions the mind that esteems it. -/
def a81_predominance {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .adhipati fun a b => sameCittaTogether a b ∨ b.kind = .nama

/-- A94 jhāna (`:209`) and A95 path (`:213`): the factors condition their associated states and matter — of their own citta, together. -/
def a94_jhana_scope {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .jhana sameCittaTogether
def a95_path_scope {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .magga sameCittaTogether

/-- A91 (`:193`): the resultant mental aggregates condition one another — mind to mind, both resultants, together. -/
def a91_result {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .vipaka fun a b =>
    a.kind = .nama ∧ b.kind = .nama ∧ a.rise = b.rise ∧
    (a.citta.map (·.jati)) = some FormalAbhidhamma.Jati.vipaka ∧ (b.citta.map (·.jati)) = some FormalAbhidhamma.Jati.vipaka

/-- A90 (`:189`, `:6061`): kamma conditions the resultant aggregates and kamma-born matter ACROSS TIME (the condition arose earlier);
    volition conditions its associated states and their matter at the same time. No stored trace is a further occurrence. -/
def a90_kamma {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .kamma fun a b =>
    sameCittaTogether a b ∨ (S.lt a.rise b.rise ∧ ((b.citta.map (·.jati)) = some FormalAbhidhamma.Jati.vipaka ∨ b.born = some .kamma))

/-- A89 (`:185`): repetition — an earlier javana of one class conditions a later one of the same class, never across wholesome, unwholesome, functional. -/
def a89_repetition {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .asevana fun a b =>
    a.kind = .nama ∧ b.kind = .nama ∧ S.lt a.rise b.rise ∧
    (a.citta.map (·.jati)) = (b.citta.map (·.jati)) ∧ (a.citta.map (·.jati)) ≠ some FormalAbhidhamma.Jati.vipaka ∧ a.citta.isSome = true

/-- A93 (`:201–205`): each sense faculty conditions its consciousness; the life faculty conditions kamma-born matter; a mental faculty conditions its associated states and matter. -/
def a93_faculty {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .indriya fun a b =>
    ((a.rupa.map (pasada.contains ·)) = some true ∧ b.kind = .nama) ∨
    (a.rupa = some .jivita ∧ b.born = some .kamma) ∨ (a.kind = .nama ∧ sameCittaTogether a b)

/-- A92 (`:197`): edible food conditions this body; a mental nutriment conditions its associated states and matter. -/
def a92_nutriment {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .ahara fun a b =>
    (a.rupa = some .ahara ∧ b.kind = .rupa) ∨ (a.kind = .nama ∧ sameCittaTogether a b)

/-- Which sense a kind of sense-object belongs to: visible form 1, sound 2, smell 3, taste 4, the tangible (earth, fire, air) 5. -/
def senseOfObject : FormalAbhidhamma.Model.Rupa → Option Nat
  | .vanna => some 1 | .sadda => some 2 | .gandha => some 3 | .rasa => some 4
  | .pathavi | .tejo | .vayo => some 5 | _ => none

/-- A80 (`:49–53`): each sense object conditions the consciousness of its own sense — visible form eye-consciousness, and so on. -/
def a80_object_sense {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .arammana fun a b =>
    ∀ r n d, a.rupa = some r → senseOfObject r = some n → (b.citta.map (·.dhatu)) = some (FormalAbhidhamma.Dhatu.sense d) → d = n

/-! ### Forbidden worlds, batch 2 -/

abbrev cwo (k : Kind) (r f : Int) (c : Nat) : Occ Z := { kind := k, rise := r, fall := f, cit := c }
abbrev vip : Option FormalAbhidhamma.Citta := some eyeCons
abbrev kus : Option FormalAbhidhamma.Citta := some { eyeCons with jati := .kusala }
abbrev aku : Option FormalAbhidhamma.Citta := some { eyeCons with jati := .akusala }

/-- A root conditioning matter that another citta originates. -/
abbrev rootOtherCitta : CondW Z := cw [cwo .nama 0 5 1, cwo .rupa 0 5 2] [(.hetu, 0, 1)]
theorem a79_forbids_rootOtherCitta : ¬ a79_root_scope rootOtherCitta := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.hetu, 0, 1) (by simp [rootOtherCitta, cw]) rfl
  simp [ends, rootOtherCitta, cw, cwo] at he
  obtain ⟨rfl, rfl⟩ := he; simp [sameCittaTogether] at hk

/-- A predominant (desire) conditioning matter of another citta. -/
abbrev predOtherMatter : CondW Z := cw [cwo .nama 0 5 1, cwo .rupa 0 5 2] [(.adhipati, 0, 1)]
theorem a81_forbids_predOtherMatter : ¬ a81_predominance predOtherMatter := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.adhipati, 0, 1) (by simp [predOtherMatter, cw]) rfl
  simp [ends, predOtherMatter, cw, cwo] at he
  obtain ⟨rfl, rfl⟩ := he; simp [sameCittaTogether] at hk

/-- A jhāna factor conditioning a state of another citta. -/
abbrev jhanaOther : CondW Z := cw [cwo .nama 0 5 1, cwo .nama 0 5 2] [(.jhana, 0, 1)]
theorem a94_forbids_jhanaOther : ¬ a94_jhana_scope jhanaOther := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.jhana, 0, 1) (by simp [jhanaOther, cw]) rfl
  simp [ends, jhanaOther, cw, cwo] at he
  obtain ⟨rfl, rfl⟩ := he; simp [sameCittaTogether] at hk

/-- A path factor conditioning a state of another citta. -/
abbrev pathOther : CondW Z := cw [cwo .nama 0 5 1, cwo .nama 0 5 2] [(.magga, 0, 1)]
theorem a95_forbids_pathOther : ¬ a95_path_scope pathOther := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.magga, 0, 1) (by simp [pathOther, cw]) rfl
  simp [ends, pathOther, cw, cwo] at he
  obtain ⟨rfl, rfl⟩ := he; simp [sameCittaTogether] at hk

/-- Result conditioning a wholesome (non-resultant) mind. -/
abbrev resultOnWholesome : CondW Z :=
  cw [{ kind := .nama, rise := 0, fall := 5, citta := vip }, { kind := .nama, rise := 0, fall := 5, citta := kus }] [(.vipaka, 0, 1)]
theorem a91_forbids_resultOnWholesome : ¬ a91_result resultOnWholesome := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.vipaka, 0, 1) (by simp [resultOnWholesome, cw]) rfl
  simp [ends, resultOnWholesome, cw, vip, kus] at he
  obtain ⟨rfl, rfl⟩ := he; simp [vip, kus] at hk

/-- Kamma conditioning an earlier state (the condition arose AFTER the conditioned) of another citta. -/
abbrev kammaBackward : CondW Z := cw [cwo .nama 5 9 1, cwo .nama 0 4 2] [(.kamma, 0, 1)]
theorem a90_forbids_kammaBackward : ¬ a90_kamma kammaBackward := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.kamma, 0, 1) (by simp [kammaBackward, cw]) rfl
  simp [ends, kammaBackward, cw, cwo] at he
  obtain ⟨rfl, rfl⟩ := he; simp [sameCittaTogether] at hk

/-- Repetition from a wholesome javana to an unwholesome one. -/
abbrev repetitionAcross : CondW Z :=
  cw [{ kind := .nama, rise := 0, fall := 2, citta := kus }, { kind := .nama, rise := 3, fall := 5, citta := aku }] [(.asevana, 0, 1)]
theorem a89_forbids_repetitionAcross : ¬ a89_repetition repetitionAcross := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.asevana, 0, 1) (by simp [repetitionAcross, cw]) rfl
  simp [ends, repetitionAcross, cw, kus, aku] at he
  obtain ⟨rfl, rfl⟩ := he; simp [kus, aku] at hk

/-- A faculty (the life faculty) conditioning mind-born matter. -/
abbrev lifeOnMindBorn : CondW Z :=
  cw [{ kind := .rupa, rise := 0, fall := 5, rupa := some .jivita }, { kind := .rupa, rise := 0, fall := 5, born := some .citta }] [(.indriya, 0, 1)]
theorem a93_forbids_lifeOnMindBorn : ¬ a93_faculty lifeOnMindBorn := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.indriya, 0, 1) (by simp [lifeOnMindBorn, cw]) rfl
  simp [ends, lifeOnMindBorn, cw] at he
  obtain ⟨rfl, rfl⟩ := he; simp [pasada, sameCittaTogether] at hk

/-- Nutriment: edible food conditioning a mental state. -/
abbrev foodOnMind : CondW Z :=
  cw [{ kind := .rupa, rise := 0, fall := 5, rupa := some .ahara }, cwo .nama 0 5 1] [(.ahara, 0, 1)]
theorem a92_forbids_foodOnMind : ¬ a92_nutriment foodOnMind := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.ahara, 0, 1) (by simp [foodOnMind, cw]) rfl
  simp [ends, foodOnMind, cw, cwo] at he
  obtain ⟨rfl, rfl⟩ := he; simp [sameCittaTogether] at hk

/-- Visible form as the object of an ear-consciousness (sense 2). -/
abbrev formToEar : CondW Z :=
  cw [{ kind := .rupa, rise := 0, fall := 5, rupa := some .vanna }, { kind := .nama, rise := 1, fall := 5, citta := some { eyeCons with dhatu := .sense 2 } }] [(.arammana, 0, 1)]
theorem a80_forbids_formToEar : ¬ a80_object_sense formToEar := by
  intro h; obtain ⟨a, b, he, hk⟩ := h (.arammana, 0, 1) (by simp [formToEar, cw]) rfl
  simp [ends, formToEar, cw] at he
  obtain ⟨rfl, rfl⟩ := he; exact absurd (hk .vanna 1 2 rfl rfl rfl) (by decide)

end FormalAbhidhamma.Model
