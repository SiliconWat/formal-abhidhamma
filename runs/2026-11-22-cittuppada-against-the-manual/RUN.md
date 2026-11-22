# Run: cittuppada-against-the-manual (2026-11-22) — the Saṅgaha's association table against the Dhammasaṅgaṇī's 23 written lists

**Registered:** `PREREG.md`, pushed 2026-11-22T21:16:48Z (push `ea0376d`). The data — each fully written list's citta record (built from its feature words by declared
rules), its terms mapped onto the 52 (the pre-registered map of PREREGISTRATION-2026-09-27b.md §3, unchanged, plus a declared extension; none unmapped) and its open
clause — was committed before the registration (`ebea4f1`, `sangaha/CanonAll.lean` from `canon/allcanon.py`).
**Window:** A0′. **Axioms:** A30 A32 A33. **Instrument:** `sangaha/CheckCanonAll.lean`, held as three theorems in `sangaha/run.sh`, with three breaks that fail.
**Refuter:** not yet run — offered.

## VERDICT: **PASS** — P1 and P2 hold for all 23 written lists, and the control reproduces.

## Result

- **P1 — every factor the Dhammasaṅgaṇī lists, the Saṅgaha's rules give, in all 23 classes** (`every_listed_factor_is_the_manuals`): the four wholesome sense-sphere
  classes, the first supramundane path, the seven unwholesome, the rootless resultants (eye-, body-consciousness for both kammas; the mind-element; mind-consciousness)
  and the rootless functionals (the five-door and mind-door adverting, the smile-producing).
- **P2 — the Saṅgaha exceeds a written list only where the list is open** (*ye vā pana … aññepi atthi*) (`the_manual_adds_only_where_the_list_is_open`).
- **Control:** the first wholesome class gives 29 listed and 38 in the Saṅgaha — `sangaha/Canon.lean`'s known answer (`the_control`).

**What the Saṅgaha adds, class by class** (the factors the written list leaves to its open clause):

| Classes | Added |
|---|---|
| wholesome, sense sphere (4) | attention, decision, desire, equanimity (*tatramajjhattatā*), the three abstinences, compassion, appreciative joy |
| supramundane path | attention, decision, desire, equanimity — the abstinences are LISTED |
| greed with view (2) | attention, decision, desire, restlessness |
| greed without view (2) | the same and conceit |
| hate | attention, decision, desire, restlessness, envy, avarice, remorse |
| doubt | attention, restlessness |
| restlessness | attention, decision |
| rootless resultants and functionals | attention, and decision where it arises |

These are the factors the commentarial tradition calls *yevāpanaka* (supplied by "or whatever others"). **Not checked in this run:** that each class's added set equals
the Atthasālinī's own *yevāpanaka* for that class (the first class's nine are, `Canon.lean`); that is the next check.

**Breaks (each fails):** conceit added to the first wholesome list · the first list's open clause removed · the doubt citta built with greed as its root.

## Predictions scored

1. *P1, all 23:* **HIT.** 2. *P2, all 23:* **HIT.** 3. *The control:* **HIT.**

Text against text — the manual's rules against the Piṭaka's own lists; no measurement bears on it (*philosophy* in the mode's terms).
