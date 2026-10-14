/-
  The founder's sixth supposition, RE-RUN under A394: AN 7.15's existence clause ("found in the world") is a premise and the
  World a population. Registered 2026-10-14T04:39:24Z (PREREG.md): the structures, the definitions and the statements of
  T6R and T6X below are verbatim. T6O cannot be proved from its premises, so it is restated clause for clause as the claim
  `t6o_registered`, which `run.sh` checks against the PREREG — and Lean proves it fails in one model and holds in another.
-/
namespace FormalAbhidhamma.PotentialWorld

/-- ONE being (supposition 1) with its POSSIBLE histories (as in the first run of this supposition, plus closure DOWNWARD:
    a history possible from `t` is possible from every earlier tick — the first run's refuter, F2). -/
structure Being where
  H : Type
  actual : H
  agree : H → H → Int → Prop
  patisandhi : H → Int → Prop
  incapable : H → Int → Prop
  heinous : H → Int → Prop
  wrongView : H → Int → Prop
  rootless : H → Int → Prop
  weak : H → Int → Prop
  agree_actual : ∀ t, agree actual actual t
  agree_down : ∀ h t t', agree h actual t → t' ≤ t → agree h actual t'
  agree_past : ∀ h t r, agree h actual t → r ≤ t →
    (patisandhi h r ↔ patisandhi actual r) ∧ (incapable h r ↔ incapable actual r) ∧ (heinous h r ↔ heinous actual r) ∧
    (wrongView h r ↔ wrongView actual r) ∧ (rootless h r ↔ rootless actual r) ∧ (weak h r ↔ weak actual r)

/-- The beings found in the world: a type `B` of them, each a `Being`. -/
structure World where
  B : Type
  being : B → Being

/-- CAN: from the existence at `r0` on, some possible history has an existence, then or later, in which the being is not
    incapable of the path. -/
def can_become_capable (b : Being) (r0 : Int) : Prop :=
  ∃ h, b.agree h b.actual r0 ∧ ∃ r, b.patisandhi h r ∧ r0 ≤ r ∧ ¬ b.incapable h r

/-- The sixth supposition, for the whole population: every being, from any existence of it, can still become capable. -/
def thesis6 (w : World) : Prop :=
  ∀ x r0, (w.being x).patisandhi (w.being x).actual r0 → can_become_capable (w.being x) r0

/-! ## The premises, one definition per axiom clause -/

/-- A124 (Vibhaṅga §826, read DISJUNCTIVELY as the commentaries read it): a being with an obstruction (kamma, defilement or
    result), or lacking faith, desire or wisdom, is incapable of the path. -/
def a124_incapable (b : Being) : Prop :=
  ∀ h r, b.heinous h r ∨ b.wrongView h r ∨ b.rootless h r ∨ b.weak h r → b.incapable h r

/-- A124 (Vibhaṅga §827): a being with no obstruction, and with faith, desire and wisdom, is capable of the path. -/
def a124_capable (b : Being) : Prop :=
  ∀ h r, ¬ b.heinous h r → ¬ b.wrongView h r → ¬ b.rootless h r → ¬ b.weak h r → ¬ b.incapable h r

/-- A124 §826, of every being in the world. -/
def a124_incapable_all (w : World) : Prop := ∀ x, a124_incapable (w.being x)

/-- A124 §827, of every being in the world. -/
def a124_capable_all (w : World) : Prop := ∀ x, a124_capable (w.being x)

/-- A125 (AN 7.15), the EXISTENCE clause (A394): the once-sunk person is "found in the world" — some being, at some
    existence of its actual history, endowed with entirely black states (a fixed wrong view: the commentaries'
    identification). -/
def a125_found_in_world (w : World) : Prop :=
  ∃ x r0, (w.being x).patisandhi (w.being x).actual r0 ∧ (w.being x).wrongView (w.being x).actual r0

/-- A125 (AN 7.15), the LITERAL reading of one being: the one "once sunk" at `r0` "stays sunk" — a fixed wrong view in every
    existence from `r0` on, in every possible history. -/
def a125_once_sunk_literal (b : Being) (r0 : Int) : Prop :=
  ∀ h, b.agree h b.actual r0 → ∀ r, b.patisandhi h r → r0 ≤ r → b.wrongView h r

/-- A125, the LITERAL reading of the person-type: whoever is once sunk stays sunk (the reading the AN commentary on AN 1.310
    holds in its own voice; the Kathāvatthu commentary attributes it to some Uttarāpathakas). -/
def a125_literal_all (w : World) : Prop :=
  ∀ x r0, (w.being x).patisandhi (w.being x).actual r0 → (w.being x).wrongView (w.being x).actual r0 →
    a125_once_sunk_literal (w.being x) r0

/-! ## The held-out answer -/

/-- ANSWER: Kv 19.7 §847–852 — no absolute fixity in wrong view, of any being in the world: from an existence in which a
    being holds a fixed wrong view, some possible history (the same up to it) has a LATER existence without one. -/
def answer_kv_19_7 (w : World) : Prop :=
  ∀ x r0, (w.being x).patisandhi (w.being x).actual r0 → (w.being x).wrongView (w.being x).actual r0 →
    ∃ h, (w.being x).agree h (w.being x).actual r0 ∧ ∃ r, (w.being x).patisandhi h r ∧ r0 < r ∧ ¬ (w.being x).wrongView h r

/-! ## A constructive `omega` (copied from `runs/2026-10-13-kv-22-10-duration-reading/Khanika2.lean`) -/

syntax "omega_c" : tactic
macro_rules
  | `(tactic| omega_c) => `(tactic| first
      | (apply And.intro <;> omega_c)
      | exact Decidable.byContradiction fun _h => by omega)

/-! ## T6R and T6X — PROVED -/

/-- T6R — on the LITERAL reading, the sixth supposition is REFUTED: the once-sunk person is found in the world, stays sunk,
    and so some being cannot become capable. -/
theorem t6r_refuted_on_the_literal_reading (w : World) (h124i : a124_incapable_all w) (h125e : a125_found_in_world w)
    (h125l : a125_literal_all w) :
    ¬ thesis6 w := by
  intro h6
  obtain ⟨x, r0, hp, hw⟩ := h125e
  obtain ⟨h, hag, r, hpr, hle, hni⟩ := h6 x r0 hp
  exact hni (h124i x h r (Or.inr (Or.inl (h125l x r0 hp hw h hag r hpr hle))))

/-- T6X — the literal reading is what the Kathāvatthu refutes: with the existence clause it contradicts the held-out
    answer. -/
theorem t6x_the_literal_reading_contradicts_the_answer (w : World) (h125e : a125_found_in_world w)
    (h125l : a125_literal_all w) :
    ¬ answer_kv_19_7 w := by
  intro ha
  obtain ⟨x, r0, hp, hw⟩ := h125e
  obtain ⟨h, hag, r, hpr, hlt, hnw⟩ := ha x r0 hp hw
  exact hnw (h125l x r0 hp hw h hag r hpr (Int.le_of_lt hlt))


/-! ## T6O — the registered statement, as a claim -/

/-- T6O as registered (`theorem t6o_on_the_restricted_reading`), clause for clause. -/
def t6o_registered : Prop :=
  ∀ (w : World), a124_incapable_all w → a124_capable_all w → a125_found_in_world w → thesis6 w

/-! ## The witness worlds -/

/-- One history; existences, incapacity and the four obstructions given tick by tick. -/
def oneHistory (pat inc hei wv rl wk : Int → Prop) : Being :=
  { H := Unit, actual := (), agree := fun _ _ _ => True,
    patisandhi := fun _ r => pat r, incapable := fun _ r => inc r, heinous := fun _ r => hei r,
    wrongView := fun _ r => wv r, rootless := fun _ r => rl r, weak := fun _ r => wk r,
    agree_actual := fun _ => trivial, agree_down := fun _ _ _ _ _ => trivial,
    agree_past := fun _ _ _ _ _ => ⟨Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl⟩ }

/-- A world of one being. -/
def single (b : Being) : World := ⟨Unit, fun _ => b⟩

/-- Once sunk, and sunk in every existence: a fixed wrong view throughout, incapable throughout. -/
def sunkForever : Being :=
  oneHistory (fun _ => True) (fun _ => True) (fun _ => False) (fun _ => True) (fun _ => False) (fun _ => False)

/-- A fixed wrong view throughout, yet never incapable (A124 broken). -/
def sunkButCapable : Being :=
  oneHistory (fun _ => True) (fun _ => False) (fun _ => False) (fun _ => True) (fun _ => False) (fun _ => False)

/-- No obstruction anywhere: capable throughout, and no one sunk. -/
def capableAlways : Being :=
  oneHistory (fun _ => True) (fun _ => False) (fun _ => False) (fun _ => False) (fun _ => False) (fun _ => False)

/-- TWO histories (the blind back-translation's model). Actually (`false`): existences up to 0, each in a fixed wrong view
    and incapable. Possibly (`true`, the same up to 0): one more existence at 1, out of the wrong view and capable. -/
def leavesInAnotherHistory : Being :=
  { H := Bool, actual := false, agree := fun h _ t => h = false ∨ t ≤ 0,
    patisandhi := fun h r => r ≤ 0 ∨ (h = true ∧ r = 1),
    incapable := fun _ r => r ≤ 0, heinous := fun _ _ => False, wrongView := fun _ r => r ≤ 0,
    rootless := fun _ _ => False, weak := fun _ _ => False,
    agree_actual := fun _ => Or.inl rfl,
    agree_down := by
      intro h t t' hag ht
      rcases hag with hf | ht0
      · exact Or.inl hf
      · exact Or.inr (by omega_c),
    agree_past := by
      intro h t r hag hr
      rcases hag with hf | ht0
      · subst hf; exact ⟨Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl⟩
      · have h0 : r ≤ 0 := by omega_c
        exact ⟨⟨fun _ => Or.inl h0, fun _ => Or.inl h0⟩, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl⟩ }

theorem sunk_incapable_all : a124_incapable_all (single sunkForever) := fun _ _ _ _ => trivial
theorem sunk_capable_all : a124_capable_all (single sunkForever) := fun _ _ _ _ hw _ _ _ => hw trivial
theorem leaves_incapable_all : a124_incapable_all (single leavesInAnotherHistory) := by
  intro _ _ r hd
  rcases hd with h | h | h | h
  · exact h.elim
  · exact h
  · exact h.elim
  · exact h.elim
theorem leaves_capable_all : a124_capable_all (single leavesInAnotherHistory) := fun _ _ _ _ hw _ _ => hw
theorem leaves_found : a125_found_in_world (single leavesInAnotherHistory) :=
  ⟨(), 0, Or.inl (Int.le_refl 0), Int.le_refl 0⟩
theorem leaves_thesis : thesis6 (single leavesInAnotherHistory) := by
  intro _ r0 hp
  have h0 : r0 ≤ 0 := by
    rcases hp with h | ⟨h1, _⟩
    · exact h
    · cases h1
  refine ⟨true, Or.inr h0, 1, Or.inr ⟨rfl, rfl⟩, by omega_c, ?_⟩
  show ¬ (1 : Int) ≤ 0
  decide

/-- T6O is NOT forced: a world whose once-sunk being stays sunk in every existence satisfies the premises. -/
theorem t6o_not_forced : ¬ t6o_registered := by
  intro h
  obtain ⟨_, _, r, _, _, hni⟩ := h (single sunkForever) sunk_incapable_all sunk_capable_all ⟨(), 0, trivial, trivial⟩ () 0 trivial
  exact hni trivial

/-- T6O is admitted: a world whose once-sunk being, in a possible history, leaves its view and becomes capable. With
    `t6o_not_forced`: INDEPENDENT on the restricted reading. -/
theorem t6o_admitted :
    ∃ w, a124_incapable_all w ∧ a124_capable_all w ∧ a125_found_in_world w ∧ thesis6 w :=
  ⟨single leavesInAnotherHistory, leaves_incapable_all, leaves_capable_all, leaves_found, leaves_thesis⟩

/-! ## Models of T6R's and T6X's hypotheses (rubric item 3), and necessity -/

/-- A model of T6R's and T6X's hypotheses together (rubric item 3): one being, sunk in every existence. -/
theorem model_t6r_hypotheses :
    ∃ w, a124_incapable_all w ∧ a125_found_in_world w ∧ a125_literal_all w :=
  ⟨single sunkForever, sunk_incapable_all, ⟨(), 0, trivial, trivial⟩, fun _ _ _ _ _ _ _ _ _ => trivial⟩

/-- T6R needs A124: a once-sunk being that is never incapable. -/
theorem needs_a124_incapable_all :
    ∃ w, a125_found_in_world w ∧ a125_literal_all w ∧ thesis6 w :=
  ⟨single sunkButCapable, ⟨(), 0, trivial, trivial⟩, fun _ _ _ _ _ _ _ _ _ => trivial,
    fun _ r0 _ => ⟨(), trivial, r0, trivial, Int.le_refl r0, fun h => h⟩⟩

/-- T6R and T6X need the existence clause: a world with no one sunk. -/
theorem needs_a125_found_in_world :
    ∃ w, a124_incapable_all w ∧ a125_literal_all w ∧ thesis6 w ∧ answer_kv_19_7 w := by
  refine ⟨single capableAlways, ?_, fun _ _ _ hw => hw.elim, fun _ r0 _ => ⟨(), trivial, r0, trivial, Int.le_refl r0, fun h => h⟩,
    fun _ _ _ hw => hw.elim⟩
  intro _ _ _ hd
  rcases hd with h | h | h | h <;> exact h.elim

/-- T6R and T6X need the literal reading: the once-sunk being leaves its view in a possible history. -/
theorem needs_a125_literal_all :
    ∃ w, a124_incapable_all w ∧ a125_found_in_world w ∧ thesis6 w ∧ answer_kv_19_7 w := by
  refine ⟨single leavesInAnotherHistory, leaves_incapable_all, leaves_found, leaves_thesis, ?_⟩
  intro _ r0 hp _
  have h0 : r0 ≤ 0 := by
    rcases hp with h | ⟨h1, _⟩
    · exact h
    · cases h1
  refine ⟨true, Or.inr h0, 1, Or.inr ⟨rfl, rfl⟩, by omega_c, ?_⟩
  show ¬ (1 : Int) ≤ 0
  decide


/-! ## Added on the run refuter's findings (F1, F6) -/

/-- The thesis ENTAILS the held-out answer (the run refuter's F1): with A124 §826, a being that can always become capable
    can always leave a fixed wrong view in a strictly later existence. So no premise set that proves the thesis can avoid
    restating Kv 19.7's conclusion — PROVED was unreachable under the hold-out (RUN.md, LEAK ACKNOWLEDGED). -/
theorem the_thesis_entails_the_answer (w : World) (h124i : a124_incapable_all w) (h6 : thesis6 w) :
    answer_kv_19_7 w := by
  intro x r0 hp hw
  obtain ⟨h, hag, r, hpr, hle, hni⟩ := h6 x r0 hp
  have hinc0 : (w.being x).incapable (w.being x).actual r0 := h124i x _ r0 (Or.inr (Or.inl hw))
  refine ⟨h, hag, r, hpr, ?_, fun hwv => hni (h124i x h r (Or.inr (Or.inl hwv)))⟩
  if hlt : r0 < r then exact hlt
  else
    have heq : r = r0 := by omega_c
    subst heq
    exact absurd ((((w.being x).agree_past h r r hag (Int.le_refl _)).2.1).mpr hinc0) hni

/-- A possible-histories being with a rebirth at EVERY tick in every history (the run refuter's F6 repair): actually it
    holds a fixed wrong view and is incapable in every existence; the history `some n` is the actual one up to `n`, then a
    rootless rebirth at `n + 1` (the fixed course's result, "immediately after the breakup of the aggregates"), then capable. -/
def sunkThenFreed : Being :=
  { H := Option Int, actual := none,
    agree := fun h _ t => h = none ∨ ∃ n, h = some n ∧ t ≤ n,
    patisandhi := fun _ _ => True,
    incapable := fun h r => match h with | none => True | some n => r ≤ n + 1,
    heinous := fun _ _ => False,
    wrongView := fun h r => match h with | none => True | some n => r ≤ n,
    rootless := fun h r => match h with | none => False | some n => r = n + 1,
    weak := fun _ _ => False,
    agree_actual := fun _ => Or.inl rfl,
    agree_down := by
      intro h t t' hag ht
      rcases hag with hn | ⟨n, hn, htn⟩
      · exact Or.inl hn
      · exact Or.inr ⟨n, hn, by omega_c⟩,
    agree_past := by
      intro h t r hag hr
      rcases hag with hn | ⟨n, hn, htn⟩
      · subst hn; exact ⟨Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl⟩
      · subst hn
        have h1 : r ≤ n + 1 := by omega_c
        have h2 : r ≤ n := by omega_c
        have h3 : ¬ r = n + 1 := fun hc => by omega
        exact ⟨Iff.rfl, ⟨fun _ => trivial, fun _ => h1⟩, Iff.rfl, ⟨fun _ => trivial, fun _ => h2⟩,
          ⟨fun h => absurd h h3, fun h => h.elim⟩, Iff.rfl⟩ }

/-- A model of T6O's premises with rebirth everywhere in which the thesis AND the held-out answer hold, and the being is
    capable in no existence of its ACTUAL history: CAN holds where WILL fails (the run refuter's F6 repair). -/
theorem t6o_admitted_with_rebirth :
    ∃ w, a124_incapable_all w ∧ a124_capable_all w ∧ a125_found_in_world w ∧ thesis6 w ∧ answer_kv_19_7 w ∧
      ∀ x r, (w.being x).incapable (w.being x).actual r := by
  refine ⟨single sunkThenFreed, ?_, ?_, ⟨(), 0, trivial, trivial⟩, ?_, ?_, fun _ _ => trivial⟩
  · intro _ h r hd
    cases h with
    | none => exact trivial
    | some n =>
      show r ≤ n + 1
      rcases hd with hh | hw | hr | hk
      · exact hh.elim
      · have : r ≤ n := hw; omega_c
      · have : r = n + 1 := hr; omega_c
      · exact hk.elim
  · intro _ h r _ hw hr _ hi
    cases h with
    | none => exact hw trivial
    | some n =>
      have a : ¬ r ≤ n := hw
      have b : ¬ r = n + 1 := hr
      have c : r ≤ n + 1 := hi
      exact absurd c (fun hc => by omega)
  · intro _ r0 _
    refine ⟨some r0, Or.inr ⟨r0, rfl, Int.le_refl r0⟩, r0 + 2, trivial, by omega_c, ?_⟩
    show ¬ r0 + 2 ≤ r0 + 1
    intro hc; omega
  · intro _ r0 _ _
    refine ⟨some r0, Or.inr ⟨r0, rfl, Int.le_refl r0⟩, r0 + 1, trivial, by omega_c, ?_⟩
    show ¬ r0 + 1 ≤ r0
    intro hc; omega

end FormalAbhidhamma.PotentialWorld
