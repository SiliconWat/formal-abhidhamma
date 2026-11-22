/-
  dhatukatha/CheckSampayoga3.lean — run 2026-11-22-dhatukatha-association-3 (PRE-REGISTERED, 02ac634), BLIND: do the Dhātukathā's counting convention (A130, A131) and the
  Dhammasaṅgaṇī's own definitions of ten matrix classes (Classes.lean: composition from its Nikkhepa, consciousness elements from its Cittuppāda) predict the sixth method's
  counts for those classes (SampayogaMatrix.lean, written without being displayed)? The rule is the registered rule, word for word. L1337 was seen (run 1): reported apart.
-/
import SampayogaMatrix
import Classes
namespace FormalAbhidhamma.Dhatukatha

def classOf (s : String) : Option (String × List Nat) := ((classes.find? (·.1 == s)).map (fun c => (c.2.1, c.2.2)))

/-- THE RULE, by composition (as registered). -/
def rule3 : String × List Nat → (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat)
  | ("feelingAside", E)   => ((1, 0, 0), (0, 1, 1), (1, 10, 17 - E.length), (0, 1, 1))
  | ("formationAside", E) => ((0, 0, 0), (1, 1, 1), (1, 10, 17 - E.length), (0, 1, 1))
  | ("allFour", E)        => ((0, 0, 0), (0, 0, 0), (1, 10, 17 - E.length), (0, 1, 1))
  | _                     => ((0, 0, 0), (0, 0, 0), (4, 1, 7), (0, 1, 1))

def computed3 (r : SRow) := match r.items with | [i] => (classOf i).map rule3 | _ => none
def reproduced3 (r : SRow) : Bool := computed3 r == some (r.aF, r.aP, r.dF, r.dP)
def blind (r : SRow) : Bool := r.line != 1337

-- The misses (if any), then (blind rows, reproduced) and (seen rows, reproduced).
#eval (mrows.filter (fun r => !reproduced3 r)).map (fun r => (r.line, r.items, (r.aF, r.aP, r.dF, r.dP), computed3 r))
#eval ((mrows.filter blind).length, (mrows.filter (fun r => blind r && reproduced3 r)).length)
#eval ((mrows.filter (fun r => !blind r)).length, (mrows.filter (fun r => !blind r && reproduced3 r)).length)

set_option maxRecDepth 200000 in
/-- THE RESULT (runs/2026-11-22-dhatukatha-association-3/RUN.md): BLIND — all eight unseen rows predicted from the Dhammasaṅgaṇī's definitions and lists under the
    commentary's convention; the two seen rows (L1337) too. -/
theorem every_blind_row_is_predicted : ((mrows.filter blind).all reproduced3, (mrows.filter blind).length) = (true, 8) := by decide

set_option maxRecDepth 200000 in
theorem the_seen_rows_too : (mrows.filter (fun r => !blind r)).all reproduced3 = true := by decide

end FormalAbhidhamma.Dhatukatha
