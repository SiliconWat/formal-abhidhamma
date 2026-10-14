# RUN — the post-A395 known-answer control: the Vajirabuddhi-ṭīkā's "no first citta"  ·  PREREG pushed 2026-10-14T06:03:08Z + OTS

- **Kind:** known-answer control (KNOWN ANSWER: "Vajirabuddhi first citta"), the check the `/prove` skill requires after any
  change to the rubric, the instrument or AXIOMS.md — today A393, A394, A395 (and its control exemption) and rows C, A2, A58,
  A77, A124, A125. Ordered by the founder: *"run it before my next thesis"*.
- **Premises:** C, A3 · **held out:** "Vajirabuddhi first citta" · **states the thesis:** A77 · **states the negation:** none ·
  **Lean:** `Control.lean`, `run.sh`
- **Before registration:** a vetting refuter (F1–F13): F1 ruled by the founder (*"do all per your recommendation"* — a control's
  own answer is exempt from A395's PROVED refusal, `PROVE-RUBRIC.md`); C's headline narrowed to citta and Vism XVII added; A77's
  *anādikaṃ* marked derived at its place; the Vajirabuddhi row's Tests narrowed to the Piṭaka layer; a non-empty model and a
  negative case (T0) added. One blind back-translation from a STRIPPED copy (no comments, no docstrings): both theorems read as
  registered, each premise needed, T1's conclusion EQUAL to the answer's body and classically equivalent to `states_a77`'s, T0
  provable from A3 alone.
- **After:** `run.sh` (7 pieces verbatim, anchored; three breaks fail, each on its target alone); `kala/THEOREMS.md`; the leak
  check; the run refuter (not the vetting agent); CI.

## OUTCOME: PROVED
## GRADE: NOT STRONG
## VERDICT: PASS (confounded) — plumbing at the COMMENTARIAL layer: the answer is one step from C's predecessor clause as Buddhaghosa states it in his own voice (Vism XVII, `e0102n.mul.xml:3725`), and *anantaracitta* already means "the citta just before"

| Theorem | Outcome | Uses (read from Lean) | Logic | Refuter | Survivor |
|---|---|---|---|---|---|
| `t1_no_first_citta` | PROVED | **A3 C** · `hC`, `h3`; Unused none | constructive (no axioms) | NARROWS (2, 8) | From C as Vism XVII states it and A3, every citta of one stream has an earlier one — the Vajirabuddhi's first ground (the four conditions), not its second (the "new being" reductio); the same ∀∃ form the ṭīkā states at `vin06t.nrf.xml:6961` (*cittapubbikā hi cittappavatti*) |
| `t0_proximity_is_irreflexive` | PROVED | **A3** · `h3` | constructive | CONTRAST (4) | the leak check's negative case |
| `model_t1_hypotheses` | a model | **A3 C** | constructive | — | T1's hypotheses hold together with at least one citta |
| `needs_c_predecessor` · `needs_a3_successor` | two models | — | constructive | — | each of T1's premises is needed |

**The leak check, verbatim** (CI fails only on LEAK or ERROR, so the lines are kept here):

```
TRIVIAL   t1_no_first_citta (its premises) → answer_vajirabuddhi_first_citta (Vajirabuddhi first citta): the run's own known answer
STATED    t1_no_first_citta (its premises) → states_a77 (A77): the premises reach a row that already states the thesis
no        t0_proximity_is_irreflexive (its premises) ↛ answer_vajirabuddhi_first_citta
no        t0_proximity_is_irreflexive (its premises) ↛ states_a77
```

⭐ **What the control showed, in one sentence:** the instrument's ACCEPTANCE side survived today's changes — registration with
the new fields and the ruled control exemption, TRIVIAL on a run's own answer, the first STATED on a registered run, the "no"
parse, the anchored harness and the drift guard on a clean input — while its REFUSAL and DETECTION side rests on build-time
plants that were never registered.

## The rubric, item by item

1. **Axioms verified** — ✓ C (now with Vism XVII), A3. ⚠️ A3's VERIFIED range `:85–89` leaves out the indeterminate antecedents
   at `:93` (bhavaṅga, death → rebirth), the step T1 takes at every rebirth — a citation to widen.
2. **Nothing load-bearing by construction** — ✗. That the predecessor is a citta of the SAME stream is supplied by the type
   (declared; A389 OQ-D: a declaration does not rescue it); and `states_a77` equals the answer on the integers (declared).
3. **A model** — ✓ with a citta (the PREREG's pass criterion).
4. **Breaks** — ✓ three, each on its target alone. No break that should still compile was planted (e.g. C dropped for T0).
5. **Axioms read from Lean** — ✓; Unused none.
6. **Logic** — ✓ constructive.
7. **No held-out answer as a premise** — the run's own answer reached in one step: TRIVIAL by design (A395's exemption).
8. **No unrepaired encoding defect** — ✗ in part: the docstrings first rendered *anamatagge* as "beginningless" (the ontic gloss
   A2 was excluded for) — corrected after registration (comments only); C's citation now names Vism XVII.
9. **Layer** — **commentarial**: C enters as Vism XVII states it; the Piṭaka route (the join, `abh03m7.mul.xml:1201` with
   `:1153–1169` and Dhs §1191) is NOT a binder here, so nothing is tested at the Piṭaka layer the ANSWERS row reserves — and the
   row's REPRODUCED (the first thesis's T3) is only duplicated.

## Predictions and pass criteria, scored by the main session

1. **T1 PROVED, constructive, Unused none, each premise needed, a model with a citta — ✅ HIT.**
2. **T0 PROVED; the leak check "no" for T0 — ✅ HIT** (a test of false positives and parsing, not of detection: the
   `needs_c_predecessor` world falsifies both definitions, so any sound check says "no").
3. **TRIVIAL for T1; STATED or "no" on A77 — ✅ HIT**, but its second half could not miss (a STATED path degraded to "no" would
   also have hit).
4. **VERDICT PASS (confounded) — ✅ HIT**, at the commentarial layer.
5. **NOT STRONG; the changed parts run clean — PARTIAL:** the acceptance side ran clean; the refusal and detection paths were not
   exercised (below).
- **Pass criteria:** a model with a citta — ✅; T0 reads "no" — ✅.
- **Calibration:** the session's PROVED — HIT (an outcome fixed by design: see OQ-1). No founder prediction (a control).

## What the instruments caught in this run

- **The run refuter:** the instrument test covers the ACCEPTANCE side only. NOT exercised on a registered run: STATED NEGATION,
  NONE NEAR, every `prereg.py` refusal (a loose held-out entry, a non-control's PROVED of an entailed answer, a premise in
  `--states-thesis`), the index's UNREACHABLE scoring (exercised only by the sixth-supposition runs), the anchored check and the
  drift guard REJECTING a planted change, an isolated break that should still compile — each was plant-tested at build time
  (commits `8dbf04f`, `d66058a`, the anchored-harness plants) but never as a registered run. The layer is commentarial, not
  Piṭaka. The harness cannot see an added `notation`, `instance` or `axiom` that changes what a verbatim statement means; nothing
  ties T1's conclusion to the answer's definition (TRIVIAL reads the definitions).
- **The vetting refuter (before registration):** the control exemption committed before the founder's ruling (now ruled), and
  the blind back-translations of the whole day given the whole file (now stripped).

## OPEN QUESTIONS for the founder → roadmap A399 (the run refuter's; the recommendations are the session's)

- **OQ-1** The ruled exemption says a control "is graded by its VERDICT", yet `runs-index.py` still counts the control's predicted
  outcome in the session's calibration — three of the session's seven hits are controls whose outcome is fixed by design.
  *(recommend: known-answer controls leave the outcome calibration; the index already reports them by VERDICT.)*
- **OQ-2** The exemption keys on `--control-known`, which nothing checks. *(recommend: `prereg.py` refuses a `--control-known` key
  that is not an ANSWERS key also listed in `--held-out`.)*
- **OQ-3** The refusal and detection side has no registered evidence. *(recommend: a standing instrument SELF-TEST — a script that
  plants each refusal and detection case (every `prereg.py` refusal, LEAK, STATED NEGATION, NONE NEAR, the anchored check, the
  drift guard, a BLIND break) and must see each fire — run by CI on every push, so these paths are a property, not a memory of
  build-time plants.)*
