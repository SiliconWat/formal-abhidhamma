/-
  model/Clocks.lean — the TWO CLOCKS (roadmap A424 (d); founder 2026-10-18). `Mind.lean` has ONE `Scale`, the stream's own: each
  citta of one stream has its own reading on it, and A3 gives their ORDER. The ordinary clock, the DAY-RECKONING that
  A104 and A126 designate on the turning of sun and moon, is a second scale laid on the first by a map that keeps the order and is
  not one-to-one (the "standard part" when the stream's scale is non-standard). A112's step across cessation spans no
  moment on the stream's clock and "seven days or so" on the day-reckoning; A24's rate and its "no citta lasts a night or a day"
  are statements on the day-reckoning.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything.

  ⚠️ Declared freedoms (recorded in the freedoms list, not rows): whether the reckoning is injective (it need not be) · what the
  seven days are exactly (A112 says "seven days or so"; the encoding reads a night at least, a week at most, the refuter's
  surviving form) · the mindless existence, the second exception (up to 500 great aeons, DN-ṭīkā `s0101t.tik.xml:2053`) is NOT
  encoded here. A104's "time is designated on the turning of the moon and the like" is the DEFINITION of the second scale and is not a
  separate clause: `Reck.f` is that designation.
  Q2′ (amendment 2): the definitions compare readings of the two scales with `lt` and quantify over moments; the rate
  (`a24_rate`) mentions a list of distinct moments, a count, and is NOT first-order in form.
-/
import Mind
namespace FormalAbhidhamma.Model

/-- A stream with a second clock laid on it: `f` reads a reading of the stream's clock on the day-reckoning; `cessation m` marks the
    neither-perception moment before a cessation attainment; `night` and `week` are the day-reckoning's lengths (A112, A24). -/
structure Reck (S R : Scale) where
  s : Stream S
  f : S.T → R.T
  cessation : s.M → Prop
  night : R.T
  week : R.T
  snap : R.T

/-- A7 and A126 (L2/L3, `abh01a.att.xml:3721`): time laid on the stream is a designation — a map from the stream's readings that keeps their order
    (a later reading is never earlier on the day-reckoning) and need not be one-to-one. -/
def a7_reckoning_keeps_order (S R : Scale) (z : Reck S R) : Prop := ∀ a b, S.lt a b → ¬ R.lt (z.f b) (z.f a)

/-- A112 (L1/L2/L3, the order-without-a-gap run): across cessation proximity holds with no moment between, yet the day-reckoning shows a
    night at least and a week at most (*"seven days or so"*, the Vibhāvinī; the Vism-ṭīkā's day-reckoning). The stream's own clock shows
    the order only. -/
def a112_cessation_step (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m n, z.cessation m → z.s.prox m n →
    ¬ R.lt (z.f (z.s.arise n)) (R.add (z.f (z.s.close m)) z.night) ∧ ¬ R.lt (R.add (z.f (z.s.close m)) z.week) (z.f (z.s.arise n))

/-- A24, no night or day (L2, `s0302a.att.xml:1463`): no single citta lasts a night or a day on the day-reckoning. -/
def a24_no_night (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m, R.lt (z.f (z.s.close m)) (R.add (z.f (z.s.arise m)) z.night)

/-- Steps of proximity that pass through no cessation moment (A24's rate is of ordinary mind, not of the gap of a cessation): `StepsFree blocked prox n m b`. -/
inductive StepsFree {M : Type} (blocked : M → Prop) (prox : M → M → Prop) : Nat → M → M → Prop
  | zero (m : M) : StepsFree blocked prox 0 m m
  | succ {n : Nat} {m a b : M} : StepsFree blocked prox n m a → prox a b → ¬ blocked a → StepsFree blocked prox (n + 1) m b

/-- A24, the rate (L2, `s0302a.att.xml:1463`, `abh02a.att.xml:533`): in one finger-snap "many hundreds of thousands of koṭis" of cittas arise — at least
    10¹² distinct moments of the stream arise within any stretch of the day-reckoning one snap long. A lower bound (*aneka*): ⚠️ a
    ṭīkā reads the snap as only *anekakoṭi*, about 10⁷ (`abh04t.nrf.xml:821`), a VARIANT recorded in the variants list. -/
def a24_rate (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m n, StepsFree z.cessation z.s.prox 1000000000000 m n → R.lt (z.f (z.s.arise n)) (R.add (z.f (z.s.arise m)) z.snap)

/-- A24 and A112, the lengths (refuter 2, findings 1 and 6): a snap is a positive length shorter than a night, and a night is no longer than a week. -/
def a112_night_week_order (S R : Scale) (z : Reck S R) : Prop := R.lt R.zero z.snap ∧ R.lt z.snap z.night ∧ ¬ R.lt z.week z.night

/-- A47, on the clock (L5, `abh07t.nrf.xml:1501`, the Vibhāvinī's *abbocchinnā asati nirodhasamāpattiyaṃ*): outside cessation the stream is unbroken in time too — a step of proximity from a moment
    that is not a cessation moment shows no gap on the day-reckoning. -/
def a47_unbroken_on_the_clock (S R : Scale) (z : Reck S R) : Prop :=
  ∀ m n, ¬ z.cessation m → z.s.prox m n → ¬ R.lt (z.f (z.s.close m)) (z.f (z.s.arise n))

/-! ## Forbidden worlds (both clocks on the whole numbers) -/

/-- Moments 0, 1, 2, … , moment n arising at 4n and closing at 4n + 3, so one unit of the stream's own clock lies between a close and the next
    arising (the step of proximity); each moment the proximate successor of the one before. -/
abbrev cchain : Stream Z :=
  ⟨Nat, fun n => (4 * n : Int), fun n => (4 * n + 1 : Int), fun n => (4 * n + 2 : Int), fun n => (4 * n + 3 : Int), fun m n => n = m + 1⟩

abbrev reck (f : Int → Int) (cess : Nat → Prop) (night week snap : Int) : Reck Z Z :=
  { s := cchain, f := f, cessation := cess, night := night, week := week, snap := snap }

/-- A reckoning that runs backward. -/
abbrev backward : Reck Z Z := reck (fun a => -a) (fun _ => False) 2 7 4
theorem a7_forbids_backward : ¬ a7_reckoning_keeps_order Z Z backward := by
  intro h; exact h 0 1 (by decide) (by decide)

/-- A cessation step the day-reckoning shows as one unit, less than a night of two (the reckoning is the identity). -/
abbrev noGap : Reck Z Z := reck (fun a => a) (fun m => m = 0) 2 7 4
theorem a112_forbids_noGap : ¬ a112_cessation_step Z Z noGap := by
  intro h; exact (h 0 1 rfl rfl).1 (by decide)

/-- A cessation step the day-reckoning shows as longer than a week (the reckoning stretches that step to a month). -/
abbrev tooLong : Reck Z Z := reck (fun a => if a < 4 then a else a + 30) (fun m => m = 0) 2 7 4
theorem a112_forbids_tooLong : ¬ a112_cessation_step Z Z tooLong := by
  intro h; exact (h 0 1 rfl rfl).2 (by decide)

/-- A citta that lasts a night: the reckoning stretches a moment's three sub-moment units to nine, over a night of two. -/
abbrev longCitta : Reck Z Z := reck (fun a => 3 * a) (fun _ => False) 2 7 4
theorem a24_forbids_longCitta : ¬ a24_no_night Z Z longCitta := by
  intro h; have := h 0; revert this; decide

@[local simp] theorem free_reach (n : Nat) : StepsFree (fun _ : Nat => False) cchain.prox n 0 n := by
  induction n with
  | zero => exact StepsFree.zero 0
  | succ n ih => exact StepsFree.succ ih (show n + 1 = n + 1 from rfl) (by simp)

/-- A snap that holds a single citta (moments four units apart, a snap of four units): a trillion cittas do not fit. -/
abbrev oneInASnap : Reck Z Z := reck (fun a => a) (fun _ => False) 2 7 4
theorem a24_forbids_oneInASnap : ¬ a24_rate Z Z oneInASnap := by
  intro h
  have := h 0 1000000000000 (free_reach 1000000000000)
  revert this; decide

/-- A snap as long as a night. -/
abbrev snapAsLongAsANight : Reck Z Z := reck (fun a => a) (fun _ => False) 4 7 4
theorem a112_forbids_snapAsLongAsANight : ¬ a112_night_week_order Z Z snapAsLongAsANight := by
  intro h; exact absurd h.2.1 (by decide)

/-- A gap on the day-reckoning at an ordinary step (the identity reckoning shows one unit between a close and the next arising). -/
abbrev gapAtAnOrdinaryStep : Reck Z Z := reck (fun a => a) (fun _ => False) 2 7 4
theorem a47_forbids_gapAtAnOrdinaryStep : ¬ a47_unbroken_on_the_clock Z Z gapAtAnOrdinaryStep := by
  intro h; exact h 0 1 (by simp [gapAtAnOrdinaryStep, reck]) rfl (by decide)

end FormalAbhidhamma.Model
