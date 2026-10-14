# PRE-REGISTRATION — first-thesis-sixth-supposition-in-the-world (PROOF)

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `02f5f66`.*

- **Date (machine):** 2026-10-13
- **Question:** Every being can still become an arahant: no being stays incapable of the path in every existence from some point on (the founder's sixth supposition, read as CAN), RE-RUN for the whole population with AN 7.15's existence clause — the once-sunk person is 'found in the world' — as a premise (A394). The scope of 'stays sunk' is a fork: on the LITERAL reading (every later existence) the thesis is tested for refutation (T6R, T6X); on the RESTRICTED reading (this existence only — the held-out answer, never a premise) the literal premise is simply omitted (T6O).
- **Thesis approved by:** the founder, 2026-10-13 (the sentence approved 'approve'; A394 ruled 'do per your recommendation', whose close condition is this re-run with the existence clause); one blind back-translation
- **Conventions: A389** (founder 2026-10-13): one claim per theorem; each premise its own binder, an ID-named definition;
  an instance stated as a hypothesis on a bound parameter (`(hk : k = 2)`), never as a literal
- **Window:** none
- **Instrument:** `SiliconWat/formal-abhidhamma` at `1e8908b` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## The exact Lean statement (the proof comes after; the statement may not move)

```lean
/-
  The founder's sixth supposition, RE-RUN under A394 (founder 2026-10-13: "1 and 2: do per your recommendation"): AN 7.15's
  existence clause — the once-sunk person is "found in the world" — enters as a premise, so the World is a POPULATION. The
  thesis as approved: "Every being can still become an arahant: no being stays incapable of the path in every existence from
  some point on" (read as CAN). The scope of "stays sunk" is a fork, both readings registered: the literal one (T6R, T6X) and
  the restricted one, which is the held-out answer and so is never a premise (T6O, which simply omits the literal premise).
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

/-! ## The theorems (statements only) -/

/-- T6R — on the LITERAL reading, the sixth supposition is REFUTED: the once-sunk person is found in the world, stays sunk,
    and so some being cannot become capable. -/
theorem t6r_refuted_on_the_literal_reading (w : World) (h124i : a124_incapable_all w) (h125e : a125_found_in_world w)
    (h125l : a125_literal_all w) :
    ¬ thesis6 w := by
  sorry

/-- T6X — the literal reading is what the Kathāvatthu refutes: with the existence clause it contradicts the held-out
    answer. -/
theorem t6x_the_literal_reading_contradicts_the_answer (w : World) (h125e : a125_found_in_world w)
    (h125l : a125_literal_all w) :
    ¬ answer_kv_19_7 w := by
  sorry

/-- T6O — on the RESTRICTED reading (the literal premise omitted; the restricted one is the held-out answer and never a
    premise), with the existence clause: every being can still become capable. -/
theorem t6o_on_the_restricted_reading (w : World) (h124i : a124_incapable_all w) (h124c : a124_capable_all w)
    (h125e : a125_found_in_world w) :
    thesis6 w := by
  sorry

end FormalAbhidhamma.PotentialWorld
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A124 | **Who is incapable of the path, and who capable** (Vibhaṅga §826–827): beings endowed with the kamma-obstruction, the defilement-obstruction, the result-obstruction, faithless, without desire, unwise, are INCAPABLE of entering the fixed course of rightness in wholesome states (*abhabbā niyāmaṃ okkamituṃ kusalesu dhammesu sammattaṃ*); those not so endowed, with faith, desire and wisdom, are CAPABLE (*bhabbā*). AN 6.86 has the same six as ONE person "endowed with six qualities", incapable "even while hearing the true Dhamma" — so capacity is conditional on hearing, and opportunity (a Buddha arisen, AN 8.29) is a separate condition. ⚠️ **Read DISJUNCTIVELY by the commentaries, not by us** (corrected 2026-10-13 on the sixth supposition's vetting refuter): the Puggalapaññatti commentary makes each a class of its own — the heinous-deed doers, the fixed-view holders, those reborn rootless or two-rooted, the faithless, the desireless, those without full bhavaṅga-wisdom — and ADDS a seventh, "those with no decisive support for path and fruit"; the Visuddhimagga inserts *vā*. The Piṭaka's form is conjunctive (*ca … ca*; the Puggalapaññatti adds *eḷā*, a seventh quality), which would leave a middle class. ⚠️ Every gloss of the obstructions is commentarial and they differ (the Visuddhimagga adds the hermaphrodite and the eunuch to the defilement-obstruction); "without desire" is glossed as humans of the other three continents, "unwise" as a rebirth without wisdom — mostly REBIRTH properties — while the Visuddhimagga's ṭīkā has faith, desire and wisdom cultivated. A sub-commentary names an incapacity outside the six: one whose course is fixed toward paccekabodhi cannot attain the paths in between. ⭐ Capacity indexed to ONE BIRTH is a Piṭaka idiom both sides of Kv 13.4 share (*bhabbo bodhisatto tāya jātiyā*) — ⚠️ but capacity also CHANGES WITHIN a birth: had King Ajātasattu not killed his father, "the Dhamma-eye would have arisen on this very seat" (DN 2 §253, `s0101m.mul.xml:1477`), so the kamma-obstruction is acquired mid-life. ⚠️ Piṭaka parity for the disjunctive reading (OURS, an inference): AN 6.87 frames the five heinous deeds and dullness as "six qualities" of ONE person, which read conjunctively would need all five heinous deeds in one life (`s0403m2.mul.xml:3062`). ⚠️ A run that encodes §826 disjunctively and §827 as written encodes a HYBRID no single layer asserts: the Puggalapaññatti commentary's capable is "none of SEVEN". How long an incapacity lasts is what Kv 19.7 settles (ANSWERS). Added 2026-10-13 for the founder's sixth supposition | Piṭaka (Vibhaṅga; AN 6.86; Kv 13.4, a shared idiom) + commentarial (the disjunctive reading and the glosses) | Vibhaṅga §826 `abh02m.mul.xml:9965`, §827 `:9969`; AN 6.86 `s0403m2.mul.xml:3050`, `:3054`; Pp §12–13 `abh03m2.mul.xml:813`, `:817`; Kv 13.4 §664 `abh03m3.mul.xml:10353`; Pp-a `abh03a.att.xml:873`, `:877`; Vism `e0101n.mul.xml:4373` | VERIFIED | — |
| A125 | **The one "once sunk, stays sunk"** (*sakiṃ nimuggo nimuggova hoti*): the first of seven persons "found in the world" (*santo saṃvijjamānā lokasmiṃ*), one endowed with entirely black unwholesome states; within the sutta, "emerging" is faith, shame, fear, energy and wisdom in wholesome states, so "stays sunk" reads as lacking those (A124's *weak*). ⚠️ That the entirely black states are a FIXED WRONG VIEW is the commentaries' identification. ⚠️ The SCOPE of "stays" is READ two ways: in every later existence (the reading the commentary attributes to some Uttarāpathakas, which Kv 19.7 refutes) or in this existence only (the MN and Kathāvatthu commentaries; a ṭīkā: supramundane faith does not arise in THAT birth) — both loci belong with ANSWERS Kv 19.7, so only the sutta's words are cited here. ⚠️ The literal reading is NOT only the opponent's (corrected on the sixth supposition's run refuter, F6): the AN commentary holds it in its own voice — the fixed wrong view has "no limit … no emergence from existence … neither heaven nor path" — and the Puggalapaññatti commentary reports it, "they say there is no emergence for him", with Makkhali Gosāla as its instance. A run may encode the literal reading as a reading; the restricted one is the held-out answer and never a premise. ⭐ The EXISTENCE clause ("found in the world") may enter as a premise (A394, founder 2026-10-13). A Puggalapaññatti person is a concept (ANSWERS sort rule): it enters as a definition. Added 2026-10-13 for the founder's sixth supposition; revised the same night on its vetting refuter | Piṭaka (Sutta; Puggalapaññatti) + commentarial (the identification; the literal reading in a commentary's own voice) | AN 7.15 `s0403m3.mul.xml:362`, `:366`, `:370`; Pp §203 `abh03m2.mul.xml:2129`; Pp-a `abh03a.att.xml:1773`; AN-a on AN 1.310 `s0401a.att.xml:5823` | VERIFIED | — |

## Type freedoms — what the Lean type leaves free, declared before the attempt (A388 OQ4)

- A population: a type of beings found in the world, each one being as its possible histories (supposition 1); the population may be a single being, and the existence clause asserts at least one once-sunk being
- Possible histories: the actual one is one; one possible from t keeps every existence begun by t, and is possible from every earlier tick (closure downward — the first run's refuter F2). A possible history from an existence's start keeps that WHOLE existence, though capacity can change within a birth (DN 2 §253) — declared, not encoded. No kamma, javanas, world-cycle or opportunity
- A124 encoded on the commentaries' DISJUNCTIVE reading (§826) with §827 as written — a hybrid no single layer asserts; the once-sunk's 'entirely black states' encoded as a fixed wrong view (the commentaries' identification)
- The answer: framed in existences (the commentary's), read modally (ours), about the fixed wrong view only

## Held out — the texts' own answers this run may NOT reason from

- Kv 19.7 §847–852

## States the thesis — rows that already state it (A393: the leak check tests them; reaching one is a check, not a finding)

- none

## Predicted outcome

- **The session predicts:** REFUTED
- **The founder predicts:** PROVED

## Predictions

1. T6R PROVED (the thesis REFUTED on the literal reading): from A124 §826, the existence clause and the literal reading, some being cannot become capable; constructive; Unused none; layer commentarial (the identification and the disjunctive reading)
2. T6X PROVED: the existence clause and the literal reading contradict the held-out answer — the encoding reproduces that the literal reading is the view Kv 19.7 refutes
3. T6O INDEPENDENT: on the restricted reading the existence clause decides nothing — a world where the once-sunk being leaves its view and becomes capable, and one where it stays sunk
4. leak-check: 'no' for T6R, T6X and T6O (no premise set reaches the answer; T6X's reaches its negation)
5. GRADE NOT STRONG: T6R is a CHECK of the AN commentary on AN 1.310 (item 2 aside, the thesis's refutation is stated there in its own voice); T6O's countermodel rests on free futures (item 2)

## Pass criteria for the instrument

- (none beyond the predictions)
