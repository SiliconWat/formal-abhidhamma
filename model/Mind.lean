/-
  model/Mind.lean — the MIND part of the one World: a stream of mind-moments on a clock.
  For *The Calculus of Moments*, attempt 1 (Protocol 1, correction 1 and amendment 1, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model of anything.

  ⭐ Amendment 1 (founder 2026-10-15, "approve all") asks whether the axioms FORCE a stream to be discrete (Q1), and
  whether they allow a non-standard stream, with infinitely many moments between two of its own (Q2). So nothing here
  assumes either: a stream's moments are an ARBITRARY type, and the clock is ANY ordered scale (whole numbers, rationals,
  or a non-standard scale are all instances — Q3). The first encoding (`c59fff2`) indexed moments by the integers, which
  made Q1 and Q2 true by construction; it is replaced.

  Every definition is named by its axiom ID (`kala/AXIOMS.md`) and is followed by its FORBIDDEN WORLD: a small stream its
  text rules out, on which Lean proves the definition false (Protocol 1 §7.2). `run.sh` weakens each definition to
  `True` and requires its forbidden-world theorem to FAIL (Protocol 1 §9).

  Layers (Protocol 1 §5): A117 L1 · A3 L1 + L2 · C L1 (a join) + L2 · A1 L2 (a premise both parties hold in Kv 2.5, L1) ·
  A40 L2 · A77 L4.
-/
namespace FormalAbhidhamma.Model

/-- A clock scale: what a clock's readings can be. ⚠️ Its laws are OURS — the meaning of "a clock" (a strict total
    order with an addition that respects it) — never axioms of the texts. Which scale a model uses is a declared freedom
    (amendment 1, Q3). Time itself is a designation on what occurs (A7): a reading ON the moments, never a moment. -/
structure Scale where
  T : Type
  lt : T → T → Prop
  add : T → T → T
  zero : T
  lt_irrefl : ∀ a, ¬ lt a a
  lt_trans : ∀ a b c, lt a b → lt b c → lt a c
  lt_total : ∀ a b, lt a b ∨ a = b ∨ lt b a
  add_assoc : ∀ a b c, add (add a b) c = add a (add b c)
  add_comm : ∀ a b, add a b = add b a
  add_zero : ∀ a, add a zero = a
  add_lt_left : ∀ a b c, lt b c → lt (add a b) (add a c)

/-- The whole-number scale, used by the forbidden worlds below (one instance among many; nothing requires it). -/
abbrev Z : Scale where
  T := Int
  lt := fun a b => a < b
  add := fun a b => a + b
  zero := 0
  lt_irrefl := fun a h => Int.lt_irrefl a h
  lt_trans := fun _ _ _ h₁ h₂ => Int.lt_trans h₁ h₂
  lt_total := fun a b => Int.lt_trichotomy a b
  add_assoc := Int.add_assoc
  add_comm := Int.add_comm
  add_zero := Int.add_zero
  add_lt_left := fun a _ _ h => Int.add_lt_add_left h a

/-- One stream (*santāna*): its mind-moments `M` (any type at all), the clock readings of each moment's arising,
    standing and dissolution sub-moments and of its close, and `prox m n` — m conditions n by proximity (*anantara*).
    The ORDER of the stream is read from the clock; A3 says what proximity is in that order. -/
structure Stream (S : Scale) where
  M : Type
  arise : M → S.T
  stand : M → S.T
  dissolve : M → S.T
  close : M → S.T
  prox : M → M → Prop

/-- A1 (L2; a premise both parties hold in Kv 2.5, L1): two cittas do not occur together (*dve cittāni ekato
    nappavattanti*). Encoded: two distinct mind-moments of one stream never overlap on the clock. -/
def a1_never_together (S : Scale) (s : Stream S) : Prop := ∀ m n, m ≠ n → ¬ S.lt (s.arise n) (s.close m) ∨ ¬ S.lt (s.arise m) (s.close n)

/-- A117 (L1, the Yamaka): a mind-moment has an arising-moment and a dissolution-moment, and they are distinct: its
    dissolution comes after its arising, and it closes after its dissolution begins. -/
def a117_arising_and_dissolution (S : Scale) (s : Stream S) : Prop := ∀ m, S.lt (s.arise m) (s.dissolve m) ∧ S.lt (s.dissolve m) (s.close m)

/-- A40 (L2 first; L4): a mind-moment is three sub-moments, arising, standing and dissolution, and they are EQUAL (the
    Visuddhimagga): one positive length d carries arising to standing, standing to dissolution, and dissolution to the
    close. -/
def a40_three_equal (S : Scale) (s : Stream S) : Prop := ∀ m, ∃ d, S.lt S.zero d ∧ s.stand m = S.add (s.arise m) d ∧ s.dissolve m = S.add (s.stand m) d ∧ s.close m = S.add (s.dissolve m) d

/-- A3 (L1 + L2): each mind-moment conditions its immediate successor by proximity, and "there is no interval between
    them" (*natthi etesaṃ antaraṃ*). Encoded both ways: m conditions n by proximity exactly when n arises after m and no
    moment of the stream arises between them. Order, not time: the clock may show any gap (A112). -/
def a3_no_moment_between (S : Scale) (s : Stream S) : Prop := ∀ m n, s.prox m n ↔ (S.lt (s.arise m) (s.arise n) ∧ ∀ k, ¬ (S.lt (s.arise m) (s.arise k) ∧ S.lt (s.arise k) (s.arise n)))

/-- C (L1 as a join; L2 states it): every citta has an immediate predecessor citta that conditions it by proximity
    (*na evaṃ anantaracittaṃ vinā cittassa uppatti nāma atthi*, Vism XVII). -/
def c_every_citta_has_a_proximate (S : Scale) (s : Stream S) : Prop := ∀ n, ∃ m, s.prox m n

/-- A77 (L4, with L2 and L3 assertions): the round is beginningless (*anādikaṃ*): before any mind-moment of a stream,
    an earlier one arises. -/
def a77_beginningless (S : Scale) (s : Stream S) : Prop := ∀ n, ∃ m, S.lt (s.arise m) (s.arise n)

/-! ## Forbidden worlds — one per definition, each a stream its text rules out (on the whole-number scale). -/

/-- Two mind-moments arising together, both over the sub-moments 0 to 3. -/
abbrev together : Stream Z := ⟨Bool, fun _ => (0 : Int), fun _ => (1 : Int), fun _ => (2 : Int), fun _ => (3 : Int), fun _ _ => False⟩

theorem a1_forbids_together : ¬ a1_never_together Z together := by
  intro h
  rcases h true false (by decide) with h' | h' <;> exact h' (by show (0 : Int) < 3; decide)

/-- A mind-moment whose dissolution is its arising: no dissolution-moment distinct from the arising-moment. -/
abbrev one_submoment : Stream Z := ⟨Unit, fun _ => (0 : Int), fun _ => (0 : Int), fun _ => (0 : Int), fun _ => (1 : Int), fun _ _ => False⟩

theorem a117_forbids_one_submoment : ¬ a117_arising_and_dissolution Z one_submoment := by
  intro h
  exact absurd (h ()).1 (by show ¬ ((0 : Int) < 0); decide)

/-- A mind-moment whose sub-moments are unequal: standing after one unit, dissolution two units later. -/
abbrev unequal : Stream Z := ⟨Unit, fun _ => (0 : Int), fun _ => (1 : Int), fun _ => (3 : Int), fun _ => (4 : Int), fun _ _ => False⟩

theorem a40_forbids_unequal : ¬ a40_three_equal Z unequal := by
  intro h
  obtain ⟨d, _, h₁, h₂, _⟩ := h ()
  have e₁ : (1 : Int) = 0 + d := h₁
  have e₂ : (3 : Int) = 1 + d := h₂
  omega

/-- Moment 1 called the proximate successor of moment 0, though moment 2 arises between them (at 5, between 0 and 10). -/
abbrev one_between : Stream Z := ⟨Nat, fun n => if n = 0 then (0 : Int) else if n = 1 then 10 else 5, fun _ => (0 : Int), fun _ => (0 : Int), fun _ => (0 : Int), fun m n => m = 0 ∧ n = 1⟩

theorem a3_forbids_one_between : ¬ a3_no_moment_between Z one_between := by
  intro h
  have := ((h 0 1).mp ⟨rfl, rfl⟩).2 2
  exact this ⟨by show (0 : Int) < 5; decide, by show (5 : Int) < 10; decide⟩

/-- A stream with a first citta: moments 0, 1, 2, … and nothing before moment 0. -/
abbrev first_citta : Stream Z := ⟨Nat, fun n => (3 * n : Int), fun n => (3 * n + 1 : Int), fun n => (3 * n + 2 : Int), fun n => (3 * n + 3 : Int), fun m n => n = m + 1⟩

theorem c_forbids_first_citta : ¬ c_every_citta_has_a_proximate Z first_citta := by
  intro h
  obtain ⟨m, hm⟩ := h 0
  exact absurd hm (by show ¬ (0 = m + 1); omega)

theorem a77_forbids_first_citta : ¬ a77_beginningless Z first_citta := by
  intro h
  obtain ⟨m, hm⟩ := h 0
  have : (3 * m : Int) < 3 * (0 : Nat) := hm
  omega

end FormalAbhidhamma.Model
