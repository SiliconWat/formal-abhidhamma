/-
  model/Mat.lean — the MAT part of the one World: matter (*rūpa*), as the rows count it. FIRST BATCH (2026-10-20):
  A39 (bases by sphere) · A4 (the life-span) · A15 (the inseparable eight; lightness) · A63 (reaching) · A6 (matter bound to
  no being) · A61 (by type: see below). BATCH 2 (2026-10-20): A66 (the 21 kalāpas; the two external; no space or
  characteristic as a member) · A5 (space) · A13 (mindless and immaterial beings) · A129 (the size ladder). The rest of MAT
  (A64 · A67 · A114 · K · A68 · A87 · A116 · A118 · A120 · A121 · A88 · A113) needs the MIND link or COSMO and follows later.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1 and 2,
  thonly/the-calculus-of-moments). A WORKING encoding: frozen only by Protocol 2, before any model is searched — so
  this file builds NO model of anything, and no world here satisfies the rows (each world below is FORBIDDEN).

  A world's matter is a list of kalāpas, each a group of the 28 kinds with an origin, a life-span in sub-moments (three to a
  citta-moment, so 17 moments = 51), and an owner, a being or none. Beings are listed with the sphere they live in and the
  bases (A39) they have. A kalāpa's place and motion are A113's, in a later batch; its arising moment is A64's.

  A61 (matter is rootless, objectless, conditioned) is encoded BY THE TYPE: `Kalapa` has no field for a root and no field for an
  object, so no world can give matter either; the census marks it T. Its other words (mundane, of the sense sphere) are the
  taxonomy's (`Tax.lean`, A65).

  Q2′ (amendment 2): every definition here quantifies over a world's finite list of kalāpas or beings and mentions no
  stream or moment of a stream, so the audit marks them NOT first-order in form, but off the stream.

  ⚠️ Notes, for the founder:
  (1) A39's last sentence (the sense-consciousnesses depend on their organ, the mind-element and most mind-consciousness
      on the heart-base, the immaterial resultants on no base) ties a citta to a base at its arising; that is the MIND link's
      (a step placed in a stream), so only the SPHERE clauses are here. PENDING, not dropped.
  (2) A4 encodes the 17 (51 sub-moments). The 16 and the 16⅓ (a ṭīkā's argument and report) are VARIANTS, recorded in the
      variants list (Protocol 1 correction 1), not rows of this file.
  (3) A6 reads the Atthasālinī's line (`abh01a.att.xml:9785`) as: matter bound to a faculty belongs to a being's continuity
      (another person's too: *parapuggalasantāne*); matter outside every faculty belongs to none.
-/
import Proc
namespace FormalAbhidhamma.Model
open FormalAbhidhamma

/-- The cases in which a being does not breathe (A114), besides the two spheres: `normal` is none of them. -/
inductive BreathCase | normal | womb | water | swoon | dead | fourthJhana | cessation deriving DecidableEq, Repr

/-- A being: the sphere it lives in (A39, A68) and the matter-bases it has, by kind. -/
structure Being where
  id : Nat
  plane : Bhumi
  bases : List Rupa
  /-- A13: whether the being has mind, whether it has matter, and its material faculties -/
  hasMind : Bool := true
  hasMatter : Bool := true
  faculties : List Rupa := []
  /-- A68: the kinds of matter the being's body has -/
  kinds : List Rupa := []
  /-- A114: whether it breathes, and which of the seven cases it is in -/
  breathes : Bool := false
  breathCase : BreathCase := .normal
  deriving DecidableEq, Repr

/-- A kalāpa (A66): a group of the 28 kinds that arise together, with its origin (A64), its life from arising to
    ceasing in sub-moments, the being it belongs to (A6), and whether it is bound to a faculty. ⚠️ No field for a root or an
    object (A61, by the type). -/
structure Kalapa where
  members : List Rupa
  origin : Origin
  life : Nat
  owner : Option Nat
  bound : Bool
  /-- A113: the place it arises at and stays at for its whole life (a single field by the type: it has no second place, so "going" is another kalāpa at another place) -/
  place : Nat := 0
  /-- A129: its size in paramāṇu (the Visuddhimagga-ṭīkā: a kalāpa is of paramāṇu size) -/
  size : Nat := 1
  deriving DecidableEq, Repr

/-- What a world has of matter. `reached`: the doors whose objects are taken by reaching (A63). -/
structure Mat where
  beings : List Being
  kalapas : List Kalapa
  reached : List Door
  /-- A5: the space between kalāpas, as pairs of their positions in `kalapas` -/
  gaps : List (Nat × Nat) := []
  /-- A129: the size ladder's ratios, paramāṇu to aṅgula -/
  ladder : List Nat := [36, 36, 36, 36, 7, 7, 7]

/-- The six bases (A39; ch. 3 §64, `abh07t.nrf.xml:1113`): the five organs and the heart-base. -/
def sixBases : List Rupa := pasada ++ [Rupa.hadaya]

/-- A39, the sense sphere (L4, ch. 3 §64–74, `abh07t.nrf.xml:1113–1161`): a being of the sense sphere has all six bases. -/
def a39_sense (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .kama → b.bases = sixBases

/-- A39, the fine-material sphere: nose, tongue and body are absent, so a being there has at most eye, ear and heart-base. -/
def a39_fine (m : Mat) : Prop :=
  ∀ b ∈ m.beings, b.plane = .rupa → ∀ r ∈ b.bases, r ∈ [Rupa.cakkhu, .sota, .hadaya]

/-- A39, the immaterial sphere: no base exists. -/
def a39_immaterial (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .arupa → b.bases = []

/-- A4 (L2, `abh02a.att.xml:413`; L4 ch. 4 §9, `abh07t.nrf.xml:1233`): concretely produced matter lasts seventeen mind-moments,
    fifty-one sub-moments. -/
def a4_life (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, (∀ r ∈ k.members, r ∉ anipphanna) → k.life = 51

/-- A15, the inseparable eight (L4, ch. 6 §27, `abh07t.nrf.xml:2169`): every kalāpa carries earth, water, fire, air,
    colour, odour, taste and nutritive essence. -/
def a15_eight (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, ∀ r ∈ [Rupa.pathavi, .apo, .tejo, .vayo, .vanna, .gandha, .rasa, .ahara], r ∈ k.members

/-- A15, lightness (L4, `abh07t.nrf.xml:6117`): occurs only in the mind-, temperature- and nutriment-born groups of beings'
    bodies. ⚠️ Linking gravity to it is OURS and excluded. -/
def a15_lightness (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, Rupa.lahuta ∈ k.members → k.origin ≠ .kamma ∧ k.owner.isSome = true

/-- A63 (L4, ch. 6 §26, `abh07t.nrf.xml:2165`): eye and ear take their objects without reaching them; nose, tongue and body
    by reaching. ⚠️ The commentaries read "reached" differently (VARIANT, `runs/2026-09-30-reported-view-control`). -/
def a63_reach (m : Mat) : Prop := m.reached = [Door.nose, .tongue, .body]

/-- A6 (L2, Atthasālinī `abh01a.att.xml:3485`, `:9785`): matter bound to a faculty belongs to a being's continuity; matter
    outside every faculty is bound to no being. -/
def a6_unbound (m : Mat) : Prop := ∀ k ∈ m.kalapas, (k.bound = false ↔ k.owner = none)

/-! ## Forbidden worlds (one per definition; none is a model) -/

abbrev eight : List Rupa := [.pathavi, .apo, .tejo, .vayo, .vanna, .gandha, .rasa, .ahara]
abbrev okKalapa : Kalapa := { members := eight, origin := .utu, life := 51, owner := none, bound := false }
abbrev okMat : Mat := { beings := [], kalapas := [], reached := [.nose, .tongue, .body] }

/-- A being of the sense sphere with no nose-base. -/
abbrev senseNoNose : Mat := { okMat with beings := [{ id := 0, plane := .kama, bases := [.cakkhu, .sota, .jivha, .kaya, .hadaya] }] }
theorem a39_forbids_senseNoNose : ¬ a39_sense senseNoNose := by unfold a39_sense; decide

/-- A being of the fine-material sphere with a nose-base. -/
abbrev fineWithNose : Mat := { okMat with beings := [{ id := 0, plane := .rupa, bases := [.cakkhu, .ghana, .hadaya] }] }
theorem a39_forbids_fineWithNose : ¬ a39_fine fineWithNose := by unfold a39_fine; decide

/-- A being of the immaterial sphere with a heart-base. -/
abbrev immaterialWithHeart : Mat := { okMat with beings := [{ id := 0, plane := .arupa, bases := [.hadaya] }] }
theorem a39_forbids_immaterialWithHeart : ¬ a39_immaterial immaterialWithHeart := by unfold a39_immaterial; decide

/-- A concretely produced kalāpa that lasts sixteen moments (the variant's number, forbidden under the 17 reading). -/
abbrev sixteenMoments : Mat := { okMat with kalapas := [{ okKalapa with life := 48 }] }
theorem a4_forbids_sixteenMoments : ¬ a4_life sixteenMoments := by unfold a4_life; decide

/-- A kalāpa without taste. -/
abbrev noTaste : Mat := { okMat with kalapas := [{ okKalapa with members := eight.filter (· ≠ Rupa.rasa) }] }
theorem a15_forbids_noTaste : ¬ a15_eight noTaste := by unfold a15_eight; decide

/-- A kamma-born kalāpa carrying lightness. -/
abbrev kammaLightness : Mat :=
  { okMat with kalapas := [{ okKalapa with members := Rupa.lahuta :: eight, origin := .kamma, owner := some 0, bound := true }] }
theorem a15_forbids_kammaLightness : ¬ a15_lightness kammaLightness := by unfold a15_lightness; decide

/-- Lightness in matter outside every being. -/
abbrev lightnessOutside : Mat := { okMat with kalapas := [{ okKalapa with members := Rupa.lahuta :: eight }] }
theorem a15_forbids_lightnessOutside : ¬ a15_lightness lightnessOutside := by unfold a15_lightness; decide

/-- The eye taking its object by reaching it. -/
abbrev eyeReaches : Mat := { okMat with reached := [.eye, .nose, .tongue, .body] }
theorem a63_forbids_eyeReaches : ¬ a63_reach eyeReaches := by unfold a63_reach; decide

/-- Matter bound to no faculty that nevertheless has an owner. -/
abbrev unboundOwned : Mat := { okMat with kalapas := [{ okKalapa with owner := some 0 }] }
theorem a6_forbids_unboundOwned : ¬ a6_unbound unboundOwned := by unfold a6_unbound; decide


/-! ## Batch 2 -/

/-- Kinds of matter in the text's order, to compare two groups as sets. -/
def canon (l : List Rupa) : List Rupa := Rupa.all.filter (· ∈ l)

/-- The twenty-one kalāpas (A66; ch. 6 §45–51, `abh07t.nrf.xml:2269–2297`), each as its members and its origin. The decads of the
    kamma-born are the pure octad, life and one of eye, ear, nose, tongue, body, woman, man, heart-base; the nonad has life only. -/
def twentyOne : List (List Rupa × Origin) :=
  (([Rupa.cakkhu, .sota, .ghana, .jivha, .kaya, .itthatta, .purisatta, .hadaya].map fun r => (eight ++ [.jivita, r], Origin.kamma))
    ++ [(eight ++ [.jivita], .kamma)])
  ++ [(eight, .citta), (eight ++ [.kayavinnatti], .citta), (eight ++ [.vacivinnatti, .sadda], .citta),
      (eight ++ [.lahuta, .muduta, .kammannata], .citta), (eight ++ [.kayavinnatti, .lahuta, .muduta, .kammannata], .citta),
      (eight ++ [.vacivinnatti, .sadda, .lahuta, .muduta, .kammannata], .citta)]
  ++ [(eight, .utu), (eight ++ [.sadda], .utu), (eight ++ [.lahuta, .muduta, .kammannata], .utu),
      (eight ++ [.sadda, .lahuta, .muduta, .kammannata], .utu)]
  ++ [(eight, .ahara), (eight ++ [.lahuta, .muduta, .kammannata], .ahara)]

theorem twentyOne_counts : twentyOne.length = 21 ∧ (twentyOne.filter (·.2 == .kamma)).length = 9 ∧
    (twentyOne.filter (·.2 == .citta)).length = 6 ∧ (twentyOne.filter (·.2 == .utu)).length = 4 ∧
    (twentyOne.filter (·.2 == .ahara)).length = 2 := by decide

def isKind (k : Kalapa) (t : List Rupa × Origin) : Bool := canon k.members == canon t.1 && k.origin == t.2

/-- A66, the kinds (L4, `abh07t.nrf.xml:2269`): every kalāpa of a world is one of the twenty-one. -/
def a66_twenty_one (m : Mat) : Prop := ∀ k ∈ m.kalapas, ∃ t ∈ twentyOne, isKind k t = true

/-- A66, outside beings (`:2289`): a kalāpa with no owner is the pure octad or the sound nonad, temperature-born. -/
def a66_external (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, k.owner = none → isKind k (eight, .utu) = true ∨ isKind k (eight ++ [.sadda], .utu) = true

/-- A66, what a kalāpa is not made of (`:2305`): space and the four characteristics are no member of any kalāpa; they delimit and mark. -/
def a66_no_delimiter_member (m : Mat) : Prop :=
  ∀ k ∈ m.kalapas, ∀ r ∈ [Rupa.akasa, .upacaya, .santati, .jarata, .aniccata], r ∉ k.members

/-- A5 (L1 on the ṭīkās' reading, L4 `abh07t.nrf.xml:2085`): space is the delimitation between two kalāpas of the world; it has no birth
    of its own, so a gap between a kalāpa and itself, or with one the world lacks, is none. -/
def a5_space (m : Mat) : Prop :=
  ∀ g ∈ m.gaps, g.1 < m.kalapas.length ∧ g.2 < m.kalapas.length ∧ g.1 ≠ g.2

/-- A13, the immaterial (L1/L2/L4, `abh07t.nrf.xml:1485`): a being of the immaterial sphere has mind and no matter. -/
def a13_arupa (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .arupa → b.hasMatter = false ∧ b.hasMind = true

/-- A13, the mindless (`:1485`, `:1957`): a being without mind has matter and a life faculty. -/
def a13_mindless (m : Mat) : Prop := ∀ b ∈ m.beings, b.hasMind = false → b.hasMatter = true ∧ Rupa.jivita ∈ b.faculties

/-- A129, the ladder (L2, Sammohavinodanī): 36 paramāṇu to the aṇu, 36 to the tajjārī, 36 to the rathareṇu, 36 to the likkhā, then 7,
    7, 7 to the aṅgula. ⚠️ Any conversion to meters is OURS and not here. -/
def a129_ladder (m : Mat) : Prop := m.ladder = [36, 36, 36, 36, 7, 7, 7]

/-- A129, the kalāpa's size (L3, the Visuddhimagga-ṭīkā: *te pana kalāpā paramāṇuparimāṇā honti*): one paramāṇu. ⚠️ VARIANT (Ledi): at most
    one forty-ninth of it; recorded in the variants list, not here. -/
def a129_size (m : Mat) : Prop := ∀ k ∈ m.kalapas, k.size = 1

/-! ### Forbidden worlds, batch 2 -/

/-- A kalāpa of seven kinds that is none of the twenty-one. -/
abbrev sevenKinds : Mat := { okMat with kalapas := [{ okKalapa with members := eight ++ [.hadaya, .cakkhu], origin := .utu, owner := some 0, bound := true }] }
theorem a66_forbids_sevenKinds : ¬ a66_twenty_one sevenKinds := by unfold a66_twenty_one; decide

/-- Lightness in matter outside a being (the temperature-born ekādasaka is internal only). -/
abbrev externalEkadasaka : Mat := { okMat with kalapas := [{ okKalapa with members := eight ++ [.lahuta, .muduta, .kammannata] }] }
theorem a66_forbids_externalEkadasaka : ¬ a66_external externalEkadasaka := by unfold a66_external; decide

/-- A kalāpa with space as a member. -/
abbrev spaceMember : Mat := { okMat with kalapas := [{ okKalapa with members := Rupa.akasa :: eight }] }
theorem a66_forbids_spaceMember : ¬ a66_no_delimiter_member spaceMember := by unfold a66_no_delimiter_member; decide

/-- A gap with a kalāpa the world does not have. -/
abbrev strayGap : Mat := { okMat with kalapas := [okKalapa], gaps := [(0, 1)] }
theorem a5_forbids_strayGap : ¬ a5_space strayGap := by unfold a5_space; decide

/-- An immaterial being with matter. -/
abbrev arupaWithMatter : Mat := { okMat with beings := [{ id := 0, plane := .arupa, bases := [], hasMatter := true }] }
theorem a13_forbids_arupaWithMatter : ¬ a13_arupa arupaWithMatter := by unfold a13_arupa; decide

/-- A mindless being with no life faculty. -/
abbrev mindlessNoLife : Mat := { okMat with beings := [{ id := 0, plane := .rupa, bases := [], hasMind := false }] }
theorem a13_forbids_mindlessNoLife : ¬ a13_mindless mindlessNoLife := by unfold a13_mindless; decide

/-- A ladder whose last three steps are 8. -/
abbrev eightLadder : Mat := { okMat with ladder := [36, 36, 36, 36, 8, 8, 8] }
theorem a129_forbids_eightLadder : ¬ a129_ladder eightLadder := by unfold a129_ladder; decide

/-- A kalāpa two paramāṇu in size. -/
abbrev bigKalapa : Mat := { okMat with kalapas := [{ okKalapa with size := 2 }] }
theorem a129_forbids_bigKalapa : ¬ a129_size bigKalapa := by unfold a129_size; decide

/-! ## Batch 3 -/

/-- The 23 kinds of the fine-material sphere: the 28 without nose, tongue, body, woman and man (A68; ch. 6 §58–61, `abh07t.nrf.xml:2345`). -/
def fineKinds : List Rupa := Rupa.all.filter (fun r => ![Rupa.ghana, .jivha, .kaya, .itthatta, .purisatta].contains r)
/-- The 17 kinds of the non-percipient: the vital nonad (the pure octad and life), space, the three mutabilities and the four characteristics. -/
def nonPercipientKinds : List Rupa :=
  eight ++ [.jivita, .akasa, .lahuta, .muduta, .kammannata, .upacaya, .santati, .jarata, .aniccata]

theorem plane_counts : Rupa.all.length = 28 ∧ fineKinds.length = 23 ∧ nonPercipientKinds.length = 17 := by decide

/-- A68, the fine-material sphere (L4): twenty-three kinds, and no nutriment-born group in the body (§58–61). -/
def a68_fine (m : Mat) : Prop :=
  (∀ b ∈ m.beings, b.plane = .rupa → ∀ r ∈ b.kinds, r ∈ fineKinds) ∧
  (∀ b ∈ m.beings, b.plane = .rupa → ∀ k ∈ m.kalapas, k.owner = some b.id → k.origin ≠ .ahara)

/-- A68, the non-percipient: seventeen kinds (the vital nonad at rebirth and the temperature-born except sound). -/
def a68_non_percipient (m : Mat) : Prop := ∀ b ∈ m.beings, b.hasMind = false → ∀ r ∈ b.kinds, r ∈ nonPercipientKinds

/-- A68, the immaterial sphere: none. -/
def a68_immaterial (m : Mat) : Prop := ∀ b ∈ m.beings, b.plane = .arupa → b.kinds = []

/-- A114 (L1/L2/L3/L5, Vism VIII `e0101n.mul.xml:6717`; SN 41.6 `s0304m.mul.xml:6871`): breath is absent in the seven cases — the womb, under water, the swoon or the non-percipient,
    the dead, the fourth jhāna, the fine-material and immaterial beings, cessation. ⚠️ The *asaññībhūta* reading as the swoon is the ṭīkās'; the Vism's word is two-way
    (a VARIANT), and the living unconscious person's bhavaṅga is a recorded tension with A47 + A64 (the breath run). -/
def a114_absent (m : Mat) : Prop :=
  ∀ b ∈ m.beings, (b.breathCase ≠ .normal ∨ b.plane = .rupa ∨ b.plane = .arupa ∨ b.hasMind = false) → b.breathes = false

/-! ### Forbidden worlds, batch 3 -/

abbrev fineWithNoseKind : Mat := { okMat with beings := [{ id := 0, plane := .rupa, bases := [], kinds := [.ghana] }] }
theorem a68_forbids_fineWithNoseKind : ¬ a68_fine fineWithNoseKind := by unfold a68_fine; decide

abbrev fineNutrimentBorn : Mat :=
  { okMat with beings := [{ id := 0, plane := .rupa, bases := [] }], kalapas := [{ okKalapa with owner := some 0, bound := true, origin := .ahara }] }
theorem a68_forbids_fineNutrimentBorn : ¬ a68_fine fineNutrimentBorn := by unfold a68_fine; decide

abbrev nonPercipientWithSound : Mat := { okMat with beings := [{ id := 0, plane := .rupa, bases := [], hasMind := false, kinds := [.sadda] }] }
theorem a68_forbids_nonPercipientWithSound : ¬ a68_non_percipient nonPercipientWithSound := by unfold a68_non_percipient; decide

abbrev immaterialWithKind : Mat := { okMat with beings := [{ id := 0, plane := .arupa, bases := [], kinds := [.pathavi] }] }
theorem a68_forbids_immaterialWithKind : ¬ a68_immaterial immaterialWithKind := by unfold a68_immaterial; decide

abbrev breathingInTheWomb : Mat := { okMat with beings := [{ id := 0, plane := .kama, bases := [], breathes := true, breathCase := .womb }] }
theorem a114_forbids_breathingInTheWomb : ¬ a114_absent breathingInTheWomb := by unfold a114_absent; decide

abbrev breathingFineMaterial : Mat := { okMat with beings := [{ id := 0, plane := .rupa, bases := [], breathes := true }] }
theorem a114_forbids_breathingFineMaterial : ¬ a114_absent breathingFineMaterial := by unfold a114_absent; decide

end FormalAbhidhamma.Model
