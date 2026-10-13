#!/usr/bin/env python3
"""theorems-index.py — generate kala/THEOREMS.md, the running list of every machine-checked theorem in this repo.

  scripts/theorems-index.py           write kala/THEOREMS.md
  scripts/theorems-index.py --check   exit 1 if it is stale, a file fails to compile, or any proof uses `sorry` (CI)

Founder 2026-10-13: *"Let's compile a running list for our 'Abhidhamma theorems' too as we find them"* — in the form
ruled with it: GENERATED from the Lean sources, never typed by hand, so the list cannot drift from the proofs.
Three files, three roles: AXIOMS.md (what the texts ASSERT) → THEOREMS.md (what we DERIVE) ← ANSWERS.md (what the
texts themselves DERIVE — the test bank).

Every row is read from Lean by `tools/Uses.lean`'s `#theorems_report`: which hypotheses the ELABORATED proof term
uses (never which ones the author says it uses), the Lean axioms beneath it (Classical.choice = a classical proof;
sorryAx = no proof at all), and the docstring. Each file is compiled the way its suite's run.sh compiles it, in a
temporary copy; nothing in the repo is touched.
"""
import glob, json, os, re, shutil, subprocess, sys, tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(REPO, "kala", "THEOREMS.md")
LIBS = ["control", "sangaha", "kala", "matika"]   # suite directories (their modules may import each other)
# A file that exists to FAIL (its run.sh requires it not to compile) is never reported. One today.
MUST_FAIL = {"control/Broken.lean"}
AXIOM_BINDER = re.compile(r"^(a0′?|a\d+b?|c|k)_", re.I)   # the /prove convention: `a112_link` → A112

def lean_bin():
    if os.environ.get("LEAN"): return os.environ["LEAN"]
    try:
        return subprocess.run(["elan", "which", "lean"], cwd=REPO, capture_output=True, text=True, check=True).stdout.strip()
    except Exception:
        return "lean"

def imports(path):
    return re.findall(r"(?m)^import\s+(\S+)", open(path, encoding="utf-8").read())

def run(lean, f, cwd, path, olean=None):
    env = dict(os.environ, LEAN_PATH=":".join(path))
    args = [lean] + (["-o", olean] if olean else []) + [f]
    return subprocess.run(args, cwd=cwd, env=env, capture_output=True, text=True)

def collect(tmp, lean):
    """Return ([(relpath, [report dicts])], [errors])."""
    # every module, by directory
    files = []
    for d in LIBS + sorted(os.path.relpath(x, REPO) for x in glob.glob(os.path.join(REPO, "runs", "2*")) if os.path.isdir(x)):
        for f in sorted(glob.glob(os.path.join(REPO, d, "*.lean"))):
            rel = os.path.relpath(f, REPO)
            os.makedirs(os.path.join(tmp, d), exist_ok=True)
            shutil.copy(f, os.path.join(tmp, rel))
            files.append(rel)
    os.makedirs(os.path.join(tmp, "tools"), exist_ok=True)
    shutil.copy(os.path.join(REPO, "tools", "Uses.lean"), os.path.join(tmp, "tools", "Uses.lean"))
    errors = []
    r = run(lean, "Uses.lean", os.path.join(tmp, "tools"), [os.path.join(tmp, "tools")], "Uses.olean")
    if r.returncode: return [], [f"tools/Uses.lean does not compile:\n{r.stdout}{r.stderr}"]

    def resolve(rel, mod):
        """The directory that provides `mod` for `rel`: its own directory first, then a library directory."""
        own = os.path.dirname(rel)
        if os.path.exists(os.path.join(REPO, own, mod + ".lean")): return own
        hits = [d for d in LIBS if os.path.exists(os.path.join(REPO, d, mod + ".lean"))]
        if len(hits) != 1: raise SystemExit(f"{rel}: import {mod} resolves to {hits or 'nothing'}")
        return hits[0]

    def search_path(rel):
        dirs, todo = [], [rel]
        while todo:
            cur = todo.pop()
            for m in imports(os.path.join(REPO, cur)):
                if m in ("Lean", "Std", "Init"): continue
                d = resolve(cur, m)
                if d not in dirs: dirs.append(d)
                todo.append(os.path.join(d, m + ".lean"))
        own = os.path.dirname(rel)
        return [os.path.join(tmp, own)] + [os.path.join(tmp, d) for d in dirs if d != own]

    # build an .olean for every module some other file imports, dependencies first
    built = set()
    def build(rel):
        if rel in built: return True
        for m in imports(os.path.join(REPO, rel)):
            if m in ("Lean", "Std", "Init"): continue
            if not build(os.path.join(resolve(rel, m), m + ".lean")): return False
        d, stem = os.path.dirname(rel), os.path.splitext(os.path.basename(rel))[0]
        r = run(lean, stem + ".lean", os.path.join(tmp, d), search_path(rel), stem + ".olean")
        if r.returncode:
            errors.append(f"{rel} does not compile:\n{(r.stdout + r.stderr)[-1500:]}"); return False
        built.add(rel); return True
    for rel in files:
        for m in imports(os.path.join(REPO, rel)):
            if m not in ("Lean", "Std", "Init"): build(os.path.join(resolve(rel, m), m + ".lean"))

    out = []
    for rel in files:
        if rel in MUST_FAIL: continue
        d, stem = os.path.dirname(rel), os.path.splitext(os.path.basename(rel))[0]
        src = open(os.path.join(REPO, rel), encoding="utf-8").read()
        rep = os.path.join(tmp, d, f"Report_{stem}.lean")
        open(rep, "w", encoding="utf-8").write("import Uses\n" + src.rstrip("\n") + "\n\n#theorems_report\n")
        r = run(lean, os.path.basename(rep), os.path.join(tmp, d), search_path(rel) + [os.path.join(tmp, "tools")])
        if r.returncode:
            errors.append(f"{rel} does not compile under the report:\n{(r.stdout + r.stderr)[-1500:]}"); continue
        rows = [json.loads(m.group(1)) for m in re.finditer(r"THEOREM_JSON (\{.*\})", r.stdout)]
        for t in rows: t["line"] -= 1        # the report copy starts with an injected `import Uses` line (F9, 2026-10-13)
        out.append((rel, rows))
    return out, errors

def first_sentence(doc):
    """The docstring's first real sentence: a leading label ("D1.", "II.", "D4,") is kept but never stands alone."""
    t = " ".join(doc.split())
    m = re.match(r"(.{25,}?[.!?])(\s|$)", t)
    s = m.group(1) if m else t
    return (s if len(s) <= 200 else s[:197] + "…").replace("|", "/")

def lean_map():
    """AXIOMS.md's Lean column → [(name parts, ID)]: the DEFINITIONS that encode an axiom (`Stream.one_at_a_time` = A1).
    File names and the names of theorems that CHECK an axiom are in that column too; neither can match, because
    `#theorems_report` lists only definitions and structure fields."""
    out = []
    for line in open(os.path.join(REPO, "kala", "AXIOMS.md"), encoding="utf-8"):
        m = re.match(r"\|\s*(A\d+[b′]?|A0′?|C|K)\s*\|", line)
        if not m: continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 6: continue
        for tok in re.findall(r"`([^`]+)`", cells[5]):
            if tok.endswith(".lean") or "/" in tok: continue
            out.append((tok.split("."), m.group(1)))
    return out

def axiom_ids(defs, table):
    found = []
    for d in defs:
        parts = d.split(".")
        for tok, i in table:
            if parts[-len(tok):] == tok and i not in found: found.append(i)
        # OQ5 (founder 2026-10-13): a premise DEFINITION named by its axiom ID — `a87_purejata` → A87 — counts wherever it
        # is reached, so a countermodel's premises (inside an ∃) are no longer invisible
        m = AXIOM_BINDER.match(parts[-1])
        if m and (i := m.group(1).upper()) not in found: found.append(i)
    order = lambda i: (0, 0) if i.startswith("A0") else (1, int(re.sub(r"\D", "", i) or 0)) if i.startswith("A") else (2, i)
    return sorted(found, key=order)

def held_out():
    """IDs whose AXIOMS.md row is marked HELD OUT (a text's own conclusion — kala/ANSWERS.md): never a premise."""
    out = set()
    for line in open(os.path.join(REPO, "kala", "AXIOMS.md"), encoding="utf-8"):
        m = re.match(r"\|\s*(A\d+[b′]?|A0′?|C|K)\s*\|", line)
        if m and "HELD OUT" in line: out.add(m.group(1))
    return out

CITE = re.compile(r"([a-z0-9]+\.(?:mul|att|tik|nrf)\.xml):(\d+)(?:[–-](\d+))?")

def cites(cell):
    """file → set of line numbers, for every `file.xml:N` or `file.xml:N–M` in a cell (`:M` alone reuses the last file)."""
    out, last = {}, None
    for tok in re.finditer(r"([a-z0-9]+\.(?:mul|att|tik|nrf)\.xml)?:(\d+)(?:[–-](\d+))?", cell):
        f = tok.group(1) or last
        if not f: continue
        last = f
        a, b = int(tok.group(2)), int(tok.group(3) or tok.group(2))
        out.setdefault(f, set()).update(range(a, b + 1))
    return out

def citation_overlaps():
    """An ANSWERS row and a live (not HELD OUT) AXIOMS row citing the same line: an answer sitting in the premises."""
    def table(path, key_re, col):
        rows = []
        for line in open(path, encoding="utf-8"):
            m = re.match(key_re, line)
            if not m or line.startswith("|---"): continue
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            if len(cells) > col: rows.append((m.group(1), line, cites(cells[col])))
        return rows
    ans = table(os.path.join(REPO, "kala", "ANSWERS.md"), r"\|\s*((?:Kv|Paṭṭh|Yam|Dhk|Pp|Dhs|Vibh)[^|]*?)\s*\|", 2)
    axs = table(os.path.join(REPO, "kala", "AXIOMS.md"), r"\|\s*(A\d+[b′]?|A0′?|C|K)\s*\|", 3)
    bad = []
    for k, _, ac in ans:
        for i, line, xc in axs:
            if "HELD OUT" in line: continue
            for f in ac.keys() & xc.keys():
                if ac[f] & xc[f]: bad.append(f"ANSWERS {k} and AXIOMS {i} both cite {f}:{min(ac[f] & xc[f])}")
    return bad

def ids(names):
    out = []
    for n in names:
        m = AXIOM_BINDER.match(n)
        out.append(f"**{m.group(1).upper().replace('′', '′')}** `{n}`" if m else f"`{n}`")
    return ", ".join(out) or "—"

def logic(axioms):
    if "sorryAx" in axioms: return "⛔ SORRY"
    return "classical" if "Classical.choice" in axioms else "constructive"

def build(results):
    table = lean_map()
    held = held_out()
    premises = []      # (theorem, held-out ID it reaches) — CI fails on any
    rows, n_cls, n_sorry, n_unused, n_byc, n_model = [], 0, 0, 0, 0, 0
    for rel, items in results:
        for t in items:
            short = t["name"].split(".")[-1]
            doc = t.get("doc", "")
            flags = []
            if "BY CONSTRUCTION" in doc: flags.append("⚠️ BY CONSTRUCTION"); n_byc += 1
            if short.endswith("_model") or re.match(r"\s*(Non-vacuity|The model|A model|MODEL)", doc): flags.append("model"); n_model += 1
            lg = logic(t["axioms"])
            n_cls += lg == "classical"; n_sorry += lg.startswith("⛔")
            n_unused += bool(t["unused"])
            link = f"[`{rel}:{t['line']}`](../{rel}#L{t['line']})"
            reached = axiom_ids(t.get("defs", []), table)
            binder_ids = [m.group(1).upper() for n in t["used"] if (m := AXIOM_BINDER.match(n))]
            premises += [(short, i) for i in sorted(set(reached + binder_ids) & held)]
            ax = " ".join(f"**{i}**" for i in reached)
            uses = " · ".join(x for x in (ax, ids(t["used"]) if t["used"] else "") if x) or "—"
            rows.append(f"| `{short}` | {link} | {first_sentence(doc) or '—'} | {uses} | "
                        f"{('⚠️ ' + ids(t['unused'])) if t['unused'] else '—'} | {lg} | {' · '.join(flags) or '—'} |")
    files = len(results)
    head = [
        "# THEOREMS — every machine-checked theorem in this repo",
        "",
        "*GENERATED by `scripts/theorems-index.py` from the Lean sources — never edit by hand; CI fails if it is stale, if a",
        "file does not compile, or if any proof uses `sorry`.*",
        "",
        "Three files, three roles: [`AXIOMS.md`](AXIOMS.md) is what the texts ASSERT · **this file is what we DERIVE** ·",
        "[`ANSWERS.md`](ANSWERS.md) is what the texts themselves DERIVE — the test bank a derivation is checked against.",
        "",
        f"**{len(rows)} theorems in {files} files** · {len(rows) - n_cls - n_sorry} constructive · {n_cls} classical · "
        f"{n_sorry} sorry · {n_unused} with an UNUSED hypothesis · {n_byc} BY CONSTRUCTION · {n_model} models.",
        "",
        "How to read a row. Every cell is READ from Lean by `tools/Uses.lean`, never written by the proof's author:",
        "- **Uses** — the axiom IDs whose Lean encoding (the `Lean` column of `AXIOMS.md`: a definition or a structure field)",
        "  the theorem reaches through its statement, its proof and every lemma of ours it calls; then the hypotheses (every",
        "  premise of the statement, up to its conclusion) the elaborated proof term contains. A hypothesis named with an axiom ID (`a112_link`, the",
        "  `/prove` convention) is shown with that ID; older runs name hypotheses for their role, and their IDs are in the",
        "  docstring and the run's `RUN.md`.",
        "- ⚠️ **Countermodels:** premises written INSIDE an `∃` are not binders. Written as DEFINITIONS named by their axiom ID",
        "  (`def a87_purejata (w) : Prop`, the convention since A388 OQ5, 2026-10-13) they are reached and shown; written",
        "  inline (the first /prove run's T2 and T3) they are invisible — read the statement.",
        "- **Unused** — hypotheses the proof never touches. ⭐ A finding about the derivation, not a tidiness warning: the",
        "  conclusion follows from less than was assumed.",
        "- **Logic** — *classical* if the proof rests on `Classical.choice` (excluded middle); *constructive* otherwise.",
        "- **⚠️ BY CONSTRUCTION** — the TYPE does the work: the theorem records a modeling choice, not a derivation.",
        "- **model** — a non-vacuity witness (the hypotheses can all hold), not a claim about the texts.",
        "",
        "Lean proves that a conclusion follows from these definitions — never that the definitions are faithful to the",
        "texts, and never that nature agrees.",
        "",
        "| Theorem | Where | What it states (its docstring, first sentence) | Uses | Unused | Logic | Flags |",
        "|---|---|---|---|---|---|---|",
    ]
    return "\n".join(head + rows) + "\n", n_sorry, premises

def main():
    lean = lean_bin()
    tmp = tempfile.mkdtemp(prefix="theorems-")
    try:
        results, errors = collect(tmp, lean)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if errors:
        for e in errors: print("✗", e, file=sys.stderr)
        sys.exit(1)
    text, n_sorry, premises = build(results)
    # The hold-out as a PROPERTY (founder 2026-10-13): no theorem may reach a HELD OUT axiom, and no live axiom may cite
    # the lines an answer cites. Both are read from the files, never from anyone's promise.
    leaks = [f"{t} reaches {i}, which is HELD OUT (kala/ANSWERS.md)" for t, i in premises] + citation_overlaps()
    if leaks:
        for x in leaks: print("✗", x, file=sys.stderr)
        sys.exit(1)
    if "--check" in sys.argv:
        cur = open(OUT, encoding="utf-8").read() if os.path.exists(OUT) else ""
        if n_sorry: print(f"✗ {n_sorry} theorem(s) rest on sorry"); sys.exit(1)
        if cur != text: print("kala/THEOREMS.md is STALE — run scripts/theorems-index.py and commit"); sys.exit(1)
        print("kala/THEOREMS.md is current"); return
    open(OUT, "w", encoding="utf-8").write(text)
    print(text.split("\n")[8])

if __name__ == "__main__":
    main()
