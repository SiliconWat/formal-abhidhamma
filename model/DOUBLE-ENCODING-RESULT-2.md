# DOUBLE ENCODING, round 2 — the result, 2026-10-21

*Written after the scoring, never edited; a correction is a new file. Pre-registration: `DOUBLE-ENCODING-PREREG-2.md` (pushed at tip 972502). Draw: `DOUBLE-ENCODING-DRAW-2.md` (block 972508).*

**VERDICT: FAIL — 2 of 25 AGREE; the threshold was 20 of 25.** Round 1 was 4 of 25.

## Method as run (as pre-registered)
25 blind `lean` encoders (Sonnet), each given only the row's statement, tier and citation, the repaired `Vocab.lean` (with field meanings) and `RULES.md`; all 25 answers compile. Lean equivalence (`de_tools.py compare`, stock plus four extra tactics): **1 of 25 proved** (A40, by `Iff.rfl`). The other 24 went to two independent `refuter` adjudicators, each given all 25 pairs in a different shuffled order with randomized labels and our definitions stripped of names and docstrings (`model/de_packet.py` builds the packets). Unblinded, **the two adjudicators gave the same verdict on every one of the 25 pairs.** AGREE needs both to find the pair equivalent.

## Every pair (verdicts relative to OUR definition)
| Row | Lean | Adjudicator 1 | Adjudicator 2 | AGREE |
|---|---|---|---|---|
| A3 | — | OURS STRONGER | OURS STRONGER | no |
| A37 | — | DIFFERENT | DIFFERENT | no |
| A40 | Iff.rfl (Lean) | EQUIVALENT | EQUIVALENT | **AGREE** |
| A43 | — | DIFFERENT | DIFFERENT | no |
| A44 | — | DIFFERENT | DIFFERENT | no |
| A45 | — | DIFFERENT | DIFFERENT | no |
| A47 | — | OURS STRONGER | OURS STRONGER | no |
| A64 | — | DIFFERENT | DIFFERENT | no |
| A67 | — | DIFFERENT | DIFFERENT | no |
| A77 | — | OURS STRONGER | OURS STRONGER | no |
| A78 | — | OURS STRONGER | OURS STRONGER | no |
| A79 | — | DIFFERENT | DIFFERENT | no |
| A80 | — | DIFFERENT | DIFFERENT | no |
| A81 | — | DIFFERENT | DIFFERENT | no |
| A84 | — | DIFFERENT | DIFFERENT | no |
| A88 | — | ENCODER STRONGER | ENCODER STRONGER | no |
| A90 | — | DIFFERENT | DIFFERENT | no |
| A95 | — | EQUIVALENT | EQUIVALENT | **AGREE** |
| A99 | — | DIFFERENT | DIFFERENT | no |
| A100 | — | DIFFERENT | DIFFERENT | no |
| A106 | — | DIFFERENT | DIFFERENT | no |
| A109 | — | DIFFERENT | DIFFERENT | no |
| A111 | — | DIFFERENT | DIFFERENT | no |
| C | — | DIFFERENT | DIFFERENT | no |
| K | — | DIFFERENT | DIFFERENT | no |
AGREE: A40, A95. OURS STRONGER (4): A3, A47, A77, A78. ENCODER STRONGER (1): A88. DIFFERENT (18): A37, A43, A44, A45, A64, A67, A79, A80, A81, A84, A90, A99, A100, A106, A109, A111, C, K.

## What the disagreements are
The pre-registration named the risk beforehand: the Cond rows not repaired in round 1 share the scope-only form. That happened, and more:
1. **Scope or obligation, again** (A79, A81, A84, A90, A99, A100, C): one side states what a present fact must be, the other that the facts must exist, or each adds a different half. A84 and C are the cleanest: each side constrains a different PART of the world (the condition facts vs the stream's `prox`).
2. **A kind or time test one side has and the other lacks** (A79, A88, A99, A100: a nama/rupa test; a clock test vs a `prox`/`momOf` test).
3. **Counts versus structure in the process rows** (A43, A44, A109, A45): an exact javana count against a shape (preparatory javanas, then absorption); exact lists against "starts with"; the tail after the path citta read as the fruition run.
4. **A genuine vocabulary gap again:** the sense-door numbering (A80: 0–4 against 1–5) is not stated in `Vocab.lean`; `Occ` has no well-formedness axiom (rise < fall), which flipped A100.
5. **Strength, ours stronger by a clause the row states** (A3 the iff and the clock-free statement; A47 the clock gap; A77 the beginningless part; A78 where the encoder's list is true of every world because `Condition` is a closed type).
6. **Different parts of the row** (A37, A111, A106, K, A67, A64, A109): each side took the half the other left out.

## What this shows, and does not
- Round 2 fixed nothing it was not asked to: the 25 were a fresh draw, and the repairs of round 1 did not generalize to rows they did not touch. The repair-then-redraw loop treats a symptom row by row; two blind Lean encoders over a 400-line vocabulary will rarely produce LOGICALLY EQUIVALENT definitions for a multi-clause row, because equivalence is a stricter relation than "both cover the row's words".
- The adjudicators' perfect concordance in both rounds says the instrument is reliable; the low rate is a property of the test's strictness, not of the readers.
- ⚠️ **It does not show that our encoding is wrong**: in 5 of 25, ours is the stronger by a clause the row states. It shows that a second honest reader, given the row alone, reaches a different formalization of it in 23 of 25 cases.

## For the founder (nothing decided here)
The pre-registered rule says Protocol 2 does not freeze below 20 of 25. Two readings of what to do:
(a) **Keep the bar and keep repairing:** each failing pair resolved row by row, then a round 3. Round 1 and 2 give no evidence that this converges.
(b) **Amend the test (a new protocol file, never an edit):** keep the instrument but change what is scored — e.g. per-pair agreement graded on the shared clauses (the intersection) with a count of clauses each side adds; or require that every pair's DISAGREEMENT be resolved and recorded, with the freeze gated on the resolution log rather than a rate. Either is an amendment the founder must rule, made before another draw, and openly stated as a change after two failures.
