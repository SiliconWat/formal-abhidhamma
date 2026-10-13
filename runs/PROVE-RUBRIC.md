# The `/prove` rubric — what a proof run is, and what makes one STRONG

*Public on purpose, and cited by commit in every proof run's `PREREG.md`: the rubric is fixed BEFORE the attempt it grades.
Founder 2026-10-13 (the design approved *"All excellent"*; built on *"go"*). A change to this file is a new commit, so each
run is graded by the rubric as it stood when the run was registered.*

## What a proof run is

Abhidhamma mode (`/abhidhamma`) faces OUTWARD: it presumes the texts and asks what physics would have to be. A proof run
faces INWARD: **given these axioms, do the texts commit you to this thesis?** It needs no physics and, unless the thesis
says something about nature, no window (`--window none`).

A proof run starts from a THESIS (the founder's, or a control's) and ends in exactly one of four outcomes. **Every
attempt is recorded, whichever outcome it reaches** — a list of successes only would be a survivorship record.

| Outcome | What Lean shows |
|---|---|
| **PROVED** | the thesis follows: `theorem … : T` from the registered axioms |
| **REFUTED** | its negation follows: `theorem … : ¬ T` |
| **INDEPENDENT** | the axioms do not settle it: one model where they hold with T, one where they hold with ¬T. Often the best result — it shows where the texts are silent and a commentary filled the gap |
| **NOT FORMALIZABLE** | the thesis could not be stated in Lean without a choice the texts do not make; it stays a reading |

## The order (each step before the next)

1. **The formal statement is approved** before any proving — by the founder for his thesis; for a control, by the vetting
   refuter (step 3). An imprecise thesis proved perfectly proves the wrong thing.
2. **The texts are searched** (every spelling) for the thesis itself. If a text already STATES it, the run can still
   check it, but the result is a reading reproduced, not a finding.
3. **A control's case is vetted by a refuter** before registration (is the texts' answer really what we say it is?).
4. **Blind back-translation.** An agent that sees ONLY the Lean statement (no thesis, no Pāli, no doctrine) writes what
   it asserts; it is compared with the approved statement before registration.
5. **Pre-registration** (`runs/prereg.py --proof`): the thesis, the exact Lean statement, the axioms (rows verbatim),
   the HELD-OUT answers, the predicted outcome (the founder's and the session's, separately — calibration), this rubric's
   commit. Pushed before the attempt; never edited.
6. **The attempt**: the thesis, then its negation, then two models.
7. **The refuter attacks the ENCODING** — whether the Lean says what the Pāli says — not only the logic.
8. **The grade** against this rubric, written in `RUN.md`; `runs/INDEX.md` and `kala/THEOREMS.md` regenerated.

## STRONG — every item, or the run is not strong

1. **Every axiom used is VERIFIED** at its cited line (no RECALLED row; no ADDED reading left unverified).
2. **Nothing load-bearing holds BY CONSTRUCTION** — the type must not do the work the axiom is supposed to do, **in either
   direction** (A388 OQ4, 2026-10-13): a result that depends on what the type CANNOT express (no citta stream, presence not
   tied to birth) is by construction too. Every PREREG declares its **type freedoms** before the attempt.
3. **A model** satisfies all the registered hypotheses together (the theorem is not vacuous).
4. **Every relied-on axiom has a break that must fail**: drop or weaken it, and the proof no longer checks.
5. **The axioms used are READ FROM LEAN** (`kala/THEOREMS.md`, via `tools/Uses.lean`), never declared; an UNUSED
   hypothesis is reported as a finding. A countermodel's premises sit inside an `∃`, so they are written as DEFINITIONS
   named by their axiom ID (A388 OQ5) — then they are read like any other.
6. **The logic is reported**: constructive, or classical (`Classical.choice`). Constructive grades higher.
7. **No held-out answer is a premise — alone or as a SET** (A388 OQ3, 2026-10-13). The texts' own conclusions
   (`kala/ANSWERS.md`) are what a run is TESTED against, never what it reasons from. `scripts/leak-check.py` asks Lean
   whether each premise set (`def premises_<thm>`) yields each held-out answer (`def answer_<key>`) in ONE bounded
   automated step (`grind`): on the run's own known answer that is **TRIVIAL** (reported; not STRONG), on any other it is
   a **LEAK** (CI fails). ⚠️ The threshold is declared, not discovered: a deeper restatement passes unseen.
8. **The refuter found no defect in the encoding** that the run did not repair or narrow.
9. **The layer is named**: the latest tier among the axioms used (Piṭaka · commentarial · sub-commentarial · manual ·
   manual's commentary · ours). A theorem that holds in the Piṭaka layer is stronger than one that needs the manual.

## Intake — refused before any work

- ⛔ **The undeclared questions** (*avyākata*: the world eternal or not, finite or not, the life-principle the body or
  not, the Tathāgata after death in the four ways). The texts set them aside; classical logic would happily "settle"
  one by excluded middle. A thesis that turns on one is refused.
- ⛔ A thesis about nibbāna as produced, left over, or a moment — those are ratified guards, not open questions.
- A thesis about nature (physics, consciousness science) goes to `/abhidhamma`, not here.

## Admission to the series *Theorems of the Abhidhamma*

A run may become a paper only if it is STRONG and either the thesis is not already stated in the texts, or the outcome
is REFUTED or INDEPENDENT. A proof of what the texts already say is a check, not a paper.

## Naming convention (since A388, 2026-10-13)

- **Each premise is a DEFINITION named by its axiom ID**, lowercase: `def a87_purejata (w : World) : Prop := …`, used as a
  hypothesis (`(h87 : a87_purejata w)`) and inside any `∃`. `kala/THEOREMS.md` maps it to its ID wherever it is reached.
- **Each theorem's premise set** is `def premises_<thm> (w) : Prop := a87_purejata w ∧ …`.
- **Each held-out answer the run is near** is `def answer_<key> (w) : Prop`, its docstring starting `ANSWER: <the
  ANSWERS.md key>`.
- Older runs name hypotheses (`a3_tick`) instead; `THEOREMS.md` reads those too.

Lean proves that a conclusion follows from these definitions — never that the definitions are faithful to the texts,
and never that nature agrees.
