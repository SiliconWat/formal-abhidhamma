# RUN — the founder's sixth supposition, re-run with AN 7.15's existence clause (A394)  ·  PREREG pushed 2026-10-14T04:39:24Z + OTS

- **Kind:** proof run — the founder's sixth supposition (*"thus, all beings have the potential to become a buddha or
  arahant"*, restated and approved: "Every being can still become an arahant: no being stays incapable of the path in every
  existence from some point on"), re-run because the founder ruled A394 (*"1 and 2: do per your recommendation"*): a sutta's
  assertion that such persons EXIST may enter as a premise. The first run is
  [`2026-10-13-first-thesis-sixth-supposition-potential`](../2026-10-13-first-thesis-sixth-supposition-potential/RUN.md).
- **Premises:** A124 (Vibhaṅga §826–827), A125 (AN 7.15: the existence clause, and the literal scope as a reading) ·
  **held out:** Kv 19.7 §847–852 · **states the thesis:** none · **Lean:** `World.lean`, `run.sh`
- **Before registration:** one blind back-translation (matched; it supplied the two-history admitting model).
- **After:** `run.sh` (14 registered pieces — now ANCHORED: each must EQUAL the source piece of the same name; T6O clause
  for clause; five breaks, each on its target alone); `kala/THEOREMS.md`; `leak-check.py`; the run refuter; CI.

- ⚠️ **Declared after grading (the post-A395 control's vetting refuter, F2, 2026-10-13):** the blind back-translations here were given the WHOLE statement file and told to ignore its comments and docstrings, which carried the thesis — blind by instruction, not by construction. Their findings came from unfolding the code (an unneeded premise, a loophole, a vacuous case), but the rubric's "only the Lean statement" was not met; the skill now hands the reader a stripped copy.
## OUTCOME: REFUTED (on the literal reading — the one Kv 19.7 refutes, held in the AN commentary's own voice; a CHECK) · INDEPENDENT (the scope left open; PROVED unreachable under the hold-out)
## GRADE: NOT STRONG
## UNREACHABLE: PROVED — with A124 §826 the thesis ENTAILS the held-out Kv 19.7 answer (proved in the re-run, `the_thesis_entails_the_answer`), so PROVED could not be reached under the hold-out; a PROVED prediction is scored UNREACHABLE, never a miss (A395, founder 2026-10-13: "approve"; marked after grading)

| Theorem | Outcome | Uses (read from Lean) | Logic | Refuter | Survivor |
|---|---|---|---|---|---|
| `t6r_refuted_on_the_literal_reading` | PROVED (the thesis REFUTED) | **A124 A125** · `h124i`, `h125e`, `h125l`; Unused none | constructive | CHECK (F5, F8) | On the literal reading, the once-sunk person "found in the world" stays sunk and cannot become capable: the thesis fails for a real being. Composed in one step from AN 7.15, the AN commentary's identification and its own-voice "neither heaven nor path" (AN 1.310); stated whole only in the Puggalapaññatti commentary's "they say" |
| `t6x_the_literal_reading_contradicts_the_answer` | PROVED | **A125** · `h125e`, `h125l` | constructive | BY CONSTRUCTION (F3) | The literal reading and Kv 19.7's answer are contraries — as WRITTEN here (the answer is, being by being, the negation of the literal scope): a plumbing check in A392's sense, and only on the view-persists reading of "stays sunk" (F4) |
| `t6o_not_forced` · `t6o_admitted` · `t6o_admitted_with_rebirth` | INDEPENDENT | **A124 A125** | constructive | NARROWS (F1, F2, F6) | With the scope of "stays" left open, the thesis is not settled. ⚠️ The not-forced witness is a world of the LITERAL reading (F2); "not forced on the RESTRICTED reading" is the first run's T6B (a being that leaves its view may stay rootless) |
| `the_thesis_entails_the_answer` | PROVED | **A124** · `h124i`, `h6` | constructive | F1 | ⭐ With A124 §826, the founder's sixth supposition ENTAILS Kv 19.7's answer: it stands on the Kathāvatthu's side of that debate — and no premise set can prove it without restating the held-out answer |
| `model_t6r_hypotheses` · `needs_a124_incapable_all` · `needs_a125_found_in_world` · `needs_a125_literal_all` | models | — | constructive | — | T6R's and T6X's hypotheses are satisfiable, and each is needed |

⭐ **What the run found, in one sentence:** the founder's sixth supposition is on the Kathāvatthu's side of Kv 19.7 — it
entails the Kathāvatthu's conclusion that no worldling is fixed forever (and more: T6B) — so on the literal reading of "once
sunk, stays sunk" that the Kathāvatthu refutes and the AN commentary holds, it is REFUTED (a check of that commentary), and
with that reading set aside the texts leave it open, PROVED being unreachable while the Kathāvatthu's conclusion is held out.

## The rubric, item by item

1. **Axioms verified** — ✗ in part: the A124 hybrid carried (the commentaries' disjunctive §826, §827 as written); the
   existence clause's "entirely black states" encoded as a fixed wrong view, the commentaries' identification (F5).
2. **Nothing load-bearing by construction** — ✗. In both directions: T6X holds by how the answer and the literal reading were
   written (F3); T6O's INDEPENDENT was guaranteed by the hold-out, since the thesis entails the answer (F1). The admitting
   model `leavesInAnotherHistory` used undeclared freedoms (histories that end; a being capable right after a fixed course,
   whose result is the next existence) — repaired by `t6o_admitted_with_rebirth` (a rebirth at every tick in every history:
   rootless at the next, capable after), where CAN holds and WILL fails (F6).
3. **A model** — ✓ (`model_t6r_hypotheses`, now docstring-flagged).
4. **Breaks** — ✓ five, each on its target alone; necessity proven by three `needs_` models.
5. **Axioms read from Lean** — ✓; Unused none.
6. **Logic** — ✓ every theorem constructive (the repair model first pulled in `Classical.choice` through `omega` on a negated
   goal; rewritten as intro-then-`omega`).
7. **No held-out answer as a premise** — ✓ for every registered premise set ("no" for T6R and T6X; T6O's by argument — it is
   invisible to the instrument, F9). `the_thesis_entails_the_answer` takes the THESIS as a hypothesis, not a premise; it is the
   finding that the thesis is at least as strong as the held-out answer (OQ-1). ⚠️ **The leak check reports "no" for it — yet
   Lean PROVES that very entailment:** its one bounded `grind` step cannot see a two-case argument (r = r0 or later, then
   `agree_past`). The rubric declares this threshold ("a deeper restatement passes unseen"); here it is SEEN missing a real
   entailment, so a "no" from the leak check is evidence of nothing deeper than one step.
8. **No unrepaired encoding defect** — ✗: the meaning of "stays sunk" (view persists, the Kathāvatthu commentary's; or lacking
   faith…wisdom, the sutta's own contrast) is undeclared in the PREREG — on the sutta's reading T6R survives, T6X fails (F4);
   `agree_past` still freezes a whole existence (declared).
9. **Layer** — commentarial (the identification of the once-sunk with the fixed wrong view; the disjunctive A124).

## Predictions, scored by the main session

1. **T6R PROVED, constructive, Unused none, commentarial — ✅ HIT.**
2. **T6X PROVED — ✅ HIT**, by construction (F3) and only on the view-persists reading (F4).
3. **T6O INDEPENDENT — ✅ HIT** on the logic; its witness is the literal reading's world (F2), and the hold-out guaranteed it (F1).
4. **leak-check "no" for T6R, T6X, T6O — PARTIAL:** "no" for the two pairs the instrument forms; T6O's by argument only; and
   the instrument also said "no" for an entailment Lean proves (item 7).
5. **NOT STRONG — ✅ HIT**, under-predicted.
- **Calibration:** the session predicted REFUTED — HIT on the literal reading. ⚠️ The founder's PROVED was UNREACHABLE under the
  hold-out (F1): scored *unreachable*, not MISS — and the same holds for both earlier runs of this supposition (OQ-1).

## What the instruments caught in this run

- **The run refuter:** the thesis entails the held-out answer (so PROVED was unreachable, and the founder's prediction could not
  win); T6X by construction; an undeclared meaning of "stays sunk"; a non-textual admitting model (repaired); the leak check's
  aperture (T6O invisible); a substring verbatim check that would have passed an appended field or clause — ANCHORED in all
  three of this thesis's harnesses (each registered piece must EQUAL the source piece of the same name). Planted: an appended
  field and an appended clause are caught. The anchoring's first version cut a term-mode theorem at the NEXT theorem's
  ":= by" and wrongly reported the first run's T6L moved — caught on its first run, fixed (cut at each theorem's own ":=").
- **The MN commentary hedges too:** its "fixed in one existence only" continues "by habituation … MOSTLY no emergence"; the
  Kv 19.7 row now carries it, with the Atthasālinī's definition of "fixed" (the result immediately after the breakup).

## OPEN QUESTIONS for the founder → roadmap A395 (the run refuter's; the recommendations are the session's)

- **OQ-1** A thesis can ENTAIL a held-out answer, given a premise the run must use; PROVED is then unreachable without a leak,
  and a PROVED prediction is scored against an outcome that could not occur. *(recommend: before registration, test whether the
  thesis with its premises entails any held-out answer (a per-instance comparison, so no premise set restates the answer); if
  it does, the PREREG says so and registers the outcome space as REFUTED or INDEPENDENT, and a PROVED prediction is scored
  UNREACHABLE, never MISS.)*
- **OQ-2** Nothing tests whether a REFUTED outcome is already stated in the texts (T6R's refutation is, at the commentarial
  layer). *(recommend: yes — "a check, not a paper" applies to a refutation the texts already state; add `--states-negation`,
  tested like `--states-thesis`.)*
- **OQ-3** A394 says "a SUTTA's assertion", but the Puggalapaññatti uses the same existence formula for its own types (18
  times, e.g. the sick-person simile, `abh03m2.mul.xml:1173`). Under "sort by content, never by book" (A388 OQ1), does A394
  admit them? *(recommend: yes — the existence formula is an assertion wherever it occurs; read A394 as "a text's assertion that
  such persons exist", the scope of each person's description still a fork.)*
