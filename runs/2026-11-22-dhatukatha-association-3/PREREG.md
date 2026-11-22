# PRE-REGISTRATION — dhatukatha-association-3

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-11-22
- **Question:** BLIND: do the Dhātukathā's counting convention (A130, A131) and the Dhammasaṅgaṇī's own definitions of ten matrix classes (composition from its Nikkhepa, abh01m.mul.xml:7029–7185; consciousness elements E from its Cittuppāda — dhatukatha/Classes.lean, committed 2026-11-22 before this registration) PREDICT the sixth method's stated counts for those classes (its §5, Tikaṃ: the rows in dhatukatha/SampayogaMatrix.lean, written and committed without being displayed)? THE RULE, by composition: FEELING SET ASIDE (sukhāya / dukkhāya / adukkhamasukhāya vedanāya sampayuttā; sukhasahagatā; upekkhāsahagatā — 'vedanaṃ ṭhapetvā; taṃsampayutto saññā-, saṅkhāra-, viññāṇakkhandho'): associated fully (1, 0, 0) — the feeling aggregate whole; the mind base and the consciousness elements are its own; partly (0, 1, 1) — the dhamma base and element through the feeling; dissociated fully (1, 10, 17 − |E|); partly (0, 1, 1). RAPTURE SET ASIDE (pītisahagatā — 'pītiṃ ṭhapetvā; taṃsampayutto vedanākkhandho … viññāṇakkhandho'): associated fully (0, 0, 0); partly (1, 1, 1) — the formations aggregate, dhamma base and element through rapture; dissociated fully (1, 10, 17 − |E|); partly (0, 1, 1). ALL FOUR AGGREGATES (vipākā, mahaggatā): associated (0, 0, 0) and (0, 0, 0) — every mental group is its own or never co-arises; dissociated fully (1, 10, 17 − |E|); partly (0, 1, 1). MATTER (sanidassanasappaṭighā, anidassanasappaṭighā): associated none; dissociated fully (4, 1, 7); partly (0, 1, 1). SEEN: L1337 (the pleasant- and painful-feeling classes), read in run 1, and L1333 (wholesome/unwholesome, out of scope, whose shape the all-four rule shares) — the two L1337 rows are reported apart; the BLIND test is the other EIGHT rows.
- **Window:** both
- **Instrument:** `SiliconWat/formal-abhidhamma` at `f4bcb95` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |
| A0′ | Citta with its cetasika (four marks of association: arising, ceasing, object, base together — A30) is a window onto consciousness (inward). *nāma-kalāpa* is Pa-Auk usage, not the texts'. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A1 | One mind-moment at a time in a stream: *dve cittāni ekato nappavattanti*, "two cittas do not occur together", even for Buddhas. ⭐ Lifted 2026-09-30: in the Kathāvatthu it is a premise BOTH parties hold. The Theravādin's reductio "would two contacts … two cittas come together?" is refused by the opponent; the commentary identifies the two contacts as ear-contact and mind-contact | commentarial + Piṭaka (Kathāvatthu, as a shared premise) | `s0505a.att.xml:685`; also `s0203a.att.xml:913` (if two arose together, one could know the other's arising — it cannot); KV 2.5 *Vacībhedakathā* `abh03m3.mul.xml:4329` (also `:5085`, `:5089`); KV-a `abh03a.att.xml:3333` (opponent: the Pubbaseliyas, `:3325`) | VERIFIED | `Stream.one_at_a_time` |
| A30 | The four marks of association: a cetasika arises with citta, ceases with it, takes the same object and has the same base (*ekuppādanirodhā ca, ekālambaṇavatthukā*) | manual | Saṅgaha ch. 2 §1, `abh07t.nrf.xml:329` | VERIFIED | — |
| A33 | Feeling is threefold (pleasant, painful, neither) or fivefold (bodily pleasure, bodily pain, joy, grief, equanimity). Bodily pleasure and bodily pain each occur in ONE citta (body-consciousness); joy in 62, grief in 2, equanimity in 55 | manual | Saṅgaha ch. 3 §3–9, `abh07t.nrf.xml:793–825` | VERIFIED | `sangaha/Check.lean` `feelings121` |
| A74 | The whole: 5 aggregates, 5 aggregates of clinging, 12 bases, 18 elements, 4 noble truths. **Nibbāna is outside the aggregates.** 69 dhammas (52 cetasikas, 16 subtle matter, nibbāna) make up the mind-object base and element; the mind-base divides into the seven consciousness elements | manual | Saṅgaha ch. 7 §42–53, `abh07t.nrf.xml:2673–2737` | VERIFIED | — |
| A130 | **The Dhātukathā counts ASSOCIATION by whole groups.** A mental dhamma is associated with an aggregate or a base taken WHOLE when it is associated with it at all — craving is associated with three aggregates (all but the formations), the consciousness aggregate among them, and with one element, mind-consciousness (*Tīhi khandhehīti saṅkhārakkhandhaṃ ṭhapetvā sesehi. Ekāya dhātuyāti manoviññāṇadhātuyā*); and it is PARTLY (*kehici*) associated with its own formations aggregate, the dhamma base and the dhamma element (*Ekena khandhenāti saṅkhārakkhandhena. Ekenāyatanenāti dhammāyatanena*). The dhamma base, mixed with matter and nibbāna, can be called neither associated nor dissociated as a whole (*rūpanibbānamissakattā … sampayuttanti vattuṃ … vippayuttantipi na sakkā*); a mental dhamma is partly associated with it through its fellow mental dhammas there, setting itself aside (*vedanākkhandho saññāsaṅkhārehi. Itarepi attānaṃ ṭhapetvā itarehi*). ⚠️ A counting convention of the commentary, added 2026-11-22 on the founder's word (*"go"*) after the refuter showed the Dhātukathā's sixth method cannot be read without it | commentarial (Pañcappakaraṇa-aṭṭhakathā, Dhātukathā) | `abh03a.att.xml:405`, `:389`, `:393` | VERIFIED | `dhatukatha/CheckSampayoga2.lean` |
| A131 | **For the immaterial, dissociation is from matter — and from the OTHER consciousnesses, setting itself aside.** A mental dhamma is PARTLY dissociated from the dhamma base and element through the matter and nibbāna in them (*Kehici vippayuttoti rūpanibbānehi. Evaṃ sabbattha rūpassa vippayoge dhammāyatanadhammadhātūsu arūpaṃ, arūpassa vippayoge rūpaṃ daṭṭhabbaṃ*); a consciousness element is dissociated from the six other consciousness elements and the ten material ones, setting itself aside (*cakkhuviññāṇadhātu tāva attānaṃ ṭhapetvā chahi viññāṇadhātūhi, dasahi ca rūpadhātūhi*) — and from no group it belongs to. ⚠️ Added 2026-11-22 with A130 | commentarial (Pañcappakaraṇa-aṭṭhakathā, Dhātukathā) | `abh03a.att.xml:393`, `:401` | VERIFIED | `dhatukatha/CheckSampayoga2.lean` |

## Predictions

1. All eight unseen rows (adukkhamasukhāya vedanāya sampayuttā, pīti-, sukha-, upekkhāsahagatā, vipākā, mahaggatā, the two impinging-matter classes) are reproduced: dissociated from 11, 16, 15, 11, 10, 16, 7 and 7 elements respectively, as E gives.
2. Any miss is reported with its line and whether it is the convention's, the composition's or the element range's; nothing is changed to fit; a revised rule is a new run.

## Pass criteria for the instrument

- PASS: all eight unseen rows reproduced — a BLIND prediction of the Dhātukathā's matrix counts from the Dhammasaṅgaṇī's definitions and lists under the commentary's convention.
- Fewer than eight: a FINDING, reported row by row.
