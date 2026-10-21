# DOUBLE ENCODING — the result (R2), 2026-10-21

*Written after the scoring, never edited; a correction is a new file. Pre-registration: `DOUBLE-ENCODING-PREREG.md` (pushed before the block existed). Draw: `DOUBLE-ENCODING-DRAW.md` (block 972410).*

**VERDICT: FAIL — 4 of 25 AGREE; the threshold was 20 of 25.** Per the pre-registration the encoding is reported **unreliable**, and Protocol 2 does not freeze until the disagreements are repaired and a fresh sample is drawn.

## Method as run
25 blind `lean` encoders (Sonnet), one per row, each given only that row's statement/tier/citation, `Vocab.lean` and `RULES.md`; all 25 answers compile. Lean equivalence (`de_tools.py compare`, stock tactics plus four added during scoring): **0 of 25 proved**. The pre-registered fall-back then applied: two independent `refuter` adjudicators, each given all 25 pairs in a different shuffled order with X/Y labels randomized and our definitions stripped of names, docstrings and citations (packets are scratch, not committed). Unblinded afterwards, **the two adjudicators gave the same verdict on every one of the 25 pairs.**

## Every pair (verdicts relative to OUR definition)
| Row | Adjudicator 1 | Adjudicator 2 | AGREE |
|---|---|---|---|
| A1 | EQUIVALENT | EQUIVALENT | **AGREE** |
| A4 | DIFFERENT | DIFFERENT | no |
| A5 | DIFFERENT | DIFFERENT | no |
| A6 | DIFFERENT | DIFFERENT | no |
| A7 | DIFFERENT | DIFFERENT | no |
| A36 | OURS STRONGER | OURS STRONGER | no |
| A39 | ENCODER STRONGER | ENCODER STRONGER | no |
| A42 | DIFFERENT | DIFFERENT | no |
| A46 | ENCODER STRONGER | ENCODER STRONGER | no |
| A57 | OURS STRONGER | OURS STRONGER | no |
| A66 | OURS STRONGER | OURS STRONGER | no |
| A68 | OURS STRONGER | OURS STRONGER | no |
| A87 | DIFFERENT | DIFFERENT | no |
| A89 | DIFFERENT | DIFFERENT | no |
| A91 | DIFFERENT | DIFFERENT | no |
| A92 | DIFFERENT | DIFFERENT | no |
| A94 | DIFFERENT | DIFFERENT | no |
| A96 | DIFFERENT | DIFFERENT | no |
| A98 | EQUIVALENT | EQUIVALENT | **AGREE** |
| A101 | DIFFERENT | DIFFERENT | no |
| A112 | DIFFERENT | DIFFERENT | no |
| A114 | EQUIVALENT | EQUIVALENT | **AGREE** |
| A116 | DIFFERENT | DIFFERENT | no |
| A120 | OURS STRONGER | OURS STRONGER | no |
| A121 | EQUIVALENT | EQUIVALENT | **AGREE** |
AGREE: A1, A98, A114, A121. OURS STRONGER (5): A36, A57, A66, A68, A120. ENCODER STRONGER (2): A39, A46. DIFFERENT (14): A4, A5, A6, A7, A42, A87, A89, A91, A92, A94, A96, A101, A112, A116.

## What the disagreements are (the adjudicators' counterexamples, grouped; each still to be resolved row by row as (i) ours wrong → repair, (ii) encoder wrong → keep, (iii) row ambiguous → declare a freedom)
1. **Vocab leaves the meaning of a field open, and the encoders guessed differently.** The two numbers in `CondW.holds` are read as indices into `occs` by most encoders and as `cit` ids by one (A89); `w.reck`, `w.link`, `Tax.kinds89` appear in our definitions but are projections the encoder never saw. A protocol defect: `Vocab.lean` must carry the field meanings before a re-run. (Touches A89, A94, A96, A101, A91, A92, A98, A87.)
2. **Soundness versus completeness.** Our definitions constrain the facts that are present (each `sampayutta`/`vipāka` fact must be between …); several encoders state the obligation (every such pair HAS a fact), or the reverse (A96, A91, A101, A94). The row's words (*"condition one another"*) lean to the obligation. Probable repair on our side.
3. **Ours is a different clause of the row** (A112: ours is the clock window, the encoder's the proximity/condition facts; A7: ours the reckoning's monotonicity, the encoder's the status "time is a concept"; A5: ours well-formedness of the gaps, the encoder's space-is-not-a-member). The row has two halves and each side took one. Probable repair: ours should state both, or the row be split.
4. **Strength.** Ours stronger by a clause the row does state (A57 five javanas exactly vs ≤ 5; A66 the 21 kinds; A68; A36 the converse; A120 mind-born at arising only) — the encoder dropped it; the encoder stronger by plane scope (A39, A46) — ours silent on `lokuttara` / on non-javana steps.
5. **Genuine readings the adjudicators flagged**: A4 (phase-relative 16/17 steps vs one rule — ours and the encoder's contradict for matter born at `stand`/`dissolve`), A42 (an upper bound on `past`; `javana > 0` in the "great" range), A116 (strict vs non-strict at the cessation end; needs `arise ≤ stand ≤ dissolve`), A6 (faculty matter's `bound`), A87.

## What this does and does not show
- It is the pre-registered test doing its job: an encoding Protocol 2 would have frozen was NOT reproducible by a second reader from the row alone in 21 of 25 cases. ⚠️ **It is not a measure of the Pāli** and not of whether our reading is wrong; where the encoder is weaker (A57, A66) ours may be right.
- The adjudicators' agreement on all 25 is reassuring about the instrument, not about the encoding.
- Four equivalences (a trivial De Morgan, two atthi/overlap, one breath) are what an unambiguous row yields; the failures concentrate where a row says two things, or where the vocabulary's meaning was unstated.
- The tactics: stock `simp` could not prove even A1 (De Morgan through an un-unfolded definition); four more tactics added in `de_tools.py` proved nothing more. Equivalent pairs were therefore settled by the adjudicators.

## Next (none done yet)
Repair order: (1) document `Vocab.lean`'s field meanings (and put `w.reck`, `w.link`, `kinds89` in it); (2) resolve each of the 21 non-agreeing pairs by the rule above; (3) re-draw a fresh sample of 25 from the rebuilt pool with a NEW pre-registration pushed before a new future block; (4) only then Protocol 2. The founder's call: whether to repair-then-redraw as written, or to change the protocol (an amendment — a new file).
