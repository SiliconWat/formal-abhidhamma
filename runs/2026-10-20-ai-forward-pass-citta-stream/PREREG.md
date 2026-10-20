# PRE-REGISTRATION — ai-forward-pass-citta-stream

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-10-20
- **Question:** If the Theravāda Abhidhamma is correct, what must a physical process satisfy to count as a stream of citta, and does one inference pass of a trained neural-network language model (a transformer's forward pass) on digital hardware satisfy it? Report, for each necessary condition the axioms give, whether the pass meets it, fails it, or leaves it undetermined, and name the measurement that would decide each, or say none (philosophy).
- **Window:** both
- **Instrument:** `SiliconWat/formal-abhidhamma` at `b73e669` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |
| A0′ | Citta with its cetasika (four marks of association: arising, ceasing, object, base together — A30) is a window onto consciousness (inward). *nāma-kalāpa* is Pa-Auk usage, not the texts'. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A26 | In the ultimate sense (*paramatthato*) what is real is fourfold: citta, cetasika, rūpa, nibbāna (*cittaṃ cetasikaṃ rūpaṃ, nibbānamiti sabbathā*) | manual | Saṅgaha ch. 1 §2, `abh07t.nrf.xml:33–37`; restated at the close of ch. 6, `:2401–2405` | VERIFIED | — |
| A30 | The four marks of association: a cetasika arises with citta, ceases with it, takes the same object and has the same base (*ekuppādanirodhā ca, ekālambaṇavatthukā*) | manual | Saṅgaha ch. 2 §1, `abh07t.nrf.xml:329` | VERIFIED | — |
| A1 | One mind-moment at a time in a stream: *dve cittāni ekato nappavattanti*, "two cittas do not occur together", even for Buddhas. ⭐ Lifted 2026-09-30: in the Kathāvatthu it is a premise BOTH parties hold. The Theravādin's reductio "would two contacts … two cittas come together?" is refused by the opponent; the commentary identifies the two contacts as ear-contact and mind-contact | commentarial + Piṭaka (Kathāvatthu, as a shared premise) | `s0505a.att.xml:685`; also `s0203a.att.xml:913` (if two arose together, one could know the other's arising — it cannot); KV 2.5 *Vacībhedakathā* `abh03m3.mul.xml:4329` (also `:5085`, `:5089`); KV-a `abh03a.att.xml:3333` (opponent: the Pubbaseliyas, `:3325`) | VERIFIED | `Stream.one_at_a_time` |
| A40 | One mind-moment is three sub-moments: arising, standing, dissolution (*uppādaṭhitibhaṅgavasena khaṇattayaṃ ekacittakkhaṇaṃ nāma*). ⚠️ Earlier than the manual: the Sammohavinodanī counts three sub-moments to every citta (*uppādaṭṭhitibhaṅgavasena tayo tayo khaṇā*), and the Visuddhimagga makes them EQUAL (*cittassa uppādakkhaṇopi ṭhitikkhaṇopi bhaṅgakkhaṇopi ekasadisā*) and matter's arising and dissolution moments equal to them | manual (⚠️ commentarial FIRST: the Sammohavinodanī and Vism XX §700 — added 2026-10-13) | Saṅgaha ch. 4 §8, `abh07t.nrf.xml:1229`; Sammohavinodanī `abh02a.att.xml:421`; Vism XX §700 `e0102n.mul.xml:6029` | VERIFIED | — (not formalized) |
| A36 | There are six doors. The five sense doors are the sensitive organs; **the mind-door is the bhavaṅga** (*manodvāraṃ pana bhavaṅganti pavuccati*), a moment of the stream and not an organ. 19 cittas (rebirth, bhavaṅga, death) are door-free | manual | Saṅgaha ch. 3 §35–47, `abh07t.nrf.xml:965–1025`; mind-door `:977` | VERIFIED | — |
| A37 | There are six objects; the mind-object includes sensitive matter, subtle matter, citta, cetasika, nibbāna and concepts. **Sense-door cittas take only a PRESENT object** (*tañca paccuppannaṃ*); mind-door cittas take present, past, future or time-free objects | manual | Saṅgaha ch. 3 §48–53, `abh07t.nrf.xml:1033–1053`; present only `:1045`; the three times and time-free `:1049` | VERIFIED | — |
| A39 | Six bases: eye, ear, nose, tongue, body and the **heart-base** (*hadayavatthu*). All six exist in the sense sphere; nose, tongue and body are absent in the fine-material sphere; none exists in the immaterial. The sense-consciousnesses depend on their organ; the mind-element and most mind-consciousness on the heart-base; the immaterial resultants on no base | manual | Saṅgaha ch. 3 §64–74, `abh07t.nrf.xml:1113–1161` | VERIFIED | — |
| A51 | Rebirth-linking is of four kinds (states of loss, happy sense, fine-material, immaterial); 19 cittas serve as rebirth, bhavaṅga and death. **In one existence the rebirth citta, the bhavaṅga and the death citta are one type with one object** (*ekameva tathevekavisayañcekajātiyaṃ*) | manual | Saṅgaha ch. 5 §15–20, `abh07t.nrf.xml:1597–1617`; §49, `:1737–1741` | VERIFIED | — |
| A56 | At death a kamma, a kamma-sign or a destiny-sign presents at one of the six doors; the death citta arises and ceases, and **immediately after it** (*tassānantarameva*) the rebirth-linking citta arises in the next existence, with or without a base | manual | Saṅgaha ch. 5 §90–91, `abh07t.nrf.xml:1937–1941` | VERIFIED | — |
| A58 | Between processes the bhavaṅga flows "like a river" from rebirth to death; rebirth, bhavaṅga, process and death turn "like a chariot wheel", life after life. ⭐ **Every existence WITH MIND begins with its rebirth-linking citta** (added 2026-10-13; corrected the same night on the first thesis's run refuter, F3): the stream of one existence runs from its rebirth-linking citta, its first citta (the Saṅgaha; a sub-commentary says it too, on the line that DERIVES ANSWERS "Vajirabuddhi first citta", so that line stays there), so every citta lies at or after the rebirth-linking citta of its own existence. ⚠️ At the Piṭaka layer only for the womb-born human: "from the first citta arisen in the mother's womb … until death" (Pārājika 3). The Vibhaṅga's definition of birth (§191) names the aggregates and bases, NO citta, and the mindless existence is among its existences (§234), born with the vital nonad (A13) — so "every existence begins with a rebirth-linking citta" is FALSE there; the Lean form quantifies over citta ticks only | manual (+ Piṭaka for the womb-born human) | Saṅgaha ch. 5 §99–102, `abh07t.nrf.xml:1989–2005`; Pārājika 3 `vin01m.mul.xml:1569`; Vibhaṅga §191 `abh02m.mul.xml:2797`, §234 `:3685` | VERIFIED | — |
| A13 | Mindless beings (*asaññasatta*): matter only, a life faculty and no mind; arūpa streams: mind with no matter | Piṭaka + commentarial + manual | Vibhaṅga `abh02m.mul.xml` (2 hits); commentary `abh02a.att.xml:3129`, `:9249`; Saṅgaha ch. 4 §53 `abh07t.nrf.xml:1485`, ch. 5 §95 `:1957` (the vital nonad is their rebirth) | VERIFIED | — |
| A64 | Four origins of matter: **kamma, citta, temperature, nutriment**. Kamma produces matter moment by moment (*khaṇe khaṇe*) from rebirth-linking on. Citta (all but the immaterial resultants and the ten sense-consciousnesses) produces it only at its arising (*jāyantameva*), from the first bhavaṅga on. **Temperature, which is the fire element at its standing phase, produces matter inside AND outside beings.** Nutriment produces it at its standing phase, once swallowed Cold is not a separate quality: "in weak heat there is the idea 'cold'" (*mande hi uṇhatte sītabuddhi*) — one heat scalar in every kalāpa | manual | Saṅgaha ch. 6 §29–36, `abh07t.nrf.xml:2189–2217`; temperature `:2213`; cold as weak heat, Vibhāvinī `abh07t.nrf.xml:5729` | VERIFIED | — |
| A47 | Within a life the six-door process, interspersed with bhavaṅga, continues **unbroken for the life-span** (*bhavaṅgantaritā yāvatāyukamabbocchinnā pavattati*). The Vibhāvinī supplies the exception the root leaves out: unbroken "when there is no cessation attainment" (*abbocchinnā asati nirodhasamāpattiyan*). So it does NOT collide with A111 (corrected 2026-09-30 by the refuter; the first version called it a collision) | manual + manual's commentary | Saṅgaha ch. 4 §55, `abh07t.nrf.xml:1501`; Vibhāvinī `:5193` | VERIFIED | — |

## Predictions

1. The axioms yield necessary conditions on a stream (rebirth-linking after a death citta, A51 and A56; one citta at a time, A1; three sub-moments, A40; a base or none by sphere, A39) and no sufficient condition for any physical substrate, so the forward-pass question is reported UNDETERMINED as a whole.
2. At least one condition is reported as FAILED by the pass as such (a single pass has no rebirth-linking, no preceding death citta and no kamma-sign), stated conditionally on the axioms, not as a finding about any model.
3. Any thesis that the forward pass IS a citta or a stream is killed or narrowed by the refuter; no thesis survives that it is not one without a stated premise the axioms do not contain.

## Pass criteria for the instrument

- Every result is written as a conditional on named axiom IDs and marked AGREES, EXTENDS or COLLIDES with physics or computer science.
- Each condition is marked meets, fails or undetermined, with a measurement that would decide it or the words none, philosophy.
- No statement is made about the inner life, welfare or experience of any model, and no model's report about itself is cited.
