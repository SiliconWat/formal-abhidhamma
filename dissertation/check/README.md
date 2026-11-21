# The chapters' number check

`check.py` walks every number in the finished chapter prose, in order, and compares each with the next binding's value, so a figure changed to any other value fails, even one that occurs elsewhere in the chapter. A number added or removed fails too. Exit 1 on any mismatch.

```sh
python3 dissertation/check/check.py
```

- `bindings/`: the ordered figure-to-key list per chapter.
- `figures.json`: every figure `numbers.json` does not hold, with its provenance. `figures.py` regenerates it from the repo's Lean (`lean_figures.json`, from `Figures.lean`), the repo's scripts, the decoded CST (`CST_ROMAN`, the CST roman XML folder) and asserted substrings of repo records.

**What it does not check:** whether a binding names the right key (that was reviewed by eye); spelled numbers in the listed prose phrases; the word "one"; citations and code spans, which are masked and tallied (`--show-exempt`).

It isn't wired into `reproduce.sh` while the chapters are drafts.
