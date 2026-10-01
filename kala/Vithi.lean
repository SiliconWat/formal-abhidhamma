/-
  Vīthi — the five-door cognitive process as arithmetic on the object's life. EXPLORATORY: not covered by
  PREREGISTRATION.md; the formal core that Abhidhamma-mode runs reason from (founder, 2026-09-30).

  Tiers (spelled out, never [C]/[S]); IDs as in AXIOMS.md:
    A4   matter lasts 17 mind-moments .............................. commentarial + manual (Saṅgaha ch. 4 §9)
    A41  the very-great process: 1 past moment + 2 bhavaṅga vibrations
         + 14 process cittas (adverting, sense-consciousness, receiving,
         investigating, determining, 7 javanas, 2 registrations) = 17 . manual (Saṅgaha ch. 4 §10–11)
    A42  the grades: very great (with registration) · great (no
         registration) · slight (no javana; determining two or three
         times) · very slight (only the bhavaṅga vibrates) ............ manual (Saṅgaha ch. 4 §12–15)
    FIT  a stage occurs only if it ends within the object's life ...... manual's commentary for javana and
                                                                         registration (Vibhāvinī `abh07t.nrf.xml:4893`:
                                                                         javana arises only with seven moments of the
                                                                         object's life left; `:4885`: no citta of one
                                                                         five-door process takes a past object); OURS
                                                                         as one rule for every stage
  ⭐ KNOWN ANSWER: the Vibhāvinī gives the grades' ranges (`:4821`): 1 · 2–3 · 4–9 · 10–15 past moments.
  `grades_by_past` derives exactly these from A4 + A41 + FIT, with no range written in. Five-door only.
  A proof assistant checks that the conclusions follow from these definitions; it says nothing about whether nature
  agrees.
-/
import Axioms
namespace FormalAbhidhamma.Kala

/-- The object's life in mind-moments, as a natural number (A4's `lifespan`). -/
def objLife : Nat := lifespan.toNat

/-- Stage lengths, in mind-moments (A41). -/
def vibrations    : Nat := 2   -- *dvikkhattuṃ bhavaṅge calite*
def toDetermining : Nat := 5   -- adverting · sense-consciousness · receiving · investigating · determining
def javanas       : Nat := 7   -- *yebhuyyena sattakkhattuṃ javati*
def registrations : Nat := 2   -- *dve tadārammaṇapākāni*
/-- Slight objects: "determining two or three times" (*dvattikkhattuṃ voṭṭhabbanameva*, A42) — at least two. -/
def minDetermining : Nat := 2

inductive Grade where
  | veryGreat | great | slight | verySlight | none
  deriving DecidableEq, Repr

/-- The grade of an object that enters the door after `p` of its moments have already passed (FIT, ours). -/
def grade (p : Nat) : Grade :=
  if p + vibrations + toDetermining + javanas + registrations ≤ objLife then .veryGreat
  else if p + vibrations + toDetermining + javanas ≤ objLife then .great
  else if p + vibrations + (toDetermining - 1) + minDetermining ≤ objLife then .slight
  else if p + vibrations ≤ objLife then .verySlight
  else .none

/-- I. The Saṅgaha's own sum (ch. 4 §11): one past moment, two vibrations and fourteen process cittas fill the
    object's life EXACTLY — *sattarasa cittakkhaṇāni paripūrenti*. -/
theorem very_great_fills_the_life :
    1 + vibrations + toDetermining + javanas + registrations = objLife := by decide

/-- II. The grades, derived from A4 + A41 + FIT, for an object entering after p = 1 … 16 past moments:
    very great {1} · great {2, 3} · slight {4 … 9} · very slight {10 … 15} · nothing at 16.
    ⭐ A KNOWN ANSWER REPRODUCED: the Saṅgaha gives the grades without ranges; the Vibhāvinī gives exactly these
    (`abh07t.nrf.xml:4821`), and they are derived here, not written in. -/
theorem grades_by_past :
    (List.range' 1 16).map grade =
      [.veryGreat, .great, .great,
       .slight, .slight, .slight, .slight, .slight, .slight,
       .verySlight, .verySlight, .verySlight, .verySlight, .verySlight, .verySlight,
       .none] := by decide

/-- III. The lag: in a very-great process the seven javanas — the moments that cognise — occupy the object's
    9th to 15th moments. Cognition never meets the object in its first eight moments. -/
theorem javanas_occupy_moments_9_to_15 :
    grade 1 = .veryGreat ∧ 1 + vibrations + toDetermining + 1 = 9 ∧
      1 + vibrations + toDetermining + javanas = 15 := by decide

/-- IV. A 16-moment life paired with the SAṄGAHA'S entry convention (the object enters after ≥ 1 past moment) admits no
    very-great process: 1 + 2 + 14 = 17 > 16. ⚠️ RE-SCOPED 2026-09-30 (object-life-budget run, refuter): this MIXES two
    conventions and does not test the 16-holders, who put entry at the ARISING phase, p = 0 (Vibhāvinī `abh07t.nrf.xml:4845`,
    *uppajjamānameva hi rūpaṃ bhavaṅgacalanassa paccayo*; Ledi `e0301n.nrf.xml:2761`) — see IV′. -/
theorem sixteen_admits_no_very_great (p : Nat) (h : 1 ≤ p) :
    ¬ (p + vibrations + toDetermining + javanas + registrations ≤ 16) := by
  simp only [vibrations, toDetermining, javanas, registrations]; omega

/-- IV′. On the 16-holders' own convention — entry at the arising phase, p = 0, a *keci* view the Vibhāvinī reports and
    calls *asāra* (`:4845`) — the very-great process fills a 16-moment life exactly, as the Saṅgaha's fills 17 with p = 1. Both leave 16 moments for the process (the Vibhāvinī defines the grades
    by life LEFT, `:4821`), so the 16 / 17 dispute moves the past-moment ranges, not the grades. -/
theorem sixteen_with_arising_entry_fills_the_life :
    0 + vibrations + toDetermining + javanas + registrations = 16 := by decide

/-- V. Every grade's process ends within the object's life. ⚠️ BY CONSTRUCTION: this is FIT restated, a modelling
    choice, not a derivation (the Vibhāvinī states it for javana and registration, `:4885`, `:4893`). -/
theorem process_never_outlives_its_object (p : Nat) (h : grade p = .veryGreat) :
    p + vibrations + toDetermining + javanas + registrations ≤ objLife := by
  unfold grade at h
  split at h
  · assumption
  · split at h <;> (try split at h) <;> (try split at h) <;> cases h

end FormalAbhidhamma.Kala
