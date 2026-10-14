# PRE-REGISTRATION — first-thesis-past-lives-and-hell (PROOF)

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `a2d9003`.*

- **Date (machine):** 2026-10-13
- **Question:** Every being (supposition 1: one stream of cittas) has infinitely many past lives — however far back you go, one of its lives had already begun earlier still (T3); every being has had a past life in hell (T4); and every being who attains the arahant path, a Buddha included, had a past life in hell before it (T5, supposition 5 read as a necessary condition). Supposition 2 (the number of beings is infinite) is stated in the Piṭaka (Bv 1.64, s0511m.mul.xml:795) and gets no theorem; a sixth supposition was added after approval and is a separate run.
- **Thesis approved by:** the founder, 2026-10-13 ('1: approve · 2: (a)'); T4 and T5 tightened to a PAST existence after the second blind back-translation (the founder's own word 'past life'), the third back-translation matching
- **Conventions: A389** (founder 2026-10-13): one claim per theorem; each premise its own binder, an ID-named definition;
  an instance stated as a hypothesis on a bound parameter (`(hk : k = 2)`), never as a literal
- **Window:** none
- **Instrument:** `SiliconWat/formal-abhidhamma` at `125b393` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)

- **Avyākata review:** 'infinite' here is the beings' past lives and their number, not the world's extent or permanence (the undeclared antavā/sassato loko); beginningless wandering is DECLARED (SN 15.1) and the Buddhavaṃsa states beings are endless

## The exact Lean statement (the proof comes after; the statement may not move)

```lean
/-
  The founder's first thesis (2026-10-13), suppositions 3–5, as Lean statements. DRAFT for his approval — nothing proved.
  Supposition 1 is the World (a being = one stream of cittas). Supposition 2 is stated in the Piṭaka (Bv 1.64) and gets
  no theorem here (see the restatement). One claim per theorem; each premise a definition named by its axiom ID.
-/
namespace FormalAbhidhamma.Samsara

/-- The eight destinies a rebirth can lead to (A48's 31 planes, grouped). -/
inductive Destiny where
  | niraya | tiracchana | peta | asura | manussa | deva | rupa | arupa
  deriving DecidableEq

/-- ONE being, as one stream of cittas on a clock of integer ticks (supposition 1). `citta t`: a citta of this stream
    occurs at tick `t`; `prox p q`: the citta at `p` conditions the citta at `q` by proximity; `patisandhi r`: a
    rebirth-linking citta (the first citta of an existence) occurs at `r`; `realm r`: the destiny of the existence that
    begins at `r`; `arahatta a`: the arahant path citta occurs at `a`; `now`: the present tick. -/
structure World where
  citta : Int → Prop
  prox : Int → Int → Prop
  patisandhi : Int → Prop
  realm : Int → Destiny
  arahatta : Int → Prop
  now : Int

/-! ## The premises, one definition per axiom clause -/

/-- C (the Paṭṭhāna's negative method): every citta has a citta that conditions it by proximity. -/
def c_predecessor (w : World) : Prop := ∀ q, w.citta q → ∃ p, w.prox p q ∧ w.citta p

/-- A3 (proximity): what conditions by proximity comes BEFORE what it conditions. -/
def a3_successor (w : World) : Prop := ∀ p q, w.prox p q → p < q

/-- A58 (with A51, Vibhaṅga §191): every existence begins with a rebirth-linking citta, so every citta lies at or
    after the rebirth-linking citta of its own existence. -/
def a58_lives_begin (w : World) : Prop := ∀ t, w.citta t → ∃ r, w.patisandhi r ∧ r ≤ t

/-- A109 (the path process): the arahant path is a citta. -/
def a109_path_is_citta (w : World) : Prop := ∀ a, w.arahatta a → w.citta a

/-! ## The theorems (statements only) -/

/-- T3 — supposition 3: however far back you go, a life of this being had already begun earlier still. Since ticks are
    integers, this is infinitely many past lives. `hnow`: the being exists now. -/
theorem t3_infinitely_many_past_lives (w : World) (hC : c_predecessor w) (h3 : a3_successor w)
    (h58 : a58_lives_begin w) (hnow : w.citta w.now) :
    ∀ b : Int, ∃ r, w.patisandhi r ∧ r < b := by
  sorry

/-- T4 — supposition 4: this being had a PAST existence in hell — one that began in hell and was followed by another
    existence that has already begun by now. -/
theorem t4_a_past_life_in_hell (w : World) (hC : c_predecessor w) (h3 : a3_successor w)
    (h58 : a58_lives_begin w) (hnow : w.citta w.now) :
    ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ w.now := by
  sorry

/-- T5 — supposition 5, as a necessary condition: if this being attains the arahant path at `a` (a Buddha attains it
    too), a PAST existence of it was in hell — one followed by another existence that had begun by `a`. -/
theorem t5_hell_before_arahantship (w : World) (hC : c_predecessor w) (h3 : a3_successor w)
    (h58 : a58_lives_begin w) (h109 : a109_path_is_citta w)
    (a : Int) (ha : w.arahatta a) :
    ∃ r r', w.patisandhi r ∧ w.realm r = Destiny.niraya ∧ w.patisandhi r' ∧ r < r' ∧ r' ≤ a := by
  sorry

end FormalAbhidhamma.Samsara
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| C | Conditionality: every moment has an immediate predecessor that conditions it; ignorance is not an uncaused root-cause of the world (*na akāraṇaṃ*). ⭐ **The Piṭaka basis for the predecessor clause** (added 2026-10-13 for the founder's first `/prove` thesis; A3 alone gives only the SUCCESSOR): the Paṭṭhāna's negative method says that what arises *not* by proximity is like what arises *not* by object (*naanantarapaccayampi nasamanantarapaccayampi naārammaṇapaccayasadisaṃ*), and what arises not by object is matter only — mind-born matter, kamma-born matter at rebirth, the base, the great elements and derived matter, external, nutriment- and temperature-born matter, the mindless beings' matter. So every mental state arises with a proximity condition, the citta that has just ceased. ⚠️ Joining the two lines is OURS; the Paṭṭhāna states each, not the conclusion. The Sutta's wording stays epistemic (A2), the manual's is *anādikaṃ* (A77) | Piṭaka (Paṭṭhāna: two lines, joined by us) + Vism XVII §584 | `abh03m7.mul.xml:1201` (the cross-reference), `:1153–1169` (the not-by-object list); `e0102n.mul.xml:3553` | VERIFIED | `Conditioned`, `beginningless` |
| A3 | Proximity (*anantara*): each moment conditions its immediate successor — *natthi etesaṃ antaraṃ*, "there is no interval between them" (the commentary), which it keeps apart from immediacy in TIME: across cessation there is none, and the condition still holds. ⚠️ Corrected 2026-10-13 (the Kv 8.2 control's vetting, F5): the clause "even across many thousands of kappas" and its line `abh05t.nrf.xml:2409` moved to ANSWERS Kv 8.2 — that line is the anuṭīkā's refutation of the intermediate existence (it ends *nattheva antarābhavo*); runs registered before keep their PREREG copies | Piṭaka (Paṭṭhāna, quoted) + commentarial | Paṭṭhāna niddesa quoted at `abh03a.att.xml:7693`; *natthi etesaṃ antaraṃ* `:7697` | VERIFIED — mūla Paṭṭhāna `abh03m7.mul.xml:85–89` (*purimā purimā … pacchimānaṃ pacchimānaṃ … anantarapaccayena paccayo*), read 2026-09-30 | `Stream.tick_succ`, `Stream.continues` |
| A58 | Between processes the bhavaṅga flows "like a river" from rebirth to death; rebirth, bhavaṅga, process and death turn "like a chariot wheel", life after life. ⭐ **Every existence BEGINS** (added 2026-10-13 for the founder's first `/prove` thesis): the stream of an existence runs from its rebirth-linking citta, its first citta (A51, A35), and the Vibhaṅga defines birth as the manifestation of the aggregates of beings in each class of beings (*yā tesaṃ tesaṃ sattānaṃ tamhi tamhi sattanikāye jāti … khandhānaṃ pātubhāvo*); so every citta lies at or after the rebirth-linking citta of its own existence | manual + Piṭaka (Vibhaṅga, the definition of birth) | Saṅgaha ch. 5 §99–102, `abh07t.nrf.xml:1989–2005`; Vibhaṅga §191 `abh02m.mul.xml:2797` (also §235 `:3689`) | VERIFIED | — |
| A109 | The path process: two or three insight cittas (preparation, access, conformity); change-of-lineage, which **takes nibbāna as object**; the path citta for **one mind-moment**; two or three fruition cittas; bhavaṅga; then reviewing | manual | Saṅgaha ch. 9 §55–60, `abh07t.nrf.xml:3313–3337`; ch. 4 §35, `:1389` | VERIFIED | — |

## Type freedoms — what the Lean type leaves free, declared before the attempt (A388 OQ4)

- Ticks are integers and a being is ONE stream of cittas (supposition 1). Matter and the mindless existences (A13) are not in the World; they add existences and never remove one
- Existences are delimited by rebirth-linking ticks only: nothing requires an existence to hold more than its first citta, or exactly one rebirth-linking citta (A51 is not encoded); and a rebirth-linking tick need not be a citta tick (A35 is not encoded — the first blind back-translation found no theorem needs it, so it was dropped)
- realm is constrained by NO premise: the World encodes no kamma (A52, A54) and no law of destiny (A48). The predicted countermodels for T4 and T5 rest on this — the claim for the refuter to test is that the texts assert no premise that would force a hell existence into every past
- arahatta is constrained only by A109 (the path is a citta)

## Held out — the texts' own answers this run may NOT reason from

- A2 · A77 (they state supposition 3 — A2 only as 'not discerned' — and are not premises; no ANSWERS row is near)

## Predicted outcome

- **The session predicts:** INDEPENDENT
- **The founder predicts:** PROVED

## Predictions

1. T3 PROVED from C, A3, A58 and hnow; constructive; Unused none; each of the four needed (needs_ models)
2. T4 INDEPENDENT: a model of every premise with a past existence in hell, and one whose past existences are all human — so T4 does not follow from T3
3. T5 INDEPENDENT the same way; it follows from T4 read at every moment, so it stands or falls with T4
4. leak-check: no answer_ definitions (no held-out answer is near), nothing to leak
5. GRADE NOT STRONG: T4 and T5 fail item 2 (their countermodels rest on the unconstrained realm field); T3 is a CHECK — the manual states it (A77)

## Pass criteria for the instrument

- (none beyond the predictions)
