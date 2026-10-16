/-
  Rung 4 — the citta × cetasika table the rules generate, printed (never asserted), one line per
  citta-type in generator order, one 0/1 per cetasika in `all` order. Read by fca.py and mutants.py.
-/
import Rules
namespace FormalAbhidhamma

def tableRows (cs : List Citta) : List String :=
  cs.map fun c => String.join (all.map fun x => if arises c x then "1" else "0")

def firstKusalaRow : Citta :=
  { jati := .kusala, bhumi := .kama, vedana := .somanassa, root := .beautiful, knowing := true }

#eval IO.println (String.intercalate "\n" (tableRows cittas121))
#eval IO.println "#89"
#eval IO.println (String.intercalate "\n" (tableRows cittas89))
#eval IO.println s!"#firstKusala {cittas121.findIdx (· == firstKusalaRow)}"

end FormalAbhidhamma
