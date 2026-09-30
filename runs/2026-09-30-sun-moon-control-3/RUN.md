# RUN — Sun–moon control 3 (known failure; first run with the tipitaka MCP tools live)  ·  PREREG pushed 2026-09-30T18:26:11Z (GitHub activity) + OTS

- **Window:** A0 · **Axioms:** A16, A17, A18 (+ A14 used) · readings the agent ADDED from the neighbourhood: B1–B5 (commentarial /
  sub-commentarial, VERIFIED) and B6 (OURS: the silver-covered moon is opaque) · physics premises P1–P3 labelled · agent BLIND ·
  full text: `DERIVATION.md` (saved verbatim before refutation) · both agent and refuter ran the MCP `control` (PASS) and `verify`.

| Derivation | Refuter | Survivor | Lean |
|---|---|---|---|
| D1 the texts' own eclipse ratio θ☾/θ☉ = 0.981, derived FIRST (guard 2e) | CHECKS; B1's *ubbedhato* reading (`s0103t.tik.xml:821`) correct | **COLLIDES** — annular only; totality needs H ≤ 2,474.5 | ✅ `SunMoon.d3_never_total` (run 1) |
| D2 distance ratio 1.0012 vs 389 | CHECKS; but "no change of physics clears it" is the wrong quantifier (run 1's lesson): D1's own gap lens clears D1 — what fails is clearing them JOINTLY | **COLLIDES** jointly | ✅ `SunMoon.d1_ratio_below_two` |
| D3 ≈ 4′ vs ≈ 31′, unit-free | CHECKS | **COLLIDES** | ✅ `SunMoon.d2_disc_too_small` |
| D4 phases from the ṭīkā's sunlight-from-above | **NARROWS**: k < ½ holds at the ZENITH only; off-zenith sun-side observers can see it nearly full (the report's own maths says so); "≈ ½ in 4 min" is k = 0.41 (0.49 at ~36 min); ṭīkā hedges *viya* | **COLLIDES** — at culmination never more than half lit; phase differs between observers at one instant | ✅ `d4_zenith_never_full` (sign step only) |
| D5 opaque moon under the sun every new moon | CHECKS; second exit missed — the text's own *divā padīpo viya* (a self-luminous moon as bright as the sun), which collides with the ≈ 400,000 brightness ratio | **COLLIDES** — > 96% annular every month; ⭐ Lean: for ANY stack with the sun above | ✅ `d5_monthly_annular` |
| D6 disc crossing ≤ 17 s vs 128 s; magnification closed | CHECKS; **CONTRAST** (strengthens): the texts' own path r ≈ 182,000–462,000 (`s0103t.tik.xml:833`) → 1.5–3.8 s, zenith rate 65–165°/h vs 15°/h | **COLLIDES** a fortiori | ✅ `d6_crossing_under_17s`, `d6b_zenith_rate` |
| D7 Rāhu tested as a further claim (guard 2b) | (a)(b) CHECK; OMITS run 2's sturdier test (*saheva gacchati* → umbra east→west vs measured west→east); (c) slip: umbra ≈ 2.7 lunar diameters is its DIAMETER; (e) **NARROWS**: SN 2.10 is testable by retrodiction (a deep eclipse visible from Sāvatthī) — not run | **COLLIDES** on shape, width, the red moon, direction; timing only with an ADDED nodal axiom | ✅ `d7b_umbra_wide`; direction `SunMoon2.d4_shadow_moves_west` |
| D8 C = 3D at disc and cakkavāḷa scales | arithmetic CHECKS; "mathematically impossible" **overclaimed** — a conical defect satisfies it; cakkavāḷa 1,203,450 VERIFIED at `abh01a.att.xml:7897` | **COLLIDES** — no smooth geometry fits both scales; metrology rules out cones | **UNCHECKED** (needs sin; core Lean) |
| D9 orderings of daily rates, declination swing, western crescent | **NARROWS**: orderings and period counts only; discs on a horizontal circle cannot SET (run 2's gap again) | AGREES (low information) | NOT A DERIVATION |
| (missed) `abh01a.att.xml:8301` — the Atthasālinī's own *asampatta* reductio: *dūre uppanno cirena suyyeyya* | **OMISSION, the strongest finding.** :8297 is a REPORTED view (*Aṭṭhakathāyaṃ pana … vuttaṃ*), rejected at :8301 on grounds that collide: sound arrives late (343 m/s), direction survives, light arrives late (LLR 2.56 s). The agent attributed :8297's 42,000 to "the Atthasālinī" | **COLLIDES** (run 2 found it) | NOT A DERIVATION |
| (missed) Meru shadows the full moon | A14 + A16 + B4 (*upaḍḍhamaggameva*) + straight lines: the sun–moon line passes through Meru at ≈ 42,025 yojanas → no sunlight at full moon, ±1–2 days, against *paripuṇṇo hoti* — the strongest axiom–axiom contradiction, unreported; §3 led with #1, which needs P2 | **CONTRADICTION inside the texts** | ✅ `meru_blocks_full_moon` (⚠️ BY CONSTRUCTION in its geometry) |

**Lean finding.** `d4_zenith_never_full`'s upper bound `s ≤ S` is flagged unused: k < ½ needs only that the sun is ABOVE (s > 0),
not how far. `d5_monthly_annular` needs only 0 < hm ≤ hs: the > 96% cover follows from "sun above, 49 vs 50" alone, not from 42,000.
All six breaks fail as required (`run.sh`).

**§3 and §2, as amended by the refuter.** §3 #1 and #3 are text + P2, i.e. physics collisions, not axiom contradictions; the axiom–axiom
contradiction is Meru's shadow. "The only exit is to leave A0" is **wrong**: D3, D4, D5, D6, :8301 and the red eclipsed moon are
collisions with APPEARANCES and survive a change of window; leaving A0 removes at most the distance claims (D2, D7b).

## Predictions, scored by the main session
1. **COLLIDES on the distance ratio, measurements named — ✅ HIT** (1.0012 vs 389; LLR, radar, parallax).
2. **No rescue; the texts' own configuration first — ✅ HIT.** D1 derived 0.981 → annular only, before any added mechanism (guard 2e
   worked); Rāhu tested as a further claim (D7) with no "no tension" sentence.
3. **No softening; :8301 reported as a physical claim — ❌ NOT HIT.** Nothing was filed as "philosophy" (guard 2d held), but the item the
   prediction names is absent: the agent read ±15 lines of :8297 and did not report :8301.
4. **STRETCH, tools + reported view — ◐** Tools used (control, passage, verify on every citation — a first); :8297 NOT identified as a
   reported view, and misattributed. Recorded, not failed.

## VERDICT: **FAIL** (pre-registered rule: 1, 2 AND 3). **The failure mode moved a third time, and narrowed:** run 1 explained a collision
away · run 2 omitted one and softened two into "philosophy" · run 3 neither explained away nor softened — it **omitted** the one collision
that sits in the Atthasālinī's own voice, and **overclaimed in the texts-LOSE direction** ("no change clears any", "the only exit is to
leave A0", "mathematically impossible"). The guards 2b, 2d, 2e each did their job on first use.
**Fixes proposed (not made — founder's word):** agent guard **2f** — *when a cited line is a REPORTED view (`… pana … vuttaṃ`), report
the author's own verdict on it and test that too*; guard **2g** — *a collision closed means closed JOINTLY; never "no change clears any",
and never name leaving the window as an exit without saying which collisions survive it*. AXIOMS candidates: B1, B3, B4, B5 (VERIFIED,
from the neighbourhood), cakkavāḷa 1,203,450 at `abh01a.att.xml:7897`; B6 stays OURS.
**Track record: 1 PASS · 3 FAIL.**
