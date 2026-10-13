# ANSWERS — what the texts themselves DERIVE: the test bank, never a premise

*Ruled 2026-10-13 (founder: "approve the answers list"). The one home of the texts' own answers, as `AXIOMS.md` is the
one home of what they assert. Three files, three roles:* **[`AXIOMS.md`](AXIOMS.md) — what the texts ASSERT** ·
**[`THEOREMS.md`](THEOREMS.md) — what we DERIVE** · **this file — what the texts DERIVE**, the known answers a derivation
is checked against.

## Why it is separate

If a conclusion the texts reach by argument is entered as an axiom, a proof run finds it by lookup and tests nothing.
Kept out, each answer is a ready-made control: when the axioms cannot reproduce it, the gap names the premise the
system never states. The precedent is already in this repo — `sangaha/AnswerKey.lean`, the Saṅgaha's own figures
*"entered SEPARATELY from the rules so the rules cannot restate it."*

## The sort rule

- A statement a text **ASSERTS without deriving** anywhere → `AXIOMS.md`.
- A statement the texts reach only by **derivation, computation or refutation** → here.
- **Layers decide the overlap.** An answer may be asserted at a later layer (the commentaries' 17 moments assert what the
  Kathāvatthu argues for); the answer row then tests only the EARLIER layers, and says so.
- What the Kathāvatthu's two sides BOTH accept may be an axiom; the CONCLUSION of a debate stays here.
- ⭐ **Sort by CONTENT, never by BOOK** (A388 OQ1, founder 2026-10-13: "approve all"). The Yamaka's and the Dhātukathā's
  COMPUTED inclusion answers — what follows from the Dhammasaṅgaṇī and Vibhaṅga — are answers; what a book simply ASSERTS
  is an axiom, whichever book it is in (the Saccayamaka's "no arising at a citta's dissolution-moment" is A118).
- The Puggalapaññatti's persons are concepts (*paññatti*): they enter as definitions, never as laws.
- ⛔ IDs are never renumbered. An `AXIOMS.md` row found to be an answer stays where it is, marked **HELD OUT → ANSWERS**,
  and `runs/prereg.py --proof` refuses it as a premise.

## Keys and columns

Keys are the texts' own references (Kv 22.10 §906, a Paṭṭhāna section, a Yamaka chapter) — no invented ID series.
**Result** is filled by proof runs only: **REPRODUCED** (the axioms derive it) · **NEEDS A PREMISE** (named) ·
**CONTRADICTED** (the axioms derive its negation) · **NOT FORMALIZED** · *not run*.

| Key | The texts' answer | Citation (layer) | Status | Tests | Result | Run |
|---|---|---|---|---|---|---|
| Kv 22.10 §906 | **REFUTED: "all dhammas last one mind-moment"** (*ekacittakkhaṇikā sabbe dhammā*, the Pubbaseliyas' and Aparaseliyas' view). Two arguments: the great earth, ocean and Sineru do not stand within one citta; and the eye-base is not co-nascent with eye-consciousness, by Sāriputta's word (MN 28, M i 190) that the eye is intact before consciousness manifests. §907 records the opponent's counter (not momentary, therefore permanent): the Theravādin rejects only "all permanent", the mūla ends on the opponent's line, and the verdict that the counter fails is the COMMENTARY's (KV-a: *taṃ avuttasadisamevāti*) | `abh03m3.mul.xml:13641–13653` (Piṭaka); opponents KV-a `abh03a.att.xml:6353` (commentarial) | VERIFIED | the Piṭaka layer (the 17 moments of A4 assert it at the commentarial layer) | **REPRODUCED on the ALIGNED reading** (a plumbing check, declared confounded; A87 + A98 already state A69 for bases — the run's F3); on the DURATION reading, open on the commentarial line, refuted on the Mūlaṭīkā's. ⚠️ **STATED — tests nothing at the Piṭaka layer on the ALIGNED reading** (A388 OQ2): Vibhaṅga §762 asserts §906's lemma outright (*purejātasmiṃ vatthusmiṃ … uppajjanti*; the commentary's *sahuppattipaṭikkhepo*). The DURATION reading is still a test | [`2026-10-13-kv-22-10-khanika-control`](../runs/2026-10-13-kv-22-10-khanika-control/) |

## Owed — the reclassification audit (founder-approved 2026-10-13)

✅ **A69 done** (HELD OUT, 2026-10-13). Open: **A59**, **A103**. Three `AXIOMS.md` rows record Kathāvatthu REFUTATIONS: **A59** (no intermediate existence, Kv 8.2), **A69** (matter
outlasts a mind-moment, Kv 22.10) and **A103** (past ceased, future unarisen; it also rests on the Dhammasaṅgaṇī's
definitions). Each gets the asserted-elsewhere test and, where the answer is the debate's conclusion, the HELD OUT mark.
A1 is a premise both sides of Kv 2.5 hold and stays an axiom.
