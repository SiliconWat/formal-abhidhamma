import Tax

namespace FormalAbhidhamma.Model

structure Cosmos where
  sunk : Nat
  risen : Nat
  sineruLength : Nat
  sineruWidth : Nat
  oceanDepth : Nat
  
  moon : Nat × Nat × Nat
  sun : Nat × Nat × Nat
  
  moonBottom : Nat
  sunBottom : Nat
  cakkavala : Nat
  litContinents : Nat
  
  dayGain : Nat
  
  planes : List Nat
  
  kingsDay : Nat
  yamaDay : Nat
  
  lifespan : Nat → Nat
  kappaPhases : Nat
  
  fireReaches : Nat
  waterReaches : Nat
  windReaches : Nat
  
  destroyedFields : Nat
  
  planeLife : List Nat

def a14_sineru (c : Cosmos) : Prop :=
  c.sunk = 84000 ∧ c.risen = 84000 ∧ c.sineruLength = 84000 ∧ c.sineruWidth = 84000 ∧ c.oceanDepth = 84000

def a17_discs (c : Cosmos) : Prop := c.moon.1 = 49 ∧ c.moon.2.1 = 49 ∧ c.sun.1 = 50 ∧ c.sun.2.1 = 50

def a19_solids (c : Cosmos) : Prop := c.moon.2.2 = 49 ∧ c.sun.2.2 = 50

def a16_stack (c : Cosmos) : Prop :=
  2 * c.moonBottom ≤ c.risen ∧ c.sunBottom = c.moonBottom + c.moon.2.2 + 1 ∧ c.moonBottom + 100 = c.sunBottom + c.sun.2.2

def a20_day_gain (c : Cosmos) : Prop := c.dayGain = 100000

def a22_three_lit (c : Cosmos) : Prop := c.litContinents = 3

def a23_cakkavala (c : Cosmos) : Prop := c.cakkavala = 1203450

def a48_planes (c : Cosmos) : Prop := c.planes = [4, 7, 16, 4]

def a11_day_lengths (c : Cosmos) : Prop := c.kingsDay = 50 ∧ c.yamaDay = 200

def a49_lifespans (c : Cosmos) : Prop := ∀ k, k ≤ 5 → c.lifespan k = 9000000 * 4 ^ k

def a10_phases (c : Cosmos) : Prop := c.kappaPhases = 4

def a10_limits (c : Cosmos) : Prop := c.fireReaches = 5 ∧ c.waterReaches = 8 ∧ c.windReaches = 9 ∧ c.destroyedFields = 1

def a50_plane_lives (c : Cosmos) : Prop :=
  c.planeLife = [2, 3, 6, 12, 24, 48, 96, 192, 384, 3000, 3000, 6000, 12000, 24000, 48000, 96000, 120000, 240000, 360000, 504000]

end FormalAbhidhamma.Model
