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

/-- The dhammas of one block of a partition. -/
def block (f : Atom → Nat) (n : Nat) : List Atom := Atom.all.filter (fun a => f a == n)
def kBlock (n : Nat) : List Atom := Atom.all.filter (fun a => khandha a == some n)

def P5 : List Atom := [.eyeP, .earP, .noseP, .tongueP, .bodyP]
def C7 : List Atom := [.eyeC, .earC, .noseC, .tongueC, .bodyC, .manoD, .manoV]
def O5 : List Atom := [.rupaO, .saddaO, .gandhaO, .rasaO, .photthabbaO]
def allRupa : List Atom := P5 ++ O5 ++ [.subtle]
def mundane : List Atom := Atom.all.filter (· != .nibbana)

/-- The dhammas an item (a slug) stands for. The blocks of the partition (`kh`, `ay`, `dh`) are DEFINITIONAL; every other item is INTERPRETED — what the manual (Saṅgaha chs. 7–9; A68, A74) says the
    item is, in terms of the 22 kinds — and the stated counts test the interpretation. -/
def itemAtoms : String → List Atom
  | "kh0" => kBlock 0 | "kh1" => kBlock 1 | "kh2" => kBlock 2 | "kh3" => kBlock 3 | "kh4" => kBlock 4
  | "ay0" => block ayatana 0 | "ay1" => block ayatana 1 | "ay2" => block ayatana 2 | "ay3" => block ayatana 3 | "ay4" => block ayatana 4 | "ay5" => block ayatana 5
  | "ay6" => block ayatana 6 | "ay7" => block ayatana 7 | "ay8" => block ayatana 8 | "ay9" => block ayatana 9 | "ay10" => block ayatana 10 | "ay11" => block ayatana 11
  | "dh0" => block dhatu 0 | "dh1" => block dhatu 1 | "dh2" => block dhatu 2 | "dh3" => block dhatu 3 | "dh4" => block dhatu 4 | "dh5" => block dhatu 5
  | "dh6" => block dhatu 6 | "dh7" => block dhatu 7 | "dh8" => block dhatu 8 | "dh9" => block dhatu 9 | "dh10" => block dhatu 10 | "dh11" => block dhatu 11
  | "dh12" => block dhatu 12 | "dh13" => block dhatu 13 | "dh14" => block dhatu 14 | "dh15" => block dhatu 15 | "dh16" => block dhatu 16 | "dh17" => block dhatu 17
  -- the four truths: suffering is every mundane dhamma; the origin is craving and the path its factors (both formations); cessation is nibbāna
  | "sacca_dukkha" => mundane | "sacca_samudaya" => [.sankhara] | "sacca_magga" => [.sankhara] | "sacca_nirodha" => [.nibbana] | "sacca4" => Atom.all
  -- the twenty-two faculties
  | "ind0" => [.eyeP] | "ind1" => [.earP] | "ind2" => [.noseP] | "ind3" => [.tongueP] | "ind4" => [.bodyP] | "ind5" => [.subtle] | "ind6" => [.subtle]
  | "ind7" => C7 | "ind8" => [.subtle, .sankhara]
  | "ind9" | "ind10" | "ind11" | "ind12" | "ind13" => [.vedana]
  | "ind14" | "ind15" | "ind16" | "ind17" | "ind18" | "ind19" | "ind20" | "ind21" => [.sankhara]
  | "indriya22" => P5 ++ [.subtle, .vedana, .sankhara] ++ C7
  -- dependent origination
  | "avijja" | "sankhara_link" | "phassa_link" | "phassa" | "tanha" | "upadana" | "kammabhava" => [.sankhara]
  | "vinnana_link" | "citta" => C7
  | "namarupa" => [.vedana, .sanna, .sankhara] ++ allRupa
  | "salayatana" => P5 ++ C7
  | "vedana_link" | "vedana_f" => [.vedana]
  -- the kinds of existence (INTERPRETED: what is present in each, A68)
  | "upapattibhava" | "kamabhava" | "sannabhava" | "pancavokarabhava" => Atom.all.filter (fun a => a != .nibbana && a != .saddaO)
  | "rupabhava" => [.eyeP, .earP, .rupaO, .subtle, .vedana, .sanna, .sankhara, .eyeC, .earC, .manoD, .manoV]
  | "arupabhava" | "nevasannabhava" | "catuvokarabhava" => [.vedana, .sanna, .sankhara, .manoV]
  | "asannabhava" | "ekavokarabhava" => [.rupaO, .subtle]
  | "jati" | "jara" | "marana" => [.subtle, .sankhara]
  | "upayasa" | "satipatthana" | "sammappadhana" | "appamanna" | "indriya5" | "bala5" | "bojjhanga7" | "magga8" | "cetana" | "adhimokkha" | "manasikara" => [.sankhara]
  -- the Dhātukathā-aṭṭhakathā (`abh03a.att.xml:141`): grief, pain and displeasure are the feeling aggregate; LAMENTATION is the form aggregate (it is speech, a sound); distress is a formation
  | "soka" | "dukkha_f" | "domanassa_f" => [.vedana]
  | "parideva" => [.saddaO]
  | "sanna_f" => [.sanna]
  | "iddhipada" => [.sankhara, .manoV]
  | "jhana" => [.vedana, .sankhara]
  | _ => []

/-- The dhammas of a combination of items. -/
def atomsOf (xs : List String) : List Atom := Atom.all.filter (fun a => xs.any (fun i => (itemAtoms i).contains a))

/-- How many aggregates, bases and elements contain a dhamma of the combination. -/
def counts (xs : List String) : Nat × Nat × Nat :=
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

/-- The items whose atom sets were CHOSEN after the stated counts were read (the kinds of existence, the iddhipāda, the jhāna, birth-decay-death): the doctrine fixes them in outline (sound is not
    kamma-born; the immaterial have no matter), but the exact sets were tuned to the text, so reproducing their rows tests the arithmetic and nothing else. Reported APART.
    ✅ The Dhātukathā-aṭṭhakathā was read afterwards (2026-10-20) and ENUMERATES the same sets: the existences of the sense sphere are the *upādinnaka* dhammas, so sound (*anupādinna*) is left out (`abh03a.att.xml:133`); the
    form-sphere existence is the eye, ear, mind, form and dhamma bases and the eight elements (`:137`); the non-percipient existences are form and dhamma only, because the other Brahmas on the same level have eyes and the
    non-percipient body is their object (`:137`); birth, decay and death are 'rūpajāti by the form aggregate, arūpajāti by the formations' (`:141`); the iddhipāda is formations and consciousness, mind and dhamma bases, mind-consciousness and
    dhamma elements, and the jhāna the feeling and formation aggregates (`:145`). So the 15 are TUNED-THEN-CONFIRMED, not independent. -/
def fitted : List String :=
  ["upapattibhava", "kamabhava", "sannabhava", "pancavokarabhava", "rupabhava", "arupabhava", "nevasannabhava", "catuvokarabhava", "asannabhava", "ekavokarabhava", "iddhipada", "jhana", "jati", "jara", "marana"]

def isFitted (r : Row) : Bool := r.items.any (fun i => fitted.contains i)

set_option maxRecDepth 200000 in
/-- THE CHECK, apart from the fitted items: every row whose items the doctrine fixes WITHOUT reference to the counts — the aggregates, bases and elements, the four truths, the twenty-two faculties,
    dependent origination's links and the mental items — is reproduced. -/
theorem every_unfitted_row_is_reproduced : (rows.filter (fun r => !isFitted r)).all reproduced = true := by decide

set_option maxRecDepth 200000 in
theorem the_unfitted_bank_size : (rows.filter (fun r => !isFitted r)).length = 160 := by decide

set_option maxRecDepth 200000 in
/-- THE CHECK: the manual's classification reproduces every one of the Dhātukathā's stated counts (sections 1–6 of its first naya). -/
theorem every_stated_row_is_reproduced : rows.all reproduced = true := by decide

set_option maxRecDepth 200000 in
/-- How many rows were checked (the bank's size). -/
theorem the_bank_size : rows.length = 175 := by decide

end FormalAbhidhamma.Dhatukatha
