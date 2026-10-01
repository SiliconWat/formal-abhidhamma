/-
  The shape of conditioning (PREREG pushed 2026-10-01T05:13:47Z; OTS-stamped). Window both; axioms A3, A78, A80, A82, A83,
  A84, A87, A88, A90, A99, A100, A112. Survivors only. D1 survives as a READING (Ledi `e0501n.nrf.xml:977`: external matter
  conditions external matter only co-nascently) and D6–D7 as readings or philosophy; they are not here.
-/
namespace FormalAbhidhamma.Shape

/-- An event: a dhamma exercising a condition at a moment, and whether it is mental. -/
structure Ev where
  t : Int
  mental : Bool

/-- φ(x, t) = 2t + [x is mental]: a mental event at t sits just after a material one at t. -/
def φ (e : Ev) : Int := 2 * e.t + (if e.mental then 1 else 0)

/-- D2. Pre-nascence: the heart-base (material, exercising at t) conditions a citta at t (A87). Post-nascence: a citta at t
    supports the body at a LATER exercise time t′ > t — the Vibhāvinī places its support on the body's series continuing
    (`abh07t.nrf.xml:6717`). Then φ rises strictly along both kinds of edge, so the heart-base/aggregates "two-cycle" unrolls
    into a chain in exercise time. ⚠️ Not forced: read both at one t (presence mode) and the cycle is synchronic (the
    Mūlaṭīkā declines to call it mutuality, `abh03t.tik.xml:4317`; the wording *na ca taṃ icchitaṃ* is the Vism-ṭīkā's). -/
theorem d2_prenascence_rises (base c : Ev) (hb : base.mental = false) (hc : c.mental = true) (same : base.t = c.t) :
    φ base < φ c := by
  simp [φ, hb, hc]; omega

theorem d2_postnascence_rises (c body : Ev) (hc : c.mental = true) (hb : body.mental = false) (later : c.t < body.t) :
    φ c < φ body := by
  simp [φ, hc, hb]; omega

/-- D4. Contiguity is a link WITHIN A SORT (A112; the Vibhāvinī `abh07t.nrf.xml:6653`: matter "of another kind cannot
    intervene"). Points are integers; points 1 … N are material events of the body's continuing time. The last citta before
    cessation (0) and the first after (N + 1) are adjacent among MENTAL events, yet not adjacent among all events. -/
def linkIn (P : Int → Prop) (x y : Int) : Prop := x < y ∧ ∀ z, P z → ¬ (x < z ∧ z < y)

theorem d4_link_within_a_sort (N : Int) (hN : 1 ≤ N) :
    linkIn (fun z => z = 0 ∨ z = N + 1) 0 (N + 1) ∧ ¬ linkIn (fun _ => True) 0 (N + 1) := by
  refine ⟨⟨by omega, fun z hz h => by omega⟩, fun ⟨_, h⟩ => h 1 trivial ⟨by omega, by omega⟩⟩

end FormalAbhidhamma.Shape
