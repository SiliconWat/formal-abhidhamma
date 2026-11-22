# PRE-REGISTRATION — dhatukatha-association

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-11-22
- **Question:** Does one association rule, with every item's dhammas as the Dhātukathā's FIRST method fixed them (dhatukatha/Check.lean, itemAtoms, unchanged), reproduce the SIXTH method's stated association and dissociation counts (abh03m1.mul.xml, the Chaṭṭhanayo, sections 1–6: aggregates, bases, elements, truths, faculties, dependent origination)? THE RULE, declared here before any count is computed: over the 22 kinds of Check.lean, a is ASSOCIATED with b iff a ≠ b, both are mental (feeling, perception, formations, the seven consciousnesses) and not both are consciousness (A30's four marks; A1: two cittas never together); a is DISSOCIATED from b iff exactly one of them is mental (matter and nibbāna the other side). An item X is associated with an aggregate, base or element G FULLY iff every dhamma of X is associated with every dhamma of G, PARTIALLY (the text's kehici) iff some pair is and not all; dissociation alike. An unstated component of an answer is 0; Natthi is all 0. SEEN while designing the rule: the answers at L1201, L1205, L1209 (the five aggregates) — reported apart, not evidence.
- **Window:** both
- **Instrument:** `SiliconWat/formal-abhidhamma` at `42e0e03` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |
| A0′ | Citta with its cetasika (four marks of association: arising, ceasing, object, base together — A30) is a window onto consciousness (inward). *nāma-kalāpa* is Pa-Auk usage, not the texts'. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A1 | One mind-moment at a time in a stream: *dve cittāni ekato nappavattanti*, "two cittas do not occur together", even for Buddhas. ⭐ Lifted 2026-09-30: in the Kathāvatthu it is a premise BOTH parties hold. The Theravādin's reductio "would two contacts … two cittas come together?" is refused by the opponent; the commentary identifies the two contacts as ear-contact and mind-contact | commentarial + Piṭaka (Kathāvatthu, as a shared premise) | `s0505a.att.xml:685`; also `s0203a.att.xml:913` (if two arose together, one could know the other's arising — it cannot); KV 2.5 *Vacībhedakathā* `abh03m3.mul.xml:4329` (also `:5085`, `:5089`); KV-a `abh03a.att.xml:3333` (opponent: the Pubbaseliyas, `:3325`) | VERIFIED | `Stream.one_at_a_time` |
| A30 | The four marks of association: a cetasika arises with citta, ceases with it, takes the same object and has the same base (*ekuppādanirodhā ca, ekālambaṇavatthukā*) | manual | Saṅgaha ch. 2 §1, `abh07t.nrf.xml:329` | VERIFIED | — |
| A62 | Matter's dyads: internal (the five sensitive organs) or external; base or not; door or not; faculty or not; **gross, near and impinging** (the 12 organs and objects) or **subtle, far and non-impinging**; clung-to (kamma-born) or not; visible (visible form only) or invisible | manual | Saṅgaha ch. 6 §19–25, `abh07t.nrf.xml:2137–2161` | VERIFIED | — |
| A68 | By plane: all 28 kinds in the sense sphere; 23 in the fine-material (no nose, tongue, body or sex, and no nutriment-born groups); 17 for the non-percipient (the vital nonad at rebirth, and temperature-born matter except sound); **none in the immaterial** | manual | Saṅgaha ch. 6 §58–61, `abh07t.nrf.xml:2345–2369` | VERIFIED | — |
| A74 | The whole: 5 aggregates, 5 aggregates of clinging, 12 bases, 18 elements, 4 noble truths. **Nibbāna is outside the aggregates.** 69 dhammas (52 cetasikas, 16 subtle matter, nibbāna) make up the mind-object base and element; the mind-base divides into the seven consciousness elements | manual | Saṅgaha ch. 7 §42–53, `abh07t.nrf.xml:2673–2737` | VERIFIED | — |

## Predictions

1. Every association and dissociation answer of method 6 §1–6, full and partial, for every item whose dhammas Check.lean fixed WITHOUT fitting, is reproduced, apart from the three seen rows.
2. Any answer not reproduced is reported with its line and with what it bears on — the rule or an item's interpretation — and neither is changed to fit before the result is reported.

## Pass criteria for the instrument

- PASS: every unseen, unfitted row reproduced: the rule is CONSISTENT with the sixth method's sections 1–6 (consistent, not derived: the rule is ours, its inputs A1 and A30 the texts').
- A miss is a FINDING, reported as it stands; a revised rule is a new run.
