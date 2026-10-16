import ToyBase
namespace Toy
open F
def arises (t : T) (f : F) : Bool :=
  if f == a then t.x                                                                    -- §R1
  else if f == b then t.y                                                               -- §R2
  else if f == c then !t.x                                                              -- §R3
  else !t.y && (t.x || !t.x)                                                            -- §R4 (the parenthesis is a tautology: an equivalent mutant lives here)

def count (t : T) : Nat := (all.filter (arises t)).length
def occurrences (f : F) : Nat := (rows.filter fun t => arises t f).length
end Toy
