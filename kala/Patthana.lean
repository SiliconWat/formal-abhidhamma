/-
  Paṭṭhāna — the 24 conditions as relations, and the shape of conditioning. EXPLORATORY: not covered by
  PREREGISTRATION.md; the formal core that Abhidhamma-mode runs reason from (founder, 2026-09-30).

  Tiers (spelled out, never [C]/[S]); IDs as in AXIOMS.md:
    A78  the 24 conditions, in the Paṭṭhāna's order ...................... Piṭaka (uddesa) + manual
    A3 · A82 · A99 · A100  proximity, contiguity, absence, disappearance:
         the citta that has just ceased conditions the present one ....... Piṭaka
    A83 · A84 · A96  co-nascence, mutuality, association: arisen
         together, conditioning one another .............................. Piṭaka
    A87  pre-nascence: organ and object, already arisen and still
         present, condition the consciousness ............................ Piṭaka
    A88  post-nascence: a later citta supports the body that arose
         before it ........................................................ Piṭaka
    A90  kamma conditions across time (nānākkhaṇika) ...................... Piṭaka + manual
  The TIMING RULE below (which condition requires which order of arising, and which requires presence) is OURS,
  read from those rows; so is the toy model. A proof assistant checks that conclusions follow from definitions;
  it says nothing about whether nature agrees.
-/
import Axioms
namespace FormalAbhidhamma.Kala

/-- The 24 conditions (A78). -/
inductive Paccaya where
  | hetu | arammana | adhipati | anantara | samanantara | sahajata | annamanna | nissaya
  | upanissaya | purejata | pacchajata | asevana | kamma | vipaka | ahara | indriya
  | jhana | magga | sampayutta | vippayutta | atthi | natthi | vigata | avigata
  deriving DecidableEq, Repr

def Paccaya.all : List Paccaya :=
  [.hetu, .arammana, .adhipati, .anantara, .samanantara, .sahajata, .annamanna, .nissaya,
   .upanissaya, .purejata, .pacchajata, .asevana, .kamma, .vipaka, .ahara, .indriya,
   .jhana, .magga, .sampayutta, .vippayutta, .atthi, .natthi, .vigata, .avigata]

/-- I. Twenty-four, none repeated (A78). -/
theorem twenty_four : Paccaya.all.length = 24 ∧ Paccaya.all.Nodup := by decide

/-- An occurrence of a dhamma: the moment it arises and how many moments it stands (a citta 1, matter 17). -/
structure Occ where
  name : Nat
  rise : Int
  life : Int
  deriving DecidableEq, Repr

def Occ.present (x : Occ) (t : Int) : Bool := decide (x.rise ≤ t) && decide (t < x.rise + x.life)

/-- One conditioning: condition `c` from `src` to `dst`. -/
structure Edge where
  c   : Paccaya
  src : Occ
  dst : Occ
  deriving DecidableEq, Repr

/-- The timing rule (OURS, read from the rows above). -/
def wellTimed (e : Edge) : Bool :=
  match e.c with
  | .anantara | .samanantara | .natthi | .vigata | .asevana =>          -- the condition has just ceased
      decide (e.src.rise + e.src.life = e.dst.rise)
  | .sahajata | .annamanna | .sampayutta | .vipaka =>                    -- arisen together
      decide (e.src.rise = e.dst.rise)
  | .purejata => decide (e.src.rise < e.dst.rise) && e.src.present e.dst.rise   -- arose before, still present
  | .pacchajata => decide (e.dst.rise < e.src.rise) && e.dst.present e.src.rise -- arose after the body it supports
  | .kamma => decide (e.src.rise < e.dst.rise)                          -- across time
  | _ => true

def forward (e : Edge) : Bool := decide (e.src.rise < e.dst.rise)
def simultaneous (e : Edge) : Bool := decide (e.src.rise = e.dst.rise)
def backward (e : Edge) : Bool := decide (e.dst.rise < e.src.rise)

/-- A toy model (OURS): one eye-door moment and its neighbours, dated in mind-moments. -/
def feeling    : Occ := ⟨1, 0, 1⟩
def perception : Occ := ⟨2, 0, 1⟩
def citta0     : Occ := ⟨3, 0, 1⟩
def citta1     : Occ := ⟨4, 1, 1⟩
def body       : Occ := ⟨5, -5, 17⟩
def eye        : Occ := ⟨6, -3, 17⟩
def form       : Occ := ⟨7, -1, 17⟩
def eyeCons    : Occ := ⟨8, 0, 1⟩
def volition   : Occ := ⟨9, -100, 1⟩
def resultant  : Occ := ⟨10, 0, 1⟩

def model : List Edge :=
  [⟨.annamanna, feeling, perception⟩, ⟨.annamanna, perception, feeling⟩,
   ⟨.anantara, citta0, citta1⟩,
   ⟨.purejata, eye, eyeCons⟩, ⟨.purejata, form, eyeCons⟩,
   ⟨.pacchajata, citta1, body⟩,
   ⟨.kamma, volition, resultant⟩]

/-- The model obeys the timing rule (non-vacuity for II–III). -/
theorem model_well_timed : model.all wellTimed = true := by decide

/-- II. Conditioning is not antisymmetric: two distinct dhammas condition each other (mutuality, A84). So the
    relation "x conditions y", taken whole, is NOT a partial order. -/
theorem conditioning_not_antisymmetric :
    ∃ e₁ ∈ model, ∃ e₂ ∈ model, e₁.src = e₂.dst ∧ e₁.dst = e₂.src ∧ e₁.src ≠ e₁.dst := by
  refine ⟨⟨.annamanna, feeling, perception⟩, by decide, ⟨.annamanna, perception, feeling⟩, by decide, rfl, rfl, by decide⟩

/-- III. Conditioning runs in all three directions of ARISING: forward (proximity, pre-nascence, kamma), within one
    moment (co-nascence, mutuality), and backward (post-nascence: the citta arose after the body it supports). -/
theorem three_directions :
    model.any forward = true ∧ model.any simultaneous = true ∧ model.any backward = true := by decide

/-- IV. Post-nascence is not retrocausal: the body a later citta supports is still present when that citta arises.
    ⚠️ BY CONSTRUCTION — it restates the timing rule, a modelling choice, not a derivation. -/
theorem postnascence_supports_a_present_body (e : Edge) (hc : e.c = .pacchajata) (h : wellTimed e = true) :
    e.dst.present e.src.rise = true := by
  unfold wellTimed at h; rw [hc] at h; simp only [Bool.and_eq_true] at h; exact h.2

/-- A chain of proximity in one stream (A3): the transitive closure of "conditions as its immediate successor". -/
inductive Chain (s : Stream) : s.Moment → s.Moment → Prop
  | step {a b} : s.succ a = some b → Chain s a b
  | next {a b c} : Chain s a b → s.succ b = some c → Chain s a c

theorem chain_increases (s : Stream) {a b : s.Moment} (h : Chain s a b) : s.tick a < s.tick b := by
  induction h with
  | step hab => have := s.tick_succ _ _ hab; omega
  | next _ hbc ih => have := s.tick_succ _ _ hbc; omega

/-- V. The proximity chain alone IS a strict order: no moment proximately conditions its way back to itself. -/
theorem proximity_is_irreflexive (s : Stream) (a : s.Moment) : ¬ Chain s a a := fun h => by
  have := chain_increases s h; omega

theorem proximity_is_transitive (s : Stream) {a b c : s.Moment} (h₁ : Chain s a b) (h₂ : Chain s b c) :
    Chain s a c := by
  induction h₂ with
  | step hbc => exact .next h₁ hbc
  | next _ hcd ih => exact .next ih hcd

end FormalAbhidhamma.Kala
