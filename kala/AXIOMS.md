# AXIOMS — the one home of Abhidhamma mode's axioms

Every run of Abhidhamma mode (`runs/`) names its axioms by the IDs below and nothing else. The Lean
definitions they correspond to live in `Axioms.lean`. If an axiom changes, it changes HERE, and a run
that used the old wording keeps its own copy in its `PREREG.md`.

**Status** says how the citation was checked:
- **VERIFIED** — read at the cited line in the local Chaṭṭha Saṅgāyana (CST) files, or fetched.
- **RECALLED** — cited from knowledge, not yet read. A run may use a RECALLED axiom only if its
  pre-registration says so (`prereg.sh --allow-recalled`), and the run report must repeat the word.
- **RULED** — a founder ruling of this program, not a textual claim.

**Tier** — Piṭaka · commentarial (aṭṭhakathā) · sub-commentarial (ṭīkā) · manual (Abhidhammattha-saṅgaha) ·
ours. `[X]` marks a cross-tradition import. CST file layers: `*.mul` mūla (Piṭaka) · `*.att` aṭṭhakathā ·
`*.tik` ṭīkā · `*.nrf` other (includes the Saṅgaha and its commentaries). Line numbers are in the
UTF-16 CST files as decoded by `cst.py`; ⚠️ a plain `grep` over them returns nothing.

## Axiom zero — the window, declared per run

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |
| A0′ | Citta with its cetasika (four marks of association: arising, ceasing, object, base together) is a window onto consciousness (inward). *nāma-kalāpa* is Pa-Auk usage, not the texts'. | a CHOICE, declared per run |

## Axioms

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A1 | One mind-moment at a time in a stream: *dve cittāni ekato nappavattanti*, "two cittas do not occur together", even for Buddhas | commentarial | `s0505a.att.xml:685`; also `s0203a.att.xml:913` (if two arose together, one could know the other's arising — it cannot) | VERIFIED (commentarial); ⏳ a Kathāvatthu debate would lift it to Piṭaka | `Stream.one_at_a_time` |
| A2 | No first point of beings' wandering is DISCERNED: *pubbā koṭi na paññāyati* — epistemic wording | Piṭaka | SN 15.1 (SuttaCentral bilara, fetched 2026-09-30); commentary `s0302a.att.xml:2489` (*aviditaggo … aparicchinnapubbāparakoṭiko*); ṭīkā `s0302t.tik.xml:2537` (*dīghatamattā*) | VERIFIED | — (see C) |
| A2b | Past world-cycles are *na sukarā saṅkhātuṃ*, not easy to count | Piṭaka | SN 15.8, `s0302m.mul.xml:3565` | VERIFIED | — |
| A3 | Proximity (*anantara*): each moment conditions its immediate successor; it holds "even across many thousands of kappas — not remoteness in time" (death-moment → rebirth) | Piṭaka (Paṭṭhāna, quoted) + other | Paṭṭhāna niddesa quoted at `abh03a.att.xml:7693`; across kappas `abh05t.nrf.xml:2409` | VERIFIED (quoted; ⏳ the mūla Paṭṭhāna file itself) | `Stream.tick_succ`, `Stream.continues` |
| A4 | Most matter lasts **17** mind-moments — ⚠️ CONTESTED in the tradition: the ṭīkā records the aṭṭhakathā's **16⅓** (*tatiyabhāgādhika-soḷasa*) | sub-commentarial (17) vs commentarial (16⅓) | `abh02t.tik.xml:277`, `:309`, `:4897` | VERIFIED | `lifespan` |
| A5 | The space element is *paricchedarūpa*: the delimitation between kalāpas, keeping them unmixed; it has no nature of its own (*anipphanna*) | manual + its commentary | Saṅgaha ch. 6: `abh07t.nrf.xml:2085` (*ākāsadhātu paricchedarūpaṃ nāma*), gloss `:5821` | VERIFIED | `between` |
| A6 | Matter outside a being's faculties is *anindriya-baddha*, bound to no being; it is "external" together with nibbāna | commentarial (Atthasālinī) | `abh01a.att.xml:3485`, `:9785` | VERIFIED | — |
| A7 | Time (*kāla*) is designated on the occurrence of dhammas and is "a mere concept, not existing by its own nature" (*paññatto kālo … sabhāvato avijjamānattā paññattimattako*) | commentarial (Atthasālinī) | `abh01a.att.xml:3721` | VERIFIED | `Stream.tick` (a function ON moments, never a moment) |
| A8 | Time-free (*kālavimutta*) = *nibbānaṃ, paññatti ca*: nibbāna AND concepts. Nibbāna is unconditioned and cannot be produced; it enters a stream only as the OBJECT of the path-moment | manual + Vibhāvinī | Saṅgaha ch. 8 §37 (memory §abhidhamma-mode; paper `abhidhamma-and-discrete-quantum-gravity` :77) | VERIFIED (via the paper) | `Object`, `nibbana_is_not_a_moment` |
| A9 | Space is CONDITIONED (Theravāda, not Sarvāstivāda) | RULED | founder 2026-09-27 | RULED | — |
| A10 | The kappa has four phases; world-destruction is LOCAL (*ekaṃ buddhakkhettaṃ vinassati*) and spares the higher realms by kind: fire below Ābhassara · water below Subhakiṇha · wind below Vehapphala | Piṭaka (phases) + commentarial (limits) | phases AN 4.156 (RECALLED); limits `vin01a.att.xml:2813`, Vism XIII `e0102n.mul.xml:729` | limits VERIFIED; phases RECALLED | — |
| A11 | Realms differ in DAY-LENGTH and lifespan (50 human years = one day and night of the Four Great Kings; 200 = one of the Yāma devas) — conventional *kāla* only, ⛔ not citta rates | Piṭaka | Vibhaṅga §1023, `abh02m.mul.xml:13221`, `:13229` (cross-ref "a. ni. 3.71" in CST numbering = AN 3.70 elsewhere) | VERIFIED | — |
| A12 | Cross-stream link: the COLOUR of mind-born matter (17 moments), ⛔ never the one-moment intimation, can be the pre-nascent object of another stream's eye-process | commentarial | Saṅgaha ch. 6 | RECALLED | — |
| A13 | Mindless beings (*asaññasatta*): matter only, a life faculty and no mind; arūpa streams: mind with no matter | Piṭaka + commentarial | Vibhaṅga `abh02m.mul.xml` (2 hits); commentary `abh02a.att.xml:3129`, `:9249` | VERIFIED | — |
| A14 | Sineru (Meru), king of mountains, is 84,000 yojanas long and 84,000 wide, and rises 84,000 above the great ocean, which is 84,000 yojanas deep | Piṭaka (sutta, quoted) + sub-commentarial | quoted at `abh04t.nrf.xml:1997` (*"sineru, bhikkhave, pabbatarājā caturāsīti yojanasahassāni āyāmena …"*; ⏳ the sutta's own locus, AN 7.66 RECALLED); ocean depth `abh01a.att.xml:413` | VERIFIED (quoted) | — |
| C | Conditionality: every moment has an immediate predecessor that conditions it; ignorance is not an uncaused root-cause of the world (*na akāraṇaṃ*) | Piṭaka (A3) + Vism XVII §584 | `e0102n.mul.xml:3553` | VERIFIED | `Conditioned`, `beginningless` |
| K | The last kamma-born matter arises at the 17th moment before death, counting death, and ceases with it | commentarial | Saṅgaha ch. 6 | RECALLED | `space_ends_with_the_stream` hypothesis |

## How to check a citation

```
python3 .claude/skills/abhidhamma/cst.py --control              # must PASS before trusting any zero
python3 .claude/skills/abhidhamma/cst.py "kālo nāma" --files "abh01*"
```
