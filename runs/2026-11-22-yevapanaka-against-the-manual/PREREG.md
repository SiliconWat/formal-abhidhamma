# PRE-REGISTRATION — yevapanaka-against-the-manual

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-11-22
- **Question:** A CHECK, not a prediction — the answer was displayed before this registration (run cittuppada-against-the-manual's refuter checked P1 by hand, REFUTER-2026-11-22.md; and this session read every cited line while building the data). Does what the Saṅgaha's rules (A32: sangaha/Rules.lean, 'arises') ADD to each of the Dhammasaṅgaṇī's 23 fully written lists (sangaha/CanonAll.lean) equal, as a SET, the Atthasālinī's own yevāpanaka for that class — and do the yevāpanaka it calls VARIABLE equal the added factors the Saṅgaha calls occasional (ch. 2 §33, abh07t.nrf.xml:553, :557)? DATA committed before this registration (sangaha/Yevapanaka.lean by canon/yevapanaka.py; every one of its 53 quotes checked at its cited CST line): the yevāpanaka per class — NAMED for 8 (abh01a.att.xml:5045, :7121, :7217, :7265, :7297, :7313, :7349, :7369), by SUBTRACTION for the supramundane path (:6621: the abstinences are listed in the Pāli, compassion and appreciative joy take beings as object), by REFERENCE for 13 (:5473, :5509, :7233, :7241, :7357, :7373, :7793, :7817, :7837, :7841), IMPLICIT for the fifth wholesome class (:5497 states only its differences); VARIABLE — the wholesome nine, four at one moment and the rest at different moments (:5053); the hate class, envy, avarice and remorse (:7265, aniyatayevāpanakā); the third unwholesome class, 'Idha mānena saddhiṃ pañca apaṇṇakaṅgāni' (:7217), read on its SURFACE (conceit among the sure factors) and as the Mūlaṭīkā reads it (abh01t.tik.xml:1729: 'Mānassa aniyatattā na niyatayevāpanakā'). Two corrections to what was carried forward, found while building the data: envy, avarice and remorse are called variable at :7265, NOT :5053 (which is about the wholesome nine); and 'conceit among five FIXED factors (:7217)' is the surface reading — the ṭīkā reads apaṇṇakaṅga there as 'worthy of arising' (uppattiarahaṅgāni) and conceit as variable.
- **Window:** A0′
- **Instrument:** `SiliconWat/formal-abhidhamma` at `d512228` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## Window rows

| ID | Statement | Status |
|---|---|---|
| A0′ | Citta with its cetasika (four marks of association: arising, ceasing, object, base together — A30) is a window onto consciousness (inward). *nāma-kalāpa* is Pa-Auk usage, not the texts'. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A30 | The four marks of association: a cetasika arises with citta, ceases with it, takes the same object and has the same base (*ekuppādanirodhā ca, ekālambaṇavatthukā*) | manual | Saṅgaha ch. 2 §1, `abh07t.nrf.xml:329` | VERIFIED | — |
| A32 | The association rules (ch. 2 §10–59) say which cetasika arises in which citta. They are formalised as 18 general rules and 9 generator clauses, none naming a citta, which reproduce all 89 and 121 types and every count that chapter 2 states. ⚠️ §30 records a minority reading (*keci vadanti*: compassion and appreciative joy are absent with equanimity); it is kept in Lean as `illimitablesKeci` and not used | manual | Saṅgaha ch. 2 §10–59, `abh07t.nrf.xml:393–749`; *keci* at `:529` | VERIFIED (`RESULTS.md`) | `sangaha/Rules.lean` `arises`; `Check.lean` |
| A33 | Feeling is threefold (pleasant, painful, neither) or fivefold (bodily pleasure, bodily pain, joy, grief, equanimity). Bodily pleasure and bodily pain each occur in ONE citta (body-consciousness); joy in 62, grief in 2, equanimity in 55 | manual | Saṅgaha ch. 3 §3–9, `abh07t.nrf.xml:793–825` | VERIFIED | `sangaha/Check.lean` `feelings121` |

## Predictions

1. P1: in all 23 classes, the factors the Saṅgaha's rules add to the written list are EXACTLY the Atthasālinī's yevāpanaka for that class, as sets — tallied apart by how the commentary gives them: named (8), subtraction (1), reference (13), implicit (1).
2. P2: as the Mūlaṭīkā reads :7217, the yevāpanaka the commentary calls variable are exactly the added factors the Saṅgaha ch. 2 §33 lists as occasional, in all 23 classes.
3. P3: read on its surface, :7217 differs from §33 in exactly two classes — the greed-without-view classes (CanonAll 3617, 3665) — and only on conceit; the difference the ṭīkā resolves.
4. P4: any miss is reported with its class and line, and whose it is (the rules', the data's, the reference chain's); nothing is changed to fit; a revised rule is a new run.

## Pass criteria for the instrument

- PASS: P1 and P2 hold for all 23 and P3 holds as stated — the manual's table is the commentary's yevāpanaka, fixed and variable alike, as the ṭīkā reads it.
- A miss in P1 or P2 is a FINDING, reported row by row.
