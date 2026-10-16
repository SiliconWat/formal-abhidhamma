/-
  model/Mind.lean — the MIND part of the one World: a stream of mind-moments on a clock of sub-moments.
  For *The Calculus of Moments*, attempt 1 (Protocol 1 + correction 1, thonly/the-calculus-of-moments). A WORKING
  encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything.

  Every definition is named by its axiom ID (`kala/AXIOMS.md`, the rubric's naming rule) and is followed by its
  FORBIDDEN WORLD: a small stream its text rules out, on which Lean proves the definition false (Protocol 1 §7.2 — a
  definition with no forbidden world is `True` in disguise). `run.sh` replaces each definition with `True` and requires
  its forbidden-world theorem to FAIL (the planted-weakening control, Protocol 1 §9).

  Layers (Protocol 1 §5): A117 L1 · A3 L1 + L2 · C L1 (a join) + L2 · A1 L2 (a shared premise in the Kathāvatthu, L1) ·
  A40 L2 · A77 L4.
-/
namespace FormalAbhidhamma.Model

/-- The clock counts SUB-moments. It is a designation on the occurrences (A7: a number ON them, never one of them),
    and that every stream reads one clock is a DECLARED FREEDOM (Protocol 1 §7.6). -/
abbrev Tick := Int

/-- One stream (*santāna*), indexed by its own mind-moments. The INDEX is the stream's order and the CLOCK its time;
    A3 keeps the two apart ("no interval" is about order: across cessation the time gap is days, A112).
    `present i` — the stream has an i-th mind-moment · `start i` — the sub-moment at which it arises ·
    `span i` — how many sub-moments it lasts · `prox i j` — the i-th conditions the j-th by proximity (*anantara*). -/
structure Stream where
  present : Int → Bool
  start   : Int → Tick
  span    : Int → Int
  prox    : Int → Int → Bool

/-- A1 (L2; a premise both parties hold in Kv 2.5, L1): two cittas do not occur together (*dve cittāni ekato
    nappavattanti*). Encoded: two distinct mind-moments of one stream never share a sub-moment. -/
def a1_never_together (s : Stream) : Prop := ∀ i j, s.present i = true → s.present j = true → i ≠ j → s.start i + s.span i ≤ s.start j ∨ s.start j + s.span j ≤ s.start i

/-- A117 (L1, the Yamaka): a mind-moment has an arising-moment and a dissolution-moment, distinct — so at least two
    sub-moments. -/
def a117_arising_and_dissolution (s : Stream) : Prop := ∀ i, s.present i = true → 2 ≤ s.span i

/-- A40 (L2 first; L4): a mind-moment is three sub-moments, arising, standing, dissolution, and they are EQUAL (the
    Visuddhimagga) — on a clock that counts sub-moments, each mind-moment lasts exactly three. -/
def a40_three_equal (s : Stream) : Prop := ∀ i, s.present i = true → s.span i = 3

/-- A3 (L1 + L2): each mind-moment conditions its immediate successor by proximity, and "there is no interval between
    them" (*natthi etesaṃ antaraṃ*): no mind-moment of the stream arises between the two. Order, not time: the
    successor may arise much later on the clock (A112). -/
def a3_no_moment_between (s : Stream) : Prop := ∀ i, s.present i = true → s.present (i + 1) = true → s.prox i (i + 1) = true ∧ s.start i < s.start (i + 1) ∧ ∀ j, s.present j = true → ¬ (s.start i < s.start j ∧ s.start j < s.start (i + 1))

/-- C (L1 as a join; L2 states it): every citta has an immediate predecessor citta that conditions it by proximity
    (*na evaṃ anantaracittaṃ vinā cittassa uppatti nāma atthi*, Vism XVII). -/
def c_every_citta_has_a_proximate (s : Stream) : Prop := ∀ i, s.present i = true → s.present (i - 1) = true ∧ s.prox (i - 1) i = true

/-- A77 (L4, with L2 and L3 assertions): the round is beginningless (*anādikaṃ*): before any mind-moment of a stream
    there is an earlier one. (Weaker than C, and a separate row: the manual's conclusion is asserted elsewhere too.) -/
def a77_beginningless (s : Stream) : Prop := ∀ i, s.present i = true → ∃ j, j < i ∧ s.present j = true

/-! ## Forbidden worlds — one per definition. Each is a stream its text rules out. -/

/-- Two mind-moments arising together: moments 0 and 1 both at sub-moment 0. -/
def together : Stream := ⟨fun i => decide (0 ≤ i ∧ i ≤ 1), fun _ => 0, fun _ => 3, fun _ _ => true⟩

theorem a1_forbids_together : ¬ a1_never_together together := by
  intro h
  have := h 0 1 rfl rfl (by decide)
  simp [together] at this

/-- A mind-moment with one sub-moment only: no dissolution distinct from its arising. -/
def one_submoment : Stream := ⟨fun _ => true, fun i => i, fun _ => 1, fun _ _ => true⟩

theorem a117_forbids_one_submoment : ¬ a117_arising_and_dissolution one_submoment := by
  intro h
  have := h 0 rfl
  simp [one_submoment] at this

/-- Mind-moments of two sub-moments: the standing phase missing, or the three phases unequal. -/
def two_submoments : Stream := ⟨fun _ => true, fun i => 2 * i, fun _ => 2, fun _ _ => true⟩

theorem a40_forbids_two_submoments : ¬ a40_three_equal two_submoments := by
  intro h
  have := h 0 rfl
  simp [two_submoments] at this

/-- A mind-moment arising BETWEEN a moment and its successor: moments 0, 1 and 2 at sub-moments 0, 10 and 5. -/
def one_between : Stream := ⟨fun i => decide (0 ≤ i ∧ i ≤ 2), fun i => if i = 0 then 0 else if i = 1 then 10 else 5, fun _ => 3, fun _ _ => true⟩

theorem a3_forbids_one_between : ¬ a3_no_moment_between one_between := by
  intro h
  have := (h 0 rfl rfl).2.2 2 rfl
  simp [one_between] at this

/-- A stream with a first citta: nothing before moment 0. -/
def first_citta : Stream := ⟨fun i => decide (0 ≤ i), fun i => 3 * i, fun _ => 3, fun _ _ => true⟩

theorem c_forbids_first_citta : ¬ c_every_citta_has_a_proximate first_citta := by
  intro h
  have := (h 0 rfl).1
  simp [first_citta] at this

theorem a77_forbids_first_citta : ¬ a77_beginningless first_citta := by
  intro h
  obtain ⟨j, hj, hp⟩ := h 0 rfl
  simp [first_citta] at hp
  omega

end FormalAbhidhamma.Model
