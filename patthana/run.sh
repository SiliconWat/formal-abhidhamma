#!/bin/sh
# Capture: the Paṭṭhāna's stated counts as generated data (scripts/patthana.py, 2026-11-19). CI has no CST text (legal L21), so the
# parser's rules are checked on known answers (--selftest), the generated JSON on its own invariants (--validate), and each deliberate
# break below must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")/.."; PY="${PYTHON:-python3}"
if $PY scripts/patthana.py --selftest >/dev/null; then echo "PASS  selftest: every parsing rule on its known answer, and a wrong expectation fails"
else $PY scripts/patthana.py --selftest; echo "FAIL selftest"; exit 1; fi
$PY scripts/patthana.py --validate || exit 1
brk() { T=$(mktemp -d); cp scripts/patthana.py "$T/"; sed -i.orig "$2" "$T/patthana.py"
  if cmp -s "$T/patthana.py" "$T/patthana.py.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $PY "$T/patthana.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brk "the negative written with a space is not joined (na anantare)" 's/in FORMS else m.group(0), text)/in () else m.group(0), text)/'
brk "no sentence stop (a statement's root reaches the next sentence's count)" 's/out.append(("stop", None))/pass/'
brk "the prose-sandwich rule removed (arūpe vipāke ekaṃ khandhaṃ)" 's/out\[j + 1\] = ("unknown", "(number in prose)")/pass/'
brk "a statement's condition kept as the count's root" 's/and val\[2\] == "root" and last == "unknown":/and False:/'
brk "a run's number given to its last condition only" 's/for c in pending:/for c in pending[-1:]:/'
brk "inferred alternative roots not marked" 's/seg\["alt"\] = 2/pass/'
# the validator must refuse a corrupt file: a count of 0, and a single root counting its own condition
T=$(mktemp -d)
$PY - "$T" <<'EOF'
import json, sys
d = json.load(open("patthana/PATTHANA.json", encoding="utf-8"))
a = json.loads(json.dumps(d)); a["count_lines"][0]["seg"][0]["counts"][0][2] = 0
json.dump(a, open(sys.argv[1] + "/zero.json", "w"), ensure_ascii=False)
b = json.loads(json.dumps(d)); r = next(r for r in b["count_lines"] if r["seg"][0]["counts"]); s = r["seg"][0]
s["root"] = [[s["counts"][0][0], s["counts"][0][1]]]; s.pop("alt", None)
json.dump(b, open(sys.argv[1] + "/self.json", "w"), ensure_ascii=False)
EOF
for f in zero self; do
  if $PY scripts/patthana.py --validate "$T/$f.json" >/dev/null 2>&1; then echo "BLIND  validate accepted the corrupt file ($f)"; exit 1
  else echo "FAILS as required  validate refuses a corrupt file ($f)"; fi
done
rm -rf "$T"
echo "all breaks fail as required"
