/-
  The cetasika rules — GENERAL constraints over the axes of `Citta`. No rule names an
  individual citta-type. Clauses tagged `§R` are counted for the compression ratio.
  Tier: Abhidhammattha-saṅgaha ch. 2 (sampayoga), as the rules are stated there.
-/
import Citta
namespace FormalAbhidhamma
open Cetasika

def isSense (c : Citta) : Bool := match c.dhatu with | .sense _ => true | _ => false

def arises (c : Citta) (x : Cetasika) : Bool :=
  if universals.contains x then true                                                    -- §R1 the seven universals: every citta
  else if x == vitakka then !isSense c && c.jhana ≤ 1                                   -- §R2 not in sense-consciousness; gone from the 2nd jhāna
  else if x == vicara then !isSense c && c.jhana ≤ 2                                    -- §R3 not in sense-consciousness; gone from the 3rd jhāna
  else if x == adhimokkha then !isSense c && c.root != .mohaDoubt                       -- §R4 not in sense-consciousness; not with doubt
  else if x == viriya then c.root != .none || (c.jati == .kiriya && c.dhatu == .manovinnana) -- §R5 rootless: only in functional mind-consciousness
  else if x == piti then c.vedana == .somanassa && c.jhana ≤ 3                          -- §R6 only with joy; gone from the 4th jhāna
  else if x == chanda then c.root == .lobha || c.root == .dosa || c.root == .beautiful  -- §R7 needs a root other than delusion alone
  else if [moha, ahirika, anottappa, uddhacca].contains x then c.jati == .akusala       -- §R8 unwholesome universals
  else if x == lobha then c.root == .lobha                                              -- §R9 greed
  else if x == ditthi then c.root == .lobha && c.view                                   -- §R10 view: greed-rooted, view-associated
  else if x == mana then c.root == .lobha && !c.view                                    -- §R11 conceit: greed-rooted, view-dissociated
  else if [dosa, issa, macchariya, kukkucca].contains x then c.root == .dosa            -- §R12 the hate quartet
  else if x == thina || x == middha then c.jati == .akusala && c.prompted               -- §R13 sloth and torpor: prompted unwholesome
  else if x == vicikiccha then c.root == .mohaDoubt                                     -- §R14 doubt
  else if beautifulUniversals.contains x then c.root == .beautiful                      -- §R15 beautiful universals
  else if abstinences.contains x then c.root == .beautiful &&                           -- §R16 abstinences: sense-sphere wholesome, supramundane
    (c.bhumi == .lokuttara || (c.bhumi == .kama && c.jati == .kusala))
  else if illimitables.contains x then c.root == .beautiful &&                          -- §R17 illimitables: sense-sphere non-resultant, fine-material to the 4th jhāna
    ((c.bhumi == .kama && c.jati != .vipaka) || (c.bhumi == .rupa && c.jhana ≤ 4))
  else c.root == .beautiful && c.knowing                                                -- §R18 wisdom: knowledge-associated

/-- The number of roots (hetu) a citta has: greed or hate brings delusion with it; delusion alone is one;
    the beautiful have non-greed and non-hate, and non-delusion when knowledge-associated. -/
def hetus (c : Citta) : Nat :=
  match c.root with
  | .lobha | .dosa => 2 | .mohaDoubt | .mohaRestless => 1 | .none => 0
  | .beautiful => if c.knowing then 3 else 2

/-- The MINORITY reading the text records at ch. 2 §30 — "upekkhāsahagatesu panettha karuṇāmuditā na
    santīti keci vadanti" (some say compassion and appreciative joy are absent with equanimity).
    Not used by `arises`; kept to count what the dissent would cost in the text's own figures (20 against the
    stated 28). The figures encode the main reading; they do not decide the dissent (corrected 2026-09-28). -/
def illimitablesKeci (c : Citta) : Bool :=
  c.root == .beautiful && c.vedana != .upekkha &&
    ((c.bhumi == .kama && c.jati != .vipaka) || (c.bhumi == .rupa && c.jhana ≤ 4))

def count (c : Citta) : Nat := (FormalAbhidhamma.all.filter (arises c)).length
def occurrences (cs : List Citta) (x : Cetasika) : Nat := (cs.filter fun c => arises c x).length

end FormalAbhidhamma
