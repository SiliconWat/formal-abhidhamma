#!/bin/sh
# Rung 4's INSTRUMENTS on known answers only — no real data: the canonical basis against its definition,
# the null models' shuffle and generator, and the mutation harness on a toy whose outcomes are planted.
# The real analysis runs only after its pre-registration is pushed (rung4/README.md). Needs Lean (LEAN=…).
set -u
cd "$(dirname "$0")"
LEAN="${LEAN:-$( (cd "$(git rev-parse --show-toplevel)" && { elan which lean || ~/.elan/bin/elan which lean; }) 2>/dev/null || command -v lean)}"; export LEAN   # the PINNED binary; a bare `lean` outside the repo is elan's default
fail=0
echo "— fca.py: the canonical basis";      python3 -I fca.py control     || fail=1
echo "— nulls.py: N1 and N2";              python3 -I nulls.py control   || fail=1
echo "— mutants.py: the harness on a toy"; python3 -I mutants.py control || fail=1
[ $fail -eq 0 ] && echo "PASS  rung 4 instruments, all controls" || echo "FAIL  rung 4 instruments"
exit $fail
