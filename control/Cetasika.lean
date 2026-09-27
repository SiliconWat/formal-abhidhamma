/-
  Formal Abhidhamma — the 52 cetasikas and their four classes.
  Source: Abhidhammattha-saṅgaha ch. 2 (tier: Saṅgaha). ASCII transliteration of the Pāli.
-/
namespace FormalAbhidhamma

inductive Cetasika where
  -- 7 universals (sabbacittasādhāraṇa)
  | phassa | vedana | sanna | cetana | ekaggata | jivitindriya | manasikara
  -- 6 occasionals (pakiṇṇaka)
  | vitakka | vicara | adhimokkha | viriya | piti | chanda
  -- 14 unwholesome (akusala)
  | moha | ahirika | anottappa | uddhacca | lobha | ditthi | mana | dosa
  | issa | macchariya | kukkucca | thina | middha | vicikiccha
  -- 25 beautiful (sobhana): 19 universal beautiful
  | saddha | sati | hiri | ottappa | alobha | adosa | tatramajjhattata
  | kayapassaddhi | cittapassaddhi | kayalahuta | cittalahuta | kayamuduta | cittamuduta
  | kayakammannata | cittakammannata | kayapagunnata | cittapagunnata | kayujukata | cittujukata
  -- 3 abstinences (virati), 2 illimitables (appamaññā), 1 wisdom (paññindriya)
  | sammavaca | sammakammanta | sammaajiva
  | karuna | mudita
  | panna
  deriving DecidableEq, Repr

open Cetasika

def universals : List Cetasika :=
  [phassa, vedana, sanna, cetana, ekaggata, jivitindriya, manasikara]
def occasionals : List Cetasika := [vitakka, vicara, adhimokkha, viriya, piti, chanda]
def unwholesome : List Cetasika :=
  [moha, ahirika, anottappa, uddhacca, lobha, ditthi, mana, dosa,
   issa, macchariya, kukkucca, thina, middha, vicikiccha]
def beautifulUniversals : List Cetasika :=
  [saddha, sati, hiri, ottappa, alobha, adosa, tatramajjhattata,
   kayapassaddhi, cittapassaddhi, kayalahuta, cittalahuta, kayamuduta, cittamuduta,
   kayakammannata, cittakammannata, kayapagunnata, cittapagunnata, kayujukata, cittujukata]
def abstinences : List Cetasika := [sammavaca, sammakammanta, sammaajiva]
def illimitables : List Cetasika := [karuna, mudita]

def all : List Cetasika :=
  universals ++ occasionals ++ unwholesome ++ beautifulUniversals ++ abstinences ++ illimitables ++ [panna]

/-- The Saṅgaha's total: 52. -/
theorem count_52 : all.length = 52 := by decide
theorem classes : (universals.length, occasionals.length, unwholesome.length,
    beautifulUniversals.length + abstinences.length + illimitables.length + 1) = (7, 6, 14, 25) := by decide

end FormalAbhidhamma
