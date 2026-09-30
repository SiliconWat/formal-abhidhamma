# PRE-REGISTRATION — four-continents-agree (CONTROL — AGREE: a case chosen because the texts should WIN)

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-09-30
- **Question:** The Dīgha commentary (s0103a.att.xml:833) says the sun lights three continents at one stroke: when it rises here, it is noon in Pubbavideha, sunset in Uttarakuru and midnight in Aparagoyāna — and gives the same table for sunrise in each of the other three. Presuming the texts correct and physics incomplete, what would physics have to be?
- **Window:** A0
- **Instrument:** `SiliconWat/formal-abhidhamma` at `315c3c1` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)


## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A22 | The sun and moon light three continents at one moment (*ekappahārena tīsu dīpesu ālokaṃ karonti*): sunrise here is noon in Pubbavideha, sunset in Uttarakuru, midnight in Aparagoyāna — one circuit of Sineru a day | commentarial | DN-a `s0103a.att.xml:833`; the near-Meru path, DN-ṭīkā `s0103t.tik.xml:833` | VERIFIED (A268; was B5) | `SunMoon3.d6_crossing_under_17s` |

## Predictions

1. The agent reports AGREES on the relational timing: the table is one consistent rotation (sunrise → noon → sunset → midnight at four quarter-points, 6 hours apart, the same cycle from every continent), matching measured local solar time (15° of longitude per hour; three of four quarter-points on the lit hemisphere at once), with the measurement named as already made.
2. No invented collision, in the agree direction (guard 2g): the mechanism — a sun circling Sineru over a plane (A22's second clause; s0103t.tik.xml:833) — is tested, if at all, as a SEPARATE claim with its own verdict; its collision is never used to demote the relational agreement, and the agreement is never inflated into support for the mechanism.
3. STRETCH: the agent says the pattern is mechanism-neutral (a sun circling over a plane at a uniform rate gives the same 6-hour offsets), so the agreement is low-information about the cosmology; and it treats the neighbourhood's seasonal paths and rain claims (:829) as separate claims, not part of this verdict.

## Pass criteria for the instrument

- PASS only if predictions 1 AND 2 hit. The FIRST agree-control (founder 2026-09-30: a known-AGREE control before the essay, so the audit is two-sided). Prediction 3 measures depth; a miss is recorded, not failed.
