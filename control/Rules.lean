/-
  The eight wholesome sense-sphere cittas (kāmāvacara kusala) — the CONTROL (C1).
  Each citta is a point on three binary axes; its cetasikas are fixed by GENERAL rules
  that never name an individual citta. Counts are the maximum reckoning (abstinences and
  illimitables included, as the Saṅgaha's tables do).
-/
import Cetasika
namespace FormalAbhidhamma
open Cetasika

structure KamaKusala where
  joyful   : Bool   -- somanassa (true) / upekkhā (false)
  knowing  : Bool   -- ñāṇasampayutta / ñāṇavippayutta
  prompted : Bool   -- sasaṅkhārika / asaṅkhārika
  deriving DecidableEq, Repr

/-- The citta-types: every combination of the three axes. -/
def cittas : List KamaKusala :=
  [true, false].flatMap fun j => [true, false].flatMap fun k =>
    [false, true].map fun p => ⟨j, k, p⟩

/-- GENERAL RULES (rule clauses counted for the compression ratio: 6). -/
def arises (c : KamaKusala) (x : Cetasika) : Bool :=
  if universals.contains x then true                               -- R1 universals: always
  else if x == piti then c.joyful                                  -- R2 pīti only with joyful feeling
  else if occasionals.contains x then true                         -- R3 other occasionals: in wholesome sense-sphere
  else if unwholesome.contains x then false                        -- R4 wholesome excludes unwholesome
  else if x == panna then c.knowing                                -- R5 wisdom only when knowledge-associated
  else true                                                        -- R6 beautiful (incl. virati, appamaññā at maximum)

def count (c : KamaKusala) : Nat := (all.filter (arises c)).length

/-- C1a: eight citta-types. -/
theorem eight : cittas.length = 8 := by decide

/-- C1b: the Saṅgaha's 38 · 37 · 37 · 36 by pair; prompting changes nothing. -/
theorem profile : cittas.map count = [38, 38, 37, 37, 37, 37, 36, 36] := by decide

end FormalAbhidhamma
