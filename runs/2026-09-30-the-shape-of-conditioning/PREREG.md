# PRE-REGISTRATION — the-shape-of-conditioning

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-09-30
- **Question:** The Paṭṭhāna's 24 conditions (A78) do not form one order. Proximity, contiguity, absence and disappearance link each citta to the next (A3, A82, A99, A100), and contiguity holds across cessation without immediacy in time (A112); co-nascence and mutuality link things arisen together, both ways (A83, A84); pre-nascence links organ and object already arisen to a later consciousness (A87); post-nascence links a later citta to the body that arose before it, and with pre-nascence makes a two-cycle between the heart-base and the mental aggregates (A84, A88); kamma links across time (A90); a future dhamma can be the object of a present citta (A80, A88). kala/Patthana.lean checks in a toy model that the whole relation is not antisymmetric, runs forward, within a moment and backward in order of arising, and that proximity alone is a strict order. Causal set theory takes physical causal structure to be a locally finite partial order (Bombelli, Lee, Meyer and Sorkin 1987). Presuming the texts, what must physical causal structure be for the Paṭṭhāna to describe it — what must physics add to a causal order — and is there a measurement?
- **Window:** both
- **Instrument:** `SiliconWat/formal-abhidhamma` at `1e33526` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)


## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |
| A0′ | Citta with its cetasika (four marks of association: arising, ceasing, object, base together — A30) is a window onto consciousness (inward). *nāma-kalāpa* is Pa-Auk usage, not the texts'. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A3 | Proximity (*anantara*): each moment conditions its immediate successor; it holds "even across many thousands of kappas — not remoteness in time" (death-moment → rebirth) | Piṭaka (Paṭṭhāna, quoted) + other | Paṭṭhāna niddesa quoted at `abh03a.att.xml:7693`; across kappas `abh05t.nrf.xml:2409` | VERIFIED — mūla Paṭṭhāna `abh03m7.mul.xml:85–89` (*purimā purimā … pacchimānaṃ pacchimānaṃ … anantarapaccayena paccayo*), read 2026-09-30 | `Stream.tick_succ`, `Stream.continues` |
| A78 | The 24 conditions, enumerated: root, object, predominance, proximity, contiguity, co-nascence, mutuality, support, decisive support, pre-nascence, post-nascence, repetition, kamma, result, nutriment, faculty, jhāna, path, association, dissociation, presence, absence, disappearance, non-disappearance | Piṭaka + manual | Paṭṭhāna uddesa `abh03m7.mul.xml:37`; Saṅgaha ch. 8 §14, `abh07t.nrf.xml:2841` | VERIFIED | — |
| A80 | Object (*ārammaṇa*): visible form conditions eye-consciousness, and so on for each sense; the five sense objects condition the mind-element; **any dhamma can condition mind-consciousness**. Whatever a citta arises taking as object conditions it | Piṭaka | `abh03m7.mul.xml:49–53` | VERIFIED | — |
| A82 | Contiguity (*samanantara*): the same relata as proximity, each citta to the next. ⚠️ The Saṅgaha counts proximity, contiguity, absence and disappearance as one fact told four ways: the citta that has just ceased conditions the present one | Piṭaka + manual | `abh03m7.mul.xml:101–133`; Saṅgaha ch. 8 §16, `abh07t.nrf.xml:2861` | VERIFIED | — |
| A83 | Co-nascence (*sahajāta*): the four mental aggregates condition one another, as do the four great elements, and **mind and matter at conception**; citta and cetasikas condition mind-born matter; the great elements condition derived matter; matter conditions mind "at one time, and at another not" | Piṭaka | `abh03m7.mul.xml:137` | VERIFIED | — |
| A84 | Mutuality (*aññamañña*): the four mental aggregates, the four great elements, and mind-and-matter at conception each condition the others. ⚠️ OURS: this relation is symmetric, so conditioning as a whole is not a partial order. It is not the only cycle: the heart-base conditions the mental aggregates by pre-nascence and they condition it by post-nascence, "helpers of their helper", which the Mūlaṭīkā denies is mutuality. Proximity is one strict order among several one-way conditions (pre-nascence, post-nascence, repetition) | Piṭaka + sub-commentarial | `abh03m7.mul.xml:141`; Mūlaṭīkā `abh03t.tik.xml:4317` | VERIFIED | `Patthana.lean` `conditioning_not_antisymmetric` |
| A87 | Pre-nascence (*purejāta*): **the five sense organs and the five objects, already arisen, condition the consciousness that takes them**; the heart-base conditions the mind-element, and conditions mind-consciousness "at one time, and at another not" | Piṭaka | `abh03m7.mul.xml:169–177` | VERIFIED | — |
| A88 | Post-nascence (*pacchājāta*): **citta and cetasikas arising later support this body, which arose before them**. Not retrocausation, and the texts say so themselves: the Vibhāvinī raises the objection (*kathaṃ pana … pacchājātassa paccayatā?*) and answers that it supports a body still present; it sustains, it does not produce (the vulture-chicks' bodies kept by their wish for food, Paṭṭhāna-aṭṭhakathā); post-nascence is one of the five kinds of presence condition (ch. 8 §34). ⚠️ Separately, the Paṭṭhāna does let FUTURE dhammas condition present ones as OBJECT (knowledge of the future, `abh03m8.mul.xml:14089`) | Piṭaka + commentarial + manual's commentary | `abh03m7.mul.xml:181`; Vibhāvinī `abh07t.nrf.xml:6717`; Paṭṭhāna-aṭṭhakathā `abh03a.att.xml:7729`; Saṅgaha ch. 8 §34 `:2933–2941` | VERIFIED | `Patthana.lean` `postnascence_supports_a_present_body` (BY CONSTRUCTION) |
| A90 | Kamma: wholesome or unwholesome kamma conditions the resultant aggregates and kamma-born matter, **across time** (*nānākkhaṇika*, the Saṅgaha's word); volition conditions its associated states and their matter at the same time | Piṭaka + manual | `abh03m7.mul.xml:189`; Saṅgaha ch. 8 §17, `abh07t.nrf.xml:2865` | VERIFIED | — |
| A99 | Absence (*natthi*): **the citta and cetasikas that have just ceased condition the present ones by their absence** | Piṭaka | `abh03m7.mul.xml:241` | VERIFIED | — |
| A100 | Disappearance (*vigata*): the citta and cetasikas that have just disappeared condition the present ones | Piṭaka | `abh03m7.mul.xml:245` | VERIFIED | — |
| A112 | **Proximity holds across cessation.** For one emerging from cessation, neither-perception is the proximity (and contiguity) condition of the fruition attainment. Reported, NOT ours: the commentaries identify it as the neither-perception before cessation, "ceased for seven days or so" (Vibhāvinī); proximity holds because no immaterial dhamma intervenes, and matter, being another continuum, makes no interval, nor does absence (Mūlaṭīkā). ⭐ **The texts state the order/time split themselves**: Buddhaghosa — "by the power of development there is no temporal immediacy there; we say this too" — so contiguity is NOT immediacy in time, against the teachers' temporal reading (the Vism-ṭīkā names Revata, and says "there IS a temporal interval, of seven days or so") | Piṭaka (Paṭṭhāna) + commentarial + sub-commentarial | `abh03m10.mul.xml:3461` (also `:3929`, `:4445`, `:4461`); Vibhāvinī `abh07t.nrf.xml:6653`; Mūlaṭīkā `abh03t.tik.xml:4309`; Vism XVII §598 `e0102n.mul.xml:3701`; Vism-ṭīkā `e0104n.att.xml:3569` | VERIFIED | — |

## Predictions

1. The texts' structure is derived to be not a partial order but a strict order (proximity, pre-nascence, kamma) together with a symmetric co-arising relation and at least one cycle; the agent names what physics would have to add — a frame-independent 'arising together' that is not a causal-order relation — classified EXTENDS, or COLLIDES with relativity of simultaneity only if co-arising relata are spatially separated, citing where the texts place them.
2. Post-nascence and future-object arrows are not offered as retrocausation: the agent reports the texts' own answer (support of a still-present body; an object is not a producer).
3. A measurement is named or the result is labelled philosophy; the agent does not claim that the Paṭṭhāna predicts causal sets.

## Pass criteria for the instrument

- Predictions 1 AND 3.
