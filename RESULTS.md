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

---

## 2026-09-27 (later) — Rung 2b: collated against the Chaṭṭha Saṅgāyana; chapter 3 as a second key

**Source:** the VRI's own text, [`VipassanaTech/tipitaka-xml` `romn/abh07t.nrf.xml`](https://github.com/VipassanaTech/tipitaka-xml) (*Abhidhammatthasaṅgaho*). `AnswerKey.lean` now cites a CST paragraph for every figure. **Every figure in the key matches the CST:**

- per-factor §13–§19, including the verse at §19, word for word as in the earlier printing;
- unwholesome §20–§27;
- beautiful §28–§32;
- supramundane §36–§37, *"Chattiṃsa pañcatiṃsa ca, catuttiṃsa … Tettiṃsadvayam"*: 36 · 35 · 34 · 33 · 33;
- sublime §38–§39;
- sense-sphere beautiful §40–§41;
- the unwholesome groupings §43–§51, *"Ekūnavīsāṭṭhārasa, vīsekavīsa vīsati. Dvāvīsa pannarasa"*;
- rootless §53–§58.

`sangaha/run.sh` → **PASS, 12 theorems; 8 of 8 deliberate breaks fail.**

### Three new theorems

| Theorem | Statement | What it tests |
|---|---|---|
| `feelings121` | ch. 3 §3–§9, *"Sukhamekattha dukkhañca, domanassaṃ dvaye ṭhitaṃ. Dvāsaṭṭhīsu somanassaṃ, pañcapaññāsaketarā"*: pleasure 1 · pain 1 · displeasure 2 · joy 62 · equanimity 55 | the generator's **feeling** axis against a chapter it was not built from |
| `roots89` | ch. 3 §10–§17: rootless 18 · one-rooted 2 · two-rooted 22 · three-rooted 47 | the generator's **root and knowledge** axes, likewise |
| `keci_reading` | ch. 2 §30 records a dissent: *"upekkhāsahagatesu panettha karuṇāmuditā na santīti keci vadanti"* (some say compassion and appreciative joy are absent with equanimity). Under that reading the illimitables occur in **20** cittas; under the main reading, **28** | **The text's own count decides between the two readings it reports.** §30 states 28, so the main reading is the one the counts presuppose |

### Scoring (final for these two)

- **P-FA1: CONFIRMED.** At L2, edition C, general rules generate exactly 89 citta-types and 121 with the five-jhāna expansion. Every per-citta and per-factor count the CST states is reproduced.
- **P-FA4: CONFIRMED.** Compression 27 ÷ 121 = 0.22 (0.24 counting §G5's members singly).
- **P-FA1b: still NOT SCORED** (registration not operational). An operational version will be registered as a new entry before it is tested.
- **P-FA2, P-FA3: not yet run.**

### ⚠️ A finding about P-FA3 as registered

P-FA3 compares the Khmer edition (K) with the CST (C) **at layer L2, which includes the *Saṅgaha***. The *Saṅgaha* is a post-canonical manual, **not part of the Khmer Tipiṭaka**; the Buddhist Institute canon ends with the Abhidhamma Piṭaka. The one Khmer-script *Saṅgaha* we hold (a 2022 PDF) is set with the CST's own paragraph numbering, so it is **probably the CST transliterated, not an independent Khmer recension** (under test). If so, P-FA3 **cannot be run as registered.** A Khmer-vs-CST comparison **of the canon (L1, the Dhammasaṅgaṇī)** is possible, but that is a *different* prediction. It must be registered, as a new entry, before any Khmer text is read.

---

## 2026-09-27 (night) — Rung 3: the canon alone (L1), and the Khmer edition against the CST

Pre-registered in `PREREGISTRATION-2026-09-27b.md` (commit `f4a26e5`, GitHub push 2026-09-27T23:04:29Z), with the synonym map fixed there before either text was read. Entered in the public prediction register before this run.

### P-FA2a — CONFIRMED (the canon alone does not give the 38)

**Edition C** is VRI `romn/abh01m.mul.xml`, §1, the *pada-bhājanīya* of the first wholesome sense-sphere citta. `canon/pada.py` finds **56 terms**, mapping to **exactly 29 distinct cetasikas**. **None** of *chanda, adhimokkha, manasikāra, tatramajjhattatā, karuṇā, muditā* or the three abstinences is named. The list closes with the open clause *"ye vā pana tasmiṃ samaye aññepi atthi paṭiccasamuppannā arūpino dhammā"*. The nine-factor detector was first tested on a control list naming four of them; it caught all four, inflected forms included.

**In Lean** (`sangaha/Canon.lean`, 4 theorems):
- the canon's 29 are distinct;
- **every one is also given by the *Saṅgaha*'s rules for this citta (L2 adds to L1, never contradicts it);**
- what L2 adds is **exactly the nine *ye vā pana* factors**, so 29 + 9 = 38.

A deliberate break (counting *chanda* as named) fails.

### P-FA2b — CONFIRMED, with one disclosure

The **first run reported 2 UNMAPPED terms, *kāyujukatā* and *cittujukatā***. Both are **sandhi** forms (kāya + ujukatā, citta + ujukatā), and §3 of the pre-registration requires sandhi to be normalized before mapping; the script had not implemented that case. With the vowel-elision rule added (it is in `pada.py`, commented as added after the first run), **0 terms are unmapped**. Both runs are reported here. Neither the map nor the prediction was changed.

### P-FA5 — CONFIRMED (same terms, same order)

**Edition K** is the Buddhist Institute edition, volume 78 (Dhammasaṅgaṇī part 1), pp. 16–17, as transcribed. It was transliterated by `canon/khmer_pali.py` (10/10 on a control of known words) and aligned by `canon/compare.py`: **C 56 terms · K 56 terms · 48 identical · 8 spelled differently · 0 added, dropped or reordered.**

Each of the 8 was checked against the **printed page image** (the scan of volume 78, pp. 16–17), as §4 requires:

| Pos. | CST | Transcription | Printed page | Verdict |
|---|---|---|---|---|
| 37 | *hirī* | *hiri* | *hiri* | **edition orthography** |
| 39 | *kāyapassaddhi* | *kāyappassaddhi* | *kāyappassaddhi*, with the edition's own note: Burmese reads *kāyapassaddhi* | **edition orthography, recorded in its apparatus** |
| 40 | *cittapassaddhi* | *cittappasaddhi* | *cittappassaddhi* | edition orthography (*pp*); the single *s* is a transcription slip |
| 10 | *cittassekaggatā* | *cittaspekaggatā* | *cittassekaggatā* | transcription slip |
| 17 | *somanassindriyaṃ* | *somanassidṭhiyaṃ* | *somanassindriyaṃ* | transcription slip |
| 47 | *kāyapāguññatā* | *kāyapātuññatā* | *kāyapāguññatā* | transcription slip |
| 12, 25 | *vīriya-* | *viriya-* | *vīriya-* (long ī; read at moderate confidence from the scan) | transcription slip, to confirm |

**No variant of the term list exists between the two editions for this passage.** Three differences are the Khmer edition's own orthography, which it documents against the Burmese in its apparatus. Five are slips in the working transcription; they have been reported to the transcriber as corrections, never as variants.

### Also found

- **The transcription's subscript order.** Some words carry the subscript RO typed before another subscript (ន្រ្ទ for ន្ទ្រ), which reads as *-inrdiyaṃ*. The transliterator normalizes the order. This is an encoding matter, not a textual one.
- **Page furniture.** A running header between a term and its *hoti* at a page break first produced a false DIFFERENT (*paññābalaṃ* against the header). Page furniture is now stripped before alignment.

### Scope and limits

- This is **one passage**: the first citta's list, the densest in the book. It is not the whole Dhammasaṅgaṇī.
- K is a working transcription. Its text is read privately and **not reproduced here**; only counts and single romanized terms are.
- **Lineage** of the Khmer scans: Kang Huychan and family · Lok Kru Aggapaṇḍita But Savong · Srong Chanda · 5000-years.org. The transcription is by Thon Ly's father.
