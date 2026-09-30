# Cryptographic timestamps

This repository makes claims whose ORDER matters: a run's axioms and predictions are fixed before the
derivation that tests them. Two independent dates back that up:

1. **The push.** GitHub's repository activity records when each commit arrived (`runs/prereg.py` prints it).
2. **OpenTimestamps.** Frozen files carry a `<name>.ots` proof beside them, committing the file's SHA-256
   to the Bitcoin blockchain — checkable without trusting this repository, GitHub or the authors:
   `ots verify runs/<run>/PREREG.md.ots`.

## What is stamped, and what is not

| Stamped (frozen once written) | Not stamped (living; history is in git) |
|---|---|
| `runs/*/PREREG.md` — stamped AT registration by `prereg.py`, before the agent runs | `kala/` — `AXIOMS.md`, `Axioms.lean`, `Time.lean` change as axioms are verified; each PREREG copies the rows it used verbatim, so the stamped PREREG carries them |
| `runs/*/DERIVATION.md`, `runs/*/RUN.md`, `runs/*/*.lean` | `RESULTS.md` — revised as rungs complete |
| `PREREGISTRATION*.md` | `README.md`, this file |

`ots stamp` overwrites an existing proof, so a stamped file is never edited. A correction is a new file
(for a run: a new run). If a stamped file ever must change, rotate its proof to `<name>.rN.ots` first and
log it here.

**Proofs start PENDING** (calendar attestations) and become Bitcoin-anchored after a few hours;
`./ots-upgrade.sh` (or MA's `/ots`) bakes the Bitcoin attestation in.
