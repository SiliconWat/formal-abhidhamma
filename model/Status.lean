/-
  model/Status.lean — the STATUS part of the one World: what sort each thing is (ultimate or concept), what is time-free, what space is, what a designation names.
  Most of STATUS is carried BY THE TYPE (the census marks A26, A103, A104, A126, A7, A8 class T): the sorts below are disjoint, a stream's moments are cittas, so no
  world makes nibbāna a moment or a concept a thing that arises. What is written here is what a world still has to SAY and a forbidden world can contradict.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything.

  A26 (four ultimate sorts), A8 (what is time-free) and A9 (the three spaces) are definitions below. A7 (time is a function on moments) is `Mind.lean`'s `Stream.arise`/`Clocks.lean`'s `Reck`;
  A103 (presence) is `Link.present_at_arising` and `Cond`'s present-at clauses; A104 and A126 (designations) are the sorts + `Designation` here; A70 (nibbāna is unconditioned
  and one) is `a70_nibbana` below, and "the path and fruition cittas take it" is `Tax.a38`.
-/
namespace FormalAbhidhamma.Model

/-- The sorts a thing can be: the four ultimates, and the concept (*paññatti*). -/
inductive Sort5 | citta | cetasika | rupa | nibbana | pannatti deriving DecidableEq, Repr

/-- The six designations of the Puggalapaññatti commentary (A126), of which only the one by a thing's own nature (*tajjā*) names something real. -/
inductive Designation | derivation | relative | collection | placing | ownNature | continuity deriving DecidableEq, Repr

/-- The three spaces (A9): delimiting space, space removed by a kasiṇa, unentangled space. -/
inductive Space | delimiting | kasina | unentangled deriving DecidableEq, Repr

/-- The twelve links of dependent origination (A76). -/
inductive Link12 | ignorance | formations | consciousness | mindMatter | sixBases | contact | feeling | craving | clinging | becoming | birth | decayDeath
  deriving DecidableEq, Repr

/-- What a world says of status. -/
structure Status where
  ultimates : List Sort5
  timeFree : List Sort5
  spaceSort : Space → Sort5
  realDesignation : Designation → Bool
  nibbanaConditioned : Bool
  nibbanaCount : Nat
  /-- what direction and time are designated on, by the sort they are -/
  timeSort : Sort5
  /-- dependent origination (A76, A77): the links in order, and how many fall in each of the three periods -/
  chain : List Link12
  periods : List Nat
  modes : Nat
  connections : Nat
  groups : Nat
  rounds : Nat
  roots : Nat

/-- A26 (L4, ch. 1 §2, `abh07t.nrf.xml:33–37`): what is real in the ultimate sense is fourfold — citta, cetasika, rūpa, nibbāna; a concept is none of them. -/
def a26_ultimates (c : Status) : Prop := c.ultimates = [.citta, .cetasika, .rupa, .nibbana]

/-- A8 (L4/L5): the time-free are nibbāna and concepts — because they do not perish — and nothing else. -/
def a8_time_free (c : Status) : Prop := c.timeFree = [.nibbana, .pannatti]

/-- A9 (L1/L2): delimiting space is conditioned (matter); the space removed by a kasiṇa and unentangled space are concepts. ⚠️ VARIANT: unentangled space as matter (A5's rival, recorded in the variants list). -/
def a9_three_spaces (c : Status) : Prop :=
  c.spaceSort .delimiting = .rupa ∧ c.spaceSort .kasina = .pannatti ∧ c.spaceSort .unentangled = .pannatti

/-- A70 (L4): nibbāna is unconditioned and one by nature. -/
def a70_nibbana (c : Status) : Prop := c.nibbanaConditioned = false ∧ c.nibbanaCount = 1

/-- A104 (L4, ch. 8 §39–43, `abh07t.nrf.xml:2977–3005`): direction and time are concepts, designated on the revolution of the moon and the like. -/
def a104_time_is_a_concept (c : Status) : Prop := c.timeSort = .pannatti

/-- A126 (L2, `abh03a.att.xml:741–753`): only the designation by a thing's own nature designates something real. A REPORTED classification (the teachers'). -/
def a126_only_own_nature (c : Status) : Prop := ∀ d, c.realDesignation d = true ↔ d = .ownNature

/-- A76 (L1/L4, Vibhaṅga ch. 6 `abh02m.mul.xml:3633`; Saṅgaha ch. 8 §4, `abh07t.nrf.xml:2773`): dependent origination has twelve links, in this order. -/
def a76_twelve_links (c : Status) : Prop :=
  c.chain = [.ignorance, .formations, .consciousness, .mindMatter, .sixBases, .contact, .feeling, .craving, .clinging, .becoming, .birth, .decayDeath]

/-- A77, the structure (L4, ch. 8 §5–10; the beginningless clause is Mind.lean's `a77_beginningless`): three periods of two, eight and two links; twenty modes, three connections, four groups,
    three rounds (defilement, kamma, result) and two roots (ignorance and craving). -/
def a77_structure (c : Status) : Prop :=
  c.periods = [2, 8, 2] ∧ c.modes = 20 ∧ c.connections = 3 ∧ c.groups = 4 ∧ c.rounds = 3 ∧ c.roots = 2

/-! ## Forbidden worlds -/

abbrev okStatus : Status :=
  { ultimates := [.citta, .cetasika, .rupa, .nibbana], timeFree := [.nibbana, .pannatti],
    spaceSort := fun s => match s with | .delimiting => .rupa | _ => .pannatti,
    realDesignation := fun d => d == .ownNature, nibbanaConditioned := false, nibbanaCount := 1, timeSort := .pannatti,
    chain := [.ignorance, .formations, .consciousness, .mindMatter, .sixBases, .contact, .feeling, .craving, .clinging, .becoming, .birth, .decayDeath],
    periods := [2, 8, 2], modes := 20, connections := 3, groups := 4, rounds := 3, roots := 2 }

abbrev conceptUltimate : Status := { okStatus with ultimates := [.citta, .cetasika, .rupa, .nibbana, .pannatti] }
theorem a26_forbids_conceptUltimate : ¬ a26_ultimates conceptUltimate := by unfold a26_ultimates; decide

abbrev mattersTimeFree : Status := { okStatus with timeFree := [.nibbana, .pannatti, .rupa] }
theorem a8_forbids_mattersTimeFree : ¬ a8_time_free mattersTimeFree := by unfold a8_time_free; decide

abbrev kasinaSpaceMatter : Status := { okStatus with spaceSort := fun _ => .rupa }
theorem a9_forbids_kasinaSpaceMatter : ¬ a9_three_spaces kasinaSpaceMatter := by
  unfold a9_three_spaces; intro h; exact absurd h.2.1 (by decide)

abbrev conditionedNibbana : Status := { okStatus with nibbanaConditioned := true }
theorem a70_forbids_conditionedNibbana : ¬ a70_nibbana conditionedNibbana := by unfold a70_nibbana; decide

abbrev realTime : Status := { okStatus with timeSort := .rupa }
theorem a104_forbids_realTime : ¬ a104_time_is_a_concept realTime := by unfold a104_time_is_a_concept; decide

abbrev derivationReal : Status := { okStatus with realDesignation := fun d => d == .ownNature || d == .derivation }
theorem a126_forbids_derivationReal : ¬ a126_only_own_nature derivationReal := by
  unfold a126_only_own_nature; intro h; have := (h .derivation).mp (by decide); exact absurd this (by decide)

/-- Eleven links (the six bases left out). -/
abbrev elevenLinks : Status := { okStatus with chain := [.ignorance, .formations, .consciousness, .mindMatter, .contact, .feeling, .craving, .clinging, .becoming, .birth, .decayDeath] }
theorem a76_forbids_elevenLinks : ¬ a76_twelve_links elevenLinks := by unfold a76_twelve_links; decide

/-- Contact before the six bases. -/
abbrev swapped : Status := { okStatus with chain := [.ignorance, .formations, .consciousness, .mindMatter, .contact, .sixBases, .feeling, .craving, .clinging, .becoming, .birth, .decayDeath] }
theorem a76_forbids_swapped : ¬ a76_twelve_links swapped := by unfold a76_twelve_links; decide

/-- Three periods split 3, 6, 3. -/
abbrev periodsThreeSixThree : Status := { okStatus with periods := [3, 6, 3] }
theorem a77_forbids_periodsThreeSixThree : ¬ a77_structure periodsThreeSixThree := by unfold a77_structure; decide

end FormalAbhidhamma.Model
