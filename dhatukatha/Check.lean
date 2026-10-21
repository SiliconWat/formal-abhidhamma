/-
  dhatukatha/Check.lean — does the manual's classification (Saṅgaha ch. 7: which dhammas are in which aggregate, base and element) REPRODUCE the Dhātukathā's stated counts?
  The counts (Dhatukatha.lean, GENERATED from the CST) are the TEST BANK and never premises: nothing below reads a count. The classification is the AXIOMS-level input
  (A62, A74: the 28 kinds' dyads and the 12 bases and 18 elements), typed here as a partition of twenty-two kinds of dhamma ("atoms").
  A stated row says: the combination X is included in k aggregates, a bases and d elements — read here as "k aggregates, a bases and d elements contain a dhamma of X"; and not
  in the rest. Nibbāna belongs to no aggregate (the text says so: *asaṅkhataṃ khandhato ṭhapetvā*).
-/
import Dhatukatha
namespace FormalAbhidhamma.Dhatukatha

/-- Twenty-two kinds of dhamma, fine enough to tell every aggregate, base and element apart: the five sensitive organs, the five sense-objects, the other (subtle) matter, feeling,
    perception, the other mental formations, the five sense-consciousnesses, the mind-element (receiving, investigating, adverting), mind-consciousness (the rest), and nibbāna. -/
inductive Atom
  | eyeP | earP | noseP | tongueP | bodyP | rupaO | saddaO | gandhaO | rasaO | photthabbaO | subtle
  | vedana | sanna | sankhara
  | eyeC | earC | noseC | tongueC | bodyC | manoD | manoV
  | nibbana
  deriving DecidableEq, Repr

def Atom.all : List Atom :=
  [.eyeP, .earP, .noseP, .tongueP, .bodyP, .rupaO, .saddaO, .gandhaO, .rasaO, .photthabbaO, .subtle, .vedana, .sanna, .sankhara,
   .eyeC, .earC, .noseC, .tongueC, .bodyC, .manoD, .manoV, .nibbana]

/-- The five aggregates (rūpa 0, vedanā 1, saññā 2, saṅkhāra 3, viññāṇa 4); nibbāna is in none. -/
def khandha : Atom → Option Nat
  | .vedana => some 1 | .sanna => some 2 | .sankhara => some 3
  | .eyeC | .earC | .noseC | .tongueC | .bodyC | .manoD | .manoV => some 4
  | .nibbana => none
  | _ => some 0

/-- The twelve bases (cakkhu 0 … phoṭṭhabba 9, mana 10, dhamma 11). -/
def ayatana : Atom → Nat
  | .eyeP => 0 | .earP => 1 | .noseP => 2 | .tongueP => 3 | .bodyP => 4
  | .rupaO => 5 | .saddaO => 6 | .gandhaO => 7 | .rasaO => 8 | .photthabbaO => 9
  | .eyeC | .earC | .noseC | .tongueC | .bodyC | .manoD | .manoV => 10
  | .subtle | .vedana | .sanna | .sankhara | .nibbana => 11

/-- The eighteen elements (the ten of the organs and objects, the five sense-consciousnesses 10–14, the mind-element 15, the mind-consciousness element 16, the dhamma-element 17). -/
def dhatu : Atom → Nat
  | .eyeP => 0 | .earP => 1 | .noseP => 2 | .tongueP => 3 | .bodyP => 4
  | .rupaO => 5 | .saddaO => 6 | .gandhaO => 7 | .rasaO => 8 | .photthabbaO => 9
  | .eyeC => 10 | .earC => 11 | .noseC => 12 | .tongueC => 13 | .bodyC => 14 | .manoD => 15 | .manoV => 16
  | .subtle | .vedana | .sanna | .sankhara | .nibbana => 17

/-- The dhammas an item stands for. -/
def Item.atoms : Item → List Atom
  | .kh n => Atom.all.filter (fun a => khandha a == some n)
  | .ay n => Atom.all.filter (fun a => ayatana a == n)
  | .dh n => Atom.all.filter (fun a => dhatu a == n)

/-- The dhammas of a combination of items. -/
def atomsOf (xs : List Item) : List Atom := Atom.all.filter (fun a => xs.any (fun i => i.atoms.contains a))

/-- How many aggregates, bases and elements contain a dhamma of the combination. -/
def counts (xs : List Item) : Nat × Nat × Nat :=
  let u := atomsOf xs
  (((List.range 5).filter (fun j => u.any (fun a => khandha a == some j))).length,
   ((List.range 12).filter (fun j => u.any (fun a => ayatana a == j))).length,
   ((List.range 18).filter (fun j => u.any (fun a => dhatu a == j))).length)

/-- A stated row is reproduced: the computed counts are the stated ones, and the rest are the others. -/
def reproduced (r : Row) : Bool :=
  let c := counts r.items
  c == r.inc && (5 - c.1, 12 - c.2.1, 18 - c.2.2) == r.exc

/-- The classification is a partition of the dhammas into the right numbers of aggregates (5), bases (12) and elements (18). -/
theorem the_numbers : (List.range 5).all (fun j => Atom.all.any (fun a => khandha a == some j)) = true ∧
    (List.range 12).all (fun j => Atom.all.any (fun a => ayatana a == j)) = true ∧
    (List.range 18).all (fun j => Atom.all.any (fun a => dhatu a == j)) = true := by decide

/-- THE CHECK: the manual's classification reproduces every one of the Dhātukathā's stated counts (sections 1–3 of its first naya). -/
theorem every_stated_row_is_reproduced : rows.all reproduced = true := by decide

/-- How many rows were checked (the bank's size). -/
theorem the_bank_size : rows.length = 76 := by decide

end FormalAbhidhamma.Dhatukatha
