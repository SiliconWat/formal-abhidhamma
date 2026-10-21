import Rules

namespace FormalAbhidhamma.Model

open FormalAbhidhamma

inductive Kicca
  | patisandhi | bhavanga | avajjana | dassana | savana | ghayana | sayana | phusana
  | sampaticchana | santirana | votthabbana | javana | tadarammana | cuti
  deriving DecidableEq, Repr

def Kicca.all : List Kicca :=
  [.patisandhi, .bhavanga, .avajjana, .dassana, .savana, .ghayana, .sayana, .phusana,
   .sampaticchana, .santirana, .votthabbana, .javana, .tadarammana, .cuti]

inductive Thana
  | patisandhi | bhavanga | avajjana | pancavinnana | sampaticchana | santirana | votthabbana | javana | tadarammana | cuti
  deriving DecidableEq, Repr

def Kicca.thana : Kicca → Thana
  | .patisandhi => .patisandhi | .bhavanga => .bhavanga | .avajjana => .avajjana
  | .dassana | .savana | .ghayana | .sayana | .phusana => .pancavinnana
  | .sampaticchana => .sampaticchana | .santirana => .santirana | .votthabbana => .votthabbana
  | .javana => .javana | .tadarammana => .tadarammana | .cuti => .cuti

inductive Obj
  | rupa | sadda | gandha | rasa | photthabba | kamaOther | mahaggata | lokuttara | agga | nibbana | pannatti
  deriving DecidableEq, Repr

def Obj.all : List Obj :=
  [.rupa, .sadda, .gandha, .rasa, .photthabba, .kamaOther, .mahaggata, .lokuttara, .agga, .nibbana, .pannatti]

def Obj.kama (o : Obj) : Bool := [Obj.rupa, .sadda, .gandha, .rasa, .photthabba, .kamaOther].contains o

def senseObj : Nat → Obj
  | 1 => .rupa | 2 => .sadda | 3 => .gandha | 4 => .rasa | _ => .photthabba

inductive Rupa
  | pathavi | apo | tejo | vayo
  | cakkhu | sota | ghana | jivha | kaya
  | vanna | sadda | gandha | rasa
  | itthatta | purisatta | hadaya | jivita | ahara
  | akasa | kayavinnatti | vacivinnatti | lahuta | muduta | kammannata
  | upacaya | santati | jarata | aniccata
  deriving DecidableEq, Repr

def Rupa.all : List Rupa :=
  [.pathavi, .apo, .tejo, .vayo, .cakkhu, .sota, .ghana, .jivha, .kaya, .vanna, .sadda, .gandha, .rasa,
   .itthatta, .purisatta, .hadaya, .jivita, .ahara,
   .akasa, .kayavinnatti, .vacivinnatti, .lahuta, .muduta, .kammannata, .upacaya, .santati, .jarata, .aniccata]

def pasada : List Rupa := [.cakkhu, .sota, .ghana, .jivha, .kaya]

def gocara : List Rupa := [.vanna, .sadda, .gandha, .rasa, .pathavi, .tejo, .vayo]

def indriyaRupa : List Rupa := pasada ++ [.itthatta, .purisatta, .jivita]

def anipphanna : List Rupa :=
  [.akasa, .kayavinnatti, .vacivinnatti, .lahuta, .muduta, .kammannata, .upacaya, .santati, .jarata, .aniccata]

inductive Origin | kamma | citta | utu | ahara deriving DecidableEq, Repr

def Origin.all : List Origin := [.kamma, .citta, .utu, .ahara]

def originTable : Rupa → Origin → Bool
  | .hadaya, o | .cakkhu, o | .sota, o | .ghana, o | .jivha, o | .kaya, o
  | .itthatta, o | .purisatta, o | .jivita, o => o == .kamma
  | .kayavinnatti, o | .vacivinnatti, o => o == .citta
  | .sadda, o => o == .citta || o == .utu
  | .lahuta, o | .muduta, o | .kammannata, o => o != .kamma
  | .upacaya, _ | .santati, _ | .jarata, _ | .aniccata, _ => false
  | _, _ => true

inductive Dhamma | citta | cetasika (x : Cetasika) | rupa (r : Rupa) | nibbana deriving DecidableEq, Repr

inductive PapaCat | asava | ogha | yoga | gantha | upadana | nivarana | anusaya | samyojanaSutta | samyojanaAbhi | kilesa
  deriving DecidableEq, Repr

def PapaCat.all : List PapaCat :=
  [.asava, .ogha, .yoga, .gantha, .upadana, .nivarana, .anusaya, .samyojanaSutta, .samyojanaAbhi, .kilesa]

def PapaCat.size : PapaCat → Nat
  | .asava | .ogha | .yoga | .gantha | .upadana => 4 | .nivarana => 6 | .anusaya => 7
  | .samyojanaSutta | .samyojanaAbhi | .kilesa => 10

inductive MissakaCat | hetu | jhananga | maggangaRight | maggangaWrong | indriya | bala | adhipati | ahara
  deriving DecidableEq, Repr

def MissakaCat.all : List MissakaCat := [.hetu, .jhananga, .maggangaRight, .maggangaWrong, .indriya, .bala, .adhipati, .ahara]

def MissakaCat.size : MissakaCat → Nat
  | .hetu => 6 | .jhananga => 7 | .maggangaRight => 8 | .maggangaWrong => 4 | .indriya => 22 | .bala => 9
  | .adhipati => 4 | .ahara => 4

inductive BodhiCat | satipatthana | sammappadhana | iddhipada | indriya | bala | bojjhanga | magganga
  deriving DecidableEq, Repr

def BodhiCat.all : List BodhiCat := [.satipatthana, .sammappadhana, .iddhipada, .indriya, .bala, .bojjhanga, .magganga]

def BodhiCat.size : BodhiCat → Nat
  | .satipatthana | .sammappadhana | .iddhipada => 4 | .indriya | .bala => 5 | .bojjhanga => 7 | .magganga => 8

inductive SabbaCat | khandha | upadanakkhandha | ayatana | dhatu | sacca deriving DecidableEq, Repr

def SabbaCat.all : List SabbaCat := [.khandha, .upadanakkhandha, .ayatana, .dhatu, .sacca]

def SabbaCat.size : SabbaCat → Nat
  | .khandha | .upadanakkhandha => 5 | .ayatana => 12 | .dhatu => 18 | .sacca => 4

inductive Kammatthana
  | kasina (n : Nat) | asubha (n : Nat) | anussati (n : Nat) | appamanna (n : Nat) | sanna | vavatthana | aruppa (n : Nat)
  deriving DecidableEq, Repr

def kammatthana40 : List (List Kammatthana) :=
  [(List.range 10).map (Kammatthana.kasina ·.succ), (List.range 10).map (Kammatthana.asubha ·.succ),
   (List.range 10).map (Kammatthana.anussati ·.succ), (List.range 4).map (Kammatthana.appamanna ·.succ),
   [.sanna], [.vavatthana], (List.range 4).map (Kammatthana.aruppa ·.succ)]

def jhanaTable : Kammatthana → Nat → Bool
  | .kasina _, n | .anussati 10, n => 1 ≤ n && n ≤ 5
  | .asubha _, n | .anussati 9, n => n == 1
  | .appamanna 4, n => n == 5
  | .appamanna _, n => 1 ≤ n && n ≤ 4
  | .aruppa _, n => n == 6
  | _, _ => false

def kiccaTable (c : Citta) : Kicca → Bool
  | .patisandhi | .bhavanga | .cuti =>
      c.jati == .vipaka && ((c.bhumi == .kama && c.root == .none && c.dhatu == .manovinnana && c.vedana == .upekkha) ||
        (c.bhumi == .kama && c.root == .beautiful) || c.bhumi == .rupa || c.bhumi == .arupa)
  | .avajjana => c.jati == .kiriya && c.root == .none && c.vedana == .upekkha
  | .dassana => c.dhatu == .sense 1 | .savana => c.dhatu == .sense 2 | .ghayana => c.dhatu == .sense 3
  | .sayana => c.dhatu == .sense 4 | .phusana => c.dhatu == .sense 5
  | .sampaticchana => c.jati == .vipaka && c.dhatu == .mano
  | .santirana => c.jati == .vipaka && c.bhumi == .kama && c.root == .none && c.dhatu == .manovinnana
  | .votthabbana => c.jati == .kiriya && c.root == .none && c.vedana == .upekkha && c.dhatu == .manovinnana
  | .javana => c.jati == .kusala || c.jati == .akusala || (c.jati == .vipaka && c.bhumi == .lokuttara) ||
      (c.jati == .kiriya && !(c.root == .none && c.vedana == .upekkha))
  | .tadarammana => c.jati == .vipaka && c.bhumi == .kama && (c.root == .beautiful || (c.root == .none && c.dhatu == .manovinnana))

def beautiful : List Cetasika := beautifulUniversals ++ abstinences ++ illimitables ++ [Cetasika.panna]

def doorOf (c : Citta) : Nat := match c.dhatu with | .sense d => d | _ => 0

def num {α : Type} (l : List α) (p : α → Bool) : Nat := (l.filter p).length

def reckon89 (c : Citta) : Citta :=
  if c.bhumi == .lokuttara then { c with jhana := 1, vedana := .somanassa } else c

structure Tax where
  
  kinds : List Citta
  
  cets : List Cetasika
  
  assoc : Citta → Cetasika → Bool
  
  kicca : Citta → Kicca → Bool
  
  abhinna : Citta → Bool
  
  scope : Citta → Bool → Obj → Bool
  
  salakkhana : List Dhamma
  
  rupas : List Rupa
  
  nipphanna : Rupa → Bool
  
  internal : Rupa → Bool
  gross : Rupa → Bool
  clung : Rupa → Bool
  visible : Rupa → Bool
  
  origin : Rupa → Origin → Bool
  
  base : Rupa → Bool
  door : Rupa → Bool
  faculty : Rupa → Bool
  
  papa : PapaCat → List (List Cetasika)
  missaka : MissakaCat → List (List Dhamma)
  bodhi : BodhiCat → List (List Dhamma)
  sabba : SabbaCat → List (List Dhamma)
  
  dhammayatana : List Dhamma
  
  kammatthana : List (List Kammatthana)
  
  kjhana : Kammatthana → Nat → Bool

def Tax.kinds89 (t : Tax) : List Citta := (t.kinds.map reckon89).eraseDups

def Tax.modes (t : Tax) : List (Citta × Bool) := t.kinds89.map (·, false) ++ (t.kinds89.filter t.abhinna).map (·, true)

def Tax.inDhammaBase (t : Tax) : Dhamma → Bool
  | .cetasika x => t.cets.contains x
  | .rupa r => t.rupas.contains r && !t.gross r
  | .nibbana => true
  | .citta => false

def a27_seventytwo (t : Tax) : Prop := t.salakkhana.Nodup ∧ t.salakkhana.length = 72

def a28_eightynine (t : Tax) : Prop :=
  t.kinds.Nodup ∧ t.kinds89.length = 89 ∧ num t.kinds89 (·.bhumi == .kama) = 54 ∧
  num t.kinds89 (·.bhumi == .rupa) = 15 ∧ num t.kinds89 (·.bhumi == .arupa) = 12 ∧ num t.kinds89 (·.bhumi == .lokuttara) = 8

def a28_onetwentyone (t : Tax) : Prop :=
  t.kinds.length = 121 ∧ num t.kinds (·.bhumi == .lokuttara) = 40 ∧
  ∀ c ∈ t.kinds89, c.bhumi = .lokuttara → ∀ n ∈ [1, 2, 3, 4, 5], ∃ k ∈ t.kinds, reckon89 k = c ∧ k.jhana = n

def a29_fiftytwo (t : Tax) : Prop :=
  t.cets.Nodup ∧ t.cets.length = 52 ∧ num t.cets (universals.contains ·) = 7 ∧ num t.cets (occasionals.contains ·) = 6 ∧
  num t.cets (unwholesome.contains ·) = 14 ∧ num t.cets (beautiful.contains ·) = 25

def a31_universals (t : Tax) : Prop := ∀ c ∈ t.kinds, ∀ x ∈ universals, t.assoc c x = true

def a32_generated (t : Tax) : Prop := (∀ c ∈ t.kinds, c ∈ cittas121) ∧ ∀ c ∈ cittas121, c ∈ t.kinds

def a32_association (t : Tax) : Prop := ∀ c ∈ t.kinds, ∀ x ∈ FormalAbhidhamma.all, t.assoc c x = arises c x

def a33_feelings (t : Tax) : Prop :=
  num t.kinds (·.vedana == .sukha) = 1 ∧ num t.kinds (·.vedana == .dukkha) = 1 ∧ num t.kinds (·.vedana == .somanassa) = 62 ∧
  num t.kinds (·.vedana == .domanassa) = 2 ∧ num t.kinds (·.vedana == .upekkha) = 55

def a34_roots (t : Tax) : Prop :=
  num t.kinds89 (hetus · == 0) = 18 ∧ num t.kinds89 (hetus · == 1) = 2 ∧ num t.kinds89 (hetus · == 2) = 22 ∧
  num t.kinds89 (hetus · == 3) = 47

def a35_every_function (t : Tax) : Prop := ∀ k ∈ Kicca.all, ∃ c ∈ t.kinds89, t.kicca c k = true

def a35_counts (t : Tax) : Prop :=
  num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 1) = 68 ∧ num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 2) = 2 ∧
  num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 3) = 9 ∧ num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 4) = 8 ∧
  num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 5) = 2

def a38_one_object (t : Tax) : Prop :=
  ∀ c ∈ t.kinds89, isSense c = true → ∀ o ∈ Obj.all, t.scope c false o = (o == senseObj (doorOf c))

def a38_supramundane (t : Tax) : Prop :=
  ∀ c ∈ t.kinds, c.bhumi = .lokuttara → ∀ o ∈ Obj.all, t.scope c false o = (o == .nibbana)

def a38_twentyfive (t : Tax) : Prop :=
  num t.kinds89 (fun c => c.bhumi == .kama && Obj.all.all (fun o => !t.scope c false o || o.kama) && Obj.all.any (t.scope c false)) = 25

def a38_twentyone (t : Tax) : Prop :=
  num t.kinds89 (fun c => Obj.all.all (fun o => t.scope c false o == (o == .pannatti))) = 21

def a38_six_any (t : Tax) : Prop := num t.modes (fun p => Obj.all.all (t.scope p.1 p.2)) = 6

def a38_six_exalted (t : Tax) : Prop := num t.kinds89 (fun c => Obj.all.all (fun o => t.scope c false o == (o == .mahaggata))) = 6

def a38_twenty (t : Tax) : Prop :=
  num t.kinds89 (fun c => Obj.all.all (fun o => t.scope c false o == !([Obj.lokuttara, .agga, .nibbana].contains o))) = 20

def a38_five_but_agga (t : Tax) : Prop := num t.modes (fun p => Obj.all.all (fun o => t.scope p.1 p.2 o == (o != .agga))) = 5

def a35_which (t : Tax) : Prop := ∀ c ∈ t.kinds89, ∀ k ∈ Kicca.all, t.kicca c k = kiccaTable c k

def a60_twentyeight (t : Tax) : Prop := t.rupas.Nodup ∧ t.rupas.length = 28

def a60_concretely_produced (t : Tax) : Prop :=
  (∀ r ∈ Rupa.all, t.nipphanna r = !anipphanna.contains r) ∧ num t.rupas t.nipphanna = 18

def a62_internal (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.internal r = pasada.contains r

def a62_gross (t : Tax) : Prop := (∀ r ∈ Rupa.all, t.gross r = (pasada ++ gocara).contains r) ∧ num Rupa.all t.gross = 12

def a62_clung (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.clung r = t.origin r .kamma

def a62_visible (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.visible r = (r == .vanna)

def a62_base (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.base r = (pasada ++ [Rupa.hadaya]).contains r

def a62_door (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.door r = (pasada ++ [Rupa.kayavinnatti, .vacivinnatti]).contains r

def a62_faculty (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.faculty r = indriyaRupa.contains r

def a65_table (t : Tax) : Prop := ∀ r ∈ Rupa.all, ∀ o ∈ Origin.all, t.origin r o = originTable r o

def a65_counts (t : Tax) : Prop :=
  num t.rupas (t.origin · .kamma) = 18 ∧ num t.rupas (t.origin · .citta) = 15 ∧ num t.rupas (t.origin · .utu) = 13 ∧
  num t.rupas (t.origin · .ahara) = 12

def a107_fifth_jhana (t : Tax) : Prop := ∀ c ∈ t.kinds, t.abhinna c = true → c.bhumi = .rupa ∧ c.jhana = 5

def a71_sizes (t : Tax) : Prop := ∀ g ∈ PapaCat.all, (t.papa g).length = g.size

def a71_unwholesome (t : Tax) : Prop := ∀ g ∈ PapaCat.all, ∀ m ∈ t.papa g, m ≠ [] ∧ ∀ x ∈ m, unwholesome.contains x = true

def a72_sizes (t : Tax) : Prop := ∀ g ∈ MissakaCat.all, (t.missaka g).length = g.size

def a72_life_faculty (t : Tax) : Prop :=
  (∃ m ∈ t.missaka .indriya, Dhamma.rupa .jivita ∈ m) ∧ ∃ m ∈ t.missaka .indriya, Dhamma.cetasika .jivitindriya ∈ m

def a72_nutriments (t : Tax) : Prop := t.missaka .ahara = [[.rupa .ahara], [.cetasika .phassa], [.cetasika .cetana], [.citta]]

def a73_sizes (t : Tax) : Prop := ∀ g ∈ BodhiCat.all, (t.bodhi g).length = g.size

def a73_fourteen (t : Tax) : Prop := ((BodhiCat.all.map t.bodhi).flatten).eraseDups.length = 14

def a74_sizes (t : Tax) : Prop := ∀ g ∈ SabbaCat.all, (t.sabba g).length = g.size

def a74_nibbana_outside (t : Tax) : Prop := ∀ m ∈ t.sabba .khandha, Dhamma.nibbana ∉ m

def a74_sixtynine (t : Tax) : Prop :=
  t.dhammayatana.Nodup ∧ t.dhammayatana.length = 69 ∧ (∀ d ∈ t.dhammayatana, t.inDhammaBase d = true) ∧
  (∀ x ∈ t.cets, Dhamma.cetasika x ∈ t.dhammayatana) ∧ (∀ r ∈ t.rupas, t.gross r = false → Dhamma.rupa r ∈ t.dhammayatana) ∧
  Dhamma.nibbana ∈ t.dhammayatana

def a74_seven_elements (t : Tax) : Prop := (t.kinds.map (·.dhatu)).eraseDups.length = 7

def a105_forty (t : Tax) : Prop := t.kammatthana = kammatthana40

def a105_absorption (t : Tax) : Prop := ∀ s ∈ t.kammatthana.flatten, ∀ n ∈ [1, 2, 3, 4, 5, 6], t.kjhana s n = jhanaTable s n

abbrev eyeCons : Citta := { jati := .vipaka, bhumi := .kama, vedana := .upekkha, root := .none, dhatu := .sense 1 }

abbrev manoAdverting : Citta := { jati := .kiriya, bhumi := .kama, vedana := .upekkha, root := .none }

abbrev nanaKiriya (joy p : Bool) : Citta :=
  { jati := .kiriya, bhumi := .kama, vedana := joyOr joy, root := .beautiful, knowing := true, prompted := p }

abbrev firstJhana : Citta :=
  { jati := .kusala, bhumi := .rupa, vedana := .somanassa, root := .beautiful, knowing := true, jhana := 1 }

abbrev entryPath (n : Nat) : Citta :=
  { jati := .kusala, bhumi := .lokuttara, vedana := if n == 5 then .upekkha else .somanassa, root := .beautiful,
    knowing := true, jhana := n, path := 1 }

end FormalAbhidhamma.Model
