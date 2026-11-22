# PRE-REGISTRATION — cittuppada-against-the-manual

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-11-22
- **Question:** Does the Saṅgaha's association table (A32: sangaha/Rules.lean, 'arises') agree with the Dhammasaṅgaṇī's OWN lists of the dhammas in each class of consciousness — for ALL 23 classes whose list is written in full (cittuppada/, abh01m.mul.xml), not only the first (sangaha/Canon.lean, rung 3)? INPUTS committed before this registration (sangaha/CanonAll.lean, by canon/allcanon.py): each class's citta record built from its feature words by DECLARED rules (kind, plane, feeling — in a several-consciousness sentence the last named's — root, knowledge, view, consciousness element, jhāna and path); each listed term mapped onto the 52 by the pre-registered map of PREREGISTRATION-2026-09-27b.md §3, UNCHANGED, plus a declared EXTENSION on the same principle (the other feelings; micchādiṭṭhi → view, micchāsaṅkappo → vitakka, micchāvāyāmo → energy, micchāsamādhi → one-pointedness, ahirika-/anottappa-, lobho/abhijjhā → greed, moho → delusion, doso/byāpādo → hate, vicikicchā, uddhaccaṃ; the three supramundane abstinences; the three supramundane faculties → wisdom); no term unmapped. CONTROL (known answer): the first wholesome class must give the 29 listed and the nine 'ye vā pana' as sangaha/Canon.lean has them.
- **Window:** A0′
- **Instrument:** `SiliconWat/formal-abhidhamma` at `ebea4f1` (AXIOMS.md, Axioms.lean as of that commit)
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

1. P1: for every one of the 23 classes, every factor the Dhammasaṅgaṇī LISTS is among the factors the Saṅgaha's rules give for its citta (listed ⊆ Saṅgaha).
2. P2: every class whose Saṅgaha set exceeds its listed set carries the open clause 'ye vā pana … aññepi atthi' (so the Saṅgaha adds only where the Piṭaka itself leaves the list open).
3. CONTROL: the first wholesome class reproduces 29 listed + exactly the nine yevāpanaka = 38.

## Pass criteria for the instrument

- PASS: P1 and P2 hold for all 23 and the control reproduces — the manual's table is CONSISTENT with the Piṭaka's own lists wherever they are written in full; the Saṅgaha's extras per class are reported (they are what the open clause leaves to the commentary).
- A class failing P1 is a FINDING (a factor the Piṭaka lists that the manual's rules deny), reported with its line; nothing is changed to fit; a revised rule is a new run.
