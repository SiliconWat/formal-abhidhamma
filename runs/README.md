# runs/ — the ledger of Abhidhamma-mode runs

One directory per run: `<date>-<slug>/`.

1. **`PREREG.md`** — written and PUSHED by `prereg.py` BEFORE the `abhidhamma` agent sees the
   question: question, window (A0 / A0′ / both), the axiom rows copied verbatim from
   `kala/AXIOMS.md`, predictions, pass criteria. GitHub's push record is the timestamp. **Never edited.**
2. **`RUN.md`** — written after: each derivation (plain English, then Unicode maths) marked
   AGREES / EXTENDS / COLLIDES; the refuter's finding (KILLS / NARROWS / CONTRAST); the survivor;
   its Lean theorem name, or UNCHECKED / NOT A DERIVATION; each prediction scored against PREREG.
3. **Lean** for the survivors, importing `../../kala/Axioms.lean`, with a `run.sh` whose breaks must fail.

**The presumption.** Abhidhamma mode PRESUMES the Theravāda Abhidhamma correct and physics incomplete,
and derives what physics would have to be for the texts to hold. Every result is conditional on the
axioms named. A result is candidate physics only with a distinguishing measurement; otherwise it is
philosophy. Lean proves a conclusion follows from these definitions — never that the definitions are
faithful to the texts, and never that nature agrees.

**Controls.** Some runs are chosen because the texts should LOSE (`PREREG.md` says CONTROL). The mode
passes such a run only by reporting COLLIDES plainly; a rescue by reinterpretation is a FAIL.

Runs dated 2026-09-30 before `prereg.py` existed are marked **RETROSPECTIVE** — not pre-registered.

**Proof runs** (`/prove`, founder 2026-10-13). A run that asks whether the texts COMMIT you to a thesis — no physics,
usually no window. Its `PREREG.md` (written by `prereg.py --proof`) fixes the thesis, the exact Lean statement, the
axioms, the held-out answers and two predicted outcomes (the founder's and the session's) before the attempt; its
`RUN.md` records one OUTCOME — PROVED · REFUTED · INDEPENDENT · NOT FORMALIZABLE — and a GRADE, STRONG or NOT STRONG,
against [`PROVE-RUBRIC.md`](PROVE-RUBRIC.md). Every attempt is recorded, whatever its outcome. A known-answer control
must reproduce a row of [`kala/ANSWERS.md`](../kala/ANSWERS.md), the texts' own conclusions, which no run may use as a
premise. Every theorem lands in [`kala/THEOREMS.md`](../kala/THEOREMS.md), generated from the Lean.
