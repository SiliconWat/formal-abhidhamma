# Outline (working draft)

## The question

The tradition says the Abhidhamma's types of consciousness (*citta*) arise *by composition* from its mental
factors (*cetasika*). Written as general constraints, never as a per-citta table, do the combination rules
generate exactly the traditional counts? In which textual layer do the counts first become derivable, and do
the two editions (Khmer and Chaṭṭha Saṅgāyana) agree?

## Chapters, mapped to what already exists

| # | Chapter | Draws on | State |
|---|---|---|---|
| 1 | Introduction: the claim of composition, and what a proof assistant can and cannot show | `README.md` §What this is not | to write |
| 2 | Background: the four ultimates, the textual layers, the two editions, prior formal work | `SOURCES.md` | to write |
| 3 | Method: pre-registration before code, controls on a known failure, kill criteria, layers as a variable, timestamps | `PREREGISTRATION.md`, `control/`, `TIMESTAMPS.md` | results exist; to write up |
| 4 | Result I, the counts: 9 generator clauses and 18 cetasika rules, none naming a citta, give all 89 and 121 citta-types and every count in chapter 2 of the *Saṅgaha*; every deliberate break fails | `sangaha/`, `RESULTS.md` (Rungs 2 and 2b; P-FA1, P-FA4 confirmed against the CST) | results exist; to write up |
| 5 | Result II, the layers: the canon alone names 29 of the 38 cetasikas of the first wholesome citta (the *Aṭṭhasālinī*'s *samatiṃsa*); the other nine are the commentary's *yevāpanaka*, inherited and contradicting none | `canon/`, `sangaha/Canon.lean` (Rung 3; P-FA2a, P-FA2b) | results exist; to write up |
| 6 | Result III, the editions: the Khmer edition and the CST name the same 56 terms in the same order | `canon/` (Rung 3; P-FA5) | first citta only; **extend** |
| 7 | Result IV, commitments: what the axioms commit you to, settled in Lean (proved, refuted, independent) | `kala/`, `runs/INDEX.md` | select which runs belong |
| 8 | Limits, and the hostile question (below) | `RESULTS.md` corrections, the null model | **owed** |
| 9 | Conclusion | | to write |

Appendices: the Lean sources, the run ledger, the timestamp record.

## The hostile question, answered in the dissertation itself

A taxonomy built on a few binary axes is *expected* to compress. "General rules reproduce the table" is
therefore close to guaranteed, and an examiner will say so. The answer has to be measured, not argued:

1. **A null model.** Fit rule sets of the same form to tables with the same margins but shuffled entries.
   If the textual table compresses far better than its shuffles, the structure is real. If every axis-built
   table compresses about as well, the finding is the weaker one, and chapter 8 says so.
2. **The ratio, reported.** Rules over rows, beside the null model's distribution.
3. **The failures, foregrounded.** Every place a general rule fails or needs an exception: a rule lost in
   transmission, or a rule never stated. That is where the finding is.

## Owed, in order

1. The null model (chapter 8). Pre-register it as a run before any code, like every other run here.
2. Extend the edition comparison beyond the first citta (chapter 6), and the layer comparison with it.
3. Choose the proof runs that belong in chapter 7, by the rubric's grades, failures included.
4. Write chapters 3–6 from the results that exist; then 1, 2, 8 and 9.
