import World

namespace FormalAbhidhamma.Model

open FormalAbhidhamma FormalAbhidhamma.Relata

variable {S R : Scale}

def o_a28_every_type (w : World S R) : Prop := ∀ c ∈ w.tax.kinds89, ∃ p ∈ w.proc.procs, ∃ s ∈ p.steps, reckon89 s.citta = c

def o_a29_every_cetasika (w : World S R) : Prop := ∀ x ∈ w.tax.cets, ∃ p ∈ w.proc.procs, ∃ s ∈ p.steps, w.tax.assoc (reckon89 s.citta) x = true

def o_a35_every_function (w : World S R) : Prop := ∀ k ∈ Kicca.all, ∃ p ∈ w.proc.procs, ∃ s ∈ p.steps, s.kicca = k

def o_a36_every_door (w : World S R) : Prop := ∀ d ∈ [Door.eye, .ear, .nose, .tongue, .body, .mind], ∃ p ∈ w.proc.procs, p.door = d

def o_a41_very_great (w : World S R) : Prop := ∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ p.past = 1

def o_a42_every_grade (w : World S R) : Prop :=
  (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ p.past = 1) ∧ (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ 2 ≤ p.past ∧ p.past ≤ 3) ∧
  (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ 4 ≤ p.past ∧ p.past ≤ 9) ∧ (∃ p ∈ w.proc.procs, p.kind = .fiveDoor ∧ 10 ≤ p.past ∧ p.past ≤ 15)

def o_a43_mind_door_and_absorption (w : World S R) : Prop := (∃ p ∈ w.proc.procs, p.kind = .mindDoor) ∧ (∃ p ∈ w.proc.procs, p.kind = .absorption)

def o_a109_path (w : World S R) : Prop := ∃ p ∈ w.proc.procs, p.kind = .path

def o_a110_every_person (w : World S R) : Prop :=
  (∃ p ∈ w.proc.procs, p.person = .worldling) ∧ (∃ p ∈ w.proc.procs, p.person = .noble) ∧ (∃ p ∈ w.proc.procs, p.person = .arahant)

def o_a115_a_meeting (w : World S R) : Prop := ∃ m ∈ w.proc.meetings, m.door ≠ .mind ∧ m.intact = true ∧ m.inRange = true ∧ m.attended = true

def o_a107_an_abhinna (w : World S R) : Prop := ∃ c ∈ w.tax.kinds, w.tax.abhinna c = true

def o_a48_every_sphere (w : World S R) : Prop := ∀ b ∈ [Bhumi.kama, .rupa, .arupa], ∃ x ∈ w.mat.beings, x.plane = b

def o_a13_both_kinds (w : World S R) : Prop := (∃ x ∈ w.mat.beings, x.plane = .arupa) ∧ (∃ x ∈ w.mat.beings, x.hasMind = false)

def o_a60_every_kind (w : World S R) : Prop := ∀ r ∈ w.tax.rupas, w.tax.nipphanna r = true → ∃ k ∈ w.mat.kalapas, r ∈ k.members

def o_a6_outside (w : World S R) : Prop := ∃ k ∈ w.mat.kalapas, k.owner = none

def o_a64_every_origin (w : World S R) : Prop := ∀ o ∈ Origin.all, ∃ k ∈ w.mat.kalapas, k.origin = o

def o_a66_every_kalapa (w : World S R) : Prop := ∀ t ∈ twentyOne, ∃ k ∈ w.mat.kalapas, isKind k t = true

def o_k_a_corpse (w : World S R) : Prop := (∃ d, w.death d) ∧ ∃ k ∈ w.mat.kalapas, k.origin = .utu ∧ k.owner ≠ none

def o_a56_death_then_rebirth (w : World S R) : Prop := ∃ d n, w.death d ∧ w.s.prox d n ∧ w.rebirth n

def o_a77_a_stream (w : World S R) : Prop := ∃ _m : w.s.M, True

def o_a78_every_condition (w : World S R) : Prop := ∀ c ∈ Relata.all, ∃ f ∈ w.cond.holds, f.1 = c

def o_a111_cessation_with_emergence (w : World S R) : Prop := ∃ m n, w.cessation m ∧ w.s.prox m n ∧ w.fruition n

def Occurs (w : World S R) : Prop :=
  o_a28_every_type w ∧ o_a29_every_cetasika w ∧ o_a35_every_function w ∧ o_a36_every_door w ∧ o_a41_very_great w ∧ o_a42_every_grade w ∧
  o_a43_mind_door_and_absorption w ∧ o_a109_path w ∧ o_a110_every_person w ∧ o_a115_a_meeting w ∧ o_a107_an_abhinna w ∧ o_a48_every_sphere w ∧
  o_a13_both_kinds w ∧ o_a60_every_kind w ∧ o_a6_outside w ∧ o_a64_every_origin w ∧ o_a66_every_kalapa w ∧ o_k_a_corpse w ∧
  o_a56_death_then_rebirth w ∧ o_a77_a_stream w ∧ o_a78_every_condition w ∧ o_a111_cessation_with_emergence w

def emptyWorld : World Z Z :=
  { s := ⟨Empty, fun m => Empty.elim m, fun m => Empty.elim m, fun m => Empty.elim m, fun m => Empty.elim m, fun m _ => Empty.elim m⟩,
    K := Empty, origin := fun k => Empty.elim k, mom := fun k => Empty.elim k, phase := fun k => Empty.elim k,
    rebirth := fun _ => False, produces := fun _ => False, embodied := fun _ => False, death := fun _ => False, cessation := fun _ => False,
    parinibbana := fun _ => False, fruition := fun _ => False, concrete := fun k => Empty.elim k, ceaseMom := fun k => Empty.elim k,
    ceasePhase := fun k => Empty.elim k, sense := fun _ => False, base := fun _ => none, object := fun _ => none,
    f := fun a => a, night := 2, week := 7, snap := 1,
    cond := ⟨[], []⟩, momOf := fun _ => none,
    mat := { beings := [], kalapas := [], reached := [] }, proc := bareProc, tax := bare, cosmos := okCosmos, status := okStatus }

def a4_variant_sixteen (S : Scale) (l : Link S) : Prop :=
  ∀ k, l.concrete k = true → l.phase k = .arise → Steps l.s.prox 15 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .dissolve

end FormalAbhidhamma.Model
