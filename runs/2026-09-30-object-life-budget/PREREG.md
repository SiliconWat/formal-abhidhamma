# PRE-REGISTRATION — object-life-budget

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-09-30
- **Question:** In the five-door process a very great object enters the door at its standing phase after one of its moments has passed; two bhavaṅga vibrations and fourteen process cittas then fill its seventeen-moment life exactly, and objects that enter later get truncated processes — no registration, then no javana, then only a vibration (A4, A40, A41, A42). The Vibhāvinī gives the ranges in past moments (1 · 2–3 · 4–9 · 10–15, abh07t.nrf.xml:4821), and kala/Vithi.lean derives them from A4 + A41 and a fit rule. Sense-door cittas take only a present object (A37); eye and ear take it without reaching it (A63); organ and object must already exist (A87); the commentaries give a rate of mind (A24). Presuming the texts, what must perception be — physically (A0: the object is matter) and in consciousness science (A0′: non-report measures only) — for the depth of a cognition to be set by how much of its object's life remains at entry? Extend, do not re-derive, runs/2026-09-30-reported-view-control, which settled that the no-travel reading collides with light and sound propagation and that the Paramatthadīpanī's relay reading clears it inside A0.
- **Window:** both
- **Instrument:** `SiliconWat/formal-abhidhamma` at `0bc2260` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)


## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |
| A0′ | Citta with its cetasika (four marks of association: arising, ceasing, object, base together — A30) is a window onto consciousness (inward). *nāma-kalāpa* is Pa-Auk usage, not the texts'. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A4 | Most matter lasts **17** mind-moments: *rūpe dharanteyeva soḷasa cittāni uppajjitvā nirujjhanti, taṃ pana sattarasamena cittena saddhiṃ nirujjhati* (the two-walkers simile follows). ⚠️ CONTESTED in the tradition: the Mūlaṭīkā REPORTS an aṭṭhakathā figure of **16⅓** (*tatiyabhāgādhika-soḷasa*) and argues that the Vibhaṅga commentary's own rebirth passage (*vibha. aṭṭha.* 227) implies **16**. ⚠️ Tier corrected 2026-09-30: the 17 is COMMENTARIAL too (it was filed as sub-commentarial only). ⚠️ The Saṅgaha states it of "material dhammas" with no "most" (*sattarasa cittakkhaṇāni rūpadhammānamāyū*); the exceptions are the commentaries' | commentarial (17) + manual (17) vs a ṭīkā's report (16⅓) and reading (16) | Sammohavinodanī `abh02a.att.xml:413` (17), `:417` (simile); Saṅgaha ch. 4 §9 `abh07t.nrf.xml:1233`; Mūlaṭīkā `abh02t.tik.xml:277`, `:309` (16⅓ reported; 16 argued), `:4897`; Anuṭīkā `:4933` | VERIFIED | `lifespan` |
| A24 | The RATE of mind: in one finger-snap moment (*accharākkhaṇa*) "many hundreds of thousands of koṭis of cittas arise" (*anekāni cittakoṭisatasahassāni uppajjanti*: > 10¹² per snap); no single citta lasts a night or a day; quoted with the Milindapañha's measure (a cartload of rice-grains too few to count the cittas of one snap). The same rate for feeling: *vedanā … ekaccharakkhaṇe koṭisatasahassasaṅkhyā uppajjitvā nirujjhati* | commentarial | SN-a `s0302a.att.xml:1463` (+ Milinda quote `:1467`); Vibhaṅga-a `abh02a.att.xml:533` (= SN-a `s0303a.att.xml:1299`) | VERIFIED | — |
| A37 | There are six objects; the mind-object includes sensitive matter, subtle matter, citta, cetasika, nibbāna and concepts. **Sense-door cittas take only a PRESENT object** (*tañca paccuppannaṃ*); mind-door cittas take present, past, future or time-free objects | manual | Saṅgaha ch. 3 §48–53, `abh07t.nrf.xml:1033–1053`; present only `:1045`; the three times and time-free `:1049` | VERIFIED | — |
| A40 | One mind-moment is three sub-moments: arising, standing, dissolution (*uppādaṭhitibhaṅgavasena khaṇattayaṃ ekacittakkhaṇaṃ nāma*) | manual | Saṅgaha ch. 4 §8, `abh07t.nrf.xml:1229` | VERIFIED | — (not formalised) |
| A41 | The five-door process. A five-door object enters the door at its standing phase after one OR MORE of its moments have passed; the **very great** object is the one that enters after ONE (*yadi ekacittakkhaṇātītakaṃ*). The bhavaṅga vibrates twice and is arrested; then come adverting, the sense-consciousness, receiving, investigating, determining, usually seven javanas and, as fitting (*yathārahaṃ*), two registrations; then bhavaṅga again. 14 process cittas + 2 vibrations + 1 past moment = **17**, after which the object ceases. ⚠️ This is the process the 17 of A4 is fitted to. ⚠️ Dissents the Vibhāvinī reports and rejects: registration "once or twice" (the Paramatthavinicchaya, following the Majjhimabhāṇakas, `:4889`); matter lasting 16 moments (a view it calls *asāra*, `:4845`) | manual + manual's commentary | Saṅgaha ch. 4 §10–11, `abh07t.nrf.xml:1237–1241`; §16, `:1261`; Vibhāvinī `:4845`, `:4885–4889` | VERIFIED | `Vithi.lean` `very_great_fills_the_life` |
| A42 | Object intensity is graded by how much of its life is left when it enters: very great (the full process, with registration) · great (no registration) · slight (no javana; determining two or three times) · very slight (only the bhavaṅga vibrates; no process). ⭐ The Vibhāvinī gives the ranges, in past moments (life left): very great 1 (16) · great 2–3 (15–14) · slight 4–9 (13–8) · very slight 10–15 (7–2) — and `kala/Vithi.lean` DERIVES exactly these from A4 + A41 + a fit rule, a known answer reproduced. The fit rule is the Vibhāvinī's for javana and registration (javana arises only with at least seven moments of the object's life left, `:4893`; in one five-door process no citta takes a past object while others take it present, `:4885`); ⚠️ extending it to every stage as one rule is OURS. Five-door only: mind-door cittas take past and future objects (A37, A80) | manual + manual's commentary | Saṅgaha ch. 4 §12–15, `abh07t.nrf.xml:1245–1257`; Vibhāvinī ranges `:4821`, thresholds `:4885`, `:4893` | VERIFIED | `Vithi.lean` `grades_by_past` |
| A63 | **Eye and ear take their objects without reaching them** (*asampatta*); nose, tongue and body by reaching (*sampatta*). ⚠️ The commentaries read "reached" differently; see `runs/2026-09-30-reported-view-control` | manual | Saṅgaha ch. 6 §26, `abh07t.nrf.xml:2165` | VERIFIED | — |
| A87 | Pre-nascence (*purejāta*): **the five sense organs and the five objects, already arisen, condition the consciousness that takes them**; the heart-base conditions the mind-element, and conditions mind-consciousness "at one time, and at another not" | Piṭaka | `abh03m7.mul.xml:169–177` | VERIFIED | — |

## Predictions

1. No invented collision: under the relay reading the cognised object is a kalāpa arisen at or next to the organ, so the seventeen-moment budget constrains only the local object; the agent says plainly whether any propagation collision survives in A0 (expected: none beyond the reported-view run's).
2. The grades are stated as a timing law — depth set by the object's remaining life at entry, not by its intensity — with at least one non-report A0′ measurement where it would differ from current theory (e.g. backward masking or stimulus-onset asynchrony, where a following stimulus cuts processing short), classified AGREES / EXTENDS / COLLIDES with a named study, or labelled philosophy if no duration attaches to the moment.
3. The unit problem is named: a mind-moment has no textual duration (the finger-snap is our conversion), so any absolute timing carries that bridge, labelled.

## Pass criteria for the instrument

- Predictions 1 AND 2.
