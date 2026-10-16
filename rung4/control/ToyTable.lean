import ToyRules
namespace Toy
#eval IO.println (String.intercalate "\n" (rows.map fun t => String.join (all.map fun f => if arises t f then "1" else "0")))
end Toy
