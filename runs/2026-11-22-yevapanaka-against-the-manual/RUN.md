# Run: yevapanaka-against-the-manual (2026-11-22) — what the Saṅgaha adds is the Atthasālinī's yevāpanaka, fixed and variable

**Registered:** `PREREG.md`, pushed 2026-11-23T02:33:21Z (push `28c5eb3`), as a **CHECK**: run `cittuppada-against-the-manual`'s refuter had already checked P1
by hand, and this session read every cited line while building the data. The data — `sangaha/Yevapanaka.lean`, by `canon/yevapanaka.py` — was committed before the
registration; the generator checks each of its 53 quotes at the cited CST line before it writes anything (a planted wrong quote and a falsely "implicit" class are
refused).
**Window:** A0′. **Axioms:** A30 A32 A33. **Instrument:** `sangaha/CheckYevapanaka.lean`, held as four theorems in `sangaha/run.sh`, with a harness control and four
breaks that fail. **Refuter:** see `REFUTER-2026-11-22.md`.

## VERDICT: **PASS** — P1 and P2 hold in all 23 classes, and P3 as stated.

## Result

- **P1 — what the Saṅgaha's rules add to each written list is EXACTLY the Atthasālinī's yevāpanaka, as sets, in all 23 classes**
  (`the_added_are_the_yevapanaka`). Run 4 had checked only that each list is inside the Saṅgaha's set, and named the added factors without comparing them (its RUN.md:
  "not checked in this run"); its refuter checked them by hand. Here the equality is a theorem, tallied by how the commentary gives each set (`by_kind`):

  | Kind | Classes | Where |
  |---|---|---|
  | named | 8 — the first wholesome (the nine) · greed with view · greed without view (with conceit) · hate · doubt · restlessness · eye-consciousness · the mind-element | `abh01a.att.xml:5045`, `:7121`, `:7217`, `:7265`, `:7297`, `:7313`, `:7349`, `:7369` |
  | by subtraction | 1 — the supramundane path: the nine minus the abstinences (listed in its Pāli) and compassion and appreciative joy (they take beings as object, the path nibbāna) | `:6621` |
  | by reference | 13 — the other wholesome, the other greed classes, body-consciousness, investigating, the unwholesome-kamma resultants, the functional mind-element, smile-producing, mind-door adverting | `:5473`, `:5509`, `:7233`, `:7241`, `:7357`, `:7373`, `:7793`, `:7817`, `:7837`, `:7841` |
  | implicit | 1 — the fifth wholesome (equanimity, with knowledge): its commentary states only its differences | `:5497` |

- **P2 — the VARIABLE yevāpanaka are the Saṅgaha's occasional factors, in all 23** (`the_variable_are_the_occasional`): the wholesome nine, four at one moment and the
  rest — the three abstinences, compassion, appreciative joy — at different moments (`:5053`, *sesā nānākkhaṇe*); the hate class, four fixed and envy, avarice,
  remorse variable (`:7265`, *aniyatayevāpanakā*); conceit in the two greed-without-view classes, as the Mūlaṭīkā reads `:7217` (`abh01t.tik.xml:1729`: *Mānassa
  aniyatattā na niyatayevāpanakā*). Against the Saṅgaha ch. 2 §33 (`abh07t.nrf.xml:553`, `:557`: *Issāmaccherakukkucca-viratikaruṇādayo; Nānā kadāci māno ca*).
- **P3 — on its surface, `:7217` differs from §33 in exactly the two greed-without-view classes, and only on conceit** (`the_surface_differs_on_conceit_only`).
  *Idha mānena saddhiṃ pañca apaṇṇakaṅgāni honti* reads as conceit among the SURE factors (*apaṇṇakaṅga* is the commentary's word for the four that always arise,
  `:5053`, `:7121`); the Mūlaṭīkā reads it as *avirajjhanakaṅgāni uppattiarahaṅgāni* — factors fit to arise — and says conceit is not fixed, citing the Paṭṭhāna's
  combinations of the fetters (`abh01t.tik.xml:1729`). The Anuṭīkā gives the reason (`abh04t.nrf.xml:1717`): were conceit fixed, sense-passion would never occur
  without it, and the Paṭṭhāna's tenfold combination of the fetters would be eightfold; it cites the Atthasālinī's own later passage, where the unprompted
  greed-without-view class arises both with conceit and without it (*dha. sa. aṭṭha.* 1485, quoted at `:1721`). The tradition resolves the difference itself; nothing
  in A32 is touched.

**Breaks (each fails; the harness control passes first):** attention dropped from eye-consciousness's yevāpanaka · conceit allowed with view too (R11 widened) · the
hate class's envy, avarice and remorse read as fixed · the Mūlaṭīkā's reading dropped (conceit fixed in the third unwholesome class).

## Two corrections to what was carried forward (roadmap A686(b), from run 4's refuter)

1. **"Envy, avarice and remorse VARIABLE (`:5053`)" — the line is `:7265`.** `:5053` is about the first wholesome class's nine (four at one moment, the rest at
   different moments).
2. **"Conceit among five FIXED factors (`:7217`)" is the surface reading only.** The Mūlaṭīkā on that very line reads conceit as variable; with its reading, the
   commentary and the Saṅgaha agree in all 23 classes (P2).

## What limits it

- **A check, not a prediction:** every answer here was displayed before the registration (run 4's refuter; this session's reading of the lines).
- **The reference chain is our reading of the commentary's cross-references.** Thirteen classes take their set from another class through a phrase that refers back
  (*sadisameva*, *vuttanayeneva*, *pākatikameva*); the generator checks the phrase stands on the line, not that it covers the yevāpanaka rather than the rest of the
  analysis. One class (`:5497`) has no such phrase at all and is marked implicit.
- **Variable is recorded only where the commentary speaks.** A class it says nothing about is given no variable factor; in all such classes the Saṅgaha's rules
  add no occasional factor either, so nothing is hidden by the default — but it is a default.
- **The 23 lists only.** The prompted classes (whose lists the Dhammasaṅgaṇī elides) carry sloth and torpor among the unwholesome yevāpanaka (`:7121`, `:7285`); they
  are not tested.
- Rules.lean has no notion of fixed and occasional; P2 compares the commentary with §33's list as DATA. A32 is unchanged.

## Predictions scored

1. *P1, all 23, tallied 8 · 1 · 13 · 1:* **HIT.** 2. *P2, all 23, as the Mūlaṭīkā reads `:7217`:* **HIT.** 3. *P3, the surface reading differs in 3617 and 3665
only, on conceit:* **HIT.** 4. *A miss reported, nothing changed to fit:* **NOT TRIGGERED**.

Text against text — the manual's rules against the commentary's own sets; no measurement bears on it (*philosophy* in the mode's terms).
