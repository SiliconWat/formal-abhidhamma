/-
  model/Mat.lean — the MAT part of the one World: matter (*rūpa*), as the rows count it. FIRST BATCH (2026-10-20):
  A39 (bases by sphere) · A4 (the life-span) · A15 (the inseparable eight; lightness) · A63 (reaching) · A6 (matter bound to
  no being) · A61 (by type: see below). The rest of MAT (A5 · A13 · A64–A67 · A129 · A114 · K · A68 · A87 · A116 · A118 ·
  A120 · A121 · A88 · A113) follows in later batches.
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

/-- A being: the sphere it lives in (A39, A68) and the matter-bases it has, by kind. -/
structure Being where
  id : Nat
  plane : Bhumi
  bases : List Rupa
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
  deriving DecidableEq, Repr

/-- What a world has of matter. `reached`: the doors whose objects are taken by reaching (A63). -/
structure Mat where
  beings : List Being
  kalapas : List Kalapa
  reached : List Door

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

end FormalAbhidhamma.Model
