# Outline (working draft)

## The question

The tradition says the Abhidhamma's types of consciousness (*citta*) arise *by composition* from its mental
factors (*cetasika*). Written as general constraints, never as a per-citta table, do the combination rules
generate exactly the traditional counts? In which textual layer do the counts first become derivable, and do
the two editions (Khmer and Chaṭṭha Saṅgāyana) agree?

## Scope (fixed 2026-10-15)

**One claim:** the two methods of the *Saṅgaha*'s chapter 2 (by factor, *sampayoga*; by type, *saṅgaha*) are
mutually consistent under one short set of general rules, with the layer of each rule and the agreement of
the editions established, and with the key's blind spots measured. Chapters 3–6 carry it; chapter 8 states
its limits; chapter 7 adds only proof runs that grade STRONG under the rubric.

**Out of scope:** the physics comparison (arm C) appears at most as an appendix, labeled a lens; the Silicon
Simile never appears; no claim about whether the Abhidhamma is true; no cosmology.

**The test an examiner will apply:** the agreement is already printed (Bodhi's Table 2.4), the enumeration has
a prior model (AloofBuddha's Haskell repository), and the layering is in Nyanaponika (1949). So the
dissertation must show what the instrument finds that a chart cannot: the key's measured blindness, the
compression against an objective minimum and two null models (rung 4), and edition and layer results beyond
the first type.

## Chapters, mapped to what already exists

| # | Chapter | Draws on | State |
|---|---|---|---|
| 1 | Introduction: the claim of composition, and what a proof assistant can and cannot show | `README.md` §What this is not | to write |
| 2 | Background: the four ultimates, the textual layers, the two editions, prior formal work and charts (Barendregt 2006; Barendregt and Raffone 2022; Bodhi's tables; Mehm Tin Mon's charts; AloofBuddha; Kyaw Pyi Phyo 2014) | `SOURCES.md` | to write |
| 3 | Method: pre-registration before code, controls on a known failure, kill criteria, layers as a variable, timestamps | `PREREGISTRATION.md`, `control/`, `TIMESTAMPS.md` | results exist; to write up |
| 4 | Result I, the counts: 9 generator clauses and 18 rules, none naming a citta, give all 89 and 121 types and every count in chapter 2; every deliberate break fails | `sangaha/`, `RESULTS.md` (Rungs 2 and 2b) | results exist; to write up |
| 5 | Result II, the layers: the canon alone names 29 of the 38 factors of the first wholesome type; the other nine are the commentary's *yevāpanaka*, inherited by the manual | `canon/`, `sangaha/Canon.lean` (Rung 3) | results exist; to write up |
| 6 | Result III, the editions: the Khmer edition and the CST name the same 56 terms in the same order | `canon/` (Rung 3; P-FA5) | first type only; **extend** |
| 7 | Result IV, commitments: proof runs graded STRONG, failures included | `kala/`, `runs/INDEX.md` | select |
| 8 | Limits, measured: the implication basis against the 18 rules; null models N1 and N2; the key's blindness to pairs of rule errors | `rung4/` | **instruments built and tested; pre-registration drafted (`RUNG4-PREREG-DRAFT.md`), awaiting approval** |
| 9 | Conclusion | | to write |

Appendices: the Lean sources, the run ledger, the timestamp record, `numbers.json`.

## Owed, in order

1. **Approve and push the rung 4 pre-registration** (founder's predictions added), then run rung 4.
2. **Extend the edition and layer comparisons beyond the first type** (a new pre-registered rung, like the
   second file). Identify the Khmer printing; cite volume and page per figure (`APPARATUS.md`).
3. **Read the Burmese ṭīkā debate on chapter 2** (Ledi Sayadaw's *Paramatthadīpanī*; the *Aṅkura-ṭīkā*), the
   likeliest place for a counting of the §30 dissent.
4. **Choose the proof runs** for chapter 7 by the rubric's grades.
5. **Write chapters 3–6** from the results; then 1, 2, 8, 9. Every number from `numbers.json`.
6. **Readers** (`READERS.md`): a Pāli/Abhidhamma scholar and a formal-methods reader on chapter 4 first, and one
   hostile reader.
7. **Peer review**: chapter 4 to a formal-methods venue, chapters 5–6 to a Pāli or Buddhist-studies journal
   (`VENUES.md`).
