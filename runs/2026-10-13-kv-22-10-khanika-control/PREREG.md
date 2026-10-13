# PRE-REGISTRATION — kv-22-10-khanika-control (PROOF — CONTROL, KNOWN ANSWER: Kv 22.10 §906)

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `4612142`.*

- **Date (machine):** 2026-10-13
- **Question:** Kathāvatthu 22.10 (Khaṇikakathā): 'all dhammas last one mind-moment' (ekacittakkhaṇikā sabbe dhammā), tested on BOTH readings of 'one mind-moment' — (A) aligned: a dhamma arises and ceases WITH one citta (the commentary's reading, KV-a abh03a.att.xml:6353); (B) duration: it lasts one mind-moment's LENGTH from its own arising (the Vism-ṭīkā's gloss, e0103n.att.xml:4209) — together with §907's counter ('not one-moment, therefore all permanent').
- **Thesis approved by:** the vetting refuter, 2026-10-13, after two rounds (the case narrowed on its findings 4a–4d, then a 'base present throughout' premise dropped on its re-vet); family A recommended for registration as a known-answer control declared CONFOUNDED; family B registered as a prediction, the mūla giving no answer
- **Window:** none
- **Instrument:** `SiliconWat/formal-abhidhamma` at `4612142` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## The exact Lean statement (the proof comes after; the statement may not move)

```lean
/-
  Kathāvatthu 22.10 (Khaṇikakathā) §906–907 — a /prove known-answer CONTROL, NARROWED after its vetting (2026-10-13): the
  view "all dhammas last one mind-moment" is tested on BOTH readings of "one mind-moment". Registered statements only: the
  proofs come after, and the statements may not move.
  Premises: A87, A98, A115, A117 (Piṭaka). HELD OUT: A69 (this debate's own conclusion) and A4's commentarial 17.
  Narrowed TWICE after vetting: the existence premise is its own row (A115); and a "base present THROUGHOUT the
  consciousness" premise was DROPPED — no layer says it (the Vibhaṅga and its commentary make the unbroken base a
  condition of the ARISING, A116), and it would import the held-out A69.
  ⚠️ BY CONSTRUCTION, declared: every dhamma of a `World` has a birth, so the view is tested only over CONDITIONED dhammas
  (the commentary's own scope, *sabbasaṅkhatadhammā*, `abh03a.att.xml:6353`); nibbāna is outside it.
-/
namespace FormalAbhidhamma.Khanika

/-- Dhammas on a clock: `birth d` is the moment `d` arises, `present d t` that `d` exists at `t`, and `pre e c` that `e`
    conditions `c` by pre-nascence (*purejāta*). Family A's clock counts mind-moments; family B's counts sub-moments. -/
structure World where
  Dhamma : Type
  birth : Dhamma → Int
  present : Dhamma → Int → Prop
  pre : Dhamma → Dhamma → Prop

/-! ## Family A — the ALIGNED reading: a one-moment dhamma arises and ceases WITH one citta
    (KV-a `abh03a.att.xml:6353`: *cakkhāyatanādīni cakkhuviññāṇādīhi saddhiṃyeva uppajjitvā nirujjheyyuṃ*). -/

/-- The view, aligned: every dhamma exists at exactly one mind-moment, the one at which it arises. -/
def OneMoment (w : World) : Prop := ∀ d t, w.present d t ↔ t = w.birth d

/-- *Niccā dhuvā sassatā* (§907): a dhamma that exists at every moment. -/
def Permanent (w : World) (d : w.Dhamma) : Prop := ∀ t, w.present d t

/-- §907's conclusion: every dhamma is permanent. -/
def AllPermanent (w : World) : Prop := ∀ d, Permanent w d

/-- T1. If eye-consciousness occurs with a pre-nascent eye-base (A115, read with A87's law), the base arose BEFORE it (A87: *purejāta*),
    and the base is present when the consciousness arises (A98), then the aligned view is false. -/
theorem t1_aligned_view_refuted (w : World)
    (a115_occurs : ∃ e c, w.pre e c)
    (a87_purejata : ∀ e c, w.pre e c → w.birth e < w.birth c)
    (a98_atthi : ∀ e c, w.pre e c → w.present e (w.birth c)) :
    ¬ OneMoment w := by
  sorry

/-- T2 (§907, the opponent's counter: "if not all one-moment, then all permanent"). That inference does not follow from
    the same premises: some world satisfies them and the inference fails in it. -/
theorem t2_counter_does_not_follow :
    ∃ w : World, (∃ e c, w.pre e c) ∧ (∀ e c, w.pre e c → w.birth e < w.birth c) ∧
      (∀ e c, w.pre e c → w.present e (w.birth c)) ∧ ¬ (¬ OneMoment w → AllPermanent w) := by
  sorry

/-! ## Family B — the DURATION reading: a one-moment dhamma lasts the LENGTH of one mind-moment, from its own arising,
    aligned to no citta (Vism-ṭīkā `e0103n.att.xml:4209`: *ekacittakkhaṇamattavantaṃ*). The clock counts sub-moments,
    `k` to a mind-moment: the Yamaka names at least two (A117); the manual counts three (A40). -/

/-- The view, by duration: every dhamma exists for exactly `k` sub-moments from its arising. -/
def OneCittaLength (w : World) (k : Int) : Prop := ∀ d t, w.present d t ↔ (w.birth d ≤ t ∧ t < w.birth d + k)

/-- T3. With the base present when the consciousness ARISES (A98; the Vibhaṅga's unbroken base, A116, says the same),
    the premises do not settle the duration view whenever a mind-moment has at least two sub-moments (A117): for every
    such `k`, one world satisfies them with the view true and another with it false. -/
theorem t3_duration_view_open (k : Int) (a117_two_submoments : 2 ≤ k) :
    (∃ w : World, (∃ e c, w.pre e c) ∧ (∀ e c, w.pre e c → w.birth e < w.birth c) ∧
        (∀ e c, w.pre e c → w.present e (w.birth c)) ∧ OneCittaLength w k) ∧
    (∃ w : World, (∃ e c, w.pre e c) ∧ (∀ e c, w.pre e c → w.birth e < w.birth c) ∧
        (∀ e c, w.pre e c → w.present e (w.birth c)) ∧ ¬ OneCittaLength w k) := by
  sorry

end FormalAbhidhamma.Khanika
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A87 | Pre-nascence (*purejāta*): **the five sense organs and the five objects, already arisen, condition the consciousness that takes them**; the heart-base conditions the mind-element, and conditions mind-consciousness "at one time, and at another not" | Piṭaka | `abh03m7.mul.xml:169–177` | VERIFIED | — |
| A98 | Presence (*atthi*): conditions that must be present while they condition: the co-nascent relations, the sense organs and objects for their consciousness, the heart-base for mind | Piṭaka | `abh03m7.mul.xml:225–237` | VERIFIED | — |
| A115 | **A sense consciousness arises when its conditions meet**: "when the internal eye is intact, external forms come into range and there is the corresponding attention, then there is the manifestation of the corresponding section of consciousness" (*evaṃ tajjassa viññāṇabhāgassa pātubhāvo hoti*). ⚠️ The sutta asserts the CONDITIONAL; that an instance OCCURS is a reading both parties of Kv 22.10 presuppose (the Theravādin quotes it there and the opponent accepts it) — an ADDED reading, declared. A run that turns it into a conditioning pair also needs A87's law. Added 2026-10-13 for the first `/prove` control (its vetting, finding 4b) | Piṭaka (Sutta) + an added existential reading | MN 28 §306, `s0201m.mul.xml:4216` (where it is ASSERTED; the Kathāvatthu only quotes it, so its lines stay with ANSWERS) | VERIFIED | — |
| A117 | **A mind-moment has at least two sub-moments: its arising-moment and its dissolution-moment** (*cittassa uppādakkhaṇe · cittassa bhaṅgakkhaṇe*), which the Yamaka distinguishes — at a citta's dissolution-moment the truth of suffering does not arise. ⚠️ The Yamaka PRESUPPOSES the two moments; it does not compute them (its answers about what arises at each belong to ANSWERS). The third, standing (*ṭhiti*), is the manual's (A40). Added 2026-10-13 | Piṭaka (Yamaka) | Saccayamaka `abh03m4.mul.xml:16241` (arising-moment), `:16337` (dissolution-moment) | VERIFIED | — |

## Held out — the texts' own answers this run may NOT reason from

- Kv 22.10 §906
- A69
- A4

## Predicted outcome

- **The session predicts:** REFUTED
- **The founder predicts:** (no prediction given)

## Predictions

1. T1 — the aligned view is REFUTED from A115 + A87 + A98; tools/Uses.lean shows all three premises used; each break (A87's born-before weakened to ≤, A98's presence dropped, A115's occurrence dropped) fails; the proof is constructive.
2. T2 — §907's counter does not follow: a countermodel in which A115 + A87 + A98 hold, the aligned view is false, and not every dhamma is permanent.
3. T3 — the duration view is INDEPENDENT of A115 + A87 + A98 for every k ≥ 2 (A117): one model with the view true, one with it false; A117's 2 ≤ k is load-bearing for the first (weakening it to 1 ≤ k must fail).
4. Layer: all three at the Piṭaka layer (A87, A98, A115, A117), with A115's existential a declared reading.

## Pass criteria for the instrument

- CONFOUNDED, declared before the attempt: the instrument (PROVE-RUBRIC.md, prereg.py, the /prove skill) was designed alongside this case, and family A's decisive premise (A87's born-before) is §906's contested intermediate lemma — asserted outright at Vibhaṅga §762 (the commentary's sahuppattipaṭikkhepo, abh02a.att.xml:7361). Family A tests the PLUMBING (Lean, Uses, breaks, the hold-out guards); its PASS is near-guaranteed.
- The control PASSES only if T1 comes out REFUTED (the known answer) and theorems-index.py --check stays green (no held-out premise reached).
- Family B is NOT a known-answer control: the mūla argues only the aligned step. T3's prediction (INDEPENDENT) is a genuine test — it would have failed had a premise carried the base's presence through the whole consciousness, which no layer says.
- T2's known answer is COMMENTARIAL (the KV-a's verdict on §907, abh03a.att.xml:6353): the mūla ends on the opponent's line.
