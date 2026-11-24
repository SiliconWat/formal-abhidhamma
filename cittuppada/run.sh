#!/bin/sh
# Capture: the Dhammasaṅgaṇī's Cittuppāda as generated data (scripts/cittuppada.py, 2026-11-21). CI has no CST text (legal L21): the parsing
# rules are checked on known answers (--selftest), the JSON on its invariants and its known answer (--validate), and each break must FAIL.
set -u; cd "$(dirname "$0")/.."; PY="${PYTHON:-python3}"
if $PY scripts/cittuppada.py --selftest >/dev/null; then echo "PASS  selftest: lists (full, elided, a missing comma), derived counts, summaries; a wrong expectation fails"
else $PY scripts/cittuppada.py --selftest; echo "FAIL selftest"; exit 1; fi
$PY scripts/cittuppada.py --validate || exit 1
brk() { T=$(mktemp -d); cp scripts/cittuppada.py "$T/"
  $PY - "$T/cittuppada.py" "$2" "$3" <<'ZZPY' || { echo "BREAK NOT APPLIED  $1"; exit 1; }
import sys
p, old, new = sys.argv[1], sys.argv[2], sys.argv[3]; s = open(p, encoding="utf-8").read()
if s.count(old) != 1: sys.exit(1)
open(p, "w", encoding="utf-8").write(s.replace(old, new))
ZZPY
  if $PY "$T/cittuppada.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brk "items split at commas (loses manindriyaṃ after the CST's missing comma)" 'parts = re.split(r"\s*(?<![\wāīūṃ])hoti(?![\wāīūṃ])\s*,?\s*", body)' 'parts = re.split(r"\s*hoti\s*,\s*", body)'
brk "the summary reads honti but not hoti" 'hon?ti(?=' 'hont?i(?='
brk "number words read whole (aṭṭhindriyāni unread)" '"aṭṭh": 8' '"aṭṭha": 8'
brk "one member counted as the whole class (ekaṃ manindriyaṃ)" 'if noun.endswith("indriyāni"): return "indriya"' 'if "indriy" in noun: return "indriya"'
T=$(mktemp -d)
$PY - "$T" <<'ZZPY'
import json, sys
d = json.load(open("cittuppada/CITTUPPADA.json", encoding="utf-8"))
a = json.loads(json.dumps(d)); a["classes"][0]["padas"] = a["classes"][0]["padas"][1:]
json.dump(a, open(sys.argv[1] + "/known.json", "w"), ensure_ascii=False)
b = json.loads(json.dumps(d)); b["summaries"][0]["of"] = b["summaries"][0]["line"] + 1
json.dump(b, open(sys.argv[1] + "/order.json", "w"), ensure_ascii=False)
c = json.loads(json.dumps(d)); t = next(s for s in c["summaries"] if isinstance(s.get("test"), list) and s["test"]); t["test"][0][3] = not t["test"][0][3]
json.dump(c, open(sys.argv[1] + "/verdict.json", "w"), ensure_ascii=False)
e = json.loads(json.dumps(d)); e["classes"][0]["padas"][0] = "phasso hoti vedanā"
json.dump(e, open(sys.argv[1] + "/term.json", "w"), ensure_ascii=False)
g = json.loads(json.dumps(d)); x = next(k for k in g["classes"] if k.get("asks") == "abyākatā" and k.get("closes") == "abyākatā"); x["closes"] = "kusalā"
json.dump(g, open(sys.argv[1] + "/answer.json", "w"), ensure_ascii=False)
ZZPY
for f in known order verdict term answer; do
  if $PY scripts/cittuppada.py --validate "$T/$f.json" >/dev/null 2>&1; then echo "BLIND  validate accepted the corrupt file ($f)"; exit 1
  else echo "FAILS as required  validate refuses a corrupt file ($f)"; fi
done
rm -rf "$T"
echo "all breaks fail as required"
