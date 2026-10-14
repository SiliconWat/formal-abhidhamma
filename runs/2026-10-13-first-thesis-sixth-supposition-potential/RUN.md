# RUN — the founder's sixth supposition, "all beings have the potential to become a buddha or arahant"  ·  PREREG pushed 2026-10-14T04:03:33Z + OTS

- **Kind:** proof run — the last supposition of the founder's first thesis (2026-10-13: *"thus, all beings have the
  potential to become a buddha or arahant"*), restated and approved (*"approve"*): "Every being can still become an arahant:
  no being stays incapable of the path in every existence from some point on." Suppositions 1–5 are the run
  [`2026-10-13-first-thesis-past-lives-and-hell`](../2026-10-13-first-thesis-past-lives-and-hell/RUN.md).
- **Premises:** A124 (Vibhaṅga §826–827), A125 (AN 7.15) · **held out:** Kv 19.7 §847–852 · **states the thesis:** none ·
  **Lean:** `Potential.lean`, `run.sh`
- **Before registration:** the "thus" does not follow (a hell life is a necessary condition everyone has met; meeting a
  necessary condition does not make the goal possible), so 6 got its own premises. A vetting refuter (F1–F14, applied or
  declared: the answer runs from a FIXED existence to a strictly later one; a possible history keeps its past; both readings
  of "stays" registered; the thesis-to-answer comparison dropped; the Kv 19.7, A124 and A125 rows revised) and two blind
  back-translations.
- **After:** `run.sh` (9 registered pieces verbatim, comments stripped; T6 and T6W clause for clause; two breaks on T6L
  alone); `kala/THEOREMS.md`; `leak-check.py` ("no"); the run refuter (a different agent from the vetting one); CI.

- ⚠️ **Declared after grading (the post-A395 control's vetting refuter, F2, 2026-10-13):** the blind back-translations here were given the WHOLE statement file and told to ignore its comments and docstrings, which carried the thesis — blind by instruction, not by construction. Their findings came from unfolding the code (an unneeded premise, a loophole, a vacuous case), but the rubric's "only the Lean statement" was not met; the skill now hands the reader a stripped copy.
## OUTCOME: INDEPENDENT
## GRADE: NOT STRONG
## UNREACHABLE: PROVED — with A124 §826 the thesis ENTAILS the held-out Kv 19.7 answer (proved in the re-run, `the_thesis_entails_the_answer`), so PROVED could not be reached under the hold-out; a PROVED prediction is scored UNREACHABLE, never a miss (A395, founder 2026-10-13: "approve"; marked after grading)

| Theorem | Outcome | Uses (read from Lean) | Logic | Refuter | Survivor |
|---|---|---|---|---|---|
| `t6_not_forced` · `t6_admitted` | INDEPENDENT | **A124** | constructive | NARROWS (F3, F4, F5, F8) | From A124 alone a being that stays incapable — rootless, or faithless, in every existence — is not excluded, and no Piṭaka text found excludes it |
| `t6w_not_forced` · `t6w_admitted` | INDEPENDENT | **A124** | constructive | NARROWS (F3) | The SAME fact as T6: every witness has one history, so CAN and WILL coincide in every model (the modal apparatus carries no weight here) |
| `t6l_fails_for_the_once_sunk_on_the_literal_reading` | PROVED | **A124 A125** · `h124i`, `h125`; Unused none | constructive | CHECK (F6) | On the literal reading of AN 7.15, the once-sunk cannot become capable — which the AN commentary on AN 1.310 already says in its own voice ("neither heaven nor path") |
| `t6b_the_answer_is_not_enough` | PROVED (a model) | **A124** | constructive | NARROWS (F11) | Kv 19.7 speaks to the fixed wrong view (one obstruction of four, the heinous deeds shared ground) and is silent on the result-obstruction and on faith: a being that leaves its wrong view may stay rootless |
| `model_t6l_hypotheses` · `needs_a124_incapable` · `needs_a125_literal` | models | — | constructive | — | T6L's hypotheses are satisfiable, and each is needed |

⭐ **What the run found, in one sentence:** the founder's "thus" does not follow, and the texts do not settle the sixth
supposition — from Vibhaṅga §826–827 a being incapable in every existence is not excluded and no Piṭaka text found excludes
it, while the commentaries DIVIDE: the DN commentary and Visuddhimagga XIII send every being upward at a world's end, the
Kathāvatthu commentary, the MN commentary and four ṭīkās deny absolute fixity, and the AN commentary on AN 1.310, in its own
voice, gives the fixed-view holder "neither heaven nor path".

## The rubric, item by item

1. **Axioms verified** — ✗ in part. A124 and A125 are verified, but the A124 pair is a HYBRID no single layer asserts:
   `a124_incapable` is the commentaries' disjunctive reading, `a124_capable` is §827 as written, and the Puggalapaññatti
   commentary's capable is "none of SEVEN" (`abh03a.att.xml:873–877`) — row noted.
2. **Nothing load-bearing by construction** — ✗. Every witness has ONE history, so the countermodel for CAN is a
   deterministic being, not an unconstrained future (F3). At the manual layer a rootless being can do three-rooted
   wholesome kamma (Saṅgaha ch. 4 §40 excludes only the functional and absorption javanas; the Vibhāvinī `abh07t.nrf.xml:5117`)
   and three-rooted kamma gives a three-rooted rebirth (§71 `:1837`): a World WITH kamma would exclude the rootless-forever
   witness for CAN (F4). A FAITHLESS-forever witness is not touched by that, and no text was searched for faith arising in
   every being (F8, NOT RUN). T6B rests on the same free result-obstruction (F11). And in the other direction, REFUTED was
   unreachable by construction (F7, OQ-1).
3. **A model** — ✓ (`model_t6l_hypotheses`, an existence AT `r0`).
4. **Breaks** — ✓ two, each on T6L alone; necessity proven (`needs_a124_incapable`, `needs_a125_literal`).
5. **Axioms read from Lean** — ✓; Unused none.
6. **Logic** — ✓ every theorem constructive.
7. **No held-out answer as a premise** — ✓ "no" — and by argument for EVERY premise set, since the answer needs a
   strictly later existence and no premise asserts one. ⚠️ Aperture: the leak check reads theorem binders, so it saw ONE pair
   (T6L); the claims and the models have none (F16).
8. **No unrepaired encoding defect** — ✗. A possible history from an existence's start keeps that WHOLE existence,
   though capacity can change within a birth (DN 2 §253: the Dhamma-eye would have arisen on that very seat had the king not
   killed his father) — F1; `agree` has no downward closure, so "can" could be non-monotone (F2); the A124 hybrid (F9).
   None changes an outcome; each is declared here.
9. **Layer** — T6L: commentarial (the identification of the once-sunk with the fixed wrong view). T6/T6W: INDEPENDENT at
   the Piṭaka layer, by silence; the commentarial layer divided.

## Predictions, scored by the main session

1. **T6 (CAN) INDEPENDENT — ✅ HIT** on the logic; the layer clause NARROWED: DN 1's "mostly" is closed by its own
   commentary (the exceptions go HIGHER, `s0101a.att.xml:2201`) and reopened by its ṭīkā (not all beings of the states of
   loss go up, `s0101t.tik.xml:1945`); "admitted at the Piṭaka layer" holds by silence only.
2. **T6W INDEPENDENT the same way — ✅ HIT**, and the same fact as 1 (one-history witnesses).
3. **T6L PROVED, constructive, commentarial — ✅ HIT**, a CHECK of the AN commentary on AN 1.310.
4. **T6B PROVED by a model — ✅ HIT.**
5. **leak-check: every row "no" — ✅ HIT** on the one row the instrument can see (F16).
6. **NOT STRONG — ✅ HIT**, under-predicted (items 1, 2 in both directions, 8).
- **Calibration:** the session predicted INDEPENDENT — HIT. The founder predicted PROVED — MISS on these premises.

## What the instruments caught in this run

- **The vetting refuter** (before registration): an answer too weak (met by the current existence), a type that left
  "possible history" unconstrained, a misattributed MN 117, a mislabeled reading of A124, and the two readings of "stays".
- **The run refuter**: the one-history witnesses (CAN = WILL), the literal reading held in a commentary's own voice, a
  within-life change of capacity, the hybrid A124, the leak check's one-pair aperture, and that `t6_admitted` proves one
  instance where the witness satisfies all. The registered statements' harness holes (namespaces, notation, the admitting
  models unchecked) are carried from the first run, still open.
- **CI** caught the registration commit's index STALE: `prereg.py`'s rebase retry, on its first use, left the index citing
  the pre-rebase commit; fixed to regenerate it (`57536c9`), not yet seen on a live race.

## OPEN QUESTION for the founder → roadmap A394 (the run refuter's; the recommendation is the session's)

- **OQ-1** AN 7.15 asserts that the once-sunk person is "found in the world" (*santo saṃvijjamānā lokasmiṃ*). With the
  literal reading — which the AN commentary holds in its own voice — and A124, the texts would assert a being that stays
  incapable forever: the sixth supposition REFUTED at that layer. The ratified sort rule says *"The Puggalapaññatti's persons
  are concepts: they enter as definitions, never as laws"* (ANSWERS.md). Does it also bar a SUTTA's existence clause from
  entering as a premise? If it does, REFUTED is unreachable by construction for any thesis about every being whose
  counter-witness is such a person. *(recommend: no — the rule bars a person-TYPE from acting as a law; a sutta's assertion
  that such persons EXIST is an assertion and may enter as a premise. The reading of its scope ("stays" in this existence, or
  in every one) stays a fork, encoded both ways, and the restricted reading is the held-out answer.)*
