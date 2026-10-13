/-
  Kathāvatthu 22.10 (Khaṇikakathā) §906–907 — a /prove known-answer CONTROL, NARROWED after its vetting (2026-10-13): the
  view "all dhammas last one mind-moment" is tested on BOTH readings of "one mind-moment". The statements are VERBATIM as registered (PREREG
  pushed 2026-10-13T20:04:02Z, OTS); the proofs, the worlds and the breaks came after.
  Premises: A87, A98, A115, A117 (Piṭaka). HELD OUT: A69 (this debate's own conclusion) and A4's commentarial 17.
  Narrowed TWICE after vetting: the existence premise is its own row (A115); and a "base present THROUGHOUT the
  consciousness" premise was DROPPED — no layer says it (the Vibhaṅga and its commentary make the unbroken base a
  condition of the ARISING, A116), and it would import the held-out A69.
  ⚠️ BY CONSTRUCTION, declared: every dhamma of a `World` has a birth, so the view is tested only over CONDITIONED dhammas
  (the commentary's own scope, *sabbasaṅkhatadhammā*, `abh03a.att.xml:6353`); nibbāna is outside it.
-/
namespace FormalAbhidhamma.Khanika

/-- Dhammas on a clock: `birth d` is the moment `d` arises, `present d t` that `d` exists at `t`, and `pre e c` that `e`
    conditions `c` by pre-nascence (*purejāta*). Family A's clock counts mind-moments; family B's counts sub-moments. -/
structure World where
  Dhamma : Type
  birth : Dhamma → Int
  present : Dhamma → Int → Prop
  pre : Dhamma → Dhamma → Prop

/-! ## Family A — the ALIGNED reading: a one-moment dhamma arises and ceases WITH one citta
    (KV-a `abh03a.att.xml:6353`: *cakkhāyatanādīni cakkhuviññāṇādīhi saddhiṃyeva uppajjitvā nirujjheyyuṃ*). -/

/-- The view, aligned: every dhamma exists at exactly one mind-moment, the one at which it arises. -/
def OneMoment (w : World) : Prop := ∀ d t, w.present d t ↔ t = w.birth d

/-- *Niccā dhuvā sassatā* (§907): a dhamma that exists at every moment. -/
def Permanent (w : World) (d : w.Dhamma) : Prop := ∀ t, w.present d t

/-- §907's conclusion: every dhamma is permanent. -/
def AllPermanent (w : World) : Prop := ∀ d, Permanent w d

/-- T1. If eye-consciousness occurs with a pre-nascent eye-base (A115, read with A87's law), the base arose BEFORE it (A87: *purejāta*),
    and the base is present when the consciousness arises (A98), then the aligned view is false. -/
theorem t1_aligned_view_refuted (w : World)
    (a115_occurs : ∃ e c, w.pre e c)
    (a87_purejata : ∀ e c, w.pre e c → w.birth e < w.birth c)
    (a98_atthi : ∀ e c, w.pre e c → w.present e (w.birth c)) :
    ¬ OneMoment w := by
  intro h
  obtain ⟨e, c, hp⟩ := a115_occurs
  have hlt := a87_purejata e c hp
  have heq := (h e (w.birth c)).mp (a98_atthi e c hp)
  omega


/-- Two dhammas: `false`, an eye-base born at 0, and `true`, an eye-consciousness born at 1, which the base conditions by
    pre-nascence. `life t` says when they exist; the worlds below differ only in it. -/
def eyeWorld (life : Bool → Int → Prop) : World where
  Dhamma := Bool
  birth := fun b => if b then 1 else 0
  present := life
  pre := fun e c => e = false ∧ c = true

theorem eyeWorld_premises (life : Bool → Int → Prop) (h : life false 1) :
    (∃ e c, (eyeWorld life).pre e c) ∧ (∀ e c, (eyeWorld life).pre e c → (eyeWorld life).birth e < (eyeWorld life).birth c) ∧
      (∀ e c, (eyeWorld life).pre e c → (eyeWorld life).present e ((eyeWorld life).birth c)) := by
  refine ⟨⟨false, true, rfl, rfl⟩, ?_, ?_⟩
  · rintro e c ⟨rfl, rfl⟩; show (0 : Int) < 1; omega
  · rintro e c ⟨rfl, rfl⟩; exact h

/-- T2's world: each dhamma exists from its birth up to moment 1, so the base is present when the consciousness arises,
    and nothing is permanent. -/
def shortLife : Bool → Int → Prop := fun d t => (if d then 1 else 0) ≤ t ∧ t ≤ 1

/-- T2 (§907, the opponent's counter: "if not all one-moment, then all permanent"). That inference does not follow from
    the same premises: some world satisfies them and the inference fails in it. -/
theorem t2_counter_does_not_follow :
    ∃ w : World, (∃ e c, w.pre e c) ∧ (∀ e c, w.pre e c → w.birth e < w.birth c) ∧
      (∀ e c, w.pre e c → w.present e (w.birth c)) ∧ ¬ (¬ OneMoment w → AllPermanent w) := by
  have hp := eyeWorld_premises shortLife (by simp [shortLife])
  refine ⟨eyeWorld shortLife, hp.1, hp.2.1, hp.2.2, fun f => ?_⟩
  have hperm := f (t1_aligned_view_refuted _ hp.1 hp.2.1 hp.2.2) false 2
  simp [eyeWorld, shortLife] at hperm

/-! ## Family B — the DURATION reading: a one-moment dhamma lasts the LENGTH of one mind-moment, from its own arising,
    aligned to no citta (Vism-ṭīkā `e0103n.att.xml:4209`: *ekacittakkhaṇamattavantaṃ*). The clock counts sub-moments,
    `k` to a mind-moment: the Yamaka names at least two (A117); the manual counts three (A40). -/

/-- The view, by duration: every dhamma exists for exactly `k` sub-moments from its arising. -/
def OneCittaLength (w : World) (k : Int) : Prop := ∀ d t, w.present d t ↔ (w.birth d ≤ t ∧ t < w.birth d + k)

/-- T3. With the base present when the consciousness ARISES (A98; the Vibhaṅga's unbroken base, A116, says the same),
    the premises do not settle the duration view whenever a mind-moment has at least two sub-moments (A117): for every
    such `k`, one world satisfies them with the view true and another with it false. -/
theorem t3_duration_view_open (k : Int) (a117_two_submoments : 2 ≤ k) :
    (∃ w : World, (∃ e c, w.pre e c) ∧ (∀ e c, w.pre e c → w.birth e < w.birth c) ∧
        (∀ e c, w.pre e c → w.present e (w.birth c)) ∧ OneCittaLength w k) ∧
    (∃ w : World, (∃ e c, w.pre e c) ∧ (∀ e c, w.pre e c → w.birth e < w.birth c) ∧
        (∀ e c, w.pre e c → w.present e (w.birth c)) ∧ ¬ OneCittaLength w k) := by
  constructor
  · -- the view TRUE: each dhamma exists for exactly `k` sub-moments from its birth; at k ≥ 2 the base, born one
    -- sub-moment earlier, is still there when the consciousness arises
    have hp := eyeWorld_premises (fun d t => (if d then 1 else 0) ≤ t ∧ t < (if d then 1 else 0) + k)
      -- proved directly, not by `omega`: `omega` closes a goal that is not `False` by contradiction, which made the
      -- first version of this theorem CLASSICAL for no mathematical reason (found by tools/Uses.lean, 2026-10-13)
      (by simp only [Bool.false_eq_true, ite_false]
          exact ⟨by decide, by rw [Int.zero_add]; exact Int.lt_of_lt_of_le (by decide) a117_two_submoments⟩)
    exact ⟨_, hp.1, hp.2.1, hp.2.2, fun d t => Iff.rfl⟩
  · -- the view FALSE: everything exists at every moment
    have hp := eyeWorld_premises (fun _ _ => True) trivial
    refine ⟨_, hp.1, hp.2.1, hp.2.2, fun h => ?_⟩
    have := (h false (-1)).mp trivial
    simp only [eyeWorld, Bool.false_eq_true, ite_false] at this
    omega

end FormalAbhidhamma.Khanika
