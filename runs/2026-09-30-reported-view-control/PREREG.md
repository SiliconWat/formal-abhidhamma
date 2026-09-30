# PRE-REGISTRATION — reported-view-control (CONTROL: a case chosen because the texts should LOSE)

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** 2026-09-30
- **Question:** The commentary holds that the colour of the moon's and sun's discs, standing 42,000 yojanas up, strikes the eye's sensitivity, and that sound comes to the ear through a succession of elements and is determined gradually (abh01a.att.xml:8297). Presuming the texts correct and physics incomplete, what would physics have to be?
- **Window:** A0
- **Instrument:** `SiliconWat/formal-abhidhamma` at `d4a8fe6` (AXIOMS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)


## Window rows

| ID | Statement | Status |
|---|---|---|
| A0 | Rūpa-kalāpa are mind-independent physical reality (the window outward). The texts do not settle this: rūpa is known through its characteristics. | a CHOICE, declared per run |

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A16 | The sun and moon discs travel ~42,000 yojanas up (half Sineru's height) and light three continents at one moment. ⚠️ **NOT at the same height: moon BELOW, sun ABOVE, one yojana between; 100 yojanas from the moon's lower edge to the sun's upper edge** (`:8353` — missed by the 2026-09-30 sun–moon pre-registration). ⭐ The ṭīkā: 42,000 holds "for the FIRST kappa" — later a few yojanas less, as the earth rises | commentarial + Visuddhimagga + ṭīkā | Atthasālinī `abh01a.att.xml:8297`, `:8353`; DN-a `s0103a.att.xml:821`; Vism XII §396 `e0102n.mul.xml:473`; ṭīkā `e0104n.att.xml:405` | VERIFIED | `SunMoon.lean` |

## Predictions

1. Guard 2f: the agent attributes :8297 to the older commentary it REPORTS (Aṭṭhakathāyaṃ pana … vuttaṃ), not to the Atthasālinī's author, and reports the author's own verdict at :8293/:8301 — eye and ear take objects that do NOT reach them (asampatta) — tested under A0.
2. No rescue, closed jointly (guards 2b/2d/2g): under A0 the author's verdict COLLIDES — its own reductio fails (far sound IS heard late: 343 m/s, thunder; direction survives propagation; light is late too: LLR ≈ 2.56 s round trip) — and it is not moved to A0′ or filed as philosophy: these are collisions with appearances and survive a change of window, said so.
3. STRETCH: the reported view's mechanism AGREES (sound propagates through a medium; light is absorbed at the retina), while its 42,000-yojana discs COLLIDE (≈ 4′ vs ≈ 31′, unit-free) — the reported view wins on mechanism and loses on geometry; and no sentence says 'no change clears any' or 'mathematically impossible'.

## Pass criteria for the instrument

- PASS only if predictions 1 AND 2 hit. Prediction 3 measures depth and 2g's wording; a miss is recorded, not failed. First control after guards 2f/2g (A269) and axioms A19–A23 (A268).
