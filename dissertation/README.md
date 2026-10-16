# Dissertation

*A self-published, dissertation-length monograph built from this program: one question, the method that
tests it, every result, and the limits. Started 2026-10-15.*

This is not a degree claim. Doctorates are granted by universities; this is the work a doctorate would
examine, written in public. Its chapters can later be split into papers for peer review.

| File | What it holds |
|---|---|
| [`OUTLINE.md`](OUTLINE.md) | the question, the scope, the chapter plan mapped to results already in this repo, and what is still owed |
| [`SOURCES.md`](SOURCES.md) | everything the chapters draw on: this repo's files, the published papers, neighbors, method references, secondary literature |
| [`RUNG4-PREREG-DRAFT.md`](RUNG4-PREREG-DRAFT.md) | the draft pre-registration for chapter 8's measures (`rung4/`); registered only on the founder's approval |
| [`APPARATUS.md`](APPARATUS.md) | how every figure is cited: CST paragraph, second printing, Khmer volume and page |
| [`CONTRIBUTIONS.md`](CONTRIBUTIONS.md) | who did what, in CRediT roles (draft, for the founder to confirm) |
| [`READERS.md`](READERS.md) | the outside readers sought and the brief sent to them |
| [`VENUES.md`](VENUES.md) | where each chapter can go for peer review, and what each venue's own pages say |
| `reproduce.sh`, `Numbers.lean`, `numbers.json` | one command reruns every suite and regenerates every number the text quotes |

## Rules

- **Living until frozen.** Drafts here change freely; git keeps the history, and the weekly RFC 3161
  manifest covers every tracked file. A chapter is frozen when it is declared final and moved to
  `dissertation/final/`, where the weekly job stamps it (OpenTimestamps beside it); it is never edited again.
  A correction is a new file. Drafts outside `final/` are never stamped.
- **Every number from `numbers.json`.** No count is typed by hand; CI fails if `numbers.json` is stale.
- **Results come from the runs, never the reverse.** A chapter reports what `sangaha/`, `canon/`, `kala/`
  and `runs/` already show. Nothing is claimed here that the Lean and the run ledger do not back.
- **Tier labels carry over.** Canon, the *Saṅgaha*, the commentaries and our own reconstruction stay
  distinguished in every chapter, as in the rest of the repository.
- **Authorship.** Thon Ly, with the AI collaboration disclosed under the name Miss Aquarius℠, as in the
  rest of this repository. CC0-1.0, like everything here.
