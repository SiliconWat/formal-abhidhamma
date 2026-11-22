# Run: dhatukatha-association (2026-11-22) — one association rule against the Dhātukathā's sixth method

**Registered:** `PREREG.md`, pushed 2026-11-22T17:30:14Z (push `12b8105`), with the rule written out in full, before any count was computed.
**Window:** both (association is of mind with mind; dissociation of mind from matter and nibbāna). **Axioms:** A1 A30 A62 A68 A74.
**Instrument:** `dhatukatha/sampayoga.py` (the sixth method's inner list as data, read with the first method's own item matcher), `dhatukatha/CheckSampayoga.lean`
(the registered rule, computed by Lean; the tally held as a theorem in `dhatukatha/run.sh`). **Refuter:** not yet run — offered.
**Scope note:** the pre-registration says "sections 1–6", the FIRST method's numbering of the inner list; the sixth method numbers the same items §1–4 (Khandho, Āyatanaṃ,
Dhātu, Saccādi). From its §5 (Tikaṃ) it turns to the matrix, whose items have no dhamma sets in `Check.lean`, and those are outside this run. Nothing else was narrowed.

## VERDICT: **FAIL** — the registered rule reproduces 17 of 55 unseen rows; a finding (its diagnosis refuted in part, `REFUTER-2026-11-22.md`).

## Result

| Rows | Reproduced by the registered rule |
|---|---|
| unseen, unfitted (the test) | **17 of 55** |
| seen while designing (L1201, L1205, L1209) or fitted in the first method | 7 of 13 (not evidence) |

**The rule as registered is NOT consistent with the sixth method's inner list.** Every one of the 38 misses traces to one of two causes:

1. **A mental item narrower than its kind (35 rows).** `Check.lean` files every formation under one kind (and every feeling under another), which co-arises with all
   seven consciousness elements. The text says otherwise, item by item: craving (*samudaya*), the path, ignorance, the four mental feelings of grief and pain, and most
   formations are associated with ONE consciousness element (mind-consciousness, or body-consciousness for bodily pleasure and pain) and dissociated from SIXTEEN
   (the ten material and six other consciousness elements); equanimity with SIX (not body-consciousness); decision (*adhimokkha*) with TWO (the mind-element and
   mind-consciousness); contact, volition and attention with all seven. And such an item is PARTLY associated with its own aggregate — its fellow formations are
   associated with it, itself is not (*kehici*, the text's `(1, 1, 1)`).
2. **Consciousness with consciousness (3 rows).** The registered rule made two different consciousnesses neither associated nor dissociated. The text makes each
   consciousness element DISSOCIATED from the other six (eye-consciousness: 16 elements) — they never arise together (A1).

## Predictions scored (against `PREREG.md`)

1. *Every unseen, unfitted row reproduced:* **MISSED** — 17 of 55.
2. *Misses reported with their lines and what they bear on, nothing changed to fit:* **HIT** — the rule in `CheckSampayoga.lean` is the registered rule; the 38 misses are
   printed by Lean (`#eval`) and traced above.

**Pass criteria:** the PASS condition is **not met**; under the second criterion the miss is a FINDING, reported as it stands.

## What it bears on, and the next run

Both causes can be DERIVED, not fitted: (1) which consciousness elements a mental factor can arise with follows from the Saṅgaha's association rules (A32, formalized in
`kala/`, which reproduce all 89 and 121 cittas) mapped onto the seven consciousness elements; (2) consciousness-with-consciousness dissociation follows from A1. A
revised rule is a NEW pre-registered run, with these derivations fixed before the counts are computed. Text-internal: no measurement bears on it (*philosophy* in the
mode's terms — a test of the manual's classification against the Piṭaka's own counts).
