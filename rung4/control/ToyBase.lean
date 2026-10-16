/- Rung 4 harness control: a toy classification whose mutation outcomes are known by construction. -/
namespace Toy
inductive F | a | b | c | d deriving DecidableEq, Repr
def all : List F := [.a, .b, .c, .d]
structure T where
  x : Bool
  y : Bool
  deriving DecidableEq, Repr
def rows : List T := [⟨true, true⟩, ⟨true, false⟩, ⟨false, true⟩, ⟨false, false⟩]
end Toy
