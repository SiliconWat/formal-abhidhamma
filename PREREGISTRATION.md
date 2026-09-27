# Pre-registration — Formal Abhidhamma, arm A

**Registered 2026-09-27 (America/Los_Angeles)** by Thon Ly · Miss Aquarius℠. This file was pushed **before** any formalization code was written. It is never edited; a correction is a new file (`PREREGISTRATION-<date>.md`) that cites this one.

## 1 · Definitions

- **General rule**: a constraint over classification axes or cetasika classes (e.g. *"pīti arises only with joyful feeling"*). It never names an individual citta.
- **Generated set**: the citta-types, each with its cetasika set, that satisfy all rules of a layer.
- **Compression ratio**: rule clauses in the Lean rule file (excluding datatype declarations) ÷ the number of citta rows generated.
- **Layers**: L1 canon (Dhammasaṅgaṇī citta-uppāda and cetasika chapters) · L2 = L1 + the *Abhidhammattha-saṅgaha* chapters 1–2 · L3 = L2 + the commentaries (Aṭṭhasālinī, the Vibhāvinī).
- **Editions**: K = the Khmer edition (Buddhist Institute, Phnom Penh) · C = the Chaṭṭha Saṅgāyana (VRI digital edition).

## 2 · The control (known answer, run first)

**C1 — the eight wholesome sense-sphere cittas** (*kāmāvacara kusala*). Three binary axes, joyful/equanimous feeling × with/without knowledge × unprompted/prompted, give **8** cittas. The traditional maximum cetasika counts (*Saṅgaha* ch. 2) are **38 · 37 · 37 · 36** for the four feeling × knowledge pairs; prompting changes nothing. The rules must reproduce all eight exactly.

**C2 — the known failure.** Delete the rule *"pīti arises only with joyful feeling"*. The equanimous pairs must then come out wrong (38 and 37 instead of 37 and 36), and the theorem must **fail to check**. If it still checks, the instrument is blind and nothing below is reported.

## 3 · Predictions (made before any code)

| ID | Prediction | Confidence |
|---|---|---|
| **P-FA1** | At L2, edition C: general rules generate **exactly 89** citta-types, and **121** with the five-jhāna expansion of the supramundane. | 0.6 |
| **P-FA1b** | P-FA1 requires **at least 3 exception rules** that name a narrow class, not a general principle (candidates: doubt-accompanied citta lacking *adhimokkha*; the smile-producing citta; the rootless cittas). | 0.7 |
| **P-FA2** | At L1 (canon alone) the rules are **under-determined or differently partitioned**: they do not by themselves yield the number 89, which is a *Saṅgaha*-era systematization. | 0.65 |
| **P-FA3** | Editions K and C yield **identical** counts at L2: no variant changes the logic. | 0.85 |
| **P-FA4** | Compression ratio at L2 below **0.5** (fewer than one rule clause per two citta rows at 121). | 0.5 |

## 4 · Kill and reopen criteria

- **No layer generates the counts** → the transmitted rules are incomplete. That is reported as the result, and the program continues to locate the missing rule.
- **The C2 break does not fail** → the instrument is blind. Stop, fix, re-register.
- **P-FA3 false** → the edition difference is traced to its variant before any other claim is made.
- **Arm B** (perception) closes if its one calibrated parameter predicts nothing out of sample. It is registered separately, if ever.
