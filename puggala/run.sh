#!/bin/sh
# Capture: the Puggalapaññatti's person-type index as generated data (scripts/puggala.py, 2026-11-20). CI has no CST text (legal L21):
# the parsing rules are checked on known answers (--selftest), the JSON on its invariants (--validate), and each deliberate break must FAIL.
set -u; cd "$(dirname "$0")/.."; PY="${PYTHON:-python3}"
if $PY scripts/puggala.py --selftest >/dev/null; then echo "PASS  selftest: names, sets, the definition forms and the closing formula, on known answers; a wrong expectation fails"
else $PY scripts/puggala.py --selftest; echo "FAIL selftest"; exit 1; fi
$PY scripts/puggala.py --validate || exit 1
brk() { T=$(mktemp -d); cp scripts/puggala.py "$T/"
  $PY - "$T/puggala.py" "$2" "$3" <<'ZZPY' || { echo "BREAK NOT APPLIED  $1"; exit 1; }
import sys
p, old, new = sys.argv[1], sys.argv[2], sys.argv[3]; s = open(p, encoding="utf-8").read()
if s.count(old) != 1: sys.exit(1)
open(p, "w", encoding="utf-8").write(s.replace(old, new))
ZZPY
  if $PY "$T/puggala.py" --selftest >/dev/null 2>&1; then echo "BLIND  $1"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
brk "a pair entry read as one name" 'items = [x.strip() for x in re.split(r",|\s+ca\b|\.$", entry.rstrip(".")) if x.strip() and x.strip() != "ca"]' 'items = [entry.rstrip(".")]'
brk "a set entry read as a name (Tayo gilānūpamā puggalā)" 'if nfc(entry.split()[0]).lower() in NUMBER or nfc(entry.split()[0]).lower() in ("aparepi", "apare"):' 'if False:'
brk "the one-g spelling (pugalo) missed" 'DEFINE = re.compile(r"Katamo ca pugg?alo\s+(.+?)\?")' 'DEFINE = re.compile(r"Katamo ca puggalo\s+(.+?)\?")'
brk "the plural closing (ime vuccanti) missed" 'vucca(?:ti|nti)' 'vuccati'
brk "the how-definition (Kathañca puggalo … hoti?) missed" 'DEFINE_HOW = re.compile(r"Kathañca\s+puggalo\s+(.+?)\s+hoti\b[^?]*\?")' 'DEFINE_HOW = re.compile(r"(?!x)x")'
T=$(mktemp -d)
$PY - "$T" <<'ZZPY'
import json, sys
d = json.load(open("puggala/PUGGALA.json", encoding="utf-8"))
a = json.loads(json.dumps(d)); a["groups"] = a["groups"][1:]
json.dump(a, open(sys.argv[1] + "/groups.json", "w"), ensure_ascii=False)
b = json.loads(json.dumps(d)); b["groups"][0]["entries"][3]["n"] = 99
json.dump(b, open(sys.argv[1] + "/numbering.json", "w"), ensure_ascii=False)
c = json.loads(json.dumps(d)); x = next(x for x in c["definitions"] if "entry" in x); c["definitions"] += [dict(x, line=10**6 + k) for k in range(3)]
json.dump(c, open(sys.argv[1] + "/joined.json", "w"), ensure_ascii=False)
ZZPY
for f in groups numbering joined; do
  if $PY scripts/puggala.py --validate "$T/$f.json" >/dev/null 2>&1; then echo "BLIND  validate accepted the corrupt file ($f)"; exit 1
  else echo "FAILS as required  validate refuses a corrupt file ($f)"; fi
done
rm -rf "$T"
echo "all breaks fail as required"
