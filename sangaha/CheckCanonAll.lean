/-
  sangaha/CheckCanonAll.lean — run 2026-11-22-cittuppada-against-the-manual (PRE-REGISTERED, ea0376d): the Saṅgaha's association table (Rules.lean, A32) against
  the Dhammasaṅgaṇī's 23 fully written lists (CanonAll.lean). P1: listed ⊆ Saṅgaha. P2: the Saṅgaha exceeds a list only where the list is open ('ye vā pana').
  CONTROL: the first wholesome class gives Canon.lean's 29 + 9.
-/
import CanonAll
namespace FormalAbhidhamma
open Cetasika

def sangahaSet (c : Citta) : List Cetasika := all.filter (arises c)
def extras (r : CanonRow) : List Cetasika := (sangahaSet r.citta).filter (fun x => !r.listed.contains x)
def p1 (r : CanonRow) : Bool := r.listed.all (arises r.citta)
def p2 (r : CanonRow) : Bool := (extras r).isEmpty || r.openClause

-- P1 misses (a factor listed that the rules deny), P2 misses, and every list's extras — printed for the report.
#eval (canonRows.filter (fun r => !p1 r)).map (fun r => (r.line, r.listed.filter (fun x => !arises r.citta x)))
#eval (canonRows.filter (fun r => !p2 r)).map (fun r => (r.line, extras r))
#eval canonRows.map (fun r => (r.line, r.listed.length, (sangahaSet r.citta).length, extras r))

/-- P1 (runs/2026-11-22-cittuppada-against-the-manual/RUN.md): in all 23 fully written lists, every factor the Dhammasaṅgaṇī lists, the Saṅgaha's rules give. -/
theorem every_listed_factor_is_the_manuals : (canonRows.all p1, canonRows.length) = (true, 23) := by decide
/-- P2: the Saṅgaha exceeds a written list only where the list itself is open (ye vā pana … aññepi atthi). -/
theorem the_manual_adds_only_where_the_list_is_open : canonRows.all p2 = true := by decide
/-- CONTROL (Canon.lean's known answer): the first wholesome class — 29 listed, 38 in the Saṅgaha. -/
theorem the_control : (canonRows.find? (·.line == 1569)).map (fun r => (r.listed.length, (sangahaSet r.citta).length)) = some (29, 38) := by decide

-- Added after run 4's refuter (runs/2026-11-22-cittuppada-against-the-manual/REFUTER-2026-11-22.md): what the run claimed and no theorem proved.
/-- No listed term went unmapped (the run's "none unmapped" rested on the generator's printout). -/
theorem no_term_unmapped : canonRows.all (·.unmapped == 0) = true := by decide
/-- Every record the declared rules built is one of the 121 citta types (a wrong rule — eye-consciousness with pleasure, say — would otherwise pass silently). -/
theorem every_record_is_a_citta : canonRows.all (fun r => cittas121.contains r.citta) = true := by decide
/-- The control as REGISTERED: the first class's extras are EXACTLY the nine yevāpanaka, as sets (the_control compared lengths only). -/
theorem the_control_is_the_nine :
    (canonRows.find? (·.line == 1569)).map (fun r => let e := extras r; e.length == 9 &&
      [chanda, adhimokkha, manasikara, tatramajjhattata, karuna, mudita, sammavaca, sammakammanta, sammaajiva].all e.contains) = some true := by decide

end FormalAbhidhamma
