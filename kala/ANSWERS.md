# ANSWERS — what the texts themselves DERIVE: the test bank, never a premise

*Ruled 2026-10-13 (founder: "approve the answers list"). The one home of the texts' own answers, as `AXIOMS.md` is the
one home of what they assert. Three files, three roles:* **[`AXIOMS.md`](AXIOMS.md) — what the texts ASSERT** ·
**[`THEOREMS.md`](THEOREMS.md) — what we DERIVE** · **this file — what the texts DERIVE**, the known answers a derivation
is checked against.

## Why it is separate

If a conclusion the texts reach by argument is entered as an axiom, a proof run finds it by lookup and tests nothing.
Kept out, each answer is a ready-made control: when the axioms cannot reproduce it, the gap names the premise the
system never states. The precedent is already in this repo — `sangaha/AnswerKey.lean`, the Saṅgaha's own figures
*"entered SEPARATELY from the rules so the rules cannot restate it."*

## The sort rule

- A statement a text **ASSERTS without deriving** anywhere → `AXIOMS.md`.
- A statement the texts reach only by **derivation, computation or refutation** → here.
- **Layers decide the overlap.** An answer may be asserted at a later layer (the commentaries' 17 moments assert what the
  Kathāvatthu argues for); the answer row then tests only the EARLIER layers, and says so.
- What the Kathāvatthu's two sides BOTH accept may be an axiom; the CONCLUSION of a debate stays here.
- ⭐ **Sort by CONTENT, never by BOOK** (A388 OQ1, founder 2026-10-13: "approve all"). The Yamaka's and the Dhātukathā's
  COMPUTED inclusion answers — what follows from the Dhammasaṅgaṇī and Vibhaṅga — are answers; what a book simply ASSERTS
  is an axiom, whichever book it is in (the Saccayamaka's "no arising at a citta's dissolution-moment" is A118).
- The Puggalapaññatti's persons are concepts (*paññatti*): they enter as definitions, never as laws.
- ⛔ IDs are never renumbered. An `AXIOMS.md` row found to be an answer stays where it is, marked **HELD OUT → ANSWERS**,
  and `runs/prereg.py --proof` refuses it as a premise.

## Keys and columns

Keys are the texts' own references (Kv 22.10 §906, a Paṭṭhāna section, a Yamaka chapter) — no invented ID series.
**Result** is filled by proof runs only: **REPRODUCED** (the axioms derive it) · **NEEDS A PREMISE** (named) ·
**CONTRADICTED** (the axioms derive its negation) · **NOT FORMALIZED** · *not run*.

| Key | The texts' answer | Citation (layer) | Status | Tests | Result | Run |
|---|---|---|---|---|---|---|
| Kv 22.10 §906 | **REFUTED: "all dhammas last one mind-moment"** (*ekacittakkhaṇikā sabbe dhammā*, the Pubbaseliyas' and Aparaseliyas' view). Two arguments: the great earth, ocean and Sineru do not stand within one citta; and the eye-base is not co-nascent with eye-consciousness, by Sāriputta's word (MN 28, M i 190) that the eye is intact before consciousness manifests. §907 records the opponent's counter (not momentary, therefore permanent): the Theravādin rejects only "all permanent", the mūla ends on the opponent's line, and the verdict that the counter fails is the COMMENTARY's (KV-a: *taṃ avuttasadisamevāti*) | `abh03m3.mul.xml:13641–13653` (Piṭaka); opponents KV-a `abh03a.att.xml:6353` (commentarial) | VERIFIED | the Piṭaka layer. ⚠️ ASSERTED at later layers, on any reading of 'one mind-moment': the commentarial 17 (A4); the commentarial SUPPORTING-BASE rule — a citta depends on a base that arose with the PREVIOUS citta and has reached standing (Vism XX §700 `e0102n.mul.xml:6029`; for the eye, the Abhidhammāvatāra-ṭīkā `abh08t.nrf.xml:7397`); and the Mūlaṭīkā (`abh02t.tik.xml:317`, matter does not serve as pre-nascent until its co-arisen citta's moment has passed) | **REPRODUCED on the ALIGNED reading** (a plumbing check, declared confounded; A87 + A98 already state A69 for bases — the run's F3); on the DURATION reading, open on the commentarial line, refuted on the Mūlaṭīkā's. ⚠️ **STATED — tests nothing at the Piṭaka layer on the ALIGNED reading** (A388 OQ2): Vibhaṅga §762 asserts §906's lemma outright (*purejātasmiṃ vatthusmiṃ … uppajjanti*; the commentary's *sahuppattipaṭikkhepo*). The DURATION reading is still a test | [`2026-10-13-kv-22-10-khanika-control`](../runs/2026-10-13-kv-22-10-khanika-control/) |
| Kv 8.2 §505–507 | **REFUTED: "there is an intermediate existence"** (*atthi antarābhavo*, the Pubbaseliyas' and Sammitiyas' view). The Theravādin's reductio: it is none of the three existences and none lies between them; it is no fifth womb, sixth destiny, eighth station of consciousness or tenth abode of beings; no beings are born or die there; it has no five aggregates | `abh03m3.mul.xml:8149–8161` (Piṭaka); opponents KV-a `abh03a.att.xml:4385` (commentarial) | VERIFIED | the Piṭaka layer: A122 (the Paṭṭhāna's death→rebirth proximity) is an available premise; the exhaustive lists the debate cites (wombs, destinies, stations, abodes) are not yet rows. At the manual layer A56 states it (*tassānantarameva*) | *not run* | — |
| Kv 1.6 §283 | **REFUTED: "the past exists, the future exists"** (part of *sabbamatthi*, "everything exists", the Sabbatthivādins' view): the past is ceased, gone, changed, set; the future unborn, unarisen — so neither may be said to exist | `abh03m3.mul.xml:2809–2813`, the debate `:2793–3241` (Piṭaka); KV-a `abh03a.att.xml:3065` (commentarial) | VERIFIED | ⚠️ **STATED — tests nothing at the Piṭaka layer**: the Dhammasaṅgaṇī's own definitions (A103, §1044–1045) are the debate's premise, word for word | *not run* | — |
| Mūlaṭīkā matter rule | **Matter arises only at a citta's ARISING sub-moment** — DERIVED by Ānanda (*vicāretabbo*) from the Cittayamaka's silence on a standing moment (§81 names only *bhaṅgakkhaṇe* and *uppādakkhaṇe*) and the Saccayamaka read literally (no dukkhasacca whatsoever at a dissolution): *Na, cittanirodhakkhaṇe rūpuppādārambhābhāvato*. The same paragraph adds that matter does not serve as pre-nascent until its co-arisen citta's moment has passed | Vibhaṅga-mūlaṭīkā `abh02t.tik.xml:313`, `:317` (sub-commentarial); Cittayamaka §81 `abh03m5.mul.xml:14521` (Piṭaka, the premise) | VERIFIED | the Piṭaka layer and the commentarial (the Vibhaṅga-anuṭīkā and Ledi reject it: kamma-born matter arises at all three sub-moments) | **REPRODUCED IN CONSEQUENCE** (A389 OQ-b): from A118 read literally + two sub-moments + A3's predecessor, the duration view falls — the second run's T2 at k = 2, which is the consequence Ānanda draws; the rule itself is not derived | [`2026-10-13-kv-22-10-duration-reading`](../runs/2026-10-13-kv-22-10-duration-reading/) |
| Dhs-a mātikā | **The matrix counts 22 triads, 100 Abhidhamma dyads and 42 Suttanta dyads** (*dvāvīsati tikā … sataṃ dukā … dvācattālīsa suttantikadukā*): a count the commentary computes from the Dhammasaṅgaṇī's list | Atthasālinī `abh01a.att.xml:305` (commentarial) | VERIFIED | the generated matrix (`matika/`, from the mūla list itself) | **REPRODUCED** — `twentytwo_triads`, `hundred_dyads`, `fortytwo_suttanta_dyads` | [`matika/`](../matika/) |
| Paṭṭh-a 24 | **Six methods in four directions make the 24 *samantapaṭṭhāna*** (*samantā cha cha hutvā catuvīsati honti*); the six are the Paṭṭhāna's own (*cha anulomamhi nayā*, `abh03m7.mul.xml:449`) | Paṭṭhāna-aṭṭhakathā `abh03a.att.xml:7665` (commentarial) | VERIFIED | the method generator | **REPRODUCED** — `twentyfour_samantapatthana` | [`matika/`](../matika/) |

## Owed — the reclassification audit (founder-approved 2026-10-13)

✅ **DONE 2026-10-13, all three.** A69 → HELD OUT (Kv 22.10 §906). A59 → HELD OUT (Kv 8.2; its premise, the Paṭṭhāna's death→rebirth proximity, added as A122). A103 → STAYS an axiom (asserted in the Dhammasaṅgaṇī; its Kathāvatthu lines moved to Kv 1.6, which tests nothing at the Piṭaka layer). Three `AXIOMS.md` rows record Kathāvatthu REFUTATIONS: **A59** (no intermediate existence, Kv 8.2), **A69** (matter
outlasts a mind-moment, Kv 22.10) and **A103** (past ceased, future unarisen; it also rests on the Dhammasaṅgaṇī's
definitions). Each gets the asserted-elsewhere test and, where the answer is the debate's conclusion, the HELD OUT mark.
A1 is a premise both sides of Kv 2.5 hold and stays an axiom.
