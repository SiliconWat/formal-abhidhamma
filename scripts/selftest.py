#!/usr/bin/env python3
"""selftest.py — the instrument's REFUSAL and DETECTION side, as a property (A399 OQ-3, founder 2026-10-13: "approve").

Every check that is supposed to REFUSE a registration or DETECT a defect is planted here once, and must be seen to fire;
one case that must be ACCEPTED keeps the plants honest (a tool that refuses everything would pass the rest). Until this
script, these paths had been tested only by build-time plants that were never registered (the post-A395 control's run
refuter, 2026-10-13). CI runs it on every push (`.github/workflows/lean.yml`).

  scripts/selftest.py            exit 0 only if every planted case fires as expected
  LEAN=<path to lean> is used for the cases that compile (leak check, anchored harness, BLIND break)
"""
import importlib.util, os, re, shutil, subprocess, sys, tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LEAN = os.environ.get("LEAN", "lean")
RESULTS = []

def case(name, ok, detail=""):
    RESULTS.append((name, ok))
    print(f"{'FIRES  ' if ok else 'SILENT '} {name}" + (f" — {detail}" if detail and not ok else ""))

def run(args, cwd=REPO, env=None):
    r = subprocess.run(args, cwd=cwd, capture_output=True, text=True, env={**os.environ, **(env or {})}, timeout=900)
    return r.returncode, (r.stdout + r.stderr)

# ── 1. prereg.py: every refusal fires; a valid control is accepted ────────────────────────────────────────────────
tmp = tempfile.mkdtemp(prefix="selftest-")
stmt = os.path.join(tmp, "Statement.lean")
open(stmt, "w").write("theorem planted : True := by\n  sorry\n")
BASE = [sys.executable, os.path.join(REPO, "runs", "prereg.py"), "selftest-planted", "--proof", "--dry-run",
        "--approved-by", "selftest", "--lean", stmt, "--axioms", "C,A3", "--type-freedom", "f", "--predict", "p"]
KEY = "Vajirabuddhi first citta"
# every flag a valid registration needs, so each plant is refused for ITS reason and not an earlier one (the first run of
# this script found six plants refused for a missing --predict-outcome and correctly called them SILENT)
GOOD = ["--thesis", "every citta has an earlier one", "--held-out", KEY, "--states-thesis", "none",
        "--states-negation", "none", "--thesis-vs-answer", f"{KEY}: does not entail — planted", "--predict-outcome", "INDEPENDENT"]
def prereg(extra, thesis=None):
    args = BASE + (["--thesis", thesis] if thesis else [])
    return run(args + extra)

def refused(name, extra, needle, thesis=None):
    code, out = prereg(extra, thesis)
    case(f"prereg refuses: {name}", code != 0 and needle in out, out.strip().splitlines()[-1] if out.strip() else "")

def g(**over):
    """GOOD with some flags replaced or removed (value None)"""
    pairs, i, out = {}, 0, []
    while i < len(GOOD): pairs[GOOD[i]] = GOOD[i + 1]; i += 2
    for k, v in over.items():
        flag = "--" + k.replace("_", "-")
        if v is None: pairs.pop(flag, None)
        else: pairs[flag] = v
    for k, v in pairs.items(): out += [k, v]
    return out

refused("a loose held-out entry", g(held_out="A2 · A77 (they state it)"), "--held-out takes ANSWERS keys")
refused("silence on held-out answers and on what states the thesis", g(held_out=None, states_thesis=None), "name the held-out answers")
refused("silence on what states the negation", g(states_negation=None), "states the thesis's NEGATION")
refused("a premise named as stating the thesis", g(states_thesis="C"), "--states-thesis takes live AXIOMS rows")
refused("a premise named as stating the negation", g(states_negation="A3"), "--states-negation takes live AXIOMS rows")
refused("a held-out answer with no thesis-vs-answer verdict", g(thesis_vs_answer=None), "--thesis-vs-answer owed")
refused("PROVED predicted of a thesis that entails a held-out answer",
        g(thesis_vs_answer=f"{KEY}: entails — planted", predict_outcome="PROVED"), "PROVED is unreachable")
refused("a control flag naming no held-out ANSWERS key",
        g(predict_outcome="PROVED") + ["--control-known", "No Such Key"], "--control-known")
refused("a HELD OUT row as a premise", ["--thesis", "x", "--held-out", KEY, "--states-thesis", "none", "--states-negation",
        "none", "--thesis-vs-answer", f"{KEY}: does not entail — x", "--predict-outcome", "INDEPENDENT"]
        + ["--axioms", "A59"], "is HELD OUT")
refused("an undeclared question (the world eternal)", g(thesis=None),
        "undeclared question", thesis="the world is eternal")
refused("AN 10.95's form of the undeclared question", g(thesis=None),
        "undeclared question", thesis="every being will eventually awaken")
# the Silicon Simile is a reading aid, never an input (founder 2026-10-14): refused in the thesis, the Lean statement and an
# /abhidhamma question; scripts/simile_guard.py refuses a blind back-translation copy, and passes a clean one
refused("the Silicon Simile's vocabulary in a thesis", g(thesis=None), "reading aid, never an input",
        thesis="perception is the compiler of every citta")
simile_stmt = os.path.join(tmp, "SimileStatement.lean")
open(simile_stmt, "w").write("-- the decompiler reads the source\ntheorem planted : True := by\n  sorry\n")
refused("the Silicon Simile's vocabulary in the Lean statement", g() + ["--lean", simile_stmt], "reading aid, never an input")
code, out = run([sys.executable, os.path.join(REPO, "runs", "prereg.py"), "selftest-planted-q", "--dry-run", "--question",
                 "is physics the pseudo-code of matter?", "--window", "A0", "--axioms", "C,A3", "--predict", "p"])
case("prereg refuses: the Silicon Simile's vocabulary in an /abhidhamma question", code != 0 and "reading aid, never an input" in out,
     out.strip().splitlines()[-1] if out.strip() else "")
guard = os.path.join(REPO, "scripts", "simile_guard.py")
blind_dirty, blind_clean = os.path.join(tmp, "BlindDirty.lean"), os.path.join(tmp, "BlindClean.lean")
open(blind_dirty, "w").write("def upstream_moment : Nat := 0\n"); open(blind_clean, "w").write("theorem planted : True := trivial\n")
code, out = run([sys.executable, guard, blind_dirty])
case("simile_guard refuses a blind copy that carries the vocabulary", code == 1 and "REFUSED" in out, out.strip()[-200:])
code, out = run([sys.executable, guard, blind_clean])
case("simile_guard passes a clean blind copy (the guard is not refusing everything)", code == 0, out.strip()[-200:])
code, out = prereg(g(thesis_vs_answer=f"{KEY}: entails — the thesis is the answer", predict_outcome="PROVED") + ["--control-known", KEY])
case("prereg ACCEPTS a valid known-answer control (the plants are not refusing everything)", code == 0 and "PRE-REGISTRATION" in out,
     out.strip().splitlines()[-1] if out.strip() else "")

# ── 2. leak-check.py: LEAK, STATED NEGATION, NONE NEAR, ERROR ─────────────────────────────────────────────────────
PRE = ("# PRE-REGISTRATION — selftest (PROOF)\n\n## Type freedoms — planted\n\n- f\n\n## Held out — planted\n\n{held}\n\n"
       "## States the thesis — planted\n\n{states}\n\n## Predicted outcome\n\n- p\n")
LEANHEAD = ("namespace SelfTest\nstructure World where\n  p : Prop\n  q : Prop\n\n"
            "def a1_premise (w : World) : Prop := w.p ∧ w.q\n\n")
def fixture(name, held, states, defs, theorem=True):
    d = os.path.join(tmp, "runs", name); os.makedirs(d)
    open(os.path.join(d, "PREREG.md"), "w").write(PRE.format(held=held, states=states))
    body = LEANHEAD + defs + ("theorem t_planted (w : World) (h1 : a1_premise w) : w.q := h1.2\n\n" if theorem else "") + "end SelfTest\n"
    open(os.path.join(d, "Planted.lean"), "w").write(body)
    return d
def leak(d): return run([sys.executable, os.path.join(REPO, "scripts", "leak-check.py"), d], env={"LEAN": LEAN})

d = fixture("leak", "- planted key", "- none", "/-- ANSWER: planted key — the premises restate it. -/\ndef answer_planted (w : World) : Prop := w.p\n\n")
code, out = leak(d); case("leak-check detects a LEAK (and fails)", code == 1 and re.search(r"(?m)^LEAK\b", out) is not None, out[-200:])
d = fixture("negation", "- (none)", "- none", "/-- NEGATES: A1 — planted. -/\ndef negates_a1 (w : World) : Prop := w.q\n\n")
code, out = leak(d); case("leak-check reports STATED NEGATION (and passes)", code == 0 and "STATED NEGATION" in out, out[-200:])
d = fixture("nonenear", "- (none)", "- none", "", theorem=False)
code, out = leak(d); case("leak-check reports NONE NEAR from the registered fields", code == 0 and "NONE NEAR" in out, out[-200:])
d = fixture("silent", "- planted key", "- A77", "", theorem=False)
code, out = leak(d); case("leak-check ERRORs on a run that declares no answer", code == 1 and "ERROR" in out, out[-200:])

# ── 3. the anchored verbatim check, and a BLIND break (a copy of a registered run) ─────────────────────────────────
src = os.path.join(REPO, "runs", "2026-10-13-first-thesis-past-lives-and-hell")
if os.path.isdir(src):
    d = os.path.join(tmp, "anchored"); shutil.copytree(src, d)
    p = os.path.join(d, "Samsara.lean"); s = open(p, encoding="utf-8").read()
    s = s.replace("  now : Int\n", "  now : Int\n  planted : True\n", 1); open(p, "w", encoding="utf-8").write(s)
    code, out = run(["sh", os.path.join(d, "run.sh")], cwd=d, env={"LEAN": LEAN})
    case("the anchored harness catches a field appended to a registered structure", code == 1 and "STATEMENT MOVED" in out, out[-200:])
    d = os.path.join(tmp, "blind"); shutil.copytree(src, d)
    rs = os.path.join(d, "run.sh"); s = open(rs, encoding="utf-8").read()
    s = s.replace('echo "all breaks fail as required"',
                  "try $T3 \"PLANTED: A109 dropped (T3 does not use it)\" 's/^def a109_path_is_citta (w : World) : Prop := .*/def a109_path_is_citta (w : World) : Prop := True/'\n"
                  'echo "all breaks fail as required"', 1)
    open(rs, "w", encoding="utf-8").write(s)
    code, out = run(["sh", rs], cwd=d, env={"LEAN": LEAN})
    case("the isolated harness reports a break on an UNUSED premise as BLIND", code == 1 and "BLIND" in out, out[-200:])
else:
    case("the anchored harness and BLIND break (source run missing)", False, src)

# ── 4. the drift guard: one axiom definition with two bodies ───────────────────────────────────────────────────────
root = os.path.join(tmp, "repo")
for sub in ("scripts", "kala", "runs"): shutil.copytree(os.path.join(REPO, sub), os.path.join(root, sub))
f = os.path.join(root, "runs", "2026-10-13-first-thesis-past-lives-and-hell", "Samsara.lean")
s = open(f, encoding="utf-8").read()
s = s.replace("def a3_successor (w : World) : Prop := ∀ p q, w.prox p q → p < q",
              "def a3_successor (w : World) : Prop := ∀ p q, w.prox p q → p ≤ q", 1)
open(f, "w", encoding="utf-8").write(s)
spec = importlib.util.spec_from_file_location("ti_selftest", os.path.join(root, "scripts", "theorems-index.py"))
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
drift = m.axiom_def_drift()
case("the drift guard catches one axiom definition with two bodies", any("a3_successor" in x for x in drift), str(drift)[:200])

shutil.rmtree(tmp, ignore_errors=True)
bad = [n for n, ok in RESULTS if not ok]
print(f"\n{len(RESULTS) - len(bad)} of {len(RESULTS)} planted cases fire as expected" + (f" — SILENT: {', '.join(bad)}" if bad else ""))
sys.exit(1 if bad else 0)
