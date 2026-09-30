# Formal Abhidhamma

*A research program to express the Theravāda Abhidhamma in the language of mathematics — machine-checked, pre-registered, open.*

[![Lean — every theorem, every break](https://github.com/SiliconWat/formal-abhidhamma/actions/workflows/lean.yml/badge.svg)](https://github.com/SiliconWat/formal-abhidhamma/actions/workflows/lean.yml) · **Track record:** [`runs/INDEX.md`](runs/INDEX.md) (every pre-registered run and control, failures included)

**Cite:** [doi:10.5281/zenodo.23067241](https://doi.org/10.5281/zenodo.23067241) (concept DOI — the latest version; v0.1.0 is
[10.5281/zenodo.23067242](https://doi.org/10.5281/zenodo.23067242)) · see `CITATION.cff` · archived by
[Software Heritage](https://archive.softwareheritage.org/swh:1:snp:1c9b8223ad236d5dd5f34a322d484b41b648bcdf) (`swh:1:snp:1c9b8223ad236d5dd5f34a322d484b41b648bcdf`, 2026-09-30) ·
timestamped (RFC 3161 + OpenTimestamps, `TIMESTAMPS.md`).
Thon Ly · Miss Aquarius℠ (AI collaboration, disclosed) · Silicon Wat℠ · CC0-1.0

## What this is

The Abhidhamma analyses experience into typed elements: 89 (by fuller reckoning 121) types of consciousness (*citta*), 52 mental factors (*cetasika*), 28 kinds of matter (*rūpa*), and 24 kinds of conditioning relation (*paccaya*). The tradition states that the citta-types arise *by composition* from the cetasikas.

This program tests that statement. If the combination rules are written as **general constraints** (never as a per-citta table), do they generate exactly the traditional counts?

- **If they do**, the system is internally consistent, and the rules are a compression of the table. The ratio is reported.
- **If they do not**, the gap is the finding: either a rule was lost in transmission, or a rule was never stated.

## Method (fixed before any code ran)

1. **Two editions.** The Khmer edition and the Chaṭṭha Saṅgāyana (CST) are formalized separately.
2. **Textual layers as a variable.** canon (Dhammasaṅgaṇī, Paṭṭhāna) → + *Abhidhammattha-saṅgaha* → + commentaries. The question is which layer the counts first become derivable in.
3. **Machine-checked.** Rules in Lean 4; each count is a theorem anyone can re-run.
4. **The instrument is tested on a known answer and a known failure** before it is trusted (`control/`).
5. **Pre-registered.** `PREREGISTRATION.md` was pushed before the first line of formalization. GitHub's push record, not a commit date, is the timestamp.
6. **Three arms kept apart.** A: formal (this repo, the core). B: perception science (calibrate-then-predict, needs an EEG partner). C: a comparison with discrete quantum-gravity programs, a **lens only**, never a claim.
7. **Kill criteria written in advance** (`PREREGISTRATION.md` §4).
8. **Open by default.** CC0.

## What this is not

It is not a proof that the Abhidhamma is true, and not a claim that it predicts physics. A proof assistant verifies that conclusions follow from the stated definitions. Nothing more. Tier labels distinguish canon, the *Saṅgaha*, the commentaries, and our own reconstruction.

## Neighbours (cited, not competed with)

- [takuya50/buddhist-comparative-logic](https://github.com/takuya50/buddhist-comparative-logic): Lean 4 + Isabelle formalization of the Heart Sutra, Madhyamaka, pramāṇa and Yogācāra (2026-09-20).
- [PJ-Oliveira/abhidhamma](https://github.com/PJ-Oliveira/abhidhamma): an interactive citta-vīthi simulator, cetasika analyzer and Paṭṭhāna matrix.

## Status

**Rung 1 — done 2026-09-27.** The pre-registration was pushed first (commit `259e5e8`, GitHub push record 2026-09-27T22:07:02Z). The control was written afterwards and passes:

```
$ control/run.sh          # Lean 4.34.1, no dependencies
C1 ✓ the eight wholesome cittas: 8 types, 38·38·37·37·37·37·36·36
C2 ✓ deleting 'pīti only with joy' breaks the count, as required
```

- `control/Cetasika.lean` defines the 52 cetasikas in four classes (theorems: 52 in total; 7 · 6 · 14 · 25).
- `control/Rules.lean` defines the eight wholesome sense-sphere cittas as three binary axes. **Six general rules, none naming a citta**, reproduce the *Saṅgaha*'s counts. Compression on the control: 6 rules ÷ 8 rows = 0.75.
- `control/Broken.lean` is the same file with rule R2 deleted on purpose. Lean refuses it: *"`decide` proved that the proposition … is false."*

**Rung 2 — done 2026-09-27** (`sangaha/`, `RESULTS.md`). 9 general generator clauses and 18 general cetasika rules, none naming a citta, give **all 89 and all 121 citta-types and every per-citta and per-factor count chapter 2 states**, checked by `decide` against a key collated from the printed Pāli. Six deliberate breaks each fail. P-FA1 and P-FA4 are **provisionally confirmed**, pending collation with the Chaṭṭha Saṅgāyana. P-FA1b is **not scored**: its registration was not operational.

```
$ sangaha/run.sh
PASS  9 theorems: 89 · 121 · distinct · both profiles · per-factor counts and absences (both reckonings)
6 of 6 deliberate breaks fail, as required
```

**Rung 2b — done.** The key is collated paragraph by paragraph against the Chaṭṭha Saṅgāyana (VRI `abh07t`), and chapter 3's feeling and root counts are added as a second key. **P-FA1 and P-FA4 are CONFIRMED.**

**Rung 3 — done 2026-09-27** (`canon/`, `sangaha/Canon.lean`):
- **The canon alone names 29 of the 38 cetasikas of the first wholesome citta**, which is the Aṭṭhasālinī's own *samatiṃsa*, reproduced. The rest of the *Saṅgaha*'s 38 is exactly the commentary's nine *yevāpanaka*: inherited, and contradicting none (P-FA2a ✓, P-FA2b ✓; see the corrections in `RESULTS.md`).
- **The Khmer edition and the CST name the same 56 terms in the same order** (P-FA5 ✓). Every spelling difference was checked against the printed page.

```
$ sangaha/run.sh
PASS  12 theorems …   PASS  4 theorems (rung 3) …   9 of 9 deliberate breaks fail, as required
```

**Next:** extend both comparisons beyond the first citta · arm B (perception) needs a partner.
