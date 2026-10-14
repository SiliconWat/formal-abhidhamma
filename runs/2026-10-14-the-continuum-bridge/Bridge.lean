/-
  The continuum bridge (PREREG pushed 2026-10-14T15:40:28Z; OTS-stamped). Window both; axioms A1, A3, A4, A5, A7, A8, A9,
  A24, A40, A61, A64, A66, A67, A70, A104, A112, A113, A117, A126, A127, A128, A129. Survivors only, in the refuter's
  narrowed forms (REFUTER.md). NOT DERIVATIONS here: every comparison with a measurement (Γ_Z, Rutherford 1911,
  Hofstadter 1956, Pohl 2010, the gold nucleus); only their arithmetic is checked. D1 is a KNOWN answer, checked in
  `runs/2026-09-30-order-without-a-gap/Gap.lean` (`d1_count_is_not_the_day`) and not repeated.
-/
namespace FormalAbhidhamma.Bridge

/-! ## D2 — santati is the gaplessness of a DISCRETE series (the density theorem) -/

/-- A relation is dense when between any two related points there is a third. -/
def Dense {α : Type} (lt : α → α → Prop) : Prop := ∀ a b, lt a b → ∃ c, lt a c ∧ lt c b

/-- `b` immediately succeeds `a`: nothing lies between (A3's *natthi etesaṃ antaraṃ*). -/
def ImmSucc {α : Type} (lt : α → α → Prop) (a b : α) : Prop := lt a b ∧ ¬ ∃ c, lt a c ∧ lt c b

/-- D2. In a dense order nothing has an immediate successor. -/
theorem d2_dense_has_no_successor {α : Type} (lt : α → α → Prop) (h : Dense lt) (a b : α) :
    ¬ ImmSucc lt a b :=
  fun ⟨hab, hno⟩ => hno (h a b hab)

/-- D2, corollary. If every citta has an immediate successor (A3, with A1's one-at-a-time), the stream's order is not
    dense. ⚠️ The refuter (F-H): that *santati* PRESUPPOSES such a series is a READING for mind (supported by the
    Dhammasaṅgaṇī-mūlaṭīkā `abh01t.tik.xml:681`, *nirantaratāya ekībhūtānamiva*); for MATTER the anuṭīkā denies the
    proximity relation (`abh02t.tik.xml:4921`), so this corollary is about the mental stream only. -/
theorem d2_proximity_forbids_density {α : Type} (lt : α → α → Prop) (s : α → α) (m₀ : α)
    (a3 : ∀ m, ImmSucc lt m (s m)) : ¬ Dense lt :=
  fun h => d2_dense_has_no_successor lt h m₀ (s m₀) (a3 m₀)

/-- Non-vacuity for D2: the integers with successor `+1` satisfy A3. -/
theorem d2_model (m : Int) : ImmSucc (fun a b : Int => a < b) m (m + 1) := by
  show m < m + 1 ∧ ¬ ∃ c, m < c ∧ c < m + 1
  refine ⟨by omega, ?_⟩
  intro ⟨c, h1, h2⟩
  omega

/-! ## D3 — BY CONSTRUCTION: the inner rows say nothing of matter -/

/-- D3, ⚠️ BY CONSTRUCTION (narrowed by the refuter, F-E). The rows that quantify only over cittas, sub-moments and
    designations (A1, A3, A7, A24, A104, A112, A117, A126–A128) mention no matter, so any matter structure, a dense one
    included, is compatible with them. This records a fact about the SIGNATURE, not a derivation. It does NOT hold of the
    declared set as a whole: A4, A40's Vism XX clause (`e0102n.mul.xml:6029`), A64 and A66 are bridges that put matter's
    births and lives on the stream's sub-moments. -/
theorem d3_inner_rows_say_nothing_of_matter (Inner MatterDense : Prop) (hi : Inner) (hm : MatterDense) :
    Inner ∧ MatterDense :=
  ⟨hi, hm⟩

/-! ## D4 — matter's life, and what a measurement can bound (corrected by the refuter, F-C) -/

/-- D4. A kalāpa lives 17 mind-moments (A4) of three sub-moments (A40): 51 sub-moments (stated by the Vibhāvinī,
    `abh07t.nrf.xml:4837`). -/
theorem d4_life_in_submoments (mm sub : Nat) (a4 : mm = 17) (a40 : sub = 3) : mm * sub = 51 := by
  subst a4; subst a40; rfl

/-- D4, corrected. Temperature produces at the producer's STANDING phase (A64, `abh07t.nrf.xml:2213`), one sub-moment
    after its arising, so the earliest change a santati can show is one sub-moment ε, not its first member's life 51ε.
    A measured upper bound T on the earliest change (ħ/Γ_Z ≈ 2.64×10⁻²⁵ s if the Z is a santati — OURS, NOT A DERIVATION)
    bounds ε only. -/
theorem d4_bound_is_one_submoment (ε d T : Nat) (earliest : d = ε) (meas : d ≤ T) : ε ≤ T := by
  omega

/-- The agent's stronger bound (51ε ≤ T) does not follow from the same premises. -/
theorem d4_the_stronger_bound_does_not_follow : ∃ ε T : Nat, 0 < ε ∧ ε ≤ T ∧ ¬ 51 * ε ≤ T :=
  ⟨1, 1, by omega, by omega, by omega⟩

/-! ## D5 — the packing bound, on the EMBEDDING reading (one dimension) -/

/-- Kalāpas of extent `c` placed along a line at increasing positions; co-present kalāpas do not pervade one another
    (A5, Vibhāvinī `abh07t.nrf.xml:5821`), so each next one starts at least `c` further on. The embedding reading
    (kalāpas have extent) is favored by the refuter (F-F: R10 `e0104n.att.xml:3573`; the Mahāṭīkā's *saviggahā*,
    `e0103n.att.xml:6261`); one dimension is OURS. -/
def Spaced (c : Nat) : List Nat → Prop
  | a :: b :: t => a + c ≤ b ∧ Spaced c (b :: t)
  | _ => True

theorem spaced_tail (c : Nat) (a : Nat) (t : List Nat) (h : Spaced c (a :: t)) : Spaced c t := by
  match t, h with
  | [], _ => trivial
  | _ :: _, h => exact h.2

theorem spaced_head_le (c : Nat) : ∀ (a : Nat) (t : List Nat), Spaced c (a :: t) → ∀ x ∈ t, a + c ≤ x
  | _, [], _, _, hx => by cases hx
  | a, b :: t, h, x, hx => by
      have hab : a + c ≤ b := h.1
      cases hx with
      | head => exact hab
      | tail _ hx' =>
        have := spaced_head_le c b t h.2 x hx'
        omega

/-- D5. In a region [lo, hi], non-pervading kalāpas of extent `c` number at most (hi − lo)/c: a finite count per region
    (AGREES in form with atomism; not distinguishing). -/
theorem d5_packing (c : Nat) : ∀ (l : List Nat) (lo hi : Nat), lo ≤ hi → Spaced c l →
    (∀ x ∈ l, lo ≤ x) → (∀ x ∈ l, x + c ≤ hi) → lo + l.length * c ≤ hi
  | [], _, _, hle, _, _, _ => by simp; omega
  | a :: t, lo, hi, _, hs, hlo, hhi => by
      have ha : lo ≤ a := hlo a (List.mem_cons_self ..)
      have hac : a + c ≤ hi := hhi a (List.mem_cons_self ..)
      have ih := d5_packing c t (a + c) hi hac (spaced_tail c a t hs) (spaced_head_le c a t hs)
        (fun x hx => hhi x (List.mem_cons_of_mem _ hx))
      rw [List.length_cons, Nat.succ_mul]
      omega

/-- Non-vacuity for D5: three kalāpas of extent 2 at 0, 2, 4 fill [0, 6]. -/
theorem d5_model : Spaced 2 [0, 2, 4] ∧ 0 + [0, 2, 4].length * 2 ≤ 6 := by
  refine ⟨⟨by omega, by omega, trivial⟩, by decide⟩

/-! ## D6 — 51 present, 49 standing (narrowed by the refuter, F-I/F-J) -/

/-- A group born at sub-moment `i` is present at `t` from its arising to its dissolution, i + 50 (A4 × A40). -/
def present (t i : Int) : Prop := i ≤ t ∧ t ≤ i + 50

/-- ... and at its standing phase strictly between the two. -/
def standing (t i : Int) : Prop := i < t ∧ t < i + 50

/-- D6. With a group born at every sub-moment (A64 *khaṇe khaṇe*; A120's commentarial line), the groups present at `t`
    are exactly those born in [t − 50, t] (51), those standing exactly those born in [t − 49, t − 1] (49). The step from
    51 present to 49 standing is OURS; it matches the Vibhāvinī's 49 (`abh07t.nrf.xml:4837`) and the
    Abhidhammāvatāra-ṭīkā's 49 kalāpas (`abh08t.nrf.xml:7373`). -/
theorem d6_present_window (t i : Int) : present t i ↔ t - 50 ≤ i ∧ i ≤ t := by
  unfold present; omega

theorem d6_standing_window (t i : Int) : standing t i ↔ t - 49 ≤ i ∧ i ≤ t - 1 := by
  unfold standing; omega

def presentN (t i : Nat) : Bool := i ≤ t && t ≤ i + 50
def standingN (t i : Nat) : Bool := i < t && t < i + 50

/-- The counts, computed at t = 100. -/
theorem d6_counts_at_100 :
    ((List.range 200).filter (presentN 100)).length = 51 ∧
    ((List.range 200).filter (standingN 100)).length = 49 := by
  decide

/-! ## D7 — extent: the Mahāṭīkā's size for one kalāpa collides (narrowed and strengthened by the refuter, F-B) -/

/-- A129's ladder: 7³ · 36⁴ paramāṇu to one aṅgula. -/
theorem d7_ladder : 7 ^ 3 * 36 ^ 4 = 576108288 := by decide

/-- Sizes on OUR anchor, an aṅgula of at least 1.7 cm = 17 × 10¹² fm. A paramāṇu is at least 29,508 fm. A kalāpa of
    1/49 its VOLUME (the Anudīpanī's 49 read as volume — OURS) is at least a quarter of that across (4³ = 64 > 49), at
    least 7,000 fm; read LINEARLY, at least 600 fm. -/
theorem d7_sizes : 17 * 10 ^ 12 / 576108288 = 29508 ∧ 29508 / 4 ≥ 7000 ∧ 29508 / 49 ≥ 600 := by decide

/-- The ratios, as corrected by the refuter: against Rutherford's 34 fm (fetched) about 200× on the volume reading and
    17× on the linear; against the proton's 0.84 fm (in hundredths) over 700× on the linear. NOT DERIVATIONS — the
    measured lengths are premises. -/
theorem d7_ratios : 7000 / 34 ≥ 200 ∧ 600 / 34 ≥ 17 ∧ 60000 / 84 ≥ 700 := by decide

/-- D7, the refuter's COUNT form (F-B(v)). On the Mahāṭīkā's identification a kalāpa is the minimal individuated unit
    of matter (A66) with eight members (the pure octad); whatever is individuated inside one is one of its members. A gold
    nucleus (≈ 7 fm, a measurement — NOT A DERIVATION) lies wholly inside one kalāpa of ≥ 600 fm on every reading above and
    has 197 individuated nucleons. Ledi's own bound (kalāpa ≤ paramāṇu/49, no lower size) escapes this: it gives no size. -/
theorem d7_count_collision (members inside : Nat) (octad : members = 8) (each_a_member : inside ≤ members)
    (gold : inside = 197) : False := by
  omega

/-- Non-vacuity for D7's first two premises: a kalāpa with its eight members. -/
theorem d7_model : ∃ m i : Nat, m = 8 ∧ i ≤ m := ⟨8, 8, rfl, Nat.le_refl _⟩

/-! ## D8 — a product never arises in its producer's place (narrowed by the refuter, F-G) -/

/-- D8. A product is co-present with its producer (A64: produced at the producer's standing phase) and co-present
    kalāpas do not pervade one another (A5), so the product's place differs from the producer's. CONSECUTIVE generations
    only. -/
theorem d8_product_moves {K P : Type} (place : K → P) (copresent : K → K → Prop)
    (a5 : ∀ p q, copresent p q → p ≠ q → place p ≠ place q) (p q : K) (a64 : copresent p q) (hne : p ≠ q) :
    place q ≠ place p :=
  fun h => a5 p q a64 hne h.symm

/-- The narrowing: generation g at site g mod 2. Consecutive generations differ in place, yet generations 0 and 2 share
    a site and the occupied set is constant, so "no lineage at rest" holds of consecutive generations only. -/
theorem d8_period_two (g : Int) : g % 2 ≠ (g + 1) % 2 ∧ (0 : Int) % 2 = 2 % 2 := by
  omega

end FormalAbhidhamma.Bridge
