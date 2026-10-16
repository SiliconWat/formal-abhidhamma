# Sources

## This repository

| Path | For |
|---|---|
| `PREREGISTRATION.md`, `PREREGISTRATION-2026-09-27b.md` | the method and the predictions, fixed before any formalization |
| `control/` | the instrument tested on a known answer and a known failure |
| `sangaha/` | Rungs 2 and 2b: the counts |
| `canon/` | Rung 3: the canon against the *Saṅgaha*, and the Khmer edition against the CST |
| `kala/` | axioms, theorems, and the answers the texts themselves give (the test bank) |
| `matika/` | the *mātikā*, generated from the CST |
| `runs/INDEX.md` | every pre-registered run and control, failures included |
| `RESULTS.md` | results by rung, with corrections |
| `TIMESTAMPS.md`, `timestamps/` | the three independent dates behind each claim |

Cite the program as [doi:10.5281/zenodo.23067241](https://doi.org/10.5281/zenodo.23067241) (concept DOI).

## Published papers from this program (CC0)

- *Machine-Checked Consistency of a Buddhist Classification: Lean Theorems for the Abhidhamma's 89 and 121
  Types of Consciousness — The Counts Check.* [doi:10.5281/zenodo.23020670](https://doi.org/10.5281/zenodo.23020670).
  The basis of chapters 3–5.
- *Discreteness, Adjacency and Order: A Structural Comparison of the Theravāda Abhidhamma with Causal Sets and
  Loop Quantum Gravity.* [doi:10.5281/zenodo.23020020](https://doi.org/10.5281/zenodo.23020020). Arm C, a lens
  only: background, never a result.
- *Causal Set Theory, the Growing Block, and the Buddhist Debate on the Three Times: What the Earliest
  Vibhajjavādin Records Say.* [doi:10.5281/zenodo.23020015](https://doi.org/10.5281/zenodo.23020015).
- *Letting the Texts Lose* (essay): [thonly.org/research/letting-the-texts-lose](https://thonly.org/research/letting-the-texts-lose).
  Why the runs are built so the texts can fail.

## Neighbors (cited, not competed with)

Prior formal work and charts (full entries in *The Counts Check*, Citations):

- H. Barendregt, "The Abhidhamma Model of Consciousness AM₀ and some of its Consequences" (preprint, 2006), and
  H. Barendregt and A. Raffone, "Axiomatizing Consciousness with Applications" (LNCS, Springer, 2022), the
  nearest formal model of the Abhidhamma.
- Bhikkhu Bodhi (ed.), *A Comprehensive Manual of Abhidhamma*, ch. 2 Tables 2.2–2.4: the agreement of the two
  methods, printed as a chart. The nearest prior art for the consistency test.
- Mehm Tin Mon, *The Essence of Buddha Abhidhamma* (3rd ed., 2015), Charts No. 2 and No. 3.
- [AloofBuddha/abhidhamma](https://github.com/AloofBuddha/abhidhamma): a Haskell model enumerating the 89 and 121.
- Nyanaponika Thera, *Abhidhamma Studies* (1949; 3rd ed. 1976): the layering of the *yevāpanaka* in print.
- Kyaw Pyi Phyo, *Paṭṭhāna (Conditional Relations) in Burmese Buddhism* (PhD thesis, King's College London, 2014).
- [takuya50/buddhist-comparative-logic](https://github.com/takuya50/buddhist-comparative-logic): Lean 4 and
  Isabelle formalizations of the Heart Sutra, Madhyamaka, pramāṇa and Yogācāra.
- [PJ-Oliveira/abhidhamma](https://github.com/PJ-Oliveira/abhidhamma): a citta-vīthi simulator, cetasika
  analyzer and Paṭṭhāna matrix.

## Method references (rung 4 and the breaks)

- R. A. DeMillo, R. J. Lipton and F. G. Sayward, "Hints on Test Data Selection," *Computer* 11(4), 1978
  (mutation testing).
- A. Celik et al., "Mutation Analysis for Coq," ASE 2019 (mutation inside a proof assistant).
- J. Rissanen, "Modeling by shortest data description," *Automatica* 14(5), 1978 (description length).
- J.-L. Guigues and V. Duquenne, "Familles minimales d'implications informatives résultant d'un tableau de
  données binaires," *Mathématiques et Sciences Humaines* 95, 1986 (the canonical basis).
- B. Ganter and R. Wille, *Formal Concept Analysis: Mathematical Foundations*, Springer, 1999.
- G. Strona et al., "A fast and unbiased procedure to randomize ecological binary matrices with fixed row and
  column totals," *Nature Communications* 5, 2014 (the curveball algorithm).
- D. Gale (1957) and H. J. Ryser (1957): when a binary matrix with given row and column totals exists, and why
  distinct ones can share every total.

## Commentarial sources still to read

- Ledi Sayadaw, *Paramatthadīpanī*, and the *Aṅkura-ṭīkā*: the Burmese debate on chapter 2, the likeliest
  place for a counting of the §30 dissent.
- The *Vibhāvinī* at §30 (already cited by `sangaha/Check.lean` for the main reading).

## Secondary literature (to read; verify the edition before citing)

- Bhikkhu Bodhi (gen. ed.), *A Comprehensive Manual of Abhidhamma: The Abhidhammattha Saṅgaha of Ācariya
  Anuruddha*. Buddhist Publication Society, 1993.
- Nārada Thera, *A Manual of Abhidhamma*. Buddhist Publication Society.
- Nyanaponika Thera, *Abhidhamma Studies: Buddhist Explorations of Consciousness and Time*.
- Y. Karunadasa, *The Theravāda Abhidhamma: Its Inquiry into the Nature of Conditioned Reality*. Centre of
  Buddhist Studies, University of Hong Kong, 2010.
- Noa Ronkin, *Early Buddhist Metaphysics: The Making of a Philosophical Tradition*. RoutledgeCurzon, 2005.
- Rupert Gethin, "The Mātikās: Memorization, Mindfulness, and the List," in Janet Gyatso (ed.), *In the
  Mirror of Memory*. SUNY Press, 1992.
- Leonardo de Moura and Sebastian Ullrich, "The Lean 4 Theorem Prover and Programming Language," CADE-28, 2021.
