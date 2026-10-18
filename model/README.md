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
| `Tax.lean` | the taxonomy: the kinds a world has and their counts — citta, cetasika, function, object, matter, origin, chapter 7's categories, the subjects of calm (A27–A29 · A31–A35 · A38 · A60 · A62 · A65 · A71–A74 · A105 · A107), importing the generator (`sangaha/`, `control/Cetasika.lean`) |
| `Proc.lean` | cognitive processes: the five-door process by grade, the mind-door process, absorption, the path process, death, the immaterial attainments' objects, the sense meeting (A35's and A38's PROC halves · A36 · A37 · A41–A45 · A57 · A106 · A109 · A115), importing `Tax.lean` |
| `run.sh` | compiles every file, then gives each definition its teeth test; `--control` plants the failures the test must catch |

## The teeth test

Every definition `aNN_…` is followed by a **forbidden world**: a small structure its text rules out, on which Lean
proves the definition false. `run.sh` then replaces each definition, every line of it, with `True` on a copy that keeps
only that one theorem, and requires the theorem to fail with its **first error inside that theorem**. A definition with
no forbidden world (`NO TEETH`), one whose weakening still checks (`BLIND`), or one whose weakening breaks the file
somewhere else (`FAILS ELSEWHERE`) fails the suite. A row with several clauses has one definition per clause, each with
its own forbidden world, so a toothless clause cannot hide behind a sharp one.

Tested on known failures: on 2026-10-15, one planted definition without a forbidden world and one whose theorem did not
depend on it were both reported. On 2026-10-18 the harness was rebuilt: the old one weakened only a definition's first
line, so a multi-line definition broke the file's syntax and was counted as a pass. `./run.sh --control` now plants all
three failures and a two-line definition that must pass, and CI runs it. Its first run caught a bug in the new harness
itself (an `example` line was read as part of the definition above it), fixed before anything relied on it.

**Definitions from a row's cited lines.** Some rows name a list whose members only their own cited lines give (A35's
functions, A38's other three object groups, A62's base, door and faculty, A105's absorption table). Protocol 1 §7.1
encodes a row's own words; correction 2 §2 (founder 2026-10-18) lets a row's OWN cited lines supply the members of a
list it names, never lines it does not cite. The eight such definitions are part of the encoding and say so in their
docstrings.

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
