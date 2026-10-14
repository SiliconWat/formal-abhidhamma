#!/bin/sh
# The founder's sixth supposition (PREREG pushed 2026-10-14T04:03:33Z, OTS). Every registered definition, the structure and
# the statements of T6L and T6B must appear VERBATIM in Potential.lean; T6 and T6W, which cannot be proved, must appear CLAUSE
# FOR CLAUSE as the claims `t6_registered` and `t6w_registered`; every theorem must CHECK; each break of T6L must FAIL.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
python3 - <<'PY' || exit 1
import re
reg = open("PREREG.md", encoding="utf-8").read().split("```lean", 1)[1].split("```", 1)[0]
# comments stripped first, so a commented-out copy cannot stand in for a moved definition (the run refuter's F9)
src = re.sub(r"(?s)/-.*?-/", "", open("Potential.lean", encoding="utf-8").read())
src = re.sub(r"(?m)--.*$", "", src)
flat = lambda s: " ".join(s.split())
CLAIMS = {"t6_can_still_become_capable": "t6_registered", "t6w_will_become_capable": "t6w_registered"}
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
print(f"VERBATIM  {len(chunks)} registered definitions and statements unchanged; T6 and T6W clause for clause as claims")
PY
if $LEAN Potential.lean; then echo "PASS  t6_not_forced/t6_admitted (INDEPENDENT) · t6w_not_forced/t6w_admitted (INDEPENDENT) · t6l_fails_for_the_once_sunk_on_the_literal_reading · t6b_the_answer_is_not_enough · model_t6l_hypotheses · needs_a124_incapable · needs_a125_literal"; else echo "FAIL"; exit 1; fi
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
try() { T=$(mktemp -d); cp Potential.lean "$T/"; only "$T/Potential.lean" "$1"; cp "$T/Potential.lean" "$T/kept.lean"
  if ! $LEAN "$T/kept.lean" >/dev/null 2>&1; then echo "ISOLATION BROKEN  $1 alone does not compile"; exit 1; fi
  sed -i.orig "$3" "$T/Potential.lean"
  if cmp -s "$T/Potential.lean" "$T/Potential.lean.orig"; then echo "BREAK NOT APPLIED  $2"; exit 1; fi
  if $LEAN "$T/Potential.lean" >/dev/null 2>&1; then echo "BLIND  $2"; exit 1; else echo "FAILS as required  $2 ($1 alone)"; fi; rm -rf "$T"; }
T6L=t6l_fails_for_the_once_sunk_on_the_literal_reading
try $T6L "A124 dropped: a fixed wrong view need not make a being incapable" 's/^  ∀ h r, b.heinous h r ∨ b.wrongView h r ∨ b.rootless h r ∨ b.weak h r → b.incapable h r/  ∀ h r, True/'
try $T6L "A125's literal reading dropped: the once-sunk need not stay sunk" 's/^  ∀ h, b.agree h b.actual r0 → ∀ r, b.patisandhi h r → r0 ≤ r → b.wrongView h r/  True/'
echo "all breaks fail as required"
