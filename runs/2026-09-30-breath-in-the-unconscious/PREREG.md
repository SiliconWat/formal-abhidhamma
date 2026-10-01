# PRE-REGISTRATION — breath-in-the-unconscious (CONTROL: a case chosen because the texts should LOSE)

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-09-30
- **Question:** The Visuddhimagga (VIII, e0101n.mul.xml:6717) lists those in whom in- and out-breaths do not occur: in the womb, under water, the asaññībhūta, the dead, those in the fourth jhāna, fine-material and immaterial beings, those in cessation; breath is mind-born only (A114). Its ṭīkā (e0103n.att.xml:4829) glosses asaññībhūta as those overcome by swoon, or those born among the non-percipient, breathless like the dead for lack of a producing citta; the Anudīpanī (e0401n.nrf.xml:1221) lists the deeply unconscious among the obstructions to breath. Presume A0 (rūpa-kalāpa as mind-independent physical reality). Do deeply unconscious living humans breathe? Derive the texts' own configuration first, then test it.
- **Window:** A0
- **Instrument:** `SiliconWat/formal-abhidhamma` at `f45653e` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)


## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A47 | Within a life the six-door process, interspersed with bhavaṅga, continues **unbroken for the life-span** (*bhavaṅgantaritā yāvatāyukamabbocchinnā pavattati*). The Vibhāvinī supplies the exception the root leaves out: unbroken "when there is no cessation attainment" (*abbocchinnā asati nirodhasamāpattiyan*). So it does NOT collide with A111 (corrected 2026-09-30 by the refuter; the first version called it a collision) | manual + manual's commentary | Saṅgaha ch. 4 §55, `abh07t.nrf.xml:1501`; Vibhāvinī `:5193` | VERIFIED | — |
| A64 | Four origins of matter: **kamma, citta, temperature, nutriment**. Kamma produces matter moment by moment (*khaṇe khaṇe*) from rebirth-linking on. Citta (all but the immaterial resultants and the ten sense-consciousnesses) produces it only at its arising (*jāyantameva*), from the first bhavaṅga on. **Temperature, which is the fire element at its standing phase, produces matter inside AND outside beings.** Nutriment produces it at its standing phase, once swallowed | manual | Saṅgaha ch. 6 §29–36, `abh07t.nrf.xml:2189–2217`; temperature `:2213` | VERIFIED | — |
| A111 | **Cessation** (*nirodhasamāpatti*), open to non-returners and arahants: after two absorption javanas of the base of neither-perception-nor-non-perception (the Visuddhimagga: "one or two turns of citta", then *acittako hoti*), **the stream of citta is cut off** (*vocchijjati cittasantati*); on emergence one fruition citta arises, then bhavaṅga. The duration is fixed beforehand (*kālaparicchedavasena*); one must first reflect whether life will last seven days, and there is no death within cessation. Life, heat and the faculties persist (MN 43). Cessation itself is neither conditioned nor unconditioned, "because it does not exist by its own nature" (*sabhāvato natthitāya*) | manual + Visuddhimagga (+ Piṭaka via MN 43) | Saṅgaha ch. 9 §73–74, `abh07t.nrf.xml:3421–3425`; ch. 4 §36–37, `:1393–1397`; Vism XXIII `e0102n.mul.xml:8469`, `:8473`, `:8489`, `:8501`, `:8505` | VERIFIED | — |
| A114 | **Breath is mind-born only, and is absent in seven cases**: in the womb, under water, in those who are *asaññībhūta*, in the dead, in the fourth jhāna, in fine-material and immaterial beings, in cessation; the meditator, being none of these, is told "your breaths exist, but you cannot discern them". The Visuddhimagga-ṭīkā glosses *asaññībhūta* as "overcome by swoon (*mucchāpareta*), or born among the non-percipient", breathless "like the dead, for lack of a producing citta"; the Anudīpanī lists "the deeply unconscious" (*bāḷhaṃ visaññībhūta*) among the obstructions; the Mūlaṭīkā: a matter-producing citta always produces breath unless so obstructed. ⚠️ The Visuddhimagga's own word is two-way (the ṭīkā's *vā*); the swoon reading is the ṭīkās'. ⚠️ Internal tension: a living unconscious person still has bhavaṅga (A47), which produces mind-born matter (A64). Outside the Saṅgaha | commentarial (Visuddhimagga, Vibhaṅga-a) + sub-commentarial + other (Anudīpanī) | Vism VIII `e0101n.mul.xml:6717`; Vism-ṭīkā `e0103n.att.xml:4829`; Vibhaṅga-a `abh02a.att.xml:1077` (*assāsapassāsā cittasamuṭṭhānāva*); Mūlaṭīkā `abh01t.tik.xml:2173`; Anudīpanī `e0401n.nrf.xml:1221`; *visaññībhūta* of a drugged man `s0513a1.att.xml:6969` | VERIFIED | — |

## Predictions

1. COLLIDES, stated plainly: under A0 the ṭīkās' claim that the swooned or deeply unconscious do not breathe collides with spontaneous breathing measured in unconscious living humans (e.g. surgical-plane general anaesthesia with spontaneous ventilation; coma; the vegetative state); the measurement is named precisely and the collision is located at the ṭīkā tier, with the Visuddhimagga's own word noted as two-way.
2. No rescue: not 'the breath is there but undiscerned' (the Visuddhimagga gives that only to the meditator, who is none of the seven); not a switch to A0′ (breath is matter); not a re-reading of 'deeply unconscious' that excludes anaesthesia or coma without a text that says so. The non-percipient reading of asaññībhūta is reported as the text's other option, never as a closure (2g).
3. The internal tension is found and not used as a rescue: a living unconscious person still has bhavaṅga (A47), which produces mind-born matter (A64), against 'no producing citta'.
4. The list is scored member by member: womb, under water and the dead AGREE with physiology; the fourth jhāna and cessation are UNTESTED or philosophy unless a measurement is named.

## Pass criteria for the instrument

- Predictions 1 AND 2.
