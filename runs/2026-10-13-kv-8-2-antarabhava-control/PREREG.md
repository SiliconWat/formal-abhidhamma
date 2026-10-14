# PRE-REGISTRATION — kv-8-2-antarabhava-control (PROOF — CONTROL, KNOWN ANSWER: Kv 8.2 §505–509)

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `ebdbc20`.*

- **Date (machine):** 2026-10-13
- **Question:** From A3 (proximity: no citta lies between; it conditions its successor), A122 (the death citta conditions a rebirth-linking citta by proximity) and A123 (the consciousness aggregate is citta), with Kv 8.2's answer and A59 held out: the intermediate existence its Kathāvatthu holders hold, as the commentaries report it — with consciousness, and with no rebirth-linking inside it — cannot exist (T1); a MINDLESS interval, attributed to no holder, is not settled by these premises (T2a, T2b).
- **Thesis approved by:** the founder ordered the control (2026-10-13: 'do all four if possible, then my thesis'); for a control the approver of the statement is the vetting refuter (2026-10-13, F1–F8, all applied or declared: T2 recast as an unattributed mindless interval; T1's view carries 'no rebirth-linking inside it'; the answer kept unqualified; A3's :2409 clause moved to ANSWERS); two blind back-translations, the second matching the approved sentence and showing each of T1's four hypotheses needed
- **Conventions: A389** (founder 2026-10-13): one claim per theorem; each premise its own binder, an ID-named definition;
  an instance stated as a hypothesis on a bound parameter (`(hk : k = 2)`), never as a literal
- **Window:** none
- **Instrument:** `SiliconWat/formal-abhidhamma` at `93a5e3d` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## The exact Lean statement (the proof comes after; the statement may not move)

```lean
/-
  Kathāvatthu 8.2 — "there is an intermediate existence" — a KNOWN-ANSWER CONTROL under the A389 conventions (one claim per
  theorem; each premise a definition named by its axiom ID and its own hypothesis). The texts' answer: REFUTED
  (kala/ANSWERS.md "Kv 8.2 §505–509"). HELD OUT: that answer and A59. The route — proximity across death — is already
  stated in later layers (the anuṭīkā, the Vibhāvinī, a Saṃyutta ṭīkā; the ANSWERS row): a CHECK of the instrument, not a
  finding. Vetted 2026-10-13 (F1–F8). Registered statements only: proofs come after.
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
  sorry

/-- T2a — the same premises admit a MINDLESS intermediate interval: a model of them all with one. -/
theorem t2a_mindless_interval_admitted :
    ∃ w, a3_successor w ∧ a3_immediate w ∧ a122_death_to_rebirth w ∧ a123_vinnana_is_citta w ∧ mindless w ∧ intermediate w := by
  sorry

/-- T2b — and a model of them all without one (with T2a: a mindless interval is INDEPENDENT of these premises). -/
theorem t2b_mindless_interval_not_forced :
    ∃ w, a3_successor w ∧ a3_immediate w ∧ a122_death_to_rebirth w ∧ a123_vinnana_is_citta w ∧ mindless w ∧ ¬ intermediate w := by
  sorry

end FormalAbhidhamma.Antarabhava
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A3 | Proximity (*anantara*): each moment conditions its immediate successor — *natthi etesaṃ antaraṃ*, "there is no interval between them" (the commentary), which it keeps apart from immediacy in TIME: across cessation there is none, and the condition still holds. ⚠️ Corrected 2026-10-13 (the Kv 8.2 control's vetting, F5): the clause "even across many thousands of kappas" and its line `abh05t.nrf.xml:2409` moved to ANSWERS Kv 8.2 — that line is the anuṭīkā's refutation of the intermediate existence (it ends *nattheva antarābhavo*); runs registered before keep their PREREG copies | Piṭaka (Paṭṭhāna, quoted) + commentarial | Paṭṭhāna niddesa quoted at `abh03a.att.xml:7693`; *natthi etesaṃ antaraṃ* `:7697` | VERIFIED — mūla Paṭṭhāna `abh03m7.mul.xml:85–89` (*purimā purimā … pacchimānaṃ pacchimānaṃ … anantarapaccayena paccayo*), read 2026-09-30 | `Stream.tick_succ`, `Stream.continues` |
| A122 | **The death citta conditions the rebirth-linking citta by PROXIMITY** (*cuticittaṃ … upapatticittassa anantarapaccayena paccayo*): the Paṭṭhāna's own instance of A3 across a death — no citta lies between. Added 2026-10-13 (the A59 audit: the premise a proof run could use to reach Kv 8.2's conclusion). ⚠️ Scope (the Kv 8.2 vetting, F6): some forty such lines in the mūla, each a death and a rebirth of DIFFERENT classes (`:3453`, `:3465`; `abh03m10.mul.xml:4853`); a same-class death and rebirth falls under A3's general clause (`abh03m10.mul.xml:3449`), which does not name the death citta; an arahant's death conditions no rebirth | Piṭaka (Paṭṭhāna, Dukapaṭṭhāna §122) | `abh03m10.mul.xml:3453` (also `:3465`) | VERIFIED | — |
| A123 | **The aggregate of consciousness IS citta.** The Dhammasaṅgaṇī answers *what is citta?* (§6) and *what is the aggregate of consciousness?* (§63) with the same list (*cittaṃ mano mānasaṃ hadayaṃ paṇḍaraṃ … viññāṇaṃ viññāṇakkhandho tajjāmanoviññāṇadhātu*). Added 2026-10-13 (the Kv 8.2 control: a being with consciousness has cittas). ⚠️ Both definitions say *tasmiṃ samaye*, on the occasion of the first wholesome citta; reading them as universal rests on the Dhammasaṅgaṇī repeating the list for every class | Piṭaka (Dhammasaṅgaṇī) | `abh01m.mul.xml:1589`, `:1833` | VERIFIED | — |

## Type freedoms — what the Lean type leaves free, declared before the attempt (A388 OQ4)

- A tick need not carry a citta: the clock admits a mindless interval. T2a's model depends on it; the texts admit such intervals (the mindless beings' existence, A13; cessation, abh03a.att.xml:7697), but place them inside an EXISTENCE
- The World has no notion of existence (bhava) or realm, so it cannot tell a mindless intermediate interval from the mindless beings' existence — the classification of existences (Vibhaṅga abh02m.mul.xml:3685) is what the unqualified answer needs
- The World has no space: the opponents' argument from continuity across distance (abh05t.nrf.xml:2389, 2409) is untested
- One stream: the being who dies is the being reborn (abh05t.nrf.xml:2405 states it inside the held-out passage; not a premise here)
- upapatti is the citta the death conditions by proximity; that it is the NEXT rebirth-linking is not assumed — the view's 'no rebirth-linking inside it' carries that, attributed to its Kathāvatthu holders (§506; abh03a.att.xml:4389), not to the later holders (abh05t.nrf.xml:2381)

## Held out — the texts' own answers this run may NOT reason from

- Kv 8.2 §505–509
- A59

## Predicted outcome

- **The session predicts:** REFUTED
- **The founder predicts:** (no prediction given)

## Predictions

1. T1 REFUTED — ¬(intermediate ∧ with_mind) from A3 (both clauses), A122, A123 — constructive, every hypothesis used (Unused: none)
2. T2a and T2b compile: a mindless interval is INDEPENDENT of these premises, BY CONSTRUCTION (type freedoms 1–2); T2b's witness is trivial
3. leak-check: T1's premises → answer_kv_8_2 (the unqualified answer) — 'no' (the premises without the view's content do not state it)
4. THEOREMS: A59 unreached; no theorem reaches a HELD OUT row; the citation-overlap guard clean
5. Grade: NOT STRONG (T1 is a short modus tollens — a plumbing check; T2 is by construction; the route is stated in the ANSWERS row's later layers)

## Pass criteria for the instrument

- PASS if T1 compiles REFUTED with A59 unreached, the leak check reports no LEAK, and the run NAMES the premise the unqualified answer needs (the classification of existences); FAIL if T1 fails, a theorem reaches A59 or another held-out row, or the premises alone state the unqualified answer (LEAK)
