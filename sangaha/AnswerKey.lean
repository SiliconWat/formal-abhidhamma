/-
  THE ANSWER KEY — the Saṅgaha's own figures, entered SEPARATELY from the rules so the rules
  cannot restate it. Order follows the generator (tradition order within each group).
  PROVENANCE — COLLATED 2026-09-27 AGAINST THE CHAṬṬHA SAṄGĀYANA (edition C): VRI tipitaka-xml,
  `romn/abh07t.nrf.xml` (Abhidhammatthasaṅgaho), chapter 2 paragraph numbers cited per figure:
    per-factor, §13–§19 ("Chasaṭṭhi pañcapaññāsa, ekādasa ca soḷasa; Sattati vīsati ceva … Pañcapaññāsa
      chasaṭṭhiṭṭhasattati tisattati; Ekapaññāsa cekūnasattati sapakiṇṇakā") · unwholesome §20–§27 ·
      beautiful §28–§32 · supramundane §36–§37 · sublime §38–§39 · sense-sphere beautiful §40–§41 ·
      unwholesome groupings §43–§51 ("Ekūnavīsāṭṭhārasa, vīsekavīsa vīsati. Dvāvīsa pannarasa") ·
      rootless §53–§58 · chapter 3 §3–§17 (feeling and root counts, `FeelingKey`/`RootKey` below).
  Cross-checked against a second printing (Pāli + Nārada, ballwarapol.github.io/sangaha/chapter_2.htm).
  ⚠️ THE TEXT MIXES RECKONINGS, and the key follows it: the jhāna-dependent factors (vitakka, vicāra,
  pīti) and the feelings are counted over 121; the other factors and the roots over 89.
  Figures the text does not state are NOT keyed.
-/
import Citta
namespace FormalAbhidhamma

def keyMundane : List Nat :=
  [19, 21, 19, 21, 18, 20, 18, 20] ++                 -- greed-rooted 8
  [20, 22] ++                                         -- hate-rooted 2
  [15, 15] ++                                         -- delusion-rooted 2
  [7, 7, 7, 7, 7, 10, 10] ++                          -- rootless resultants of unwholesome kamma 7
  [7, 7, 7, 7, 7, 10, 11, 10] ++                      -- rootless resultants of wholesome kamma 8
  [10, 11, 12] ++                                     -- rootless functionals 3
  [38, 38, 37, 37, 37, 37, 36, 36] ++                 -- sense-sphere beautiful: wholesome 8
  [33, 33, 32, 32, 32, 32, 31, 31] ++                 --                         resultant 8
  [35, 35, 34, 34, 34, 34, 33, 33] ++                 --                         functional 8
  [35, 34, 33, 32, 30, 35, 34, 33, 32, 30, 35, 34, 33, 32, 30] ++  -- fine-material 15
  List.replicate 12 30                                -- immaterial 12

def key89  : List Nat := keyMundane ++ List.replicate 8 36
def key121 : List Nat := keyMundane ++ (List.replicate 8 [36, 35, 34, 33, 33]).flatten

open Cetasika
/-- Saṅgaha ch. 2 §4–§5, counted over 121 (the text's reckoning for the jhāna-dependent factors):
    "with" 55 · 66 · 51 and "without" 66 · 55 · 70. -/
def occurrenceKey121 : List (Cetasika × Nat) := [(vitakka, 55), (vicara, 66), (piti, 51)]
def absenceKey121    : List (Cetasika × Nat) := [(vitakka, 66), (vicara, 55), (piti, 70)]

/-- Saṅgaha ch. 2 §4–§5 and §6–§9, counted over 89: universals in all 89 · adhimokkha 78 · viriya 73 ·
    chanda 69 (without: 11 · 16 · 20) · the four unwholesome universals 12 · lobha 8 · diṭṭhi 4 · māna 4 ·
    the hate quartet 2 · thīna-middha 5 · vicikicchā 1 · beautiful universals 59 · abstinences 16 ·
    illimitables 28 · paññā 47. -/
def occurrenceKey89 : List (Cetasika × Nat) :=
  (universals.map (·, 89)) ++
  [(adhimokkha, 78), (viriya, 73), (chanda, 69),
   (moha, 12), (ahirika, 12), (anottappa, 12), (uddhacca, 12), (lobha, 8), (ditthi, 4), (mana, 4),
   (dosa, 2), (issa, 2), (macchariya, 2), (kukkucca, 2), (thina, 5), (middha, 5), (vicikiccha, 1)] ++
  (beautifulUniversals.map (·, 59)) ++ (abstinences.map (·, 16)) ++ (illimitables.map (·, 28)) ++ [(panna, 47)]
def absenceKey89 : List (Cetasika × Nat) := [(adhimokkha, 11), (viriya, 16), (chanda, 20)]

/-- Chapter 3 §3–§9 (feelings, counted over 121): "Sukhamekattha dukkhañca, domanassaṃ dvaye ṭhitaṃ.
    Dvāsaṭṭhīsu somanassaṃ, pañcapaññāsaketarā." — pleasure 1 · pain 1 · displeasure 2 · joy 62 · equanimity 55. -/
def feelingKey121 : List (Vedana × Nat) :=
  [(.sukha, 1), (.dukkha, 1), (.domanassa, 2), (.somanassa, 62), (.upekkha, 55)]

/-- Chapter 3 §10–§17 (roots, counted over 89): "Ahetukāṭṭhārasekahetukā dve dvāvīsati. Dvihetukā matā
    sattacattālīsatihetukā." — rootless 18 · one-rooted 2 · two-rooted 22 · three-rooted 47. -/
def rootKey89 : List (Nat × Nat) := [(0, 18), (1, 2), (2, 22), (3, 47)]

end FormalAbhidhamma
