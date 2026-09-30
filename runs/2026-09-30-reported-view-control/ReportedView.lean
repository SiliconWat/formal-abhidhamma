/-
  Reported-view control (PREREG pushed 2026-09-30T20:02:39Z; OTS-stamped). Window A0; axiom A16 + readings the
  agent ADDED (DERIVATION.md §1): R2 the Atthasālinī author's ruling (`abh01a.att.xml:8301`, eye and ear take objects
  that do not reach them, heard "where it arose"), R4/R6 (`abh01t.tik.xml:2125`, `s0304t.tik.xml:1871`), R7 (the
  Mohavicchedanī's threshold account, `abh09t.nrf.xml:5953`), R8 (a great thunder heard in one moment, `e0401n.nrf.xml:1209`).
  ⚠️ The comparisons with measurements are NOT derivations; Lean checks only that the ruled claims and the measured
  law cannot hold together. Units: distances in km or m, times in ms.
-/
namespace FormalAbhidhamma.ReportedView

/-- D2 / D4 / D8 share one shape. "Taken where it stands, at its present moment" (R2, R4, R6; for D8 R7 above threshold)
    makes the delay ZERO at every distance; the measured law makes delay·c = d for a finite c. For any d > 0 they cannot
    both hold — sight (Rømer, LLR 2.56 s), sound (1738 Paris, ≈ 332 m/s), and a single loud impulse alike. -/
theorem instant_contradicts_propagation (delay : Nat → Nat) (c d : Nat)
    (ruled : ∀ x, delay x = 0) (measured : ∀ x, delay x * c = x) (hd : 0 < d) : False := by
  have h := measured d
  rw [ruled d, Nat.zero_mul] at h
  omega

/-- D3, NARROWED by the refuter: CONDITIONAL on R2's identification (the seen object IS the distant disc's own colour).
    Light at 300 km/ms, transit t with 17τ > t (the object still exists, R4 + A4) and 17τ ≤ R = 250 ms (P-proc RECALLED,
    P3 reaction time): anything seen lies within 75,000 km. So the moon at ≥ 306,600 km (A16, D1) is invisible under
    finite c. ⚠️ Not "forced": the Paramatthadīpanī (`e0301n.nrf.xml:4205`) makes a locally arisen relayed object
    asampatta, which escapes this theorem by dropping its hypothesis `seen`. -/
theorem d3_bound (d t tau : Nat) (seen : d = 300 * t) (alive : t < 17 * tau) (fits : 17 * tau ≤ 250) : d < 75000 := by
  omega

theorem d3_moon_unseen (t tau : Nat) (alive : t < 17 * tau) (fits : 17 * tau ≤ 250) :
    ¬ (306600 = 300 * t) := by
  intro h; have := d3_bound 306600 t tau h alive fits; omega

/-- D9. "A great thunder heard in one moment" (R8): measured rumble lasts spread/c_s. With c_s = 343 m/s
    (343·dur_ms = 1000·spread_m) and a channel spread ≥ 1 km, the rumble lasts > 2.9 s — hundreds of times the
    ≤ 250/17 ms that one mind-moment can last on D3's own premises. -/
theorem d9_rumble (dur spread : Nat) (law : 343 * dur = 1000 * spread) (h : 1000 ≤ spread) : 2900 < dur := by
  omega

/-- Non-vacuity. Each hypothesis set alone is satisfiable: instant perception (delay ≡ 0) is a model of `ruled`; the
    measured law with c = 1 is a model of `measured`; D3's premises hold at t = 0 (asampatta); a 1.029 km rumble. -/
example : ∀ x : Nat, (fun _ => 0) x = 0 := fun _ => rfl
example : ∀ x : Nat, (fun y : Nat => y) x * 1 = x := fun x => Nat.mul_one x
example : (0 : Nat) = 300 * 0 ∧ 0 < 17 * 14 ∧ 17 * 14 ≤ 250 := by decide
example : 343 * 3000 = 1000 * 1029 := by decide

end FormalAbhidhamma.ReportedView
