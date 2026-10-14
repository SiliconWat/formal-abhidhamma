/-
  A KNOWN-ANSWER CONTROL after the A393/A395 changes to the rubric, prereg.py, leak-check.py and runs-index.py (and today's
  AXIOMS rows): the Vajirabuddhi-ṭīkā's derivation that in beginningless saṃsāra there is no first citta
  (kala/ANSWERS.md "Vajirabuddhi first citta", HELD OUT), reproduced from premises that exclude it. A plumbing check by
  construction: the answer is one step from C's predecessor clause as the Visuddhimagga (XVII) states it in its own voice. One
  claim per theorem; each premise a definition named by its axiom ID. T0, which uses A3 alone, is the leak check's case that
  must read "no". Registered 2026-10-14T06:03:08Z (PREREG.md): the structure, definitions and statements are verbatim; the
  proofs and every other theorem added after.
-/
namespace FormalAbhidhamma.FirstCitta

/-- One stream of cittas on a clock of integer ticks. `citta t`: a citta of this stream occurs at tick `t`;
    `prox p q`: the citta at `p` conditions the citta at `q` by proximity. -/
structure World where
  citta : Int → Prop
  prox : Int → Int → Prop

/-! ## The premises, one definition per axiom clause -/

/-- C (the Paṭṭhāna commentary; the Paṭṭhāna's negative method): every citta has a citta that conditions it by proximity. -/
def c_predecessor (w : World) : Prop := ∀ q, w.citta q → ∃ p, w.prox p q ∧ w.citta p

/-- A3 (proximity): what conditions by proximity comes BEFORE what it conditions. -/
def a3_successor (w : World) : Prop := ∀ p q, w.prox p q → p < q

/-! ## The held-out answer, and the row that states the thesis -/

/-- ANSWER: Vajirabuddhi first citta — in beginningless saṃsāra there is no first citta: every citta has an earlier one. -/
def answer_vajirabuddhi_first_citta (w : World) : Prop := ∀ q, w.citta q → ∃ p, p < q ∧ w.citta p

/-- STATES: A77 — the manual's "the round is beginningless" (*anādikaṃ*), read for one stream: no citta is the first. -/
def states_a77 (w : World) : Prop := ¬ ∃ f, w.citta f ∧ ∀ t, w.citta t → f ≤ t

/-! ## The theorem (statement only) -/

/-- T1 — the control: from C and A3, every citta of the stream has an earlier citta (no first citta). -/
theorem t1_no_first_citta (w : World) (hC : c_predecessor w) (h3 : a3_successor w) :
    ∀ q, w.citta q → ∃ p, p < q ∧ w.citta p := by
  intro q hq
  obtain ⟨p, hp, hpc⟩ := hC q hq
  exact ⟨p, h3 p q hp, hpc⟩

/-- T0 — the leak check's negative case: from A3 alone, no citta conditions itself by proximity. -/
theorem t0_proximity_is_irreflexive (w : World) (h3 : a3_successor w) :
    ∀ p, ¬ w.prox p p := by
  intro p hp
  exact Int.lt_irrefl p (h3 p p hp)


/-! ## A model of T1's hypotheses with at least one citta (rubric item 3; the PREREG's pass criterion), and necessity -/

/-- A model of T1's hypotheses together, NOT vacuous: a citta at every tick, each conditioning the next. -/
theorem model_t1_hypotheses :
    ∃ w, c_predecessor w ∧ a3_successor w ∧ ∃ q, w.citta q :=
  ⟨⟨fun _ => True, fun p q => q = p + 1⟩, fun q _ => ⟨q - 1, show q = q - 1 + 1 by omega, trivial⟩,
    fun p q (h : q = p + 1) => by subst h; exact Int.lt_succ p, 0, trivial⟩

/-- T1 needs C: one citta and no proximity at all — it has no earlier citta. -/
theorem needs_c_predecessor :
    ∃ w, a3_successor w ∧ ¬ ∀ q, w.citta q → ∃ p, p < q ∧ w.citta p :=
  ⟨⟨fun t => t = 0, fun _ _ => False⟩, fun _ _ h => h.elim,
    fun h => (h 0 rfl).elim fun p ⟨hlt, hp⟩ => absurd (show p = 0 from hp) (fun e => by subst e; exact Int.lt_irrefl 0 hlt)⟩

/-- T1 needs A3: one citta, its own proximity condition — a loop, not a past. -/
theorem needs_a3_successor :
    ∃ w, c_predecessor w ∧ ¬ ∀ q, w.citta q → ∃ p, p < q ∧ w.citta p :=
  ⟨⟨fun t => t = 0, fun p q => p = q⟩, fun q hq => ⟨q, rfl, hq⟩,
    fun h => (h 0 rfl).elim fun p ⟨hlt, hp⟩ => absurd (show p = 0 from hp) (fun e => by subst e; exact Int.lt_irrefl 0 hlt)⟩

end FormalAbhidhamma.FirstCitta
