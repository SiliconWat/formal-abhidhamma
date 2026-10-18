# fo/ — the first-order layer

The stream axioms of *The Calculus of Moments* written as **first-order sentences** in
[Mathlib](https://github.com/leanprover-community/mathlib4)'s model theory, pinned to Mathlib **v4.34.1**, the
toolchain the rest of this repository uses. Approved by Thon Ly on 2026-10-16. It answers amendment 2's Q2′
(`thonly/the-calculus-of-moments`, `protocol/2026-10-16-attempt-1-amendment-2.md`).

**Why a separate package.** The core encoding (`model/`, `kala/`) is plain Lean with no dependencies. Mathlib is large
(about 7.6 GB with its prebuilt files), so it lives here, apart, and the core never imports it.

**Why first-order.** Lean can say "finitely many"; first-order logic cannot. Łoś's theorem
(`FirstOrder.Language.Ultraproduct.sentence_realize`) carries every first-order sentence true in a structure to its
ultrapower, and an ultrapower of an infinite stream has moments infinitely far apart. So if every stream row is an
`L.Sentence`, a non-standard stream follows mechanically, and whether any row says "finitely many" is decided by its
type rather than by a reader's audit.

## What is here

`FO/Stream.lean`:

- **The language** `L`: two binary relations, `before` (one moment arises before another) and `prox` (one moment
  conditions the next by proximity).
- **The rows as sentences**, defined only: the arising order (irreflexive, transitive, total), A3, C and A77. ⛔ No
  model of them is built. Protocol 1 forbids any model search before Protocol 2 freezes the encoding. That each
  sentence says what its core definition in `model/Mind.lean` says is owed to Protocol 2, as one meaning lemma per row.
- **The instrument and its controls**, on the natural numbers, a structure the texts forbid (it has a first moment):
  - `star_has_infinitely_many_before` (+): the ultrapower over the hyperfilter has a moment with infinitely many
    moments before it.
  - `nat_finitely_many_before` (−): in the natural numbers every moment has finitely many before it.
  - `star_iff_nat`: the two satisfy the same sentences (Łoś).
  - `finitely_many_before_is_not_first_order`: so no sentence of `L` says "every moment has finitely many moments
    before it".

`FO/Chain.lean` (roadmap A424, owed item 1; 2026-10-18): what a finite chain of steps spans on a hyperreal clock.
Conditional theorems about any list of durations, never a model of the rows:

- `finite_chain_spans_infinitesimal` · `finite_chain_standard_part_zero`: if every step of a FINITE chain lasts an
  infinitesimal time, so does the chain, and its standard part is 0. The moments within a finite chain (a *galaxy*, in
  the order) fall inside one *halo* of time (on the clock); in one space the inclusion runs the other way, so the two
  words always name their spaces.
- `ordinary_duration_needs_a_long_step`: so a finite chain spanning more than an infinitesimal has a step that is not.
- `infinitely_many_steps_make_a_unit`: ε · ω = 1, a product (the hyperfinite sum of ω steps follows by transfer, not
  formalized here).
- `cessation_step_is_not_infinitesimal`: one ordinary step among infinitesimal ones, and the span is no longer
  infinitesimal. It models the day-reckoning; on time laid on the stream the texts give no interval across cessation
  (`abh03t.tik.xml:4309`).

Whether a citta's duration IS infinitesimal is a clock reading the texts allow and never force, never a row. It is not
H₂ of Thesis H (amendment 2), which counts moments: the clock reading yields H₂ on a stretch of ordinary length with no
cessation in it, and H₂ does not yield the clock reading.

## Checking it

```sh
cd fo
lake exe cache get   # Mathlib's prebuilt files
./run.sh
```

`run.sh` builds both modules, requires no `sorryAx` behind any of the nine theorems, and applies five breaks. Each must
fail, with its first error inside the theorem it targets:

- **principal:** over a principal ultrafilter the ultrapower is the natural numbers again.
- **infinite:** "finitely many" is swapped for "infinitely many".
- **one-long-step:** the first step of the chain is exempted from being infinitesimal.
- **no-ordinary-step:** the cessation step is made infinitesimal too.
- **finitely-many:** a thousand steps of length ε stand in for ω of them.

CI runs it in its own job (`lean.yml`, job `fo`), after `lake exe cache get`.

A planted break that changes only a comment was reported as a FAIL (2026-10-16), so an "ok" line means the target
depends on what was broken.
