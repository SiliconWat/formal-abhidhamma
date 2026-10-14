# PRE-REGISTRATION — vajirabuddhi-first-citta-control (PROOF — CONTROL, KNOWN ANSWER: Vajirabuddhi first citta)

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `e50e62f`.*

- **Date (machine):** 2026-10-13
- **Question:** In saṃsāra whose beginning is unknown there is no first citta: from C (every citta has a citta that conditions it by proximity) and A3 (proximity runs forward), every citta of a stream has an earlier one — the Vajirabuddhi-ṭīkā's derivation (vin06t.nrf.xml:2177), held out, reproduced as the known-answer control the /prove skill requires after the A393–A395 changes to the rubric, the instrument and AXIOMS.md.
- **Thesis approved by:** the vetting refuter, 2026-10-13 (F1–F13 applied or declared: F1 ruled by the founder, 'do all per your recommendation' — a control's own answer is exempt from A395; F2 the blind reading made from a STRIPPED copy; C's headline narrowed to citta and Vism XVII added; A77's anādikaṃ marked derived at its place; the Vajirabuddhi row's Tests narrowed to the Piṭaka layer; a non-empty model and a negative case added); one stripped blind back-translation (matched); ordered by the founder, 2026-10-13: 'run it before my next thesis'
- **Conventions: A389** (founder 2026-10-13): one claim per theorem; each premise its own binder, an ID-named definition;
  an instance stated as a hypothesis on a bound parameter (`(hk : k = 2)`), never as a literal
- **Window:** none
- **Instrument:** `SiliconWat/formal-abhidhamma` at `e50e62f` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## The exact Lean statement (the proof comes after; the statement may not move)

```lean
/-
  A KNOWN-ANSWER CONTROL after the A393/A395 changes to the rubric, prereg.py, leak-check.py and runs-index.py (and today's
  AXIOMS rows): the Vajirabuddhi-ṭīkā's derivation that in beginningless saṃsāra there is no first citta
  (kala/ANSWERS.md "Vajirabuddhi first citta", HELD OUT), reproduced from premises that exclude it. A plumbing check by
  construction: the answer is one step from C's predecessor clause as the Visuddhimagga (XVII) states it in its own voice. One
  claim per theorem; each premise a definition named by its axiom ID. T0, which uses A3 alone, is the leak check's case that
  must read "no".
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
  sorry

/-- T0 — the leak check's negative case: from A3 alone, no citta conditions itself by proximity. -/
theorem t0_proximity_is_irreflexive (w : World) (h3 : a3_successor w) :
    ∀ p, ¬ w.prox p p := by
  sorry

end FormalAbhidhamma.FirstCitta
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| C | Conditionality: every CITTA has an immediate predecessor citta that conditions it by proximity (matter arises NOT by proximity — the Paṭṭhāna's negative method; headline narrowed 2026-10-13 on the post-A395 control's vetting refuter, F11); ignorance is not an uncaused root-cause of the world (*na akāraṇaṃ*). ⭐ Asserted in Buddhaghosa's own voice too: "as a citta arises without some among the root condition and the rest, not so is there any arising of a citta without the proximate citta" (*na evaṃ anantaracittaṃ vinā cittassa uppatti nāma atthi*, Vism XVII). ⭐ **The predecessor clause, by layer** (2026-10-13; corrected the same night on the first thesis's run refuter, F2): the Paṭṭhāna commentary STATES it — whatever arises by the object condition does not fail to get proximity and contiguity (*na hi ārammaṇapaccayādīhi uppajjamānā anantarasamanantarapaccayādayo na labhanti*); in the Paṭṭhāna itself it is a JOIN of two lines (what arises not by proximity is like what arises not by object, and that is matter only), with the Dhammasaṅgaṇī's every mental aggregate having an object — the join is sound for every citta, but the tier is the commentary's. ⚠️ "Just ceased" is about ORDER, not time: the predecessor of the first citta after cessation ceased about seven days before (A112), and after the mindless existence up to five hundred great eons before — *ciraniruddhampi hi cittaṃ … anantarapaccayamattaṃ hotiyeva*. ⚠️ A sub-commentary DERIVES from it that there is no first citta (ANSWERS "Vajirabuddhi first citta"). The Sutta's wording stays epistemic (A2), the manual's is *anādikaṃ* (A77) | commentarial (Paṭṭhāna-aṭṭhakathā; Vism XVII) + Piṭaka (the two lines and Dhs §1191) + Vism XVII §584 | `abh03a.att.xml:9117`; Vism XVII `e0102n.mul.xml:3725`; `abh03m7.mul.xml:1201` (the cross-reference), `:1153–1169` (the not-by-object list); Dhs §1191 `abh01m.mul.xml:7925`; `s0101t.tik.xml:2053–2057` (after the mindless existence); `e0102n.mul.xml:3553` | VERIFIED | `Conditioned`, `beginningless` |
| A3 | Proximity (*anantara*): each moment conditions its immediate successor — *natthi etesaṃ antaraṃ*, "there is no interval between them" (the commentary), which it keeps apart from immediacy in TIME: across cessation there is none, and the condition still holds. ⚠️ Corrected 2026-10-13 (the Kv 8.2 control's vetting, F5): the clause "even across many thousands of kappas" and its line `abh05t.nrf.xml:2409` moved to ANSWERS Kv 8.2 — that line is the anuṭīkā's refutation of the intermediate existence (it ends *nattheva antarābhavo*); runs registered before keep their PREREG copies | Piṭaka (Paṭṭhāna, quoted) + commentarial | Paṭṭhāna niddesa quoted at `abh03a.att.xml:7693`; *natthi etesaṃ antaraṃ* `:7697` | VERIFIED — mūla Paṭṭhāna `abh03m7.mul.xml:85–89` (*purimā purimā … pacchimānaṃ pacchimānaṃ … anantarapaccayena paccayo*), read 2026-09-30 | `Stream.tick_succ`, `Stream.continues` |

## Type freedoms — what the Lean type leaves free, declared before the attempt (A388 OQ4)

- One stream of cittas on integer ticks: that a predecessor is a citta of the SAME stream is supplied by the type (no text encoded for it); the clock is unbounded below (on the naturals, C and A3 with one citta are unsatisfiable); A3's 'no interval' is not encoded, only its order; matter, existences, the mindless and cessation are outside the World
- A77's round (defilement, kamma, result in three planes) cannot be expressed; states_a77 reads it for one stream, where it is classically EQUIVALENT to the answer — so the leak check's STATED on A77 and TRIVIAL on the answer carry one bit, not two (by construction); A2 is not listed because its wording is epistemic ('not discerned')

## Held out — the texts' own answers this run may NOT reason from

- Vajirabuddhi first citta

## States the thesis — rows that already state it (A393: the leak check tests them; reaching one is a check, not a finding)

- A77

## States the negation — rows that already state the thesis's negation (A395: reaching one makes a REFUTED a check)

- none

## The thesis against each held-out answer (A395) — an answer the thesis ENTAILS makes PROVED unreachable

- Vajirabuddhi first citta: entails — the thesis is the answer (a known-answer control; its own answer is exempt, ruled 2026-10-13)


## Predicted outcome

- **The session predicts:** PROVED
- **The founder predicts:** (no prediction given)

## Predictions

1. T1 PROVED from C and A3; constructive; Unused none; each premise needed (needs_ models); a model with at least one citta
2. T0 (A3 alone: proximity is irreflexive) PROVED; the leak check reads 'no' for T0 — the case that must not be reached
3. leak-check: TRIVIAL for T1 on the run's own known answer; on states_a77 (a negated existential, one contradiction step) STATED or 'no' — either reported
4. VERDICT PASS (confounded): the answer is one step from C's predecessor clause as the Visuddhimagga (XVII) states it in its own voice
5. GRADE NOT STRONG (TRIVIAL; plumbing). The instrument's changed parts run clean: the new registration fields, the anchored harness, the drift guard (c_predecessor, a3_successor identical to the earlier runs'), the index counting a known-answer PASS

## Pass criteria for the instrument

- the model has at least one citta
- T0 reads 'no' in the leak check
