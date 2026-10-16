# model/ — one World for every live axiom

The working encoding for *The Calculus of Moments*, attempt 1: is there one structure in which every live axiom of
`kala/AXIOMS.md` holds at once, and in which every kind it names occurs, or else what are the smallest sets that
cannot hold together? The rules are fixed in the book's public record:
[Protocol 1](https://github.com/thonly/the-calculus-of-moments/blob/main/protocol/2026-10-15-attempt-1.md) and
[correction 1](https://github.com/thonly/the-calculus-of-moments/blob/main/protocol/2026-10-15-attempt-1-correction-1.md).

**Nothing here is a result.** This directory holds definitions and their forbidden worlds, and nothing else. No model
of the axioms is built here before Protocol 2 freezes the encoding by commit.

| File | What it holds |
|---|---|
| `CENSUS.md` | every live row, with its class (constraint · by the type · not formalizable), its part of `World`, its occurrence conditions, and its rival readings |
| `Mind.lean` | the stream: mind-moments on a clock of sub-moments (A1 · A3 · A40 · A77 · A117 · C) |
| `run.sh` | compiles every file, then gives each definition its teeth test |

## The teeth test

Every definition `aNN_…` is followed by a **forbidden world**: a small structure its text rules out, on which Lean
proves the definition false. `run.sh` then weakens each definition to `True` on a copy that keeps only that one
theorem, and requires the theorem to fail. A definition with no forbidden world (`NO TEETH`), or one whose weakening
still checks (`BLIND`), fails the suite. Tested on a known failure (2026-10-15): one planted definition without a
forbidden world, and one whose theorem did not depend on it, were both reported, and the suite exited 1.

## The parts of `World`, in build order

1. **MIND**: streams, mind-moments, sub-moments, existences, deaths, rebirths, cessation, the arahant's last moment.
2. **TAX**: the kinds and their counts, reusing the generated 89/121 (`sangaha/`) and the 24 conditions (`matika/`).
3. **PROC**: cognitive processes as runs of a stream.
4. **MAT**: kalāpas, with origin, birth, life, owner and place.
5. **COND**: the 24 conditions as relations, read against `matika/RELATA`.
6. **COSMO**: Sineru, the sun and moon, the planes, days and eons.
7. **STATUS**: concepts, time and nibbāna, mostly by the type.

Then the occurrence conditions, the freedoms list, the blind back-translation of every definition, and the refuter on
the encoding in both directions. Protocol 2 freezes the result.
