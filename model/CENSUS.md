# CENSUS — every live axiom, sorted for the one-model attempt

*A WORKING FILE for* The Calculus of Moments, *attempt 1* ([Protocol 1](https://github.com/thonly/the-calculus-of-moments/blob/main/protocol/2026-10-15-attempt-1.md)).
*This is not frozen. It changes as the encoding is written, and the version that counts is the one Protocol 2 freezes,
by commit, before any model is searched. Where this file and `kala/AXIOMS.md` disagree, AXIOMS.md wins.*

**Scope:** the 127 live rows of `kala/AXIOMS.md` at `332b501` (VERIFIED, not HELD OUT). A59, A69, A102 and A119 are HELD
OUT, A12 is RECALLED, and A0 and A0′ are windows. None of them enters.

**Classes:** **C** = CONSTRAINT (a definition `aNN_… : World → Prop`, with a forbidden world) · **T** = BY THE TYPE (holds
because of how `World` is built; listed, never counted as tested) · **N** = NOT FORMALIZABLE (with the reason).

**Layers** (Protocol 1 §5, with correction 1): L1 Piṭaka · L2 commentaries (aṭṭhakathā, Visuddhimagga) · L3
sub-commentaries (ṭīkā) · L4 the manual (Abhidhammattha-saṅgaha) · L5 the manual's commentaries (Vibhāvinī; Ledi's
Paramatthadīpanī and Anudīpanī). A row enters at the latest layer among the clauses its base encoding uses. A row
split by clause shows each clause's layer.

**Parts of `World`:** TAX (the taxonomy: kinds and their counts) · MIND (streams, mind-moments, sub-moments,
existences) · PROC (cognitive processes) · MAT (kalāpas: origin, birth, life, place) · COND (the 24 conditions as
relations) · COSMO (Sineru, the sun and moon, planes, days, eons) · STATUS (concepts, time, nibbāna).

**Occurs** names the occurrence conditions a row contributes (Protocol 1 §4: the empty world must fail).
**Watch** marks a rival reading (a VARIANT, see correction 1), a possible scope collision, or a known tension.

| ID | Layer | Class | Part | The encoding, in one line | Occurs | Watch |
|---|---|---|---|---|---|---|
| A26 | L4 | T | STATUS | ultimate entities are one of four sorts: citta, cetasika, rūpa, nibbāna; concepts are a separate sort | each sort | — |
| A27 | L4 | C | TAX | the kinds with their own characteristic number 72 (the breakdown 1 + 52 + 18 + 1 is OURS, never an axiom) | — | OURS clause excluded, so the encoding is weak by the row's own words (a count of 72 distinct entities) |
| A28 | L4 | C | TAX | the generated citta-types number 89, and 121 by the jhāna reckoning (`sangaha/Check.lean`) | each of the 89 types in some stream | — |
| A29 | L4 | C | TAX | the cetasikas number 52, in classes of 7 · 6 · 14 · 25 | each of the 52 in some moment | — |
| A30 | L4 | T | MIND | a mind-moment is one citta with its cetasika set, so they arise, cease, take an object and have a base together | — | by the type: the model cannot separate them |
| A31 | L4 | C | TAX | the seven universals are in every citta-type | — | — |
| A32 | L4 | C | TAX | the 18 association rules and 9 generator clauses (`sangaha/Rules.lean`) | — | VARIANT: the *keci* illimitables (`illimitablesKeci`) |
| A128 | L2 | N | — | states perception's FUNCTION by similes (a carpenter's mark, a mole); nothing structural beyond A31's presence of perception | — | — |
| A33 | L4 | C | TAX | feeling three- and fivefold; per-citta feeling counts 1 · 1 · 62 · 2 · 55 (121 reckoning) | — | — |
| A34 | L4 | C | TAX | root counts 18 · 2 · 22 · 47 | — | — |
| A35 | L4 | C | TAX+PROC | 14 functions, 10 stations; per-citta function counts 68 · 2 · 9 · 8 · 2; a process station holds only a citta-type with that function | each function performed | ⏳ COVERAGE: the cited lines (§20–32) give which types perform each function; the row carries only the counts (`a35_which`, from the cited lines: correction 2 §2) |
| A36 | L4 | C | PROC | six doors; the mind-door is a bhavaṅga moment; 19 citta-types are door-free | each door used | — |
| A37 | L4 | C | PROC | a sense-door citta takes a PRESENT object; a mind-door citta takes a present, past, future or time-free object | — | ⚠️ the eye-door-only-visible-form clause of §51 is not in the row's words (finding 5); the mind-door clause permits (finding 6) |
| A38 | L4 | C | TAX+PROC | object scopes by citta-type (sense-consciousness one kind; supramundane only nibbāna; 25 · 21 · 5) | — | ⚠️ ROW ERROR: "5 take any object" misreads §59 (`:1077`) and the verse (`:1105`, *chacceti*): six take any object, five all but the arahant's path and fruit; encoded as the text (correction 2 §1) · the other three groups (6 · 20 · 5) from the cited lines (§2) |
| A39 | L4 | C | MAT+MIND | six bases; by sphere (all six in the sense sphere, no nose, tongue or body in the fine-material, none in the immaterial); dependence of each consciousness | — | — |
| A1 | L1 (shared premise) · L2 | C | MIND | at most one citta per tick in a stream | — | — |
| A40 | L2 | C | MIND | a mind-moment is three equal sub-moments: arising, standing, dissolution | — | — |
| A4 | L2 | C | MAT | concretely produced matter lasts 17 mind-moments (51 sub-moments) | — | VARIANT: 16 (a ṭīkā's reading), 16⅓ (a ṭīkā's report) |
| A41 | L5 | C | PROC | the very great five-door process: entry after one past moment, 2 vibrations, 14 process cittas, then the object ceases (17) | a very great five-door process | VARIANT: Ledi, 6 or 5 javanas for weak objects; dissents the Vibhāvinī rejects are not encoded |
| A42 | L5 | C | PROC | grades by past moments: 1 · 2–3 · 4–9 · 10–15, as the row gives them (the fit rule that derives them in `kala/Vithi.lean` is not encoded: extending it to every stage is OURS) | each grade | the *keci* 16-moment view is A4's variant · ✅ "with registration" read as §10's *yathārahaṃ* (finding 4, correction 3) |
| A43 | L4 | C | PROC | mind-door process (clear: registration; obscure: none); absorption after 3 or 4 preparatory javanas, with no registration | a mind-door process; an absorption | absorption read from §21 (the 26 exalted and supramundane javanas), so the path process is one (correction 2 §2) |
| A44 | L4 | C | PROC | javana counts: 7 (or 6); 5 at death; a first absorption and super-knowledge once; a path citta one moment, then 2 or 3 fruition | — | VARIANT: the reported twin-miracle reviewing (*vadanti*) |
| A45 | L4 | C | PROC | registration only for sense-sphere beings, objects and javana, on a clear or very great object; resultant follows desirability | — | VARIANT: the teachers' intervening equanimity investigation |
| A46 | L4 | C | MIND | no wholesome or unwholesome javana for arahants; no functional javana for others; supramundane javana only for noble persons; non-percipient beings have no citta | — | — |
| A47 | L5 | C | MIND | within a life, processes and bhavaṅga run unbroken for the life-span, except during cessation (the Vibhāvinī's clause, quoted in the row) | — | the root alone (L4) would collide with A111; the row carries the exception |
| A24 | L2 | C | MIND+COSMO | more than 10¹² cittas per finger-snap; no citta lasts a night or a day | — | freedom: the finger-snap's length against the day is not given |
| A25 | L1 | N | — | a simile with no number (*lahuparivattaṃ*) | — | — |
| A48 | L4 | C | COSMO+MIND | 31 planes (4 · 7 · 16 · 4); no worldling in the Pure Abodes; no noble person among the non-percipient or in the states of loss | a stream in each plane at some time | — |
| A49 | L4 | C | COSMO | deva life-spans 9×10⁶ human years × 4ᵏ; no fixed limit for humans and the states of loss | — | freedom: the 360-day divine year (OURS, not read) |
| A50 | L4 | C | COSMO | fine-material and immaterial life-spans in kappas (19 figures, 20 planes) | — | freedom: which kappa |
| A51 | L4 | C | MIND | four kinds of rebirth-linking; 19 such citta-types; in one existence the rebirth citta, bhavaṅga and death citta are one type with one object | each kind of rebirth | — |
| A52 | L4 | T | MIND | kamma carries four classifications (function, order, time, plane) | — | — |
| A53 | L4 | C | MIND | the kamma-door classifications; fine-material and immaterial kamma is mind-kamma only | — | — |
| A54 | L4 | C | MIND | kamma → rebirth and resultants (the table at its cited lines, captured in full) | — | VARIANT: *kecana*, prompted ↔ unprompted |
| A55 | L4 | T | MIND | each death is one of four kinds | each kind of death | — |
| A56 | L4 | C | MIND | at death a sign presents at a door; the rebirth-linking citta arises immediately after the death citta | a death followed by a rebirth | — |
| A57 | L4 | C | PROC | death javanas are five; the rebirth citta may take a present object; kamma is always past | — | "can take a present object" permits (finding 6) |
| A58 | L4 (L1 for the womb-born) | C | MIND | every existence with mind begins with its rebirth-linking citta; every citta lies at or after it | — | — |
| A11 | L1 | C | COSMO | day-lengths by realm (50 human years = one Four-Great-Kings day; 200 = one Yāma day) | — | — |
| A13 | L1 · L2 · L4 | C | MIND+MAT | a non-percipient existence: matter and a life faculty, no citta; an immaterial existence: citta, no matter | each | — |
| A60 | L4 | C | TAX | 28 kinds of matter, 18 concretely produced, 10 not | each concretely produced kind in some kalāpa | — |
| A61 | L1 · L4 | T | MAT | matter has no object and no root (no field for either); its conditioned origin is A64's | — | — |
| A5 | L1 (ṭīkās' reading) · L4 · L5 | C | MAT | the space element delimits kalāpas and has no birth of its own: present exactly when both neighbors are | — | VARIANT: the Atthasālinī's unentangled space (linked to A9) |
| A9 | L1 · L2 | C | STATUS | delimiting space is conditioned; kasiṇa-removed space and unentangled space are concepts | — | VARIANT: unentangled space as rūpa (A5's rival) |
| A6 | L2 | T | MAT | matter outside a being's faculties is bound to no being (its owner field is empty) | matter outside any being | — |
| A15 | L4 | C | MAT | every kalāpa carries the inseparable eight; lightness only in beings' mind-, temperature- and nutriment-born groups | — | the gravity link is OURS, excluded |
| A62 | L4 | C | TAX | matter's dyads (12 gross, impinging; 16 subtle; visible = visible form only; clung-to = kamma-born) | — | ⏳ COVERAGE: "base or not; door or not; faculty or not" name dyads without members (§20–22 give 6 · 7 · 8; from the cited lines, correction 2 §2) |
| A63 | L4 | C | MAT | eye and ear take objects not in contact; nose, tongue and body only objects in contact | — | VARIANT: the commentaries' sense of "reached" |
| A64 | L4 | C | MAT | the four origins and their timing (kamma every moment from rebirth-linking; citta at its arising from the first bhavaṅga, not the immaterial resultants or the ten sense-consciousnesses; temperature at standing, inside and outside; nutriment at standing once swallowed); one heat scalar | each origin | — |
| A65 | L4 | C | TAX+MAT | the origin table; 18 · 15 · 13 · 12; the characteristics from none | — | — |
| A66 | L4 (+ Paramatthadīpanī L5) | C | MAT | a kalāpa has one arising, one base; one cessation for concretely produced matter; 21 kalāpas (9 · 6 · 4 · 2); outside beings only the pure octad and the sound nonad, both temperature-born | each of the 21 | — |
| A67 | L4 | C | MAT | the decads at conception by birth mode; kamma-born from rebirth-linking, mind-born from the second citta; four-origin continuity for the life-span | — | ⚠️ SCOPE COLLISION expected: no exception for cessation (A111) or the non-percipient (A13), and Ledi's exception covers only three-origin matter |
| A129 | L2 · L3 | C | MAT | the size ladder (36 · 36 · 36 · 36 · 7 · 7 · 7); a kalāpa is of *paramāṇu* size (the Vism-ṭīkā) | — | VARIANT: Ledi, a kalāpa ≤ 1/49 *paramāṇu* |
| A114 | L1 · L2 · L3 · L5 | C | MAT | breath is mind-born only; absent in seven cases (womb, under water, the *asaññībhūta*, the dead, fourth jhāna, fine-material and immaterial beings, cessation); a matter-producing citta produces breath unless obstructed | — | VARIANT: *asaññībhūta* as the non-percipient only (the Vism's two-way word); tension with A47 + A64 in a swoon (runs/2026-09-30-breath-in-the-unconscious) |
| K | L4 | C | MAT | at death, kamma-born matter stops arising from the standing phase of the 17th citta before the death citta; earlier ones cease with the death citta; mind- and nutriment-born stop; temperature-born continues as the corpse | a corpse | the count including the death citta is OURS → a declared choice |
| A68 | L4 | C | MAT+COSMO | kinds of matter by plane (28 · 23 · 17 · none) | — | — |
| A70 | L4 | C | STATUS+PROC | path and fruition cittas take nibbāna; nibbāna is unconditioned, one by nature (the rest is by the type: nibbāna is an object, never a moment) | — | — |
| A71 | L4 | C | TAX | the unwholesome categories as nine groups made of the 14 unwholesome cetasikas (captured in full) | — | — |
| A72 | L4 | C | TAX | the mixed categories (6 · 7 · 12 · 22 · 9 · 4 · 4) over cetasikas, cittas and matter | — | — |
| A73 | L4 | C | TAX | 37 requisites in 7 groups are 14 dhammas | — | — |
| A74 | L4 | C | TAX | 5 · 5 · 12 · 18 · 4; nibbāna outside the aggregates; the mind-object base = 69 (52 + 16 + 1); 7 consciousness elements | — | — |
| A75 | L4 | N | — | a statement about how the teaching PRESENTS conditionality (two ways), not about what occurs | — | — |
| A76 | L1 · L4 | C | MIND+COND | the twelve links as conditioning steps across existences (mapping per the Saṅgaha's cited lines) | — | — |
| A77 | L4 (+ L2, L3 assertions) | C | MIND | the three periods; the round is beginningless | a beginningless stream | — |
| C | L1 (join) · L2 | C | MIND+COND | every citta has an immediate predecessor citta that conditions it by proximity; matter does not arise by proximity | — | — |
| A78 | L1 · L4 | C | COND | the 24 conditions (`matika/`) | each condition between some pair | — |
| A79 | L1 | C | COND | root: the roots condition their associated states and the matter those states originate | — | relata from `matika/RELATA` |
| A80 | L1 | C | COND | object: each object conditions the citta that takes it; any dhamma can condition mind-consciousness | — | — |
| A81 | L1 | C | COND | predominance: the four predominants; the esteemed object | — | — |
| A3 | L1 · L2 | C | MIND+COND | proximity: each citta conditions its immediate successor; order, not time | — | — |
| A82 | L1 | C | COND | contiguity: the same relata as proximity | — | the grouping with absence and disappearance is HELD OUT |
| A83 | L1 | C | COND | co-nascence: mental aggregates, great elements, mind and matter at conception; citta → mind-born matter; elements → derived | — | — |
| A84 | L1 · L3 | C | COND | mutuality: mental aggregates, great elements, mind-and-matter at conception, each to the others | — | "symmetric, so not a partial order" is OURS |
| A85 | L1 | C | COND | support: the co-nascent relations; each organ for its consciousness; the base for mind | — | — |
| A86 | L1 · L4 | C | COND | decisive support: earlier states condition later ones; three kinds | — | — |
| A87 | L1 | C | COND+MAT | pre-nascence: the five organs and objects, already arisen, condition the consciousness that takes them; the heart-base the mind-element | — | — |
| A115 | L1 (+ an added existential reading) | C | PROC | when the eye is intact, form in range, and attention, eye-consciousness arises | an instance (the added reading, declared) | the conditional over meetings; the manifesting consciousness as a process step is the MIND link (finding 7) |
| A116 | L1 · L2 | C | MAT+PROC | the five sense-consciousnesses arise in a pre-born, unceased base (presence at arising only) | — | — |
| A117 | L1 | C | MIND | a mind-moment has an arising-moment and a dissolution-moment | — | — |
| A118 | L1 (wording) · L3 (scope) | C | MIND+MAT | COMMON CORE (correction 1): in the course of existence, no mind-born matter arises at a citta's dissolution-moment; in the formless world no truth of suffering arises then | — | VARIANT: Ānanda's literal scope (no matter at all); the *apare*'s formless-only scope. ⛔ never with A120 at base |
| A120 | L2 · L3 · L5 | C | MAT | kamma-born matter arises at all three sub-moments of every citta (Vism XX §700, Buddhaghosa's own voice); mind-born only at arising | — | the rival line to A118's literal scope; VARIANT: `:433`'s literal extension |
| A121 | L1 | C | MIND+MAT | every conditioned dhamma passes away (finite duration) | — | — |
| A122 | L1 | C | MIND+COND | the death citta conditions the rebirth-linking citta by proximity (different-class rebirths) | — | — |
| A123 | L1 | T | MIND | the consciousness aggregate is citta (one sort) | — | — |
| A124 | L1 · L2 | C | MIND | capable and incapable of the path (the six obstructions and qualities, per birth) | an incapable being; a capable one | VARIANT: conjunctive (Piṭaka) vs disjunctive (commentaries), and the seventh quality |
| A125 | L1 · L2 | C | MIND | COMMON CORE (correction 1): a person with entirely black states is found in the world, sunk now | such a person | VARIANT: "stays sunk" in every later existence (the AN commentary's own voice); the restricted reading is HELD OUT (Kv 19.7) |
| A88 | L1 · L2 · L5 | C | COND+MAT | post-nascence: later citta supports a body that arose before it and is still present | — | — |
| A89 | L1 | C | COND | repetition: earlier javana conditions the next of its kind | — | — |
| A90 | L1 | C | COND | kamma: across time to resultants and kamma-born matter; volition co-nascently; no stored trace | — | — |
| A91 | L1 | C | COND | result: resultant mental aggregates condition one another | — | — |
| A92 | L1 | C | COND | nutriment: edible food → this body; mental nutriments → their associated states and matter | — | — |
| A93 | L1 | C | COND | faculty: sense faculties → their consciousness; material life faculty → kamma-born matter; mental faculties | — | — |
| A94 | L1 | C | COND | jhāna factors → associated states and matter | — | — |
| A95 | L1 | C | COND | path factors → associated states and matter | — | — |
| A96 | L1 | C | COND | association: mental aggregates, one another | — | — |
| A97 | L1 | C | COND | dissociation: matter → mind and mind → matter | — | — |
| A98 | L1 | C | COND | presence: the co-nascent relations, organs and objects, the heart-base, while present | — | — |
| A99 | L1 | C | COND | absence: the just-ceased citta and cetasikas → the present ones | — | — |
| A100 | L1 | C | COND | disappearance: the same | — | — |
| A101 | L1 | C | COND | non-disappearance: the relata of presence | — | — |
| A103 | L1 · L2 · L3 | T | STATUS | a dhamma exists at a time only if arisen and not yet ceased (presence is defined so) | — | — |
| A104 | L4 | T | STATUS | concepts are a sort apart, objects of citta and never real; direction and time are designated on the moon's turning | — | ties conventional days to COSMO |
| A126 | L2 | T | STATUS | relative and continuity designations are concepts (only *tajjā* designates the real) | — | a REPORTED classification (the teachers'); by the type either way |
| A113 | L3 · L5 | T | MAT | a kalāpa has one place for its whole life; "going" is later kalāpas at other places | — | every motion in COSMO is read this way (a declared choice) |
| A7 | L2 | T | STATUS | time is a function on moments, never a moment | — | — |
| A8 | L4 · L5 | T | STATUS | nibbāna and concepts are time-free: objects, never moments | — | — |
| A105 | L4 | C | TAX | 40 subjects in 7 groups (10 · 10 · 10 · 4 · 1 · 1 · 4); which reach absorption, and which jhāna | — | ⏳ COVERAGE: "which reach absorption, and which jhāna" names a table its cited lines give (§19–25; from the cited lines, correction 2 §2) · the temperaments, stages and signs are names (by the type) |
| A106 | L4 | C | PROC | the four immaterial attainments' objects (two concepts, two cittas) | — | — |
| A107 | L4 | C | TAX | the five super-knowledges arise from the fifth jhāna | a super-knowledge | — |
| A108 | L4 | N | — | stages of a meditator's knowledge and modes of comprehension; the model holds no knowledge-content beyond citta-types | — | — |
| A127 | L2 | N | — | what APPEARS to a meditator and what conceals it | — | — |
| A109 | L4 | C | PROC | the path process: preparation, access, conformity; change-of-lineage on nibbāna; path one moment; 2–3 fruition; bhavaṅga; reviewing | a path process | "then reviewing" is the order of processes: the MIND link (finding 7) |
| A110 | L4 | C | MIND | four noble persons by what each path abandons; a stream-enterer has at most seven more births | each noble person | — |
| A111 | L1 (MN 43) · L2 · L4 | C | MIND+MAT | cessation for non-returners and arahants: after neither-perception javanas the stream is cut off for a pre-fixed time (≤ the remaining life); no death within; emergence by one fruition citta; life and heat persist | a cessation with emergence | — |
| A112 | L1 · L2 · L3 | C | MIND+COND | proximity holds across cessation (neither-perception → fruition) | — | VARIANT: the teachers' temporal reading of contiguity (Revata) |
| A2 | L1 | N | — | epistemic: no first point is DISCERNED; its ontic gloss is A77's *anādikaṃ*, encoded there | — | — |
| A2b | L1 | N | — | epistemic: past world-cycles are not easy to count | — | — |
| A10 | L1 · L2 | C | COSMO | four phases of the kappa; destruction is local and spares realms by kind (fire below Ābhassara, water below Subhakiṇha, wind below Vehapphala); the lengths "not easy to count" are N | — | — |
| A14 | L1 | C | COSMO | Sineru 84,000 yojanas long and wide, sunk 84,000, risen 84,000; the ocean 84,000 deep | — | — |
| A16 | L2 · L3 | C | COSMO | sun and moon ~42,000 yojanas up, moon below, sun above, 100 yojanas edge to edge (first kappa) | — | — |
| A17 | L2 | C | COSMO | moon 49 yojanas, sun 50 | — | — |
| A18 | L1 · L2 | C | COSMO | Rāhu seizes the sun and moon; the seizure is an occultation | an eclipse | — |
| A19 | L3 | C | COSMO | the discs are solids 49 and 50 yojanas in each dimension | — | — |
| A20 | L2 | C | COSMO | phases: the sun gains 100,000 yojanas a day; the moon a line, full at the uposatha; at new moon the sun directly above the moon, covering it | a full moon; a new moon | ⚠️ P3: Sineru's shadow (A14 + A16 + A21) |
| A21 | L3 | C | COSMO | the moon waxes by sunlight from above; at full moon it lags by half the path | — | ⚠️ P3 |
| A22 | L2 | C | COSMO | the sun lights three continents at one moment; one circuit of Sineru a day | — | how the fourth is dark is not stated: occlusion or range is a FREEDOM unless a row closes it |
| A23 | L2 | C | COSMO | one cakkavāḷa is 1,203,450 yojanas long and wide | — | the number of cakkavāḷas is free (undeclared, declared) |

## Counts (this draft)

| Class | Rows |
|---|---|
| C — CONSTRAINT | 107 |
| T — BY THE TYPE | 13: A26 · A30 · A52 · A55 · A61 · A6 · A123 · A103 · A104 · A126 · A113 · A7 · A8 |
| N — NOT FORMALIZABLE | 7: A128 · A25 · A75 · A108 · A127 · A2 · A2b |

Two C rows carry a clause of another class: A70's "nibbāna is an object, never a moment" is by the type, and A10's "not
easy to count" is not formalizable. *(Counted by script from the table above, 127 rows, none missing and none
repeated. The first hand count said 103 · 16 · 8 and was wrong, so a count is never typed here by hand again.)*

## What the census already shows

1. **Rival readings are more than Protocol 1 §6 listed.** §6 named A4, A9 and A129. The rows also record live rivals at
   A5, A32, A41, A44, A45, A54, A63, A112, A114, A118 (with A120), A124 and A125. Correction 1 handles them before anything
   is frozen.
2. **One scope collision is visible before any Lean:** A67's four-origin continuity "for the life-span" has no
   exception for cessation or for the non-percipient (prediction P4).
3. **The day/night geometry is not closed by any row.** A22 lights three continents and leaves the fourth dark without
   saying why. So whether Sineru's shadow reaches the full moon (P3) turns on a freedom, unless the encoding finds a row
   that commits the texts to straight shadows.

## Encoded so far (2026-10-18)

| Part | File | Rows | Definitions | Forbidden worlds |
|---|---|---|---|---|
| MIND (first six) | `Mind.lean` | A1 · A3 · A40 · A77 · A117 · C | 6 | 6 |
| TAX | `Tax.lean` | A27 · A28 · A29 · A31 · A32 · A33 · A34 · A35 · A38 · A60 · A62 · A65 · A71 · A72 · A73 · A74 · A105 · A107 | 45, of which 8 from the rows' cited lines (`a35_which` · `a38_six_exalted` · `a38_twenty` · `a38_five_but_agga` · `a62_base` · `a62_door` · `a62_faculty` · `a105_absorption`; Protocol 1 correction 2 §2) | 45 |
| PROC | `Proc.lean` | A35 (PROC half) · A36 · A37 · A38 (PROC half) · A41 · A42 · A43 · A44 · A45 · A57 · A106 · A109 · A115 | 44 | 44 |
| MAT (batches 1–2, 2026-10-20) | `Mat.lean` | A39 (sphere clauses) · A4 · A15 · A63 · A6 · A66 · A5 · A13 · A129 (A61 by the type) | 17 | 17 |
| MAT link (2026-10-20) | `Link.lean` | A120 (two clauses) · A118 (common core) · A64 (kamma from rebirth; mind-born by producers) · A67 (mind-born not at rebirth) · A4 in stream terms · K (the death citta counted in: founder 2026-10-20) | 8 | 8 |

`run.sh` passed on 2026-10-18 with 95 forbidden worlds and no problems, after its own control. A row with several
clauses has one definition per clause. TAX rows the census listed under TAX+PROC or TAX+MAT (A35, A38, A65) have their
taxonomy clauses here; the PROC and MAT halves are encoded with those parts.

**Findings for the founder, from the TAX encoding:**

1. **A38 misreads its line.** The row says "5 take any object". The Saṅgaha says six (§59, `abh07t.nrf.xml:1077`:
   the four knowledge-associated sense-sphere functionals, the functional super-knowledge and determining; the verse,
   `:1105`, *pañca sabbattha chacceti*). Five take every object except the arahant's path and fruit (§58). The encoding
   follows the text. ✅ Ruled 2026-10-18: Protocol 1 correction 2 §1 reads the clause as the text, and `kala/AXIOMS.md`
   carries a dated note on the row.
2. **Four rows name a list whose members only their cited lines give** (A35, A38's other three groups, A62's base,
   door and faculty, A105's absorption table). Protocol 1 §7.1 encodes a row's own words. Eight definitions
   encode the cited lines; ✅ ruled 2026-10-18: correction 2 §2 lets a row's own cited lines supply
   them, so the eight definitions are part of the encoding.
3. **Some count rows are weak by their own words** (A27: any 72 distinct entities). This is reported, not repaired:
   the OURS breakdown never becomes an axiom.

**Findings for the founder, from the PROC encoding (2026-10-18):**

4. **A42's row says more than its line.** It calls the very great grade "the full process, WITH registration"; the
   Saṅgaha says the two registrations come "as fitting" (*yathārahaṃ*, ch. 4 §10, `abh07t.nrf.xml:1237`), and A45 bars
   registration outside the sense sphere. Encoded as the ROW says (`a42_very_great`), so with A45 a world has no very
   great five-door object for a being of the fine-material sphere. If the attempt meets it, it is a scope collision of
   the row's words, not of the text; whether to read the row as the line (as correction 2 §1 did for A38) is the
   founder's.
   ✅ **RULED 2026-10-20 (Protocol 1 correction 3 §1, founder *"Reconcile A42"*):** read as the line; `a42_very_great` now requires the javana, and the scope collision cannot occur.
5. **A37's cited line says more than the row.** Every eye-door citta takes visible form only (§51, `:1045`); the row's
   words do not say so, and it is not a list's members, so correction 2 §2 does not bring it in. Not encoded.
6. **Three clauses permit and forbid nothing**: A37's mind-door times, A44's "in attainments javanas run many times",
   A57's "the rebirth citta can take a present object". No forbidden world exists for a permission; they go to the
   occurrence list (Protocol 1 §4), with A115's added existential reading.
7. **What PROC leaves to the MIND link**: how a process's steps sit in a stream's moments, the order of processes
   (A109's "then reviewing", the bhavaṅga after a process), and that A115's manifesting consciousness is a step of a
   process.
