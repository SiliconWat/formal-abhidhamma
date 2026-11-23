/-
  dhatukatha/CheckSampayoga4.lean — run 2026-11-22-dhatukatha-association-4 (PRE-REGISTERED, 5e11514): does run 3's rule, word for word, reproduce the sixth method's
  matrix counts for EVERY class a stated criterion admits (Classes4.lean, read by classes4.py from the Nikkhepa's own definitions), not only the ten run 3 chose?
  BLIND: L1361 in full, L1393 in full, L1349 as to its bases and elements (its opening was displayed in error — PREREG.md). SEEN, reported apart: L1333 (run 1),
  L1365 (run 3's rapture row), L1381 (run 3's mahaggatā row). SampayogaMatrix4.lean was written without being displayed.
-/
import SampayogaMatrix4
import Classes4
namespace FormalAbhidhamma.Dhatukatha

def classOf4 (s : String) : Option (String × List Nat) := ((classes4.find? (·.1 == s)).map (fun c => (c.2.1, c.2.2)))

/-- THE RULE — run 3's (`CheckSampayoga3.lean` `rule3`, registered 02ac634), copied word for word. -/
def rule4 : String × List Nat → (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat)
  | ("feelingAside", E)   => ((1, 0, 0), (0, 1, 1), (1, 10, 17 - E.length), (0, 1, 1))
  | ("formationAside", E) => ((0, 0, 0), (1, 1, 1), (1, 10, 17 - E.length), (0, 1, 1))
  | ("allFour", E)        => ((0, 0, 0), (0, 0, 0), (1, 10, 17 - E.length), (0, 1, 1))
  | _                     => ((0, 0, 0), (0, 0, 0), (4, 1, 7), (0, 1, 1))

def computed4 (r : SRow) := match r.items with | [i] => (classOf4 i).map rule4 | _ => none
def reproduced4 (r : SRow) : Bool := computed4 r == some (r.aF, r.aP, r.dF, r.dP)
/-- the blind lines, as registered -/
def blind4 (r : SRow) : Bool := r.line == 1361 || r.line == 1393 || r.line == 1349

-- The misses (if any), then (blind class-rows, reproduced) and (seen class-rows, reproduced).
#eval (mrows4.filter (fun r => !reproduced4 r)).map (fun r => (r.line, r.items, (r.aF, r.aP, r.dF, r.dP), computed4 r))
#eval ((mrows4.filter blind4).length, (mrows4.filter (fun r => blind4 r && reproduced4 r)).length)
#eval ((mrows4.filter (fun r => !blind4 r)).length, (mrows4.filter (fun r => !blind4 r && reproduced4 r)).length)

set_option maxRecDepth 200000 in
/-- THE RESULT (runs/2026-11-22-dhatukatha-association-4/RUN.md): all five blind class-rows reproduced — savitakkasavicārā (L1361, the one tuple no seen row
    has), hīnā and sammattaniyatā (L1393), vipākadhammadhammā and saṃkiliṭṭhasaṃkilesikā (L1349, as to bases and elements). -/
theorem every_blind_row_is_predicted4 : ((mrows4.filter blind4).all reproduced4, (mrows4.filter blind4).length) = (true, 5) := by decide

set_option maxRecDepth 200000 in
/-- The eleven seen class-rows (L1333, L1365, L1381) too — reported apart; they do not carry the verdict. -/
theorem the_seen_rows_too4 : ((mrows4.filter (fun r => !blind4 r)).all reproduced4, (mrows4.filter (fun r => !blind4 r)).length) = (true, 11) := by decide

set_option maxRecDepth 200000 in
/-- Every class the criterion admits has its row (16 = 16): none was dropped between the scope and the data. -/
theorem every_admitted_class_has_its_row : (mrows4.length, classes4.length) = (16, 16) := by decide

end FormalAbhidhamma.Dhatukatha
