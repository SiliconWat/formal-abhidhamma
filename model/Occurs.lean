/-
  model/Occurs.lean — the OCCURRENCE LIST as Lean (Protocol 1 §4): what a model must CONTAIN, as opposed to what its rows forbid. A world that satisfies every row but contains
  nothing satisfies them all vacuously (`procs := []`, no kalāpas, no facts), so a model is a World with `Satisfies w ∧ Occurs w`. The list is `LISTS.md` §1.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–4, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything; its only world is the EMPTY one, and the empty world must FAIL each clause.

  ⚠️ NOT YET EXPRESSIBLE in this World (recorded in `LISTS.md`, to be named in Protocol 2 as the occurrence list's declared gaps): A18 an eclipse and A20 a full and a new moon (they are
  MOTIONS of the sun and moon in time, and the Cosmos is a set of numbers) · A51 each of the four kinds of rebirth and A55 each of the four kinds of death (a moment carries no citta-type) ·
  A124 an incapable being and a capable one, A125 a person of entirely black states (no persons in the stream) · A26 each sort (BY THE TYPE).
-/
import World
namespace FormalAbhidhamma.Model
open FormalAbhidhamma FormalAbhidhamma.Relata

variable {S R : Scale}

/-- A28: each of the 89 types occurs as the citta of some step of some process. -/
def o_a28_every_type (w : World S R) : Prop := ∀ c ∈ w.tax.kinds89, ∃ p ∈ w.proc.procs, ∃ s ∈ p.steps, reckon89 s.citta = c
/-- A29: each of the 52 cetasikas arises in the citta of some step. -/
def o_a29_every_cetasika (w : World S R) : Prop := ∀ x ∈ w.tax.cets, ∃ p ∈ w.proc.procs, ∃ s ∈ p.steps, w.tax.assoc (reckon89 s.citta) x = true
/-- A35: each of the fourteen functions is performed in some process. -/
def o_a35_every_function (w : World S R) : Prop := ∀ k ∈ Kicca.all, ∃ p ∈ w.proc.procs, ∃ s ∈ p.steps, s.kicca = k
/-- A36: each of the six doors is the door of some process. -/
def o_a36_every_door (w : World S R) : Prop := ∀ d ∈ [Door.eye, .ear, .nose, .tongue, .body, .mind], ∃ p ∈ w.proc.procs, p.door = d
/-- A41: a very great five-door process. -/
def o_a41_very_great (w : World S R) : Prop := ∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ p.past = 1
/-- A42: each of the four grades. -/
def o_a42_every_grade (w : World S R) : Prop :=
  (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ p.past = 1) ∧ (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ 2 ≤ p.past ∧ p.past ≤ 3) ∧
  (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ 4 ≤ p.past ∧ p.past ≤ 9) ∧ (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ 10 ≤ p.past ∧ p.past ≤ 15)
/-- A43: a mind-door process, and an absorption. -/
def o_a43_mind_door_and_absorption (w : World S R) : Prop := (∃ p ∈ w.proc.procs, p.kind = .mindDoor) ∧ (∃ p ∈ w.proc.procs, p.kind = .absorption)
/-- A109: a path process. -/
def o_a109_path (w : World S R) : Prop := ∃ p ∈ w.proc.procs, p.kind = .path
/-- A110 (as far as a process carries a person): each of a worldling, a noble person and an arahant. -/
def o_a110_every_person (w : World S R) : Prop :=
  (∃ p ∈ w.proc.procs, p.person = .worldling) ∧ (∃ p ∈ w.proc.procs, p.person = .noble) ∧ (∃ p ∈ w.proc.procs, p.person = .arahant)
/-- A115: a meeting at a sense door where the eye (or other organ) is intact, the object in range and attention present. -/
def o_a115_a_meeting (w : World S R) : Prop := ∃ m ∈ w.proc.meetings, m.door ≠ .mind ∧ m.intact = true ∧ m.inRange = true ∧ m.attended = true
/-- A107: a super-knowledge. -/
def o_a107_an_abhinna (w : World S R) : Prop := ∃ c ∈ w.tax.kinds, w.tax.abhinna c = true
/-- A48: a being in each sphere (the 31 planes are the cosmos's; here the three spheres a Being carries). -/
def o_a48_every_sphere (w : World S R) : Prop := ∀ b ∈ [Bhumi.kama, .rupa, .arupa], ∃ x ∈ w.mat.beings, x.plane = b
/-- A13: an immaterial being, and a mindless one. -/
def o_a13_both_kinds (w : World S R) : Prop := (∃ x ∈ w.mat.beings, x.plane = .arupa) ∧ (∃ x ∈ w.mat.beings, x.hasMind = false)
/-- A60: each concretely produced kind of matter is in some kalāpa. -/
def o_a60_every_kind (w : World S R) : Prop := ∀ r ∈ w.tax.rupas, w.tax.nipphanna r = true → ∃ k ∈ w.mat.kalapas, r ∈ k.members
/-- A6: matter outside any being. -/
def o_a6_outside (w : World S R) : Prop := ∃ k ∈ w.mat.kalapas, k.owner = none
/-- A64: each origin. -/
def o_a64_every_origin (w : World S R) : Prop := ∀ o ∈ Origin.all, ∃ k ∈ w.mat.kalapas, k.origin = o
/-- A66: each of the twenty-one kalāpas. -/
def o_a66_every_kalapa (w : World S R) : Prop := ∀ t ∈ twentyOne, ∃ k ∈ w.mat.kalapas, isKind k t = true
/-- K: a corpse — temperature-born matter of a body, in a world where a death occurs. (The weak form: that it persists AFTER the death needs the matter placed in the stream.) -/
def o_k_a_corpse (w : World S R) : Prop := (∃ d, w.death d) ∧ ∃ k ∈ w.mat.kalapas, k.origin = .utu ∧ k.owner ≠ none
/-- A56: a death followed at once by a rebirth. -/
def o_a56_death_then_rebirth (w : World S R) : Prop := ∃ d n, w.death d ∧ w.s.prox d n ∧ w.rebirth n
/-- A77: a beginningless stream — one that has a moment at all (the beginningless law is `Satisfies`). -/
def o_a77_a_stream (w : World S R) : Prop := ∃ _m : w.s.M, True
/-- A78: each of the twenty-four conditions holds between some pair. -/
def o_a78_every_condition (w : World S R) : Prop := ∀ c ∈ Relata.all, ∃ f ∈ w.cond.holds, f.1 = c
/-- A111: a cessation with its emergence. -/
def o_a111_cessation_with_emergence (w : World S R) : Prop := ∃ m n, w.cessation m ∧ w.s.prox m n ∧ w.fruition n

/-- The occurrence list, as far as this World can say it. -/
def Occurs (w : World S R) : Prop :=
  o_a28_every_type w ∧ o_a29_every_cetasika w ∧ o_a35_every_function w ∧ o_a36_every_door w ∧ o_a41_very_great w ∧ o_a42_every_grade w ∧
  o_a43_mind_door_and_absorption w ∧ o_a109_path w ∧ o_a110_every_person w ∧ o_a115_a_meeting w ∧ o_a107_an_abhinna w ∧ o_a48_every_sphere w ∧
  o_a13_both_kinds w ∧ o_a60_every_kind w ∧ o_a6_outside w ∧ o_a64_every_origin w ∧ o_a66_every_kalapa w ∧ o_k_a_corpse w ∧
  o_a56_death_then_rebirth w ∧ o_a77_a_stream w ∧ o_a78_every_condition w ∧ o_a111_cessation_with_emergence w

/-! ## The control: the EMPTY world must fail the occurrence list (Protocol 1 §8: "If it passes, the conditions are broken") -/

/-- The empty world: no moments, no matter, no processes, no facts. -/
def emptyWorld : World Z Z :=
  { s := ⟨Empty, fun m => Empty.elim m, fun m => Empty.elim m, fun m => Empty.elim m, fun m => Empty.elim m, fun m _ => Empty.elim m⟩,
    K := Empty, origin := fun k => Empty.elim k, mom := fun k => Empty.elim k, phase := fun k => Empty.elim k,
    rebirth := fun _ => False, produces := fun _ => False, embodied := fun _ => False, death := fun _ => False, cessation := fun _ => False,
    parinibbana := fun _ => False, fruition := fun _ => False, concrete := fun k => Empty.elim k, ceaseMom := fun k => Empty.elim k,
    ceasePhase := fun k => Empty.elim k, sense := fun _ => False, base := fun _ => none, object := fun _ => none,
    f := fun a => a, night := 2, week := 7, snap := 1,
    cond := ⟨[], []⟩, momOf := fun _ => none,
    mat := { beings := [], kalapas := [], reached := [] }, proc := bareProc, tax := bare, cosmos := okCosmos, status := okStatus }

theorem empty_world_fails_a41 : ¬ o_a41_very_great emptyWorld := by
  intro h; obtain ⟨p, hp, _⟩ := h; simp [emptyWorld, bareProc] at hp
theorem empty_world_fails_a35 : ¬ o_a35_every_function emptyWorld := by
  intro h; obtain ⟨p, hp, _⟩ := h Kicca.patisandhi (by simp [Kicca.all]); simp [emptyWorld, bareProc] at hp
theorem empty_world_fails_a6 : ¬ o_a6_outside emptyWorld := by
  intro h; obtain ⟨k, hk, _⟩ := h; simp [emptyWorld] at hk
theorem empty_world_fails_a78 : ¬ o_a78_every_condition emptyWorld := by
  intro h; obtain ⟨f, hf, _⟩ := h Condition.hetu (by simp [Relata.all]); simp [emptyWorld] at hf
theorem empty_world_fails_a77 : ¬ o_a77_a_stream emptyWorld := by
  intro h; obtain ⟨m, _⟩ := h; exact Empty.elim m
theorem empty_world_fails_a111 : ¬ o_a111_cessation_with_emergence emptyWorld := by
  intro h; obtain ⟨m, _⟩ := h; exact Empty.elim m
theorem empty_world_fails_a56 : ¬ o_a56_death_then_rebirth emptyWorld := by
  intro h; obtain ⟨d, _⟩ := h; exact Empty.elim d
/-- The empty world fails the occurrence list as a whole. -/
theorem empty_world_fails_occurs : ¬ Occurs emptyWorld := fun h => empty_world_fails_a41 h.2.2.2.2.1

/-! ## The second control: A4's seventeen and the sixteen planted together are FOUND (Protocol 1 §6: two rival readings are never entered together — a contradiction by entry) -/

/-- The variant, a ṭīkā's argument: the matter that arises at a citta's arising ceases at the dissolution of the citta FIFTEEN steps on (sixteen moments, counting the first). -/
def a4_variant_sixteen (S : Scale) (l : Link S) : Prop :=
  ∀ k, l.concrete k = true → l.phase k = .arise → Steps l.s.prox 15 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .dissolve

/-- On a chain of moments, a matter group that arises at a citta's arising cannot cease both fifteen and sixteen steps on: the two readings entered together are a contradiction by entry,
    for every place cm the group is made to cease at. -/
theorem a4_forbids_sixteenAndSeventeenTogether (cm : Nat) :
    ¬ (a4_life_in_the_stream Z (chainLink .utu 0 .arise cm .dissolve 0) ∧ a4_variant_sixteen Z (chainLink .utu 0 .arise cm .dissolve 0)) := by
  intro ⟨h17, h16⟩
  have e17 := chain_steps (((h17 () rfl).1 rfl).1)
  have e16 := chain_steps ((h16 () rfl rfl).1)
  simp at e17 e16
  omega

end FormalAbhidhamma.Model
