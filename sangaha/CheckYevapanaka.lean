/-
  sangaha/CheckYevapanaka.lean — run 2026-11-22-yevapanaka-against-the-manual (PRE-REGISTERED, 28c5eb3; a CHECK — its answer was displayed before registration):
  what the Saṅgaha's rules (Rules.lean, A32) ADD to each of the Dhammasaṅgaṇī's 23 fully written lists (CanonAll.lean) against the Atthasālinī's own yevāpanaka for
  that class (Yevapanaka.lean, every quote checked at its CST line by canon/yevapanaka.py). P1: the added = the yevāpanaka, as sets. P2: as the Mūlaṭīkā reads :7217,
  the commentary's VARIABLE yevāpanaka = the added factors the Saṅgaha calls occasional (§33). P3: on its surface, :7217 differs only in the two greed-without-view
  classes, only on conceit.
-/
import CanonAll
import Yevapanaka
namespace FormalAbhidhamma
open Cetasika

/-- copied from CheckCanonAll.lean (run cittuppada-against-the-manual): what the Saṅgaha gives a class, and what it adds to the written list -/
def sangahaSet (c : Citta) : List Cetasika := all.filter (arises c)
def extras (r : CanonRow) : List Cetasika := (sangahaSet r.citta).filter (fun x => !r.listed.contains x)

def setEq (a b : List Cetasika) : Bool := a.all b.contains && b.all a.contains
def yevOf (line : Nat) : Option YevRow := yevRows.find? (·.line == line)
def addedOccasional (r : CanonRow) : List Cetasika := (extras r).filter occasionalSangaha.contains

def p1 (r : CanonRow) : Bool := match yevOf r.line with | some y => setEq (extras r) y.yev | none => false
def p2 (r : CanonRow) : Bool := match yevOf r.line with | some y => setEq y.varTika (addedOccasional r) | none => false
def surfaceAgrees (r : CanonRow) : Bool := match yevOf r.line with | some y => setEq y.varSurface (addedOccasional r) | none => false

-- P1 misses (line, added, the commentary's), P2 misses, the rows where the SURFACE reading of :7217 differs, and the kinds tallied.
#eval (canonRows.filter (fun r => !p1 r)).map (fun r => (r.line, extras r, (yevOf r.line).map (·.yev)))
#eval (canonRows.filter (fun r => !p2 r)).map (fun r => (r.line, addedOccasional r, (yevOf r.line).map (·.varTika)))
#eval (canonRows.filter (fun r => !surfaceAgrees r)).map (fun r => (r.line, addedOccasional r, (yevOf r.line).map (·.varSurface)))
#eval ["named", "subtraction", "reference", "implicit"].map (fun k => (k, (canonRows.filter (fun r => p1 r && (yevOf r.line).map (·.kind) == some k)).length))

/-- P1 (runs/2026-11-22-yevapanaka-against-the-manual/RUN.md): in all 23 written lists, what the Saṅgaha adds is EXACTLY the Atthasālinī's yevāpanaka, as sets. -/
theorem the_added_are_the_yevapanaka : (canonRows.all p1, canonRows.length) = (true, 23) := by decide
/-- …tallied by how the commentary gives them: named 8 · by subtraction 1 · by reference 13 · implicit 1. -/
theorem by_kind : ["named", "subtraction", "reference", "implicit"].map (fun k => (canonRows.filter (fun r => p1 r && (yevOf r.line).map (·.kind) == some k)).length)
    = [8, 1, 13, 1] := by decide
/-- P2: as the Mūlaṭīkā reads :7217, the commentary's VARIABLE yevāpanaka are exactly the added factors the Saṅgaha (§33) calls occasional, in all 23. -/
theorem the_variable_are_the_occasional : canonRows.all p2 = true := by decide
/-- P3: on its surface, :7217 differs from §33 in exactly the two greed-without-view classes, and only on conceit. -/
theorem the_surface_differs_on_conceit_only :
    (canonRows.filter (fun r => !surfaceAgrees r)).map (fun r => (r.line, addedOccasional r)) = [(3617, [mana]), (3665, [mana])] := by decide

end FormalAbhidhamma
