/-
  Breath in the unconscious — a CONTROL (PREREG pushed 2026-10-01T05:13:01Z; OTS-stamped). Window A0; axioms A47, A64,
  A111, A114, plus readings the agent ADDED (the closure of the seven cases; the swoon's javanas, found by the refuter).
  Survivors only. D4 (the collision with breathing in syncope, coma, the vegetative state, anaesthesia) and D6 (the womb)
  are comparisons with measurements: NOT DERIVATIONS, so not here.
-/
namespace FormalAbhidhamma.Breath

inductive St where
  | awake | asleep | womb | submerged | swoon | jhana4 | cessation | dead
  deriving DecidableEq, Repr

/-- The seven cases without breath (A114; Vism VIII `e0101n.mul.xml:6717`), with *asaññībhūta* on the ṭīkās' swoon
    reading (`e0103n.att.xml:4829`). The fine-material and immaterial beings are left out: not living humans. -/
def L : List St := [.womb, .submerged, .swoon, .jhana4, .cessation, .dead]

/-- D1. A114 with its closure (ADDED: the seven cases are exhaustive — Vism-ṭīkā `:4829`, Sāratthadīpanī `vin01t2.tik.xml:3281`)
    ⇒ the swooned do not breathe and sleepers do. -/
theorem d1_swoon_breathless_sleep_breathes (B : St → Prop)
    (a114 : ∀ s, s ∈ L → ¬ B s) (closure : ∀ s, s ∉ L → B s) : ¬ B .swoon ∧ B .asleep :=
  ⟨a114 _ (by decide), closure _ (by decide)⟩

/-- Non-vacuity for D1: a model satisfying both hypotheses. -/
theorem d1_model : (∀ s, s ∈ L → ¬ (s = .awake ∨ s = .asleep)) ∧ (∀ s, s ∉ L → (s = .awake ∨ s = .asleep)) := by
  constructor <;> intro s <;> cases s <;> decide

/-- D2. Dhammapāla's grouping read broadly (M1b: in a swoon no matter-producing citta occurs) against the texts' own
    report that javanas run in a swoon (Vism-ṭīkā `e0104n.att.xml:1665`, *suttamucchitādikāle hi pañcapi javanāni
    javanti*; the refuter's finding) and A64 (those javanas produce mind-born matter): a living swooned person is impossible. -/
theorem d2_broad_reading_contradicts (Citta : Type) (occurs : Citta → Prop) (MP : Citta → Prop)
    (javana_runs : ∃ c, occurs c ∧ MP c) (m1b : ∀ c, occurs c → ¬ MP c) : False := by
  obtain ⟨c, ho, hm⟩ := javana_runs
  exact m1b c ho hm

/-- D3 (as narrowed by the refuter). Breath is not a function of which citta types occur: a swoon has the bhavaṅga
    sleep has (A51) and more (its javanas), yet the swooned do not breathe and sleepers do (D1). So no rule "breathes iff
    some occurring citta has a breath-producing type" fits — the texts' own extra variable is the base's weakness
    (*vatthudubbalatā*, Vibhāvinī `abh07t.nrf.xml:5081`), a material quantity. -/
theorem d3_not_a_function_of_type (T : Type) (types : St → List T) (g : T → Bool) (B : St → Prop)
    (rule : ∀ s, B s ↔ ∃ t ∈ types s, g t = true)
    (hsub : ∀ t, t ∈ types .asleep → t ∈ types .swoon)
    (a114 : ∀ s, s ∈ L → ¬ B s) (closure : ∀ s, s ∉ L → B s) : False := by
  have ⟨hsw, hsl⟩ := d1_swoon_breathless_sleep_breathes B a114 closure
  obtain ⟨t, ht, hg⟩ := (rule .asleep).mp hsl
  exact hsw ((rule .swoon).mpr ⟨t, hsub t ht, hg⟩)

/-- D5. A warm breathless body (A111 via MN 43: heat not subsided; A114: no breath in cessation) with no non-oxidative
    heat (Pk = 0) can be held warm only while its O₂ store and anaerobic budget last. Joules and watts as naturals. The
    figures are OURS / textbook, refuter-checked in kind: O₂ store ≈ 2 L × 20 kJ/L = 40 kJ; anaerobic ≤ 300 kJ.
    Conclusion: across seven days (604,800 s) the body may lose NO whole watt of heat — so either a non-oxidative heat
    source of the size of its heat loss (the texts name kamma-born fire, `e0103n.att.xml:6249`), or ambient = body heat. -/
theorem d5_seven_days_needs_nonoxidative_heat (Ploss Pk aer an : Nat)
    (balance : Ploss * 604800 ≤ aer + an + Pk * 604800) (pk : Pk = 0)
    (o2 : aer ≤ 40000) (anaer : an ≤ 300000) : Ploss = 0 := by
  subst pk; omega

end FormalAbhidhamma.Breath
