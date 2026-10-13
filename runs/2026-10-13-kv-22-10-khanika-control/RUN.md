# RUN — Kathāvatthu 22.10, the first `/prove` run (a known-answer control)  ·  PREREG pushed 2026-10-13T20:04:02Z + OTS

- **Kind:** proof — CONTROL, KNOWN ANSWER `Kv 22.10 §906` (`kala/ANSWERS.md`), declared CONFOUNDED on family A before the attempt.
- **Premises:** A87, A98, A115, A117 (Piṭaka) · **held out:** Kv 22.10 §906, A69, A4 · **window:** none · **Lean:** `Khanika.lean`, `run.sh`
- **Before registration:** the vetting refuter ran twice (the case was narrowed on its findings 4a–4d; then a premise that the base
  is present THROUGHOUT the consciousness was dropped — no layer says it, and it would have imported the held-out A69); three blind
  back-translations (the second caught that T2, as first written, never stated the opponent's inference).
- **After:** `run.sh` — the three registered statements VERBATIM, the theorems check, five breaks fail (a planted moved statement was
  refused); `kala/THEOREMS.md` regenerated; the RUN refuter (a different agent from the vetting one).

## OUTCOME: REFUTED
## GRADE: NOT STRONG
## VERDICT: PASS (confounded — declared in the PREREG: the instrument was designed alongside this case, and family A's decisive premise is the debate's contested lemma)

The registered primary thesis — "all dhammas last one mind-moment" on the ALIGNED reading — is refuted (the known answer, reproduced),
and `theorems-index.py --check` stayed green. The run is NOT STRONG: the refuter found encoding defects the run could not repair
without moving its statements (a corrected version is a new run).

| Theorem | Outcome | Uses (read from Lean) | Logic | Refuter | Survivor |
|---|---|---|---|---|---|
| `t1_aligned_view_refuted` | REFUTED | **A115**, **A87**, **A98** | constructive | NARROWS (F3, F4) | A87's born-before, the base present when the consciousness ARISES and A115's added existential refute the aligned view. ⚠️ On a mind-moment clock, A87 + A98 already state the held-out A69 for bases (a base present at two distinct moments), so this is a plumbing check, not a derivation of §906 from what both sides share; and the "at its arising" timing is the Vibhaṅga's (A116, `abh02m.mul.xml:9121–9133`), carried under A98's name |
| `t2_counter_does_not_follow` | REFUTED (the inference) | — (a countermodel: its premises sit inside the `∃`, which `Uses.lean` cannot see) | constructive | CHECKS, narrowed (F2, F7) | In a world satisfying those premises, §907's "not one-moment, therefore all permanent" fails — the COMMENTARY's verdict, not the mūla's. ⚠️ The witness leans on the type's freedom to make a dhamma present before its birth |
| `t3_duration_view_open` | INDEPENDENT | **A117** | constructive (after a fix — see below) | NARROWS (F1, F2, F5) | For every k ≥ 2, A115 + A87 + presence at arising leave the duration view open — **in a World that represents no citta stream**. Once the stream is represented, the view-true world needs matter to arise at a citta's NON-arising sub-moment: the Sammohavinodanī, the Vibhaṅga-anuṭīkā, the Vibhāvinī and Ledi admit it; the Mūlaṭīkā denies it (which refutes the view for every k), and so, at k = 2, does A117's own Saccayamaka line read literally. **The duration view is INDEPENDENT on the commentarial line's reading, not where the mūla is silent** |

⭐ **What the run found, in one sentence:** the Kathāvatthu's eye-base argument against "all dhammas last one mind-moment" goes
through on the reading that aligns every dhamma with one citta; on a duration reading it turns on a live commentarial dispute —
whether matter can arise at a citta's standing or dissolution sub-moment (the Mūlaṭīkā says no, the Sammohavinodanī, Vibhāvinī and
Ledi say yes). That dispute is known to scholarship (the Ānanda–Dhammapāla disagreement on the *ṭhitikkhaṇa*); mapping it onto Kv
22.10's argument is not found in this repo's corpus — ⛔ never *new* or *first* without `/novelty`.

## The rubric, item by item (`runs/PROVE-RUBRIC.md` at `4612142`)

1. **Every axiom VERIFIED** — met (A87, A98, A115, A117 read at their lines). ⚠️ A98's row says "must be present while they condition"; that wording is the Paṭṭhāna-aṭṭhakathā's (`abh03a.att.xml:7769`), the mūla lists relata only (F4).
2. **Nothing load-bearing BY CONSTRUCTION** — ✗ NOT MET. The `World` type represents no citta stream, does not tie presence to birth, and links `k` to no citta's span (F2); T3's view-true world and T2's witness depend on those freedoms. The conditioned-only scope was declared; these were not.
3. **A model** — met (T2's world satisfies T1's premises; T3 exhibits both).
4. **Breaks** — met for the five registered (each FAILS). ⚠️ The A87/A98/A115 breaks touch only T1's named binders, and no break strengthens A98 to "throughout", the one change that would flip T3 (F4).
5. **Axioms read from Lean** — met, with the blind spot now recorded in `THEOREMS.md`: premises inside an `∃` are invisible (F9).
6. **Logic reported** — met; all four constructive.
7. **No held-out answer is a premise** — ✗ NOT MET IN SUBSTANCE. No premise is A69 by name, and the guard stayed green; but A87 ∧ A98 on a mind-moment clock jointly STATE A69 for bases (F3). ⚠️ **The guard checks names and Lean definitions, not content** — A69 has no Lean form, so the guard could not have seen this.
8. **No unrepaired encoding defect** — ✗ NOT MET (F1–F5).
9. **Layer named** — T1: Piṭaka (A87, A98-as-A116, A115's existential a declared reading). T3: the commentarial line (F1). T2's known answer: commentarial.

## Predictions, scored by the main session

1. **T1 REFUTED from A115 + A87 + A98, all three used, each break fails, constructive — ✅ HIT** (narrowed by F3/F4).
2. **T2: a countermodel to §907's counter — ✅ HIT** (narrowed by F2: the witness uses presence before birth).
3. **T3 INDEPENDENT for every k ≥ 2, A117 load-bearing — ✅ HIT as a Lean statement; NARROWED in meaning by F1** (independent only on the commentarial line).
4. **All three at the Piṭaka layer — ❌ MISS** (T3 rests on the commentarial reading of where matter may arise).
- **Calibration:** the session predicted REFUTED for the primary thesis — HIT. The founder gave no prediction (a control).

## What the instruments caught in their own first run

- **The blind back-translation** caught that T2, as first registered-to-be, never stated the opponent's inference.
- **The vetting refuter** killed a "throughout" premise in no layer, which would have carried the held-out A69.
- **`tools/Uses.lean`** reported T3 as CLASSICAL; the cause was `omega` closing a non-`False` goal by contradiction, not the
  mathematics — T3 went constructive when two inequalities were proved directly (`/prove` step 6 now warns of it).
- **The run refuter** found that `THEOREMS.md` gave the docstring's line plus one (fixed: the theorem's name, minus the injected
  import line), that a countermodel's premises are invisible to `Uses.lean` (now stated in its legend), that `ANSWERS.md`
  over-attributed §907's verdict to the mūla (fixed), and that the A4 row labeled the Vibhaṅga-anuṭīkā as the Mūlaṭīkā (fixed).

## OPEN QUESTIONS for the founder (ratified rules; the refuter proposed no wording, and neither does this record)

- **OQ1.** The Yamaka sits in the hold-out (its answers are a test bank), yet the sort rule sends what a text ASSERTS to AXIOMS. The
  Saccayamaka's "no arising at a citta's dissolution-moment" (`abh03m4.mul.xml:16337`, `:18405`) follows from neither the
  Dhammasaṅgaṇī nor the Vibhaṅga. Axiom (then T3 at k = 2 is REFUTED once the stream is represented) or held-out answer?
- **OQ2.** Vibhaṅga §762 asserts §906's lemma outright (*purejātasmiṃ vatthusmiṃ … uppajjanti*; the commentary's
  *sahuppattipaṭikkhepo*). By the sort rule's "both → an axiom, the answer row tests nothing", is Kv 22.10 §906 (aligned) a
  row that tests nothing?
- **OQ3.** Does rubric item 7 bar a premise SET whose conjunction, on the type's clock, is a held-out answer (F3)?
- **OQ4.** Does item 2 (the type must not do the axiom's work) also cover the converse — a result produced by what the type
  CANNOT express (F1, F2)?
- **OQ5.** How do items 5 and 9 apply to countermodel theorems, whose premises `Uses.lean` cannot see?
- **OQ6.** (Resolved by correction, recorded for completeness.) `ANSWERS.md` said the Theravādin rejects §907's counter; the
  mūla rejects only "all permanent".

## The next run this one points to (not registered; the founder's call)

A corrected statement, as a NEW run: represent the citta stream; tie presence to birth (and past it, finitely); state the base's
presence at the consciousness's arising under A116's own name; and test the duration reading SEPARATELY on the two commentarial lines
(matter arising only at a citta's arising sub-moment — the Mūlaṭīkā — versus at all three — the Sammohavinodanī, Vibhāvinī, Ledi).
Predicted: REFUTED on the first line, INDEPENDENT on the second — the commentarial dispute, made exact.
