#!/bin/sh
# Control: C1 must CHECK, C2 (rule R2 deleted) must FAIL. Exit 0 only if both hold.
cd "$(dirname "$0")"
LEAN="${LEAN:-lean}"
$LEAN -o Cetasika.olean Cetasika.lean || { echo "Cetasika.lean failed"; exit 1; }
if LEAN_PATH=. $LEAN Rules.lean; then echo "C1 ✓ the eight wholesome cittas: 8 types, 38·38·37·37·37·37·36·36"; else echo "C1 ✗"; exit 1; fi
if LEAN_PATH=. $LEAN Broken.lean >/dev/null 2>&1; then echo "C2 ✗ the break CHECKED — the instrument is blind"; exit 1; else echo "C2 ✓ deleting 'pīti only with joy' breaks the count, as required"; fi
