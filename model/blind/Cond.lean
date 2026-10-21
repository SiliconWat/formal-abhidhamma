import Mind

import Tax

import Relata

namespace FormalAbhidhamma.Model

open FormalAbhidhamma.Relata

structure Occ (S : Scale) where
  kind : Kind
  rise : S.T
  fall : S.T
  
  cit : Nat := 0
  
  citta : Option FormalAbhidhamma.Citta := none
  
  rupa : Option FormalAbhidhamma.Model.Rupa := none
  
  born : Option FormalAbhidhamma.Model.Origin := none

structure CondW (S : Scale) where
  occs : List (Occ S)
  holds : List (Condition × Nat × Nat)

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

def ends {S : Scale} (w : CondW S) (i j : Nat) : Option (Occ S × Occ S) :=
  match w.occs[i]?, w.occs[j]? with | some a, some b => some (a, b) | _, _ => none

def facts_between_occurrences {S : Scale} (w : CondW S) (c : Condition) (p : Occ S → Occ S → Prop) : Prop :=
  ∀ f ∈ w.holds, f.1 = c → ∃ a b, ends w f.2.1 f.2.2 = some (a, b) ∧ p a b

def a78_relata {S : Scale} (w : CondW S) : Prop :=
  ∀ f ∈ w.holds, ∃ a b, ends w f.2.1 f.2.2 = some (a, b) ∧ admits (sangaha f.1) a.kind b.kind = true

def a83_co_nascent {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .sahajata fun a b => a.rise = b.rise

def a84_mutual {S : Scale} (w : CondW S) : Prop :=
  (facts_between_occurrences w .annamanna fun a b => a.rise = b.rise) ∧
  ∀ f ∈ w.holds, f.1 = .annamanna → (Condition.annamanna, f.2.2, f.2.1) ∈ w.holds

def prenascent : List FormalAbhidhamma.Model.Rupa :=
  [.cakkhu, .sota, .ghana, .jivha, .kaya, .vanna, .sadda, .gandha, .rasa, .pathavi, .tejo, .vayo, .hadaya]

def a87_pre_born {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .purejata fun a b =>
    S.lt a.rise b.rise ∧ S.lt b.rise a.fall ∧ ∃ r, a.rupa = some r ∧ r ∈ prenascent

def a88_post_born {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .pacchajata fun a b => S.lt b.rise a.rise ∧ S.lt a.rise b.fall

def a96_associated {S : Scale} (w : CondW S) : Prop :=
  ∀ i j a b, i ≠ j → w.occs[i]? = some a → w.occs[j]? = some b → a.kind = .nama → b.kind = .nama → a.cit = b.cit →
    (Condition.sampayutta, i, j) ∈ w.holds

def a30_sampayutta_marks {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .sampayutta fun a b => a.kind = .nama ∧ b.kind = .nama ∧ a.rise = b.rise ∧ a.fall = b.fall

def a97_dissociated {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .vippayutta fun a b => a.kind ≠ b.kind

def a98_present {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .atthi fun a b => S.lt b.rise a.fall ∧ S.lt a.rise b.fall

def a101_not_disappeared {S : Scale} (w : CondW S) : Prop :=
  ∀ i j, (Condition.avigata, i, j) ∈ w.holds ↔ (Condition.atthi, i, j) ∈ w.holds

def a99_absent {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .natthi fun a b => S.lt a.rise b.rise ∧ ¬ S.lt b.rise a.fall

def a100_gone {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .vigata fun a b => S.lt a.rise b.rise ∧ ¬ S.lt b.rise a.fall

abbrev o (k : Kind) (r f : Int) : Occ Z := { kind := k, rise := r, fall := f }

abbrev cw (os : List (Occ Z)) (h : List (Condition × Nat × Nat)) : CondW Z := ⟨os, h⟩

def sameCittaTogether {S : Scale} (a b : Occ S) : Prop := a.cit = b.cit ∧ a.rise = b.rise

def vipakaNama {S : Scale} (w : CondW S) (a : Occ S) : Prop :=
  a.kind = .nama ∧ ∃ p ∈ w.occs, p.cit = a.cit ∧ (p.citta.map (·.jati)) = some FormalAbhidhamma.Jati.vipaka

def ownCittaScope {S : Scale} (a b : Occ S) : Prop := a.kind = .nama ∧ b.cit = a.cit ∧ (b.kind = .nama ∨ (b.kind = .rupa ∧ b.born = some .citta))

def a79_root_scope {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .hetu sameCittaTogether

def a81_predominance {S : Scale} (w : CondW S) : Prop :=
  ∀ f ∈ w.holds, f.1 = .adhipati → ∃ a b, ends w f.2.1 f.2.2 = some (a, b) ∧
    (sameCittaTogether a b ∨ (b.kind = .nama ∧ (Condition.arammana, f.2.1, f.2.2) ∈ w.holds))

def a94_jhana_scope {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .jhana ownCittaScope

def a95_path_scope {S : Scale} (w : CondW S) : Prop := facts_between_occurrences w .magga ownCittaScope

def a91_result {S : Scale} (w : CondW S) : Prop :=
  ∀ i j a b, i ≠ j → w.occs[i]? = some a → w.occs[j]? = some b → vipakaNama w a → vipakaNama w b → a.cit = b.cit →
    (Condition.vipaka, i, j) ∈ w.holds

def a78_vipaka_scope {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .vipaka fun a b =>
    a.kind = .nama ∧ b.kind = .nama ∧ a.rise = b.rise ∧
    (a.citta.map (·.jati)) = some FormalAbhidhamma.Jati.vipaka ∧ (b.citta.map (·.jati)) = some FormalAbhidhamma.Jati.vipaka

def a90_kamma {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .kamma fun a b =>
    sameCittaTogether a b ∨ (S.lt a.rise b.rise ∧ ((b.citta.map (·.jati)) = some FormalAbhidhamma.Jati.vipaka ∨ b.born = some .kamma))

def a89_repetition {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .asevana fun a b =>
    a.kind = .nama ∧ b.kind = .nama ∧ S.lt a.rise b.rise ∧
    (a.citta.map (·.jati)) = (b.citta.map (·.jati)) ∧ (a.citta.map (·.jati)) ≠ some FormalAbhidhamma.Jati.vipaka ∧ a.citta.isSome = true

def a93_faculty {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .indriya fun a b =>
    ((a.rupa.map (pasada.contains ·)) = some true ∧ b.kind = .nama) ∨
    (a.rupa = some .jivita ∧ b.born = some .kamma) ∨ (a.kind = .nama ∧ sameCittaTogether a b)

def a92_nutriment {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .ahara fun a b =>
    (a.rupa = some .ahara ∧ b.kind = .rupa) ∨ ownCittaScope a b

def senseOfObject : FormalAbhidhamma.Model.Rupa → Option Nat
  | .vanna => some 1 | .sadda => some 2 | .gandha => some 3 | .rasa => some 4
  | .pathavi | .tejo | .vayo => some 5 | _ => none

def a80_object_sense {S : Scale} (w : CondW S) : Prop :=
  facts_between_occurrences w .arammana fun a b =>
    ∀ r n d, a.rupa = some r → senseOfObject r = some n → (b.citta.map (·.dhatu)) = some (FormalAbhidhamma.Dhatu.sense d) → d = n

abbrev cwo (k : Kind) (r f : Int) (c : Nat) : Occ Z := { kind := k, rise := r, fall := f, cit := c }

def a82_contiguity_same_relata {S : Scale} (w : CondW S) : Prop :=
  ∀ i j, (Condition.anantara, i, j) ∈ w.holds ↔ (Condition.samanantara, i, j) ∈ w.holds

def a121_passes_away {S : Scale} (w : CondW S) : Prop := ∀ a ∈ w.occs, a.kind ≠ .pannatti → S.lt a.rise a.fall

end FormalAbhidhamma.Model
