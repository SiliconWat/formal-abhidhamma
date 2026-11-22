# Correction to RUN.md (2026-11-22, the same day)

Two statements in RUN.md overstate the result. RUN.md is left as written; this file corrects it. The VERDICT stands — **P1 and the control carry it** — on narrower ground.

1. **"Breaks (each fails)" — the breaks were VACUOUS when RUN.md was written.** The break harness in `sangaha/run.sh` exported a RELATIVE `../control` and then
   compiled inside a temp directory, where that path pointed nowhere: the UNBROKEN copy could not compile (`unknown module prefix 'Cetasika'`), so every break
   "failed as required" for a reason unrelated to the break. CI's green did not validate them (it exports the same relative path). Found by the advisor's control:
   compile the unbroken copy through the break chain — it failed. **FIXED:** an absolute control path, the repo's `lean-toolchain` copied into the temp directory
   (the elan proxy picks the toolchain by directory — the same local fault had made the older R4 break read BLIND here while CI passed it), and a HARNESS CONTROL
   that must pass before any break counts. Re-run: the harness control PASSES, and all three breaks genuinely FAIL. The same control was added to the
   Dhātukathā runs' harnesses (runs 2 and 3); there the unbroken copies check and the breaks were real all along.

2. **P2 ("the Saṅgaha exceeds a list only where the list is open") was NON-DISCRIMINATING.** All 23 fully written lists carry the open clause *ye vā pana …
   aññepi atthi*, so P2 could not have failed. It is true, and it says nothing beyond P1. The result is **P1** (every factor the Dhammasaṅgaṇī lists, the
   Saṅgaha's rules give, in all 23 classes) **and the control** (the first class's 29 + 9 = 38).
