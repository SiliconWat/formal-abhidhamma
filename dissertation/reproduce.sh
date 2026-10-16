#!/bin/sh
# One command for every number in the dissertation: runs every suite (each theorem must check, each deliberate
# break must fail, each rung-4 control must pass), then regenerates numbers.json from the Lean and from the rule
# files' own clause tags. `--check` fails if numbers.json is stale. Needs Lean 4 (LEAN=…) and Python 3.
set -u
cd "$(dirname "$0")/.."
LEAN="${LEAN:-$( (cd "$(git rev-parse --show-toplevel)" && { elan which lean || ~/.elan/bin/elan which lean; }) 2>/dev/null || command -v lean)}"; export LEAN   # the PINNED binary; a bare `lean` outside the repo is elan's default
fail=0
[ "${1:-}" = "--check-numbers" ] && set -- --check && SKIP_SUITES=1   # CI: the suites already ran in their own step
for s in control/run.sh sangaha/run.sh kala/run.sh matika/run.sh rung4/run.sh; do
  [ -n "${SKIP_SUITES:-}" ] && break
  [ -f "$s" ] || continue
  if sh "$s" >/dev/null 2>&1; then echo "✓ $s"; else echo "✗ $s"; fail=1; fi
done
( cd control && "$LEAN" -o Cetasika.olean Cetasika.lean ) >/dev/null 2>&1
( cd sangaha && for f in Citta Rules AnswerKey Canon; do LEAN_PATH="../control:." "$LEAN" -o $f.olean $f.lean || exit 1; done ) >/dev/null 2>&1 || { echo "✗ building sangaha"; exit 1; }
lean_json=$(cd sangaha && LEAN_PATH="../control:." "$LEAN" ../dissertation/Numbers.lean) || { echo "✗ Numbers.lean"; exit 1; }
new=$(python3 -I - "$lean_json" <<'PY'
import json, re, sys
d = json.loads(sys.argv[1])
g = len(re.findall(r"§G\d+", open("sangaha/Citta.lean", encoding="utf-8").read()))
r = len(set(re.findall(r"§R\d+", open("sangaha/Rules.lean", encoding="utf-8").read())))
d.update({"generator_clauses": g, "rule_clauses": r, "clauses": g + r,
          "compression_121": round((g + r) / d["cittas121"], 2), "compression_89": round((g + r) / d["cittas89"], 2)})
print(json.dumps(d, ensure_ascii=False, indent=1, sort_keys=True))
PY
)
if [ "${1:-}" = "--check" ]; then
  if [ "$new" = "$(cat dissertation/numbers.json 2>/dev/null)" ]; then echo "✓ numbers.json is current"; else echo "✗ numbers.json is stale: run dissertation/reproduce.sh"; fail=1; fi
else
  printf '%s\n' "$new" > dissertation/numbers.json && echo "wrote dissertation/numbers.json"
fi
exit $fail
