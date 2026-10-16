# Rung 4 — is the table special, and how blind is the key?

*Instruments built and tested 2026-10-15. Nothing has been run on the real table. The analysis runs only
after its pre-registration is pushed (the draft is `dissertation/RUNG4-PREREG-DRAFT.md`).*

The counts check (`sangaha/`, the paper *The Counts Check*) left three things open in its own words: the
compression ratio is "a crude description-length proxy" and the principled measures, implication bases
and description length, are "not computed here"; "distinct 121 × 52 matrices can share every projection
checked"; and an examiner will say an axis-built taxonomy compresses anyway. Rung 4 measures all three.

| Measure | Instrument | Question |
|---|---|---|
| M1, the canonical basis | `fca.py` on the table from `Table.lean` | How many attribute implications does the table itself contain (the Duquenne–Guigues basis, provably minimal), against the text's 18 rules? |
| M2, null N1 | `nulls.py`: margin-preserving shuffles (curveball) | Is there structure beyond the row and column totals? (Expected; the floor, not the finding.) |
| M3, null N2 | `nulls.py`: random rule systems of the text's shape over the real axes (`Axes.lean`) | Would ANY rule system on these axes give a table this compressible? (The examiner's question.) |
| M4, the key's blindness | `mutants.py`: all 156 single-point mutants of `arises`, then every cross-clause pair | Do two rule-shaped errors ever cancel in every keyed figure? |

A note fixed in advance: the key holds every row total (over 121 and 89) and every column total (each over
the text's own reckoning). So any single mutant that changes the table changes some row total and is
caught. The single-mutant score is 100% by construction (a lemma, reported, never offered as evidence).
The informative test is the pairs.

## Controls (run on every push by `.github/workflows/lean.yml`; `rung4/run.sh`)

- `fca.py control`: a planted implication system recovered exactly; the empty basis of a power set; Ganter's
  algorithm equal to the definition by exhaustion on 600 random small tables.
- `nulls.py control`: the shuffle keeps every total, moves cells, never changes a uniquely realizable
  table, and reaches the 2 × 2 identity's alternative; the rank and compression statistics on known
  tables; the generator keeps the text's column groups and is reproducible from its seed.
- `mutants.py control`: a toy classification (`control/`) whose outcomes are planted: every non-equivalent
  single mutant killed, a tautology's equivalent mutant found, a planted column swap surviving as a pair,
  and the Python projections agreeing with Lean on every mutant.

## Running the real analysis (after the pre-registration is pushed)

```sh
cd sangaha && LEAN_PATH="../control:." lean ../rung4/Table.lean > ../rung4/results/table.txt
LEAN_PATH="../control:." lean ../rung4/Axes.lean > ../rung4/results/axes.txt && cd ..
sed -n '1,121p' rung4/results/table.txt > rung4/results/table121.txt
python3 rung4/fca.py basis rung4/results/table121.txt > rung4/results/basis121.json
python3 rung4/nulls.py run --table rung4/results/table121.txt --axes rung4/results/axes.txt --out rung4/results/nulls.json
python3 rung4/mutants.py run --out rung4/results/mutants.json
```

Results land in `rung4/results/`, are stamped (OpenTimestamps and the RFC 3161 manifest), and are never
edited. The mutant set is fixed by its SHA-256 (`mutants.py list` prints it), cited in the pre-registration.
