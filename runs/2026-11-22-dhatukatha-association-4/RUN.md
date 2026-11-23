# Run: dhatukatha-association-4 (2026-11-22) — run 3's rule over every matrix class a stated criterion admits

**Registered:** `PREREG.md`, pushed 2026-11-23T02:23:19Z (push `5e11514`). The inputs were committed before the registration (`f8906cc`): `dhatukatha/classes4.py` reads
the SCOPE from the Dhammasaṅgaṇī's own definitions (its Nikkhepa, `abh01m.mul.xml:7017–7309`) by the criterion stated in the registration, and
`dhatukatha/sampayoga_matrix4.py` wrote the sixth method's rows for the admitted classes WITHOUT displaying them (it prints only how many rows it wrote).
**Window:** A0′. **Axioms:** A1 A30 A33 A74 A130 A131 A132 (A132(d): a class of many dhammas is not associated with the groups it contains).
**Instrument:** `dhatukatha/CheckSampayoga4.lean` (run 3's `rule3`, copied word for word as `rule4`), held as three theorems in `dhatukatha/run.sh`, with a harness control
and four breaks that fail. **Refuter:** see `REFUTER-2026-11-22.md`.

## VERDICT: **PASS** — 5 of 5 blind class-rows reproduced; the 11 seen class-rows too, reported apart.

## What the scope is, and why

Run 3's refuter (finding 5) found its ten classes chosen without a stated criterion. Here the criterion is read from each class's definition, not chosen: each reading
(a clause closing *– ime dhammā <the class>*) gets a shape from its own words, and a class is admitted only when every reading gives one mental shape.

| Outcome | Classes (§5 line) |
|---|---|
| **IN, blind** | *savitakkasavicārā* (L1361, vitakka AND vicāra set aside) · *hīnā*, *sammattaniyatā* (L1393) · *vipākadhammadhammā*, *saṃkiliṭṭhasaṃkilesikā* (L1349, as to bases and elements) |
| **IN, seen** | *kusalā*, *akusalā* (L1333, run 1) · *avitakkavicāramattā* (L1365, run 3's rapture row) · *dassanena pahātabbā*, *bhāvanāya pahātabbā*, *dassanena pahātabbahetukā*, *bhāvanāya pahātabbahetukā*, *ācayagāmino*, *apacayagāmino*, *sekkhā*, *asekkhā* (L1381, run 3's *mahaggatā* row) |
| OUT, defined by object (10) | *parittārammaṇā*, *mahaggatārammaṇā*, *appamāṇārammaṇā*, *maggārammaṇā*, *atītārammaṇā*, *anāgatārammaṇā*, *paccuppannārammaṇā*, *ajjhattārammaṇā*, *bahiddhārammaṇā*, *ajjhattabahiddhārammaṇā* — their elements need the rules of object, not in the inputs |
| OUT, mixed with matter or the unconditioned (8) | *nevavipākanavipākadhammadhammā*, *anupādinnupādāniyā*, *anupādinnaanupādāniyā*, *asaṃkiliṭṭhaasaṃkilesikā*, *avitakkaavicārā*, *appamāṇā*, *paṇītā*, *anuppannā* — the rule has no mixed shape |
| OUT, readings that disagree (2) | *maggahetukā* (all four · a formation set aside) · *maggādhipatino* (object · a formation set aside) |
| OUT, unclassified (1) | *micchattaniyatā* (defined by the five heinous kammas and fixed wrong view, not by aggregates or cittas) |
| OUT, tested in run 3 (10) | its ten classes |

## Result

- **L1361, *savitakkasavicārā* — the one tuple no seen row had.** Two formations set aside, and the elements of the classes whose written lists hold vitakko and
  vicāro (the Cittuppāda): the mind-element and mind-consciousness. Predicted and found: associated with nothing wholly; partly with the formations aggregate, the
  dhamma base and the dhamma element (through vitakka and vicāra); dissociated wholly from the form aggregate, the ten material bases and **15** elements; partly
  from the dhamma base and element.
- **L1393, *hīnā* and *sammattaniyatā*; L1349, *vipākadhammadhammā* and *saṃkiliṭṭhasaṃkilesikā*** (all four, mind-consciousness only): associated with nothing;
  dissociated wholly from 1 aggregate, 10 bases and 16 elements, partly from the dhamma base and element — as predicted.
- **The seen rows** (L1333, L1365, L1381; 11 class-rows) reproduce under the same rule, the composition now read by the criterion, not by hand.
- `every_admitted_class_has_its_row`: all 16 admitted classes have their row — none dropped between the scope and the data.

**Breaks (each fails; the harness control passes first):** *savitakkasavicārā* given mind-consciousness only · *savitakkasavicārā* read as all four (its set-aside
ignored) · *hīnā* given every consciousness element · A132(d) dropped (an all-four class partly associated, as a single dhamma is).

## What limits it

- **The blindness is partial, and was declared before the run.** Seen: run 3's files (its refuter said these classes "would pass"; L1365 shares the rapture
  tuple; the commentary it quotes, `abh03a.att.xml:421–429`, says the "abandoned by seeing" classes are like the wholesome), and — displayed in error by this
  session's own name-listing script, which cut each subject at the first count word, so a subject ending in *…pe…* let the opening of its answer through — L1349's
  "associated: none; dissociated from one aggregate". The blind content is L1361 and L1393 in full, and L1349's bases and elements.
- **Most of the blind content is one constant.** Every all-four class here has mind-consciousness as its only element (every wholesome, unwholesome, path and fruit
  class in the Cittuppāda is a mind-consciousness), so four of the five blind class-rows are the tuple of *mahaggatā*, seen in run 3. **The genuinely new prediction
  is L1361**: the formation-set-aside shape with TWO elements (15), which no seen row has.
- **The criterion carries one reading of ours:** *taṃsamuṭṭhānaṃ kāyakammaṃ, vacīkammaṃ, manokammaṃ* read as volitions (mental), not as bodily or vocal matter. It
  decides whether *saṃkiliṭṭhasaṃkilesikā*, *hīnā* and the "abandoned" classes are all four or mixed; L1333 (*akusalā*, whose definition carries the same words) was
  seen to have the all-four row in run 1, so this reading is not independent of a seen row.
- **The scope script's first version dropped two names** (*vipākadhammadhammā*, *nevavipākanavipākadhammadhammā*: one-word names in *-dhammā*); caught before the
  commit by comparing the per-row name count with the subject listing. The inputs' commit message says "23 OUT"; it is 21 (plus run 3's ten) — noted in the
  registration.
- The rule and the convention (A130, A131, A132) are run 3's, unchanged; their limits (run 2's and run 3's refuters) carry over.

## Predictions scored

1. *L1361, savitakkasavicārā: (0,0,0) · (1,1,1) · (1,10,15) · (0,1,1):* **HIT.**
2. *L1349 ×2 and L1393 ×2, all four: (0,0,0) · (0,0,0) · (1,10,16) · (0,1,1):* **HIT** (4 of 4).
3. *The seen rows reproduce, reported apart:* **HIT** (11 of 11).
4. *A miss reported, nothing changed to fit:* **NOT TRIGGERED**.

**Pass:** met — all five blind class-rows reproduced, by a scope read from the definitions. Text against text; no measurement bears on it (*philosophy* in the mode's
terms).
