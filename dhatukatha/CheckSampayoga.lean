/-
  dhatukatha/CheckSampayoga.lean — does ONE association rule, with every item's dhammas as the FIRST method fixed them (Check.lean, `itemAtoms`, unchanged), reproduce the SIXTH method's
  stated association and dissociation counts (its inner list, §1–4)? PRE-REGISTERED, rule and all, before any count was computed: runs/2026-11-22-dhatukatha-association/PREREG.md.
  The counts (Sampayoga.lean, GENERATED from the CST) are the TEST BANK and never premises: nothing below reads a count except to compare.
  THE RULE, as registered — over the 22 kinds of Check.lean:
    a is ASSOCIATED with b iff a ≠ b, both are mental, and not both are consciousness (A30's four marks; A1: two cittas never together);
    a is DISSOCIATED from b iff exactly one of them is mental (matter and nibbāna the other side);
    an item X is related to an aggregate, base or element G FULLY iff every dhamma of X is related to every dhamma of G, PARTIALLY (kehici) iff some pair is and not all.
  Three rows were SEEN while the rule was designed (L1201, L1205, L1209: the five aggregates); they are reported apart.
-/
import Check
import Sampayoga
namespace FormalAbhidhamma.Dhatukatha

def mental : Atom → Bool
  | .vedana | .sanna | .sankhara | .eyeC | .earC | .noseC | .tongueC | .bodyC | .manoD | .manoV => true
  | _ => false

def consc : Atom → Bool
  | .eyeC | .earC | .noseC | .tongueC | .bodyC | .manoD | .manoV => true
  | _ => false

def assoc (a b : Atom) : Bool := a != b && mental a && mental b && !(consc a && consc b)
def dissoc (a b : Atom) : Bool := mental a != mental b

/-- The groups: the five aggregates, twelve bases and eighteen elements, each as its dhammas. -/
def aggs : List (List Atom) := (List.range 5).map kBlock
def bases : List (List Atom) := (List.range 12).map (block ayatana)
def elems : List (List Atom) := (List.range 18).map (block dhatu)

def full (rel : Atom → Atom → Bool) (X G : List Atom) : Bool := !G.isEmpty && !X.isEmpty && X.all (fun x => G.all (fun g => rel x g))
def some' (rel : Atom → Atom → Bool) (X G : List Atom) : Bool := X.any (fun x => G.any (fun g => rel x g))
def part (rel : Atom → Atom → Bool) (X G : List Atom) : Bool := some' rel X G && !full rel X G

def tally (f : List Atom → Bool) : Nat × Nat × Nat :=
  ((aggs.filter f).length, (bases.filter f).length, (elems.filter f).length)

/-- What the rule says about a combination of items. -/
def computed (xs : List String) : (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat) :=
  let X := atomsOf xs
  (tally (full assoc X), tally (part assoc X), tally (full dissoc X), tally (part dissoc X))

def sreproduced (r : SRow) : Bool := computed r.items == (r.aF, r.aP, r.dF, r.dP)

def seen : List Nat := [1201, 1205, 1209]
def unseen (r : SRow) : Bool := !seen.contains r.line && !r.items.any (fun i => fitted.contains i)

-- The misses, line by line, printed for the report (the pre-registration's second prediction); then (unseen rows, reproduced) and (seen rows, reproduced).
#eval (srows.filter (fun r => unseen r && !sreproduced r)).map (fun r => (r.line, r.items, (r.aF, r.aP, r.dF, r.dP), computed r.items))
#eval ((srows.filter unseen).length, (srows.filter (fun r => unseen r && sreproduced r)).length)
#eval ((srows.filter (fun r => !unseen r)).length, (srows.filter (fun r => !unseen r && sreproduced r)).length)

set_option maxRecDepth 200000 in
/-- THE RESULT, as registered and recorded (runs/2026-11-22-dhatukatha-association/RUN.md): the rule reproduces 17 of the 55 unseen, unfitted rows — a FINDING, held here so it
    cannot drift: the rule is too coarse in two ways (a mental item narrower than its kind; consciousness with consciousness), and a revised rule is a NEW run. -/
theorem the_registered_rule_reproduces_17_of_55 :
    ((srows.filter unseen).length, (srows.filter (fun r => unseen r && sreproduced r)).length) = (55, 17) := by decide

end FormalAbhidhamma.Dhatukatha
