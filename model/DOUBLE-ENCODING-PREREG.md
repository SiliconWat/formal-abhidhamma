# DOUBLE ENCODING — pre-registration (Protocol 1 amendment 1, R2)

*Written and PUSHED before the draw. ⛔ Never edited after the push; a correction is a new file. Question: **if a second encoder who has never seen `model/` is given a row's words and only the encoding's TYPES, does it write the same statement?** One encoder cannot measure its own reliability; back-translation checks a definition against its row, never against a second honest encoding.*

## The pool (65 rows)
Every row with at least one definition in the model files, **minus** (a) the rows whose definitions are typed TABLES or counts read from the Saṅgaha (A105, A107, A27, A28, A29, A31, A32, A33, A34, A35, A38, A60, A62, A65, A71, A72, A73, A74) and (b) the rows that are bare stipulations of a number or list (A10, A104, A11, A126, A129, A14, A16, A17, A19, A20, A22, A23, A26, A48, A49, A50, A70, A76, A8, A9), where "agreement" would measure copying. Pool, in order:

`A1 A3 A4 A5 A6 A7 A13 A15 A24 A36 A37 A39 A40 A41 A42 A43 A44 A45 A46 A47 A56 A57 A58 A63 A64 A66 A67 A68 A77 A78 A79 A80 A81 A82 A83 A84 A87 A88 A89 A90 A91 A92 A93 A94 A95 A96 A97 A98 A99 A100 A101 A106 A109 A111 A112 A114 A115 A116 A117 A118 A120 A121 A122 C K`

## The draw
- **The seed is a Bitcoin block that did not exist when this file was pushed:** the block at height **972410** (the tip was 972407 at registration, 2026-10-20). Its hash `H` is read from two public explorers (`mempool.space`, `blockstream.info`); if they disagree, the draw waits.
- **Rule:** sort the pool by `SHA-256( H + ":" + row_id )` (hex, ascending; `row_id` as written above) and take the first **25**. The script is `model/double-encoding.py`, committed with this file.
- Nobody can know the sample before the block is mined, and no row can be added to or dropped from the pool after.

## The encoder
A fresh `lean` agent (no memory, no CLAUDE.md, no doctrine), one per row so that no row's encoding sees another's. It is given: the row's STATEMENT, tier and citation from `kala/AXIOMS.md` (the Lean column removed), `model/Vocab.lean` (sha256 `7bf52b33aff015571535d0438db1495941df384da070c6e7a782ca784b49a79b`: the types and nothing else), and the encoding rules (Protocol 1 §7.1: literal first, a row's own cited lines may supply the members of a list it names, no scope another text supplies). It writes ONE definition over the vocabulary. ⛔ It is never shown `model/*.lean`, `model/blind/`, `TABLE.md`, `BLIND.md` or any row's definition; the folder it works in holds Vocab.lean and the row.

## Scoring
Per pair (the encoder's definition against ours): **AGREE** if Lean proves them equivalent for all worlds (`Iff.rfl`, `simp`, `omega`, or a short proof), or, where Lean cannot, if two independent adjudicators (`refuter`, no memory of which is which) find them equivalent. Otherwise one of: **ENCODER STRONGER · ENCODER WEAKER · DIFFERENT · NOT ENCODABLE** over the vocabulary, each with a counterexample world where one holds and the other does not.
- **Threshold, fixed now: at least 20 of 25 AGREE (80%).** Below it, the encoding is reported unreliable and Protocol 2 does not freeze until the disagreements are repaired and a fresh sample is drawn.
- **Every pair is reported, whatever its outcome**, with the adjudication; a disagreement is resolved as (i) our definition is wrong → repaired, (ii) the encoder's is wrong → kept, (iii) the row is ambiguous → DECLARED as a freedom.
- ⚠️ What agreement means: two encoders reading the same words agree. It shows the encoding is not idiosyncratic. It does not show the words say what the Pāli says (the refuter checked that) or that the row is the whole text.
