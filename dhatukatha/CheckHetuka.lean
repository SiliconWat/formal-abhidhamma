/-
  dhatukatha/CheckHetuka.lean — known-answer control 2026-11-22-dhatukatha-hetuka-by-kind-control (PRE-REGISTERED, dba8e4c; agree direction): A132(d)'s "contains"
  read BY KIND reproduces the Dhātukathā's row for the two -hetukā classes (L1381), and read BY OCCURRENCE misses it. A check of a FIT (L1381 was known when the
  reading was chosen): its information is in the by-occurrence arm failing — the instrument tells the two readings apart.
-/
import SampayogaMatrix4
import Hetuka
namespace FormalAbhidhamma.Dhatukatha

/-- run 3's rule (`CheckSampayoga3.lean` `rule3`, registered 02ac634), copied word for word. -/
def ruleH : String × List Nat → (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat) × (Nat × Nat × Nat)
  | ("feelingAside", E)   => ((1, 0, 0), (0, 1, 1), (1, 10, 17 - E.length), (0, 1, 1))
  | ("formationAside", E) => ((0, 0, 0), (1, 1, 1), (1, 10, 17 - E.length), (0, 1, 1))
  | ("allFour", E)        => ((0, 0, 0), (0, 0, 0), (1, 10, 17 - E.length), (0, 1, 1))
  | _                     => ((0, 0, 0), (0, 0, 0), (4, 1, 7), (0, 1, 1))

/-- the stated row of a class, on L1381 -/
def statedH (slug : String) := (mrows4.find? (fun r => r.items == [slug] && r.line == 1381)).map (fun r => (r.aF, r.aP, r.dF, r.dP))
def reproducesUnder (reading : List (String × String × List Nat)) (slug : String) : Bool :=
  match reading.find? (·.1 == slug) with | some c => statedH slug == some (ruleH (c.2.1, c.2.2)) | none => false

def hetuka : List String := ["dassanena_pahatabbahetuka", "bhavanaya_pahatabbahetuka"]

#eval hetuka.map (fun s => (s, statedH s, reproducesUnder hetukaByKind s, reproducesUnder hetukaByOccurrence s))

/-- P1: BY KIND, both -hetukā classes reproduce L1381 exactly. -/
theorem by_kind_reproduces_L1381 : hetuka.all (reproducesUnder hetukaByKind) = true := by decide
/-- P2: BY OCCURRENCE, both MISS it (the rule gives partly associated where the text says Natthi) — the instrument tells the readings apart. -/
theorem by_occurrence_misses_L1381 : hetuka.all (fun s => !reproducesUnder hetukaByOccurrence s) = true := by decide
/-- …and only on association: the other three tuples agree under both readings. -/
theorem the_miss_is_association_only :
    hetuka.all (fun s => match statedH s with
      | some (aF, _, dF, dP) => (aF, dF, dP) == (let t := ruleH ("formationAside", [6]); (t.1, t.2.2.1, t.2.2.2)) | none => false) = true := by decide

end FormalAbhidhamma.Dhatukatha
