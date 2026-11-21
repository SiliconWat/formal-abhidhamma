# Chapter 3 · Method

*Thon Ly · Miss Aquarius℠ (AI collaboration, disclosed). Living draft: not frozen, never stamped, free to change. CC0-1.0. Who did what is in `CONTRIBUTIONS.md`, a table whose lines are still a draft for Thon Ly to confirm. Translations from the Pāli are ours. Citations give file:line in the Chaṭṭha Saṅgāyana (CST) as decoded, at `VipassanaTech/tipitaka-xml` text `05d5d3c`, with the CST file's layer and this repository's tier (`kala/AXIOMS.md`): Piṭaka, commentarial, manual, the manual's commentary, or ours. Open items are marked **GAP** and collected at the end.*

---

## 3.1 · What the method has to do

The tradition says the Abhidhamma's types of consciousness (*citta*) arise by composition from its mental factors (*cetasika*). That sentence can be tested only if it can fail. The method in this chapter exists to make failure possible, and to make a pass mean something when it comes.

These terms were fixed in writing before any code existed (`PREREGISTRATION.md` §1).

- A **general rule** is a constraint over classification axes or factor classes. It never names an individual type.
- The **generated set** is the list of types, each with its factors, that satisfies all the rules of a layer.
- The **compression ratio** is the number of rule clauses in the Lean rule file, datatype declarations excluded, divided by the number of rows generated.
- The **layers** are L1, the canon (the *Dhammasaṅgaṇī*'s account of the arising of consciousness and of its factors); L2, L1 with chapters 1–2 of the *Abhidhammattha-saṅgaha*; and L3, L2 with the commentaries (the *Aṭṭhasālinī*, the *Vibhāvinī*). The **editions** are K, the Khmer edition of the Buddhist Institute, Phnom Penh, and C, the Chaṭṭha Saṅgāyana in the Vipassana Research Institute's digital text.

The tool is Lean 4, with no dependencies. Every theorem reported in chapters 4 and 5 is proved by `decide`: the kernel evaluates the statement, and no compiled code is trusted. It is worth saying at once what that buys. The domain is finite, 121 rows by 52 columns, and a short script would compute the same numbers. The kernel adds a trusted evaluator and a checked artifact. It adds no deductive depth. A proof assistant verifies that conclusions follow from stated definitions, and nothing more. Whether the definitions say what the Pāli says is a question a reader answers by hand, using the citations this chapter requires.

Nothing here tests whether the Abhidhamma is true.

---

## 3.2 · The order of the work

The claims of this program depend on order: predictions before code, a synonym map before the text it maps. So the order is the first thing to report, and it is reported from the record rather than from memory.

| Step | Commit | What it did | Date evidence |
|---|---|---|---|
| a | `259e5e8` | first pre-registration: definitions, control, predictions, kill criteria | GitHub's activity record: 2026-09-27T22:07:02Z, read again on 2026-11-05 |
| b | `e1ed2bd` | rung 1: the control, written after the push | commit date only |
| c | `b9070d4` | rung 2: the generator, the rules, a key collated from one printing | commit date only |
| d | `c5c77fb` | rung 2b: the key collated against the CST; chapter 3 of the *Saṅgaha* added as a second key | commit date only |
| e | `f4a26e5` | second pre-registration: the synonym map, the canon-only and edition predictions, before either edition of the *Dhammasaṅgaṇī* was read | GitHub's activity record: 2026-09-27T23:04:29Z, read again on 2026-11-05 |
| f | `ada7a20` | rung 3: the canon alone, and K against C | commit date only |
| g | `74e19fe` | corrections from an adversarial reading of the *Aṭṭhasālinī* | commit date only |
| h | `c9136e1` | corrections from the first cold review of the paper | commit date only |

Steps a through g fall on one calendar day (2026-09-27), and step h on the next morning. A short interval between a prediction and its test does not weaken the order, but a reader should know it. The ladder was climbed quickly, and §3.3 says what prior knowledge does to the predictions.

Only the two pre-registrations rest on a date the authors cannot set. A local commit date can be set by hand. The pushes are written by the host.

---

## 3.3 · Pre-registration, and what it does not prove

Two files were pushed before the work they govern, and neither has been edited. A correction is a new file, as the first file's opening line requires and as the second file demonstrates by citing the first.

| ID | Prediction (abridged from the registered wording) | Confidence | File |
|---|---|---|---|
| P-FA1 | at L2, edition C, general rules generate exactly 89 types, and 121 with the five-jhāna expansion | 0.6 | first |
| P-FA1b | P-FA1 requires at least 3 exception rules naming a narrow class | 0.7 | first |
| P-FA2 | at L1 the rules are under-determined or differently partitioned | 0.65 | first |
| P-FA3 | editions K and C yield identical counts at L2 | 0.85 | first |
| P-FA4 | compression at L2 is below 0.5 at 121 rows | 0.5 | first |
| P-FA2a | the operational form of P-FA2: in C, the first wholesome type's list names exactly 29 distinct factors, none of the 9 the prediction lists by name, and closes with an open clause | 0.75 | second |
| P-FA2b | zero unmapped terms in C's list | 0.6 | second |
| P-FA5 | K's list, transliterated and normalized, names the same terms in the same order as C's; any difference is orthographic only | 0.8 | second |

Outcomes are in the chapters that carry them: P-FA1, P-FA1b and P-FA4 in chapter 4; P-FA2, P-FA2a and P-FA2b in chapter 5; P-FA3 and P-FA5 in chapter 6. The predictions are also entered in the public prediction register (thonly.org/research/program/register).

**What a push time proves.** That the file existed in public by that moment, in that form. So the statement "the predictions preceded the code, and the synonym map preceded the *Dhammasaṅgaṇī* reading" is a property of the record. No one has to be believed about it.

**What a push time cannot prove.** What the predictor already knew. The *Saṅgaha*'s tables are in print, and the first pass of this project's answer key was built from memory of them (§3.4). So P-FA1 and P-FA4 are not predictions of unknown figures. They are predictions about whether general rules could be written to fit known figures. The second file's claim is narrower and stronger: it states that no CST *Dhammasaṅgaṇī* file had been fetched before its push, and exactly what Khmer text had been seen by then (the title line of the first two pages of volumes 77–80). No record can establish what the authors, or a language model, already carried from earlier reading or training. This limit is not closed, and it is named again in chapter 5.

**Two predictions did not survive as registered, and the record keeps both.**

- *P-FA1b.* Its test, "a narrow class", was never defined. On the most natural reading the count came out 2, which would falsify it, but that reading was chosen after seeing the data. `RESULTS.md` first promised an operational version before rung 3. The second file retired it unscored instead, for the stated reason that any definition chosen after the data would be chosen knowing the answer. The promise and the retirement both stand in the record.
- *P-FA3.* It compares editions at L2, which includes the *Saṅgaha*. That work is not part of the Khmer Tipiṭaka, and the one Khmer-script copy held reproduces the CST's paragraph structure. It could not run. P-FA5 replaces it at L1, as a new prediction and not as an edit (chapter 6).

**The kill criteria** (`PREREGISTRATION.md` §4), and where each stands.

| Criterion | Status |
|---|---|
| no layer generates the counts: report that as the result, and look for the missing rule | did not fire at L2 (chapter 4); see GAP 5b for L1 |
| the C2 break does not fail: the instrument is blind, so stop, fix, re-register | did not fire (§3.5) |
| P-FA3 false: trace the variant before any other claim | not reached; P-FA3 could not run |
| arm B's parameter predicts nothing out of sample: close arm B | not reached; arm B is not part of this dissertation |

---

## 3.4 · The key is kept apart from the rules

The formalization is nine generator clauses and 18 rule clauses in two files, `sangaha/Citta.lean` and `sangaha/Rules.lean`. The figures they must reproduce are in a third, `sangaha/AnswerKey.lean`, and the assertions that join them are in a fourth, `sangaha/Check.lean`. A rule set allowed to read the key could restate it, and then a pass would mean nothing.

**What goes in the key.** Only figures the text states, each cited to its CST paragraph (`APPARATUS.md` gives the map). A figure the text does not state is never keyed. So the key holds row totals and column totals and no cell of the table, a limit taken up in §4.8.

**How the key was built.** In three passes, and the order is part of the result.

1. From memory, as the tables are rendered in Bhikkhu Bodhi's *Comprehensive Manual*. This pass contained an error. The text counts vitakka, vicāra, pīti and the feelings over 121, and every other factor and the roots over 89. The first draft read everything on one basis, which would have recorded false mismatches.
2. Against a second printing (the Pāli with Nārada's English). This pass exposed a different hazard: a machine summary of the page gave the fifth supramundane jhāna as a figure the text does not state. The rule since then is that every figure is read from the raw text and never from a summary.
3. Against the CST itself, paragraph by paragraph (`abh07t.nrf.xml` in its range of lines 13–3497, layer other, tier manual). This pass found no disagreement with the second.

**One modeling choice stands between the key and the text.** At the 89 reckoning each supramundane type is taken at the first jhāna, so its row in `profile89` is the text's first-jhāna figure of 36 (§36, `abh07t.nrf.xml:593`, layer other, tier manual). The figure is the text's. Its assignment to the 89 reckoning is ours.

**What separates the files is a rule, not a property.** Nothing stops a future author from importing the key into the rules. §3.9 lists which guards hold without anyone's care, and this is not one of them. The partial remedy is that the rules were read from the text's factor-by-factor sentences and are checked against its type-by-type totals, which they were not read from (§4.5).

---

## 3.5 · The instrument is tested on a known answer and a known failure

Before the rule set was trusted it ran on a case with a certain answer. The registered control has two parts.

- **C1, the known answer.** The eight wholesome sense-sphere types form a product of three binary axes: joyful or equanimous feeling, with or without knowledge, unprompted or prompted. Their traditional combination counts are 38, 37, 37 and 36 for the four pairs of feeling and knowledge, and prompting changes nothing. `control/Rules.lean` gives six general rules, and the theorem `profile` must check.
- **C2, the known failure.** `control/Broken.lean` is the same file with the rule "pīti arises only with joyful feeling" deleted. The equanimous pairs then come out wrong, and the theorem must fail to check. If it checks, the instrument is blind and nothing else is reported.

Run again for this draft:

```
$ control/run.sh
C1 ✓ the eight wholesome cittas: 8 types, 38·38·37·37·37·37·36·36
C2 ✓ deleting 'pīti only with joy' breaks the count, as required
```

The compression on the control is 6 ÷ 8 = 0.75. The control shows the checker can see an error of this kind. It says nothing about whether the rules are faithful to the text, and it is not offered as evidence for that.

---

## 3.6 · The breaks

A checker that has only ever passed is an untested claim. So the full formalization carries deliberate faults, applied by `sangaha/run.sh` on every run.

| Where the fault is seeded | Breaks |
|---|---|
| the rules (`Rules.lean`) | 4 |
| the key (`AnswerKey.lean`) | 2 |
| the generator (`Citta.lean`) | 2 |
| the canon list (`Canon.lean`) | 1 |
| **total** | **9** |

Three details of the harness carry weight. It copies the sources to a temporary directory and edits the copy, so a break cannot leak into the real files. It refuses a break whose edit changed nothing (`BREAK NOT APPLIED`). And a break that stops the files from compiling is treated as a harness failure and not as a successful break: the fault must compile, and the theorems must then refuse it. The whole suite exits nonzero if any break still checks, and the workflow `.github/workflows/lean.yml` runs it on every push.

The set grew with the rungs: 6 at rung 2, 8 at rung 2b, 9 at rung 3. All are listed in §4.6.

The technique is mutation testing (DeMillo, Lipton and Sayward 1978). Its use inside a proof assistant is established (Celik et al., ASE 2019), and *The Counts Check* records what its census found of the neighbors. These breaks are chosen by hand, so they sample the fault space and do not cover it. An exhaustive version exists as an instrument: `rung4/mutants.py` lists 156 single-point mutants of `arises`. It has been tested only on a toy with planted outcomes and has not been run on the real rules. See GAP 3a.

---

## 3.7 · Layers and editions as variables

This program treats the textual layer and the edition as variables, because the question "where do the counts come from?" has an answer in the history of the text as well as in its logic.

**The layers were mis-specified, and the correction is part of the method.** The first file ordered them canon ⊂ canon + manual ⊂ canon + manual + commentaries. That order is editorial. On the conventional datings, which *The Counts Check* takes from Bodhi's introduction to the *Comprehensive Manual* and which were not re-read for this draft, the *Aṭṭhasālinī* (c. 5th century CE) predates the *Saṅgaha* (no earlier than the 8th, more probably the 10th to early 12th). So the registered order cannot be read as history. The result in chapter 5 turns on this. The Lean checks inclusion and remainder, and the attribution of the remainder to a layer rests on reading. No theorem establishes it.

**The editions are not independent.** The CST is the Burmese recension, and the Khmer edition's apparatus cites Burmese readings. Agreement between them is agreement between relatives. `APPARATUS.md` requires this to be said wherever agreement is reported, and chapter 6 says it.

**Text the repository may not hold.** No Khmer-edition text is committed here, only counts, positions and single romanized terms (`PREREGISTRATION-2026-09-27b.md` §5). This has a price, and chapter 6 states it: the K side of the comparison cannot be rerun from this repository alone.

---

## 3.8 · Timestamps

`TIMESTAMPS.md` names three independent dates behind each claim.

1. **The push**, recorded by GitHub (§3.2).
2. **RFC 3161.** A manifest of every tracked file and its SHA-256, weekly and on every push that touches `kala/`, `matika/` or `runs/`, signed by three trust authorities, one of them eIDAS-qualified, and stamped to Bitcoin (`timestamps/`, `./tsa-verify.sh`).
3. **OpenTimestamps.** Frozen files carry a `.ots` proof beside them, which can be checked without trusting this repository, GitHub or the authors.

A timestamp proves that these exact bytes existed by a date. It proves nothing about authorship, originality or whether a claim is right.

The rule for the dissertation is in its `README.md`. A chapter is living until it is declared final and moved to `dissertation/final/`, where it is stamped and never edited again. These chapters are living drafts, so they carry no proof of their own. Once committed they will appear in the weekly manifest with every other tracked file.

One inconsistency in the record should be stated here rather than discovered by an examiner. 7 planning files in `dissertation/` carry `.ots` proofs from 2026-10-15, although `README.md` says drafts outside `final/` are never stamped. They attest real text and harm nothing, but each will read as stale after its next edit. See GAP 3e.

---

## 3.9 · Which guards hold by themselves

A guard that needs someone's restraint at the moment it is tested is a rule. A guard that holds whether or not anyone is careful is a property. This table is the one in *The Counts Check* §3.4, carried over.

| Guard | Kind | Why |
|---|---|---|
| the predictions precede the code and the *Dhammasaṅgaṇī* reading | **property** | the push record is written by the host |
| the predictor did not know the *Saṅgaha*'s tables | **not claimed** | the tables were known (§3.3) |
| the breaks keep testing the checker | **property of the harness** | re-applied on every run; a break that changes nothing is refused |
| a figure is the text's and not the author's | **checkable rule** | each key figure carries a paragraph number that any reader can check, but nothing forces a future editor to keep it right |
| the rules never read the key | **rule** | separate files, and nothing stops an import |
| no Khmer-edition text is published | **rule** | the scripts print only terms and counts, but a contributor could commit the transcription |

Two are properties, one is not claimed, and three depend on care. A successor to this repository needs to know which is which.

---

## 3.10 · Where the figures in these chapters come from

The rule in `dissertation/README.md` is that every number comes from `numbers.json`, which `reproduce.sh` regenerates from the Lean and which CI checks for staleness. As of this draft `numbers.json` holds 14 keys. They carry the headline figures: the 89 and 121, the 52, the 9 and 18 clauses and their total of 27, the two ratios, the 29, 38 and 9.

These chapters quote many more figures than that: each rule's extension, each per-type count, the theorem and break totals, and the edition counts. Each of those was produced for this draft by one of four routes and checked by script, and none was typed from memory:

- evaluation of the repository's own Lean definitions (`arises`, `count`, `occurrences`, the key);
- the output of `control/run.sh`, `sangaha/run.sh`, `canon/pada.py`, `canon/compare.py` or `rung4/mutants.py list`;
- the decoded CST, at a cited line;
- a frozen or dated record in this repository (the pre-registrations, `RESULTS.md`), where the figure cannot be regenerated here.

So the rule as written is stricter than the mechanism as built. See GAP 3c.

---

## 3.11 · Authorship

An examiner's first question about AI-assisted research is who did what. `CONTRIBUTIONS.md` answers in the roles of the CRediT taxonomy, and the disclosure line is the one used across this repository: Thon Ly · Miss Aquarius℠ (AI collaboration, disclosed). As drafted there, the Lean, the scripts, the controls and the drafts of these chapters are the AI collaboration's work; the program's question, each approval, the rulings on disputed readings and final editorial control are Thon Ly's. Every line of that table is marked as a draft reading of the record, and none is final until he confirms it. This chapter therefore cites the table and does not restate it as settled.

The consequence for the method is direct. The author of the rules and the reader who collated the key share a substrate. The separation of files, the pre-registration and the breaks are the available defenses against that, and none of them is an outside reader. See GAP 3d.

---

## 3.12 · What the method does not yet cover

**GAP 3a. Rung 4 has not been registered or run.** Its instruments are built and tested on known answers (`rung4/run.sh`), and its pre-registration is a draft awaiting a decision (`RUNG4-PREREG-DRAFT.md`). Until it runs, the method has no measure of the table against an objective minimum, no null models, and no measure of what the key cannot see. The examiner's test in `OUTLINE.md` asks for exactly these, so the method as reported here does not yet meet it.

**GAP 3b. No rung extends the layer and edition comparisons beyond the first type.** The outline owes a new pre-registered rung. It is not written, and these chapters do not write it. Chapters 5 and 6 report one list.

**GAP 3c. `numbers.json` does not yet hold every figure the chapters quote.** The checking script for this draft is outside the repository. The rule in `README.md` is met in full only when `Numbers.lean` prints the rest and a check over the chapter text runs in CI.

**GAP 3d. No outside reader has read any of this.** `READERS.md` records that none has been invited. The only other readings on record are the adversarial reading and the cold-review round in `RESULTS.md`, and neither is recorded as an outside human reading.

**GAP 3e. Two stamping policies disagree** over living drafts (§3.8). The repository's policy is the one stated in `README.md` and `TIMESTAMPS.md`.
