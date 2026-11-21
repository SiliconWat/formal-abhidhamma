# Chapter 5 · Result II: the layers

*Thon Ly · Miss Aquarius℠ (AI collaboration, disclosed). Living draft: not frozen, never stamped, free to change. CC0-1.0. Translations from the Pāli are ours. Pāli citations are file:line at text `05d5d3c`, with the CST file's layer and this repository's tier. Open items are marked **GAP**.*

---

## 5.0 · The result, stated once

For one type of consciousness, the first wholesome sense-sphere type: the canon's list names 29 of the 38 factors the *Saṅgaha* gives. Every one of the 29 is among the 38, and the remainder is exactly 9 factors. Those 9 are first named for this list by the commentary, the *Aṭṭhasālinī*, which predates the *Saṅgaha*. The manual inherits them. It does not add them.

The count of 29 is not a discovery. The commentary reaches the same count by its own deduplication, and Nyanaponika set out the layering in print in 1949. What the program contributes is a synonym map published before the text was read, and an inclusion with an exact remainder checked by machine. And the whole result rests on **one list**. The outline's larger claim, the layer of each rule across all the types, has not been tested (GAP 5a).

---

## 5.1 · The question, and how it was registered

The first pre-registration predicted, with confidence 0.65, that at L1 the rules would be "under-determined or differently partitioned" (P-FA2). That wording could not be scored as it stood. The second file (`PREREGISTRATION-2026-09-27b.md`, pushed 2026-09-27T23:04:29Z) replaced it with an operational form on one object: the *pada-bhājanīya* of the first wholesome sense-sphere type, the *Dhammasaṅgaṇī*'s list of what is present when such a consciousness arises.

Three things were fixed in that file before either edition of the *Dhammasaṅgaṇī* was read.

- **The synonym map.** Each canonical term maps to one of the 52 factors or to CITTA, consciousness itself, which is not a factor. A term outside the map is reported as UNMAPPED and is never mapped afterward.
- **P-FA2a** (confidence 0.75). In edition C the list names exactly 29 distinct factors, names none of *chanda, adhimokkha, manasikāra, tatramajjhattatā, karuṇā, muditā* or the three abstinences, and closes with an open clause.
- **P-FA2b** (confidence 0.6). Zero unmapped terms in C's list.

A note on what that blindness is worth. A prediction of exactly 29, with those exact exclusions, is a prediction by someone who already knew the shape of the answer, and the map targets a 52-factor scheme that itself inherits the commentarial identifications. The pre-registration proves that the map was not adjusted after the reading. It does not prove the result was unknown.

---

## 5.2 · The canon's list

The list is §1 of the *Dhammasaṅgaṇī* (`abh01m.mul.xml:1569`, layer mūla, tier Piṭaka). It opens:

> *Yasmiṃ samaye kāmāvacaraṃ kusalaṃ cittaṃ uppannaṃ hoti somanassasahagataṃ ñāṇasampayuttaṃ … tasmiṃ samaye phasso hoti, vedanā hoti, saññā hoti, cetanā hoti, cittaṃ hoti …*
>
> At the time when a wholesome sense-sphere consciousness has arisen, accompanied by joy, associated with knowledge … at that time there is contact, there is feeling, there is perception, there is volition, there is consciousness …

It runs to *paggāho hoti, avikkhepo hoti* and closes:

> *ye vā pana tasmiṃ samaye aññepi atthi paṭiccasamuppannā arūpino dhammā – ime dhammā kusalā.*
>
> or whatever other conditioned immaterial phenomena there are at that time: these phenomena are wholesome.

`canon/pada.py` was run on that paragraph again for this draft, with the CST's inline variant notes stripped first. It reports:

| Measure | Value |
|---|---|
| terms before each *hoti* | 56 |
| distinct terms (*sammādiṭṭhi* occurs twice) | 55 |
| terms that map to CITTA (*cittaṃ*, *manindriyaṃ*) | 2 |
| distinct factors after mapping | **29** |
| unmapped terms | 0 |
| of the 9 listed factors, how many are named | 0 |
| closes with the open clause | yes |

**P-FA2a is confirmed. P-FA2b is confirmed, with a disclosure.** The first run reported 2 unmapped terms, *kāyujukatā* and *cittujukatā*. Both are sandhi forms (*kāya* + *ujukatā*, *citta* + *ujukatā*), and the pre-registration required sandhi to be normalized before mapping, but the script had not implemented the case. It was added and is commented as added after the first run. Both runs are reported in `RESULTS.md`. Neither the map nor the prediction changed. An examiner may fairly ask whether a normalization added after a failure is a post-hoc rescue. The defense is that §3 of the second file names sandhi in advance, and the reader can judge whether that suffices.

The detector for the 9 was first tested on a control list naming four of them in inflected forms, and it caught all four.

---

## 5.3 · What the Lean establishes

`sangaha/Canon.lean` writes the 29 out as a list and proves 4 theorems by `decide`.

| Theorem | Statement |
|---|---|
| `canon_29` | the list has 29 entries, all distinct |
| `canon_subset` | every one of them is given by the *Saṅgaha*'s rules for this type |
| `added_is_yevapanaka` | what the rules give beyond the list has 9 members and is, as a set, exactly the 9 |
| `thirty_eight` | the rules give 38 factors for this type |

`numbers.json` carries these as `canon_named_first_kusala` 29, `saṅgaha_first_kusala` 38, `added_by_saṅgaha` 9 and `yevāpanaka` 9. A deliberate break, counting *chanda* as named, fails (§4.6).

By the *Saṅgaha*'s classes:

| Class | In the type's 38 | Named in the canon's list | Supplied |
|---|---|---|---|
| universals | 7 | 6 | 1: *manasikāra* |
| occasionals | 6 | 4 | 2: *chanda, adhimokkha* |
| beautiful universals | 19 | 18 | 1: *tatramajjhattatā* |
| abstinences | 3 | 0 | 3 |
| illimitables | 2 | 0 | 2 |
| wisdom | 1 | 1 | 0 |

The 13 common factors plus the 25 beautiful ones make the 38, as §40 itself says: *aññasamānā terasa cetasikā, pañcavīsati sobhanacetasikā ceti aṭṭhatiṃsa dhammā* (`abh07t.nrf.xml:625`, layer other, tier manual).

What these theorems do **not** establish is any claim about layers. `Canon.lean` proves set facts about two lists. That the first list is the canon's is a citation, and where the remainder comes from is a reading. The word *layer* appears in the file's comments and in no theorem.

---

## 5.4 · The commentary had already counted it

The *Aṭṭhasālinī* counts the same list (*Yevāpanakavaṇṇanā*, on Dhs §1; `abh01a.att.xml:5081`, layer aṭṭhakathā, tier commentarial):

> *Iti phassādīni chappaññāsa yevāpanakavasena vuttāni navāti sabbānipi imasmiṃ dhammuddesavāre pañcasaṭṭhi dhammapadāni bhavanti. … Aggahitaggahaṇena panettha phassapañcakaṃ, vitakko vicāro pīti cittekaggatā, pañcindriyāni, hiribalaṃ ottappabalanti dve balāni, alobho adosoti dve mūlāni, kāyapassaddhicittapassaddhiādayo dvādasa dhammāti samatiṃsa dhammā honti.*
>
> Thus the fifty-six beginning with contact, and the nine stated as "whatever else", make sixty-five terms in this section. … Taking only what has not already been taken: the contact-pentad, initial and sustained application, rapture, one-pointedness, the five faculties, the two powers of shame and dread, the two roots of non-greed and non-hate, and the twelve beginning with bodily and mental tranquility: these are exactly thirty phenomena.

So 56 + 9 = 65, and 30 is consciousness plus 29 factors. The script's 56 is the commentary's *chappaññāsa*, and the map's 29 is the commentary's *samatiṃsa* less consciousness.

This cuts two ways, and both are reported. It corroborates P-FA2a against a count the project did not produce. It also removes any novelty from the count, and it is **not independent**: the 52-factor scheme the map targets inherits the commentary's identifications, so a map built on that scheme could hardly do otherwise. The synonym map performed the commentary's *aggahitaggahaṇa*, "taking what has not yet been taken", because it was built in that tradition.

---

## 5.5 · Who names the 9

The same commentary names them, a few lines earlier (`abh01a.att.xml:5045`, layer aṭṭhakathā, tier commentarial):

> *Ettāvatā cittaṅgavasena pāḷiyaṃ āruḷhe paropaṇṇāsadhamme dīpetvā yevāpanakavasena aparepi nava dhamme dhammarājā dīpeti. Tesu tesu hi suttapadesu 'chando adhimokkho manasikāro tatramajjhattatā karuṇā muditā kāyaduccaritavirati vacīduccaritavirati micchājīvaviratī'ti ime nava dhammā paññāyanti.*
>
> Having thus shown the more than fifty phenomena that have come into the text as limbs of consciousness, under "whatever else" the King of Dhamma shows nine further phenomena. For in various sutta passages these nine are known: zeal, decision, attention, neutrality, compassion, appreciative joy, and abstinence from bodily misconduct, verbal misconduct and wrong livelihood.

**This corrects the program's own first report.** `RESULTS.md`'s rung 3 entry, and still the wording of `Canon.lean`'s `addedByL2` and of `sangaha/run.sh`, say that L2 adds the 9, and the key `added_by_saṅgaha` in `numbers.json` keeps the name. In the registered layer order that looked true. Chronologically it is not, and `RESULTS.md` carries the correction as an appended entry. On the conventional datings (taken in *The Counts Check* from Bodhi's introduction and not re-read for this draft) the commentary is about five to seven centuries older than the manual.

```
  c. 3rd c. BCE             c. 5th c. CE                   c. 10th–12th c. CE
  ─────────────────────     ──────────────────────────     ──────────────────────────
  CANON                     COMMENTARY                     MANUAL
  Dhammasaṅgaṇī §1          Aṭṭhasālinī                    Abhidhammattha-saṅgaha
  56 terms, 29 factors      counts the 56 as 30            states 38 for this type
  + an OPEN clause:   ───▶  (samatiṃsa, = 29 + citta)      "entering into combination"
  "ye vā pana …"            and NAMES the 9      ───▶   = 29 + the 9,
                            (as the dhammarājā's,          inherited as members,
                            from the suttas)               re-classed
```

**A further check supports this, from the manual's own side.** The word does not appear in the manual. A count over lines 13–3497 of `abh07t.nrf.xml` finds 0 occurrences of *yevāpanaka* or *ye vā pana*, and the *Vibhāvinī* from line 3505 onward has 8 occurrences of *yevāpanaka*. The *Vibhāvinī* says the same thing in words. On §34 it records that some describe the remaining factors as fixed *yevāpanaka*, and calls that their mere opinion, *idha yevāpanakanāmena kesañci anuddhaṭattā*, because here none are brought up under the name *yevāpanaka*: *na yevāpanakanāmena keci uddhaṭāti* (`abh07t.nrf.xml:4345`, layer other, tier manual's commentary). So the manual takes the 9 as members and re-classes them, and it drops the category that brought them in. This is a reading of the two texts, not a theorem.

**The layering is not the program's finding.** According to *The Counts Check*, which quotes the book, Nyanaponika's *Abhidhamma Studies* (1949; quoted there from the third edition, 1976), ch. 14, already sets the commentaries' nine against this list and records their incorporation into the *Visuddhimagga* and the *Saṅgaha*. The finding that the manual's set is the canon's list plus the commentary's nine is his. What this chapter supplies is an instrument for it: a map fixed before reading, and inclusion with an exact remainder checked by machine.

---

## 5.6 · 38 is not the size of a moment

The commentary goes on, in the same paragraph, to say how many of these terms are present at once:

> *Tesu ekakkhaṇe kadāci ekasaṭṭhi bhavanti, kadāci samasaṭṭhi. … Uppattiyaṃ pañcasu ṭhānesu ekasaṭṭhi bhavanti. Tehi mutte ekasmiṃ ṭhāne samasaṭṭhi bhavanti.* (`abh01a.att.xml:5081`)
>
> Of these, at one moment there are sometimes sixty-one, sometimes sixty. … In arising, in five situations there are sixty-one. In the one situation free of those, there are sixty.

And it has already said why: *chando adhimokkho manasikāro tatramajjhattatāti ime cattārova ekakkhaṇe labbhanti, sesā nānākkhaṇe* (`abh01a.att.xml:5053`), of the nine, these four alone are found in one moment, the rest at different moments. So of the 9, 4 are present together and 5 (the abstinences, compassion, appreciative joy) come at most one at a time. 61 is 56 + 4 + 1. 60 is 56 + 4.

Carried over to factors, the most present together in this type is 38 − 5 + 1 = **34**. That 34 is derived here (tier ours). The text does not state it. The *Saṅgaha*'s 38 is the size of the combination: every factor that can join this type on some occasion. All 38 are never present at once on this account, and §4.1 and chapter 8's limits should be read accordingly.

---

## 5.7 · Scope: "the canon leaves 9 unnamed" holds for this list

It should not be read as a claim about the canon as a whole. For the book, checked again for this draft by search of `abh01m.mul.xml` (after the reader's control passed):

- **The 3 abstinences are named as path factors** in the supramundane type: *sammāvācā hoti, sammākammanto hoti, sammāājīvo hoti* (§277, `abh01m.mul.xml:3041`, layer mūla, tier Piṭaka). The commentary notes the point: *Ime hi tayo dhammā idha pāḷiyaṃ āgatattāva yevāpanakesu na gahitā* (`abh01a.att.xml:6621`, layer aṭṭhakathā, tier commentarial), "for these three are not taken among the *yevāpanaka* here, because they have come in the text." The *Vibhāvinī* says the same on §29 (`abh07t.nrf.xml:4329`, tier manual's commentary).
- **Karuṇā and muditā qualify jhāna**: *paṭhamaṃ jhānaṃ upasampajja viharati karuṇāsahagataṃ* (§258, `abh01m.mul.xml:2897`), and likewise muditā (§260, `:2905`). In these paragraphs they qualify the jhāna. They are not items in a list of factors.
- **Chanda** appears in *chandādhipateyya*, "with zeal dominant", 108 times in lower case by a count of the decoded file (capitalized headings are not in that count). That use was not read occurrence by occurrence.
- **Manasikāra.** The stem *manasikār* occurs 9 times, 5 of them as *amanasikār-*. *The Counts Check* reads these as other senses. The occurrences were not re-read for this draft, and the statement rests on the paper.
- **Adhimokkha and tatramajjhattatā.** The stems *adhimokkh* and *tatramajjhatt* occur 0 times. A zero says only that those spellings do not occur in this file. Other words for the same factors were not searched.

---

## 5.8 · Scoring

| ID | Registered confidence | Outcome |
|---|---|---|
| P-FA2 | 0.65 | operationalized as P-FA2a for one list; **as worded, not scored** (GAP 5b) |
| P-FA2a | 0.75 | **confirmed**; consistent with the commentary's *samatiṃsa* |
| P-FA2b | 0.6 | **confirmed** after the sandhi rule the registration named; first run disclosed |

---

## 5.9 · What this chapter does not establish

**GAP 5a. The layer of each rule is not established.** `OUTLINE.md`'s scope says the one claim includes "the layer of each rule". What exists is the layer of one row: the first wholesome type, against the canon's list for it. The other 120 rows of the 121 have not been compared with their canonical lists, and none of the 18 rules has been assigned a layer. Some of those comparisons will be harder than this one: the *Dhammasaṅgaṇī* abbreviates many of its later lists, and they will need expansion rules fixed in advance. The extension needs a new pre-registered rung. It is not written, and it is not attempted here.

**GAP 5b. The first prediction's question is open.** P-FA2 as registered asks whether the rules at L1 yield the 89, and `README.md` asks in which layer the counts first become derivable. One row's 38 is not derivable from the canon's list alone. Whether the number 89 itself is derivable at L1 has not been tested. It is not answered by this chapter.

**GAP 5c. L3 has not been formalized as a layer.** The commentary's role above is established by reading, at the cited lines. No Lean file represents the commentary's rules, so the statement that the counts become derivable at L3 for this row is no more than 29 + 9 = 38 with a citation. The registered layer order is itself editorial (§3.7), so a future rung should state what it means by a layer before it runs.

**GAP 5d. Unread sources.** The Burmese ṭīkā debate on chapter 2 (`OUTLINE.md`, owed item 3) may bear on the *yevāpanaka* as well as on the §30 dissent. It has not been read.

**GAP 5e. A disclosure for any future rung.** While this draft was being prepared on 2026-11-05, `canon/pada.py` was run once by mistake on the wrong paragraph of the *Dhammasaṅgaṇī*: §147, the first type without knowledge, at `abh01m.mul.xml:2233`. A search for the paragraph's opening matched there first, because the opening of §1 is broken by page markers in the file. Its output was seen. It is not reported here as a result, and it was not used. Any pre-registration extending the comparison beyond the first type must declare that this paragraph's output had been seen before registration, or must leave that paragraph out.

---

## 5.10 · Limits, collected

- One list. One type. The *Dhammasaṅgaṇī*'s densest, and its first.
- The attribution of the remainder rests on reading, not on the theorems (§5.3).
- The count is not novel and the map is not independent of the commentary (§5.4).
- The layering is Nyanaponika's finding in print (§5.5).
- The readers `READERS.md` seeks are asked what they would need to see before they believed the layer claim. None has been asked yet.
