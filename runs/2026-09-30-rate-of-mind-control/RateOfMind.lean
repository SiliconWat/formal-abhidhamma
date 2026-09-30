/-
  Rate-of-mind control — the FIRST A0′ control (PREREG pushed 2026-09-30T20:13:41Z; OTS-stamped). Window A0′;
  axioms A1, A4, A24, A25. Survivors only (the refuter KILLED D6's numeric prediction and D10). Times in femtoseconds.
-/
namespace FormalAbhidhamma.RateOfMind

/-- D2. A1 (moments do not overlap, so N moments of length τ fit in one snap: N·τ ≤ snap) and A24 (N ≥ 2·10¹²,
    reading *anekāni* as ≥ 2 — OURS), with a snap ≤ 0.4 s (our conversion of the grammar's mora) ⇒ τ ≤ 200 fs.
    One-sided: *anekāni* has no ceiling, so τ has no floor. -/
theorem d2_moment_bound (N τ snap : Nat) (fit : N * τ ≤ snap) (many : 2000000000000 ≤ N)
    (short : snap ≤ 400000000000000) : τ ≤ 200 := by
  have h : 2000000000000 * τ ≤ N * τ := Nat.mul_le_mul_right τ many
  omega

/-- D5. Observing a moment costs an adverting citta and n javanas on that one object (A1 + `s0203a.att.xml:913`);
    with the texts' 7 javanas (`e0401n.nrf.xml:909`), two observed moments p < q lie ≥ 8 apart. ⚠️ A LOWER bound on
    spacing only — the refuter: bhavaṅga-calana, upaccheda and tadārammaṇa make it larger, and nothing bounds it above. -/
theorem d5_spacing (p q n : Nat) (process : p + 1 + n ≤ q) (javana : 7 ≤ n) : 8 ≤ q - p := by
  omega

/-- D9. A4: a rūpa lasts 17 cittas, so a citta (τ > 0) is shorter than a rūpa — AN 1.48's ordinal, nothing more. -/
theorem d9_citta_faster (τ : Nat) (h : 0 < τ) : τ < 17 * τ := by
  omega

/-- D8. One object per citta (Kathāvatthu `abh03m3.mul.xml:4529`, Piṭaka): a sight and a sound need two indices.
    ⚠️ BY CONSTRUCTION — a function cannot send one index to two objects; the content is the Kathāvatthu's refusal. -/
theorem d8_serial {O : Type} (obj : Nat → O) (i j : Nat) (x y : O) (hx : obj i = x) (hy : obj j = y) (hxy : x ≠ y) :
    i ≠ j := by
  intro h; subst h; exact hxy (hx ▸ hy)

/-- Non-vacuity: 3·10¹² moments of 100 fs in a 0.3 s snap; an observing process of 1 + 7. -/
example : 3000000000000 * 100 ≤ 300000000000000 := by decide
example : 8 ≤ (8 : Nat) - 0 := d5_spacing 0 8 7 (by decide) (by decide)

end FormalAbhidhamma.RateOfMind
