# Results — arm A

Results are appended below; an earlier result is never edited. Predictions are scored against `PREREGISTRATION.md` (commit `259e5e8`). The scoring stays **provisional** until the scored conditions are fully met.

---

## 2026-09-27 — Rung 2: the 89 and the 121 at layer L2 (*Abhidhammattha-saṅgaha* ch. 1–2)

`sangaha/run.sh` (Lean 4.34.1, no dependencies) → **PASS, 9 theorems, all by `decide` (kernel evaluation, no compiled code trusted); 6 of 6 deliberate breaks fail.**

### What was built

- **`Citta.lean`, the generator.** It has 9 clauses (§G1–§G9), each over the classification axes of ch. 1 (class, plane, feeling, root, element, knowledge, view, prompting, jhāna, base, path). None lists a citta by name except §G5, whose three rootless functionals are written out member by member.
- **`Rules.lean`, the cetasika rules.** It has 18 clauses (§R1–§R18), each a constraint over those axes. **None names an individual citta.**
- **`AnswerKey.lean`, the key.** It is written separately from the rules and holds only figures the text states. Each figure is checked against the Pāli and Nārada's English as printed at `ballwarapol.github.io/sangaha/chapter_2.htm` (§4–§5 per-factor counts, §11–§20 per-citta counts).

### What checks

| Theorem | Statement |
|---|---|
| `n89` · `n121` | the generator yields exactly 89 and 121 types |
| `distinct121` | no two are the same point |
| `profile89` · `profile121` | the rules give **every** per-citta cetasika count the text states: 19·21·19·21·18·20·18·20 · 20·22 · 15·15 · the 18 rootless (7…12) · 38/37/37/36 · 33/32/32/31 · 35/34/34/33 · 35/34/33/32/30 · 30 · 36/35/34/33/33 |
| `occurrences89` · `absences89` | every per-factor count the text gives over 89: universals 89 · adhimokkha 78 · viriya 73 · chanda 69 (without: 11 · 16 · 20) · the unwholesome factors 12/8/4/4/2/5/1 · beautiful universals 59 · abstinences 16 · illimitables 28 · paññā 47 |
| `occurrences121` · `absences121` | the factors the text counts over 121: vitakka 55 · vicāra 66 · pīti 51 (without: 66 · 55 · 70) |

### Scoring (provisional)

- **P-FA1 (89 and 121 at L2, edition C): PROVISIONALLY CONFIRMED.** ⚠️ The key has been collated against one printed edition whose recension the page does not state, **not yet against the Chaṭṭha Saṅgāyana itself.** The prediction names edition C, so it is not scored final until that collation is done.
- **P-FA1b (≥ 3 narrow exception rules): NOT SCORED. The registration did not make it operational.** "Names a narrow class rather than a general principle" was never defined. On the most natural reading (a clause that carves a narrow class out of an otherwise general rule, not counting clauses that define a root's own factor), there are **two**: §R4's doubt clause and §R5's rootless-energy clause. That count would **falsify** it. We do not score a prediction on a definition chosen after seeing the result. An operational version will be registered as a new entry before rung 3.
- **P-FA4 (compression below 0.5 at 121): PROVISIONALLY CONFIRMED.** 27 clauses ÷ 121 rows = **0.22**. Counting §G5's three written-out members as three clauses gives 29 ÷ 121 = 0.24. Over 89 it is 0.30. ⚠️ The ratio depends on what counts as a clause; the registered definition (clauses in the rule file) is what is reported.
- P-FA2 (canon alone) and P-FA3 (Khmer = CST): **not yet run.**

### Observations (our reconstruction, not claims about the text's intent)

1. **The text states some exclusions by enumeration where a general rule is available.** §4(d) excludes energy (*viriya*) from five-door adverting, the ten sense-consciousnesses, receiving and investigating, four classes named one by one. §R5 states it as one rule: *among the rootless, energy only in the functional mind-consciousness element.* The two are extensionally equal (checked). By contrast §R4 (*adhimokkha*: not in the ten sense-consciousnesses, not with doubt) is the text's own §4(c) almost word for word.
2. **The text mixes its reckonings.** Factors whose presence depends on the jhāna (vitakka, vicāra, pīti) are counted over 121; every other factor over 89. A key that reads every figure on one basis would record three false mismatches. The first draft of this key did exactly that, from memory, before it was collated.
3. **One figure was nearly entered wrong from a secondary summary.** A machine summary of the page gave the fifth supramundane jhāna as 32. The text reads *"thirty-six, thirty-five, thirty-four, and thirty-three in the last two"* (33). Every figure in the key is read from the text, never from a summary.

### Honest limits

- **The rules were written by someone who knew the tables.** The guard against circularity is that no rule names a citta, and that the per-factor statements are an independent second key. A knowledgeable author can still fit general rules to a known answer. **The stronger tests are still ahead:** the canon alone (P-FA2) and a second edition (P-FA3).
- **The generator restates chapter 1's axes; it does not discover them.** What it shows is that the 89/121 is exactly a product structure over those axes with nine clauses.
- This checks internal consistency: conclusions follow from definitions. It says nothing about whether the Abhidhamma is true.
