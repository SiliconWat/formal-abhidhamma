#!/bin/sh
# Capture: the Yamaka's question index as generated data (scripts/yamaka.py, 2026-11-20). CI has no CST text (legal L21), so the parser's
# rules are checked on known answers (--selftest), the generated JSON on its own invariants (--validate), and each deliberate break below
# must FAIL. Breaks are literal replacements (sed cannot be trusted with a regex's backslashes). Exit 0 only if all hold.
set -u; cd "$(dirname "$0")/.."; PY="${PYTHON:-python3}"
if $PY scripts/yamaka.py --selftest >/dev/null; then echo "PASS  selftest: lettered and unlettered questions, every answer kind, elided series, on known answers; a wrong expectation fails"
else $PY scripts/yamaka.py --selftest; echo "FAIL selftest"; exit 1; fi
$PY scripts/yamaka.py --validate || exit 1
brk() { T=$(mktemp -d); cp scripts/yamaka.py "$T/"
  $PY - "$T/yamaka.py" "$2" "$3" <<'ZZPY' || { echo "BREAK NOT APPLIED  $1"; exit 1; }
import sys
p, old, new = sys.argv[1], sys.argv[2], sys.argv[3]; s = open(p, encoding="utf-8").read()
if s.count(old) != 1: sys.exit(1)
open(p, "w", encoding="utf-8").write(s.replace(old, new))
ZZPY
  if $PY "$T/yamaka.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brk "Āmantā read as no" 'YES, NO, NONE_ = {"āmantā"}, {"no", "na"}, {"natthi"}' 'YES, NO, NONE_ = set(), {"no", "na", "āmantā"}, {"natthi"}'
brk "an answer not cut at its sentence end (two answered questions on one line)" 'cut = re.search(r"[.!]\s", answer)' 'cut = None'
brk "text between two question marks taken as an answer" 'answer = "…" if answer.lstrip().startswith("…") else ""' 'pass'
brk "an elided series not marked" 'kind = "elided" if answer.lstrip().startswith("…") else inline_kind(answer)' 'kind = inline_kind(answer)'
brk "a one-word answer line read as an analysis" 'kind = one  # the next line' 'pass  # the next line'
brk "a lettered body line without a question mark dropped" 'e = ELIDED.match(p) if rend == "bodytext" else None' 'e = None'
T=$(mktemp -d)
$PY - "$T" <<'ZZPY'
import json, sys
d = json.load(open("yamaka/YAMAKA.json", encoding="utf-8"))
a = json.loads(json.dumps(d)); a["books"][2]["tally"]["yes"] += 1
json.dump(a, open(sys.argv[1] + "/tally.json", "w"), ensure_ascii=False)
b = json.loads(json.dumps(d)); b["books"][4]["q"][0][0] = b["books"][4]["lines"][0]
json.dump(b, open(sys.argv[1] + "/outside.json", "w"), ensure_ascii=False)
c = json.loads(json.dumps(d)); c["books"] = c["books"][:9]
json.dump(c, open(sys.argv[1] + "/nine.json", "w"), ensure_ascii=False)
ZZPY
for f in tally outside nine; do
  if $PY scripts/yamaka.py --validate "$T/$f.json" >/dev/null 2>&1; then echo "BLIND  validate accepted the corrupt file ($f)"; exit 1
  else echo "FAILS as required  validate refuses a corrupt file ($f)"; fi
done
rm -rf "$T"
echo "all breaks fail as required"
