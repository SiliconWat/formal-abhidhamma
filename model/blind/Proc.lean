import Tax

namespace FormalAbhidhamma.Model

open FormalAbhidhamma

inductive Door | eye | ear | nose | tongue | body | mind deriving DecidableEq, Repr

def Door.senseKicca : Door → List Kicca
  | .eye => [.dassana] | .ear => [.savana] | .nose => [.ghayana] | .tongue => [.sayana] | .body => [.phusana]
  | .mind => []

inductive When | present | past | future | timeless deriving DecidableEq, Repr

inductive Sign | kamma | kammaNimitta | gatiNimitta deriving DecidableEq, Repr

inductive Desir | anittha | ittha | atiittha deriving DecidableEq, Repr

inductive MObj | rupa (r : Rupa) | citta | cetasika (x : Cetasika) | nibbana | pannatti deriving DecidableEq, Repr

inductive Person | worldling | noble | arahant deriving DecidableEq, Repr

inductive PKind | fiveDoor | mindDoor | absorption | path deriving DecidableEq, Repr

structure Step where
  citta : Citta
  kicca : Kicca
  door : Option Door := none
  obj : Obj := .kamaOther
  when : When := .present
  abhinna : Bool := false
  sign : Option Sign := none
  objBase : Nat := 0
  deriving DecidableEq, Repr

structure Process where
  kind : PKind
  door : Door
  past : Nat := 0
  clear : Bool := true
  nearDeath : Bool := false
  first : Bool := false
  plane : Bhumi := .kama
  person : Person := .worldling
  desirable : Desir := .ittha
  steps : List Step

structure Meeting where
  door : Door
  intact : Bool
  inRange : Bool
  attended : Bool
  follows : List Step

structure Proc where
  procs : List Process
  
  organ : Door → Option Rupa
  
  mindObject : List MObj
  meetings : List Meeting

def Process.kiccas (p : Process) : List Kicca := p.steps.map (·.kicca)

def Process.count (p : Process) (k : Kicca) : Nat := (p.steps.filter (·.kicca == k)).length

def Process.javanas (p : Process) : List Step := p.steps.filter (·.kicca == .javana)

def stepKama (s : Step) : Bool := s.citta.bhumi == .kama

def stepPath (s : Step) : Bool := s.citta.bhumi == .lokuttara && s.citta.jati == .kusala

def stepFruit (s : Step) : Bool := s.citta.bhumi == .lokuttara && s.citta.jati == .vipaka

def fiveDoorHead (d : Door) : List Kicca := [.avajjana] ++ d.senseKicca ++ [.sampaticchana, .santirana, .votthabbana]

def veryGreatOrder (d : Door) (ks : List Kicca) : Bool :=
  let h := fiveDoorHead d
  let rest := ks.drop h.length
  let tail := rest.dropWhile (· == .javana)
  ks.take h.length == h && rest.takeWhile (· == .javana) != [] && (tail == [] || tail == [.tadarammana, .tadarammana])

def mindDoorOrder (ks : List Kicca) : Bool :=
  let a := ks.dropWhile (· == .bhavanga)
  let b := a.drop 1
  ks.takeWhile (· == .bhavanga) != [] && a.head? == some .avajjana && b.takeWhile (· == .javana) != [] &&
    (b.dropWhile (· == .javana)).all (· == .tadarammana)

def absorbsAfter (js : List Step) (m : Nat) : Bool :=
  (js.take m).all stepKama && m < js.length && (js.drop m).all (!stepKama ·)

def afterPath (p : Process) : List Step := (p.steps.dropWhile (!stepPath ·)).drop 1

def a35_station_fits (t : Tax) (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, t.kicca (reckon89 s.citta) s.kicca = true

def a36_organs (w : Proc) : Prop :=
  w.organ .eye = some .cakkhu ∧ w.organ .ear = some .sota ∧ w.organ .nose = some .ghana ∧
  w.organ .tongue = some .jivha ∧ w.organ .body = some .kaya

def a36_mind_door_no_organ (w : Proc) : Prop := w.organ .mind = none

def a36_mind_door_is_bhavanga (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind ≠ .fiveDoor → p.kiccas.head? = some .bhavanga

def a36_door_free (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, (s.door = none ↔ s.kicca ∈ [Kicca.patisandhi, .bhavanga, .cuti])

def a36_nineteen (t : Tax) : Prop :=
  num t.kinds89 (fun c => t.kicca c .patisandhi || t.kicca c .bhavanga || t.kicca c .cuti) = 19

def a37_sense_door_present (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, s.door ≠ none → s.door ≠ some .mind → s.when = .present

def a37_mind_object (t : Tax) (w : Proc) : Prop :=
  (pasada.all fun r => w.mindObject.contains (.rupa r)) = true ∧
  ((t.rupas.filter (!t.gross ·)).all fun r => w.mindObject.contains (.rupa r)) = true ∧
  w.mindObject.contains .citta = true ∧ (t.cets.all fun x => w.mindObject.contains (.cetasika x)) = true ∧
  w.mindObject.contains .nibbana = true ∧ w.mindObject.contains .pannatti = true

def a38_in_scope (t : Tax) (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, t.scope (reckon89 s.citta) s.abhinna s.obj = true

def a41_entry (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .fiveDoor → 1 ≤ p.past

def a41_two_vibrations (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → p.kiccas.take 3 = [.bhavanga, .bhavanga, .avajjana]

def a41_order (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → veryGreatOrder p.door (p.kiccas.drop 2) = true

def a41_seventeen (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → p.past + p.steps.length ≤ 17

def a42_very_great (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → 1 ≤ p.count .javana

def a42_great (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → 2 ≤ p.past → p.past ≤ 3 → p.count .tadarammana = 0

def a42_slight (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → 4 ≤ p.past → p.past ≤ 9 →
    p.count .javana = 0 ∧ (p.count .votthabbana = 2 ∨ p.count .votthabbana = 3)

def a42_very_slight (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → 10 ≤ p.past → p.past ≤ 15 → (p.kiccas.all (· == .bhavanga)) = true

def a43_clear (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .mindDoor → p.clear = true → p.plane = .kama →
    (∀ s ∈ p.javanas, stepKama s = true ∧ s.obj.kama = true) → 1 ≤ p.count .tadarammana

def a43_obscure (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .mindDoor → p.clear = false → p.count .tadarammana = 0

def a43_order (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .mindDoor → mindDoorOrder p.kiccas = true

def a43_absorption (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .absorption ∨ p.kind = .path) → (absorbsAfter p.javanas 3 || absorbsAfter p.javanas 4) = true

def a43_absorption_no_registration (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .absorption ∨ p.kind = .path) → p.count .tadarammana = 0

def a44_seven_or_six (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .fiveDoor ∨ p.kind = .mindDoor) → p.nearDeath = false →
    (p.count .javana = 0 ∨ p.count .javana = 6 ∨ p.count .javana = 7)

def a44_five_at_death (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .fiveDoor ∨ p.kind = .mindDoor) → p.nearDeath = true →
    (p.count .javana = 0 ∨ p.count .javana = 5)

def a44_first_once (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .absorption → p.first = true → (p.javanas.filter (!stepKama ·)).length = 1

def a44_abhinna_once (w : Proc) : Prop := ∀ p ∈ w.procs, (p.steps.filter (·.abhinna)).length ≤ 1

def a44_path_one_moment (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .path → (p.steps.filter stepPath).length = 1

def a44_fruition (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path →
    ((afterPath p).length = 2 ∨ (afterPath p).length = 3) ∧ ((afterPath p).all stepFruit) = true

def a45_desirability (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps,
    s.kicca ∈ [Kicca.dassana, .savana, .ghayana, .sayana, .phusana, .sampaticchana, .santirana, .tadarammana] →
      s.citta.ofKusala = (p.desirable != .anittha)

def a45_sense_beings (w : Proc) : Prop := ∀ p ∈ w.procs, 1 ≤ p.count .tadarammana → p.plane = .kama

def a45_sense_objects (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, s.kicca = .tadarammana → s.obj.kama = true

def a45_sense_javana (w : Proc) : Prop :=
  ∀ p ∈ w.procs, 1 ≤ p.count .tadarammana → (p.javanas.all stepKama) = true

def a45_clear_or_very_great (w : Proc) : Prop :=
  ∀ p ∈ w.procs, 1 ≤ p.count .tadarammana →
    (p.kind = .fiveDoor ∧ p.past = 1) ∨ (p.kind = .mindDoor ∧ p.clear = true)

def a57_five_at_death (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.nearDeath = true → (p.count .javana = 0 ∨ p.count .javana = 5)

def a57_kamma_past (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, s.sign = some .kamma → s.when = .past

def arupaAttainment (s : Step) (b : Nat) : Bool :=
  s.kicca == .javana && s.citta.bhumi == .arupa && s.citta.jati != .vipaka && s.citta.base == b

def a106_first (w : Proc) : Prop := ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 1 = true → s.obj = .pannatti

def a106_second (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 2 = true → s.obj = .mahaggata ∧ s.objBase = 1

def a106_third (w : Proc) : Prop := ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 3 = true → s.obj = .pannatti

def a106_fourth (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 4 = true → s.obj = .mahaggata ∧ s.objBase = 3

def a109_insight (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path →
    ([2, 3].any fun i => (p.javanas.take (i + 1)).all stepKama && ((p.javanas.drop (i + 1)).head?.map stepPath == some true)) = true

def a109_change_of_lineage (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path → ((p.steps.takeWhile (!stepPath ·)).getLast?.map (·.obj)) = some .nibbana

def a109_path_once (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .path → (p.steps.filter stepPath).length = 1

def a109_fruition (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path →
    ((afterPath p).length = 2 ∨ (afterPath p).length = 3) ∧ ((afterPath p).all stepFruit) = true

def a115_conditions_meet (w : Proc) : Prop :=
  ∀ m ∈ w.meetings, m.door ≠ .mind → m.intact = true → m.inRange = true → m.attended = true →
    (m.follows.any fun s => m.door.senseKicca.contains s.kicca) = true

abbrev withProcs (ps : List Process) : Proc := { bareProc with procs := ps }

abbrev bhvCitta : Citta := { jati := .vipaka, bhumi := .kama, vedana := .upekkha, root := .beautiful }

abbrev fiveAdverting : Citta := { jati := .kiriya, bhumi := .kama, vedana := .upekkha, root := .none, dhatu := .mano }

abbrev receivingC : Citta := { jati := .vipaka, bhumi := .kama, vedana := .upekkha, root := .none, dhatu := .mano }

abbrev investigatingC : Citta := { jati := .vipaka, bhumi := .kama, vedana := .upekkha, root := .none }

abbrev kamaJavana : Citta := { jati := .kusala, bhumi := .kama, vedana := .somanassa, root := .beautiful, knowing := true }

abbrev entryFruit : Citta := { entryPath 1 with jati := .vipaka }

abbrev arupaJavana (b : Nat) : Citta :=
  { jati := .kusala, bhumi := .arupa, vedana := .upekkha, root := .beautiful, knowing := true, jhana := 5, base := b }

abbrev stp (c : Citta) (k : Kicca) (d : Door) (o : Obj) : Step := { citta := c, kicca := k, door := some d, obj := o }

abbrev bhv : Step := { citta := bhvCitta, kicca := .bhavanga }

abbrev eyeSteps (j r : Nat) : List Step :=
  [bhv, bhv, stp fiveAdverting .avajjana .eye .rupa, stp eyeCons .dassana .eye .rupa,
   stp receivingC .sampaticchana .eye .rupa, stp investigatingC .santirana .eye .rupa,
   stp manoAdverting .votthabbana .eye .rupa]
  ++ List.replicate j (stp kamaJavana .javana .eye .rupa) ++ List.replicate r (stp bhvCitta .tadarammana .eye .rupa)

abbrev atEye (past : Nat) (ss : List Step) : Process := { kind := .fiveDoor, door := .eye, past := past, steps := ss }

abbrev mindSteps (j r : Nat) : List Step :=
  [bhv, stp manoAdverting .avajjana .mind .kamaOther] ++ List.replicate j (stp kamaJavana .javana .mind .kamaOther)
  ++ List.replicate r (stp bhvCitta .tadarammana .mind .kamaOther)

abbrev atMind (ss : List Step) : Process := { kind := .mindDoor, door := .mind, steps := ss }

abbrev absorbSteps (m a : Nat) : List Step :=
  [bhv, stp manoAdverting .avajjana .mind .kamaOther] ++ List.replicate m (stp kamaJavana .javana .mind .kamaOther)
  ++ List.replicate a (stp firstJhana .javana .mind .pannatti)

abbrev absorption (ss : List Step) : Process := { kind := .absorption, door := .mind, steps := ss }

abbrev pathSteps (i : Nat) (g : Obj) (k f : Nat) : List Step :=
  [bhv, stp manoAdverting .avajjana .mind .kamaOther] ++ List.replicate i (stp kamaJavana .javana .mind .kamaOther)
  ++ [stp kamaJavana .javana .mind g] ++ List.replicate k (stp (entryPath 1) .javana .mind .nibbana)
  ++ List.replicate f (stp entryFruit .javana .mind .nibbana)

abbrev pathProc (ss : List Step) : Process := { kind := .path, door := .mind, steps := ss }

def a46_javana_by_person (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.javanas,
    (p.person = .arahant → s.citta.jati ≠ .kusala ∧ s.citta.jati ≠ .akusala ∧
      (s.citta.bhumi = .lokuttara → s.citta.jati = .vipaka ∧ s.citta.path = 4)) ∧
    (p.person ≠ .arahant → s.citta.jati ≠ .kiriya) ∧
    (s.citta.bhumi = .lokuttara → p.person ≠ .worldling)

def organAbsent (pl : Bhumi) : Dhatu → Bool
  | .sense d => pl == .arupa || (pl == .rupa && decide (2 ≤ d))
  | _ => false

def a46_plane_organs (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, organAbsent p.plane s.citta.dhatu = false

def a35_step_cittas_are_types (t : Tax) (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, reckon89 s.citta ∈ t.kinds89

def a38_abhinna_flag_is_an_abhinna_citta (t : Tax) (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, s.abhinna = true → t.abhinna (reckon89 s.citta) = true

def a36_steps_at_the_processs_door (w : Proc) : Prop :=
  ∀ p ∈ w.procs,
    (p.kind = .fiveDoor → p.door ≠ .mind) ∧ (p.kind ≠ .fiveDoor → p.door = .mind) ∧
    ∀ s ∈ p.steps, s.door ≠ none → s.door = some p.door

def doorObject : Door → Obj
  | .eye => .rupa | .ear => .sadda | .nose => .gandha | .tongue => .rasa | .body => .photthabba | .mind => .kamaOther

def a37_sense_door_takes_its_object (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → ∀ s ∈ p.steps, s.door ≠ none → s.obj = doorObject p.door

def a42_range (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past ≤ 15

def a43_kind_follows_content (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ((p.steps.any stepPath) = true ↔ p.kind = .path) ∧
    ((p.kind = .fiveDoor ∨ p.kind = .mindDoor) → ∀ s ∈ p.javanas, stepKama s = true)

def a115_no_conditions_no_consciousness (w : Proc) : Prop :=
  ∀ m ∈ w.meetings, m.door ≠ .mind → (m.intact && m.inRange && m.attended) = false →
    (m.follows.any fun s => m.door.senseKicca.contains s.kicca) = false

end FormalAbhidhamma.Model
