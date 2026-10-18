/-
  model/Proc.lean — the PROC part of the one World: cognitive processes (*vīthi*), as the manual counts them.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1 and 2, amendments 1 and 2,
  thonly/the-calculus-of-moments). A WORKING encoding: frozen only by Protocol 2, before any model is searched — so
  this file builds NO model of anything, and no world here satisfies the rows (each world below is FORBIDDEN).

  A world's processes are a field of `Proc`. Each process is a list of steps, a step being one citta-type performing
  one function, at a door or at none, on an object, with that object's time. The bhavaṅga moments a process opens
  with are steps too (the mind-door IS a bhavaṅga, A36); the past moments of a five-door object are a number (`past`).
  How a process sits in a stream, moment by moment, and the order of one process after another (A109's reviewing,
  the bhavaṅga after a process) are the MIND link's, not this file's.

  The vocabularies of functions, objects and matter are `Tax.lean`'s; the citta-types are the generator's. Rows A35
  and A38 tie a process to the taxonomy (`Tax.kicca`, `Tax.scope`); the other rows constrain processes alone.

  Q2′ (amendment 2): every definition here quantifies over a world's finite list of processes and the steps in each,
  so the audit will mark them NOT first-order in form, but off the stream: a process is a finite run the texts count
  (A41's 17), and nothing here says how many moments lie between two moments of a stream.

  Layers: A115 L1 (MN 28) · every other row L4 (the manual), A41 and A42 with L5 clauses (the Vibhāvinī) that are
  watched, not encoded, where they are dissents.

  ⚠️ Findings, for the founder (each in its definition's comment, and in `CENSUS.md`):
  (1) A42's row says the very great grade is "the full process, WITH registration"; the Saṅgaha's line says the two
      registrations come "as fitting" (*yathārahaṃ*, §10, `abh07t.nrf.xml:1237`), and A45 bars registration outside the
      sense sphere. Encoded
      as the ROW says, so with A45 a world has no very great five-door object for a being of the fine-material sphere.
      If the attempt meets that, it is a scope collision of the row's words, not of the text.
  (2) A37's cited line also says that every eye-door citta takes visible form only (§51); the row's words do not, so it
      is not encoded (a coverage gap of the axiom list).
  (3) Three clauses PERMIT rather than forbid, and so have no forbidden world: A37's mind-door times, A44's "in
      attainments javanas run many times", A57's "the rebirth citta can take a present object". They go to the
      occurrence list (Protocol 1 §4), with A115's added existential reading.
  (4) A43's "absorption" is read from its cited line (§21: the 26 exalted and supramundane javanas), so it covers the
      path process too (Protocol 1 correction 2 §2: a row's own cited lines may supply the members of a list it names).
-/
import Tax
namespace FormalAbhidhamma.Model
open FormalAbhidhamma

/-! ## Vocabularies (names only) -/

/-- The six doors (Saṅgaha ch. 3 §35, `abh07t.nrf.xml:965`). Six BY THE TYPE. -/
inductive Door | eye | ear | nose | tongue | body | mind deriving DecidableEq, Repr

/-- The sense function a door's consciousness performs; none for the mind-door. -/
def Door.senseKicca : Door → List Kicca
  | .eye => [.dassana] | .ear => [.savana] | .nose => [.ghayana] | .tongue => [.sayana] | .body => [.phusana]
  | .mind => []

/-- An object's time, relative to the citta that takes it (§51–52, `:1045–1049`): present, past, future, time-free. -/
inductive When | present | past | future | timeless deriving DecidableEq, Repr

/-- What a dying being's last process and the next rebirth take (ch. 5 §92, `:1945`): kamma, its sign, a sign of the
    destiny. -/
inductive Sign | kamma | kammaNimitta | gatiNimitta deriving DecidableEq, Repr

/-- An object's desirability (ch. 4 §25–27, `:1337–1345`): undesirable, desirable, very desirable. -/
inductive Desir | anittha | ittha | atiittha deriving DecidableEq, Repr

/-- The mind-object's members by kind (ch. 3 §50, `:1041`). -/
inductive MObj | rupa (r : Rupa) | citta | cetasika (x : Cetasika) | nibbana | pannatti deriving DecidableEq, Repr

/-- The kinds of process the rows name. ⚠️ The split is OURS (five-door · mind-door with limited javana · absorption ·
    the path process). -/
inductive PKind | fiveDoor | mindDoor | absorption | path deriving DecidableEq, Repr

/-- One step: a citta-type performing a function, at a door (`none` = door-free), on an object, at its time. `abhinna`
    marks a super-knowledge javana; `sign` what a rebirth, bhavaṅga or death citta takes; `objBase` the immaterial base
    of an object that is itself an immaterial citta (A106). -/
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

/-- One process. `past`: the moments of a five-door object's life gone before it enters (A41). `clear`: a mind-door
    object's vividness (A43). `nearDeath`: the process before death (A44, A57). `first`: a beginner's first absorption
    (A44). `plane`: the being's sphere (A45). -/
structure Process where
  kind : PKind
  door : Door
  past : Nat := 0
  clear : Bool := true
  nearDeath : Bool := false
  first : Bool := false
  plane : Bhumi := .kama
  desirable : Desir := .ittha
  steps : List Step

/-- A sense meeting (A115): an organ at a door, intact or not; an object in range or not; attention or not; and the
    steps that follow. -/
structure Meeting where
  door : Door
  intact : Bool
  inRange : Bool
  attended : Bool
  follows : List Step

/-- What a world has, process by process. -/
structure Proc where
  procs : List Process
  /-- which organ, if any, each door is -/
  organ : Door → Option Rupa
  /-- the members of the mind-object -/
  mindObject : List MObj
  meetings : List Meeting

/-- The functions of a process's steps, in order. -/
def Process.kiccas (p : Process) : List Kicca := p.steps.map (·.kicca)
/-- How many of its steps perform function k. -/
def Process.count (p : Process) (k : Kicca) : Nat := (p.steps.filter (·.kicca == k)).length
/-- Its javana steps, in order. -/
def Process.javanas (p : Process) : List Step := p.steps.filter (·.kicca == .javana)

def stepKama (s : Step) : Bool := s.citta.bhumi == .kama
def stepPath (s : Step) : Bool := s.citta.bhumi == .lokuttara && s.citta.jati == .kusala
def stepFruit (s : Step) : Bool := s.citta.bhumi == .lokuttara && s.citta.jati == .vipaka

/-- A five-door process's first five process cittas at door d (A41): adverting, the sense function, receiving,
    investigating, determining. -/
def fiveDoorHead (d : Door) : List Kicca := [.avajjana] ++ d.senseKicca ++ [.sampaticchana, .santirana, .votthabbana]

/-- After its vibrations: the head, then one or more javanas, then two registrations or none (A41: *yathārahaṃ*, `abh07t.nrf.xml:1237`). No
    bound on the javanas: the row's "usually seven" is a frequency, not a count. -/
def veryGreatOrder (d : Door) (ks : List Kicca) : Bool :=
  let h := fiveDoorHead d
  let rest := ks.drop h.length
  let tail := rest.dropWhile (· == .javana)
  ks.take h.length == h && rest.takeWhile (· == .javana) != [] && (tail == [] || tail == [.tadarammana, .tadarammana])

/-- One or more bhavaṅgas, adverting, one or more javanas, then registrations or none (A43). Unbounded. -/
def mindDoorOrder (ks : List Kicca) : Bool :=
  let a := ks.dropWhile (· == .bhavanga)
  let b := a.drop 1
  ks.takeWhile (· == .bhavanga) != [] && a.head? == some .avajjana && b.takeWhile (· == .javana) != [] &&
    (b.dropWhile (· == .javana)).all (· == .tadarammana)

/-- The javanas absorb after m preparatory ones: the first m sense-sphere, at least one more, all of those not. -/
def absorbsAfter (js : List Step) (m : Nat) : Bool :=
  (js.take m).all stepKama && m < js.length && (js.drop m).all (!stepKama ·)

/-- The steps after a process's first path citta. -/
def afterPath (p : Process) : List Step := (p.steps.dropWhile (!stepPath ·)).drop 1

/-! ## The rows -/

/-- A35, its PROC half (L4, ch. 3 §18–34, `abh07t.nrf.xml:885–957`): a process's station holds only a citta-type with
    that function — each step's citta-type performs the step's function (`Tax.kicca`), read in the 89 reckoning, where
    the TAX rows fix it (`reckon89`: a supramundane citta by its path and fruit, not its jhāna). -/
def a35_station_fits (t : Tax) (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, t.kicca (reckon89 s.citta) s.kicca = true

/-- A36, the five doors (L4, §36–37, `:969–973`): the eye itself is the eye-door, and so for ear, nose, tongue and body.
    (Six doors: BY THE TYPE.) -/
def a36_organs (w : Proc) : Prop :=
  w.organ .eye = some .cakkhu ∧ w.organ .ear = some .sota ∧ w.organ .nose = some .ghana ∧
  w.organ .tongue = some .jivha ∧ w.organ .body = some .kaya

/-- A36, the mind-door (L4, §38, `:977`): *manodvāraṃ pana bhavaṅganti pavuccati* — a moment of the stream, not an
    organ. Encoded twice: the mind-door is no organ (this), and a process not at a five door opens with a bhavaṅga
    (`a36_mind_door_is_bhavanga`). -/
def a36_mind_door_no_organ (w : Proc) : Prop := w.organ .mind = none

def a36_mind_door_is_bhavanga (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind ≠ .fiveDoor → p.kiccas.head? = some .bhavanga

/-- A36, door-free (L4, §41, `:989`): the cittas are door-free *by way of* rebirth, bhavaṅga and death
    (*paṭisandhibhavaṅgacutivasena dvāravimuttāni*) — a step is door-free exactly when it performs one of the three. -/
def a36_door_free (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, (s.door = none ↔ s.kicca ∈ [Kicca.patisandhi, .bhavanga, .cuti])

/-- A36, nineteen (L4, §41): the citta-types that are door-free, those performing rebirth, bhavaṅga or death,
    number 19 (*ekūnavīsati*, `abh07t.nrf.xml:989`). -/
def a36_nineteen (t : Tax) : Prop :=
  num t.kinds89 (fun c => t.kicca c .patisandhi || t.kicca c .bhavanga || t.kicca c .cuti) = 19

/-- A37, the five-door present (L4, §51, `:1045`): the cittas of a sense door take only a PRESENT object (*tañca
    paccuppannaṃ*). (Its mind-door clause permits four times and forbids nothing: the occurrence list.) -/
def a37_sense_door_present (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, s.door ≠ none → s.door ≠ some .mind → s.when = .present

/-- A37, the mind-object (L4, §50, `:1041`): it includes sensitive matter, subtle matter, citta, cetasika, nibbāna and
    concepts. "Includes", as the row says: each is a member. -/
def a37_mind_object (t : Tax) (w : Proc) : Prop :=
  (pasada.all fun r => w.mindObject.contains (.rupa r)) = true ∧
  ((t.rupas.filter (!t.gross ·)).all fun r => w.mindObject.contains (.rupa r)) = true ∧
  w.mindObject.contains .citta = true ∧ (t.cets.all fun x => w.mindObject.contains (.cetasika x)) = true ∧
  w.mindObject.contains .nibbana = true ∧ w.mindObject.contains .pannatti = true

/-- A38, its PROC half (L4, ch. 3 §54–63, `:1057–1105`): each step's object lies in its citta-type's scope
    (`Tax.scope`, a super-knowledge counted apart), read in the 89 reckoning as `a35_station_fits` is. -/
def a38_in_scope (t : Tax) (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, t.scope (reckon89 s.citta) s.abhinna s.obj = true

/-- A41, entry (L4, ch. 4 §10, `:1237`): a five-door object enters at its standing phase after one OR MORE of its
    moments have passed (*ekacittakkhaṇātītāni vā bahucittakkhaṇātītāni vā ṭhitippattāneva*). The forbidden world is
    the 16-moment view's entry at the arising phase, which the Vibhāvinī calls *asāra* (`:4845`). -/
def a41_entry (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .fiveDoor → 1 ≤ p.past

/-- A41, two vibrations (L4, §10, `abh07t.nrf.xml:1237`): for the very great object, entering after ONE past moment, the bhavaṅga vibrates
    twice (*dvikkhattuṃ bhavaṅge calite*) and is cut off: two bhavaṅgas, then adverting. -/
def a41_two_vibrations (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → p.kiccas.take 3 = [.bhavanga, .bhavanga, .avajjana]

/-- A41, the order (L4, §10): adverting, the sense-consciousness, receiving, investigating, determining, javanas, and
    two registrations as fitting. -/
def a41_order (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → veryGreatOrder p.door (p.kiccas.drop 2) = true

/-- A41, seventeen (L4, §11, `:1241`): fourteen process cittas, two vibrations and the one past moment complete
    seventeen moments, and then the object ceases (*sattarasa cittakkhaṇāni paripūrenti, tato paraṃ nirujjhati*): the
    process does not outlast them. -/
def a41_seventeen (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → p.past + p.steps.length ≤ 17

/-- A42, very great (L5, the Vibhāvinī's range `:4821`: one past moment): "the full process, WITH registration", as
    the ROW says. ⚠️ FINDING (1): the Saṅgaha's §10 says the registrations come "as fitting" (*yathārahaṃ*, `abh07t.nrf.xml:1237`), and A45
    bars them outside the sense sphere; encoded as the row's words. -/
def a42_very_great (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .fiveDoor → p.past = 1 → 1 ≤ p.count .tadarammana

/-- A42, great (L5 range: two or three past moments; L4 §12, `:1245`): no registration. -/
def a42_great (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → 2 ≤ p.past → p.past ≤ 3 → p.count .tadarammana = 0

/-- A42, slight (L5 range: four to nine; L4 §13, `:1249`): no javana; determining two or three times
    (*dvattikkhattuṃ voṭṭhabbanameva*). -/
def a42_slight (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → 4 ≤ p.past → p.past ≤ 9 →
    p.count .javana = 0 ∧ (p.count .votthabbana = 2 ∨ p.count .votthabbana = 3)

/-- A42, very slight (L5 range: ten to fifteen; L4 §14, `:1253`): only the bhavaṅga vibrates; no process citta
    (*bhavaṅgacalanameva hoti, natthi vīthicittuppādo*). -/
def a42_very_slight (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .fiveDoor → 10 ≤ p.past → p.past ≤ 15 → (p.kiccas.all (· == .bhavanga)) = true

/-- A43, the clear mind-door object (L4, §17, `:1277`): registration follows the javanas. -/
def a43_clear (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .mindDoor → p.clear = true → 1 ≤ p.count .tadarammana

/-- A43, the obscure one (L4, §18, `:1281`): no registration. -/
def a43_obscure (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .mindDoor → p.clear = false → p.count .tadarammana = 0

/-- A43, the order (L4, §17): the bhavaṅga vibrates, then adverting, then javanas, then registration if any. -/
def a43_order (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .mindDoor → mindDoorOrder p.kiccas = true

/-- A43, absorption (L4, §21, `:1305`): three or four preparatory javanas, then the fourth or fifth absorbs
    (*catukkhattuṃ tikkhattumeva vā … catutthaṃ, pañcamaṃ vā*). Absorption is one of the 26 exalted and supramundane
    javanas (the cited line), so the path process is absorption too. -/
def a43_absorption (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .absorption ∨ p.kind = .path) → (absorbsAfter p.javanas 3 || absorbsAfter p.javanas 4) = true

/-- A43, absorption has no registration (L4, §20, `:1301`; §21: bhavaṅga follows the absorption). -/
def a43_absorption_no_registration (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .absorption ∨ p.kind = .path) → p.count .tadarammana = 0

/-- A44, seven or six (L4, §31, `:1373`): in a limited-javana process the sense-sphere javanas run seven times or six. -/
def a44_seven_or_six (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .fiveDoor ∨ p.kind = .mindDoor) → p.nearDeath = false →
    (p.count .javana = 0 ∨ p.count .javana = 6 ∨ p.count .javana = 7)

/-- A44, five at death (L4, §32, `:1377`): when the process is slow, as at death, five only (*pañcavārameva*). -/
def a44_five_at_death (w : Proc) : Prop :=
  ∀ p ∈ w.procs, (p.kind = .fiveDoor ∨ p.kind = .mindDoor) → p.nearDeath = true →
    (p.count .javana = 0 ∨ p.count .javana = 5)

/-- A44, a first absorption once (L4, §34, `:1385`): in a beginner's first absorption the exalted javana runs once. -/
def a44_first_once (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .absorption → p.first = true → (p.javanas.filter (!stepKama ·)).length = 1

/-- A44, the super-knowledges once (L4, §34, `abh07t.nrf.xml:1385`: *sabbadāpi ekavārameva*): never two super-knowledge javanas in one process. -/
def a44_abhinna_once (w : Proc) : Prop := ∀ p ∈ w.procs, (p.steps.filter (·.abhinna)).length ≤ 1

/-- A44, a path citta one moment (L4, §35, `:1389`: *ekacittakkhaṇikā*). -/
def a44_path_one_moment (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .path → (p.steps.filter stepPath).length = 1

/-- A44, then two or three fruition cittas (L4, §35, `abh07t.nrf.xml:1389`: *dve tīṇi phalacittāni*). -/
def a44_fruition (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path →
    ((afterPath p).length = 2 ∨ (afterPath p).length = 3) ∧ ((afterPath p).all stepFruit) = true

/-- A45, desirability (L4, §25–26, `:1337–1341`): on an undesirable object the five consciousnesses, receiving,
    investigating and registration are results of UNwholesome kamma; on a desirable one, of wholesome. -/
def a45_desirability (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps,
    s.kicca ∈ [Kicca.dassana, .savana, .ghayana, .sayana, .phusana, .sampaticchana, .santirana, .tadarammana] →
      s.citta.ofKusala = (p.desirable != .anittha)

/-- A45, sense-sphere beings (L4, §29–30, `:1353–1361`): registration only for beings of the sense sphere. -/
def a45_sense_beings (w : Proc) : Prop := ∀ p ∈ w.procs, 1 ≤ p.count .tadarammana → p.plane = .kama

/-- A45, sense-sphere objects (L4, §29): registration only on a sense-sphere object. -/
def a45_sense_objects (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, s.kicca = .tadarammana → s.obj.kama = true

/-- A45, after sense-sphere javana (L4, §29): registration only where the javanas are sense-sphere. -/
def a45_sense_javana (w : Proc) : Prop :=
  ∀ p ∈ w.procs, 1 ≤ p.count .tadarammana → (p.javanas.all stepKama) = true

/-- A45, clear or very great (L4, §30, `:1361`: *vibhūtetimahante ca*): registration only on a clear mind-door object
    or a very great five-door one. -/
def a45_clear_or_very_great (w : Proc) : Prop :=
  ∀ p ∈ w.procs, 1 ≤ p.count .tadarammana →
    (p.kind = .fiveDoor ∧ p.past = 1) ∨ (p.kind = .mindDoor ∧ p.clear = true)

/-- A57, five at death (L4, ch. 5 §92, `:1945`): in the process before death the javanas are slow, five only. -/
def a57_five_at_death (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.nearDeath = true → (p.count .javana = 0 ∨ p.count .javana = 5)

/-- A57, kamma always past (L4, §92, `abh07t.nrf.xml:1945`: *kammaṃ pana atītameva*): a rebirth or bhavaṅga citta that takes kamma takes it
    as past. (That they CAN take a present object permits: the occurrence list.) -/
def a57_kamma_past (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, (s.kicca = .patisandhi ∨ s.kicca = .bhavanga) → s.sign = some .kamma → s.when = .past

/-- An immaterial attainment's javana with base b. -/
def arupaAttainment (s : Step) (b : Nat) : Bool :=
  s.kicca == .javana && s.citta.bhumi == .arupa && s.citta.jati != .vipaka && s.citta.base == b

/-- A106, the first (L4, ch. 9 §36, `:3201`): the space got by removing a kasiṇa, attended to as infinite — a concept. -/
def a106_first (w : Proc) : Prop := ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 1 = true → s.obj = .pannatti

/-- A106, the second (L4, §37, `:3205`): that first immaterial consciousness, as infinite. -/
def a106_second (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 2 = true → s.obj = .mahaggata ∧ s.objBase = 1

/-- A106, the third (L4, §38, `:3209`): that consciousness's absence, as "there is nothing" — a concept. -/
def a106_third (w : Proc) : Prop := ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 3 = true → s.obj = .pannatti

/-- A106, the fourth (L4, §39, `:3213`): the third attainment, as peaceful and sublime. -/
def a106_fourth (w : Proc) : Prop :=
  ∀ p ∈ w.procs, ∀ s ∈ p.steps, arupaAttainment s 4 = true → s.obj = .mahaggata ∧ s.objBase = 3

/-- A109, insight (L4, ch. 9 §55, `:3313`): two or three insight cittas (preparation, access, conformity), then the
    change-of-lineage, all sense-sphere javanas, then the path. -/
def a109_insight (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path →
    ([2, 3].any fun i => (p.javanas.take (i + 1)).all stepKama && ((p.javanas.drop (i + 1)).head?.map stepPath == some true)) = true

/-- A109, change-of-lineage takes nibbāna (L4, §57, `:3321`: *gotrabhucittaṃ nibbānamālambitvā*): the step just before
    the path citta takes nibbāna as object. -/
def a109_change_of_lineage (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path → ((p.steps.takeWhile (!stepPath ·)).getLast?.map (·.obj)) = some .nibbana

/-- A109, the path for one mind-moment (L4, ch. 4 §35, `:1389`; ch. 9 §58, `:3325`). -/
def a109_path_once (w : Proc) : Prop := ∀ p ∈ w.procs, p.kind = .path → (p.steps.filter stepPath).length = 1

/-- A109, two or three fruition cittas (L4, §59, `:3329`). (Then bhavaṅga, then reviewing: the order of processes in a
    stream, the MIND link's.) -/
def a109_fruition (w : Proc) : Prop :=
  ∀ p ∈ w.procs, p.kind = .path →
    ((afterPath p).length = 2 ∨ (afterPath p).length = 3) ∧ ((afterPath p).all stepFruit) = true

/-- A115 (L1, MN 28 §306, `s0201m.mul.xml:4216`): when the eye is intact, forms come into range and there is the
    corresponding attention, the corresponding consciousness manifests (*evaṃ tajjassa viññāṇabhāgassa pātubhāvo
    hoti*); and so for each sense door. The CONDITIONAL only; that a meeting occurs is the row's added reading, for the
    occurrence list. -/
def a115_conditions_meet (w : Proc) : Prop :=
  ∀ m ∈ w.meetings, m.door ≠ .mind → m.intact = true → m.inRange = true → m.attended = true →
    (m.follows.any fun s => m.door.senseKicca.contains s.kicca) = true

/-! ## Forbidden worlds — one per definition, each a world its text rules out. -/

/-- No processes, no meetings, no mind-object; the five doors are their organs and the mind-door none. -/
abbrev bareProc : Proc :=
  { procs := [], mindObject := [], meetings := [],
    organ := fun d => match d with
      | .eye => some .cakkhu | .ear => some .sota | .nose => some .ghana | .tongue => some .jivha
      | .body => some .kaya | .mind => none }

abbrev withProcs (ps : List Process) : Proc := { bareProc with procs := ps }

/-- A bhavaṅga: a great resultant, door-free. -/
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

/-- A five-door process at the eye: two vibrations, the five process cittas, j javanas, r registrations. -/
abbrev eyeSteps (j r : Nat) : List Step :=
  [bhv, bhv, stp fiveAdverting .avajjana .eye .rupa, stp eyeCons .dassana .eye .rupa,
   stp receivingC .sampaticchana .eye .rupa, stp investigatingC .santirana .eye .rupa,
   stp manoAdverting .votthabbana .eye .rupa]
  ++ List.replicate j (stp kamaJavana .javana .eye .rupa) ++ List.replicate r (stp bhvCitta .tadarammana .eye .rupa)

abbrev atEye (past : Nat) (ss : List Step) : Process := { kind := .fiveDoor, door := .eye, past := past, steps := ss }

/-- A mind-door process: one vibration, adverting, j javanas, r registrations. -/
abbrev mindSteps (j r : Nat) : List Step :=
  [bhv, stp manoAdverting .avajjana .mind .kamaOther] ++ List.replicate j (stp kamaJavana .javana .mind .kamaOther)
  ++ List.replicate r (stp bhvCitta .tadarammana .mind .kamaOther)

abbrev atMind (ss : List Step) : Process := { kind := .mindDoor, door := .mind, steps := ss }

/-- An absorption: one vibration, adverting, m preparatory javanas, then a absorbing first-jhāna javanas. -/
abbrev absorbSteps (m a : Nat) : List Step :=
  [bhv, stp manoAdverting .avajjana .mind .kamaOther] ++ List.replicate m (stp kamaJavana .javana .mind .kamaOther)
  ++ List.replicate a (stp firstJhana .javana .mind .pannatti)

abbrev absorption (ss : List Step) : Process := { kind := .absorption, door := .mind, steps := ss }

/-- A path process: one vibration, adverting, i insight javanas, change-of-lineage on `g`, k path cittas, f fruits. -/
abbrev pathSteps (i : Nat) (g : Obj) (k f : Nat) : List Step :=
  [bhv, stp manoAdverting .avajjana .mind .kamaOther] ++ List.replicate i (stp kamaJavana .javana .mind .kamaOther)
  ++ [stp kamaJavana .javana .mind g] ++ List.replicate k (stp (entryPath 1) .javana .mind .nibbana)
  ++ List.replicate f (stp entryFruit .javana .mind .nibbana)

abbrev pathProc (ss : List Step) : Process := { kind := .path, door := .mind, steps := ss }

/-- Eye-consciousness performing receiving, on a world whose functions are the text's table. -/
abbrev eyeReceives : Proc := withProcs [atEye 1 [stp eyeCons .sampaticchana .eye .rupa]]
theorem a35_forbids_eyeReceives : ¬ a35_station_fits { bare with kicca := kiccaTable } eyeReceives := by
  unfold a35_station_fits; decide

/-- The eye-door is visible form, not the eye. -/
abbrev eyeDoorIsForm : Proc := { bareProc with organ := fun d => if d == .eye then some .vanna else bareProc.organ d }
theorem a36_forbids_eyeDoorIsForm : ¬ a36_organs eyeDoorIsForm := by unfold a36_organs; decide

/-- The mind-door is the heart-base: an organ. -/
abbrev mindDoorHeart : Proc := { bareProc with organ := fun d => if d == .mind then some .hadaya else bareProc.organ d }
theorem a36_forbids_mindDoorHeart : ¬ a36_mind_door_no_organ mindDoorHeart := by unfold a36_mind_door_no_organ; decide

/-- A mind-door process that opens with adverting, no bhavaṅga before it. -/
abbrev noBhavangaDoor : Proc := withProcs [atMind ((mindSteps 7 0).drop 1)]
theorem a36_forbids_noBhavangaDoor : ¬ a36_mind_door_is_bhavanga noBhavangaDoor := by
  unfold a36_mind_door_is_bhavanga; decide

/-- A bhavaṅga at the eye-door. -/
abbrev bhavangaAtDoor : Proc := withProcs [atEye 1 [{ bhv with door := some .eye }]]
theorem a36_forbids_bhavangaAtDoor : ¬ a36_door_free bhavangaAtDoor := by unfold a36_door_free; decide

/-- One door-free citta-type in the world, not nineteen. -/
abbrev oneDoorFree : Tax := { bare with kinds := [bhvCitta], kicca := kiccaTable }
theorem a36_forbids_oneDoorFree : ¬ a36_nineteen oneDoorFree := by unfold a36_nineteen; decide

/-- An eye-door javana taking a PAST object. -/
abbrev eyeDoorPast : Proc := withProcs [atEye 1 [{ stp kamaJavana .javana .eye .rupa with when := .past }]]
theorem a37_forbids_eyeDoorPast : ¬ a37_sense_door_present eyeDoorPast := by unfold a37_sense_door_present; decide

/-- A mind-object with everything but concepts. -/
abbrev noConcepts : Proc :=
  { bareProc with mindObject := pasada.map MObj.rupa ++ [.citta, .nibbana] }
theorem a37_forbids_noConcepts : ¬ a37_mind_object bare noConcepts := by unfold a37_mind_object; decide

/-- Eye-consciousness taking sound, on a world whose sense-consciousnesses take their own object. -/
abbrev eyeTakesSound : Proc := withProcs [atEye 1 [stp eyeCons .dassana .eye .sadda]]
theorem a38_forbids_eyeTakesSound :
    ¬ a38_in_scope { bare with scope := fun c _ o => doorOf c == 0 || o == senseObj (doorOf c) } eyeTakesSound := by
  unfold a38_in_scope; decide

/-- A five-door object entering at its arising phase, with no moment past (the 16-moment view's entry). -/
abbrev arisingEntry : Proc := withProcs [atEye 0 (eyeSteps 7 2)]
theorem a41_forbids_arisingEntry : ¬ a41_entry arisingEntry := by unfold a41_entry; decide

/-- A very great object, and the bhavaṅga vibrates three times. -/
abbrev threeVibrations : Proc := withProcs [atEye 1 (bhv :: eyeSteps 7 2)]
theorem a41_forbids_threeVibrations : ¬ a41_two_vibrations threeVibrations := by unfold a41_two_vibrations; decide

/-- A very great object, and registration comes before the javanas. -/
abbrev registrationFirst : Proc :=
  withProcs [atEye 1 (eyeSteps 0 2 ++ List.replicate 7 (stp kamaJavana .javana .eye .rupa))]
theorem a41_forbids_registrationFirst : ¬ a41_order registrationFirst := by unfold a41_order; decide

/-- A very great object, eight javanas and two registrations: eighteen moments. -/
abbrev eighteenMoments : Proc := withProcs [atEye 1 (eyeSteps 8 2)]
theorem a41_forbids_eighteenMoments : ¬ a41_seventeen eighteenMoments := by unfold a41_seventeen; decide

/-- A very great object with no registration. -/
abbrev veryGreatBare : Proc := withProcs [atEye 1 (eyeSteps 7 0)]
theorem a42_forbids_veryGreatBare : ¬ a42_very_great veryGreatBare := by unfold a42_very_great; decide

/-- A great object (two moments past) with registration. -/
abbrev greatRegisters : Proc := withProcs [atEye 2 (eyeSteps 7 2)]
theorem a42_forbids_greatRegisters : ¬ a42_great greatRegisters := by unfold a42_great; decide

/-- A slight object (four moments past) with a javana. -/
abbrev slightJavana : Proc := withProcs [atEye 4 (eyeSteps 1 0)]
theorem a42_forbids_slightJavana : ¬ a42_slight slightJavana := by unfold a42_slight; decide

/-- A very slight object (ten moments past) with process cittas. -/
abbrev verySlightProcess : Proc := withProcs [atEye 10 (eyeSteps 0 0)]
theorem a42_forbids_verySlightProcess : ¬ a42_very_slight verySlightProcess := by unfold a42_very_slight; decide

/-- A clear mind-door object with no registration. -/
abbrev clearBare : Proc := withProcs [atMind (mindSteps 7 0)]
theorem a43_forbids_clearBare : ¬ a43_clear clearBare := by unfold a43_clear; decide

/-- An obscure mind-door object with registration. -/
abbrev obscureRegisters : Proc := withProcs [{ atMind (mindSteps 7 2) with clear := false }]
theorem a43_forbids_obscureRegisters : ¬ a43_obscure obscureRegisters := by unfold a43_obscure; decide

/-- A mind-door process whose javana comes before its adverting. -/
abbrev javanaFirst : Proc :=
  withProcs [atMind [bhv, stp kamaJavana .javana .mind .kamaOther, stp manoAdverting .avajjana .mind .kamaOther]]
theorem a43_forbids_javanaFirst : ¬ a43_order javanaFirst := by unfold a43_order; decide

/-- An absorption at the third javana: two preparatory javanas only. -/
abbrev absorbsThird : Proc := withProcs [absorption (absorbSteps 2 1)]
theorem a43_forbids_absorbsThird : ¬ a43_absorption absorbsThird := by unfold a43_absorption; decide

/-- An absorption followed by registration. -/
abbrev absorptionRegisters : Proc :=
  withProcs [absorption (absorbSteps 4 1 ++ [stp bhvCitta .tadarammana .mind .kamaOther])]
theorem a43_forbids_absorptionRegisters : ¬ a43_absorption_no_registration absorptionRegisters := by
  unfold a43_absorption_no_registration; decide

/-- Four javanas in a limited process, not at death. -/
abbrev fourJavanas : Proc := withProcs [atEye 2 (eyeSteps 4 0)]
theorem a44_forbids_fourJavanas : ¬ a44_seven_or_six fourJavanas := by unfold a44_seven_or_six; decide

/-- Seven javanas in the process before death. -/
abbrev sevenAtDeath : Proc := withProcs [{ atEye 2 (eyeSteps 7 0) with nearDeath := true }]
theorem a44_forbids_sevenAtDeath : ¬ a44_five_at_death sevenAtDeath := by unfold a44_five_at_death; decide

/-- A beginner's first absorption running twice. -/
abbrev firstTwice : Proc := withProcs [{ absorption (absorbSteps 4 2) with first := true }]
theorem a44_forbids_firstTwice : ¬ a44_first_once firstTwice := by unfold a44_first_once; decide

/-- Two super-knowledge javanas in one process. -/
abbrev abhinnaTwice : Proc :=
  withProcs [absorption (absorbSteps 4 0 ++ List.replicate 2 { stp { firstJhana with jhana := 5, vedana := .upekkha }
    .javana .mind .rupa with abhinna := true })]
theorem a44_forbids_abhinnaTwice : ¬ a44_abhinna_once abhinnaTwice := by unfold a44_abhinna_once; decide

/-- A path citta for two moments. -/
abbrev pathTwice : Proc := withProcs [pathProc (pathSteps 2 .nibbana 2 2)]
theorem a44_forbids_pathTwice : ¬ a44_path_one_moment pathTwice := by unfold a44_path_one_moment; decide

/-- A path with one fruition citta after it. -/
abbrev oneFruit : Proc := withProcs [pathProc (pathSteps 2 .nibbana 1 1)]
theorem a44_forbids_oneFruit : ¬ a44_fruition oneFruit := by unfold a44_fruition; decide

/-- An undesirable object, and the eye-consciousness is a wholesome result. -/
abbrev undesirableWholesome : Proc := withProcs [{ atEye 1 [stp eyeCons .dassana .eye .rupa] with desirable := .anittha }]
theorem a45_forbids_undesirableWholesome : ¬ a45_desirability undesirableWholesome := by unfold a45_desirability; decide

/-- Registration in a being of the fine-material sphere. -/
abbrev brahmaRegisters : Proc := withProcs [{ atEye 1 (eyeSteps 7 2) with plane := .rupa }]
theorem a45_forbids_brahmaRegisters : ¬ a45_sense_beings brahmaRegisters := by unfold a45_sense_beings; decide

/-- Registration on an exalted object. -/
abbrev registersExalted : Proc :=
  withProcs [atMind (mindSteps 7 0 ++ [stp bhvCitta .tadarammana .mind .mahaggata])]
theorem a45_forbids_registersExalted : ¬ a45_sense_objects registersExalted := by unfold a45_sense_objects; decide

/-- Registration after a fine-material javana. -/
abbrev registersAfterJhana : Proc :=
  withProcs [atMind ([bhv, stp manoAdverting .avajjana .mind .kamaOther, stp firstJhana .javana .mind .pannatti]
    ++ [stp bhvCitta .tadarammana .mind .kamaOther])]
theorem a45_forbids_registersAfterJhana : ¬ a45_sense_javana registersAfterJhana := by unfold a45_sense_javana; decide

/-- Registration on a great five-door object (two moments past). -/
abbrev greatObjectRegisters : Proc := withProcs [atEye 2 (eyeSteps 7 2)]
theorem a45_forbids_greatObjectRegisters : ¬ a45_clear_or_very_great greatObjectRegisters := by
  unfold a45_clear_or_very_great; decide

/-- Seven javanas before death, at the mind-door. -/
abbrev sevenBeforeDeath : Proc := withProcs [{ atMind (mindSteps 7 0) with nearDeath := true }]
theorem a57_forbids_sevenBeforeDeath : ¬ a57_five_at_death sevenBeforeDeath := by unfold a57_five_at_death; decide

/-- A rebirth citta taking kamma as PRESENT. -/
abbrev kammaPresent : Proc :=
  withProcs [{ atMind [{ citta := bhvCitta, kicca := .patisandhi, sign := some .kamma, when := .present }] with
    nearDeath := true }]
theorem a57_forbids_kammaPresent : ¬ a57_kamma_past kammaPresent := by unfold a57_kamma_past; decide

/-- The first immaterial attainment taking an exalted object. -/
abbrev firstTakesExalted : Proc := withProcs [absorption [stp (arupaJavana 1) .javana .mind .mahaggata]]
theorem a106_forbids_firstTakesExalted : ¬ a106_first firstTakesExalted := by unfold a106_first; decide

/-- The second immaterial attainment taking the THIRD's consciousness. -/
abbrev secondTakesThird : Proc := withProcs [absorption [{ stp (arupaJavana 2) .javana .mind .mahaggata with objBase := 3 }]]
theorem a106_forbids_secondTakesThird : ¬ a106_second secondTakesThird := by unfold a106_second; decide

/-- The third immaterial attainment taking an exalted object. -/
abbrev thirdTakesExalted : Proc := withProcs [absorption [stp (arupaJavana 3) .javana .mind .mahaggata]]
theorem a106_forbids_thirdTakesExalted : ¬ a106_third thirdTakesExalted := by unfold a106_third; decide

/-- The fourth immaterial attainment taking the FIRST's consciousness. -/
abbrev fourthTakesFirst : Proc := withProcs [absorption [{ stp (arupaJavana 4) .javana .mind .mahaggata with objBase := 1 }]]
theorem a106_forbids_fourthTakesFirst : ¬ a106_fourth fourthTakesFirst := by unfold a106_fourth; decide

/-- One insight citta only before the change-of-lineage. -/
abbrev oneInsight : Proc := withProcs [pathProc (pathSteps 1 .nibbana 1 2)]
theorem a109_forbids_oneInsight : ¬ a109_insight oneInsight := by unfold a109_insight; decide

/-- A change-of-lineage taking a sense-sphere object, not nibbāna. -/
abbrev lineageOnSense : Proc := withProcs [pathProc (pathSteps 2 .kamaOther 1 2)]
theorem a109_forbids_lineageOnSense : ¬ a109_change_of_lineage lineageOnSense := by unfold a109_change_of_lineage; decide

/-- A path citta for two moments, in A109's words. -/
abbrev pathTwiceAgain : Proc := withProcs [pathProc (pathSteps 3 .nibbana 2 2)]
theorem a109_forbids_pathTwiceAgain : ¬ a109_path_once pathTwiceAgain := by unfold a109_path_once; decide

/-- Four fruition cittas after the path. -/
abbrev fourFruits : Proc := withProcs [pathProc (pathSteps 2 .nibbana 1 4)]
theorem a109_forbids_fourFruits : ¬ a109_fruition fourFruits := by unfold a109_fruition; decide

/-- The eye intact, a form in range, attention — and no eye-consciousness. -/
abbrev noSeeing : Proc := { bareProc with meetings := [⟨.eye, true, true, true, []⟩] }
theorem a115_forbids_noSeeing : ¬ a115_conditions_meet noSeeing := by unfold a115_conditions_meet; decide

end FormalAbhidhamma.Model
