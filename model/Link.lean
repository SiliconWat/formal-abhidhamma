/-
  model/Link.lean — the MIND link of MAT: matter placed in a stream, by the mind-moment and the sub-moment at which it
  arises. FIRST BATCH (2026-10-20): A120 and A118's common core (which sub-moments mind-born matter may arise at) · A64
  and A67 (kamma-born matter from rebirth-linking on; mind-born matter not at the rebirth-linking citta; which cittas
  produce matter). Not yet: K (the death count is OURS: A4's 17 with "ceases with the death citta" makes it include the death
  citta, a DECLARED CHOICE the founder owes) · A4 in stream terms (the same counting choice) · A118's literal scope (a VARIANT).
  For *The Calculus of Moments*, attempt 1 (Protocol 1, its corrections 1–3, amendments 1–2, thonly/the-calculus-of-moments).
  A WORKING encoding: frozen only by Protocol 2, before any model is searched — so this file builds NO model, and no world
  here satisfies the rows (each world below is FORBIDDEN).

  A `Link` is a stream (Mind.lean, any clock scale, any type of moments) with occurrences of matter. Each occurrence has an
  origin (Tax.lean), the mind-moment at which it arises, and which of that moment's three sub-moments. Nothing here fixes
  whether the stream is discrete (Q1) or standard (Q2); the proximity relation is the stream's.
  `rebirth m`: m is a rebirth-linking citta. `produces m`: m is a citta that can produce matter (A64 excludes the immaterial
  resultants and the ten sense-consciousnesses; WHICH moments those are is the PROC/TAX link's). `embodied m`: the being
  whose moment m is has matter (A13: the immaterial have none).

  Q2′ (amendment 2): these definitions quantify over the stream's moments and occurrences and compare readings of the clock
  with `lt`; the audit marks them first-order in form, except A64's "at or before" reading of rebirth, which is a
  disjunction over the order and stays first-order.
-/
import Mind
import Tax
namespace FormalAbhidhamma.Model
open FormalAbhidhamma

/-- The three sub-moments of a mind-moment (A40). -/
inductive Phase | arise | stand | dissolve deriving DecidableEq, Repr

/-- Matter placed in a stream. -/
structure Link (S : Scale) where
  s : Stream S
  K : Type
  origin : K → Origin
  mom : K → s.M
  phase : K → Phase
  rebirth : s.M → Prop
  produces : s.M → Prop
  embodied : s.M → Prop
  /-- death citta (K) -/
  death : s.M → Prop := fun _ => False
  /-- concretely produced matter, as opposed to the intimations and the characteristics (A4) -/
  concrete : K → Bool := fun _ => true
  /-- where an occurrence ceases: the mind-moment and the sub-moment of its dissolution (A4) -/
  ceaseMom : K → s.M
  ceasePhase : K → Phase
  /-- the neither-perception moment before a cessation attainment, and the fruition citta that emerges (A111) -/
  cessation : s.M → Prop := fun _ => False
  fruition : s.M → Prop := fun _ => False
  /-- a sense-consciousness: its base (the organ) and its object, as occurrences (A116, A87) -/
  sense : s.M → Prop := fun _ => False
  base : s.M → Option K := fun _ => none
  object : s.M → Option K := fun _ => none

/-- Steps of proximity: `Steps prox n m m'` — m' is n proximity-steps after m. -/
inductive Steps {M : Type} (prox : M → M → Prop) : Nat → M → M → Prop
  | zero (m : M) : Steps prox 0 m m
  | succ {n : Nat} {m a b : M} : Steps prox n m a → prox a b → Steps prox (n + 1) m b

/-- A120 (L2/L3/L5, `kala/AXIOMS.md`; Vism XX §700 `e0102n.mul.xml`): mind-born matter arises only at a citta's arising sub-moment
    (*nāpi ṭhitikkhaṇe vā bhaṅgakkhaṇe vā uppajjati*). -/
def a120_mind_born_at_arising (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.phase k = .arise

/-- A120, the other half: kamma-born matter arises at all three sub-moments of every citta of an embodied being (*tīsu tīsu
    khaṇesu*, Buddhaghosa's own voice). -/
def a120_kamma_born_at_all_three (S : Scale) (l : Link S) : Prop :=
  ∀ m, l.embodied m → ∀ p : Phase, ∃ k, l.origin k = .kamma ∧ l.mom k = m ∧ l.phase k = p

/-- A118, the COMMON CORE (Protocol 1 correction 1): in the course of existence no mind-born matter arises at a citta's
    dissolution-moment. ⛔ The literal scope (no matter at all, Ānanda) and the formless-only scope (the *apare*) are VARIANTS and
    are not encoded here; never with A120 at base. -/
def a118_core (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.phase k ≠ .dissolve

/-- A64 (L4, ch. 6 §29–36, `abh07t.nrf.xml:2189`): kamma produces matter from rebirth-linking on — every kamma-born occurrence arises at a
    rebirth-linking citta or after one. -/
def a64_kamma_from_rebirth (S : Scale) (l : Link S) : Prop :=
  ∀ k, l.origin k = .kamma → ∃ r, l.rebirth r ∧ (r = l.mom k ∨ S.lt (l.s.arise r) (l.s.arise (l.mom k)))

/-- A64 and A67 (L4, `:2193`, `abh07t.nrf.xml:2321–2329`): mind-born matter arises from the first bhavaṅga on — never at the rebirth-linking
    citta itself (A67: from the second citta). -/
def a67_mind_born_not_at_rebirth (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → ¬ l.rebirth (l.mom k)

/-- A64 (L4, `:2197`): only cittas that produce matter produce it (all but the immaterial resultants and the ten sense-consciousnesses). -/
def a64_mind_born_only_by_producers (S : Scale) (l : Link S) : Prop := ∀ k, l.origin k = .citta → l.produces (l.mom k)

/-- A4 in stream terms (L2/L4, `abh02a.att.xml:413`; `abh07t.nrf.xml:1233`), the COUNT INCLUSIVE of the moment at which the matter arises
    (⚠️ a declared choice, founder 2026-10-20 *"continue per your recommendation"*, the K row's own reading): concretely produced
    matter lasts fifty-one sub-moments, so matter arising at a citta's arising sub-moment ceases at the dissolution-moment of the
    citta sixteen steps on (the "seventeenth"), standing → the arising of the seventeenth step, dissolution → its standing. -/
def a4_life_in_the_stream (S : Scale) (l : Link S) : Prop :=
  ∀ k, l.concrete k = true →
    (l.phase k = .arise → Steps l.s.prox 16 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .dissolve) ∧
    (l.phase k = .stand → Steps l.s.prox 17 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .arise) ∧
    (l.phase k = .dissolve → Steps l.s.prox 17 (l.mom k) (l.ceaseMom k) ∧ l.ceasePhase k = .stand)

/-- K (L4, ch. 6 §56, `abh07t.nrf.xml:2333`): from the standing phase of the seventeenth citta before the death citta (the death citta counted
    as the first, so b is sixteen steps before it), kamma-born matter no longer arises: not at b's standing or dissolution, and at none of
    the cittas from b's successor to the death citta. -/
def k_kamma_born_stops (S : Scale) (l : Link S) : Prop :=
  ∀ d b, l.death d → Steps l.s.prox 16 b d → ∀ k, l.origin k = .kamma →
    ¬ (l.mom k = b ∧ l.phase k ≠ .arise) ∧ ∀ n, 1 ≤ n → n ≤ 16 → ¬ Steps l.s.prox n b (l.mom k)

/-! ## Forbidden worlds -/

/-! ### One moment, one occurrence (whole-number scale) -/

/-- One moment 0 (arise 0, stand 1, dissolve 2, close 3); one occurrence at moment 0 with origin o and phase p. -/
abbrev one (o : Origin) (p : Phase) (rb pr em : Prop) : Link Z :=
  { s := ⟨Unit, fun _ => (0 : Int), fun _ => (1 : Int), fun _ => (2 : Int), fun _ => (3 : Int), fun _ _ => False⟩,
    K := Unit, origin := fun _ => o, mom := fun _ => (), phase := fun _ => p,
    rebirth := fun _ => rb, produces := fun _ => pr, embodied := fun _ => em, ceaseMom := fun _ => (), ceasePhase := fun _ => .dissolve }

/-- Mind-born matter arising at a citta's standing sub-moment. -/
abbrev mindBornStanding : Link Z := one .citta .stand False True True
theorem a120_forbids_mindBornStanding : ¬ a120_mind_born_at_arising Z mindBornStanding := by
  intro h; have := h () rfl; exact absurd this (by decide)

/-- An embodied citta whose standing sub-moment has no kamma-born matter (only an arising one). -/
abbrev kammaOnlyAtArising : Link Z := one .kamma .arise True True True
theorem a120_forbids_kammaOnlyAtArising : ¬ a120_kamma_born_at_all_three Z kammaOnlyAtArising := by
  intro h; obtain ⟨k, _, _, hp⟩ := h () trivial Phase.stand; cases hp

/-- Mind-born matter arising at a citta's dissolution-moment. -/
abbrev mindBornDissolving : Link Z := one .citta .dissolve False True True
theorem a118_forbids_mindBornDissolving : ¬ a118_core Z mindBornDissolving := by
  intro h; exact h () rfl rfl

/-- Kamma-born matter in a stream with no rebirth-linking citta. -/
abbrev kammaNoRebirth : Link Z := one .kamma .arise False True True
theorem a64_forbids_kammaNoRebirth : ¬ a64_kamma_from_rebirth Z kammaNoRebirth := by
  intro h; obtain ⟨r, hr, _⟩ := h () rfl; exact hr

/-- Mind-born matter arising at the rebirth-linking citta itself. -/
abbrev mindBornAtRebirth : Link Z := one .citta .arise True True True
theorem a67_forbids_mindBornAtRebirth : ¬ a67_mind_born_not_at_rebirth Z mindBornAtRebirth := by
  intro h; exact h () rfl trivial

/-- Mind-born matter produced by a citta that does not produce it (an immaterial resultant or a sense-consciousness). -/
abbrev mindBornByNonProducer : Link Z := one .citta .arise False False True
theorem a64_forbids_mindBornByNonProducer : ¬ a64_mind_born_only_by_producers Z mindBornByNonProducer := by
  intro h; exact h () rfl

/-! ### A chain of moments 0, 1, 2, …: moment n arises at 3n, each the proximate successor of the one before -/

abbrev chain : Stream Z := ⟨Nat, fun n => (3 * n : Int), fun n => (3 * n + 1 : Int), fun n => (3 * n + 2 : Int), fun n => (3 * n + 3 : Int), fun m n => n = m + 1⟩

@[local simp] theorem chain_steps {n a b : Nat} (h : Steps chain.prox n a b) : b = a + n := by
  induction h with
  | zero m => rfl
  | succ _ hp ih => have : _ = _ := hp; omega

@[local simp] theorem chain_reach : ∀ n : Nat, Steps chain.prox n 0 n := by
  intro n; induction n with
  | zero => exact Steps.zero 0
  | succ n ih => exact Steps.succ ih (show n + 1 = n + 1 from rfl)

/-- A chain with one occurrence at moment `m` and phase `p`, origin `o`, ceasing at moment `cm` in phase `cp`; moment `dm` is the death citta. -/
abbrev chainLink (o : Origin) (m : Nat) (p : Phase) (cm : Nat) (cp : Phase) (dm : Nat) : Link Z :=
  { s := chain, K := Unit, origin := fun _ => o, mom := fun _ => m, phase := fun _ => p,
    rebirth := fun _ => False, produces := fun _ => True, embodied := fun _ => True,
    death := fun d => d = dm, ceaseMom := fun _ => cm, ceasePhase := fun _ => cp }

/-- Matter arising at a citta's arising that ceases at the dissolution of the fifteenth step on (sixteen moments, not seventeen). -/
abbrev dies16 : Link Z := chainLink .utu 0 .arise 15 .dissolve 0
theorem a4_forbids_dies16 : ¬ a4_life_in_the_stream Z dies16 := by
  intro h
  have := chain_steps (((h () rfl).1 rfl).1)
  simp at this

/-- Matter arising at a citta's standing that ceases at the arising of the sixteenth step on rather than the seventeenth. -/
abbrev standsTooShort : Link Z := chainLink .utu 0 .stand 16 .arise 0
theorem a4_forbids_standsTooShort : ¬ a4_life_in_the_stream Z standsTooShort := by
  intro h
  have := chain_steps (((h () rfl).2.1 rfl).1)
  simp at this

/-- Kamma-born matter arising at the standing phase of the seventeenth citta before the death citta (moment 0; death at 16). -/
abbrev kammaAtStanding : Link Z := chainLink .kamma 0 .stand 0 .arise 16
theorem k_forbids_kammaAtStanding : ¬ k_kamma_born_stops Z kammaAtStanding := by
  intro h
  exact (h 16 (0 : Nat) rfl (chain_reach 16) () rfl).1 ⟨rfl, by decide⟩

/-- Kamma-born matter arising at a later citta before the death citta (moment 3; death at 16, so b = 0). -/
abbrev kammaLater : Link Z := chainLink .kamma 3 .arise 0 .arise 16
theorem k_forbids_kammaLater : ¬ k_kamma_born_stops Z kammaLater := by
  intro h
  exact (h 16 (0 : Nat) rfl (chain_reach 16) () rfl).2 3 (by decide) (by decide) (chain_reach 3)

/-- The clock reading of a sub-moment of a moment. -/
def Phase.at (S : Scale) (s : Stream S) (m : s.M) : Phase → S.T
  | .arise => s.arise m | .stand => s.stand m | .dissolve => s.dissolve m

/-- Occurrence k has arisen and not yet ceased when moment m arises: it arose at a strictly earlier reading and has not ceased before m's arising. -/
def present_at_arising (S : Scale) (l : Link S) (k : l.K) (m : l.s.M) : Prop :=
  S.lt (l.phase k |>.at S l.s (l.mom k)) (l.s.arise m) ∧ ¬ S.lt (l.ceasePhase k |>.at S l.s (l.ceaseMom k)) (l.s.arise m)

/-- A116 (L1/L2, Vibhaṅga §762 `abh02m.mul.xml:9125`; Sammohavinodanī `abh02a.att.xml:7361`): a sense-consciousness arises in a pre-born, unceased
    base — the base has arisen before it and has not ceased when it arises. Presence at the ARISING only, never "throughout". -/
def a116_prenascent_unceased_base (S : Scale) (l : Link S) : Prop :=
  ∀ m, l.sense m → ∃ k, l.base m = some k ∧ present_at_arising S l k m

/-- A87, the MAT half (L1, `abh03m7.mul.xml:169–177`): the organ and the object are already arisen, and unceased, when the consciousness that takes them arises. (The
    condition relation itself, pre-nascence, is the COND link's.) -/
def a87_organ_and_object_already_arisen (S : Scale) (l : Link S) : Prop :=
  ∀ m, l.sense m → (∃ k, l.base m = some k ∧ present_at_arising S l k m) ∧ (∃ k, l.object m = some k ∧ present_at_arising S l k m)

/-! ### Forbidden worlds: A116, A87 -/

/-- Two moments, 0 and 1 on the chain; a sense-consciousness at 1 whose base arises at moment 1 itself (co-arising). -/
abbrev coarisingBase : Link Z :=
  { (chainLink .kamma 1 .arise 3 .dissolve 99) with sense := fun m => m = 1, base := fun m => (if m = 1 then some () else none : Option Unit), object := fun m => (if m = 1 then some () else none : Option Unit) }
theorem a116_forbids_coarisingBase : ¬ a116_prenascent_unceased_base Z coarisingBase := by
  intro h
  obtain ⟨k, hk, hp⟩ := h 1 rfl
  have := hp.1
  simp [Phase.at, coarisingBase, chainLink] at this

/-- A sense-consciousness whose base arose at moment 0 but ceased at moment 0's dissolution, before moment 1 arises. -/
abbrev ceasedBase : Link Z :=
  { (chainLink .kamma 0 .arise 0 .dissolve 99) with sense := fun m => m = 1, base := fun m => (if m = 1 then some () else none : Option Unit), object := fun m => (if m = 1 then some () else none : Option Unit) }
theorem a116_forbids_ceasedBase : ¬ a116_prenascent_unceased_base Z ceasedBase := by
  intro h
  obtain ⟨k, hk, hp⟩ := h 1 rfl
  have := hp.2
  simp [Phase.at, ceasedBase, chainLink] at this

/-- A sense-consciousness with no object. -/
abbrev noObject : Link Z :=
  { (chainLink .kamma 0 .arise 5 .dissolve 99) with sense := fun m => m = 1, base := fun m => (if m = 1 then some () else none : Option Unit) }
theorem a87_forbids_noObject : ¬ a87_organ_and_object_already_arisen Z noObject := by
  intro h
  obtain ⟨_, k, hk, _⟩ := h 1 rfl
  simp [noObject] at hk

/-- A122 (L1, `abh07t.nrf.xml:1941`, the Paṭṭhāna's rebirths of different class): the death citta conditions the rebirth-linking citta by proximity — what comes
    immediately after a death citta is a rebirth-linking citta. -/
def a122_death_then_rebirth (S : Scale) (l : Link S) : Prop := ∀ d n, l.death d → l.s.prox d n → l.rebirth n

/-- A122, the other way: a rebirth-linking citta is immediately preceded by a death citta (every existence is joined to the one before it). -/
def a122_rebirth_after_death (S : Scale) (l : Link S) : Prop := ∀ r, l.rebirth r → ∃ d, l.death d ∧ l.s.prox d r

/-- A death citta followed at once by a moment that is no rebirth-linking citta (moment 1 follows death at 0; only moment 2 is a rebirth). -/
abbrev deathNotFollowed : Link Z :=
  { (chainLink .kamma 0 .arise 0 .dissolve 0) with rebirth := fun m => m = 2 }
theorem a122_forbids_deathNotFollowed : ¬ a122_death_then_rebirth Z deathNotFollowed := by
  intro h
  have := h 0 1 rfl rfl
  simp [deathNotFollowed, chainLink] at this

/-- A rebirth-linking citta whose predecessor is no death citta (rebirth at 5, death at 0). -/
abbrev rebirthNotAfterDeath : Link Z :=
  { (chainLink .kamma 0 .arise 0 .dissolve 0) with rebirth := fun m => m = 5 }
theorem a122_forbids_rebirthNotAfterDeath : ¬ a122_rebirth_after_death Z rebirthNotAfterDeath := by
  intro h
  obtain ⟨d, hd, hp⟩ := h 5 rfl
  simp [rebirthNotAfterDeath, chainLink] at hd hp
  omega

/-- A58 (L4, ch. 5 §99–102, `abh07t.nrf.xml:1989–2005`): every citta lies at or after the rebirth-linking citta of its own existence — some rebirth-linking citta is the moment itself or arises before it. -/
def a58_begins_with_rebirth (S : Scale) (l : Link S) : Prop := ∀ m, ∃ r, l.rebirth r ∧ (r = m ∨ S.lt (l.s.arise r) (l.s.arise m))

/-- A47 (L5, `abh07t.nrf.xml:1501`, `:5193`): within a life the process and the bhavaṅga run unbroken — every moment has a proximate successor. The cessation exception is on the CLOCK
    only (A112, Clocks.lean): proximity itself holds across it. -/
def a47_unbroken (S : Scale) (l : Link S) : Prop := ∀ m, ∃ n, l.s.prox m n

/-- A111, emergence (L1/L2/L4, MN 43; `kala/AXIOMS.md`): the attainer emerges by one fruition citta — the proximate successor of the neither-perception moment before cessation is a fruition citta. -/
def a111_emerges_by_fruition (S : Scale) (l : Link S) : Prop := ∀ m n, l.cessation m → l.s.prox m n → l.fruition n

/-- A111, no death within: the attainer does not die during cessation — neither the moment before it nor the one that emerges is a death citta. -/
def a111_no_death_within (S : Scale) (l : Link S) : Prop := ∀ m n, l.cessation m → l.s.prox m n → ¬ l.death m ∧ ¬ l.death n

/-- A stream of two moments, and nothing after the second. -/
abbrev endsAtOnce : Link Z :=
  { s := ⟨Bool, fun b => if b then (4 : Int) else 0, fun b => if b then (5 : Int) else 1, fun b => if b then (6 : Int) else 2, fun b => if b then (7 : Int) else 3, fun m n => m = false ∧ n = true⟩,
    K := Unit, origin := fun _ => .kamma, mom := fun _ => false, phase := fun _ => .arise,
    rebirth := fun m => m = false, produces := fun _ => True, embodied := fun _ => True,
    ceaseMom := fun _ => false, ceasePhase := fun _ => .dissolve }
theorem a47_forbids_endsAtOnce : ¬ a47_unbroken Z endsAtOnce := by
  intro h
  obtain ⟨n, hn⟩ := h true
  exact absurd hn.1 (by decide)

/-- A stream with no rebirth-linking citta at all. -/
abbrev noRebirthAnywhere : Link Z := { (chainLink .kamma 0 .arise 0 .dissolve 99) with rebirth := fun _ => False }
theorem a58_forbids_noRebirthAnywhere : ¬ a58_begins_with_rebirth Z noRebirthAnywhere := by
  intro h
  obtain ⟨r, hr, _⟩ := h 0
  exact hr

/-- Cessation emerging by a citta that is no fruition (moment 0 is the cessation moment, moment 1 follows and is not a fruition). -/
abbrev emergesByOther : Link Z := { (chainLink .kamma 0 .arise 0 .dissolve 99) with cessation := fun m => m = 0, fruition := fun m => m = 5 }
theorem a111_forbids_emergesByOther : ¬ a111_emerges_by_fruition Z emergesByOther := by
  intro h
  have := h 0 1 rfl rfl
  simp [emergesByOther, chainLink] at this

/-- A death during cessation (moment 1 follows the cessation moment 0 and is the death citta). -/
abbrev diesInCessation : Link Z := { (chainLink .kamma 0 .arise 0 .dissolve 1) with cessation := fun m => m = 0 }
theorem a111_forbids_diesInCessation : ¬ a111_no_death_within Z diesInCessation := by
  intro h
  exact (h 0 1 rfl rfl).2 rfl

end FormalAbhidhamma.Model
