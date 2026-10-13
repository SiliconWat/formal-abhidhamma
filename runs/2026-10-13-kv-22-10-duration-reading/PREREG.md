# PRE-REGISTRATION — kv-22-10-duration-reading (PROOF)

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `c9a2809`.*

- **Date (machine):** 2026-10-13
- **Question:** On the DURATION reading of 'all dhammas last one mind-moment' (every dhamma lasts one mind-moment's length from its own arising — a reconstruction: the recorded opponent concedes co-arising), do Kathāvatthu 22.10's eye-base premises refute the view? Tested under each rule for where matter may arise: (T1) the Mūlaṭīkā's — only at a citta's arising sub-moment; (T2) the Yamaka read literally, with the number of sub-moments left as the Piṭaka leaves it; (T3) the commentarial permission alone — at any sub-moment.
- **Thesis approved by:** the founder ordered the run and its design (2026-10-13: 'Approve all; do each in turn'); the formal statement vetted by a refuter and registered with its named narrowings (F1–F5), back-translated blind four times
- **Window:** none
- **Instrument:** `SiliconWat/formal-abhidhamma` at `25053d0` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** VipassanaTech/tipitaka-xml romn/ @ 05d5d3c7cede65195bebf7e99b1943db80057cc5 (CST line numbers are as of this version)



## The exact Lean statement (the proof comes after; the statement may not move)

```lean
/-
  Kathāvatthu 22.10 on the DURATION reading, by each rule for WHERE MATTER MAY ARISE — the corrected run the first /prove run
  pointed to (founder 2026-10-13: "Approve all; do each in turn"), redesigned on its vetting. Registered statements only: the
  proofs come after, and the statements may not move. Graded under A388: every premise is a definition named by its axiom
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

/-! ## The theorems -/

/-- T1 (the Mūlaṭīkā's line). If matter arises only at a citta's arising sub-moment, the eye-base premises refute the
    duration view, for every number of sub-moments to a mind-moment. -/
theorem t1_mulatika_line_refutes (k : Int) (w : World) (h : premises_t1 k w) : ¬ OneCittaLength k w := by
  sorry

/-- T2 (the PIṬAKA cell: the Yamaka read literally, the number of sub-moments left as the Piṭaka leaves it). With two
    sub-moments to a mind-moment the eye-base premises refute the duration view; with three they do not settle it. -/
theorem t2_pitaka_cell_turns_on_the_count :
    (∀ w, premises_t2 2 w → ¬ OneCittaLength 2 w) ∧
    (∃ w, premises_t2 3 w ∧ OneCittaLength 3 w) ∧ (∃ w, premises_t2 3 w ∧ ¬ OneCittaLength 3 w) := by
  sorry

/-- T3 (A120's permission ALONE — matter may arise at any sub-moment — with the commentarial supporting-base rule held out).
    For every number `k ≥ 2` of sub-moments, the eye-base premises do not settle the duration view. -/
theorem t3_permission_alone_open (k : Int) (hk : a117_two_submoments k) :
    (∃ w, premises_t3 k w ∧ OneCittaLength k w) ∧ (∃ w, premises_t3 k w ∧ ¬ OneCittaLength k w) := by
  sorry

end FormalAbhidhamma.Khanika2
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

| ID | Statement | Tier | Citation | Status | Lean |
|---|---|---|---|---|---|
| A3 | Proximity (*anantara*): each moment conditions its immediate successor; it holds "even across many thousands of kappas — not remoteness in time" (death-moment → rebirth) | Piṭaka (Paṭṭhāna, quoted) + other | Paṭṭhāna niddesa quoted at `abh03a.att.xml:7693`; across kappas `abh05t.nrf.xml:2409` | VERIFIED — mūla Paṭṭhāna `abh03m7.mul.xml:85–89` (*purimā purimā … pacchimānaṃ pacchimānaṃ … anantarapaccayena paccayo*), read 2026-09-30 | `Stream.tick_succ`, `Stream.continues` |
| A87 | Pre-nascence (*purejāta*): **the five sense organs and the five objects, already arisen, condition the consciousness that takes them**; the heart-base conditions the mind-element, and conditions mind-consciousness "at one time, and at another not" | Piṭaka | `abh03m7.mul.xml:169–177` | VERIFIED | — |
| A103 | **Of conditioned dhammas the past has ceased and the future has not arisen** (⚠️ 2026-10-13 audit: ASSERTED in the Dhammasaṅgaṇī, so an axiom; the Kathāvatthu's refutation of "everything exists" is its CONCLUSION → ANSWERS Kv 1.6, stated — tests nothing at the Piṭaka layer) (the Dhammasaṅgaṇī defines past and future dhammas as the five aggregates). The Theravādin refutes "everything exists" (everywhere? always? in every way?) and "the past exists, the future exists" as the present does: the past is "ceased, gone, changed, set", the future "unborn, unarisen". Past and future are counted among the aggregates yet do not exist; by the sutta of the three ways of speech the past is called "was", the future "will be", the present "is"; an unripe past deed "will ripen" without existing. The anuṭīkā allows "exists" only "by the nature of past and future" (*atītānāgatasabhāvena*); only the present is *dharamāna*. The view refuted is the Sabbamatthivādins'. ⛔ Never "only the present exists" unqualified: nibbāna exists and is time-free (KV-ṭīkā; A8); concepts are time-free but not ultimately real (A104) | Piṭaka (Kathāvatthu, Dhammasaṅgaṇī) + commentarial + sub-commentarial | Dhammasaṅgaṇī §1044–1045 `abh01m.mul.xml:7253–7257` (where it is ASSERTED; the Kathāvatthu's lines — KV 1.6 and its aṭṭhakathā — moved to ANSWERS Kv 1.6, 2026-10-13); anuṭīkā `abh05t.nrf.xml:1581`, `:1597`; KV-ṭīkā `abh03t.tik.xml:1425` | VERIFIED | — |
| A115 | **A sense consciousness arises when its conditions meet**: "when the internal eye is intact, external forms come into range and there is the corresponding attention, then there is the manifestation of the corresponding section of consciousness" (*evaṃ tajjassa viññāṇabhāgassa pātubhāvo hoti*). ⚠️ The sutta asserts the CONDITIONAL; that an instance OCCURS is a reading both parties of Kv 22.10 presuppose (the Theravādin quotes it there and the opponent accepts it) — an ADDED reading, declared. A run that turns it into a conditioning pair also needs A87's law. Added 2026-10-13 for the first `/prove` control (its vetting, finding 4b) | Piṭaka (Sutta) + an added existential reading | MN 28 §306, `s0201m.mul.xml:4216` (where it is ASSERTED; the Kathāvatthu only quotes it, so its lines stay with ANSWERS) | VERIFIED | — |
| A116 | **The five sense consciousnesses ARISE in a pre-born base and in an UNBROKEN base** (*purejātasmiṃ vatthusmiṃ … uppajjanti · asambhinnasmiṃ vatthusmiṃ … uppajjanti*). The commentary: the first is the rejection of CO-ARISING (*sahuppattipaṭikkhepo*: "being later-born themselves, they arise in pre-born bases"); the second means an UNCEASED base — "they do not arise dependent on a ceased, past base". ⚠️ Presence at the ARISING only, never "throughout the consciousness" (that reading was ours, and the vetting refuter killed it 2026-10-13: it is in no layer, and it would import the held-out A69). Kv 10.3 §576 quotes the list as a premise both sides accept. Added 2026-10-13 | Piṭaka (Vibhaṅga) + commentarial (the gloss) | Vibhaṅga §762, `abh02m.mul.xml:9125`, `:9133`; Sammohavinodanī `abh02a.att.xml:7361`, `:7369` | VERIFIED | — |
| A117 | **A mind-moment has at least two sub-moments: its arising-moment and its dissolution-moment** (*cittassa uppādakkhaṇe · cittassa bhaṅgakkhaṇe*), which the Yamaka distinguishes — at a citta's dissolution-moment the truth of suffering does not arise. ⚠️ The Yamaka PRESUPPOSES the two moments; it does not compute them (its answers about what arises at each belong to ANSWERS). The third, standing (*ṭhiti*), is the manual's (A40). Added 2026-10-13 | Piṭaka (Yamaka) | Saccayamaka `abh03m4.mul.xml:16241` (arising-moment), `:16337` (dissolution-moment) | VERIFIED | — |
| A118 | **In the course of existence, at a citta's DISSOLUTION-moment, the truth of suffering does not arise** (*sabbesaṃ cavantānaṃ pavatte cittassa bhaṅgakkhaṇe … dukkhasaccaṃ nuppajjati*); and where the truth of origin ceases, the truth of suffering does not arise (§136). Read LITERALLY — the truth of suffering includes matter — no matter arises at a citta's dissolution-moment. ⚠️ TWO READINGS on record: the Mūlaṭīkā takes it literally (A119); the Vibhaṅga-anuṭīkā (*tayidamakāraṇaṃ*) and the Vibhāvinī restrict the 'no' to the formless world or to mind-born matter (A120). Asserted, not computed, so an axiom (A388 OQ1, sort by content). ⚠️ A proof run rests the literal reading on `:16337` ALONE: §136 (`:18405`) concerns the dissolution of a CRAVING-associated citta only (the Vibhaṅga-anuṭīkā, `abh02t.tik.xml:4949`: *na sabbassa*). Added 2026-10-13 | Piṭaka (Yamaka) | Saccayamaka `abh03m4.mul.xml:16337`; §136 `:18405` | VERIFIED | — |
| A119 | **The Mūlaṭīkā's rule: a citta has no standing-moment, and matter arises only at a citta's ARISING-moment** (*nippariyāyena hi cittassa uppādakkhaṇe eva rūpaṃ uppajjamānaṃ hoti*), argued from the Yamaka's silence on the standing-moment and from A118 read literally. The Vibhāvinī reports it as the view of "others" (*apare … paṭisedhenti*). ⚠️ Framed in the Mūlaṭīkā as a point *to be examined* (*vicāretabbo*); the Vibhaṅga-anuṭīkā (`:4941`) and the Vibhāvinī treat it as his position. ⚠️ The SAME paragraph adds that matter does not serve as a pre-nascent condition until the moment of its co-arisen citta has passed (*cittakkhaṇe pana avītivatte … purejātapaccayakiccaṃ na karoti*) — that clause states the HELD-OUT answer (a base outlasts a mind-moment) and is NOT part of this row. Added 2026-10-13 | sub-commentarial (Ānanda's Mūlaṭīkā) | Vibhaṅga-mūlaṭīkā `abh02t.tik.xml:313`, `:317`; reported at Vibhāvinī `abh07t.nrf.xml:5981` | VERIFIED | — |
| A121 | **The conditioned PASSES AWAY**: "three marks of the conditioned: arising is discernible, passing away is discernible, the alteration of what stands is discernible" (*uppādo paññāyati, vayo paññāyati, ṭhitassa aññathattaṃ paññāyati*); the unconditioned has none of the three (AN 3.48). Added 2026-10-13 so that no conditioned dhamma of a proof run's world exists forever | Piṭaka (Sutta) | AN 3.47 `s0402m2.mul.xml:1492` (AN 3.48 `:1500`) | VERIFIED | — |

## Type freedoms — what the Lean type leaves free, declared before the attempt (A388 OQ4)

- pre is the pre-nascent BASE of a five-sense consciousness; only the base's birth is constrained by the matter rules (objects and other matter are left free)
- the clock: k EQUAL sub-moments to a mind-moment, cittas on a grid from offset 0 — the Visuddhimagga's equal sub-moments (Vism XX §700), a COMMENTARIAL premise carried by the encoding, declared rather than free
- presence need not be an interval: only present at birth (A121), never before it (A103), and bounded (A121); one stream only
- the view is a RECONSTRUCTION: in the mūla the opponent assents to co-arising (abh03m3.mul.xml:13645; KV-a abh03a.att.xml:6353 pavattaṃ sandhāya laddhivasena paṭijānāti); 'duration without co-arising' is an escape the recorded opponent did not take
- T3's layer is COMMENTARIAL BY CHOICE (A120's permission has no Lean form: it is the ABSENCE of a rule), not computed by THEOREMS.md

## Held out — the texts' own answers this run may NOT reason from

- Kv 22.10 §906
- A69
- A4
- the commentarial supporting-base rule (Vism XX §700 e0102n.mul.xml:6029: a citta depends on a base that arose with the PREVIOUS citta and has reached standing — it states the answer)

## Predicted outcome

- **The session predicts:** INDEPENDENT
- **The founder predicts:** (no prediction given)

## Predictions

1. T1 — REFUTED for every k, from A115 + A87 + A116 + A3 (stream) + A119; constructive. A reading reproduced: the Mūlaṭīkā's own paragraph (:317) already states the answer.
2. T2 — the Piṭaka cell turns on the count: REFUTED at two sub-moments (via A3's predecessor citta + A118 read literally); INDEPENDENT at three (a view-true world with the base born at the predecessor's STANDING sub-moment; a view-false world in which the answer is false).
3. T3 — INDEPENDENT for every k ≥ 2 (a view-true world with the base born at the predecessor's DISSOLUTION sub-moment).
4. leak-check: premises_common, premises_t2 and premises_t3 do NOT yield the answer; premises_t1 yields it by hand in three steps (one nonlinear), predicted BEYOND one grind step — if grind finds it, a LEAK to acknowledge (T1 restates the Mūlaṭīkā's own answer).
5. Layers: T1 sub-commentarial (A119); T2's k = 2 half Piṭaka (the count 2 is the Mūlaṭīkā's reading of the Yamaka), its k = 3 half uses the commentarial count (A40, Vism XX §700); T3 commentarial by choice.

## Pass criteria for the instrument

- Not a known-answer control: the mūla argues only the aligned step, so on the duration reading the texts give no answer at the Piṭaka layer to reproduce; the later layers ASSERT it (A4; Vism XX §700's supporting-base rule; the Mūlaṭīkā :317) and those assertions are held out.
- Per the vetting (check 6), every outcome follows from one line of arithmetic once the encodings are fixed — the predictions carry little calibration information; the content is in the encodings, which the run refuter must attack.
- The open questions the vetting raised (OQ-a: is A119's matter clause the Mūlaṭīkā's DERIVATION, hence an answer? OQ-b: can T1–T3, whose premises are sub-commentarial or manual, be graded against the Kv 22.10 row at all?) go to the founder; the run is graded as registered.
