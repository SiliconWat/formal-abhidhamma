/-
  model/Tax.lean — the TAX part of the one World: the kinds the world has, and their counts.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, correction 1, amendments 1 and 2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything.

  The vocabulary (the axes of a citta-type, the 52 cetasikas) is the generator's (`sangaha/Citta.lean`,
  `control/Cetasika.lean`) and its rules (`sangaha/Rules.lean`); this file imports them and adds the vocabularies of
  chapters 3 and 6 that the rows below need (functions, stations, objects, the 28 kinds of matter, the four origins).
  A vocabulary only names; it claims nothing. What a WORLD has — which kinds, which cetasika in which citta, which
  function, which object, which origin — is a field of `Tax`, and each row below constrains a field. So each count is a
  claim about the world, with a forbidden world on which Lean proves it false.

  Every row here is a manual row (L4, Saṅgaha chs. 1–3, 6, 7 and 9). A row with several clauses is split, one
  definition per clause, each with its own forbidden world, so a toothless clause cannot hide behind a sharp one.

  Q2′ (amendment 2): no definition here mentions a stream's moments or their order. Each counts KINDS in a finite list,
  so the audit will mark them NOT first-order in form, but off the stream: none can force a stretch to be finite.

  ⚠️ Three findings the encoding has already made, for the founder (each in its definition's comment):
  A38's "5 take any object" misreads §59 (the text says six) · A35 and A62 name lists whose members the row does not
  carry, though the cited lines do (a coverage gap of the axiom list, not of this file).
-/
import Rules
namespace FormalAbhidhamma.Model
open FormalAbhidhamma

/-! ## Vocabularies (names only; nothing here is a claim about a world) -/

/-- The fourteen functions of citta, in the text's order (Saṅgaha ch. 3 §18, `abh07t.nrf.xml:885`). -/
inductive Kicca
  | patisandhi | bhavanga | avajjana | dassana | savana | ghayana | sayana | phusana
  | sampaticchana | santirana | votthabbana | javana | tadarammana | cuti
  deriving DecidableEq, Repr

def Kicca.all : List Kicca :=
  [.patisandhi, .bhavanga, .avajjana, .dassana, .savana, .ghayana, .sayana, .phusana,
   .sampaticchana, .santirana, .votthabbana, .javana, .tadarammana, .cuti]

/-- The ten stations (§19, `:889`): the five sense functions share one, the station of the five consciousnesses. -/
inductive Thana
  | patisandhi | bhavanga | avajjana | pancavinnana | sampaticchana | santirana | votthabbana | javana | tadarammana | cuti
  deriving DecidableEq, Repr

def Kicca.thana : Kicca → Thana
  | .patisandhi => .patisandhi | .bhavanga => .bhavanga | .avajjana => .avajjana
  | .dassana | .savana | .ghayana | .sayana | .phusana => .pancavinnana
  | .sampaticchana => .sampaticchana | .santirana => .santirana | .votthabbana => .votthabbana
  | .javana => .javana | .tadarammana => .tadarammana | .cuti => .cuti

/-- Object classes, as many as chapter 3's seven object groups (§54–62, `:1057–1089`) need and no more. ⚠️ The split
    is OURS: the five sense objects · every other sense-sphere dhamma · the exalted · the supramundane path and fruit
    below arahantship · the arahant's path and fruit (§58 sets them apart) · nibbāna · concepts. -/
inductive Obj
  | rupa | sadda | gandha | rasa | photthabba | kamaOther | mahaggata | lokuttara | agga | nibbana | pannatti
  deriving DecidableEq, Repr

def Obj.all : List Obj :=
  [.rupa, .sadda, .gandha, .rasa, .photthabba, .kamaOther, .mahaggata, .lokuttara, .agga, .nibbana, .pannatti]

/-- The sense-sphere ("limited", *paritta*) objects: the five sense objects and every other sense-sphere dhamma. -/
def Obj.kama (o : Obj) : Bool := [Obj.rupa, .sadda, .gandha, .rasa, .photthabba, .kamaOther].contains o

/-- The object of the sense-consciousness at door d (1 eye … 5 body), "respectively" (*yathākkamaṃ*, §54). -/
def senseObj : Nat → Obj
  | 1 => .rupa | 2 => .sadda | 3 => .gandha | 4 => .rasa | _ => .photthabba

/-- The 28 kinds of matter in the text's order (Saṅgaha ch. 6 §4–15, `abh07t.nrf.xml:2053–2097`). `vanna` is visible
    form (*rūpa*, the visible base); the tangible is not a kind of its own: it is earth, fire and air (§6, `:2061`). -/
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

/-- Sensitive matter, the five organs (§5, `:2057`). -/
def pasada : List Rupa := [.cakkhu, .sota, .ghana, .jivha, .kaya]
/-- Objective matter as the text counts it (§6): visible form, sound, smell, taste, and the tangible as earth, fire, air. -/
def gocara : List Rupa := [.vanna, .sadda, .gandha, .rasa, .pathavi, .tejo, .vayo]
/-- The material faculties (§22, `:2149`): the five organs, the two of sex, the life faculty. The meaning of A65's
    "the faculties"; ⚠️ A62's row names this dyad without its members (see `a62_…`). -/
def indriyaRupa : List Rupa := pasada ++ [.itthatta, .purisatta, .jivita]
/-- The ten not concretely produced, as A60's row names them: space, the two intimations, the three mutabilities,
    the four characteristics (§12–15, `:2085–2097`). -/
def anipphanna : List Rupa :=
  [.akasa, .kayavinnatti, .vacivinnatti, .lahuta, .muduta, .kammannata, .upacaya, .santati, .jarata, .aniccata]

/-- The four origins of matter (ch. 6 §29–36): kamma, citta, temperature, nutriment. -/
inductive Origin | kamma | citta | utu | ahara deriving DecidableEq, Repr
def Origin.all : List Origin := [.kamma, .citta, .utu, .ahara]

/-- A65's origin table, as its row states it (ch. 6 §37–42, `abh07t.nrf.xml:2221–2241`): the heart-base and the
    faculties from kamma only · the intimations from citta only · sound from citta or temperature · the three
    mutabilities from temperature, citta and nutriment · the inseparables and space from all four · the
    characteristics from none (*na kutoci jāyanti*). -/
def originTable : Rupa → Origin → Bool
  | .hadaya, o | .cakkhu, o | .sota, o | .ghana, o | .jivha, o | .kaya, o
  | .itthatta, o | .purisatta, o | .jivita, o => o == .kamma
  | .kayavinnatti, o | .vacivinnatti, o => o == .citta
  | .sadda, o => o == .citta || o == .utu
  | .lahuta, o | .muduta, o | .kammannata, o => o != .kamma
  | .upacaya, _ | .santati, _ | .jarata, _ | .aniccata, _ => false
  | _, _ => true

/-- The ultimate entities, for A27's count: citta (one, by its characteristic), each cetasika, each kind of matter,
    nibbāna. ⚠️ Which 72 of these have their own characteristic is OURS (A27's row marks the breakdown so). -/
inductive Dhamma | citta | cetasika (x : Cetasika) | rupa (r : Rupa) | nibbana deriving DecidableEq, Repr

/-- Chapter 7's categories, by the lists A71–A74 name. Each list's MEMBERS are a world's (a field of `Tax`), each member
    given by its NATURE — the dhammas it is (one, or two: *thinamiddha* is sloth and torpor; the life faculty is
    material and mental). A member's NAME is not encoded; only what it is. -/
inductive PapaCat | asava | ogha | yoga | gantha | upadana | nivarana | anusaya | samyojanaSutta | samyojanaAbhi | kilesa
  deriving DecidableEq, Repr
def PapaCat.all : List PapaCat :=
  [.asava, .ogha, .yoga, .gantha, .upadana, .nivarana, .anusaya, .samyojanaSutta, .samyojanaAbhi, .kilesa]
/-- A71's sizes, in the row's order (the fetters twice: the Suttanta's list and the Abhidhamma's). -/
def PapaCat.size : PapaCat → Nat
  | .asava | .ogha | .yoga | .gantha | .upadana => 4 | .nivarana => 6 | .anusaya => 7
  | .samyojanaSutta | .samyojanaAbhi | .kilesa => 10

inductive MissakaCat | hetu | jhananga | maggangaRight | maggangaWrong | indriya | bala | adhipati | ahara
  deriving DecidableEq, Repr
def MissakaCat.all : List MissakaCat := [.hetu, .jhananga, .maggangaRight, .maggangaWrong, .indriya, .bala, .adhipati, .ahara]
/-- A72's sizes: 6 roots · 7 jhāna factors · 12 path factors (8 right, 4 wrong) · 22 faculties · 9 powers · 4
    predominants · 4 nutriments. -/
def MissakaCat.size : MissakaCat → Nat
  | .hetu => 6 | .jhananga => 7 | .maggangaRight => 8 | .maggangaWrong => 4 | .indriya => 22 | .bala => 9
  | .adhipati => 4 | .ahara => 4

inductive BodhiCat | satipatthana | sammappadhana | iddhipada | indriya | bala | bojjhanga | magganga
  deriving DecidableEq, Repr
def BodhiCat.all : List BodhiCat := [.satipatthana, .sammappadhana, .iddhipada, .indriya, .bala, .bojjhanga, .magganga]
/-- A73's sizes: 4 · 4 · 4 · 5 · 5 · 7 · 8 = 37. -/
def BodhiCat.size : BodhiCat → Nat
  | .satipatthana | .sammappadhana | .iddhipada => 4 | .indriya | .bala => 5 | .bojjhanga => 7 | .magganga => 8

inductive SabbaCat | khandha | upadanakkhandha | ayatana | dhatu | sacca deriving DecidableEq, Repr
def SabbaCat.all : List SabbaCat := [.khandha, .upadanakkhandha, .ayatana, .dhatu, .sacca]
/-- A74's sizes: 5 aggregates · 5 aggregates of clinging · 12 bases · 18 elements · 4 noble truths. -/
def SabbaCat.size : SabbaCat → Nat
  | .khandha | .upadanakkhandha => 5 | .ayatana => 12 | .dhatu => 18 | .sacca => 4

/-- The forty subjects of calm (ch. 9 §2, §6–12, `abh07t.nrf.xml:3033–3085`), each group numbered in the text's order:
    ten kasiṇas · ten foul objects · ten recollections (9 = mindfulness of the body, 10 = of breathing) · four
    illimitables (1 loving-kindness, 2 compassion, 3 appreciative joy, 4 equanimity) · one perception · one analysis ·
    four immaterials. -/
inductive Kammatthana
  | kasina (n : Nat) | asubha (n : Nat) | anussati (n : Nat) | appamanna (n : Nat) | sanna | vavatthana | aruppa (n : Nat)
  deriving DecidableEq, Repr

/-- The forty, grouped as the text groups them (the vocabulary; a world's own list is `Tax.kammatthana`). -/
def kammatthana40 : List (List Kammatthana) :=
  [(List.range 10).map (Kammatthana.kasina ·.succ), (List.range 10).map (Kammatthana.asubha ·.succ),
   (List.range 10).map (Kammatthana.anussati ·.succ), (List.range 4).map (Kammatthana.appamanna ·.succ),
   [.sanna], [.vavatthana], (List.range 4).map (Kammatthana.aruppa ·.succ)]

/-- from the row's cited lines, Protocol 1 correction 2 §2 (A105's last clause): which subjects reach absorption, and in which jhāna, as the row's
    own cited lines give it (ch. 9 §19–25, `:3125–3149`). `n` 1–5 is a fine-material jhāna on the fivefold scheme;
    `n = 6` is an immaterial jhāna (⚠️ that code is OURS). The ten kasiṇas and breathing: all five · the ten foul
    objects and mindfulness of the body: the first · loving-kindness, compassion, appreciative joy: the first four ·
    equanimity: the fifth · the four immaterials: the immaterial · the other ten (eight recollections, the perception,
    the analysis): access only, no absorption. -/
def jhanaTable : Kammatthana → Nat → Bool
  | .kasina _, n | .anussati 10, n => 1 ≤ n && n ≤ 5
  | .asubha _, n | .anussati 9, n => n == 1
  | .appamanna 4, n => n == 5
  | .appamanna _, n => 1 ≤ n && n ≤ 4
  | .aruppa _, n => n == 6
  | _, _ => false

/-- from the row's cited lines, Protocol 1 correction 2 §2 (A35's members): which citta-type performs which function, as the row's own cited lines
    give it (ch. 3 §20–32, `:893–941`): the 19 (two equanimity investigations, eight great resultants, nine exalted
    resultants) rebirth-linking, bhavaṅga and death · the two advertings · each sense-consciousness its own sense
    function · the two receivings · the three investigations · mind-door adverting determining · the 55 javanas
    (wholesome, unwholesome, fruition and functional, the two advertings excepted) · the eleven registrations (eight
    great resultants, three investigations). -/
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

/-- The beautiful cetasikas, the fourth class of A29 (19 + 3 + 2 + 1 = 25). -/
def beautiful : List Cetasika := beautifulUniversals ++ abstinences ++ illimitables ++ [Cetasika.panna]

/-- The door of a sense-consciousness (1 eye … 5 body); 0 for any other citta. -/
def doorOf (c : Citta) : Nat := match c.dhatu with | .sense d => d | _ => 0

/-- How many members of a list satisfy p. -/
def num {α : Type} (l : List α) (p : α → Bool) : Nat := (l.filter p).length

/-- The 89 reckoning of a citta-type: a supramundane citta reckoned without its jhāna (A28). The generator writes the
    89 reckoning's supramundane cittas at the first jhāna (`cittas89`), so that is the representative here. -/
def reckon89 (c : Citta) : Citta :=
  if c.bhumi == .lokuttara then { c with jhana := 1, vedana := .somanassa } else c

/-! ## The world's taxonomy -/

/-- What a world has, kind by kind. Nothing here fixes a count; the rows below do. -/
structure Tax where
  /-- the citta-types, in the 121 reckoning (each supramundane citta by its jhāna) -/
  kinds : List Citta
  /-- the cetasikas -/
  cets : List Cetasika
  /-- which cetasika arises in which citta-type -/
  assoc : Citta → Cetasika → Bool
  /-- which function a citta-type performs -/
  kicca : Citta → Kicca → Bool
  /-- which citta-types can occur as a super-knowledge -/
  abhinna : Citta → Bool
  /-- which objects a citta-type takes; the Bool is true when it occurs as a super-knowledge (§58–59 count those apart) -/
  scope : Citta → Bool → Obj → Bool
  /-- the ultimate entities with their own characteristic -/
  salakkhana : List Dhamma
  /-- the kinds of matter -/
  rupas : List Rupa
  /-- which kinds are concretely produced -/
  nipphanna : Rupa → Bool
  /-- matter's dyads -/
  internal : Rupa → Bool
  gross : Rupa → Bool
  clung : Rupa → Bool
  visible : Rupa → Bool
  /-- which origin can produce which kind -/
  origin : Rupa → Origin → Bool
  /-- from the row's cited lines, Protocol 1 correction 2 §2: A62's three dyads named without members -/
  base : Rupa → Bool
  door : Rupa → Bool
  faculty : Rupa → Bool
  /-- chapter 7's categories: each member by its nature -/
  papa : PapaCat → List (List Cetasika)
  missaka : MissakaCat → List (List Dhamma)
  bodhi : BodhiCat → List (List Dhamma)
  sabba : SabbaCat → List (List Dhamma)
  /-- the members of the mind-object base (A74) -/
  dhammayatana : List Dhamma
  /-- the subjects of calm, grouped -/
  kammatthana : List (List Kammatthana)
  /-- from the row's cited lines, Protocol 1 correction 2 §2: which jhāna a subject reaches (n = 6 the immaterial) -/
  kjhana : Kammatthana → Nat → Bool

/-- The citta-types in the 89 reckoning. -/
def Tax.kinds89 (t : Tax) : List Citta := (t.kinds.map reckon89).eraseDups

/-- The citta-types as they take objects: each type, and the types that also occur as a super-knowledge, again
    (chapter 3 §58–59 counts those apart: 89 + 2 = 91). -/
def Tax.modes (t : Tax) : List (Citta × Bool) := t.kinds89.map (·, false) ++ (t.kinds89.filter t.abhinna).map (·, true)

/-- Whether a dhamma belongs to the mind-object base as A74 composes it: a cetasika, subtle matter, or nibbāna. -/
def Tax.inDhammaBase (t : Tax) : Dhamma → Bool
  | .cetasika x => t.cets.contains x
  | .rupa r => t.rupas.contains r && !t.gross r
  | .nibbana => true
  | .citta => false

/-! ## The rows -/

/-- A27 (L4, ch. 7 §1, `abh07t.nrf.xml:2421`): there are 72 ultimate entities with their own characteristic
    (*dvāsattatividhā … vatthudhammā salakkhaṇā*). ⚠️ The row fixes the COUNT only: which 72 (1 + 52 + 18 + 1) is OURS,
    a declared choice, never an axiom. So this definition is weak by the row's own words. -/
def a27_seventytwo (t : Tax) : Prop := t.salakkhana.Nodup ∧ t.salakkhana.length = 72

/-- A28, the 89 (L4, ch. 1 §35–37, `:241–261`): citta has 89 types, 54 sense-sphere, 15 fine-material, 12
    immaterial, 8 supramundane. -/
def a28_eightynine (t : Tax) : Prop :=
  t.kinds.Nodup ∧ t.kinds89.length = 89 ∧ num t.kinds89 (·.bhumi == .kama) = 54 ∧
  num t.kinds89 (·.bhumi == .rupa) = 15 ∧ num t.kinds89 (·.bhumi == .arupa) = 12 ∧ num t.kinds89 (·.bhumi == .lokuttara) = 8

/-- A28, the 121 (L4, ch. 1 §38–43, `:269–309`): or 121, when each supramundane citta is reckoned by the five jhānas
    (8 × 5 = 40): every supramundane type of the 89 reckoning occurs at each of the five jhānas. -/
def a28_onetwentyone (t : Tax) : Prop :=
  t.kinds.length = 121 ∧ num t.kinds (·.bhumi == .lokuttara) = 40 ∧
  ∀ c ∈ t.kinds89, c.bhumi = .lokuttara → ∀ n ∈ [1, 2, 3, 4, 5], ∃ k ∈ t.kinds, reckon89 k = c ∧ k.jhana = n

/-- A29 (L4, ch. 2 §2–9, `:341–385`): there are 52 cetasikas in four classes, 7 universal · 6 occasional · 14
    unwholesome · 25 beautiful. -/
def a29_fiftytwo (t : Tax) : Prop :=
  t.cets.Nodup ∧ t.cets.length = 52 ∧ num t.cets (universals.contains ·) = 7 ∧ num t.cets (occasionals.contains ·) = 6 ∧
  num t.cets (unwholesome.contains ·) = 14 ∧ num t.cets (beautiful.contains ·) = 25

/-- A31 (L4, ch. 2 §2, `:341`; §12, `:413`): the seven universals occur in every citta-type. (Its clause "so every
    mind-moment has an object and a contact" is about moments, and goes to the MIND link.) -/
def a31_universals (t : Tax) : Prop := ∀ c ∈ t.kinds, ∀ x ∈ universals, t.assoc c x = true

/-- A32, the generator (L4, ch. 2 §10–59, `:393–749`): the citta-types are exactly the ones the nine generator
    clauses build (`sangaha/Citta.lean`, none naming a citta). -/
def a32_generated (t : Tax) : Prop := (∀ c ∈ t.kinds, c ∈ cittas121) ∧ ∀ c ∈ cittas121, c ∈ t.kinds

/-- A32, the association rules (same lines): which cetasika arises in which citta-type is exactly what the 18 general
    rules say (`sangaha/Rules.lean` `arises`). VARIANT, not entered: the *keci* reading of §30 (`illimitablesKeci`,
    `:529`), tested on its own after the base. -/
def a32_association (t : Tax) : Prop := ∀ c ∈ t.kinds, ∀ x ∈ FormalAbhidhamma.all, t.assoc c x = arises c x

/-- A33 (L4, ch. 3 §3–9, `:793–825`): feeling is threefold or fivefold (by the type, `Vedana`); bodily pleasure and
    bodily pain each in ONE citta, joy in 62, grief in 2, equanimity in 55 (the 121 reckoning). -/
def a33_feelings (t : Tax) : Prop :=
  num t.kinds (·.vedana == .sukha) = 1 ∧ num t.kinds (·.vedana == .dukkha) = 1 ∧ num t.kinds (·.vedana == .somanassa) = 62 ∧
  num t.kinds (·.vedana == .domanassa) = 2 ∧ num t.kinds (·.vedana == .upekkha) = 55

/-- A34 (L4, ch. 3 §10–17, `:833–877`): six roots (by the type, `Root` and `hetus`); 18 cittas rootless, 2
    one-rooted, 22 two-rooted, 47 three-rooted (the 89 reckoning). -/
def a34_roots (t : Tax) : Prop :=
  num t.kinds89 (hetus · == 0) = 18 ∧ num t.kinds89 (hetus · == 1) = 2 ∧ num t.kinds89 (hetus · == 2) = 22 ∧
  num t.kinds89 (hetus · == 3) = 47

/-- A35, the fourteen (L4, ch. 3 §18–19, `:885–889`): citta performs 14 functions (by the type, `Kicca`) in 10
    stations (by the type, `Kicca.thana`); each function is performed by some citta-type. -/
def a35_every_function (t : Tax) : Prop := ∀ k ∈ Kicca.all, ∃ c ∈ t.kinds89, t.kicca c k = true

/-- A35, the counts (L4, §34, `:953–957`): 68 citta-types have one function, 2 have two, 9 three, 8 four, 2 five (the
    89 reckoning). ⚠️ COVERAGE GAP, for the founder: the cited lines (§20–32, `:893–941`) also say WHICH types perform
    each function (the 19 for rebirth-linking, bhavaṅga and death; the 55 javanas; the 11 registrations …). The row
    carries only the counts, so only the counts are encoded (literal first, Protocol 1 §7.1). Widening the row is a
    change to the axiom list, which Protocol 1 fixes at `332b501`: a correction, the founder's call. -/
def a35_counts (t : Tax) : Prop :=
  num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 1) = 68 ∧ num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 2) = 2 ∧
  num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 3) = 9 ∧ num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 4) = 8 ∧
  num t.kinds89 (fun c => num Kicca.all (t.kicca c) == 5) = 2

/-- A38, the sense-consciousnesses (L4, ch. 3 §54, `:1057`): each of the five takes one kind of object, respectively
    (*yathākkamaṃ rūpādiekekārammaṇāneva*): eye-consciousness visible form only, … body-consciousness the tangible only. -/
def a38_one_object (t : Tax) : Prop :=
  ∀ c ∈ t.kinds89, isSense c = true → ∀ o ∈ Obj.all, t.scope c false o = (o == senseObj (doorOf c))

/-- A38, the supramundane (L4, §62, `:1089`): supramundane cittas take only nibbāna. -/
def a38_supramundane (t : Tax) : Prop :=
  ∀ c ∈ t.kinds, c.bhumi = .lokuttara → ∀ o ∈ Obj.all, t.scope c false o = (o == .nibbana)

/-- A38, the limited (L4, §56 and the verse §63, `:1065`, `:1093`): 25 sense-sphere citta-types take only sense-sphere
    objects. -/
def a38_twentyfive (t : Tax) : Prop :=
  num t.kinds89 (fun c => c.bhumi == .kama && Obj.all.all (fun o => !t.scope c false o || o.kama) && Obj.all.any (t.scope c false)) = 25

/-- A38, concepts (L4, §61 and §63, `:1085`, `:1097`): 21 citta-types take concepts (the remaining exalted cittas;
    the seven groups partition, so these take concepts only). -/
def a38_twentyone (t : Tax) : Prop :=
  num t.kinds89 (fun c => Obj.all.all (fun o => t.scope c false o == (o == .pannatti))) = 21

/-- A38, any object (L4, §59 and §63, `:1077`, `:1105`). ⚠️ FINDING, for the founder: the row says "5 take any object";
    the text says SIX — the four knowledge-associated sense-sphere functionals, the functional super-knowledge and
    determining (*… kiriyābhiññāvoṭṭhabbanañceti sabbathāpi sabbārammaṇāni*), and the verse (*pañca sabbattha chacceti*):
    five take every object except the arahant's path and fruit (§58), six take every object. Encoded as the TEXT says
    (Protocol 1 correction 2 §1, 2026-10-18); the row's literal 5 is this definition's forbidden world. Counted over the
    citta-types and the two that also occur as a super-knowledge (§58–59 count those apart: 89 + 2 = 91). -/
def a38_six_any (t : Tax) : Prop := num t.modes (fun p => Obj.all.all (t.scope p.1 p.2)) = 6

/-- A38, exalted objects (from the row's cited lines, not its words — Protocol 1 correction 2 §2; §60 and §63, `:1081`,
    `:1093`): six citta-types take exalted objects only (the second and fourth immaterial, in their three classes). -/
def a38_six_exalted (t : Tax) : Prop := num t.kinds89 (fun c => Obj.all.all (fun o => t.scope c false o == (o == .mahaggata))) = 6

/-- A38, all but the supramundane (from the row's cited lines, Protocol 1 correction 2 §2; §57 and §63, `:1069`, `:1101`): twenty citta-types (the
    unwholesome and the knowledge-dissociated sense-sphere javanas) take every object except the supramundane. -/
def a38_twenty (t : Tax) : Prop :=
  num t.kinds89 (fun c => Obj.all.all (fun o => t.scope c false o == !([Obj.lokuttara, .agga, .nibbana].contains o))) = 20

/-- A38, all but the arahant's path and fruit (from the row's cited lines, Protocol 1 correction 2 §2; §58 and §63, `:1073`, `:1101–1105`): five (the
    knowledge-associated sense-sphere wholesome and the wholesome super-knowledge) take every object except those. -/
def a38_five_but_agga (t : Tax) : Prop := num t.modes (fun p => Obj.all.all (fun o => t.scope p.1 p.2 o == (o != .agga))) = 5

/-- A35, which (from the row's cited lines, Protocol 1 correction 2 §2): every citta-type performs exactly the functions `kiccaTable` gives it. -/
def a35_which (t : Tax) : Prop := ∀ c ∈ t.kinds89, ∀ k ∈ Kicca.all, t.kicca c k = kiccaTable c k

/-- A60, the 28 (L4, ch. 6 §3–17, `:2049–2121`): 28 kinds of matter (four great elements and 24 derived, in eleven
    classes, by the type). -/
def a60_twentyeight (t : Tax) : Prop := t.rupas.Nodup ∧ t.rupas.length = 28

/-- A60, concretely produced (L4, §11–17, `:2081–2121`): 18 are concretely produced (*nipphanna*) and 10 are not:
    space, the two intimations, the three mutabilities, the four characteristics. -/
def a60_concretely_produced (t : Tax) : Prop :=
  (∀ r ∈ Rupa.all, t.nipphanna r = !anipphanna.contains r) ∧ num t.rupas t.nipphanna = 18

/-- A62, internal (L4, ch. 6 §19, `:2137`): internal matter is the five sensitive organs; the rest is external.
    ⚠️ COVERAGE GAP, for the founder: the row then names three dyads, "base or not; door or not; faculty or not",
    without their members, which its cited lines give (§20–22, `:2141–2149`: six, seven and eight). A dyad with no
    members has no content to encode, so those three clauses are NOT FORMALIZABLE as the row stands. -/
def a62_internal (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.internal r = pasada.contains r

/-- A62, gross (L4, §23, `:2153`): gross, near and impinging are the 12 organs and objects (the five organs and the
    seven objects of §6, the tangible being earth, fire and air); the rest is subtle, far and non-impinging. -/
def a62_gross (t : Tax) : Prop := (∀ r ∈ Rupa.all, t.gross r = (pasada ++ gocara).contains r) ∧ num Rupa.all t.gross = 12

/-- A62, clung-to (L4, §24, `:2157`): clung-to matter is kamma-born matter. Read here at the level of KINDS: the kinds
    that can be clung-to are the kinds kamma can produce. (Of a kalāpa's members it is a MAT clause, encoded there.) -/
def a62_clung (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.clung r = t.origin r .kamma

/-- A62, visible (L4, §25, `:2161`): only visible form is visible; the rest is invisible. -/
def a62_visible (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.visible r = (r == .vanna)

/-- A62, base (from the row's cited lines, Protocol 1 correction 2 §2; §20, `:2141`): the base is the five organs and the heart-base, six. -/
def a62_base (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.base r = (pasada ++ [Rupa.hadaya]).contains r

/-- A62, door (from the row's cited lines, Protocol 1 correction 2 §2; §21, `:2145`): the doors are the five organs and the two intimations, seven. -/
def a62_door (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.door r = (pasada ++ [Rupa.kayavinnatti, .vacivinnatti]).contains r

/-- A62, faculty (from the row's cited lines, Protocol 1 correction 2 §2; §22, `:2149`): the faculties are the five organs, the two of sex and the
    life faculty, eight. -/
def a62_faculty (t : Tax) : Prop := ∀ r ∈ Rupa.all, t.faculty r = indriyaRupa.contains r

/-- A65, the table (L4, ch. 6 §37–42, `:2221–2241`): which origin produces which kind is exactly `originTable`. -/
def a65_table (t : Tax) : Prop := ∀ r ∈ Rupa.all, ∀ o ∈ Origin.all, t.origin r o = originTable r o

/-- A65, the counts (L4, §43, `:2245–2249`): 18 kinds are kamma-born, 15 mind-born, 13 temperature-born, 12
    nutriment-born. -/
def a65_counts (t : Tax) : Prop :=
  num t.rupas (t.origin · .kamma) = 18 ∧ num t.rupas (t.origin · .citta) = 15 ∧ num t.rupas (t.origin · .utu) = 13 ∧
  num t.rupas (t.origin · .ahara) = 12

/-- A107 (L4, ch. 9 §41–42, `:3221–3233`): the super-knowledges arise from the fifth jhāna — the fine-material fifth
    jhāna occurring as a super-knowledge (*abhiññāvasena pavattamānaṃ pana rūpāvacarapañcamajjhānaṃ*). The five
    (psychic power, the divine ear, knowing others' minds, recollecting past lives, the divine eye) are names. -/
def a107_fifth_jhana (t : Tax) : Prop := ∀ c ∈ t.kinds, t.abhinna c = true → c.bhumi = .rupa ∧ c.jhana = 5

/-- A71, the lists (L4, ch. 7 §3–12, `abh07t.nrf.xml:2437–2473`): 4 taints, 4 floods, 4 bonds, 4 bodily knots, 4
    clingings, 6 hindrances, 7 latent tendencies, 10 fetters in the Suttanta's list and 10 in the Abhidhamma's, 10
    defilements (nine groups: the fetters are one group in two lists). -/
def a71_sizes (t : Tax) : Prop := ∀ g ∈ PapaCat.all, (t.papa g).length = g.size

/-- A71, their nature (same lines; the verse §14, `:2481–2501`): the nine groups are made of the 14 unwholesome
    cetasikas — every member is one or more of them. (Which ones each member is, §13 and the verse's counts by nature,
    the row does not carry.) -/
def a71_unwholesome (t : Tax) : Prop := ∀ g ∈ PapaCat.all, ∀ m ∈ t.papa g, m ≠ [] ∧ ∀ x ∈ m, unwholesome.contains x = true

/-- A72, the lists (L4, ch. 7 §15–21, `:2509–2533`): 6 roots, 7 jhāna factors, 12 path factors (8 right, 4 wrong),
    22 faculties, 9 powers, 4 predominants, 4 nutriments. -/
def a72_sizes (t : Tax) : Prop := ∀ g ∈ MissakaCat.all, (t.missaka g).length = g.size

/-- A72, the life faculty (§18 and §25, `:2521`, `:2549`): the material and the mental life faculty are among the 22. -/
def a72_life_faculty (t : Tax) : Prop :=
  (∃ m ∈ t.missaka .indriya, Dhamma.rupa .jivita ∈ m) ∧ ∃ m ∈ t.missaka .indriya, Dhamma.cetasika .jivitindriya ∈ m

/-- A72, the nutriments (§21, `:2533`): edible food, contact, mental volition, consciousness, in that order
    (*kabaḷīkāro āhāro, phasso dutiyo, manosañcetanā tatiyā, viññāṇaṃ catutthaṃ*). -/
def a72_nutriments (t : Tax) : Prop := t.missaka .ahara = [[.rupa .ahara], [.cetasika .phassa], [.cetasika .cetana], [.citta]]

/-- A73, the 37 (L4, ch. 7 §30–36, `:2585–2609`): the requisites of enlightenment in seven groups, 4 foundations of
    mindfulness, 4 right efforts, 4 bases of power, 5 faculties, 5 powers, 7 factors of enlightenment, 8 path factors. -/
def a73_sizes (t : Tax) : Prop := ∀ g ∈ BodhiCat.all, (t.bodhi g).length = g.size

/-- A73, the fourteen (§37–39, `:2613–2633`): by nature they are 14 dhammas (*cuddasete sabhāvato*). -/
def a73_fourteen (t : Tax) : Prop := ((BodhiCat.all.map t.bodhi).flatten).eraseDups.length = 14

/-- A74, the lists (L4, ch. 7 §42–46, `:2673–2689`): 5 aggregates, 5 aggregates of clinging, 12 bases, 18 elements,
    4 noble truths. -/
def a74_sizes (t : Tax) : Prop := ∀ g ∈ SabbaCat.all, (t.sabba g).length = g.size

/-- A74, nibbāna (§50, `:2713`): nibbāna is outside the aggregates (*khandhasaṅgahanissaṭaṃ*). -/
def a74_nibbana_outside (t : Tax) : Prop := ∀ m ∈ t.sabba .khandha, Dhamma.nibbana ∉ m

/-- A74, the mind-object base (§47, `:2693`): 69 dhammas, the cetasikas, subtle matter and nibbāna, make up the
    mind-object base and element — so the world's 52 cetasikas (A29) and its 16 subtle kinds (A62) must leave room for
    exactly one more. -/
def a74_sixtynine (t : Tax) : Prop :=
  t.dhammayatana.Nodup ∧ t.dhammayatana.length = 69 ∧ (∀ d ∈ t.dhammayatana, t.inDhammaBase d = true) ∧
  (∀ x ∈ t.cets, Dhamma.cetasika x ∈ t.dhammayatana) ∧ (∀ r ∈ t.rupas, t.gross r = false → Dhamma.rupa r ∈ t.dhammayatana) ∧
  Dhamma.nibbana ∈ t.dhammayatana

/-- A74, the seven (§48, `:2697`): the mind-base divides into the seven consciousness elements (*manāyatanameva
    sattaviññāṇadhātuvasena bhijjati*): the world's citta-types fall under exactly seven elements. -/
def a74_seven_elements (t : Tax) : Prop := (t.kinds.map (·.dhatu)).eraseDups.length = 7

/-- A105, the forty (L4, ch. 9 §2–12, `:3033–3085`): 40 subjects in seven groups (10 kasiṇas, 10 foul objects, 10
    recollections, 4 illimitables, 1 perception, 1 analysis, 4 immaterials). The row's six temperaments, three stages
    of development and three signs are names: by the type, nothing to constrain. -/
def a105_forty (t : Tax) : Prop := t.kammatthana = kammatthana40

/-- A105, absorption (from the row's cited lines, Protocol 1 correction 2 §2: the row says "which subjects reach absorption, and which jhāna", and its
    cited lines give it, §19–25): every subject reaches exactly the jhānas `jhanaTable` gives it. -/
def a105_absorption (t : Tax) : Prop := ∀ s ∈ t.kammatthana.flatten, ∀ n ∈ [1, 2, 3, 4, 5, 6], t.kjhana s n = jhanaTable s n

/-! ## Forbidden worlds — one per definition, each a taxonomy its text rules out. -/

/-- A world with nothing in it, and every field false: the base the forbidden worlds below change one field of. -/
abbrev bare : Tax :=
  { kinds := [], cets := [], assoc := fun _ _ => false, kicca := fun _ _ => false, abhinna := fun _ => false,
    scope := fun _ _ _ => false, salakkhana := [], rupas := [], nipphanna := fun _ => false, internal := fun _ => false,
    gross := fun _ => false, clung := fun _ => false, visible := fun _ => false, origin := fun _ _ => false,
    base := fun _ => false, door := fun _ => false, faculty := fun _ => false, papa := fun _ => [], missaka := fun _ => [],
    bodhi := fun _ => [], sabba := fun _ => [], dhammayatana := [], kammatthana := [], kjhana := fun _ _ => false }

/-- Eye-consciousness, the resultant of wholesome kamma. -/
abbrev eyeCons : Citta := { jati := .vipaka, bhumi := .kama, vedana := .upekkha, root := .none, dhatu := .sense 1 }
/-- Mind-door adverting (determining in the five-door process). -/
abbrev manoAdverting : Citta := { jati := .kiriya, bhumi := .kama, vedana := .upekkha, root := .none }
/-- A knowledge-associated sense-sphere functional citta: joy or not, prompted or not. -/
abbrev nanaKiriya (joy p : Bool) : Citta :=
  { jati := .kiriya, bhumi := .kama, vedana := joyOr joy, root := .beautiful, knowing := true, prompted := p }
/-- The first-jhāna fine-material wholesome citta. -/
abbrev firstJhana : Citta :=
  { jati := .kusala, bhumi := .rupa, vedana := .somanassa, root := .beautiful, knowing := true, jhana := 1 }
/-- The stream-entry path, at the first jhāna and at the second. -/
abbrev entryPath (n : Nat) : Citta :=
  { jati := .kusala, bhumi := .lokuttara, vedana := if n == 5 then .upekkha else .somanassa, root := .beautiful,
    knowing := true, jhana := n, path := 1 }

/-- Seventy-one entities with their own characteristic (citta, the 52 cetasikas, 18 matter; nibbāna left out). -/
abbrev seventyone : Tax := { bare with salakkhana := Dhamma.citta :: (FormalAbhidhamma.all.map Dhamma.cetasika ++
  ((Rupa.all.filter (!anipphanna.contains ·)).map Dhamma.rupa)) }

theorem a27_forbids_seventyone : ¬ a27_seventytwo seventyone := by unfold a27_seventytwo; decide

/-- The 89 types without their supramundane cittas: the 81 mundane types only. -/
abbrev mundaneOnly : Tax := { bare with kinds := mundane }

theorem a28_forbids_mundaneOnly : ¬ a28_eightynine mundaneOnly := by unfold a28_eightynine; decide

/-- The supramundane reckoned once only: the stream-entry path at the first jhāna, with no second-jhāna path. -/
abbrev oneJhanaPath : Tax := { bare with kinds := [entryPath 1] }

theorem a28_forbids_oneJhanaPath : ¬ a28_onetwentyone oneJhanaPath := by unfold a28_onetwentyone; decide

/-- Only the seven universals: the other 45 cetasikas missing. -/
abbrev sevenCetasikas : Tax := { bare with cets := universals }

theorem a29_forbids_sevenCetasikas : ¬ a29_fiftytwo sevenCetasikas := by unfold a29_fiftytwo; decide

/-- Eye-consciousness with no contact (every cetasika absent). -/
abbrev noContact : Tax := { bare with kinds := [eyeCons] }

theorem a31_forbids_noContact : ¬ a31_universals noContact := by unfold a31_universals; decide

/-- A citta-type the generator does not build: a fine-material citta at a sixth jhāna. -/
abbrev sixthJhana : Tax := { bare with kinds := [{ firstJhana with jhana := 6 }] }

theorem a32_forbids_sixthJhana : ¬ a32_generated sixthJhana := by unfold a32_generated; decide

/-- Eye-consciousness with applied thought (*vitakka*), which §R2 bars from sense-consciousness. -/
abbrev eyeWithVitakka : Tax := { bare with kinds := [eyeCons], assoc := fun _ x => universals.contains x || x == .vitakka }

theorem a32_forbids_eyeWithVitakka : ¬ a32_association eyeWithVitakka := by unfold a32_association; decide

/-- Every type with equanimity: no joy, no grief, no bodily pleasure or pain. -/
abbrev allEquanimity : Tax := { bare with kinds := mundane.map fun c => { c with vedana := .upekkha } }

theorem a33_forbids_allEquanimity : ¬ a33_feelings allEquanimity := by unfold a33_feelings; decide

/-- A world with no citta-types at all: no rootless, no rooted. -/
abbrev noKinds : Tax := bare

theorem a34_forbids_noKinds : ¬ a34_roots noKinds := by unfold a34_roots; decide

/-- Eye-consciousness and mind-door adverting, and neither performs registration (nor anything else). -/
abbrev noRegistration : Tax := { bare with kinds := [eyeCons, manoAdverting] }

theorem a35_forbids_noRegistration : ¬ a35_every_function noRegistration := by unfold a35_every_function; decide

/-- Eye-consciousness performing two functions, seeing and hearing: one type with two, none with one. -/
abbrev seesAndHears : Tax := { bare with kinds := [eyeCons], kicca := fun _ k => k == .dassana || k == .savana }

theorem a35_forbids_seesAndHears : ¬ a35_counts seesAndHears := by unfold a35_counts; decide

/-- Eye-consciousness that also hears sounds. -/
abbrev eyeHears : Tax := { bare with kinds := [eyeCons], scope := fun _ _ o => o == .rupa || o == .sadda }

theorem a38_forbids_eyeHears : ¬ a38_one_object eyeHears := by unfold a38_one_object; decide

/-- A stream-entry path that takes a concept as well as nibbāna. -/
abbrev pathTakesConcept : Tax := { bare with kinds := [entryPath 1], scope := fun _ _ o => o == .nibbana || o == .pannatti }

theorem a38_forbids_pathTakesConcept : ¬ a38_supramundane pathTakesConcept := by unfold a38_supramundane; decide

/-- Eye-consciousness that takes an exalted object: no type left that takes sense-sphere objects only. -/
abbrev eyeExalted : Tax := { bare with kinds := [eyeCons], scope := fun _ _ o => o == .mahaggata }

theorem a38_forbids_eyeExalted : ¬ a38_twentyfive eyeExalted := by unfold a38_twentyfive; decide

/-- The first jhāna taking nibbāna instead of a concept: no type takes concepts only. -/
abbrev jhanaNibbana : Tax := { bare with kinds := [firstJhana], scope := fun _ _ o => o == .nibbana }

theorem a38_forbids_jhanaNibbana : ¬ a38_twentyone jhanaNibbana := by unfold a38_twentyone; decide

/-- The row's literal reading: FIVE types take every object (the four knowledge-associated functionals and
    determining), and none occurs as a super-knowledge. The text's six are missing the functional super-knowledge. -/
abbrev fiveAny : Tax :=
  { bare with kinds := [nanaKiriya true false, nanaKiriya true true, nanaKiriya false false, nanaKiriya false true, manoAdverting],
              scope := fun _ _ _ => true }

theorem a38_forbids_fiveAny : ¬ a38_six_any fiveAny := by unfold a38_six_any; decide

/-- The 18 concretely produced kinds only: the ten others missing. -/
abbrev eighteenRupa : Tax := { bare with rupas := Rupa.all.filter (!anipphanna.contains ·) }

theorem a60_forbids_eighteenRupa : ¬ a60_twentyeight eighteenRupa := by unfold a60_twentyeight; decide

/-- Space counted as concretely produced, with the other 18. -/
abbrev spaceConcrete : Tax :=
  { bare with rupas := Rupa.all, nipphanna := fun r => !anipphanna.contains r || r == .akasa }

theorem a60_forbids_spaceConcrete : ¬ a60_concretely_produced spaceConcrete := by unfold a60_concretely_produced; decide

/-- The heart-base counted as internal, with the five organs. -/
abbrev heartInternal : Tax := { bare with internal := fun r => pasada.contains r || r == .hadaya }

theorem a62_forbids_heartInternal : ¬ a62_internal heartInternal := by unfold a62_internal; decide

/-- Water counted as impinging, with the twelve (thirteen gross kinds). -/
abbrev waterGross : Tax := { bare with gross := fun r => (pasada ++ gocara).contains r || r == .apo }

theorem a62_forbids_waterGross : ¬ a62_gross waterGross := by unfold a62_gross; decide

/-- Sound clung-to, though kamma produces no sound (origin as the table says). -/
abbrev soundClung : Tax := { bare with clung := fun r => r == .sadda, origin := originTable }

theorem a62_forbids_soundClung : ¬ a62_clung soundClung := by unfold a62_clung; decide

/-- Sound counted visible, with visible form. -/
abbrev soundVisible : Tax := { bare with visible := fun r => r == .vanna || r == .sadda }

theorem a62_forbids_soundVisible : ¬ a62_visible soundVisible := by unfold a62_visible; decide

/-- The heart-base produced by temperature too, otherwise as the table says. -/
abbrev heartFromHeat : Tax :=
  { bare with origin := fun r o => originTable r o || (r == .hadaya && o == .utu) }

theorem a65_forbids_heartFromHeat : ¬ a65_table heartFromHeat := by unfold a65_table; decide

/-- The characteristics produced by all four origins: every kind from every origin. -/
abbrev characteristicsBorn : Tax := { bare with rupas := Rupa.all, origin := fun _ _ => true }

theorem a65_forbids_characteristicsBorn : ¬ a65_counts characteristicsBorn := by unfold a65_counts; decide

/-- The first jhāna occurring as a super-knowledge. -/
abbrev firstJhanaAbhinna : Tax := { bare with kinds := [firstJhana], abhinna := fun _ => true }

theorem a107_forbids_firstJhanaAbhinna : ¬ a107_fifth_jhana firstJhanaAbhinna := by unfold a107_fifth_jhana; decide

/-- Eye-consciousness performing hearing. -/
abbrev eyeHearing : Tax := { bare with kinds := [eyeCons], kicca := fun _ k => k == .savana }

theorem a35_forbids_eyeHearing : ¬ a35_which eyeHearing := by unfold a35_which; decide

/-- The base of boundless space (the second immaterial) taking a concept: no type takes exalted objects only. -/
abbrev secondImmaterialConcept : Tax :=
  { bare with kinds := [{ jati := .kusala, bhumi := .arupa, vedana := .upekkha, root := .beautiful, knowing := true, jhana := 5, base := 2 }],
              scope := fun _ _ o => o == .pannatti }

theorem a38_forbids_secondImmaterialConcept : ¬ a38_six_exalted secondImmaterialConcept := by unfold a38_six_exalted; decide

/-- A greed-rooted citta taking nibbāna (every object): none left that takes all but the supramundane. -/
abbrev greedTakesNibbana : Tax :=
  { bare with kinds := [{ jati := .akusala, bhumi := .kama, vedana := .somanassa, root := .lobha, view := true }],
              scope := fun _ _ _ => true }

theorem a38_forbids_greedTakesNibbana : ¬ a38_twenty greedTakesNibbana := by unfold a38_twenty; decide

/-- The knowledge-associated sense-sphere wholesome cittas taking the arahant's path and fruit as well. -/
abbrev wholesomeTakesAgga : Tax :=
  { bare with kinds := [true, false].flatMap fun joy => [false, true].map fun p =>
                { jati := .kusala, bhumi := .kama, vedana := joyOr joy, root := .beautiful, knowing := true, prompted := p },
              scope := fun _ _ _ => true }

theorem a38_forbids_wholesomeTakesAgga : ¬ a38_five_but_agga wholesomeTakesAgga := by unfold a38_five_but_agga; decide

/-- The heart-base left out of the bases. -/
abbrev heartNoBase : Tax := { bare with base := pasada.contains }

theorem a62_forbids_heartNoBase : ¬ a62_base heartNoBase := by unfold a62_base; decide

/-- The heart-base counted a door. -/
abbrev heartDoor : Tax := { bare with door := fun r => (pasada ++ [Rupa.kayavinnatti, .vacivinnatti]).contains r || r == .hadaya }

theorem a62_forbids_heartDoor : ¬ a62_door heartDoor := by unfold a62_door; decide

/-- The life faculty left out of the material faculties. -/
abbrev noLifeFaculty : Tax := { bare with faculty := fun r => indriyaRupa.contains r && r != .jivita }

theorem a62_forbids_noLifeFaculty : ¬ a62_faculty noLifeFaculty := by unfold a62_faculty; decide

/-- Five hindrances: sloth-and-torpor and restlessness-and-remorse merged into one, and nothing else listed. -/
abbrev fiveHindrances : Tax :=
  { bare with papa := fun g => if g == .nivarana then [[.lobha], [.dosa], [.thina, .middha, .uddhacca, .kukkucca], [.vicikiccha], [.moha]] else [] }

theorem a71_forbids_fiveHindrances : ¬ a71_sizes fiveHindrances := by unfold a71_sizes; decide

/-- A taint whose nature is faith, a beautiful cetasika. -/
abbrev faithTaint : Tax := { bare with papa := fun g => if g == .asava then [[.saddha]] else [] }

theorem a71_forbids_faithTaint : ¬ a71_unwholesome faithTaint := by unfold a71_unwholesome; decide

/-- Eleven path factors: the right eight and three wrong. -/
abbrev threeWrong : Tax := { bare with missaka := fun g => if g == .maggangaWrong then [[.cetasika .ditthi], [.cetasika .vitakka], [.cetasika .viriya]] else [] }

theorem a72_forbids_threeWrong : ¬ a72_sizes threeWrong := by unfold a72_sizes; decide

/-- The faculties with the material life faculty only. -/
abbrev materialLifeOnly : Tax := { bare with missaka := fun g => if g == .indriya then [[.rupa .jivita]] else [] }

theorem a72_forbids_materialLifeOnly : ¬ a72_life_faculty materialLifeOnly := by unfold a72_life_faculty; decide

/-- Feeling as the second nutriment, in place of contact. -/
abbrev feelingNutriment : Tax :=
  { bare with missaka := fun g => if g == .ahara then [[.rupa .ahara], [.cetasika .vedana], [.cetasika .cetana], [.citta]] else [] }

theorem a72_forbids_feelingNutriment : ¬ a72_nutriments feelingNutriment := by unfold a72_nutriments; decide

/-- Seven path factors in the requisites, with right livelihood missing. -/
abbrev sevenFactors : Tax :=
  { bare with bodhi := fun g => if g == .magganga then
      [[.cetasika .panna], [.cetasika .vitakka], [.cetasika .sammavaca], [.cetasika .sammakammanta],
       [.cetasika .viriya], [.cetasika .sati], [.cetasika .ekaggata]] else [] }

theorem a73_forbids_sevenFactors : ¬ a73_sizes sevenFactors := by unfold a73_sizes; decide

/-- Every requisite is citta: one dhamma by nature, not fourteen. -/
abbrev allCitta : Tax := { bare with bodhi := fun g => List.replicate g.size [Dhamma.citta] }

theorem a73_forbids_allCitta : ¬ a73_fourteen allCitta := by unfold a73_fourteen; decide

/-- Eleven bases: the mind-object base missing. -/
abbrev elevenBases : Tax := { bare with sabba := fun g => if g == .ayatana then List.replicate 11 [Dhamma.citta] else [] }

theorem a74_forbids_elevenBases : ¬ a74_sizes elevenBases := by unfold a74_sizes; decide

/-- Nibbāna counted in an aggregate. -/
abbrev nibbanaAggregate : Tax := { bare with sabba := fun g => if g == .khandha then [[.nibbana]] else [] }

theorem a74_forbids_nibbanaAggregate : ¬ a74_nibbana_outside nibbanaAggregate := by unfold a74_nibbana_outside; decide

/-- Citta counted in the mind-object base, with the 52, the 16 subtle and nibbāna: seventy. -/
abbrev cittaInDhammaBase : Tax :=
  { bare with cets := FormalAbhidhamma.all, rupas := Rupa.all, gross := fun r => (pasada ++ gocara).contains r,
              dhammayatana := .citta :: .nibbana :: (FormalAbhidhamma.all.map Dhamma.cetasika ++
                ((Rupa.all.filter (!(pasada ++ gocara).contains ·)).map Dhamma.rupa)) }

theorem a74_forbids_cittaInDhammaBase : ¬ a74_sixtynine cittaInDhammaBase := by unfold a74_sixtynine; decide

/-- Only eye-consciousness: one element, not seven. -/
abbrev oneElement : Tax := { bare with kinds := [eyeCons] }

theorem a74_forbids_oneElement : ¬ a74_seven_elements oneElement := by unfold a74_seven_elements; decide

/-- Thirty-nine subjects: the analysis of the four elements missing. -/
abbrev noAnalysis : Tax := { bare with kammatthana := kammatthana40.filter (· != [.vavatthana]) }

theorem a105_forbids_noAnalysis : ¬ a105_forty noAnalysis := by unfold a105_forty; decide

/-- Loving-kindness reaching the fifth jhāna. -/
abbrev mettaFifth : Tax :=
  { bare with kammatthana := kammatthana40, kjhana := fun s n => jhanaTable s n || (s == .appamanna 1 && n == 5) }

theorem a105_forbids_mettaFifth : ¬ a105_absorption mettaFifth := by unfold a105_absorption; decide

/-! ## Vocabulary checks (about the names, never a world) -/

theorem kicca_all_complete : ∀ k : Kicca, k ∈ Kicca.all := by intro k; cases k <;> decide
theorem kicca_fourteen_in_ten : Kicca.all.length = 14 ∧ (Kicca.all.map Kicca.thana).eraseDups.length = 10 := by decide
theorem rupa_all_complete : ∀ r : Rupa, r ∈ Rupa.all := by intro r; cases r <;> decide
theorem rupa_twentyeight : Rupa.all.length = 28 ∧ Rupa.all.Nodup ∧ anipphanna.length = 10 := by decide
theorem obj_all_complete : ∀ o : Obj, o ∈ Obj.all := by intro o; cases o <;> decide
theorem kammatthana_forty : kammatthana40.flatten.length = 40 ∧ kammatthana40.flatten.Nodup := by decide
theorem category_sizes :
    (PapaCat.all.map PapaCat.size, MissakaCat.all.map MissakaCat.size, BodhiCat.all.map BodhiCat.size, SabbaCat.all.map SabbaCat.size)
      = ([4, 4, 4, 4, 4, 6, 7, 10, 10, 10], [6, 7, 8, 4, 22, 9, 4, 4], [4, 4, 4, 5, 5, 7, 8], [5, 5, 12, 18, 4]) := by decide
/-- An ENCODING check, not a world: the table gives the text's own totals, 30 subjects reach absorption (§20,
    `:3129`) and 26 reach a fine-material jhāna (§24, `:3145`). -/
theorem jhanaTable_text_totals :
    (kammatthana40.flatten.filter fun s => [1, 2, 3, 4, 5, 6].any (jhanaTable s)).length = 30 ∧
    (kammatthana40.flatten.filter fun s => [1, 2, 3, 4, 5].any (jhanaTable s)).length = 26 := by decide

end FormalAbhidhamma.Model
