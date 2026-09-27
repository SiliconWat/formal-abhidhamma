/-
  Formal Abhidhamma — rung 2, layer L2 (Abhidhammattha-saṅgaha ch. 1–2).
  A citta-type is a point on classification axes. The GENERATOR below builds the 89 (121)
  types from those axes; it never lists a citta by name. Clauses tagged `§G` are counted
  for the compression ratio (PREREGISTRATION.md §1).
-/
import Cetasika
namespace FormalAbhidhamma

inductive Jati | kusala | akusala | vipaka | kiriya deriving DecidableEq, Repr
inductive Bhumi | kama | rupa | arupa | lokuttara deriving DecidableEq, Repr
inductive Vedana | somanassa | upekkha | domanassa | sukha | dukkha deriving DecidableEq, Repr
/-- The root structure: greed, hate, delusion-with-doubt, delusion-with-restlessness, rootless, beautiful. -/
inductive Root | lobha | dosa | mohaDoubt | mohaRestless | none | beautiful deriving DecidableEq, Repr
/-- The element (dhātu): a sense-consciousness at door 1–5 (eye … body), mind element, mind-consciousness element. -/
inductive Dhatu | sense (door : Nat) | mano | manovinnana deriving DecidableEq, Repr

structure Citta where
  jati     : Jati
  bhumi    : Bhumi
  vedana   : Vedana
  root     : Root
  dhatu    : Dhatu := .manovinnana
  ofKusala : Bool := true    -- for resultants: result of wholesome (true) or unwholesome kamma
  knowing  : Bool := false   -- ñāṇasampayutta
  view     : Bool := false   -- diṭṭhigatasampayutta
  prompted : Bool := false   -- sasaṅkhārika
  jhana    : Nat  := 0       -- 0 = not a jhāna-citta; 1–5 on the fivefold scheme; immaterial = 5
  base     : Nat  := 0       -- immaterial base 1–4
  path     : Nat  := 0       -- supramundane path 1–4
  deriving DecidableEq, Repr

def bools : List Bool := [true, false]
def unprompted_first : List Bool := [false, true]
def joyOr (joy : Bool) : Vedana := if joy then .somanassa else .upekkha

-- §G1 greed-rooted: feeling × wrong view × prompting
def lobhaCittas : List Citta :=
  bools.flatMap fun joy => bools.flatMap fun v => unprompted_first.map fun p =>
    { jati := .akusala, bhumi := .kama, vedana := joyOr joy, root := .lobha, view := v, prompted := p }
-- §G2 hate-rooted: displeasure × prompting
def dosaCittas : List Citta :=
  unprompted_first.map fun p => { jati := .akusala, bhumi := .kama, vedana := .domanassa, root := .dosa, prompted := p }
-- §G3 delusion-rooted: accompanied by doubt | by restlessness; equanimity
def mohaCittas : List Citta :=
  [Root.mohaDoubt, .mohaRestless].map fun r => { jati := .akusala, bhumi := .kama, vedana := .upekkha, root := r }
-- §G4 rootless resultants, per kamma-quality: five sense-consciousnesses (touch takes pleasure|pain,
--      the rest equanimity) · receiving (mind element) · investigating (joy only for wholesome kamma)
def senseFeeling (good : Bool) (d : Nat) : Vedana :=
  if d == 5 then (if good then .sukha else .dukkha) else .upekkha
def ahetukaVipaka (good : Bool) : List Citta :=
  ([1, 2, 3, 4, 5].map fun d =>
      { jati := .vipaka, bhumi := .kama, vedana := senseFeeling good d, root := .none, dhatu := .sense d, ofKusala := good })
  ++ [{ jati := .vipaka, bhumi := .kama, vedana := .upekkha, root := .none, dhatu := .mano, ofKusala := good }]
  ++ ((if good then [Vedana.somanassa, .upekkha] else [.upekkha]).map fun v =>
      { jati := .vipaka, bhumi := .kama, vedana := v, root := .none, ofKusala := good })
-- §G5 rootless functionals: five-door adverting (mind element) · mind-door adverting · smile-producing
def ahetukaKiriya : List Citta :=
  [ { jati := .kiriya, bhumi := .kama, vedana := .upekkha,   root := .none, dhatu := .mano },
    { jati := .kiriya, bhumi := .kama, vedana := .upekkha,   root := .none },
    { jati := .kiriya, bhumi := .kama, vedana := .somanassa, root := .none } ]
-- §G6 beautiful sense-sphere: 3 classes × feeling × knowledge × prompting
def kamaSobhana : List Citta :=
  [Jati.kusala, .vipaka, .kiriya].flatMap fun j => bools.flatMap fun joy => bools.flatMap fun k =>
    unprompted_first.map fun p =>
      { jati := j, bhumi := .kama, vedana := joyOr joy, root := .beautiful, knowing := k, prompted := p }
-- §G7 fine-material: 3 classes × 5 jhānas (the fifth with equanimity)
def rupaCittas : List Citta :=
  [Jati.kusala, .vipaka, .kiriya].flatMap fun j => [1, 2, 3, 4, 5].map fun n =>
    { jati := j, bhumi := .rupa, vedana := if n == 5 then .upekkha else .somanassa,
      root := .beautiful, knowing := true, jhana := n }
-- §G8 immaterial: 3 classes × 4 bases, each with fifth-jhāna factors
def arupaCittas : List Citta :=
  [Jati.kusala, .vipaka, .kiriya].flatMap fun j => [1, 2, 3, 4].map fun b =>
    { jati := j, bhumi := .arupa, vedana := .upekkha, root := .beautiful, knowing := true, jhana := 5, base := b }
-- §G9 supramundane: 4 paths × {path, fruit} × jhāna (first only, reckoning 89; all five, reckoning 121)
def lokuttaraCittas (jhanas : List Nat) : List Citta :=
  [1, 2, 3, 4].flatMap fun pa => [Jati.kusala, .vipaka].flatMap fun j => jhanas.map fun n =>
    { jati := j, bhumi := .lokuttara, vedana := if n == 5 then .upekkha else .somanassa,
      root := .beautiful, knowing := true, jhana := n, path := pa }

def mundane : List Citta :=
  lobhaCittas ++ dosaCittas ++ mohaCittas ++ ahetukaVipaka false ++ ahetukaVipaka true ++ ahetukaKiriya
  ++ kamaSobhana ++ rupaCittas ++ arupaCittas

def cittas89  : List Citta := mundane ++ lokuttaraCittas [1]
def cittas121 : List Citta := mundane ++ lokuttaraCittas [1, 2, 3, 4, 5]

end FormalAbhidhamma
