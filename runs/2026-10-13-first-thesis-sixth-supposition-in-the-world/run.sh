#!/bin/sh
# The founder's sixth supposition, re-run under A394 (PREREG pushed 2026-10-14T04:39:24Z, OTS). Every registered definition,
# both structures and the statements of T6R and T6X must appear VERBATIM in World.lean; T6O, which cannot be proved, must
# appear CLAUSE FOR CLAUSE as the claim `t6o_registered`; every theorem must CHECK; each break of T6R and T6X must FAIL.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
python3 - <<'PY' || exit 1
import re
reg = open("PREREG.md", encoding="utf-8").read().split("```lean", 1)[1].split("```", 1)[0]
# comments stripped first, so a commented-out copy cannot stand in for a moved definition (the run refuter's F9)
src = re.sub(r"(?s)/-.*?-/", "", open("World.lean", encoding="utf-8").read())
src = re.sub(r"(?m)--.*$", "", src)
flat = lambda s: " ".join(s.split())
CLAIMS = {"t6o_on_the_restricted_reading": "t6o_registered"}
chunks = re.findall(r"(?m)^(def [\s\S]*?)(?=\n\n|\n/-)", reg) + re.findall(r"(?m)^(structure \w+ where[\s\S]*?)(?=\n\n)", reg)
chunks += re.findall(r"(?m)^(inductive [\s\S]*?)(?=\n\n)", reg)                # the Destiny type too (F9)
thms = re.findall(r"(?m)^(theorem [\s\S]*?:= by)", reg)
chunks += [t for t in thms if t.split()[1] not in CLAIMS]
moved = [c.split("\n")[0] for c in chunks if c not in src]
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
print(f"VERBATIM  {len(chunks)} registered definitions and statements unchanged; T6O clause for clause as a claim")
PY
if $LEAN World.lean; then echo "PASS  t6r_refuted_on_the_literal_reading · t6x_the_literal_reading_contradicts_the_answer · t6o_not_forced/t6o_admitted (INDEPENDENT) · model_t6r_hypotheses · needs_a124_incapable_all · needs_a125_found_in_world · needs_a125_literal_all"; else echo "FAIL"; exit 1; fi
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
try() { T=$(mktemp -d); cp World.lean "$T/"; only "$T/World.lean" "$1"; cp "$T/World.lean" "$T/kept.lean"
  if ! $LEAN "$T/kept.lean" >/dev/null 2>&1; then echo "ISOLATION BROKEN  $1 alone does not compile"; exit 1; fi
  sed -i.orig "$3" "$T/World.lean"
  if cmp -s "$T/World.lean" "$T/World.lean.orig"; then echo "BREAK NOT APPLIED  $2"; exit 1; fi
  if $LEAN "$T/World.lean" >/dev/null 2>&1; then echo "BLIND  $2"; exit 1; else echo "FAILS as required  $2 ($1 alone)"; fi; rm -rf "$T"; }
T6R=t6r_refuted_on_the_literal_reading
T6X=t6x_the_literal_reading_contradicts_the_answer
A124='s/^  ∀ h r, b.heinous h r ∨ b.wrongView h r ∨ b.rootless h r ∨ b.weak h r → b.incapable h r/  ∀ h r, True/'
FOUND='s/^  ∃ x r0, (w.being x).patisandhi (w.being x).actual r0 ∧ (w.being x).wrongView (w.being x).actual r0$/  True/'
LIT='s/^    a125_once_sunk_literal (w.being x) r0$/    True/'
try $T6R "A124 dropped: a fixed wrong view need not make a being incapable" "$A124"
try $T6R "the existence clause dropped: no one need be once sunk" "$FOUND"
try $T6R "the literal reading dropped: the once-sunk need not stay sunk" "$LIT"
try $T6X "the existence clause dropped" "$FOUND"
try $T6X "the literal reading dropped" "$LIT"
echo "all breaks fail as required"
