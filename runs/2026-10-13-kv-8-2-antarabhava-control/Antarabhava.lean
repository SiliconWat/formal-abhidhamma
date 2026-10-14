/-
  Kathāvatthu 8.2 — "there is an intermediate existence" — a KNOWN-ANSWER CONTROL under the A389 conventions (one claim per
  theorem; each premise a definition named by its axiom ID and its own hypothesis). The texts' answer: REFUTED
  (kala/ANSWERS.md "Kv 8.2 §505–509"). HELD OUT: that answer and A59. The route — proximity across death — is already
  stated in later layers (the anuṭīkā, the Vibhāvinī, a Saṃyutta ṭīkā; the ANSWERS row): a CHECK of the instrument, not a
  finding. Vetted 2026-10-13 (F1–F8). Registered 2026-10-14T00:22:20Z (PREREG.md); the statements below are verbatim, the proofs added after.
-/
namespace FormalAbhidhamma.Antarabhava

/-- One stream on a clock of ticks. `citta t`: a citta of this stream occurs at tick `t`; `vinnana t`: the aggregate of
    consciousness occurs at `t`; `patisandhi t`: a rebirth-linking citta occurs at `t`; `prox p q`: the citta at `p`
    conditions the citta at `q` by proximity; `cuti`: the tick of a death citta; `upapatti`: the tick of the citta that
    death conditions by proximity; `antara t`: the being is in an intermediate existence at `t`. -/
structure World where
  citta : Int → Prop
  vinnana : Int → Prop
  patisandhi : Int → Prop
  prox : Int → Int → Prop
  cuti : Int
  upapatti : Int
  antara : Int → Prop

/-! ## The premises, one definition per axiom clause -/

/-- A3 (proximity): what conditions by proximity comes BEFORE what it conditions — its successor. -/
def a3_successor (w : World) : Prop := ∀ p q, w.prox p q → p < q

/-- A3 (proximity, *natthi etesaṃ antaraṃ*): no citta lies between the two. -/
def a3_immediate (w : World) : Prop := ∀ p q, w.prox p q → ∀ t, p < t → t < q → ¬ w.citta t

/-- A122 (the Paṭṭhāna): the death citta conditions a REBIRTH-LINKING citta by proximity. -/
def a122_death_to_rebirth (w : World) : Prop := w.prox w.cuti w.upapatti ∧ w.patisandhi w.upapatti

/-- A123 (the Dhammasaṅgaṇī §6, §63): the aggregate of consciousness is citta. -/
def a123_vinnana_is_citta (w : World) : Prop := ∀ t, w.vinnana t → w.citta t

/-! ## The view, held two ways, and the held-out answer -/

/-- The view as the Kathāvatthu's holders hold it (the Pubbaseliyas and Sammitiyas, `abh03a.att.xml:4385`): after the
    death the being is in an intermediate existence, with NO rebirth-linking inside it before then (§506 `abh03m3.mul.xml:8157`,
    *jāyanti … na hevaṃ*; `abh03a.att.xml:4389`, *cutipaṭisandhiparamparañca anicchanto*). ⚠️ Not the later holders who
    allow deaths and rebirths inside it (`abh05t.nrf.xml:2381`). -/
def intermediate (w : World) : Prop :=
  ∃ t, w.cuti < t ∧ w.antara t ∧ ∀ s, w.cuti < s → s ≤ t → ¬ w.patisandhi s

/-- The commentaries' report of its content: the intermediate being has consciousness (it watches for its parents' union,
    `abh03a.att.xml:4385`; its feeling and the rest are not gross, `:4389`; the aggregates of the intermediate existence,
    `abh03t.tik.xml:2177`). The mūla records only the opponent's "no". -/
def with_mind (w : World) : Prop := ∀ t, w.antara t → w.vinnana t

/-- A MINDLESS interval — attributed to no holder (F1): what remains if the intermediate being has no consciousness. -/
def mindless (w : World) : Prop := ∀ t, w.antara t → ¬ w.vinnana t

/-- ANSWER: Kv 8.2 §505–509 — there is no intermediate existence. -/
def answer_kv_8_2 (w : World) : Prop := ¬ intermediate w

/-! ## The theorems -/

/-- T1 — proximity across death leaves no room for the intermediate existence its Kathāvatthu holders hold, as the
    commentaries report it: one with consciousness and no rebirth inside it. -/
theorem t1_no_room_for_the_reported_view (w : World) (h3s : a3_successor w) (h3 : a3_immediate w)
    (h122 : a122_death_to_rebirth w) (h123 : a123_vinnana_is_citta w) : ¬ (intermediate w ∧ with_mind w) := by
  intro ⟨⟨t, h1, ha, hno⟩, hm⟩
  obtain ⟨hp, hpat⟩ := h122
  -- the rebirth-linking citta the death conditions comes after it; the view puts no rebirth-linking before `t`,
  -- so `t` lies strictly between them — where proximity leaves no citta, and a minded being has one
  if h : t < w.upapatti then exact h3 _ _ hp t h1 h (h123 t (hm t ha))
  else exact hno w.upapatti (h3s _ _ hp) (Int.not_lt.mp h) hpat

/-- T2a — the same premises admit a MINDLESS intermediate interval: a model of them all with one. -/
theorem t2a_mindless_interval_admitted :
    ∃ w, a3_successor w ∧ a3_immediate w ∧ a122_death_to_rebirth w ∧ a123_vinnana_is_citta w ∧ mindless w ∧ intermediate w := by
  refine ⟨⟨fun t => t = 0 ∨ t = 2, fun t => t = 0 ∨ t = 2, fun t => t = 2, fun p q => p = 0 ∧ q = 2, 0, 2, fun t => t = 1⟩, ?_, ?_, ⟨⟨rfl, rfl⟩, rfl⟩, fun _ h => h, ?_, ⟨1, by decide, rfl, ?_⟩⟩
  · intro p q ⟨hp, hq⟩; subst hp hq; decide
  · intro p q ⟨hp, hq⟩ t h1 h2 hc; subst hp hq; rcases hc with hc | hc <;> omega
  · intro t ht hv; subst ht; rcases hv with hv | hv <;> exact absurd hv (by decide)
  · intro s _ h2 hs; subst hs; exact absurd h2 (by decide)

/-- T2b — and a model of them all without one (with T2a: a mindless interval is INDEPENDENT of these premises). -/
theorem t2b_mindless_interval_not_forced :
    ∃ w, a3_successor w ∧ a3_immediate w ∧ a122_death_to_rebirth w ∧ a123_vinnana_is_citta w ∧ mindless w ∧ ¬ intermediate w := by
  refine ⟨⟨fun t => t = 0 ∨ t = 2, fun t => t = 0 ∨ t = 2, fun t => t = 2, fun p q => p = 0 ∧ q = 2, 0, 2, fun _ => False⟩, ?_, ?_, ⟨⟨rfl, rfl⟩, rfl⟩, fun _ h => h, fun _ h => h.elim, fun ⟨_, _, h, _⟩ => h⟩
  · intro p q ⟨hp, hq⟩; subst hp hq; decide
  · intro p q ⟨hp, hq⟩ t h1 h2 hc; subst hp hq; rcases hc with hc | hc <;> omega

/-! ## A model of T1's hypotheses together (rubric item 3): they are jointly satisfiable, so T1 is not vacuous -/

theorem model_t1_hypotheses :
    ∃ w, a3_successor w ∧ a3_immediate w ∧ a122_death_to_rebirth w ∧ a123_vinnana_is_citta w ∧ with_mind w := by
  refine ⟨⟨fun t => t = 0 ∨ t = 2, fun t => t = 0 ∨ t = 2, fun t => t = 2, fun p q => p = 0 ∧ q = 2, 0, 2, fun _ => False⟩,
    ?_, ?_, ⟨⟨rfl, rfl⟩, rfl⟩, fun _ h => h, fun _ h => h.elim⟩
  · intro p q ⟨hp, hq⟩; subst hp hq; decide
  · intro p q ⟨hp, hq⟩ t h1 h2 hc; subst hp hq; rcases hc with hc | hc <;> omega

end FormalAbhidhamma.Antarabhava
