# PRE-REGISTRATION — first-thesis-sixth-supposition-potential (PROOF)

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `02f5f66`.*

- **Date (machine):** 2026-10-13
- **Question:** Every being can still become an arahant: no being stays incapable of the path in every existence from some point on (the founder's sixth supposition; 'buddha or arahant' narrowed to arahant, since a Buddha also attains arahantship; 'potential' read as capacity for the path, Vibhaṅga §826–827's bhabba). The sentence admits two readings of 'stays', both registered: CAN, some possible history (T6), and WILL, the actual history (T6W).
- **Thesis approved by:** the founder, 2026-10-13 ('approve'); the vetting refuter, 2026-10-13 (F1–F14 applied or declared: the answer runs from a FIXED existence to a strictly later one; a possible history keeps the past; both readings of 'stays' registered; the thesis-to-answer comparison dropped; the Kv 19.7, A124 and A125 rows revised); two blind back-translations, the second after the revision
- **Conventions: A389** (founder 2026-10-13): one claim per theorem; each premise its own binder, an ID-named definition;
  an instance stated as a hypothesis on a bound parameter (`(hk : k = 2)`), never as a literal
- **Window:** none
- **Instrument:** `SiliconWat/formal-abhidhamma` at `3c24c75` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## The exact Lean statement (the proof comes after; the statement may not move)

```lean
/-
  The founder's sixth supposition (2026-10-13), as approved: "Every being can still become an arahant: no being stays
  incapable of the path in every existence from some point on." One claim per theorem; each premise a definition named by
  its axiom ID; the held-out answer (kala/ANSWERS.md Kv 19.7 §847–852) as `answer_kv_19_7`. The approved sentence admits two
  readings of "stays" — CAN (some possible history) and WILL (the actual history) — and both are registered (T6, T6W).
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

/-! ## The theorems (statements only) -/

/-- T6 — the sixth supposition, read as CAN: from any existence of this being, it can still become capable of the path. -/
theorem t6_can_still_become_capable (b : Being) (h124i : a124_incapable b) (h124c : a124_capable b)
    (r0 : Int) (hr0 : b.patisandhi b.actual r0) :
    can_become_capable b r0 := by
  sorry

/-- T6W — the sixth supposition, read as WILL: from any existence of this being, it will become capable of the path. -/
theorem t6w_will_become_capable (b : Being) (h124i : a124_incapable b) (h124c : a124_capable b)
    (r0 : Int) (hr0 : b.patisandhi b.actual r0) :
    will_become_capable b r0 := by
  sorry

/-- T6L — on the literal reading of AN 7.15, the sixth supposition (CAN) fails for the one "once sunk". -/
theorem t6l_fails_for_the_once_sunk_on_the_literal_reading (b : Being) (h124i : a124_incapable b)
    (r0 : Int) (h125 : a125_once_sunk_literal b r0) :
    ¬ can_become_capable b r0 := by
  sorry

/-- T6B — the Kathāvatthu's answer does not give the sixth supposition: a being that holds a fixed wrong view and CAN
    leave it, as the answer says, yet cannot become capable — its later existences rootless. -/
theorem t6b_the_answer_is_not_enough :
    ∃ b, a124_incapable b ∧ a124_capable b ∧ answer_kv_19_7 b ∧
      ∃ r0, b.patisandhi b.actual r0 ∧ b.wrongView b.actual r0 ∧ ¬ can_become_capable b r0 := by
  sorry

end FormalAbhidhamma.Potential
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A124 | **Who is incapable of the path, and who capable** (Vibhaṅga §826–827): beings endowed with the kamma-obstruction, the defilement-obstruction, the result-obstruction, faithless, without desire, unwise, are INCAPABLE of entering the fixed course of rightness in wholesome states (*abhabbā niyāmaṃ okkamituṃ kusalesu dhammesu sammattaṃ*); those not so endowed, with faith, desire and wisdom, are CAPABLE (*bhabbā*). AN 6.86 has the same six as ONE person "endowed with six qualities", incapable "even while hearing the true Dhamma" — so capacity is conditional on hearing, and opportunity (a Buddha arisen, AN 8.29) is a separate condition. ⚠️ **Read DISJUNCTIVELY by the commentaries, not by us** (corrected 2026-10-13 on the sixth supposition's vetting refuter): the Puggalapaññatti commentary makes each a class of its own — the heinous-deed doers, the fixed-view holders, those reborn rootless or two-rooted, the faithless, the desireless, those without full bhavaṅga-wisdom — and ADDS a seventh, "those with no decisive support for path and fruit"; the Visuddhimagga inserts *vā*. The Piṭaka's form is conjunctive (*ca … ca*; the Puggalapaññatti adds *eḷā*, a seventh quality), which would leave a middle class. ⚠️ Every gloss of the obstructions is commentarial and they differ (the Visuddhimagga adds the hermaphrodite and the eunuch to the defilement-obstruction); "without desire" is glossed as humans of the other three continents, "unwise" as a rebirth without wisdom — mostly REBIRTH properties — while the Visuddhimagga's ṭīkā has faith, desire and wisdom cultivated. A sub-commentary names an incapacity outside the six: one whose course is fixed toward paccekabodhi cannot attain the paths in between. ⭐ Capacity indexed to ONE BIRTH is a Piṭaka idiom both sides of Kv 13.4 share (*bhabbo bodhisatto tāya jātiyā*). How long an incapacity lasts is what Kv 19.7 settles (ANSWERS). Added 2026-10-13 for the founder's sixth supposition | Piṭaka (Vibhaṅga; AN 6.86; Kv 13.4, a shared idiom) + commentarial (the disjunctive reading and the glosses) | Vibhaṅga §826 `abh02m.mul.xml:9965`, §827 `:9969`; AN 6.86 `s0403m2.mul.xml:3050`, `:3054`; Pp §12–13 `abh03m2.mul.xml:813`, `:817`; Kv 13.4 §664 `abh03m3.mul.xml:10353`; Pp-a `abh03a.att.xml:873`, `:877`; Vism `e0101n.mul.xml:4373` | VERIFIED | — |
| A125 | **The one "once sunk, stays sunk"** (*sakiṃ nimuggo nimuggova hoti*): the first of seven persons "found in the world" (*santo saṃvijjamānā lokasmiṃ*), one endowed with entirely black unwholesome states; within the sutta, "emerging" is faith, shame, fear, energy and wisdom in wholesome states, so "stays sunk" reads as lacking those (A124's *weak*). ⚠️ That the entirely black states are a FIXED WRONG VIEW is the commentaries' identification. ⚠️ The SCOPE of "stays" is READ two ways: in every later existence (the reading the commentary attributes to some Uttarāpathakas, which Kv 19.7 refutes) or in this existence only (the MN and Kathāvatthu commentaries; a ṭīkā: supramundane faith does not arise in THAT birth) — both loci belong with ANSWERS Kv 19.7, so only the sutta's words are cited here, and a run encodes the literal reading only as the opponent's, never the restricted one as a premise. A Puggalapaññatti person is a concept (ANSWERS sort rule): it enters as a definition. Added 2026-10-13 for the founder's sixth supposition; revised the same night on its vetting refuter | Piṭaka (Sutta; Puggalapaññatti) + commentarial (the identification) | AN 7.15 `s0403m3.mul.xml:362`, `:366`, `:370`; Pp §203 `abh03m2.mul.xml:2129` | VERIFIED | — |

## Type freedoms — what the Lean type leaves free, declared before the attempt (A388 OQ4)

- One being, as its possible histories (supposition 1); existences delimited by rebirth-linking ticks; NO kamma, javanas, world-cycle or opportunity (hearing the Dhamma, a Buddha arisen — AN 6.86, AN 8.29): T6 is about CAPACITY for the path, not attaining it
- Which futures are possible is constrained only by what 'a possible history' means (the actual one is one; it keeps every existence begun by its branch point). The CAN countermodel rests on this: the texts that would constrain futures — Vism XIII §405, 'ALL beings are reborn in the Brahma world' at a world's end (commentarial), against DN 1 §39 'MOSTLY' (Piṭaka) and the Vinaya ṭīkā's 'said of the majority' — are declared, not encoded
- The obstruction predicates are free per existence; A124 is encoded on the commentaries' DISJUNCTIVE reading; the Puggalapaññatti commentary's seventh class (no decisive support for path and fruit) and the paccekabodhi exception are not encoded
- The answer: framed in existences (the commentary's), read modally (ours), about the fixed wrong view only — the heinous deeds, the debate's shared premise, are not encoded

## Held out — the texts' own answers this run may NOT reason from

- Kv 19.7 §847–852

## States the thesis — rows that already state it (A393: the leak check tests them; reaching one is a check, not a finding)

- none

## Predicted outcome

- **The session predicts:** INDEPENDENT
- **The founder predicts:** PROVED

## Predictions

1. T6 (CAN) INDEPENDENT: a model with the being rootless in every later existence of every possible history, and one where it is capable — the first admitted at the Piṭaka layer (DN 1 'mostly'), excluded at the commentarial layer only on Vism XIII §405's 'all'
2. T6W (WILL) INDEPENDENT the same way
3. T6L PROVED from A124 (disjunctive) and A125 (literal): on the reading the commentary attributes to some Uttarāpathakas, the sixth supposition fails for the once-sunk; constructive; commentarial layer
4. T6B PROVED by a model: a being that holds a fixed wrong view and CAN leave it, as the Kathāvatthu says, yet never becomes capable — the answer does not give the sixth supposition
5. leak-check: no premise set reaches answer_kv_19_7 (every row 'no')
6. GRADE NOT STRONG: item 2 (the CAN countermodel rests on the unconstrained futures) and items 1/9 (A124's encoding is the commentaries' reading)

## Pass criteria for the instrument

- (none beyond the predictions)
