#!/usr/bin/env python3
"""de_tools.py — the machinery of the double encoding (DOUBLE-ENCODING-PREREG.md).
  de_tools.py workspace <outdir> ROW...   one folder per row: row.md (statement, tier, citation; the Lean column removed), Vocab.lean, RULES.md — and nothing else
  de_tools.py compare <workdir> ROW...    transplant each encoder's definition into the real namespace, state OURS (the conjunction of the row's definitions over the World) and try to prove the two equivalent"""
import os, re, subprocess, sys, shutil, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import world as W

RULES = """# Rules for the encoding

You are writing ONE definition in Lean 4 (core Lean, no Mathlib) that says what a row of an axiom list says, over a given vocabulary. Nothing else.

1. **Vocabulary.** `Vocab.lean` holds the types and nothing else (a stream of mind-moments on a clock, matter placed in it, conditioning facts, processes, beings, the cosmos, the status, and `World`). Read it. You may define small helper functions of your own in the same file if the row needs a table or a count; you may not change the types.
2. **Signature.** Write `def enc {S R : Scale} (w : World S R) : Prop := ...` — one proposition about a whole World, inside `namespace V`. Reach the parts through its fields (`w.s` the stream, `w.mat`, `w.proc`, `w.tax`, `w.cond`, `w.cosmos`, `w.status`, the matter placed in the stream `w.K` `w.origin` `w.mom` `w.phase` …, the day-reckoning `w.f` `w.night` `w.week` `w.snap`).
3. **Literal first.** Say what the row's own words say, with only the scope that the row itself records. A scope that only another text supplies is not added. If the row names a list without its members but cites the lines that give them, you may use those lines' members (say so in a comment).
4. **Say what is forbidden, not what is typical.** The definition is true of a world that obeys the row and false of one that breaks it. A definition that is true of every world says nothing; a world with no matter, no processes and no facts will satisfy most rows vacuously, and that is allowed — do not add an existence claim the row does not make (that is a separate list).
5. **Compile it.** `lean Check.lean` where Check.lean is `import`-free: paste Vocab.lean's content, then your definition, inside the same `namespace V`. It must compile with no `sorry`. Put your final definition (and its helpers) in `Answer.lean`, from `namespace V` to `end V`, WITHOUT the vocabulary.
6. **Work alone.** Open only the files in this folder. Do not search the filesystem, do not read anything outside it, do not look up the row's subject elsewhere. Return the content of Answer.lean and one line on any choice you had to make.
"""

def rows():
    d = {}
    for l in open(os.path.join(REPO, "kala", "AXIOMS.md"), encoding="utf-8"):
        cells = [c.strip() for c in l.split("|")]
        m = re.match(r"^(A\d+b?|C|K)$", cells[1]) if len(cells) > 7 else None
        if m: d[m.group(1)] = (cells[2], cells[3], cells[4])      # statement, tier, citation (the Lean column is dropped)
    return d

def workspace(out, ids):
    R = rows()
    for r in ids:
        d = os.path.join(out, r); os.makedirs(d, exist_ok=True)
        st, tier, cite = R[r]
        open(os.path.join(d, "row.md"), "w", encoding="utf-8").write(f"# Row {r}\n\n**Statement.** {st}\n\n**Tier.** {tier}\n\n**Citation.** {cite}\n")
        shutil.copy(os.path.join(HERE, "Vocab.lean"), os.path.join(d, "Vocab.lean"))
        open(os.path.join(d, "RULES.md"), "w", encoding="utf-8").write(RULES)

def ours(row):
    parts = [(f, n, ap) for f, n, ap in W.defs() if (n.split("_")[0].upper() == row)]
    body = " ∧\n    ".join(f"{n} {ap}" for _, n, ap in parts)
    return f"def ours {{S R : Scale}} (w : World S R) : Prop :=\n    {body}", [n for _, n, _ in parts]

TACTICS = ["Iff.rfl", "by simp [ours, enc]", "by unfold ours enc; simp", "by unfold ours enc; constructor <;> intro h <;> simpa using h",
           "by constructor <;> intro h <;> simp_all [ours, enc]"]

def compare(work, ids, lean):
    out = {}
    for r in ids:
        ans = open(os.path.join(work, r, "Answer.lean"), encoding="utf-8").read()
        body = re.sub(r"(?m)^\s*namespace V\s*$|^\s*end V\s*$", "", ans)
        o, names = ours(r)
        results = []
        for t in TACTICS:
            src = f"import World\nnamespace FormalAbhidhamma.Model\nopen FormalAbhidhamma FormalAbhidhamma.Relata\n{body}\n{o}\ntheorem same {{S R : Scale}} (w : World S R) : ours w ↔ enc w := {t}\nend FormalAbhidhamma.Model\n"
            p = os.path.join(work, r, "Compare.lean"); open(p, "w", encoding="utf-8").write(src)
            res = subprocess.run([lean, p], capture_output=True, text=True, env=dict(os.environ, LEAN_PATH=os.environ.get("LEAN_PATH", ""), ELAN_TOOLCHAIN=open(os.path.join(REPO, "lean-toolchain")).read().strip()))
            ok = res.returncode == 0 and "sorry" not in res.stdout
            results.append((t, ok, (res.stdout + res.stderr)[:300]))
            if ok: break
        out[r] = (names, results)
        print(r, "PROVED EQUIVALENT by" if results[-1][1] else "NOT PROVED", results[-1][0] if results[-1][1] else "", "| ours:", ", ".join(names))
    return out

if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "workspace": workspace(sys.argv[2], sys.argv[3:])
    elif cmd == "compare": compare(sys.argv[2], sys.argv[3:], os.environ.get("LEAN", "lean"))
