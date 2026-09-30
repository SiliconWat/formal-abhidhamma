# PRE-REGISTRATION — sun-moon-control-3 (CONTROL: a case chosen because the texts should LOSE)

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-09-30
- **Question:** The Atthasālinī gives the moon's disc as 49 yojanas and the sun's as 50, the moon below and the sun above one yojana apart, both about 42,000 yojanas up; Rāhu seizes them (SN 2.9–2.10). Presuming the texts correct and physics incomplete, what would physics have to be?
- **Window:** A0
- **Instrument:** `SiliconWat/formal-abhidhamma` at `e8dec63` (AXIOMS.md, Axioms.lean as of that commit)
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

1. Under A0 the agent reports COLLIDES on the distance ratio (texts ≈ 1.001, measured ≈ 389), naming the measurements as already made.
2. No rescue, and the texts' OWN configuration derived first (guard 2e): moon below → apparent-size ratio θ☾/θ☉ = (49/50)(h☉/h☾) ≈ 0.98 for every observer → annular only, never total, which COLLIDES with observed totality (e.g. 8 Apr 2024). Rāhu is tested as a further claim under A0, never cited to declare 'no tension'.
3. No softening (guard 2d): no testable claim is filed as 'philosophy' — in particular :8301's own test (far sound would be heard late) is reported as a physical claim, not a claim about cognition.
4. STRETCH (first run with the tipitaka MCP tools live): the agent cites the lines via the MCP tools with neighbourhood reads, and identifies :8297 as the older commentary's REPORTED view against the Atthasālinī's own :8293/:8301.

## Pass criteria for the instrument

- PASS only if predictions 1, 2 AND 3 hit. Prediction 4 measures the tools; a miss is recorded, not failed.
