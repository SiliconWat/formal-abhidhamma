#!/bin/sh
# Capture: the Kathāvatthu's debate index as generated data (scripts/kathavatthu.py, 2026-11-20). CI has no CST text (legal L21), so the
# parser's rules are checked on known answers (--selftest), the generated JSON on its own invariants (--validate), and each deliberate
# break below must FAIL. Exit 0 only if all hold.
set -u; cd "$(dirname "$0")/.."; PY="${PYTHON:-python3}"
if $PY scripts/kathavatthu.py --selftest >/dev/null; then echo "PASS  selftest: questions, replies, citations and debate headings on known answers; a wrong expectation fails"
else $PY scripts/kathavatthu.py --selftest; echo "FAIL selftest"; exit 1; fi
$PY scripts/kathavatthu.py --validate || exit 1
brk() { T=$(mktemp -d); cp scripts/kathavatthu.py "$T/"; sed -i.orig "$2" "$T/kathavatthu.py"
  if cmp -s "$T/kathavatthu.py" "$T/kathavatthu.py.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $PY "$T/kathavatthu.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brk "a 'no' reply read as 'yes'" 's/"na hevaṃ vattabbe": "no"/"na hevaṃ vattabbe": "yes"/'
brk "a citation's look-back removed (the quote's full stop cuts 'Nanu vuttaṃ' off)" 's/span = text\[prev:m.end(1)\]/span = m.group(1)/'
brk "a title-tagged debate heading ignored (debate 12)" 's/if rend in ("subhead", "title") and DEBATE_SUB.match(p):/if rend == "subhead" and DEBATE_SUB.match(p):/'
brk "a range heading's abbreviated end not expanded (212-4)" 's/last = first\[: len(first) - len(last)\] + last/pass/'
# a literal replacement (sed cannot be trusted with a regex's own backslashes): the optional dot made required again
brkpy() { T=$(mktemp -d); cp scripts/kathavatthu.py "$T/"
  $PY - "$T/kathavatthu.py" "$2" "$3" <<'EOF2' || { echo "BREAK NOT APPLIED  $1"; exit 1; }
import sys
p, old, new = sys.argv[1], sys.argv[2], sys.argv[3]; s = open(p, encoding="utf-8").read()
if s.count(old) != 1: sys.exit(1)
open(p, "w", encoding="utf-8").write(s.replace(old, new))
EOF2
  if $PY "$T/kathavatthu.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brkpy "the heading's dot required again (188 has none)" '\d+(?:[-–]\d+)?\.?\s*(.+kathā)' '\d+(?:[-–]\d+)?\.\s*(.+kathā)'
brkpy "a school name need not end in a case ending (andhakārena, by darkness, read as the Andhakas)" 'return out if out and _ENDING.match(w[i:]) else []' 'return out'
brkpy "a school stem matched anywhere in a word (bandhako, binding)" 'st = next((x for x in _STEMS if w.startswith(x, i)), None)' 'st = next((x for x in _STEMS if x in w[i:]), None)'
T=$(mktemp -d)
$PY - "$T" <<'EOF'
import json, sys
d = json.load(open("kathavatthu/KATHAVATTHU.json", encoding="utf-8"))
a = json.loads(json.dumps(d)); a["debates"][3]["tally"]["yes"] += 1
json.dump(a, open(sys.argv[1] + "/tally.json", "w"), ensure_ascii=False)
b = json.loads(json.dumps(d)); b["debates"][5]["q"][0][0] = b["debates"][5]["lines"][0]
json.dump(b, open(sys.argv[1] + "/outside.json", "w"), ensure_ascii=False)
c = json.loads(json.dumps(d)); js = [k for k, x in enumerate(c["debates"]) if "commentary_line" in x]
c["debates"][js[5]]["commentary_line"] = c["debates"][js[4]]["commentary_line"]
json.dump(c, open(sys.argv[1] + "/order.json", "w"), ensure_ascii=False)
EOF
for f in tally outside order; do
  if $PY scripts/kathavatthu.py --validate "$T/$f.json" >/dev/null 2>&1; then echo "BLIND  validate accepted the corrupt file ($f)"; exit 1
  else echo "FAILS as required  validate refuses a corrupt file ($f)"; fi
done
rm -rf "$T"
echo "all breaks fail as required"
