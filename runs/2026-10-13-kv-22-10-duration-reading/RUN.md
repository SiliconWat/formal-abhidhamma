# RUN — Kathāvatthu 22.10 on the DURATION reading, the second `/prove` run  ·  PREREG pushed 2026-10-13T21:51:14Z + OTS

- **Kind:** proof (not a known-answer control: the mūla argues only the aligned step, so on the duration reading there is no
  Piṭaka-layer answer to reproduce). Ordered by the founder (*"Approve all; do each in turn"*) as the first run's correction.
- **Premises:** A3, A87, A103, A115, A116, A117, A118, A119, A121 · **held out:** Kv 22.10 §906, A69, A4, and the commentarial
  SUPPORTING-BASE rule (Vism XX §700) · **type freedoms:** declared in the PREREG · **Lean:** `Khanika2.lean`, `run.sh`
- **Before registration:** one vetting refuter (five findings, F1–F5, all applied or declared) and four blind back-translations
  (one tightened the premises: AN 3.47's *arising is discernible*, A121).
- **After:** `run.sh` — 19 registered definitions and statements VERBATIM (a planted moved definition was refused), the theorems
  check, six breaks fail; `leak-check.py` (four pairs, all `no` within one `grind` step); `kala/THEOREMS.md` (all three
  CONSTRUCTIVE, after `omega_c`); CI green; the run refuter (a different agent from the vetting one).

## OUTCOME: INDEPENDENT
## GRADE: NOT STRONG

The registered primary thesis — do Kv 22.10's eye-base premises refute the view on the duration reading? — comes out
**INDEPENDENT**: the Piṭaka-row premises with the commentaries' equal-sub-moment clock leave it open for every count of
sub-moments ≥ 2 (T3, and the k = 3 half of T2). It falls only under readings that already contain its answer.

| Theorem | Outcome | Uses (read from Lean) | Logic | Refuter | Survivor |
|---|---|---|---|---|---|
| `t1_mulatika_line_refutes` | REFUTED | A3, A87, A115, A116, A117, A119 (A103, A121 over-reported: F5) | constructive | NARROWS (F2, F6) | If the base can be born only at a citta's arising, on a uniform grid, the view falls for every integer k. ⚠️ A REPRODUCTION of the Mūlaṭīkā's own inference, which passes through the held-out answer (the base "arose at an EARLIER citta's arising" is the operative clause of Vism XX §700's held-out rule) — a check, not a finding. A119 is itself DERIVED (A389 OQ-A) |
| `t2_pitaka_cell_turns_on_the_count` | REFUTED at k = 2 · INDEPENDENT at k = 3 | A3, A87, A115, A116, A117, A118 | constructive | **KILLS "Piṭaka cell"**, NARROWS (F1, F2, F3) | The view falls only on Ānanda's PAIRED readings of the Yamaka — a two-moment citta (from the Cittayamaka's silence, §81) and *no dukkhasacca whatsoever* at a dissolution (his scope, contested at `:16337` itself by Dhammasiri and the *apare*) — which makes the k = 2 half T1 again. The k = 3 half pairs Ānanda's scope with the anuṭīkā's count, a combination nobody holds. **The Piṭaka text alone does not refute the view.** |
| `t3_permission_alone_open` | INDEPENDENT | A3, A87, A103, A115, A116, A117, A121 | constructive | CHECKS, narrowed (F3, F7) | With no rule placing the base's birth, the Piṭaka-row premises plus the clock leave the view open for every k ≥ 2. **The content is the view-TRUE world** (a base born at the predecessor's dissolution sub-moment, lasting exactly one mind-moment); the view-false half is cheap |

⭐ **What the run found, in one sentence:** on a duration reading, Kathāvatthu 22.10's eye-base argument against universal
momentariness does not follow from the Piṭaka premises — they leave it open for every count of sub-moments ≥ 2 — and the
tradition closes it only with later rules that already contain the conclusion: Ānanda's readings of the Yamaka (a two-moment
citta; no matter at any dissolution) or Buddhaghosa's supporting-base rule (a citta stands on a base that arose with the
previous one). ⛔ Never *new* or *first* without `/novelty` (the Ānanda–Dhammapāla dispute itself is known to scholarship).

## The rubric, item by item (`runs/PROVE-RUBRIC.md` as amended under A388)

1. **Axioms verified** — partial: A118's literal SCOPE was presented as the Piṭaka's (F1; row corrected); A119's first quoted clause was the wrong one (F6; corrected).
2. **Nothing load-bearing BY CONSTRUCTION** — ✗: the view-false witness (`shortLife`) has cittas present only at their arising and a gap between consecutive cittas, which the Cittayamaka (§81: a citta at its dissolution is *uppanna*) and proximity (A3, A82) exclude (F3); and the commentarial clock rides under A3's Piṭaka ID (F4).
3. **A model** — ✗ for T1 and T2 at k = 2: none in Lean (`tri_common` cannot build one); one exists by hand (F5).
4. **Breaks** — ✗: none for A115 or `a3_stream`, both relied on (F5).
5. **Axioms read from Lean** — ✗: the A388 `premises_` bundle is ONE binder, so its unused conjuncts (A103, A121 in T1) are listed under Uses and the Unused column cannot fire (F5).
6. **Logic** — ✓ all constructive (`omega_c`).
7. **No held-out answer as a premise** — ✗ IN SUBSTANCE: T1, and T2 at k = 2, pass through the answer (F2). The leak check's `no` is honest only at its declared threshold: it never showed it can see the nonlinear `k·n` class (T1), and it tests the universal closure `∀ k`, which is false at k = 3, so it never asks about the instance T2 actually uses (k = 2).
8. **No unrepaired encoding defect** — ✗ (F1–F6).
9. **Layer named** — ✗ as registered: T2 is not at the Piṭaka layer (F1).

## Predictions, scored by the main session

1. **T1 REFUTED for every k, constructive — ✅ HIT** (narrowed: a reproduction through the answer).
2. **T2 REFUTED at k = 2, INDEPENDENT at k = 3 — ✅ HIT as Lean; NARROWED in meaning** (not the Piṭaka's; F1).
3. **T3 INDEPENDENT for every k ≥ 2 — ✅ HIT.**
4. **leak-check: `no` for common, t2, t3; t1 beyond one `grind` step — ✅ HIT as instrument output; ❌ MISLEADING as evidence** (F2: `no` ≠ no restatement).
5. **Layers — ❌ MISS** (T2 not Piṭaka; the clock under A3's ID).
- **Calibration:** the session predicted INDEPENDENT for the primary thesis — HIT. No founder prediction.

## What the instruments caught in this run

- **The leak check was blind** on its first pass here: a one-line regex saw no multi-line ANSWER docstring and exited 0 having
  checked nothing. Fixed before grading; a post-A388 proof run without an answer, or a run yielding no pair, is now an ERROR.
- **`omega` made T2 and T3 classical** through the witness lemmas — from a negated CONJUNCTION, not from top-level contradiction
  alone (probed). `omega_c` (split, then decidable contradiction) made all three constructive.
- **The run refuter** found the A118 scope dispute at `:16337` itself, the A119 clause error, the `na sabbassa` mistranslation (all
  corrected in AXIOMS.md), and three instrument gaps (A389 OQ-C).

## OPEN QUESTIONS for the founder → roadmap A389 (no wording proposed by the refuter; recommendations are the session's)

- **OQ-A** A119 is reached only by derivation (Ānanda, *vicāretabbo*). Axiom or answer under "sort by content"? *(recommend: answer)*
- **OQ-B** A118's literal SCOPE over kamma-born matter is Ānanda's, contested at the line. Is that scope Piṭaka-tier? *(recommend: no — wording Piṭaka, scope sub-commentarial)*
- **OQ-C** Do rubric items 5 and 7 bind PER CONJUNCT and PER INSTANCE (the `premises_` bundle hides conjuncts; the leak check tests the closure, not the instance used)? *(recommend: yes)*
- **OQ-D** Does a DECLARED type freedom that a witness depends on still fail item 2? *(recommend: yes — declaring keeps it honest, it does not make the witness textual)*
- **OQ-b** (the vetting's) Should T1 and T2 at k = 2 be keyed to the Mūlaṭīkā's derivation (a new ANSWERS row) rather than Kv 22.10? *(recommend: yes)*
