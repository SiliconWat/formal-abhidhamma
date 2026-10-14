# RUN — Kathāvatthu 8.2, a known-answer control under the A389 conventions  ·  PREREG pushed 2026-10-14T00:22:20Z + OTS

- **Kind:** known-answer control (KNOWN ANSWER: Kv 8.2 §505–509, REFUTED). Ordered by the founder (*"do all four if
  possible, then my thesis"*), because the skill requires a control after any change to it, the rubric or AXIOMS.md, and
  the only earlier `/prove` control predated the A388 and A389 conventions.
- **Premises:** A3 (both clauses), A122, A123 · **held out:** Kv 8.2 §505–509 and A59 · **Lean:** `Antarabhava.lean`, `run.sh`
- **Before registration:** a vetting refuter (F1–F8, all applied or declared: T2 recast as an UNATTRIBUTED mindless
  interval; T1's view carries "no rebirth-linking inside it"; the answer kept unqualified; A3's `abh05t.nrf.xml:2409`
  clause moved to ANSWERS because that line is the sub-commentary's own refutation) and two blind back-translations.
- **After:** `run.sh` (12 registered pieces verbatim, with a planted moved definition refused; seven breaks fail, each
  with T1 compiled ALONE); `kala/THEOREMS.md` (T1 uses all four hypotheses, all constructive); `leak-check.py` ("no");
  CI green; the run refuter (a different agent from the vetting one).

## OUTCOME: REFUTED
## GRADE: NOT STRONG
## VERDICT: PASS (confounded)

The control passes: T1 comes out REFUTED with A59 unreached and no LEAK. It is confounded on two counts. First, T1 is
A122 set nearly word for word against the view: the sub-commentary frames the dispute as the identity of the death's
proximate successor (`abh03t.tik.xml:2177`), and A122 asserts the Theravādin side. Second, the view's content is the
commentaries' report, not the canonical record.

| Theorem | Outcome | Uses (read from Lean) | Logic | Refuter | Survivor |
|---|---|---|---|---|---|
| `t1_no_room_for_the_reported_view` | REFUTED | A3 (both clauses), A122, A123; Unused none | constructive (propext) | NARROWS (1, 3, 5) | The intermediate existence AS THE COMMENTARIES REPORT IT cannot exist: one with consciousness, after a death citta, with no rebirth-linking inside it. ⚠️ At the Piṭaka layer, A122 reaches only rebirths of a DIFFERENT class (some forty lines, each naming a death and rebirth of different classes). The common human-to-human case needs A56 (manual, unused) or a universal reading of A122 |
| `t2a`, `t2b` | INDEPENDENT | A3, A122, A123 | constructive | CHECKS (by construction, declared) | A MINDLESS interval, attributed to no holder, is left open by these premises. The texts themselves contain mindless intervals (the mindless beings' existence, A13; cessation, `abh03a.att.xml:7697`), but place them inside an EXISTENCE, which the World cannot express |
| `model_t1_hypotheses` | a model | A3, A122, A123 | constructive | CHECKS | T1's hypotheses are jointly satisfiable, so T1 is not vacuous |
| `needs_a3_successor` · `needs_a3_immediate` · `needs_a122` · `needs_a123` | four models | — | constructive | answers F4 | Each of T1's four hypotheses is NEEDED: a model of the other three in which the view holds |

⭐ **What the control found, in one sentence:** from the Paṭṭhāna's proximity across death, the instrument reproduces
Kv 8.2's REFUTED for the intermediate existence as the commentaries report it, without touching the held-out answer. The
unqualified answer ("no intermediate existence at all") is NOT reached. It needs premises the World cannot express:
**(a) coverage**, that every being at every moment is in one of the exhaustive kinds the debate cites (existences,
wombs, destinies, stations of consciousness, abodes of beings); and **(b) a rebirth that is not only a citta**, since the
mindless beings' rebirth is material (A13). The classification of existences alone is not enough, because the holder
denies that the intermediate existence is a *bhava* at all (§506). ⛔ Not new: the proximity route is stated in later
layers (the ANSWERS row).

## The rubric, item by item

1. **Axioms verified** — ✗ in part. A123 is re-cited to the universal Piṭaka definitions (Dhs §1193; Vibhaṅga); A122's
   universal reading is NOT Piṭaka (different-class rebirths only).
2. **Nothing load-bearing by construction** — ✗. T2a holds by construction (declared). T1 rests on the one-stream type,
   which the PREREG cited at `abh05t.nrf.xml:2405`, inside the held-out passage; it is attested outside it at
   `abh03a.att.xml:4385` and `:4389`.
3. **A model** — ✓ (`model_t1_hypotheses`; not pre-registered).
4. **Breaks** — ✓ after a repair. The first harness broke each definition on the WHOLE file, where a definition set to
   `True` also broke T2a, T2b and the model. So every break "failed" whether or not T1 needed it. Planted test: an
   unused hypothesis added to T1 and broken — the old harness said FAILS, the new one says BLIND. Each break now runs
   on T1 alone, and necessity is proven in Lean (the four `needs_` models).
5. **Axioms read from Lean** — ✓ per conjunct; Unused none.
6. **Logic** — ✓ constructive.
7. **No held-out answer as a premise** — ✓. The leak check reports "no", and that holds at any depth, since T2a is a
   model of all four premises in which `intermediate` holds. ⚠️ Open question (below): A122 asserts exactly the debated point.
8. **No unrepaired encoding defect** — ✗. The view's content is commentarial and T1's Piṭaka scope is narrowed (refuter 1, 3).
9. **Layer** — **commentarial**: the view's content is the commentaries' report, and A3's immediacy clause is cited to
   the Paṭṭhāna commentary (`abh03a.att.xml:7697`).

## Predictions, scored by the main session

1. **T1 REFUTED, constructive, Unused none — ✅ HIT.**
2. **T2a and T2b compile, INDEPENDENT by construction; T2b trivial — ✅ HIT.**
3. **leak-check "no" — ✅ HIT** (and, per the refuter, at any depth).
4. **A59 unreached; no held-out row reached; overlap guard clean — ✅ HIT.** Aperture: the guard compares AXIOMS rows
   with ANSWERS rows. The view's docstrings cite lines inside the answer's own passage, which is right, since a view
   must cite where it is reported.
5. **NOT STRONG — ✅ HIT.**
- **Calibration:** the session predicted REFUTED — HIT. No founder prediction (a control).

## What the instruments caught in this run

- **The vetting refuter** caught three things: T2 misattributed to the canonical text's concession (the commentary
  says the opponent's "no" was about grossness); T1's hidden "no rebirth inside it"; and a premise row (A3) citing a
  line of the held-out answer's own passage, now moved to ANSWERS and enforced by the overlap guard (a planted A3 citing
  that line is flagged).
- **The run refuter** caught a defect in the break harness that every earlier run shares: breaks on the whole file
  cannot isolate a theorem. It is fixed here and the fix is in the `/prove` skill. ⚠️ In earlier runs, "breaks fail"
  is not isolated evidence; their per-theorem evidence is the Unused column of `kala/THEOREMS.md`.

## OPEN QUESTION for the founder → roadmap A392 (no wording proposed by the refuter; the recommendation is the session's)

- **OQ-1** The sort rule puts A122 in AXIOMS (the Paṭṭhāna asserts it; nothing derives it). The sub-commentary,
  though, frames Kv 8.2's dispute as exactly what A122 asserts: the identity of the death's proximate successor. Does
  the sort rule still admit such a row as the decisive premise of that debate's control? *(recommend: yes, the row
  stays an axiom; but a control whose decisive premise IS the debated point is a plumbing check by construction, and
  its PASS is always confounded. The rubric should say so.)*
