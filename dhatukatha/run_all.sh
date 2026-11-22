#!/bin/sh
# Capture: every count the Dhātukathā states, all fourteen methods (scripts/dhatukatha_all.py, 2026-11-21). CI has no CST text (legal L21): the
# parsing rules are checked on known answers (--selftest), the JSON on its invariants and its CONTROL (dhatukatha.py's 175 rows), and each
# break must FAIL.
set -u; cd "$(dirname "$0")/.."; PY="${PYTHON:-python3}"
if $PY scripts/dhatukatha_all.py --selftest >/dev/null; then echo "PASS  selftest: included / not included, Na kehici, a comma, the neuter plural, partial (kehici) answers; a wrong expectation fails"
else $PY scripts/dhatukatha_all.py --selftest; echo "FAIL selftest"; exit 1; fi
$PY scripts/dhatukatha_all.py --validate || exit 1
brk() { T=$(mktemp -d); cp scripts/dhatukatha_all.py "$T/"
  $PY - "$T/dhatukatha_all.py" "$2" "$3" <<'ZZPY' || { echo "BREAK NOT APPLIED  $1"; exit 1; }
import sys
p, old, new = sys.argv[1], sys.argv[2], sys.argv[3]; s = open(p, encoding="utf-8").read()
if s.count(old) != 1: sys.exit(1)
open(p, "w", encoding="utf-8").write(s.replace(old, new))
ZZPY
  if $PY "$T/dhatukatha_all.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brk "a capital Na kehici is not read as zero" '((?:[Nn]a k' '((?:na k'
brk "a comma after the noun ends no count (Tīhi khandhehi, …)" '(?=[\s,]|$))")' '(?=\s|$))")'
brk "the neuter plural verb is not read (saṅgahitāni)" '(?:āni|o|ā|aṃ)' '(?:o|ā|aṃ)'
T=$(mktemp -d)
$PY - "$T" <<'ZZPY'
import json, sys
d = json.load(open("dhatukatha/ALL.json", encoding="utf-8"))
a = json.loads(json.dumps(d)); a["control"]["agree"] -= 1
json.dump(a, open(sys.argv[1] + "/control.json", "w"), ensure_ascii=False)
b = json.loads(json.dumps(d)); r = next(r for r in b["rows"] if "sums" in r); r["sums"] = [5, 12, 17]
json.dump(b, open(sys.argv[1] + "/sums.json", "w"), ensure_ascii=False)
c = json.loads(json.dumps(d)); c["rows"][0]["answers"][0][1][2] = 19
json.dump(c, open(sys.argv[1] + "/range.json", "w"), ensure_ascii=False)
ZZPY
for f in control sums range; do
  if $PY scripts/dhatukatha_all.py --validate "$T/$f.json" >/dev/null 2>&1; then echo "BLIND  validate accepted the corrupt file ($f)"; exit 1
  else echo "FAILS as required  validate refuses a corrupt file ($f)"; fi
done
rm -rf "$T"
echo "all breaks fail as required"
