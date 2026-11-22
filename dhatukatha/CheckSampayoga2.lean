/-
  dhatukatha/CheckSampayoga2.lean — run 2026-11-22-dhatukatha-association-2 (PRE-REGISTERED, 49ea7a4): do the Dhātukathā's own counting convention (A130, A131) and each
  mental item's consciousness ELEMENTS as the Dhammasaṅgaṇī lists them (Ranges.lean, generated from cittuppada/ and committed before the registration) reproduce the sixth
  method's stated counts? The rule below is the registered rule, word for word in code. The rows had all been SEEN (run 1 and its refuter): a CONSISTENCY test; the independent
  input is the element ranges, from another book.
-/
import Sampayoga
import Ranges
namespace FormalAbhidhamma.Dhatukatha

inductive Kind | matter | feeling | perception | formation | formations | consciousness
  deriving DecidableEq, Repr

def all7 : List Nat := [0, 1, 2, 3, 4, 5, 6]

/-- The in-scope items: each with its kind and its consciousness elements (E). Feelings and formations take E from the Dhammasaṅgaṇī (Ranges.lean); the whole aggregates
    and consciousness items all seven, or the one element they are. Anything else is OUT of scope (it needs an identification of item with terms). -/
def kindOf : String → Option (Kind × List Nat)
  | "kh0" | "ay0" | "ay9" | "dh0" | "dh9" | "sacca_nirodha" | "ind0" | "ind4" | "ind5" | "ind6" => some (.matter, [])
  | "kh1" => some (.feeling, all7) | "kh2" => some (.perception, all7) | "kh3" => some (.formations, all7)
  | "kh4" | "ay10" | "ind7" | "citta" | "vinnana_link" => some (.consciousness, all7)
  | "dh10" => some (.consciousness, [0]) | "dh15" => some (.consciousness, [5]) | "dh16" => some (.consciousness, [6])
  | "ind9" => some (.feeling, rangeOf "sukhindriyaṃ") | "ind10" => some (.feeling, rangeOf "dukkhindriyaṃ")
  | "ind11" => some (.feeling, rangeOf "somanassindriyaṃ") | "ind12" => some (.feeling, rangeOf "domanassindriyaṃ")
  | "ind13" => some (.feeling, rangeOf "upekkhindriyaṃ") | "vedana_link" => some (.feeling, rangeOf "vedanā")
  | "ind14" => some (.formation, rangeOf "saddhindriyaṃ") | "ind15" => some (.formation, rangeOf "vīriyindriyaṃ")
  | "ind16" => some (.formation, rangeOf "satindriyaṃ") | "ind17" => some (.formation, rangeOf "samādhindriyaṃ")
  | "ind18" => some (.formation, rangeOf "paññindriyaṃ") | "ind19" => some (.formation, rangeOf "anaññātaññassāmītindriyaṃ")
  | "ind20" => some (.formation, rangeOf "aññindriyaṃ") | "ind21" => some (.formation, rangeOf "aññātāvindriyaṃ")
  | "phassa" | "phassa_link" => some (.formation, rangeOf "phasso") | "cetana" => some (.formation, rangeOf "cetanā")
  | _ => none

/-- THE RULE, as registered (A130, A131): associated fully / partly, dissociated fully / partly, each as (aggregates, bases, elements). -/
def rule : Kind × List Nat → (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat)
  | (.matter, _) => ((0, 0, 0), (0, 0, 0), (4, 1, 7), (0, 1, 1))
  | (k, E) =>
    let e := E.length
    let consc := k == .consciousness
    ((3, if consc then 0 else 1, if consc then 0 else e),
     (if k == .formation then 1 else 0, 1, 1),
     (1, 10, 10 + 7 - e),
     (0, 1, 1))

def inScope (r : SRow) : Bool := match r.items with | [i] => (kindOf i).isSome | _ => false
def computed2 (r : SRow) := match r.items with | [i] => (kindOf i).map rule | _ => none
def reproduced2 (r : SRow) : Bool := computed2 r == some (r.aF, r.aP, r.dF, r.dP)

-- The misses (if any), line by line; then (in-scope rows, reproduced) and the out-of-scope rows' count.
#eval (srows.filter (fun r => inScope r && !reproduced2 r)).map (fun r => (r.line, r.items, (r.aF, r.aP, r.dF, r.dP), computed2 r))
#eval ((srows.filter inScope).length, (srows.filter (fun r => inScope r && reproduced2 r)).length, (srows.filter (fun r => !inScope r)).length)

set_option maxRecDepth 200000 in
/-- THE RESULT (runs/2026-11-22-dhatukatha-association-2/RUN.md): the convention A130/A131, with the Dhammasaṅgaṇī's element ranges, reproduces every one of the 38
    in-scope rows of the sixth method's inner list — CONSISTENT (the rows had been seen; the ranges come from another book). -/
theorem every_in_scope_row_is_reproduced : (srows.filter inScope).all reproduced2 = true := by decide

set_option maxRecDepth 200000 in
theorem the_in_scope_count : (srows.filter inScope).length = 38 := by decide

end FormalAbhidhamma.Dhatukatha
