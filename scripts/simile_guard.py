#!/usr/bin/env python3
"""simile_guard.py — the Silicon Simile is a READING AID, never an INPUT (founder ruling 2026-10-14: "yes").

The simile (a computer read through the Visuddhimagga's own wooden machine, Vism XVIII §675) renders a run's result for a
reader AFTER the result is fixed. It never enters what a blind reader sees, or the record that fixes the result: the
pre-registration, the deriving agent's question, the Lean statement, the blind back-translation. A lens fed into a blind
step would bias every derivation toward what fits a computer. The test is deletion: every result stands with the simile
line deleted.

This file is the ONE home of the vocabulary. `runs/prereg.py` imports it; /prove step 4 runs it on the comment-stripped
copy before the blind back-translation; `scripts/selftest.py` plants it.

  scripts/simile_guard.py FILE...   exit 1 and name the term if any FILE carries the simile's vocabulary

Distinctive terms only: words a question about the texts would not use for its own reasons. `commit` is deliberately
absent (the program asks what the axioms COMMIT you to), and so are `binary`, `hardware` and `software`.
"""
import re, sys

SIMILE = re.compile(
    r"silicon simile|pseudo[- ]?code|decompil\w*|\bcompilers?\b|\bupstream\b|\bfirmware\b|\bVLIW\b|\blinker\b"
    r"|\brepos?\b|\bgit\b|address space|deploy key",
    re.I)

def find(text):
    """the first simile term in text, or None. Lean names are split first (snake_case and camelCase), because an
    underscore is a word character and `upstream_moment` hid its term from \\b — the guard's first self-test run found it."""
    words = re.sub(r"(?<=[a-z0-9])(?=[A-Z])", " ", text or "").replace("_", " ")
    m = SIMILE.search(words)
    return m.group(0) if m else None

if __name__ == "__main__":
    if len(sys.argv) < 2: sys.exit(__doc__)
    hits = [(f, t) for f in sys.argv[1:] for t in [find(open(f, encoding="utf-8").read())] if t]
    for f, t in hits:
        print(f"REFUSED {f}: carries the Silicon Simile's vocabulary ('{t}') — the simile is a reading aid, never an input")
    sys.exit(1 if hits else 0)
