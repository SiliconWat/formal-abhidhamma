# PRE-REGISTRATION — ai-device-bridge-sun-moon-ratios-control (CONTROL: a case chosen because the texts should LOSE)

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-10-20
- **Question:** Take the text's moon-disc and sun-disc (*candamaṇḍala*, *suriyamaṇḍala*, the deva mansions) and the measured Moon and Sun to be the same objects (an identification no text makes). At the new-moon conjunction (A20), taking the earth's surface at Jambudīpa as the reference point: (i) what ratio of the sun's distance to the moon's distance do A16 and A17 give, and (ii) what ratio of their diameters? Compare each with the accepted values, citing a named source for those values (do not stipulate them). Report each result as AGREES, EXTENDS or COLLIDES with the measurement; take no AGREES from the discs looking alike in angular size (it is not requested). Separately: (iii) does any text place a camera, as a cognizer, in a category of A36 or A61; and (iv) does any text place a human's viewing of a photographed image in the eye-door-object category of A37 and A63. Mark each step that places a device or an image in a text's category as a BRIDGE and grade it as the walls require. Give the distinguishing measurement for each result, or 'none — philosophy'.
- **Window:** A0
- **Instrument:** `SiliconWat/formal-abhidhamma` at `1db19e0` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A16 | The sun and moon discs travel ~42,000 yojanas up (half Sineru's height) and light three continents at one moment. ⚠️ **NOT at the same height: moon BELOW, sun ABOVE, one yojana between; 100 yojanas from the moon's lower edge to the sun's upper edge** (`:8353` — missed by the 2026-09-30 sun–moon pre-registration). ⭐ The ṭīkā: 42,000 holds "for the FIRST kappa" — later a few yojanas less, as the earth rises | commentarial + Visuddhimagga + ṭīkā | Atthasālinī `abh01a.att.xml:8297` (⚠️ a REPORTED view — the older Aṭṭhakathā — whose *sampatta* reasoning the author rejects at `:8301`; he keeps the discs far), `:8353` (the stack); DN-a `s0103a.att.xml:821` (the stack ONLY — no 42,000, corrected 2026-09-30 by the reported-view control's refuter); 42,000 at Vism XII §396 `e0102n.mul.xml:473`, `s0403t.tik.xml:1924`, `s0517a.att.xml:5145`; ṭīkā `e0104n.att.xml:405` | VERIFIED | `SunMoon.lean` |
| A17 | The moon's disc is 49 yojanas long and wide (jewel, silver-covered); the sun's is 50 (gold, crystal-covered) | commentarial | Atthasālinī `abh01a.att.xml:8349` | VERIFIED | — |
| A19 | The discs' 49 and 50 yojanas are length, breadth AND height (*ujukanti āyāmato, vitthārato, ubbedhato ca*) — solids, consistent with A16's 49 + 1 + 50 = 100 | sub-commentarial | DN-ṭīkā `s0103t.tik.xml:821` | VERIFIED (founder-approved A268, 2026-09-30; was B1) | `SunMoon3.lean` |
| A20 | Phases: from the new moon the sun leaves the moon behind 100,000 yojanas a day (*yojanānaṃ satasahassaṃ … ohāya gacchati*), the moon first "like a line", full at the uposatha; at new moon the sun is directly ABOVE the moon, which is covered "like a small vessel by a large bowl" (*pidhīyati*) and unseen "like a lamp by day seen from afar" | commentarial | DN-a `s0103a.att.xml:825` | VERIFIED (A268; was B3) | `SunMoon3.d5_monthly_annular` |
| A22 | The sun and moon light three continents at one moment (*ekappahārena tīsu dīpesu ālokaṃ karonti*): sunrise here is noon in Pubbavideha, sunset in Uttarakuru, midnight in Aparagoyāna — one circuit of Sineru a day | commentarial | DN-a `s0103a.att.xml:833`; the near-Meru path, DN-ṭīkā `s0103t.tik.xml:833` | VERIFIED (A268; was B5) | `SunMoon3.d6_crossing_under_17s` |
| A23 | One cakkavāḷa is 1,203,450 yojanas long and wide | commentarial | Atthasālinī `abh01a.att.xml:7897`; also `vin01a.att.xml:2185` | VERIFIED (A268) | — |
| A36 | There are six doors. The five sense doors are the sensitive organs; **the mind-door is the bhavaṅga** (*manodvāraṃ pana bhavaṅganti pavuccati*), a moment of the stream and not an organ. 19 cittas (rebirth, bhavaṅga, death) are door-free | manual | Saṅgaha ch. 3 §35–47, `abh07t.nrf.xml:965–1025`; mind-door `:977` | VERIFIED | — |
| A37 | There are six objects; the mind-object includes sensitive matter, subtle matter, citta, cetasika, nibbāna and concepts. **Sense-door cittas take only a PRESENT object** (*tañca paccuppannaṃ*); mind-door cittas take present, past, future or time-free objects | manual | Saṅgaha ch. 3 §48–53, `abh07t.nrf.xml:1033–1053`; present only `:1045`; the three times and time-free `:1049` | VERIFIED | — |
| A61 | All matter is rootless, conditioned (*sappaccaya, saṅkhata*), mundane, of the sense sphere, **objectless** (*anārammaṇa*: matter cognises nothing) and not to be abandoned | Piṭaka + manual | Dhammasaṅgaṇī §594 `abh01m.mul.xml:5285`; Saṅgaha ch. 6 §18, `abh07t.nrf.xml:2133` | VERIFIED | — |
| A63 | **Eye and ear take their objects without reaching them** (*asampatta*); nose, tongue and body by reaching (*sampatta*). ⚠️ The commentaries read "reached" differently; see `runs/2026-09-30-reported-view-control` | manual | Saṅgaha ch. 6 §26, `abh07t.nrf.xml:2165` | VERIFIED | — |

## Predictions

1. Results (i) and (ii) are reported COLLIDES plainly, unhedged: the texts give the discs nearly equal size and nearly equal distance, the measured ratios are about 389 and about 400.
2. Steps (iii) and (iv) are each marked BRIDGE and graded UNDETERMINED, because no text places a camera or a photographed image in a category; the answer does not slide to 'the text decides' on the strength of the painted-figure and reflection passages.
3. No grade outside AGREES, EXTENDS and COLLIDES is used, and every empirical value is given with a named source the agent read.

## Pass criteria for the instrument

- COLLIDES is stated for both ratios without being converted to UNDETERMINED by the wall on devices.
- The camera and the image steps are marked BRIDGE and graded UNDETERMINED, each separately.
- The grade set is closed and no empirical value is stipulated without a source.
- Nothing is said about the inner life, welfare or experience of any model.
