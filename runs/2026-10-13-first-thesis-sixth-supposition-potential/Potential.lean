/-
  The founder's sixth supposition (2026-10-13), as approved: "Every being can still become an arahant: no being stays
  incapable of the path in every existence from some point on." Registered 2026-10-14T04:03:33Z (PREREG.md): the structure,
  the definitions and the statements of T6L and T6B below are verbatim. T6 (CAN) and T6W (WILL) cannot be proved from their
  premises, so each is restated, clause for clause, as a CLAIM (`t6_registered`, `t6w_registered`) that `run.sh` checks
  against the PREREG — and Lean proves the claim fails in one model of the premises and holds in another (INDEPENDENT).
-/
namespace FormalAbhidhamma.Potential

/-- ONE being (supposition 1) with its POSSIBLE histories, over which "can" ranges. `H`: the possible histories; `actual`:
    the one that occurs; `agree h h' t`: `h` is a possible history of `h'` from tick `t`; `patisandhi h r`: in `h` an
    existence begins at `r`; in `h`, in the existence beginning at `r`: `incapable` — incapable of the path (*abhabba*);
    `heinous` — the kamma-obstruction; `wrongView` — the defilement-obstruction (a fixed wrong view); `rootless` — the
    result-obstruction (a rootless or two-rooted rebirth); `weak` — lacking faith, desire or wisdom. The TYPE carries two
    constraints, both from what "a possible history" means: the actual history is one, and a possible history from `t` is
    the actual one at every existence that has begun by `t`. -/
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
  agree_past : ∀ h t r, agree h actual t → r ≤ t →
    (patisandhi h r ↔ patisandhi actual r) ∧ (incapable h r ↔ incapable actual r) ∧ (heinous h r ↔ heinous actual r) ∧
    (wrongView h r ↔ wrongView actual r) ∧ (rootless h r ↔ rootless actual r) ∧ (weak h r ↔ weak actual r)

/-- CAN: from the existence at `r0` on, some possible history has an existence, then or later, in which the being is not
    incapable of the path. -/
def can_become_capable (b : Being) (r0 : Int) : Prop :=
  ∃ h, b.agree h b.actual r0 ∧ ∃ r, b.patisandhi h r ∧ r0 ≤ r ∧ ¬ b.incapable h r

/-- WILL: from the existence at `r0` on, the ACTUAL history has an existence, then or later, in which the being is not
    incapable of the path. -/
def will_become_capable (b : Being) (r0 : Int) : Prop :=
  ∃ r, b.patisandhi b.actual r ∧ r0 ≤ r ∧ ¬ b.incapable b.actual r

/-! ## The premises, one definition per axiom clause -/

/-- A124 (Vibhaṅga §826, read DISJUNCTIVELY as the commentaries read it): a being with an obstruction (kamma, defilement or
    result), or lacking faith, desire or wisdom, is incapable of the path. -/
def a124_incapable (b : Being) : Prop :=
  ∀ h r, b.heinous h r ∨ b.wrongView h r ∨ b.rootless h r ∨ b.weak h r → b.incapable h r

/-- A124 (Vibhaṅga §827): a being with no obstruction, and with faith, desire and wisdom, is capable of the path. -/
def a124_capable (b : Being) : Prop :=
  ∀ h r, ¬ b.heinous h r → ¬ b.wrongView h r → ¬ b.rootless h r → ¬ b.weak h r → ¬ b.incapable h r

/-- A125 (AN 7.15), on the LITERAL reading — the one the commentary attributes to some Uttarāpathakas, which Kv 19.7
    refutes — with the commentaries' identification of "once sunk" as a fixed wrong view: from `r0`, a fixed wrong view in
    every existence, in every possible history. -/
def a125_once_sunk_literal (b : Being) (r0 : Int) : Prop :=
  ∀ h, b.agree h b.actual r0 → ∀ r, b.patisandhi h r → r0 ≤ r → b.wrongView h r

/-! ## The held-out answer -/

/-- ANSWER: Kv 19.7 §847–852 — no absolute fixity in wrong view: from an existence in which the being holds a fixed wrong
    view, some possible history (the same up to it) has a LATER existence without one. The debate's conclusion about the
    fixed wrong view only; the heinous deeds are its shared premise, not encoded; the framing in existences is the
    commentary's, and the modal reading is ours. -/
def answer_kv_19_7 (b : Being) : Prop :=
  ∀ r0, b.patisandhi b.actual r0 → b.wrongView b.actual r0 →
    ∃ h, b.agree h b.actual r0 ∧ ∃ r, b.patisandhi h r ∧ r0 < r ∧ ¬ b.wrongView h r

/-! ## A constructive `omega` (copied from `runs/2026-10-13-kv-22-10-duration-reading/Khanika2.lean`) -/

syntax "omega_c" : tactic
macro_rules
  | `(tactic| omega_c) => `(tactic| first
      | (apply And.intro <;> omega_c)
      | exact Decidable.byContradiction fun _h => by omega)

/-! ## The witness beings — one history each (so every possible history is the actual one) -/

/-- One history; existences, incapacity and the four obstructions given tick by tick. -/
def oneHistory (pat inc hei wv rl wk : Int → Prop) : Being :=
  { H := Unit, actual := (), agree := fun _ _ _ => True,
    patisandhi := fun _ r => pat r, incapable := fun _ r => inc r, heinous := fun _ r => hei r,
    wrongView := fun _ r => wv r, rootless := fun _ r => rl r, weak := fun _ r => wk r,
    agree_actual := fun _ => trivial,
    agree_past := fun _ _ _ _ _ => ⟨Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl⟩ }

/-- An existence at every tick, every one rootless (the result-obstruction), and so incapable. -/
def rootlessForever : Being :=
  oneHistory (fun _ => True) (fun _ => True) (fun _ => False) (fun _ => False) (fun _ => True) (fun _ => False)

/-- An existence at every tick, none obstructed, none incapable. -/
def capableAlways : Being :=
  oneHistory (fun _ => True) (fun _ => False) (fun _ => False) (fun _ => False) (fun _ => False) (fun _ => False)

/-- A fixed wrong view at 0, given up at once — and every existence from 1 on rootless. -/
def wrongThenRootless : Being :=
  oneHistory (fun r => 0 ≤ r) (fun r => 0 ≤ r) (fun _ => False) (fun r => r = 0) (fun r => 1 ≤ r) (fun _ => False)

/-- A fixed wrong view at every tick, yet never incapable (A124 broken). -/
def sunkButCapable : Being :=
  oneHistory (fun _ => True) (fun _ => False) (fun _ => False) (fun _ => True) (fun _ => False) (fun _ => False)

/-- A fixed wrong view at every tick, and incapable throughout. -/
def sunkForever : Being :=
  oneHistory (fun _ => True) (fun _ => True) (fun _ => False) (fun _ => True) (fun _ => False) (fun _ => False)

theorem rootless_incapable : a124_incapable rootlessForever := fun _ _ _ => trivial
theorem rootless_capable : a124_capable rootlessForever := fun _ _ _ _ hr _ => absurd trivial hr
theorem capable_incapable : a124_incapable capableAlways := by
  intro _ _ hd; rcases hd with h | h | h | h <;> exact h.elim
theorem capable_capable : a124_capable capableAlways := fun _ _ _ _ _ _ h => h

/-! ## T6 and T6W — the registered statements, as claims -/

/-- T6 as registered (`theorem t6_can_still_become_capable`), clause for clause. -/
def t6_registered : Prop :=
  ∀ (b : Being), a124_incapable b → a124_capable b → ∀ (r0 : Int), b.patisandhi b.actual r0 → can_become_capable b r0

/-- T6W as registered (`theorem t6w_will_become_capable`), clause for clause. -/
def t6w_registered : Prop :=
  ∀ (b : Being), a124_incapable b → a124_capable b → ∀ (r0 : Int), b.patisandhi b.actual r0 → will_become_capable b r0

/-- T6 (CAN) is NOT forced: a being rootless in every existence of every possible history satisfies the premises and
    cannot become capable. -/
theorem t6_not_forced : ¬ t6_registered := by
  intro h
  obtain ⟨_, _, r, _, _, hni⟩ := h rootlessForever rootless_incapable rootless_capable 0 trivial
  exact hni trivial

/-- T6 is admitted: a being capable in every existence. With `t6_not_forced`: INDEPENDENT. -/
theorem t6_admitted :
    ∃ b, a124_incapable b ∧ a124_capable b ∧ ∃ r0, b.patisandhi b.actual r0 ∧ can_become_capable b r0 :=
  ⟨capableAlways, capable_incapable, capable_capable, 0, trivial, (), trivial, 0, trivial, Int.le_refl 0, fun h => h⟩

/-- T6W (WILL) is NOT forced, by the same being. -/
theorem t6w_not_forced : ¬ t6w_registered := by
  intro h
  obtain ⟨r, _, _, hni⟩ := h rootlessForever rootless_incapable rootless_capable 0 trivial
  exact hni trivial

/-- T6W is admitted. With `t6w_not_forced`: INDEPENDENT. -/
theorem t6w_admitted :
    ∃ b, a124_incapable b ∧ a124_capable b ∧ ∃ r0, b.patisandhi b.actual r0 ∧ will_become_capable b r0 :=
  ⟨capableAlways, capable_incapable, capable_capable, 0, trivial, 0, trivial, Int.le_refl 0, fun h => h⟩

/-! ## T6L — PROVED -/

/-- T6L — on the literal reading of AN 7.15, the sixth supposition (CAN) fails for the one "once sunk". -/
theorem t6l_fails_for_the_once_sunk_on_the_literal_reading (b : Being) (h124i : a124_incapable b)
    (r0 : Int) (h125 : a125_once_sunk_literal b r0) :
    ¬ can_become_capable b r0 := by
  intro ⟨h, hag, r, hp, hle, hni⟩
  exact hni (h124i h r (Or.inr (Or.inl (h125 h hag r hp hle))))

/-! ## T6B — PROVED (a model) -/

/-- T6B — the Kathāvatthu's answer does not give the sixth supposition: a being that holds a fixed wrong view and CAN
    leave it, as the answer says, yet cannot become capable — its later existences rootless. -/
theorem t6b_the_answer_is_not_enough :
    ∃ b, a124_incapable b ∧ a124_capable b ∧ answer_kv_19_7 b ∧
      ∃ r0, b.patisandhi b.actual r0 ∧ b.wrongView b.actual r0 ∧ ¬ can_become_capable b r0 := by
  refine ⟨wrongThenRootless, ?_, ?_, ?_, 0, Int.le_refl 0, rfl, ?_⟩
  · intro _ r hd
    show 0 ≤ r
    rcases hd with h | h | h | h
    · exact h.elim
    · show 0 ≤ r; have : r = 0 := h; omega_c
    · show 0 ≤ r; have : 1 ≤ r := h; omega_c
    · exact h.elim
  · intro _ r _ hw hr _ hi
    have h1 : ¬ r = 0 := hw
    have h2 : ¬ 1 ≤ r := hr
    have h3 : 0 ≤ r := hi
    exact absurd h3 (by omega_c)
  · intro r0 _ hw
    have : r0 = 0 := hw
    exact ⟨(), trivial, 1, show (0 : Int) ≤ 1 by decide, by subst this; decide, show ¬ (1 : Int) = 0 by decide⟩
  · intro ⟨_, _, r, hp, hle, hni⟩
    exact hni (show 0 ≤ r from hle)


/-! ## Models of the provable theorems' hypotheses (rubric item 3), and necessity -/

/-- T6L's hypotheses are jointly satisfiable, with an existence after `r0` (not vacuously). -/
theorem model_t6l_hypotheses :
    ∃ b r0, a124_incapable b ∧ a125_once_sunk_literal b r0 ∧ b.patisandhi b.actual r0 :=
  ⟨sunkForever, 0, fun _ _ _ => trivial, fun _ _ _ _ _ => trivial, trivial⟩

/-- T6L needs A124: once sunk, yet capable, if a fixed wrong view did not make a being incapable. -/
theorem needs_a124_incapable :
    ∃ b r0, a125_once_sunk_literal b r0 ∧ can_become_capable b r0 :=
  ⟨sunkButCapable, 0, fun _ _ _ _ _ => trivial, (), trivial, 0, trivial, Int.le_refl 0, fun h => h⟩

/-- T6L needs A125's literal reading: without it, a being under A124 can be capable. -/
theorem needs_a125_literal :
    ∃ b r0, a124_incapable b ∧ can_become_capable b r0 :=
  ⟨capableAlways, 0, capable_incapable, (), trivial, 0, trivial, Int.le_refl 0, fun h => h⟩

end FormalAbhidhamma.Potential
