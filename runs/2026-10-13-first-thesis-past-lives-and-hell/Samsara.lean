/-
  The founder's first thesis (2026-10-13), suppositions 3–5, under the A389 conventions (one claim per theorem; each premise
  a definition named by its axiom ID and its own hypothesis). Supposition 1 is the World (a being = one stream of cittas);
  supposition 2 is stated in the Piṭaka (Bv 1.64) and gets no theorem. Registered 2026-10-14T03:17:28Z (PREREG.md): the
  definitions and T3's statement below are verbatim. T4 and T5 cannot be proved from their premises, so each registered
  statement is restated here, clause for clause, as a CLAIM (`t4_registered`, `t5_registered`) that `run.sh` checks
  against the PREREG — and Lean proves the claim fails in one model of the premises and holds in another (INDEPENDENT).
-/
namespace FormalAbhidhamma.Samsara

/-- The eight destinies a rebirth can lead to (A48's 31 planes, grouped). -/
inductive Destiny where
  | niraya | tiracchana | peta | asura | manussa | deva | rupa | arupa
  deriving DecidableEq

/-- ONE being, as one stream of cittas on a clock of integer ticks (supposition 1). `citta t`: a citta of this stream
    occurs at tick `t`; `prox p q`: the citta at `p` conditions the citta at `q` by proximity; `patisandhi r`: a
    rebirth-linking citta (the first citta of an existence) occurs at `r`; `realm r`: the destiny of the existence that
    begins at `r`; `arahatta a`: the arahant path citta occurs at `a`; `now`: the present tick. -/
structure World where
  citta : Int → Prop
  prox : Int → Int → Prop
  patisandhi : Int → Prop
  realm : Int → Destiny
  arahatta : Int → Prop
  now : Int

/-! ## The premises, one definition per axiom clause -/

/-- C (the Paṭṭhāna's negative method): every citta has a citta that conditions it by proximity. -/
def c_predecessor (w : World) : Prop := ∀ q, w.citta q → ∃ p, w.prox p q ∧ w.citta p

/-- A3 (proximity): what conditions by proximity comes BEFORE what it conditions. -/
def a3_successor (w : World) : Prop := ∀ p q, w.prox p q → p < q

/-- A58 (with A51, Vibhaṅga §191): every existence begins with a rebirth-linking citta, so every citta lies at or
    after the rebirth-linking citta of its own existence. -/
def a58_lives_begin (w : World) : Prop := ∀ t, w.citta t → ∃ r, w.patisandhi r ∧ r ≤ t

/-- A109 (the path process): the arahant path is a citta. -/
def a109_path_is_citta (w : World) : Prop := ∀ a, w.arahatta a → w.citta a

/-! ## A constructive `omega` (copied from `runs/2026-10-13-kv-22-10-duration-reading/Khanika2.lean`): split a
    conjunction, then decide each half by contradiction, so a decidable goal does not pull in `Classical.choice`. -/

syntax "omega_c" : tactic
macro_rules
  | `(tactic| omega_c) => `(tactic| first
      | (apply And.intro <;> omega_c)
      | exact Decidable.byContradiction fun _h => by omega)

/-! ## T3 — PROVED -/

/-- T3 — supposition 3: however far back you go, a life of this being had already begun earlier still. Since ticks are
    integers, this is infinitely many past lives. `hnow`: the being exists now. -/
theorem t3_infinitely_many_past_lives (w : World) (hC : c_predecessor w) (h3 : a3_successor w)
    (h58 : a58_lives_begin w) (hnow : w.citta w.now) :
    ∀ b : Int, ∃ r, w.patisandhi r ∧ r < b := by
  intro b
  -- descend from the present citta: for every k there is a citta at least k ticks back
  have key : ∀ k : Nat, ∃ t, w.citta t ∧ t + k ≤ w.now := by
    intro k
    induction k with
    | zero => exact ⟨w.now, hnow, by omega_c⟩
    | succ k ih =>
      obtain ⟨t, ht, hk⟩ := ih
      obtain ⟨p, hp, hpc⟩ := hC t ht
      have hpt := h3 p t hp
      exact ⟨p, hpc, by omega_c⟩
  obtain ⟨t, ht, hk⟩ := key (w.now - b + 1).toNat
  have hb := Int.self_le_toNat (w.now - b + 1)
  obtain ⟨r, hr, hle⟩ := h58 t ht
  exact ⟨r, hr, by omega_c⟩

/-! ## T4 and T5 — the registered statements, as claims -/

/-- T4 as registered (`theorem t4_a_past_life_in_hell`), clause for clause: from these premises, this being had a PAST
    existence in hell — one that began in hell and was followed by another existence that has already begun by now. -/
def t4_registered : Prop :=
  ∀ (w : World), c_predecessor w → a3_successor w → a58_lives_begin w → w.citta w.now →
    ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ w.now

/-- T5 as registered (`theorem t5_hell_before_arahantship`), clause for clause: from these premises, if this being attains
    the arahant path at `a`, a PAST existence of it was in hell — one followed by another existence that had begun by `a`. -/
def t5_registered : Prop :=
  ∀ (w : World), c_predecessor w → a3_successor w → a58_lives_begin w → a109_path_is_citta w → ∀ (a : Int), w.arahatta a →
    ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ a

/-! ## The witness worlds: a beginningless stream, a rebirth at every tick, an arahant path at 0. In `hellWorld` the
    existence beginning at −1 is in hell; in `humanWorld` every existence is human. -/

/-- Every tick a citta and a rebirth-linking; proximity is the next tick; the path at 0; `realm` as given. -/
def world (rl : Int → Destiny) : World :=
  ⟨fun _ => True, fun p q => q = p + 1, fun _ => True, rl, fun t => t = 0, 0⟩

def hellWorld : World := world (fun r => if r = -1 then Destiny.niraya else Destiny.manussa)
def humanWorld : World := world (fun _ => Destiny.manussa)

theorem world_c (rl : Int → Destiny) : c_predecessor (world rl) :=
  fun q _ => ⟨q - 1, show q = q - 1 + 1 by omega_c, trivial⟩

theorem world_a3 (rl : Int → Destiny) : a3_successor (world rl) :=
  fun p q (h : q = p + 1) => by omega_c

theorem world_a58 (rl : Int → Destiny) : a58_lives_begin (world rl) :=
  fun t _ => ⟨t, trivial, Int.le_refl t⟩

theorem world_a109 (rl : Int → Destiny) : a109_path_is_citta (world rl) :=
  fun _ _ => trivial

/-- T4 is NOT forced: in a model of every premise, no existence is in hell — so `t4_registered` is false. -/
theorem t4_not_forced : ¬ t4_registered := by
  intro h
  obtain ⟨r, r', _, hr, _⟩ := h humanWorld (world_c _) (world_a3 _) (world_a58 _) trivial
  cases hr

/-- T4 is admitted: a model of every premise in which it holds. With `t4_not_forced`: INDEPENDENT. -/
theorem t4_admitted :
    ∃ w, c_predecessor w ∧ a3_successor w ∧ a58_lives_begin w ∧ w.citta w.now ∧
      ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ w.now :=
  ⟨hellWorld, world_c _, world_a3 _, world_a58 _, trivial, -1, 0, trivial, by decide, trivial, by decide, by decide⟩

/-- T5 is NOT forced: an arahant path at 0 whose stream was never in hell — so `t5_registered` is false. -/
theorem t5_not_forced : ¬ t5_registered := by
  intro h
  obtain ⟨r, r', _, hr, _⟩ := h humanWorld (world_c _) (world_a3 _) (world_a58 _) (world_a109 _) 0 rfl
  cases hr

/-- T5 is admitted: an arahant path at 0 preceded by a past existence in hell. With `t5_not_forced`: INDEPENDENT. -/
theorem t5_admitted :
    ∃ w a, c_predecessor w ∧ a3_successor w ∧ a58_lives_begin w ∧ a109_path_is_citta w ∧ w.arahatta a ∧
      ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ a :=
  ⟨hellWorld, 0, world_c _, world_a3 _, world_a58 _, world_a109 _, rfl, -1, 0, trivial, by decide, trivial, by decide,
    by decide⟩

/-! ## How the suppositions build on one another -/

/-- Supposition 4 does not follow from supposition 3: a world where T3's conclusion holds (infinitely many past lives)
    and no past existence is in hell. -/
theorem t4_not_from_t3 :
    ∃ w : World, (∀ b : Int, ∃ r, w.patisandhi r ∧ r < b) ∧
      ¬ ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ w.now :=
  ⟨humanWorld, fun b => ⟨b - 1, trivial, by omega_c⟩, fun ⟨_, _, _, hr, _⟩ => by cases hr⟩

/-- Supposition 5 follows from supposition 4 read at EVERY moment (a past hell existence before each citta): it stands
    or falls with 4. -/
theorem t5_from_t4_everywhere (w : World)
    (h4 : ∀ t, w.citta t → ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ t)
    (h109 : a109_path_is_citta w) (a : Int) (ha : w.arahatta a) :
    ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ a :=
  h4 a (h109 a ha)

/-! ## A model of T3's hypotheses together (rubric item 3): they are jointly satisfiable, so T3 is not vacuous -/

theorem model_t3_hypotheses :
    ∃ w, c_predecessor w ∧ a3_successor w ∧ a58_lives_begin w ∧ w.citta w.now :=
  ⟨humanWorld, world_c _, world_a3 _, world_a58 _, trivial⟩

/-! ## Each of T3's hypotheses is NEEDED — a model of the other three in which T3's conclusion fails -/

/-- Without C: one citta, now, with no predecessor — and no life before it. -/
theorem needs_c_predecessor :
    ∃ w, a3_successor w ∧ a58_lives_begin w ∧ w.citta w.now ∧ ¬ ∀ b : Int, ∃ r, w.patisandhi r ∧ r < b := by
  refine ⟨⟨fun t => t = 0, fun _ _ => False, fun t => t = 0, fun _ => Destiny.manussa, fun _ => False, 0⟩,
    fun _ _ h => h.elim, fun t ht => ⟨t, ht, Int.le_refl t⟩, rfl, fun h => ?_⟩
  obtain ⟨r, hr, hlt⟩ := h 0
  exact absurd hlt (by show ¬ r < 0; omega_c)

/-- Without A3: the one citta is its own predecessor — a loop, not a past. -/
theorem needs_a3_successor :
    ∃ w, c_predecessor w ∧ a58_lives_begin w ∧ w.citta w.now ∧ ¬ ∀ b : Int, ∃ r, w.patisandhi r ∧ r < b := by
  refine ⟨⟨fun t => t = 0, fun p q => p = 0 ∧ q = 0, fun t => t = 0, fun _ => Destiny.manussa, fun _ => False, 0⟩,
    fun q hq => ⟨0, ⟨rfl, hq⟩, rfl⟩, fun t ht => ⟨t, ht, Int.le_refl t⟩, rfl, fun h => ?_⟩
  obtain ⟨r, hr, hlt⟩ := h 0
  exact absurd hlt (by show ¬ r < 0; omega_c)

/-- Without A58: a beginningless stream in which no existence ever begins. -/
theorem needs_a58_lives_begin :
    ∃ w, c_predecessor w ∧ a3_successor w ∧ w.citta w.now ∧ ¬ ∀ b : Int, ∃ r, w.patisandhi r ∧ r < b :=
  ⟨⟨fun _ => True, fun p q => q = p + 1, fun _ => False, fun _ => Destiny.manussa, fun _ => False, 0⟩,
    fun q _ => ⟨q - 1, show q = q - 1 + 1 by omega_c, trivial⟩, fun p q (h : q = p + 1) => by omega_c, trivial,
    fun h => (h 0).elim fun _ hr => hr.1⟩

/-- Without the being existing now: no citta at all, and no life. -/
theorem needs_now :
    ∃ w, c_predecessor w ∧ a3_successor w ∧ a58_lives_begin w ∧ ¬ ∀ b : Int, ∃ r, w.patisandhi r ∧ r < b :=
  ⟨⟨fun _ => False, fun _ _ => False, fun _ => False, fun _ => Destiny.manussa, fun _ => False, 0⟩,
    fun _ h => h.elim, fun _ _ h => h.elim, fun _ h => h.elim, fun h => (h 0).elim fun _ hr => hr.1⟩

end FormalAbhidhamma.Samsara
