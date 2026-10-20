/-
  model/Cosmos.lean — the COSMO part of the one World: the places and the large numbers the rows give (Sineru, the sun and moon, the cakkavāḷa, the planes, the
  day-lengths and life-spans of the realms, the kappa). Numbers are in yojanas or years as the rows give them.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything, and no world here
  satisfies the rows (each world below is FORBIDDEN, by one number).

  FIRST BATCH (2026-10-20): A14 · A16 · A17 · A19 · A20 · A22 · A23 · A48 · A11 · A49 · A10. Not yet: A18 (Rāhu's seizure as an occultation)
  and A21 (the moon waxes by sunlight from above, lagging half the path), whose content is a MOTION and needs the world's places in time (P3); A50
  (the nineteen life-span figures of the fine-material and immaterial planes, to be read from the Saṅgaha before they are typed).
  ⚠️ FREEDOMS (the freedoms list, not rows): the number of cakkavāḷas · how the fourth continent is dark (occlusion or range, A22) · the divine
  year's 360 days (A49's arithmetic is OURS and not encoded) · A16's "42,000 holds for the FIRST kappa, a few yojanas less later" — the encoding
  reads only the upper bound · every motion is read by A113 (a later kalāpa at another place; nothing travels).
  Q2′ (amendment 2): every definition here is a statement about numbers in one world; none mentions a stream or a moment.
-/
import Tax
namespace FormalAbhidhamma.Model

/-- What a world says of the cosmos. -/
structure Cosmos where
  sunk : Nat
  risen : Nat
  sineruLength : Nat
  sineruWidth : Nat
  oceanDepth : Nat
  /-- length, breadth, height in yojanas -/
  moon : Nat × Nat × Nat
  sun : Nat × Nat × Nat
  /-- height above the earth of each disc's lower edge -/
  moonBottom : Nat
  sunBottom : Nat
  cakkavala : Nat
  litContinents : Nat
  /-- yojanas a day the sun gains on the moon -/
  dayGain : Nat
  /-- the number of planes in each of the four spheres: states of loss, happy sense, fine-material, immaterial -/
  planes : List Nat
  /-- how many human years are one day and night of the Four Great Kings, of the Yāma devas -/
  kingsDay : Nat
  yamaDay : Nat
  /-- the life-span in human years of the k-th sense deva realm, k = 0 the Four Great Kings -/
  lifespan : Nat → Nat
  kappaPhases : Nat
  /-- the highest of the sixteen fine-material planes (counted from 1) that each destruction reaches -/
  fireReaches : Nat
  waterReaches : Nat
  windReaches : Nat
  /-- how many buddha-fields one destruction ruins -/
  destroyedFields : Nat

/-- A14 (L1, AN 7.66; `kala/AXIOMS.md`): Sineru is 84,000 yojanas long and wide, sunk 84,000 into the great ocean and risen 84,000 above it; the ocean is 84,000 deep. -/
def a14_sineru (c : Cosmos) : Prop :=
  c.sunk = 84000 ∧ c.risen = 84000 ∧ c.sineruLength = 84000 ∧ c.sineruWidth = 84000 ∧ c.oceanDepth = 84000

/-- A17 (L2, `abh01a.att.xml:8349`) and A19 (L3, DN-ṭīkā `s0103t.tik.xml:821`): the moon's disc is 49 yojanas long and wide, the sun's 50; both are solids of the same measure in height. -/
def a17_discs (c : Cosmos) : Prop := c.moon.1 = 49 ∧ c.moon.2.1 = 49 ∧ c.sun.1 = 50 ∧ c.sun.2.1 = 50
def a19_solids (c : Cosmos) : Prop := c.moon.2.2 = 49 ∧ c.sun.2.2 = 50

/-- A16 (L2/L3, `abh01a.att.xml:8297`, `:8353`): the discs travel at about half Sineru's height (the encoding reads the upper bound only), the moon BELOW and the sun
    ABOVE with one yojana between, a hundred yojanas from the moon's lower edge to the sun's upper edge. -/
def a16_stack (c : Cosmos) : Prop :=
  2 * c.moonBottom ≤ c.risen ∧ c.sunBottom = c.moonBottom + c.moon.2.2 + 1 ∧ c.moonBottom + 100 = c.sunBottom + c.sun.2.2

/-- A20 (L2, DN-a `s0103a.att.xml:825`): from the new moon the sun leaves the moon behind a hundred thousand yojanas a day. -/
def a20_day_gain (c : Cosmos) : Prop := c.dayGain = 100000

/-- A22 (L2, DN-a `s0103a.att.xml:833`): the sun and moon light three continents at one moment. -/
def a22_three_lit (c : Cosmos) : Prop := c.litContinents = 3

/-- A23 (L2, `abh01a.att.xml:7897`): one cakkavāḷa is 1,203,450 yojanas long and wide. -/
def a23_cakkavala (c : Cosmos) : Prop := c.cakkavala = 1203450

/-- A48 (L4, ch. 5 §3–14, `abh07t.nrf.xml:1533–1585`): thirty-one planes — four states of loss, seven happy sense planes, sixteen fine-material, four immaterial. -/
def a48_planes (c : Cosmos) : Prop := c.planes = [4, 7, 16, 4]

/-- A11 (L1, Vibhaṅga §1023 `abh02m.mul.xml:13221`, `:13229`): fifty human years are one day and night of the Four Great Kings; two hundred of the Yāma devas. -/
def a11_day_lengths (c : Cosmos) : Prop := c.kingsDay = 50 ∧ c.yamaDay = 200

/-- A49 (L4, ch. 5 §21–23, `abh07t.nrf.xml:1621–1633`): the Four Great Kings live 9,000,000 human years and each higher deva realm four times the one below, to the
    Vasavattī at 9,216,000,000. ⚠️ The arithmetic through the divine year is OURS and not here. -/
def a49_lifespans (c : Cosmos) : Prop := ∀ k, k ≤ 5 → c.lifespan k = 9000000 * 4 ^ k

/-- A10, the phases (L1, AN 4.156 `s0402m3.mul.xml:4972`): the kappa has four phases. -/
def a10_phases (c : Cosmos) : Prop := c.kappaPhases = 4

/-- A10, the limits (L2, `vin01a.att.xml:2813`, Vism XIII `e0102n.mul.xml:729`): fire reaches the planes below Ābhassara (the fifth), water below Subhakiṇha (the eighth),
    wind below Vehapphala (the ninth); and a destruction is LOCAL, ruining one buddha-field. -/
def a10_limits (c : Cosmos) : Prop := c.fireReaches = 5 ∧ c.waterReaches = 8 ∧ c.windReaches = 9 ∧ c.destroyedFields = 1

/-! ## Forbidden worlds (one number wrong each) -/

abbrev okCosmos : Cosmos :=
  { sunk := 84000, risen := 84000, sineruLength := 84000, sineruWidth := 84000, oceanDepth := 84000,
    moon := (49, 49, 49), sun := (50, 50, 50), moonBottom := 42000, sunBottom := 42050, cakkavala := 1203450,
    litContinents := 3, dayGain := 100000, planes := [4, 7, 16, 4], kingsDay := 50, yamaDay := 200,
    lifespan := fun k => 9000000 * 4 ^ k, kappaPhases := 4, fireReaches := 5, waterReaches := 8, windReaches := 9, destroyedFields := 1 }

abbrev shallowSineru : Cosmos := { okCosmos with sunk := 42000 }
theorem a14_forbids_shallowSineru : ¬ a14_sineru shallowSineru := by unfold a14_sineru; decide

abbrev equalDiscs : Cosmos := { okCosmos with moon := (50, 50, 49) }
theorem a17_forbids_equalDiscs : ¬ a17_discs equalDiscs := by unfold a17_discs; decide

abbrev flatDiscs : Cosmos := { okCosmos with sun := (50, 50, 1) }
theorem a19_forbids_flatDiscs : ¬ a19_solids flatDiscs := by unfold a19_solids; decide

/-- The sun below the moon. -/
abbrev sunBelow : Cosmos := { okCosmos with sunBottom := 41000 }
theorem a16_forbids_sunBelow : ¬ a16_stack sunBelow := by unfold a16_stack; decide

abbrev slowSun : Cosmos := { okCosmos with dayGain := 1000 }
theorem a20_forbids_slowSun : ¬ a20_day_gain slowSun := by unfold a20_day_gain; decide

abbrev allFourLit : Cosmos := { okCosmos with litContinents := 4 }
theorem a22_forbids_allFourLit : ¬ a22_three_lit allFourLit := by unfold a22_three_lit; decide

abbrev smallCakkavala : Cosmos := { okCosmos with cakkavala := 1000000 }
theorem a23_forbids_smallCakkavala : ¬ a23_cakkavala smallCakkavala := by unfold a23_cakkavala; decide

abbrev thirtyPlanes : Cosmos := { okCosmos with planes := [4, 7, 15, 4] }
theorem a48_forbids_thirtyPlanes : ¬ a48_planes thirtyPlanes := by unfold a48_planes; decide

abbrev sameDay : Cosmos := { okCosmos with yamaDay := 50 }
theorem a11_forbids_sameDay : ¬ a11_day_lengths sameDay := by unfold a11_day_lengths; decide

abbrev doubling : Cosmos := { okCosmos with lifespan := fun k => 9000000 * 2 ^ k }
theorem a49_forbids_doubling : ¬ a49_lifespans doubling := by
  unfold a49_lifespans; intro h; have := h 1 (by decide); revert this; decide

abbrev threePhases : Cosmos := { okCosmos with kappaPhases := 3 }
theorem a10_forbids_threePhases : ¬ a10_phases threePhases := by unfold a10_phases; decide

/-- A destruction by fire that reaches the Ābhassara plane (the sixth). -/
abbrev fireTooHigh : Cosmos := { okCosmos with fireReaches := 6 }
theorem a10_forbids_fireTooHigh : ¬ a10_limits fireTooHigh := by unfold a10_limits; decide

end FormalAbhidhamma.Model
