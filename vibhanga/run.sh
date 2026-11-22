#!/bin/sh
# Capture: the Vibhaṅga's question-sections as generated data (scripts/vibhanga_pp.py, 2026-11-21). CI has no CST text (legal L21): the parsing
# rules are checked on known answers (--selftest), the JSON on its invariants (--validate), and each deliberate break must FAIL.
set -u; cd "$(dirname "$0")/.."; PY="${PYTHON:-python3}"
if $PY scripts/vibhanga_pp.py --selftest >/dev/null; then echo "PASS  selftest: subjects (collective, fused, one item), modalities, two subjects in a sentence, the partition; a wrong expectation fails"
else $PY scripts/vibhanga_pp.py --selftest; echo "FAIL selftest"; exit 1; fi
$PY scripts/vibhanga_pp.py --validate || exit 1
brk() { T=$(mktemp -d); cp scripts/vibhanga_pp.py "$T/"
  $PY - "$T/vibhanga_pp.py" "$2" "$3" <<'ZZPY' || { echo "BREAK NOT APPLIED  $1"; exit 1; }
import sys
p, old, new = sys.argv[1], sys.argv[2], sys.argv[3]; s = open(p, encoding="utf-8").read()
if s.count(old) != 1: sys.exit(1)
open(p, "w", encoding="utf-8").write(s.replace(old, new))
ZZPY
  if $PY "$T/vibhanga_pp.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brk "a fused collective read as one item (Dasāyatanā)" 'if fused:' 'if False:'
brk "siyā na vattabbā read as plain unsayable" '"may-be-cannot-be-said" if m.group(1) else "cannot-be-said"' '"cannot-be-said"'
brk "a sentence with two subjects read as one (Tayo iddhipādā …, cittiddhipādo …)" 'if w0 in items or (any(n in w0 for n in NOUNS)' 'if w0 in items or (False'
brk "the partition never overshoots" 'elif N and total > N:' 'elif False:'
T=$(mktemp -d)
$PY - "$T" <<'ZZPY'
import json, sys
d = json.load(open("vibhanga/PANHAPUCCHAKA.json", encoding="utf-8"))
a = json.loads(json.dumps(d)); a["sections"] = a["sections"][1:]
json.dump(a, open(sys.argv[1] + "/sections.json", "w"), ensure_ascii=False)
b = json.loads(json.dumps(d)); x = b["sections"][0]["parts"][0]["sentences"][0]; x["preds"][0][0] = "probably"
json.dump(b, open(sys.argv[1] + "/modality.json", "w"), ensure_ascii=False)
c = json.loads(json.dumps(d)); bl = next(bl for p in c["sections"][0]["parts"] for bl in p["blocks"] if bl["ok"]); bl["sum"] += 1
json.dump(c, open(sys.argv[1] + "/verdict.json", "w"), ensure_ascii=False)
ZZPY
for f in sections modality verdict; do
  if $PY scripts/vibhanga_pp.py --validate "$T/$f.json" >/dev/null 2>&1; then echo "BLIND  validate accepted the corrupt file ($f)"; exit 1
  else echo "FAILS as required  validate refuses a corrupt file ($f)"; fi
done
rm -rf "$T"
echo "all breaks fail as required"
