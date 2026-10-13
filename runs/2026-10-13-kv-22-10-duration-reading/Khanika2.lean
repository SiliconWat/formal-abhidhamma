/-
  Kathāvatthu 22.10 on the DURATION reading, by each rule for WHERE MATTER MAY ARISE — the corrected run the first /prove run
  pointed to (founder 2026-10-13: "Approve all; do each in turn"), redesigned on its vetting. The statements are VERBATIM as registered (PREREG
  pushed 2026-10-13T21:51:14Z, OTS); the proofs, the witness worlds and the breaks came after. Graded under A388: every premise is a definition named by its axiom
  ID, each theorem's premise set is a `premises_` definition, the held-out answer is `answer_kv_22_10`.
  HELD OUT: A69, A4, Kv 22.10 §906 — and the commentarial SUPPORTING-BASE rule (Vism XX §700: a citta depends on a base that
  arose with the PREVIOUS citta and has reached standing), because it states the answer.
-/
namespace FormalAbhidhamma.Khanika2

/-- One stream of mind and matter on a clock of SUB-moments. `birth d`: the sub-moment at which `d` arises; `present d t`:
    `d` exists at sub-moment `t`; `pre e c`: `e` is the pre-nascent BASE of the five-sense consciousness `c`; `citta d`: `d`
    is a mind-moment. -/
structure World where
  Dhamma : Type
  birth : Dhamma → Int
  present : Dhamma → Int → Prop
  pre : Dhamma → Dhamma → Prop
  citta : Dhamma → Prop

/-! ## The premises, one definition per axiom (A388 OQ5) -/

/-- A117: a mind-moment has at least two sub-moments (the Yamaka's arising- and dissolution-moments). -/
def a117_two_submoments (k : Int) : Prop := 2 ≤ k

/-- A3 (with A117 and the Visuddhimagga's equal sub-moments): every citta arises at a mind-moment boundary, `n · k`. -/
def a3_stream (k : Int) (w : World) : Prop := ∀ c, w.citta c → ∃ n : Int, w.birth c = n * k

/-- A3 / A82: the consciousness has an IMMEDIATELY preceding citta, one mind-moment earlier. -/
def a3_predecessor (k : Int) (w : World) : Prop := ∀ e c, w.pre e c → ∃ p, w.citta p ∧ w.birth p = w.birth c - k

/-- A115: a sense consciousness — a citta — arises with a pre-nascent base. -/
def a115_occurs (w : World) : Prop := ∃ e c, w.pre e c ∧ w.citta c

/-- A87: the base was born BEFORE the consciousness it conditions. -/
def a87_purejata (w : World) : Prop := ∀ e c, w.pre e c → w.birth e < w.birth c

/-- A116: the consciousness ARISES in an unbroken base — the base is present when the consciousness arises. -/
def a116_unbroken_base (w : World) : Prop := ∀ e c, w.pre e c → w.present e (w.birth c)

/-- A103: nothing exists before it arises (the Dhammasaṅgaṇī: the future is unarisen). -/
def a103_not_before_birth (w : World) : Prop := ∀ d t, w.present d t → w.birth d ≤ t

/-- A121: every conditioned dhamma passes away — its presence is bounded. -/
def a121_passes_away (w : World) : Prop := ∀ d, ∃ T : Int, ∀ t, w.present d t → t < T

/-- A121: its arising is discernible — a dhamma exists at the sub-moment it arises. -/
def a121_arises (w : World) : Prop := ∀ d, w.present d (w.birth d)

/-- A119 (the Mūlaṭīkā): matter — the base — arises only at the ARISING sub-moment of some citta. -/
def a119_matter_at_arising (w : World) : Prop := ∀ e c, w.pre e c → ∃ p, w.citta p ∧ w.birth e = w.birth p

/-- A118 (the Yamaka read literally, `abh03m4.mul.xml:16337`): no base arises at the DISSOLUTION sub-moment — the last of
    its `k` — of any citta. -/
def a118_not_at_dissolution (k : Int) (w : World) : Prop := ∀ e c p, w.pre e c → w.citta p → w.birth e ≠ w.birth p + (k - 1)

/-! ## The view, and the held-out answer -/

/-- The view on the DURATION reading (a reconstruction: the recorded opponent concedes co-arising): every dhamma exists for
    exactly `k` sub-moments — one mind-moment's length — from its own arising. -/
def OneCittaLength (k : Int) (w : World) : Prop := ∀ d t, w.present d t ↔ (w.birth d ≤ t ∧ t < w.birth d + k)

/-- ANSWER: Kv 22.10 §906 — A69's content (matter outlasts a mind-moment) for a pre-nascent base; it implies the view's
    negation in one step, not the converse. -/
def answer_kv_22_10 (k : Int) (w : World) : Prop := ∃ e c t, w.pre e c ∧ w.present e t ∧ w.birth e + k ≤ t

/-! ## The premise sets (A388 OQ3) -/

def premises_common (k : Int) (w : World) : Prop :=
  a117_two_submoments k ∧ a3_stream k w ∧ a3_predecessor k w ∧ a115_occurs w ∧ a87_purejata w ∧
    a116_unbroken_base w ∧ a103_not_before_birth w ∧ a121_passes_away w ∧ a121_arises w

def premises_t1 (k : Int) (w : World) : Prop := premises_common k w ∧ a119_matter_at_arising w
def premises_t2 (k : Int) (w : World) : Prop := premises_common k w ∧ a118_not_at_dissolution k w
def premises_t3 (k : Int) (w : World) : Prop := premises_common k w


/-- `omega` closes a goal that is not `False` by CLASSICAL contradiction, which made the first version of these witnesses
    classical for no mathematical reason (tools/Uses.lean, 2026-10-13). For a DECIDABLE goal, `Decidable.byContradiction` is
    constructive, and `omega` is then asked only to close `False` — after a conjunction is split, because `omega` reasons
    from a negated conjunction classically (probed: `a ≤ b ∧ c < d` went classical, each half alone did not). -/
syntax "omega_c" : tactic
macro_rules
  | `(tactic| omega_c) => `(tactic| first
      | (apply And.intro <;> omega_c)
      | exact Decidable.byContradiction fun _h => by omega)

/-! ## Witness worlds: an adverting citta `p` (born 0), a base `e` (born `be`), an eye-consciousness `c` (born `k`) -/

inductive D | p | e | c
  deriving DecidableEq

def bornAt (k be : Int) : D → Int
  | .p => 0
  | .e => be
  | .c => k

def tri (k be : Int) (life : D → Int → Prop) : World where
  Dhamma := D
  birth := bornAt k be
  present := life
  pre := fun x y => x = .e ∧ y = .c
  citta := fun x => x = .p ∨ x = .c

/-- The view's own life: each dhamma exists exactly `k` sub-moments from its birth. -/
def viewLife (k be : Int) : D → Int → Prop := fun d t => bornAt k be d ≤ t ∧ t < bornAt k be d + k

/-- A life that is NOT the view's, and in which the answer is FALSE: the two cittas exist only at their arising, the base
    exactly `k` sub-moments from its own (so no base outlasts a mind-moment). -/
def shortLife (k be : Int) : D → Int → Prop
  | .e, t => be ≤ t ∧ t < be + k
  | d, t => t = bornAt k be d

theorem tri_common (k be : Int) (life : D → Int → Prop) (hk : 2 ≤ k) (hb : be < k)
    (hlife : ∀ d t, life d t → bornAt k be d ≤ t ∧ t < bornAt k be d + k)
    (hat : ∀ d, life d (bornAt k be d)) (hbase : life .e k) : premises_common k (tri k be life) := by
  refine ⟨hk, ?_, ?_, ⟨.e, .c, ⟨rfl, rfl⟩, Or.inr rfl⟩, ?_, ?_, ?_, ?_, ?_⟩
  · rintro x (rfl | rfl)
    · exact ⟨0, by simp [tri, bornAt]⟩
    · exact ⟨1, by simp [tri, bornAt]⟩
  · rintro x y ⟨rfl, rfl⟩; exact ⟨.p, Or.inl rfl, by simp [tri, bornAt]⟩
  · rintro x y ⟨rfl, rfl⟩; show be < k; exact hb
  · rintro x y ⟨rfl, rfl⟩; exact hbase
  · intro d t h; exact (hlife d t h).1
  · intro d; exact ⟨bornAt k be d + k, fun t h => (hlife d t h).2⟩
  · intro d; exact hat d

theorem viewLife_ok (k be : Int) (hk : 2 ≤ k) (h0 : 0 < be) (hb : be < k) :
    premises_common k (tri k be (viewLife k be)) ∧ OneCittaLength k (tri k be (viewLife k be)) := by
  refine ⟨tri_common k be _ hk hb (fun d t h => h) (fun d => ⟨Int.le_refl _, by omega_c⟩) ?_, fun d t => Iff.rfl⟩
  show be ≤ k ∧ k < be + k; omega_c

theorem shortLife_ok (k be : Int) (hk : 2 ≤ k) (h0 : 0 < be) (hb : be < k) :
    premises_common k (tri k be (shortLife k be)) ∧ ¬ OneCittaLength k (tri k be (shortLife k be)) := by
  refine ⟨tri_common k be _ hk hb ?_ ?_ ?_, fun hv => ?_⟩
  · intro d t h; cases d <;> simp only [shortLife, bornAt] at h ⊢ <;> omega_c
  · intro d; cases d <;> simp only [shortLife, bornAt] <;> omega_c
  · show be ≤ k ∧ k < be + k; omega_c
  · have := (hv .p 1).mpr (by show bornAt k be .p ≤ 1 ∧ 1 < bornAt k be .p + k; simp only [bornAt]; omega_c)
    simp only [tri, shortLife, bornAt] at this; omega

theorem shortLife_no_answer (k be : Int) : ¬ answer_kv_22_10 k (tri k be (shortLife k be)) := by
  rintro ⟨x, y, t, ⟨rfl, rfl⟩, hpres, hge⟩
  simp only [tri, shortLife, bornAt] at hpres hge; omega

/-- At three sub-moments, a base born at the predecessor's STANDING sub-moment (1) is never at a citta's dissolution
    sub-moment: the cittas arise at 0 and 3, so their dissolutions are 2 and 5. -/
theorem standing_base_not_at_dissolution (life : D → Int → Prop) : a118_not_at_dissolution 3 (tri 3 1 life) := by
  rintro x y q ⟨rfl, rfl⟩ (rfl | rfl) <;> simp [tri, bornAt]

/-! ## The theorems -/

/-- T1 (the Mūlaṭīkā's line). If matter arises only at a citta's arising sub-moment, the eye-base premises refute the
    duration view, for every number of sub-moments to a mind-moment. -/
theorem t1_mulatika_line_refutes (k : Int) (w : World) (h : premises_t1 k w) : ¬ OneCittaLength k w := by
  intro hv
  obtain ⟨⟨hk, hstream, _, ⟨e, c, hp, hc⟩, h87, h116, _, _, _⟩, h119⟩ := h
  obtain ⟨p, hpc, hpe⟩ := h119 e c hp
  obtain ⟨n, hn⟩ := hstream p hpc
  obtain ⟨m, hm⟩ := hstream c hc
  have he : w.birth e = n * k := hpe.trans hn
  have hlt := h87 e c hp
  have hpres := ((hv e (w.birth c)).mp (h116 e c hp)).2
  rw [he, hm] at hlt
  rw [he, hm] at hpres
  unfold a117_two_submoments at hk
  have h1 : n < m := Int.lt_of_mul_lt_mul_right hlt (by omega)
  have h2 : m * k < (n + 1) * k := by rw [Int.add_mul, Int.one_mul]; exact hpres
  have h3 : m < n + 1 := Int.lt_of_mul_lt_mul_right h2 (by omega)
  omega

/-- T2 (the PIṬAKA cell: the Yamaka read literally, the number of sub-moments left as the Piṭaka leaves it). With two
    sub-moments to a mind-moment the eye-base premises refute the duration view; with three they do not settle it. -/
theorem t2_pitaka_cell_turns_on_the_count :
    (∀ w, premises_t2 2 w → ¬ OneCittaLength 2 w) ∧
    (∃ w, premises_t2 3 w ∧ OneCittaLength 3 w) ∧ (∃ w, premises_t2 3 w ∧ ¬ OneCittaLength 3 w) := by
  refine ⟨?_, ?_, ?_⟩
  · intro w h hv
    obtain ⟨⟨_, _, hpred, ⟨e, c, hp, _⟩, h87, h116, _, _, _⟩, h118⟩ := h
    obtain ⟨p, hpc, hpb⟩ := hpred e c hp
    have hlt := h87 e c hp
    have hpres := ((hv e (w.birth c)).mp (h116 e c hp)).2
    have hne := h118 e c p hp hpc
    omega
  · have h := viewLife_ok 3 1 (by decide) (by decide) (by decide)
    exact ⟨_, ⟨h.1, standing_base_not_at_dissolution _⟩, h.2⟩
  · have h := shortLife_ok 3 1 (by decide) (by decide) (by decide)
    exact ⟨_, ⟨h.1, standing_base_not_at_dissolution _⟩, h.2⟩

/-- T3 (A120's permission ALONE — matter may arise at any sub-moment — with the commentarial supporting-base rule held out).
    For every number `k ≥ 2` of sub-moments, the eye-base premises do not settle the duration view. -/
theorem t3_permission_alone_open (k : Int) (hk : a117_two_submoments k) :
    (∃ w, premises_t3 k w ∧ OneCittaLength k w) ∧ (∃ w, premises_t3 k w ∧ ¬ OneCittaLength k w) := by
  unfold a117_two_submoments at hk
  have h0 : (0 : Int) < k - 1 := by omega_c
  have hb : k - 1 < k := by omega_c
  exact ⟨⟨_, viewLife_ok k (k - 1) hk h0 hb⟩, ⟨_, shortLife_ok k (k - 1) hk h0 hb⟩⟩

end FormalAbhidhamma.Khanika2
