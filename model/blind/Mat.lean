import Proc

namespace FormalAbhidhamma.Model

open FormalAbhidhamma

inductive BreathCase | normal | womb | water | swoon | dead | fourthJhana | cessation deriving DecidableEq, Repr

structure Being where
  id : Nat
  plane : Bhumi
  bases : List Rupa
  
  hasMind : Bool := true
  hasMatter : Bool := true
  faculties : List Rupa := []
  
  kinds : List Rupa := []
  
  breathes : Bool := false
  breathCase : BreathCase := .normal
  deriving DecidableEq, Repr

structure Kalapa where
  members : List Rupa
  origin : Origin
  life : Nat
  owner : Option Nat
  bound : Bool
  
  place : Nat := 0
  
  size : Nat := 1
  deriving DecidableEq, Repr

structure Mat where
  beings : List Being
  kalapas : List Kalapa
  reached : List Door
  
  gaps : List (Nat × Nat) := []
  
  ladder : List Nat := [36, 36, 36, 36, 7, 7, 7]

def sixBases : List Rupa := pasada ++ [Rupa.hadaya]

def a39_sense (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .kama → ∀ r ∈ b.bases, r ∈ sixBases

def a39_fine (m : Mat) : Prop :=
  ∀ b ∈ m.beings, b.plane = .rupa → ∀ r ∈ b.bases, r ∈ [Rupa.cakkhu, .sota, .hadaya]

def a39_other (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .lokuttara → ∀ r ∈ b.bases, r ∈ sixBases

def a39_immaterial (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .arupa → b.bases = []

def a4_life (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, (∀ r ∈ k.members, r ≠ .kayavinnatti ∧ r ≠ .vacivinnatti) → k.life = 51

def a15_eight (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, ∀ r ∈ [Rupa.pathavi, .apo, .tejo, .vayo, .vanna, .gandha, .rasa, .ahara], r ∈ k.members

def a15_lightness (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, Rupa.lahuta ∈ k.members → k.origin ≠ .kamma ∧ k.owner.isSome = true

def a63_reach (m : Mat) : Prop := m.reached = [Door.nose, .tongue, .body]

def a6_unbound (m : Mat) : Prop := ∀ k ∈ m.kalapas, (k.bound = false ↔ k.owner = none)

abbrev eight : List Rupa := [.pathavi, .apo, .tejo, .vayo, .vanna, .gandha, .rasa, .ahara]

def canon (l : List Rupa) : List Rupa := Rupa.all.filter (· ∈ l)

def twentyOne : List (List Rupa × Origin) :=
  (([Rupa.cakkhu, .sota, .ghana, .jivha, .kaya, .itthatta, .purisatta, .hadaya].map fun r => (eight ++ [.jivita, r], Origin.kamma))
    ++ [(eight ++ [.jivita], .kamma)])
  ++ [(eight, .citta), (eight ++ [.kayavinnatti], .citta), (eight ++ [.vacivinnatti, .sadda], .citta),
      (eight ++ [.lahuta, .muduta, .kammannata], .citta), (eight ++ [.kayavinnatti, .lahuta, .muduta, .kammannata], .citta),
      (eight ++ [.vacivinnatti, .sadda, .lahuta, .muduta, .kammannata], .citta)]
  ++ [(eight, .utu), (eight ++ [.sadda], .utu), (eight ++ [.lahuta, .muduta, .kammannata], .utu),
      (eight ++ [.sadda, .lahuta, .muduta, .kammannata], .utu)]
  ++ [(eight, .ahara), (eight ++ [.lahuta, .muduta, .kammannata], .ahara)]

def isKind (k : Kalapa) (t : List Rupa × Origin) : Bool := canon k.members == canon t.1 && k.origin == t.2

def a66_twenty_one (m : Mat) : Prop := ∀ k ∈ m.kalapas, ∃ t ∈ twentyOne, isKind k t = true

def a66_external (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, k.owner = none → isKind k (eight, .utu) = true ∨ isKind k (eight ++ [.sadda], .utu) = true

def a66_no_delimiter_member (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, ∀ r ∈ [Rupa.akasa, .upacaya, .santati, .jarata, .aniccata], r ∉ k.members

def a5_space (m : Mat) : Prop :=
  ∀ g ∈ m.gaps, g.1 < m.kalapas.length ∧ g.2 < m.kalapas.length ∧ g.1 ≠ g.2

def a13_arupa (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .arupa → b.hasMatter = false ∧ b.hasMind = true

def a13_mindless (m : Mat) : Prop := ∀ b ∈ m.beings, b.hasMind = false → b.hasMatter = true ∧ Rupa.jivita ∈ b.faculties

def a129_ladder (m : Mat) : Prop := m.ladder = [36, 36, 36, 36, 7, 7, 7]

def a129_size (m : Mat) : Prop := ∀ k ∈ m.kalapas, k.size = 1

def fineKinds : List Rupa := Rupa.all.filter (fun r => ![Rupa.ghana, .jivha, .kaya, .itthatta, .purisatta].contains r)

def nonPercipientKinds : List Rupa :=
  eight ++ [.jivita, .akasa, .lahuta, .muduta, .kammannata, .upacaya, .santati, .jarata, .aniccata]

def a68_fine (m : Mat) : Prop :=
  (∀ b ∈ m.beings, b.plane = .rupa → ∀ r ∈ b.kinds, r ∈ fineKinds) ∧
  (∀ b ∈ m.beings, b.plane = .rupa → ∀ k ∈ m.kalapas, k.owner = some b.id → k.origin ≠ .ahara)

def a68_non_percipient (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .rupa → b.hasMind = false → ∀ r ∈ b.kinds, r ∈ nonPercipientKinds

def a68_immaterial (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .arupa → b.kinds = []

def a114_absent (m : Mat) : Prop :=
  ∀ b ∈ m.beings, (b.breathCase ≠ .normal ∨ b.plane = .rupa ∨ b.plane = .arupa ∨ b.hasMind = false) → b.breathes = false

end FormalAbhidhamma.Model
