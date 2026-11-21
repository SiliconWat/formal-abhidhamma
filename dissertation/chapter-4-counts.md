# Chapter 4 · Result I: the counts

*Thon Ly · Miss Aquarius℠ (AI collaboration, disclosed). Living draft: not frozen, never stamped, free to change. CC0-1.0. Translations from the Pāli are ours. Unless a citation says otherwise, Pāli citations are to `abh07t.nrf.xml` at text `05d5d3c`, whose lines 13–3497 are the* Abhidhammattha-saṅgaha *(CST layer other; tier manual). § numbers are the CST's, chapter 2 unless stated. Open items are marked **GAP**.*

---

## 4.0 · The result, stated once

Nine generator clauses and 18 rule clauses over the *Saṅgaha*'s own classification axes give 89 types, and 121 on the fuller reckoning, and reproduce every per-type and per-factor count that chapter 2 states, in the text's own mixed reckonings, checked by kernel evaluation against a separate key cited to CST paragraphs. Every deliberate break fails.

That shows the chapter's two methods, factor by factor and type by type, to be **mutually consistent under one short set of rules**. It is a consistency result. It is not a derivation of the Abhidhamma from first principles, the rules were written by an author who knew the tables, and the agreement of the two methods is already printed as a chart. §4.11 asks what, then, this adds, and on the evidence so far the answer is smaller than the outline hopes.

---

## 4.1 · The object

Chapter 2 of the *Saṅgaha* states the relation between the 52 factors and the types of consciousness twice.

**The method of association** (*sampayoga-naya*, §12–§34) goes factor by factor. §13 reads:

> *Pakiṇṇakesu pana vitakko tāva dvipañcaviññāṇavajjitakāmāvacaracittesu ceva ekādasasu paṭhamajjhānacittesu ceti pañcapaññāsacittesu uppajjati.* (`abh07t.nrf.xml:417`)
>
> Among the occasionals, initial application arises in the sense-sphere types except the twice-five sense-consciousnesses, and in the eleven first-jhāna types: in fifty-five types.

The occasionals close with a verse at §19 giving the counts without and with each factor:

> *Chasaṭṭhi pañcapaññāsa, ekādasa ca soḷasa; / Sattati vīsati ceva, pakiṇṇakavivajjitā. / Pañcapaññāsa chasaṭṭhiṭṭhasattati tisattati; / Ekapaññāsa cekūnasattati sapakiṇṇakā.* (`abh07t.nrf.xml:445–457`)

In figures, for vitakka, vicāra, adhimokkha, vīriya, pīti and chanda in that order: 66, 55, 11, 16, 70 and 20 types lack the factor, and 55, 66, 78, 73, 51 and 69 have it.

**The method of combination** (*saṅgaha-naya*, §35–§58) goes type by type. §37 reads:

> *Chattiṃsa pañcatiṃsa ca, catuttiṃsa yathākkamaṃ. / Tettiṃsadvayamiccevaṃ, pañcadhānuttare ṭhitā.* (`abh07t.nrf.xml:597–601`)
>
> Thirty-six, thirty-five, thirty-four in order, and thirty-three twice: thus fivefold in the supramundane.

The two methods describe one incidence structure, a table of 121 types by 52 factors that the text never writes out whole. The first method gives each column by its support and its count. The second gives the row totals in groups.

```
                        52 factors (cetasika)
                ┌───────────────────────────────┐
   121 types   │                               │──▶ row totals: 38, 37, 37, 36 …
   (citta)      │   the incidence the text      │    (saṅgaha-naya, §35–§58)
                │   never writes down whole     │
                └───────────────────────────────┘
                                │
                                ▼
                  column totals, on mixed bases: 55, 66, 78, 73, 51, 69 …
                  (sampayoga-naya, §12–§34)

   chapter 3 adds two more projections of the same types:
     by feeling (§3–§9):  pleasure 1 · pain 1 · displeasure 2 · joy 62 · equanimity 55
     by root   (§10–§17): rootless 18 · one-rooted 2 · two-rooted 22 · three-rooted 47
```

Two features of the object bind everything below.

**The text mixes its reckonings.** It counts vitakka, vicāra, pīti and the feelings over 121, and every other factor and the roots over 89. The reason is that the 89 reckoning counts each supramundane type once, while the presence of these three factors depends on the jhāna the type is reckoned at. So 78, 73 and 69 are the same facts as 110, 105 and 101 on the other basis, and a key that read every figure on one basis would record false mismatches. The key follows the text.

**These are combination counts, not co-present sets.** The text says the factors *saṅgahaṃ gacchanti*, enter into combination (§36, `abh07t.nrf.xml:593`), and that the abstinences and illimitables *paccekameva yojetabbā*, are to be fitted in severally (§40, `abh07t.nrf.xml:625`). Its verse at §33 lists the factors that arise *nānā kadāci*, separately and occasionally (`abh07t.nrf.xml:553–557`). So the 38 of the first wholesome type is every factor that can join that type on some occasion. Nothing in this chapter is a claim about the size of any actual moment. Chapter 5 gives the commentary's own figure for that.

---

## 4.2 · The generator: 9 clauses

A type of consciousness is a point on axes read from chapter 1: class, plane, feeling, root structure, element, the quality of the kamma a resultant comes from, knowledge, wrong view, prompting, jhāna, immaterial base, and path. There is no separate axis for path and fruit. In the supramundane plane it is carried by class, a wholesome type being a path and a resultant one a fruit. This encoding of the axes is our reconstruction, in `sangaha/Citta.lean`.

| Clause | Builds | Types |
|---|---|---|
| §G1 | greed-rooted: feeling × view × prompting | 8 |
| §G2 | hate-rooted: displeasure × prompting | 2 |
| §G3 | delusion-rooted: with doubt or with restlessness | 2 |
| §G4 | rootless resultants, per kamma quality | 7 + 8 |
| §G5 | rootless functionals: five-door adverting, mind-door adverting, smile-producing, **written out member by member** | 3 |
| §G6 | beautiful sense-sphere: class × feeling × knowledge × prompting | 24 |
| §G7 | fine-material: class × jhāna | 15 |
| §G8 | immaterial: class × base | 12 |
| §G9 | supramundane: path × {path, fruit} × jhāna (first only, or all five) | 8 or 40 |

The clauses before §G9 give 81 types. With 8 supramundane types that is 89, and with 40 it is 121. The theorems `n89`, `n121` and `distinct121` check those lengths and that no two types are the same point.

The generator **restates chapter 1's axes and discovers nothing**. What it shows is that the 89 and 121 are exactly a product structure over those axes, with §G5's members listed. It is also the one place a type is written out, so "none naming a type" holds strictly of the rules and holds of the generator with that exception.

**This enumeration has a prior public model, and it is not claimed here.** As *The Counts Check* records from the repository itself, `AloofBuddha/abhidhamma`, a Haskell model with a first commit on 2026-09-18, before this generator's, builds both reckonings as a product over the same axes, and states as a known gap that it encodes no factor-combination rules. That gap is what the rules below address.

---

## 4.3 · The rules: 18 clauses

`sangaha/Rules.lean` defines one function, `arises`, as a chain of 18 tagged clauses. Each clause is a condition over the axes, and none names a type. A condition that names no type can still pick out very few, so the table reports each rule's **extension**: the number of types, over 89 and over 121, in which the factor it governs occurs. The extensions were recomputed for this draft from `occurrences`.

| Rule | Factor(s) | Condition over the axes | Extension (89 / 121) | Text (`abh07t.nrf.xml`) |
|---|---|---|---|---|
| §R1 | the 7 universals | every type | 89 / 121 | §12 `:413` |
| §R2 | vitakka | not a sense-consciousness; jhāna at most the first | 55 / 55 | §13 `:417` |
| §R3 | vicāra | not a sense-consciousness; jhāna at most the second | 58 / 66 | §14 `:421` |
| §R4 | adhimokkha | not a sense-consciousness; not with doubt | 78 / 110 | §15 `:425`, **nearly verbatim** |
| §R5 | vīriya | among the rootless, only the functional mind-consciousness element | 73 / 105 | §16 `:429` |
| §R6 | pīti | joyful feeling; jhāna at most the third | 35 / 51 | §17 `:433` |
| §R7 | chanda | a root other than delusion alone | 69 / 101 | §18 `:437` |
| §R8 | moha, ahirika, anottappa, uddhacca | unwholesome | 12 / 12 | §20 `:465` |
| §R9 | lobha | greed-rooted | 8 / 8 | §21 `:469` |
| §R10 | diṭṭhi | greed-rooted, with view | 4 / 4 | §22 `:473` |
| §R11 | māna | greed-rooted, without view | 4 / 4 | §23 `:477` |
| §R12 | dosa, issā, macchariya, kukkucca | hate-rooted | 2 / 2 | §24 `:481` |
| §R13 | thīna, middha | prompted unwholesome | 5 / 5 | §25 `:485` |
| §R14 | vicikicchā | delusion with doubt | 1 / 1 | §26 `:489` |
| §R15 | the 19 beautiful universals | beautiful | 59 / 91 | §28 `:521` |
| §R16 | the 3 abstinences | beautiful; sense-sphere wholesome, or supramundane | 16 / 48 | §29 `:525`, **transcribes the sentence** |
| §R17 | karuṇā, muditā | beautiful sense-sphere non-resultant, or fine-material up to the fourth jhāna | 28 / 28 | §30 `:529`, **transcribes the sentence** |
| §R18 | paññā | beautiful and with knowledge | 47 / 79 | §31 `:533` |

The rules differ in how much they do, and the differences should not be smoothed over.

**Some rules state over the axes what the text states as a list of exclusions.** §16 removes energy by naming four classes, *pañcadvārāvajjanadvipañcaviññāṇasampaṭicchanasantīraṇavajjitacittesu* (`abh07t.nrf.xml:429`). §R5 states one condition over the element axis, and among the rootless its extension is the mind-door adverting and the smile-producing types. §17 removes pīti by naming displeasure, equanimity, body-consciousness and the fourth jhāna (`abh07t.nrf.xml:433`), and §R6 states joy up to the third jhāna. §18 removes the rootless and the two delusion-rooted types (`abh07t.nrf.xml:437`), and §R7 names the roots that remain. In each case the two are extensionally equal over the generated types, and that equality is what the occurrence theorems check.

**Some rules are the text's sentence.** §R4 is §15 nearly word for word, *Adhimokkho dvipañcaviññāṇavicikicchāsahagatavajjitacittesu* (`abh07t.nrf.xml:425`). §R16 and §R17 transcribe the locus sentences of §29 and §30. Matching 16 and 28 from them is restatement. §R8 to §R14 mostly define a root's own factors, and their extensions (2, 1) are as small as the classes they name. *General*, in the registered sense, is a test of syntax: no type is named. It is not a measure of how much is generalized, and the extension column is there so that no one takes it for one.

**The rule set is not unique.** Other rule sets could reproduce the same counts, and this one is not claimed to be the text's own. The result is that one short set exists.

The 52 factors and their classes are themselves checked (`control/Cetasika.lean`): 7 · 6 · 14 · 25.

---

## 4.4 · What checks

`sangaha/run.sh` was run again for this draft, on Lean as pinned in `lean-toolchain`. Its output, abridged:

```
PASS  12 theorems: 89 · 121 · distinct · both profiles · per-factor counts and absences · ch. 3 feelings and roots · the keci reading
PASS  4 theorems (rung 3): canon names 29 · all 29 inside the Saṅgaha's set · L2 adds exactly the nine 'ye vā pana' · 38
9 of 9 deliberate breaks fail, as required
```

(The middle line's *L2 adds* is the script's wording from before the correction reported in chapter 5. The theorem is unchanged. Its description was wrong.)

The 12 theorems of `Check.lean`, each proved by `decide`:

| Theorem | Statement | Exercises |
|---|---|---|
| `n89` · `n121` | the generator yields exactly 89 and 121 types | the generator |
| `distinct121` | no two types are the same point | the generator |
| `profile89` · `profile121` | the rules give every per-type count the text states (below) | the rules, on the generator |
| `occurrences89` · `absences89` | the per-factor counts over 89: universals 89 · adhimokkha 78 · vīriya 73 · chanda 69 (without: 11 · 16 · 20) · unwholesome 12 · 8 · 4 · 4 · 2 · 5 · 1 · beautiful universals 59 · abstinences 16 · illimitables 28 · paññā 47 | the rules, on the generator |
| `occurrences121` · `absences121` | the factors counted over 121: vitakka 55 · vicāra 66 · pīti 51 (without: 66 · 55 · 70) | the rules, on the generator |
| `feelings121` | chapter 3: pleasure 1 · pain 1 · displeasure 2 · joy 62 · equanimity 55 | the generator's feeling axis only |
| `roots89` | chapter 3: rootless 18 · one-rooted 2 · two-rooted 22 · three-rooted 47 | the generator's root and knowledge axes only |
| `keci_reading` | the dissent at §30 gives 20 where the text states 28 (§4.7) | an alternative rule |

The per-type profile the rules give, which equals the key at every position:

| Group | Types | Counts | Text |
|---|---|---|---|
| greed-rooted | 8 | 19 · 21 · 19 · 21 · 18 · 20 · 18 · 20 | §43–§46, §48, §51 |
| hate-rooted | 2 | 20 · 22 | §47–§48, §51 |
| delusion-rooted | 2 | 15 · 15 | §49–§51 |
| rootless resultant, unwholesome kamma | 7 | 7 for the sense-consciousnesses · 10 · 10 | §53–§58 |
| rootless resultant, wholesome kamma | 8 | 7 for the sense-consciousnesses · 10 · 11 · 10 | §53–§58 |
| rootless functional | 3 | 10 · 11 · 12 | §53–§58 |
| beautiful sense-sphere, wholesome (pairs) | 8 | 38 · 37 · 37 · 36 | §40–§41 |
| beautiful sense-sphere, resultant (pairs) | 8 | 33 · 32 · 32 · 31 | §40–§41 |
| beautiful sense-sphere, functional (pairs) | 8 | 35 · 34 · 34 · 33 | §40–§41 |
| fine-material, per class | 15 | 35 · 34 · 33 · 32 · 30 | §38–§39 |
| immaterial | 12 | 30 | §38–§39 |
| supramundane, at the first jhāna (89) | 8 | 36 | §36 |
| supramundane, per jhāna (121) | 40 | 36 · 35 · 34 · 33 · 33 | §36–§37 |

`numbers.json` records the match directly: `profile89_matches_key` and `profile121_matches_key` are both true. Every figure matched on the first collation against the CST.

**P-FA1 is confirmed. P-FA4 is confirmed (§4.9).** Both are confirmed under the limit stated in chapter 3: the figures were known before the rules were written.

---

## 4.5 · Which theorem tests what

A test is evidence only for the code it runs, and the theorems above differ sharply in what they exercise.

- **The occurrence theorems check each rule against the sentence it was read from.** They catch an error of transcription. They cannot show that the rules were not fitted.
- **The profile theorems are the cross-method test.** The rules were read from the factor-indexed statements, and `profile89` and `profile121` check them against type-indexed totals they were not read from. If the two methods of chapter 2 disagreed, or if the rules misread them, this is where it would show.
- **The chapter 3 theorems test only the generator.** `feelings121` and `roots89` count values on the feeling and root axes and never call the factor rules. They show that chapter 1's labels, as encoded, reproduce chapter 3's tallies: the verses at chapter 3 §9 (*Sukhamekattha dukkhañca, domanassaṃ dvaye ṭhitaṃ. / Dvāsaṭṭhīsu somanassaṃ, pañcapaññāsaketarā*, `abh07t.nrf.xml:821–825`) and §17 (*Ahetukāṭṭhārasekahetukā dve dvāvīsati. / Dvihetukā matā sattacattālīsatihetukā*, `abh07t.nrf.xml:873–877`). That is a useful check on the axes, against a chapter they were not built from. It says nothing about the rules, and earlier descriptions in this program that counted it as evidence for the rules were too generous.

So the claim of the chapter rests on one test: rows against rules read from columns. That test is real, and it is one test over one chapter.

**GAP 4a. The key does not hold every count in chapter 2.** The outline says "every count in chapter 2". The key holds every per-type and per-factor count. The chapter also states how many *ways* of combination each group has: *pañcadhāva* for the supramundane (§36, `abh07t.nrf.xml:593`), *pañcadhāva* for the sublime (§38, `:609`), *dvādasadhāva* for the beautiful sense-sphere (§40, `:625`), *sattadhāva* for the unwholesome (§50, `:693`), *catudhāva* for the rootless (§57, `:733`), and the total at §59, *tettiṃsavidhasaṅgaho* (`:749`): 5 + 5 + 12 + 7 + 4 = 33. None of these is keyed, and no theorem checks them. They look checkable, but not by counting distinct totals, since the text groups some of its ways by count (*gaṇanavasena*, `:693`, `:733`), some by pair of types (*dukavasena*, `:625`) and some by jhāna (*pañcakajjhānavasena*, `:593`). Writing that down is a modeling decision, and it should be made before anyone computes the result. Until then this dissertation says "every per-type and per-factor count", and the outline's wider phrase should not be quoted as the result.

---

## 4.6 · The breaks

Each break is applied to a copy of the sources by script, verified to have changed its file, and required to make the check fail. Run again for this draft:

```
break                                       expected           observed
──────────────────────────────────────────  ─────────────────  ────────
R4 without its doubt clause                 the check fails    FAILS
R6 pīti allowed in the 4th jhāna            the check fails    FAILS
R16 abstinences in functionals too          the check fails    FAILS
key: smile-producing 12 → 13          the check fails    FAILS
key: adhimokkha 78 → 77                the check fails    FAILS
generator: fine-material jhānas 1–4         the check fails    FAILS
generator: smile with equanimity            the check fails    FAILS
canon: chanda counted as named              the check fails    FAILS
roots: knowledge adds no root               the check fails    FAILS
```

These nine were chosen by hand, among faults the author could foresee. So they establish that the checker can see these faults. They do not establish how much it can see. The question of what it cannot see is §4.8.

---

## 4.7 · A dissent the text records

At §30, having placed the illimitables in 28 types, the text adds:

> *upekkhāsahagatesu panettha karuṇāmuditā na santīti keci vadanti.* (`abh07t.nrf.xml:529`)
>
> Some say compassion and appreciative joy are absent here from the types accompanied by equanimity.

`illimitablesKeci` formalizes this as an alternative rule that `arises` does not use. Under it the illimitables occur in **20** types, not 28: the 8 equanimous beautiful sense-sphere types, 4 wholesome and 4 functional, lose them. A reader who adopts the *keci* reading must change 5 stated figures, not one:

```
figure (§30; per-type, §40–§41)         main reading   keci reading
──────────────────────────────────────  ────────────   ────────────
illimitables, number of types                28             20
wholesome, equanimous, with knowledge        37             35
wholesome, equanimous, without knowledge     36             34
functional, equanimous, with knowledge       34             32
functional, equanimous, without knowledge    33             31
```

The theorem establishes only the figure 20. The four per-type figures in the right column are the left column less the two factors, a subtraction done for this table, not a theorem.

What this shows needs care, because the first version overstated it. `RESULTS.md` first said that the text's own count decides between the readings. That was retracted: the 28 sits in the same sentence the dissent qualifies. What holds is that **the author's stated figures encode the main reading**. The *Saṅgaha* gives no argument either way.

The argument is in its commentary. The *Vibhāvinī* on §30 (`abh07t.nrf.xml:4333`, layer other, tier manual's commentary) holds that in sense-sphere wholesome consciousness the preliminary work for compassion and appreciative joy occurs with equanimous types too, by familiarity, *yathā taṃ paguṇaganthaṃ sajjhāyantassa*, as with someone reciting a well-known text, and that for this reason the denial *kecivādo kato*, was set down as a minority view. It adds that in absorption (*appanāvīthiyaṃ*) the two occur only with joyful types. So the commentary argues the reading. As far as this project has read, no one counts what it costs in the text's own figures, and that is the modest thing the table adds.

**GAP 4b. That "as far as read" is weak.** The Burmese ṭīkā debate on chapter 2 (Ledi Sayadaw's *Paramatthadīpanī*; the *Aṅkura-ṭīkā*) has not been read. It is the likeliest place for a counting of this dissent (`OUTLINE.md`, owed item 3). Until it is read, nothing here should be taken as saying the count is unprecedented.

---

## 4.8 · What the key cannot see

The key holds totals. It holds no cell of the table.

So the occurrence theorems fix each column's total, and the profile theorems fix each row's, but no theorem fixes which factor sits in which type. Agreement at the cells rests on the reading of the *sampayoga* sentences, which a reader checks by hand. Distinct tables of 121 by 52 can share every total: that is the classical fact about 0-1 matrices with given margins (Gale 1957; Ryser 1957). A rule set could in principle be wrong at cells in a pattern that cancels in every total the text states.

How much this matters is an empirical question, and this repository has an instrument for it. It has not been run.

**GAP 4c. The key's blindness has not been measured.** The outline's chapter 8 is meant to carry this, through `rung4/mutants.py`: the 156 single-point mutants of `arises`, then every cross-clause pair, testing whether two rule-shaped errors can cancel in every keyed figure. That waits on the rung 4 pre-registration, which is a draft awaiting a decision and has not been run. The single-mutant score would not be evidence in any case, since the key holds every row total and any single mutant that changes the table changes one (`rung4/README.md` says so in advance). Only the pairs are informative. No sentence in this chapter should be read as saying that the rules are correct cell by cell.

---

## 4.9 · Compression

27 clauses ÷ 121 rows = **0.22**. Over 89 the ratio is 0.3. Counting §G5's three written-out members singly gives 29 ÷ 121 = 0.24. P-FA4 predicted below 0.5 and is confirmed.

The number should be read with three cautions. It depends on what counts as a clause, and the registered definition is the one reported. It depends on the axes: a distinction carried by a datatype (delusion with doubt against with restlessness, mind element against mind-consciousness element, prompting) costs no clause, so the ratio measures this encoding and can be compared only across encodings on the same axes. And it is a crude stand-in. Description length (Rissanen 1978) and implication bases (Ganter and Wille 1999) are the principled measures of how far a table is generated rather than listed, and neither has been computed.

**GAP 4d. The ratio has no comparison class.** Any taxonomy built on axes compresses. An examiner will ask whether 0.22 is any better than random rule systems of the same shape on the same axes would give, and today there is no answer. The draft rung 4 pre-registration gives a probability of 0.5 that the real table falls inside the central range of those null systems, in which case the compression is expected and is not a finding. Until the measure runs, the ratio is a description of this encoding and supports no claim about the text.

---

## 4.10 · Scoring

| ID | Registered confidence | Outcome |
|---|---|---|
| P-FA1 | 0.6 | **confirmed**: 89 and 121 at L2, edition C, with every per-type and per-factor count reproduced |
| P-FA1b | 0.7 | **retired, unscored**: the test was never defined (chapter 3) |
| P-FA4 | 0.5 | **confirmed**: 0.22 |

---

## 4.11 · What, then, does this add?

`OUTLINE.md` names the test an examiner will apply, and `READERS.md` asks one reader to press it: does the result say anything Bodhi's Table 2.4 does not? The honest answer, today, has two parts.

**What is not new.** The agreement of the two methods is printed. Bodhi's Tables 2.2–2.4 set out the method of association, the method of combination and both together, with totals in both reckonings, as *The Counts Check* reports from that book (not re-read for this draft). The tradition teaches the methods as two views of one structure. The generator has a prior model. The checks of this chapter would also pass by a short script.

**What the check does add, narrowly.** The form of the agreement changes: rules over axes that name no type, in place of a table; a key cited paragraph by paragraph to a named edition; evaluation by a trusted kernel; breaks that show the check can fail; and a stated cost for the §30 dissent. *The Counts Check*'s census reports this composition as not found in its declared aperture on 2026-09-28, and that wording is its limit. Nothing is claimed here as new. A reader who says "that is a tidier chart" has a fair point, and the stronger answer is owed.

**What would answer the examiner.** The outline itself names three things a chart cannot do: measure the key's blindness (GAP 4c), compare the compression with an objective minimum and with null models (GAP 4d), and carry edition and layer results beyond the first type (GAP 5a, GAP 6a). None exists yet. This chapter therefore delivers the consistency result and does not deliver the outline's answer to its own test. It should not be sent to a venue as though it did.

---

## 4.12 · Limits, collected

- It is a consistency check. The rules were written by an author who knew the tables, and §R4, §R16 and §R17 restate the text.
- The cross-method test is one test over one chapter (§4.5).
- No theorem checks a cell (§4.8).
- The ways of combination are not keyed (GAP 4a).
- The result is on one edition, C. P-FA3, the same counts in K, could not run (chapter 6).
- Every theorem is a finite evaluation (chapter 3).
- A reader's check of each rule against its sentence is still owed. `READERS.md` puts that question first, and no reader has yet been invited.
