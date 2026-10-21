# DOUBLE ENCODING, round 2 — pre-registration (after `DOUBLE-ENCODING-RESULT.md`: 4 of 25, FAIL)

*Written and PUSHED before the draw. ⛔ Never edited after the push; a correction is a new file. Everything in `DOUBLE-ENCODING-PREREG.md` stands (the encoder, the scoring, the threshold of 20 of 25) except what is changed here.*

## What changed since round 1
- `Vocab.lean` now carries the field meanings (the docstrings), with row ids and provenance removed; the `holds` numbers are stated as indices into `occs`. Round 1's encoders were not told.
- The 21 non-agreeing rows were resolved (`DOUBLE-ENCODING-RESOLUTIONS.md`): repairs to ours, and the founder's rulings on A4, A42, A116, A6, A112 (2026-10-21, "approve all").
- The adjudication packet (round 1) showed our definitions with names and docstrings stripped; the same is done again.

## The pool (40 rows)
Round 1's pool of 65 rows **minus the 25 rows already drawn**. The drawn rows were repaired in response to what the round-1 encoders wrote, so they are no longer an independent test: a repaired row cannot also be a clean sample. Nothing else is excluded. In order:

`A13 A45 A40 A93 A37 A15 A41 A115 A3 A56 A78 A109 A97 A81 A82 A63 A44 A88 A58 A80 C A106 A118 A77 A84 K A117 A47 A67 A43 A111 A64 A24 A95 A99 A83 A90 A79 A122 A100`

⚠️ **Expected risk, stated beforehand:** the Cond rows A79–A100 not repaired in this round (root, object, predominance, absence …) share the scope-only form (`facts_between_occurrences`) that round 1's adjudicators called soundness-versus-completeness for A96/A91/A101/A94/A92. Only A95 (with A94) and the rows named in the resolutions were changed. If the class fails again, that is the finding, not a surprise.

## The draw
- The seed is the Bitcoin block at height **972508** (the tip was 972502 at registration). Its hash `H` is read from two public explorers (`mempool.space`, `blockstream.info`); if they disagree, the draw waits.
- Rule: sort the pool by `SHA-256( H + ":" + row_id )` (hex, ascending) and take the first **25**: `python3 model/double-encoding.py --prereg DOUBLE-ENCODING-PREREG-2.md --height 972508`.
- Encoders: a fresh `lean` agent per row, never shown `model/`; given the row's statement, tier and citation, `Vocab.lean` and `RULES.md` — nothing else.
- Scoring: Lean equivalence where it proves (`de_tools.py compare`); otherwise two independent adjudicators, each given all 25 pairs in a different shuffled order with randomized labels and our definitions stripped of names, docstrings and citations; **AGREE only if both find the pair equivalent**. Threshold: **at least 20 of 25 AGREE**. Every pair is reported.
