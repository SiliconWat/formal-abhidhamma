namespace FormalAbhidhamma.Model

inductive Sort5 | citta | cetasika | rupa | nibbana | pannatti deriving DecidableEq, Repr

inductive Designation | derivation | relative | collection | placing | ownNature | continuity deriving DecidableEq, Repr

inductive Space | delimiting | kasina | unentangled deriving DecidableEq, Repr

inductive Link12 | ignorance | formations | consciousness | mindMatter | sixBases | contact | feeling | craving | clinging | becoming | birth | decayDeath
  deriving DecidableEq, Repr

structure Status where
  ultimates : List Sort5
  timeFree : List Sort5
  spaceSort : Space → Sort5
  realDesignation : Designation → Bool
  nibbanaConditioned : Bool
  nibbanaCount : Nat
  
  timeSort : Sort5
  
  chain : List Link12
  periods : List Nat
  modes : Nat
  connections : Nat
  groups : Nat
  rounds : Nat
  roots : Nat

def a26_ultimates (c : Status) : Prop := c.ultimates = [.citta, .cetasika, .rupa, .nibbana]

def a8_time_free (c : Status) : Prop := c.timeFree = [.nibbana, .pannatti]

def a9_three_spaces (c : Status) : Prop :=
  c.spaceSort .delimiting = .rupa ∧ c.spaceSort .kasina = .pannatti ∧ c.spaceSort .unentangled = .pannatti

def a70_nibbana (c : Status) : Prop := c.nibbanaConditioned = false ∧ c.nibbanaCount = 1

def a7_time_is_a_concept (c : Status) : Prop := c.timeSort = .pannatti ∧ c.timeSort ∉ c.ultimates

def a5_delimiting_space_is_matter (c : Status) : Prop := c.spaceSort .delimiting = .rupa

def a104_time_is_a_concept (c : Status) : Prop := c.timeSort = .pannatti

def a126_only_own_nature (c : Status) : Prop := ∀ d, c.realDesignation d = true ↔ d = .ownNature

def a76_twelve_links (c : Status) : Prop :=
  c.chain = [.ignorance, .formations, .consciousness, .mindMatter, .sixBases, .contact, .feeling, .craving, .clinging, .becoming, .birth, .decayDeath]

def a77_structure (c : Status) : Prop :=
  c.periods = [2, 8, 2] ∧ c.modes = 20 ∧ c.connections = 3 ∧ c.groups = 4 ∧ c.rounds = 3 ∧ c.roots = 2

end FormalAbhidhamma.Model
