/-
  Rung 4 — each citta-type's AXIS values (the generator's coordinates, never its cetasikas), one line per
  type in generator order, for the axis-built null model in nulls.py: random rule systems of the same shape
  as the text's, drawn over these same axes.
-/
import Citta
namespace FormalAbhidhamma

def last (s : String) : String := (s.splitOn ".").getLast!
def dhatuStr : Dhatu → String
  | .sense d => s!"sense{d}" | .mano => "mano" | .manovinnana => "manovinnana"

def axesLine (c : Citta) : String :=
  s!"jati={last (toString (repr c.jati))} bhumi={last (toString (repr c.bhumi))} vedana={last (toString (repr c.vedana))} root={last (toString (repr c.root))} dhatu={dhatuStr c.dhatu} ofKusala={c.ofKusala} knowing={c.knowing} view={c.view} prompted={c.prompted} jhana={c.jhana}"

#eval IO.println (String.intercalate "\n" (cittas121.map axesLine))

end FormalAbhidhamma
