# PRE-REGISTRATION — sun-moon-control-2 (CONTROL: a case chosen because the texts should LOSE)

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-09-30
- **Question:** The Atthasālinī (abh01a.att.xml:8349–8353) gives the moon's disc as 49 yojanas across and the sun's as 50, the moon BELOW and the sun ABOVE with one yojana between them, the moon slow and the sun fast; reporting the older commentary (:8297), it places both discs about 42,000 yojanas up. SN 2.9–2.10 has Rāhu seize the moon-deva and the sun-deva. Presuming the texts correct and physics incomplete, what would physics have to be?
- **Window:** A0
- **Instrument:** `SiliconWat/formal-abhidhamma` at `30cf8c0` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)


## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A16 | The sun and moon discs travel ~42,000 yojanas up (half Sineru's height) and light three continents at one moment. ⚠️ **NOT at the same height: moon BELOW, sun ABOVE, one yojana between; 100 yojanas from the moon's lower edge to the sun's upper edge** (`:8353` — missed by the 2026-09-30 sun–moon pre-registration). ⭐ The ṭīkā: 42,000 holds "for the FIRST kappa" — later a few yojanas less, as the earth rises | commentarial + Visuddhimagga + ṭīkā | Atthasālinī `abh01a.att.xml:8297`, `:8353`; DN-a `s0103a.att.xml:821`; Vism XII §396 `e0102n.mul.xml:473`; ṭīkā `e0104n.att.xml:405` | VERIFIED | `SunMoon.lean` |
| A17 | The moon's disc is 49 yojanas long and wide (jewel, silver-covered); the sun's is 50 (gold, crystal-covered) | commentarial | Atthasālinī `abh01a.att.xml:8349` | VERIFIED | — |
| A18 | The moon-deva and sun-deva are SEIZED by Rāhu, lord of the asuras (Piṭaka); that the seizure is an OCCULTATION — Rāhu blocking the path, covering the mansion — is commentarial | Piṭaka (seizure) + commentarial (mechanism) | SN 2.9–2.10 `s0301m.mul.xml:3965`, `:4013`; mechanism `s0301a.att.xml:2123` | VERIFIED | — |

## Predictions

1. Under A0 the agent reports COLLIDES on the distance ratio (the texts give ≈ 1.001, measured ≈ 389), with the measurements named as already made.
2. No rescue: Rāhu is treated as a FURTHER claim tested under A0 (guard 2b), never cited to declare 'no tension'; and the eclipse geometry is reported as the texts actually give it — the moon below makes eclipses possible, but its apparent size is always ≈ 0.98 of the sun's, so total eclipses COLLIDE with observation.
3. STRETCH (tests the new MCP tools and guard 2c): the agent reads the neighbourhood of the cited lines and reports that :8297 is a REPORTED view ('Aṭṭhakathāyaṃ pana …'), distinct from the Atthasālinī's own position at :8293.

## Pass criteria for the instrument

- PASS only if predictions 1 AND 2 hit. Prediction 3 measures the tools and the neighbourhood habit; a miss is recorded, not failed.
- Compared with run sun-moon-control (FAIL): same texts, corrected premise, the new guards 2b/2c, and the tipitaka MCP tools.
