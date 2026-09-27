/-
  Rung 3 — L1 against L2 for the first wholesome sense-sphere citta.
  `canonNamed` is the set of 29 cetasikas the Dhammasaṅgaṇī names for this citta (CST `abh01m` §1,
  mapped by `canon/pada.py` with the synonym map pre-registered in PREREGISTRATION-2026-09-27b.md §3).
-/
import Rules
namespace FormalAbhidhamma
open Cetasika

def canonNamed : List Cetasika :=
  [phassa, vedana, sanna, cetana, ekaggata, jivitindriya,          -- 6 of the 7 universals (no manasikāra)
   vitakka, vicara, viriya, piti,                                   -- 4 of the 6 occasionals (no chanda, adhimokkha)
   saddha, sati, hiri, ottappa, alobha, adosa,
   kayapassaddhi, cittapassaddhi, kayalahuta, cittalahuta, kayamuduta, cittamuduta,
   kayakammannata, cittakammannata, kayapagunnata, cittapagunnata, kayujukata, cittujukata,
   panna]

/-- The nine the commentary supplies for the canon's open clause "ye vā pana … aññepi atthi". -/
def yevapanaka : List Cetasika :=
  [chanda, adhimokkha, manasikara, tatramajjhattata, karuna, mudita, sammavaca, sammakammanta, sammaajiva]

def firstKusala : Citta :=
  { jati := .kusala, bhumi := .kama, vedana := .somanassa, root := .beautiful, knowing := true }

theorem canon_29 : canonNamed.length = 29 ∧ canonNamed.Nodup := by decide
/-- L2 never contradicts L1 here: everything the canon names, the Saṅgaha's rules also give. -/
theorem canon_subset : canonNamed.all (arises firstKusala) = true := by decide
/-- And what L2 adds is exactly the nine "ye vā pana" factors: 29 + 9 = 38. -/
def addedByL2 : List Cetasika := all.filter (fun x => arises firstKusala x && !canonNamed.contains x)

/-- As SETS (the canon lists the nine in no order; `all` lists them in class order): the two lists
    have the same members and the same length, 9. -/
theorem added_is_yevapanaka :
    addedByL2.length = 9 ∧ yevapanaka.all addedByL2.contains = true ∧ addedByL2.all yevapanaka.contains = true := by decide
theorem thirty_eight : (all.filter (arises firstKusala)).length = 38 := by decide

end FormalAbhidhamma
