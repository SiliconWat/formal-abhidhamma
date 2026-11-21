# Chapter 6 · Result III: the editions

*Thon Ly · Miss Aquarius℠ (AI collaboration, disclosed). Living draft: not frozen, never stamped, free to change. CC0-1.0. Pāli citations are file:line at text `05d5d3c`, with the CST file's layer and this repository's tier. No Khmer-edition text appears in this chapter, only counts, positions and single romanized terms. Open items are marked **GAP**.*

---

## 6.0 · The result, stated once

For one list, the *Dhammasaṅgaṇī*'s account of the first wholesome sense-sphere type, the Khmer edition of the Buddhist Institute and the Chaṭṭha Saṅgāyana name **the same 56 terms in the same order**. Their spelling differences on this list are orthographic or are slips in the working transcription, and two remain undecided.

The outline's question is wider: do the two editions agree, at every layer? For that, this chapter has one passage and nothing more. It is marked in the outline as "first type only; **extend**", and it stays that way (GAP 6a). The two editions are also not independent, so even complete agreement would be agreement between relatives (§6.5).

---

## 6.1 · The prediction that could not run, and the one that replaced it

P-FA3 (confidence 0.85) predicted that K and C yield identical counts at L2. It could not run. L2 includes the *Abhidhammattha-saṅgaha*, which is a post-canonical manual and is not part of the Khmer Tipiṭaka. The one Khmer-script *Saṅgaha* the project holds has the CST's own paragraph structure in all nine chapters (43 · 60 · 74 · 55 · 102 · 65 · 53 · 43 · 75). The second pre-registration concludes that it is the CST transliterated, not an independent recension. Those are also the highest paragraph numbers per chapter in the CST file itself, recomputed for this draft from `abh07t.nrf.xml`.

So **the counts of chapter 4 have been run on one edition only**. There is no second edition of the *Saṅgaha* to run them on. This is a limit of the sources and no fault of the check, but it does mean the outline's phrasing, "do the two editions agree?", cannot be asked of the counts as registered.

P-FA5 (confidence 0.8), registered at L1 as a new prediction, asks what can be asked: edition K's list for the first type, transliterated from Khmer script and normalized, names the same terms in the same order as edition C's, and any difference is orthographic only. Its falsifier is strict. A term added, dropped or reordered counts only if **confirmed against the printed page image**. An unconfirmed difference is a question about the transcription and is never reported as a variant.

---

## 6.2 · The witnesses

**Edition C.** VRI `romn/abh01m.mul.xml` §1 (`abh01m.mul.xml:1569`, layer mūla, tier Piṭaka). It carries its own variant apparatus inline.

**Edition K.** The Khmer Tipiṭaka of the Buddhist Institute, Phnom Penh, volume 78 (the *Dhammasaṅgaṇī*, part 1), pp. 16–17, as transcribed. The transcription is a working draft made page by page from the printed volume, and its maker is credited in `PREREGISTRATION-2026-09-27b.md` §5 and in `CONTRIBUTIONS.md`. Differences were checked against the scan of the printed page. The scans are preserved through **Kang Huychan and family · Lok Kru Aggapaṇḍita But Savong · Srong Chanda · 5000-years.org**, and any use of them names these donors.

**What may be published.** The reproduction question for the edition is open, and the Buddhist Institute's blessing is sought. So the K text is read privately and is not in this repository (`APPARATUS.md`).

**GAP 6b. The printing is not identified.** `APPARATUS.md` requires that the printing the transcription follows, and its year, be identified from the volumes themselves. That is not yet done for this chapter, so the K citation above names an edition and a volume but no printing.

---

## 6.3 · The instrument

Three scripts do the work, all in `canon/`.

- `khmer_pali.py` transliterates Khmer script to romanized Pāli in the CST's convention. Its rules are short: a consonant carries an inherent *a* unless followed by a vowel sign, a subscript or a *bantoc*; *niggahita* is *ṃ*; and the vowel sign Khmer Pāli uses for *iṃ* is handled directly.
- `pada.py` normalizes each term: Unicode NFC, lower case, final *-ṅ* to *-ṃ*, and the sandhi rule of chapter 5.
- `compare.py` aligns the two term lists as sequences. A position is IDENTICAL if the normalized terms are equal; CLOSE if they differ by an edit distance of at most 3 and a similarity ratio of at least 0.7; otherwise DIFFERENT. Unmatched terms are reported as added or dropped. A CLOSE position is undecided until the printed page is read.

**Controls.** Before use, the transliterator scored 10 of 10 on known words chosen to cover conjuncts, the *niggahita* and that vowel sign (`canon/CONTROL-WORDS.md`).

For this draft a second control was run, on a known answer, and it touches no K text. The Khmer-script file of the CST's digital distribution as held locally, `india/khmer/abh01m.mul.xml`, is a machine transliteration of the same Burmese text, so it is **not a witness**, and that is what makes it useful here. Transliterated back and aligned with C at §1, it should come out identical, and it does: 56 terms, 56 IDENTICAL. Planted faults on the alignment (a dropped term, a swapped pair, a respelled term) are each reported. This shows the pipeline loses nothing on clean input. It does not show anything about the K transcription.

**Two artifacts of the working text**, both handled and both reported in `RESULTS.md`.

- *Subscript order.* Some words carry the subscript RO typed before another subscript, which reads as *-inrdiyaṃ*. The transliterator normalizes the order. This is an encoding matter and has no textual weight.
- *Page furniture.* At the page break a running header fell between a term and its *hoti*, and first produced a false DIFFERENT. Page furniture is now stripped before alignment.

---

## 6.4 · The result

**C 56 terms · K 56 terms · 48 identical · 8 spelled differently · 0 added, dropped or reordered.**

These counts are the record of the run on 2026-09-27 in `RESULTS.md`. They were not regenerated for this draft: the K transcription is not in the repository and was not fetched. See GAP 6c.

Each of the 8 was checked against the printed page as §4 of the pre-registration requires. The right column below takes the latest classification, from *The Counts Check* §8.2, which read the CST's apparatus as well. It is more cautious than `RESULTS.md`'s first entry on the last row.

| Pos. | C | K as transcribed | K as printed | CST apparatus (`abh01m.mul.xml:1569`) | Classification |
|---|---|---|---|---|---|
| 37 | *hirī* | *hiri* | *hiri* | none | **edition orthography**, not documented in either apparatus |
| 39 | *kāyapassaddhi* | *kāyappassaddhi* | *kāyappassaddhi*, with K's note giving a reading with single *p* | *kāyappassaddhi (syā.)* | **edition orthography**, recorded in K's apparatus; agrees with the reading C attributes to *syā.* |
| 40 | *cittapassaddhi* | *cittappasaddhi* | *cittappassaddhi*, with K's note likewise | *cittappassaddhi (syā.)* | edition orthography (*pp*), likewise; the single *s* is a transcription slip |
| 10 | *cittassekaggatā* | *cittaspekaggatā* | *cittassekaggatā* | none | transcription slip |
| 17 | *somanassindriyaṃ* | *somanassidṭhiyaṃ* | *somanassindriyaṃ* | none | transcription slip |
| 47 | *kāyapāguññatā* | *kāyapātuññatā* | *kāyapāguññatā* | none | transcription slip |
| 12, 25 | *vīriya-* | *viriya-* | *vīriya-*, long *ī* read at moderate confidence | *viriyindriyaṃ*, *viriyabalaṃ (sī. syā.)* | **undecided**: `RESULTS.md` first classed these as slips, to be confirmed; the short *i* is a real reading in the witnesses C names, so they stay open until the print is read at higher confidence |

The CST's apparatus was read again at the cited line for this draft, and the column above reflects it: *viriyindriyaṃ* and *viriyabalaṃ (sī. syā.)*, *kāyappassaddhi* and *cittappassaddhi (syā.)*, and *kāyujjukatā*, *cittujjukatā (sī. ka.)* at two further positions that do not differ between C and K. It has no note on *hirī*. *The Counts Check* reads *sī.* and *syā.* as the Sinhala and Thai readings. The K side of the table, and the reading of K's foot-of-page notes, is not checkable from this repository and is reported from the record.

The slips have been reported to the transcriber as corrections to a working draft. They are not variants, and nothing here counts against that work: a page-by-page transcription is what made this comparison possible.

**P-FA5 is confirmed.** 56 = 56, 0 added, dropped or reordered, under the registered falsifier.

---

## 6.5 · What agreement between these two editions means

**They are not independent witnesses.** The CST is the Burmese recension. K's apparatus at this passage cites what we read as the Burmese reading, under the siglum *o. ma.* So K's editors had the Burmese tradition in view, and agreement between K and C cannot count as two independent lines converging. `APPARATUS.md` requires this to be said wherever agreement is reported.

**The Sixth Council's collation is older and wider.** On the record in *The Counts Check* §8.1, the Council whose text the CST is collated the script editions of its day, the Cambodian among them. The CST's apparatus carries a Cambodian siglum, *kaṃ.*, which a count of the decoded files finds 35 times in the notes of `s0101m.mul.xml` and 0 times in those of `abh01m.mul.xml`. So at this passage the CST records no Cambodian reading, and §6.4's comparison is not a repetition of what its apparatus already shows. It is also much narrower than a critical edition: one modern printed edition, one list, and no manuscripts.

**The list is easy.** It is a run of technical terms, each followed by *hoti*. A passage like this is where agreement is most expected, so agreement here predicts little about the rest, and `READERS.md` asks readers which result they would expect to fail when the comparison goes further.

**No logic was at stake.** The program's interest is in a variant that changes the logic. On this list, as read, no difference touches which factor a term names, so no count changes. That is one list's answer to that question, and the question stands for the rest.

---

## 6.6 · What this chapter does not establish

**GAP 6a. The comparison has not been extended beyond the first type.** The outline marks this chapter **extend**. The extension needs a new pre-registered rung, like the second file: which passages, which map, what counts as a variant, and what happens to abbreviated lists. That rung is not written, and this chapter does not attempt it. Nothing here should be quoted as "the editions agree" without "on one list".

**GAP 6b. The printing** (§6.2).

**GAP 6c. The result cannot be rerun from this repository.** `canon/compare.py` needs the K transcription, which by the registered rule is not public, so an outside reader can rerun the instrument and its controls but not the result. The 56, 48 and 8 above are therefore a record, not a regeneration, and they are not produced by `reproduce.sh`. `numbers.json` holds none of them. Nor was the K side re-fetched for this draft, so whether the transcription has since changed is unknown. A way to make the result independently checkable, such as a published per-position hash or a reader with access to the scans, is owed if the reproduction question stays closed.

**GAP 6d. Volume and page per figure.** `APPARATUS.md` requires each count to name its Khmer volume and page "where the comparison exists". So far the comparison exists at one place, volume 78, pp. 16–17.

**GAP 6e. Open readings.** The long *ī* of *vīriya-* at positions 12 and 25 is read from the scan at moderate confidence. The siglum *o. ma.* is read as Burmese without the edition's abbreviation key, which was not consulted, so that reading is ours (tier ours).

**GAP 6f. P-FA3's question is unanswered at L2,** and it cannot be answered with the sources held (§6.1).

---

## 6.7 · Limits, collected

- One passage, the first list, in a working transcription checked against the printed scan only where the two editions differed. Where they agree, a shared error in the transcription would not have been seen.
- Two editions that share ancestry.
- A record rather than a regeneration, on the K side.
- No Khmer text reproduced, and the blessing still being sought.
- Chapter 4's counts remain on edition C alone.
