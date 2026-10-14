#!/bin/sh
# The post-A395 known-answer control (PREREG pushed 2026-10-14T06:03:08Z, OTS): the Vajirabuddhi-ṭīkā's "no first citta".
# Every registered definition, the structure and both statements must appear VERBATIM (anchored) in Control.lean; every
# theorem must CHECK; each break must FAIL on its target alone.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
python3 - <<'PY' || exit 1
import re
reg = open("PREREG.md", encoding="utf-8").read().split("```lean", 1)[1].split("```", 1)[0]
# comments stripped first, so a commented-out copy cannot stand in for a moved definition (the run refuter's F9)
src = re.sub(r"(?s)/-.*?-/", "", open("Control.lean", encoding="utf-8").read())
src = re.sub(r"(?m)--.*$", "", src)
flat = lambda s: " ".join(s.split())
CLAIMS = {}
chunks = re.findall(r"(?m)^(def [\s\S]*?)(?=\n\n|\n/-)", reg) + re.findall(r"(?m)^(structure World where[\s\S]*?)(?=\n\n)", reg)
chunks += re.findall(r"(?m)^(inductive [\s\S]*?)(?=\n\n)", reg)                # the Destiny type too (F9)
thms = re.findall(r"(?m)^(theorem [\s\S]*?:= by)", reg)
chunks += [t for t in thms if t.split()[1] not in CLAIMS]
# ANCHORED (the re-run's refuter, F11): each registered chunk must EQUAL the source chunk of the same name, cut the same way —
# a substring test passed a field appended to a structure or a line appended to a definition
def cut(text):
    out = {}
    for pat in (r"(?m)^(def [\s\S]*?)(?=\n\n|\n/-|\Z)", r"(?m)^(structure \w+ where[\s\S]*?)(?=\n\n|\Z)",
                r"(?m)^(inductive [\s\S]*?)(?=\n\n|\Z)", r"(?m)^(theorem [\s\S]*?:=(?: by)?)"):   # each theorem cut at ITS OWN ":=" — a
        # term-mode theorem has no "by", and cutting at ":= by" let it swallow the next theorem's statement (caught at once)
        for c in re.findall(pat, text): out[" ".join(c.split()[:2])] = c
    return out
have = cut(src)
moved = [c.split("\n")[0] for c in chunks if have.get(" ".join(c.split()[:2])) != c]
# an unprovable registered theorem becomes a claim: each named binder a ∀, each hypothesis an arrow, the conclusion kept
for t in thms:
    name = t.split()[1]
    if name not in CLAIMS: continue
    head, concl = t[len("theorem " + name):-len(":= by")].rsplit(") :", 1)
    binders = re.findall(r"\((\w+) : ([^()]*)\)", head + ")")
    parts = [f"∀ ({n} : {ty})," if not n.startswith("h") else f"{ty} →" for n, ty in binders]
    want = flat(" ".join(parts) + " " + concl)
    m = re.search(rf"def {CLAIMS[name]} : Prop :=\n([\s\S]*?)(?=\n\n)", src)
    if not m or flat(m.group(1)) != want: moved.append(f"{name} (as {CLAIMS[name]})")
if not chunks or moved:
    print("STATEMENT MOVED", moved or "nothing registered was found"); raise SystemExit(1)
print(f"VERBATIM  {len(chunks)} registered definitions and statements unchanged; no unprovable statement registered")
PY
if $LEAN Control.lean; then echo "PASS  t1_no_first_citta · t0_proximity_is_irreflexive · model_t1_hypotheses · needs_c_predecessor · needs_a3_successor"; else echo "FAIL"; exit 1; fi
# A break is applied to a copy that keeps the definitions and ONLY the theorem it targets (the Kv 8.2 run refuter's F4).
only() { python3 - "$1" "$2" <<'PY'
import re, sys
path, keep = sys.argv[1], sys.argv[2]
L = open(path, encoding="utf-8").read().split("\n")
starts = [i for i, l in enumerate(L) if l.startswith("theorem ")]
drop = set()
for i in starts:
    if L[i].split()[1] == keep: continue
    a = i
    if a > 0 and L[a - 1].rstrip().endswith("-/"):            # its docstring goes with it
        while a > 0 and not L[a - 1].lstrip().startswith("/--"): a -= 1
        a -= 1
    b = i + 1
    while b < len(L) and not re.match(r"(/--|/-!|theorem |def |end )", L[b]): b += 1
    drop.update(range(a, b))
open(path, "w", encoding="utf-8").write("\n".join(l for k, l in enumerate(L) if k not in drop))
PY
}
try() { T=$(mktemp -d); cp Control.lean "$T/"; only "$T/Control.lean" "$1"; cp "$T/Control.lean" "$T/kept.lean"
  if ! $LEAN "$T/kept.lean" >/dev/null 2>&1; then echo "ISOLATION BROKEN  $1 alone does not compile"; exit 1; fi
  sed -i.orig "$3" "$T/Control.lean"
  if cmp -s "$T/Control.lean" "$T/Control.lean.orig"; then echo "BREAK NOT APPLIED  $2"; exit 1; fi
  if $LEAN "$T/Control.lean" >/dev/null 2>&1; then echo "BLIND  $2"; exit 1; else echo "FAILS as required  $2 ($1 alone)"; fi; rm -rf "$T"; }
T1=t1_no_first_citta
T0=t0_proximity_is_irreflexive
try $T1 "C dropped: a citta may lack a predecessor" 's/^def c_predecessor (w : World) : Prop := .*/def c_predecessor (w : World) : Prop := True/'
try $T1 "A3 dropped: proximity need not run forward" 's/^def a3_successor (w : World) : Prop := .*/def a3_successor (w : World) : Prop := True/'
try $T0 "A3 dropped (T0)" 's/^def a3_successor (w : World) : Prop := .*/def a3_successor (w : World) : Prop := True/'
echo "all breaks fail as required"
