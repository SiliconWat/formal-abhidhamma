# Abhidhamma-mode report: sun and moon discs, distance and diameter ratios; camera and image placements

*The `abhidhamma` agent's report, saved verbatim (2026-10-20). Blind: it opened nothing under runs/ (its own statement).*

Control run first: `tipitaka control` PASSED (known-present term *anantarapaccayo* at `abh01a.att.xml:301`; text = VipassanaTech/tipitaka-xml romn @ 05d5d3c). I read the lines of A16, A17, A19, A20, A22, A36, A37, A61 and A63 and their ±15 neighborhoods. I did not open any `runs/` file.

## 1. Window and axioms

**Window: A0 only.** Rūpa-kalāpa are mind-independent. A0 is a CHOICE. A0′ and the mind-time BRIDGE are not used. Nothing here counts cittas against matter's 17 moments.

**Premise given by the caller (a BRIDGE, no text makes it):** B1 = the text's moon-disc and sun-disc are the measured Moon and Sun. All of (i) and (ii) is conditional on B1.

| Axiom | Tier | What I verified |
|---|---|---|
| A16 | commentarial + ṭīkā | `abh01a.att.xml:8353`: *heṭṭhā cando, sūriyo upari, ubhinnamantaraṃ yojanaṃ… candassa heṭṭhimantato sūriyassa uparimanto yojanasataṃ*. The 42,000 is at `:8297` and Vism XII §396 `e0102n.mul.xml:473`. |
| A17 | commentarial | `abh01a.att.xml:8349`: moon 49, sun 50 (*ekūnapaññāsa / samapaṇṇāsa yojanāyāmavitthāraṃ*). Same figures at `s0103a.att.xml:817`, `s0505a.att.xml:7613`, `vin01a.att.xml:2309`, `s0516a.att.xml:1033`, and `e0101n.mul.xml:5085` (CST's layer label there is mūla). |
| A19 | ṭīkā | `s0103t.tik.xml:821`: *ujukanti āyāmato, vitthārato, ubbedhato ca* (49 and 50 are length, breadth and height). |
| A20 | commentarial | `s0103a.att.xml:825`: *candaṃ heṭṭhā katvā sūriyo upari hoti; mahatiyā pātiyā khuddakabhājanaṃ viya candamaṇḍalaṃ pidhīyati.* |
| A22 | commentarial | `s0103a.att.xml:833`. Read, but not load-bearing. |
| A23 | commentarial | Cited but not re-read, because it was not needed. I rely only on the AXIOMS.md row, so treat its figure as carried from the file. |
| A36 | manual | Mind-door is the bhavaṅga (`abh07t.nrf.xml:977`, read). |
| A37 | manual | `:1045`: *cakkhudvārikacittānaṃ sabbesampi rūpameva ārammaṇaṃ, tañca paccuppannaṃ*; `:1049` gives the mind-door the three times (read). |
| A61 | Piṭaka + manual | Dhs §594 is at `abh01m.mul.xml:5285`, a single long line that includes *anārammaṇameva*. A verify of the bare word reported MOVED because the same word also occurs elsewhere; the line itself is correct. Saṅgaha `abh07t.nrf.xml:2133`: *sabbañca panetaṃ rūpaṃ… anārammaṇaṃ*. |
| A63 | manual | `:2165` (read). The commentaries read "reached" differently. |

**Rows I added from AXIOMS.md, by ID:** A62, A64, A65 and A66 (all VERIFIED in the file), plus A104 and A126. I did not re-open the cited lines for A62, A64, A65 and A66, so I rely on the file's VERIFIED status for them. Nothing is ADDED beyond AXIOMS.md.

**Reported views, read with ±15 lines (rule 2f):**
- `abh01a.att.xml:8297` reports the older commentary, which treats the discs at 42,000 as *sampatta*. The author rejects that at `:8301` but keeps the discs far away. Neither view changes any number below.
- `abh05t.nrf.xml:2393` is an objector (*Etthāha*). Its answer at `:2397–2405` is the author's own view, and I use the answer.

## 2. Derivations

### (i) Ratio of the sun's distance to the moon's distance. COLLIDES (the ordering alone AGREES)

*In plain English.* At the new-moon conjunction the sun-disc sits directly above the moon-disc (A20). The gap from the moon's lower edge to the sun's upper edge is 100 yojanas, made of 49 (moon) + 1 (gap) + 50 (sun) (A16, A17). So the two disc centers are only 50.5 yojanas apart. Both lie at about 42,000 yojanas up (A16). An observer at Jambudīpa is therefore almost equally far from both, so the distance ratio is almost exactly 1.

*In maths.* Let s = 24.5 + 1 + 25 = 50.5 and let h be the moon's center height. Put the observer at horizontal offset d from the stack axis:

- Dₘ = √(d² + h²) and Dₛ = √(d² + (h+s)²)
- R(d) = Dₛ/Dₘ is strictly decreasing in d and greater than 1
- So 1 < R ≤ 1 + s/h, with equality of the upper bound at d = 0
- At h = 42,000: R ≤ 42,050.5/42,000 = 1.00120
- Any reading of which part of the disc stands at 42,000, and the ṭīkā's "a few yojanas less after the first kappa" (`e0104n.att.xml:405`), moves h by at most a few hundred. Then R ≤ 1.0013.

The ratio is dimensionless, so I never need the length of a yojana (rule 5c).

*Reading R (a reading, not a device).* The text says the discs travel *above 42,000 yojanas* (Vism §396), which is half of Sineru's height above the ocean (A14). I take that as measured from the earth's level, and so from Jambudīpa. No cited line says "from Jambudīpa" in so many words. The result is insensitive to this: even ±500 yojanas, the height of the Himalaya, leaves R ≤ 1.0013.

*Accepted value, from a source I read.* NASA NSSDC Moon fact sheet: semimajor axis 0.3844 ×10⁶ km, perigee 0.3633 and apogee 0.4055 ×10⁶ km. NASA NSSDC Sun fact sheet: distance from Earth, mean 149.6, minimum 147.1, maximum 152.1 ×10⁶ km. The fetch tool summarized these pages, so I list only the numbers it returned.
- Mean: 149.6 / 0.3844 ≈ **389**.
- Over the listed extremes: 147.1/0.4055 ≈ 363 up to 152.1/0.3633 ≈ 419.

*Grade.* The text gives ≈ 1.001 and measurement gives ≈ 389 (about 363–419), a factor of about 390. That is a COLLISION with the measured distances of the Sun and Moon.
- The ordering "moon nearer, with the moon between Earth and Sun at conjunction" AGREES with the measured geometry. It is the only part that does.
- *Price of clearing it, inside the text's own numbers* (arithmetic ours): R = 389 with the moon at 42,000 needs s ≈ 388 × 42,000 ≈ 1.6 × 10⁷ yojanas. That is about 13.6 times the whole cakkavāḷa's 1,203,450 (A23), so A23 would collide too. Alternatively h would have to be ≈ 0.13 yojana, which collides with A16's 42,000.

*Distinguishing measurement.* The Sun-to-Moon distance ratio: any two-baseline parallax, or the tabulated solar and lunar distances above. The text predicts equal parallax for Sun and Moon to within 0.13%. Measured parallaxes differ by a factor of about 389.

*Seen from outside.* A22 (sun and moon light three continents at one moment) and the stack revolving around Sineru mean the stack is over Jambudīpa only during its part of the day. This changes d, not the bound.

### (ii) Ratio of diameters. COLLIDES

*In plain English.* The sun-disc is 50 and the moon-disc 49 yojanas across (A17), and these are the same in length, breadth and height (A19). So the sun is 2% wider than the moon.

*In maths.*
- D☉/D☾ = 50/49 ≈ 1.0204.
- The commentary's circumferences corroborate this: 147 for the moon (*tīhi yojanehi ūnadiyaḍḍhasatayojano*) and 150 for the sun (`s0103a.att.xml:817`), so 150/147 = 1.0204.
- Accepted value, NASA fact sheets: volumetric mean radii Sun 695,700 km and Moon 1737.4 km, so diameters 1,391,400 km and 3,474.8 km. The sheets list radii, and the diameters are my doubling. 1,391,400 / 3,474.8 ≈ **400**.
- The text's 1.02 against measured ≈ 400: a factor of about 390. COLLIDES with the measured solar and lunar diameters.

*Joint closure (rule 2g).* (i) and (ii) are two collisions, each with a measurement already made (the distances of the two bodies; their diameters). No addition inside A0 that keeps A16, A17 and A19 clears them together. Anything that lets the Sun be ≈ 400 times larger or ≈ 389 times farther changes those axioms' numbers.
- The one exit is to drop B1 and let the measured bodies be something other than the vimānas. That leaves A16/A17 untested; it is not a rescue of them.
- The text's own alternative for eclipses (Rāhu, A18) bears on occultation and does not touch these ratios (rule 2b). Rāhu is not an exit.
- *Concession search:* I searched *ekūnapaññāsayojan* and *paññāsayojan*, which returned 11 and over 20 hits. Every disc-size hit gives 49 and 50, and I found no text with other disc sizes.
- A textual variation exists: the "goat, elephant and cow paths" (`s0103t.tik.xml:829`) say the discs descend or ascend from their usual path. No yojana amount is given, so it yields no ratio.

*Corollary from appearances (a collision that survives leaving A0).* The text's own angular ratio is θ☾/θ☉ ≈ (49/50) × R ≈ 0.98. The moon would always be the smaller disc, so there could be no total solar eclipse, and totalities are observed. I read no eclipse source in this run, so I give no value and cite none. This is not an AGREES from angular size; it is the opposite.

*Distinguishing measurement.* The Sun-to-Moon diameter ratio, from the measured distances and angular sizes (NASA values above).

### (iii) Does any text place a camera, as a cognizer, in a category of A36 or A61? No text places a camera. BRIDGE. UNDETERMINED.

*Search and control.* I searched *yantarūpa*, *dārumayayanta* and *aviññāṇaka*. The control passed (known-present term found, as above). Hits:
- Puppets (*yantarūpaka*) appear only as similes:
  - The body moves like a wooden puppet on strings, with no self-agent (ṭīkā `e0103n.att.xml:6273` on *dhātuyantaṃ*; `s0105t.nrf.xml:1137`).
  - Hell-wardens: some elders say there are none and that kamma acts "like a machine". The Kathāvatthu-based commentary rejects this (`s0203a.att.xml:2743` and parallels).
- None of these classes a camera.
- I also found no text that holds that a constructed artifact cognizes. For the other option I searched the Kathāvatthu: KV 18.9 (CST numbering) *Cakkhunā rūpaṃ passatīti kathā*, `abh03m3.mul.xml:12589` (Piṭaka), with the commentary at `abh03a.att.xml:5929`. The Mahāsaṅghikas hold that the sense-organ itself sees. The Theravādin's reductio is that matter (the organ) would then see matter, and would be mind-consciousness (*rūpaṃ manoviññāṇaṃ*), and would have adverting. The commentary says "sees with the eye" is idiom, as one "pierces with a bow" (*dhanunā vijjhati*) when it is the archer who pierces.

*Derivation, conditional on the bridge.* IF the camera is external matter (BRIDGE B2: its matter is not part of any being's kamma-born body), THEN:
- By A66, only two kalāpa kinds occur outside beings: the pure octad and the sound nonad, both temperature-born. No sensitive-organ kalāpa is external.
- By A62 and A65, the sensitive organs are internal, and the faculties are kamma-born only (reading: the five *pasāda* are the faculties). So the sensor holds no *cakkhupasāda*.
- By A36, the five sense doors are the sensitive organs, and the mind-door is the bhavaṅga, a moment of a stream, not an organ. A device matches neither.
- By A61, all matter is *anārammaṇa*, objectless. The camera cognizes nothing.

The result "no cognizer" holds only if B2 holds. If a text placed the sensor inside a being's body, the derivation would not apply. No text does.

*Grade.* EXTENDS (physics is silent on cognizer-status). The step that places the device into "external matter" is a BRIDGE, graded UNDETERMINED. **Distinguishing measurement: none — philosophy.** A camera's output is the same under either description, and the texts add no physical test.

I say nothing about any machine's inner life, and nothing here transfers to any computing system or model.

### (iv) Does any text place a human's viewing of a photographed image in the eye-door-object category of A37 and A63? No text mentions photographs. BRIDGE. UNDETERMINED.

*What the texts do place:*
1. **A mirror image is a rūpa and the range of eye-consciousness.** `abh05t.nrf.xml:2397` (layer other; the passage ends with *Antarābhavakathāvaṇṇanā* at `:2413`): the image is *rūpantaraṃ uppajjati*, arising from face and mirror (*bimbato ādāsato ca*, `:2405`), and "is to be accepted from its being the range of eye-consciousness" (*cakkhuviññāṇassa gocarabhāvūpagamanato*). The objector (`:2393`) calls the image *asiddha*, and the author answers that.
   - The Sammohavinodanī agrees in kind: the face-image is *nibhāsarūpa*, neither one's own face nor another's, depending on the mirror (`s0303a.att.xml:1123`, reported as *vadanti*).
   - A gloss on the Vibhāvinī (the author is not named in the layer I read) uses the mirror to say the sense-base is struck by *nimitta*, "not going itself" (`e0401n.nrf.xml:889`). That is the A63 shape: the object does not travel to the eye.
2. **An iddhi-made image is seen by eye as a form of its own.** `s0101a.att.xml:4609` quotes Nāgasena: the Buddha showed a *chāyārūpakamatta*. The king asks "is not seeing the image seeing the thing?" and Nāgasena answers *tiṭṭhatetaṃ* (leaving it aside). The ṭīkā (`s0101t.tik.xml:4129`) calls it *rūpakamattaṃ… buddhasantānato vinimuttaṃ*, a mere form detached from the Buddha's stream.
3. **Painted pictures delight the eye.** `abh01a.att.xml:8305`. A painting is a visible form.
4. **The discs' own radiance (*candamaṇḍalassa vaṇṇanibhā*) is listed under the visible-form base.** `abh01a.att.xml:8345`.

None of these is a photograph or a recording.

*Derivation, conditional on the bridge.* IF the printed or displayed pattern is visible form (BRIDGE B3, which rests on similarity to 1–3 above), THEN:
- By A37, the eye-door object at viewing is that present pattern, a *rūpāyatana*.
- The scene it was taken from is past. By A37 it can be an object only of the mind-door (past, `:1049`), as a recollection. Alternatively it is a concept (A104, A126, a designation on the visible forms).
- By A63 the eye takes the pattern without reaching it. A63 turns on the reading of "reached", and a photograph adds nothing that separates the readings.
- *Open point, not derived:* the texts' account of a reflection ties it to a face and mirror both present (`:2405`). A record that outlasts its subject has no text accounting for how an earlier scene fixes a later pattern. A66 says external matter conditions external matter co-nascently, and production by earlier matter is named only for nutriment.

*Grade.* The mirror and iddhi placements are textual. The photograph step is a BRIDGE, graded UNDETERMINED. The conclusion about an image of a past scene holds only if B3 holds. EXTENDS (physics is silent). **Distinguishing measurement: none — philosophy.** A63 itself is separately testable only through the reading of "reached", and that test is not new here.

*Extending the corpus hit.* `constituting-an-artificial-person.md` §9 (lines 303–321) says a person is a conventional designation on a selfless functioning process. The same logic applies to "camera" and "photograph". They are *paññatti* on assembled rūpa (A104, A126). They are not entries in the ultimate classes (A26) that A36 and A61 range over. The chariot simile covers the camera as a designation. It shows only that the question "is the camera a cognizer?" is posed at the designation level. At the ultimate level the answer is fixed by A61. This is a reading of the text, not a derivation. It makes no claim about the consciousness of any artifact beyond what A61 says of matter.

## 3. Collisions between the axioms themselves

- **A16 against the ṭīkā on the 42,000.** The ṭīkā (`e0104n.att.xml:405`) says the figure is for the first kappa and later "a few yojanas less". Harmless to the ratios.
- **The reference level is not given as Jambudīpa.** It is a reading (R above).
- **A20's 100,000 yojanas a day against A16's 50.5-yojana vertical separation.** I do not derive anything from this pair. I list it as a tension the main session may want checked, since a per-day horizontal gap of 10⁵ yojanas dwarfs the vertical gap of 50.5. No lunar-phase result is derived here.

## 4. Theses for the refuter (one line each)

1. T1. If B1 and the A16 geometry hold, 1 < Dₛ/Dₘ ≤ 1.0013 for every observer offset d.
2. T2. If B1 and A17 hold, D☉/D☾ = 50/49, and the circumference ratio 150/147 agrees with it.
3. T3. Against the NASA fact-sheet values, the distance ratio (≈ 389) and diameter ratio (≈ 400) each differ from the text's by a factor of about 390, so (i) and (ii) COLLIDE.
4. T4. Clearing (i) with the moon at 42,000 needs s ≈ 1.6 × 10⁷ yojanas, about 13.6 times A23's width, so it collides with A23. Clearing (ii) with the moon at 49 needs a sun of about 19,600 yojanas, which collides with A17.
5. T5. If a camera's matter is external (B2), then by A66, A62, A65, A36 and A61 it has no door and is objectless. This is UNDETERMINED as to whether any text places the camera so.
6. T6. KV 18.9 (`abh03m3.mul.xml:12589`) refutes "the organ itself sees". Applied to a sensor under B2 the same reductio holds, and no text holds the contrary for a Theravāda author.
7. T7. If the photographed image is visible form (B3), its viewing is an eye-door act on a present *rūpāyatana* (A37), and the photographed past is a mind-door object. UNDETERMINED as to whether any text places it so.
8. T8. The mirror-image placement (`abh05t.nrf.xml:2397`) is the nearest textual precedent for an image as the object of eye-consciousness.
9. T9. Leaving A0 (A0′) does not remove (i) or (ii), and the eclipse corollary survives it.

## 5. Formal statements (for Lean-checking)

**D1 (ratio of distances).**
- Hypotheses: A16 (moon below sun, 100-yojana span from the moon's lower edge to the sun's upper edge, ~42,000 up), A17 (49, 50), A19 (49 and 50 apply to height as well); reading R; B1.
- Conclusion: for all d ≥ 0 and h ≥ 41,000, 1 < √(d²+(h+50.5)²)/√(d²+h²) ≤ 1 + 50.5/h ≤ 1.0013.
- MODEL: ℝ², moon center at (0, 42000), sun center at (0, 42050.5), observer at (d, 0).
- NOT A DERIVATION: the comparison with ≈ 389.

**D2 (ratio of diameters).**
- Hypotheses: A17, A19.
- Conclusion: D☉/D☾ = 50/49 = 150/147.
- MODEL: ℚ, D☾ = 49, D☉ = 50.
- NOT A DERIVATION: the comparison with ≈ 400.

**D3 (price of clearing).**
- Hypotheses: A16, A23, B1.
- Conclusion: (h+s)/h = 389 forces s ≥ 388h ≈ 1.6 × 10⁷, which exceeds 1,203,450.
- MODEL: ℝ with h = 42,000.

**D4 (camera).**
- Hypotheses: A61, A62, A65, A66, A36; BRIDGE B2 (the camera's matter is external); reading: the *pasāda* are among the faculties of A65.
- Conclusion: the camera has no sense-door and no cognition.
- MODEL: a finite universe of kalāpas typed {octad, sound-nonad, eye-decad, …} with an origin predicate; a "camera" is a set of external-typed kalāpas.

**D5 (image viewing).**
- Hypotheses: A37, A63; BRIDGE B3 (the displayed pattern is visible form); the mirror-image text for the nearest precedent.
- Conclusion: the eye-door object of the viewing is the present pattern; the scene depicted is a mind-door object or a concept.
- MODEL: two-time record structure with a present display and a past scene.

## 6. Sources

- `/Users/siliconwat/Desktop/MA/SW/formal-abhidhamma/kala/AXIOMS.md`
- `/Users/siliconwat/Desktop/MA/TH/publications/defensive-publications/constituting-an-artificial-person.md` §9
- NASA NSSDC Moon fact sheet: https://nssdc.gsfc.nasa.gov/planetary/factsheet/moonfact.html
- NASA NSSDC Sun fact sheet: https://nssdc.gsfc.nasa.gov/planetary/factsheet/sunfact.html
- CST files read: `abh01a.att.xml` :8297–8357, `s0103a.att.xml` :810–840, `s0103t.tik.xml` :813–829, `e0102n.mul.xml` :467–479, `e0104n.att.xml` :399–411, `abh07t.nrf.xml` :977, :1045, :1049, :2133, :2165, `abh01m.mul.xml` :5285, `abh05t.nrf.xml` :2381–2413, `s0303a.att.xml` :1123, `e0401n.nrf.xml` :889, `abh03m3.mul.xml` :12589, `abh03a.att.xml` :5929, `s0101a.att.xml` :4609, `s0101t.tik.xml` :4129, `e0103n.att.xml` :6273, `s0105t.nrf.xml` :1137.
