#!/usr/bin/env python3
"""leak-check.py — does a proof run's premise SET restate a held-out answer? (founder 2026-10-13, A388 OQ3: "approve all")

  scripts/leak-check.py [runs/<dir> …]      default: every run whose Lean file declares a `def answer_…`

⭐ A389 OQ-C (founder 2026-10-13, "approve A389"): items 5 and 7 bind PER CONJUNCT and PER INSTANCE. So the check now runs
PER THEOREM: each theorem's own premise binders, at the instance it states, against every held-out answer whose parameters
it binds — the second run's T2 used `k = 2` while the closure `∀ k` was false at `k = 3`, and the check never asked about
the instance the theorem used. A run registered under A389 (its PREREG says "Conventions: A389") must state one claim per
theorem with each premise its own binder: a premise bundle as a hypothesis, or a ∀-claim with no premise binders, is an ERROR.

Rubric item 7 bars a held-out answer as a premise. The first proof run showed that a guard on NAMES cannot see a premise
SET that jointly states an answer (its refuter, F3: A87 + A98 on a mind-moment clock already said what the held-out A69
says). So, for every premise set `def premises_<thm> (w) : Prop` and every held-out answer `def answer_<key> (w) : Prop`
in a run's Lean file, this asks Lean whether `∀ w, premises_<thm> w → answer_<key> w` falls to ONE bounded automated step
(`grind`, after unfolding the file's own definitions):

  - no      → the answer is not restated by that premise set (at this depth);
  - TRIVIAL → yes, and the answer is the run's OWN known answer (a known-answer control): the reproduction is within one
              automated step of its premises — reported, and the run cannot be STRONG;
  - LEAK    → yes, and it is ANOTHER held-out answer: the premises restate a text's conclusion. Exit 1, unless RUN.md
              carries the line `LEAK ACKNOWLEDGED: premises_<thm> → answer_<key>` (which also forbids STRONG).

⚠️ The threshold is DECLARED, not discovered: "one `grind` call within the heartbeat budget" stands in for "the premises
already say it". A deeper restatement passes unseen. Each answer's docstring must start `ANSWER: <the ANSWERS.md key>`.
Instrument control (2026-10-13): it HITS on the first run's T1 premises → ¬OneMoment, and `grind` FAILS on the
non-entailment premises → OneMoment.
"""
import glob, os, re, subprocess, sys, tempfile, shutil

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HEARTBEATS = 400000

def lean_bin():
    if os.environ.get("LEAN"): return os.environ["LEAN"]
    try:
        return subprocess.run(["elan", "which", "lean"], cwd=REPO, capture_output=True, text=True, check=True).stdout.strip()
    except Exception:
        return "lean"

def signatures(src):
    """Every `theorem NAME <binders> : <conclusion> := …` → (name, [binder texts], [binder names], conclusion)."""
    out = []
    for m in re.finditer(r"(?m)^theorem (\w+)", src):
        i, groups = m.end(), []
        while True:
            while i < len(src) and src[i] in " \n": i += 1
            if i >= len(src) or src[i] not in "({[": break
            close, depth, j = {"(": ")", "{": "}", "[": "]"}[src[i]], 0, i
            while j < len(src):
                if src[j] in "({[": depth += 1
                elif src[j] in ")}]": depth -= 1
                j += 1
                if depth == 0: break
            groups.append(src[i:j]); i = j
        if i >= len(src) or src[i] != ":": continue
        k = src.find(":=", i)
        concl = src[i + 1:k].strip()
        names = [n for g in groups for n in g[1:].split(":", 1)[0].split()]
        out.append((m.group(1), groups, names, concl))
    return out

def check_run(d, lean):
    out = []
    pre = open(os.path.join(d, "PREREG.md"), encoding="utf-8").read() if os.path.exists(os.path.join(d, "PREREG.md")) else ""
    known = (re.search(r"KNOWN ANSWER: ([^)]+)\)", pre.split("\n", 1)[0]) or [None, None])[1]
    run_md = open(os.path.join(d, "RUN.md"), encoding="utf-8").read() if os.path.exists(os.path.join(d, "RUN.md")) else ""
    a389 = "Conventions: A389" in pre          # one claim per theorem; one binder per premise (founder 2026-10-13)
    for f in sorted(glob.glob(os.path.join(d, "*.lean"))):
        src = open(f, encoding="utf-8").read()
        def binders(name):
            """the binder NAMES of `def <name> (k : Int) (w : World) : Prop` → ["k", "w"]"""
            m = re.search(rf"(?m)^def {name}((?:\s*\([^)]*\))*)\s*:\s*Prop", src)
            return [n for g in re.findall(r"\(([^):]*):", m.group(1)) for n in g.split()] if m else None
        prem = re.findall(r"(?m)^def (premises_\w+)", src)
        # the docstring may run over several lines (`(?:—[\s\S]*?)?`): a one-line pattern saw NO answer in the second
        # proof run and the check exited 0 having checked nothing (caught 2026-10-13, before the run was graded)
        ans = re.findall(r"/--\s*ANSWER:\s*([^\n—-]+?)\s*(?:—[\s\S]*?)?-/\s*\ndef (answer_\w+)", src)
        # A393 (founder 2026-10-13): a row that already STATES the thesis is tested like an answer; reaching it is STATED
        sts = re.findall(r"/--\s*STATES:\s*([^\n—-]+?)\s*(?:—[\s\S]*?)?-/\s*\ndef (states_\w+)", src)
        # A395: a row that already states the thesis's NEGATION; reaching it makes a REFUTED outcome a check
        ngs = re.findall(r"/--\s*NEGATES:\s*([^\n—-]+?)\s*(?:—[\s\S]*?)?-/\s*\ndef (negates_\w+)", src)
        if not ans and not sts and not ngs:
            # a post-A388 proof run (its PREREG declares type freedoms) MUST state its held-out answers in Lean — unless its
            # REGISTERED PREREG (A393's structured fields, never free text) names no held-out answer AND says nothing
            # states the thesis
            sec = lambda h: pre.split(h, 1)[1].split("\n## ", 1)[0] if h in pre else ""
            if ("## Type freedoms" in pre and "- (none)" in sec("## Held out") and
                    re.search(r"(?m)^- none$", sec("## States the thesis"))):
                out.append(("NONE NEAR", f"{os.path.relpath(f, REPO)}: registered — no held-out answer near, nothing states the thesis (A393)"))
            elif "## Type freedoms" in pre:
                out.append(("ERROR", f"{os.path.relpath(f, REPO)}: a proof run under A388 declares no `def answer_…` or `def states_…`"))
            continue
        defs = re.findall(r"(?m)^def (\w+)", src)
        end = list(re.finditer(r"(?m)^end (\S+)\s*$", src))
        # REVERSE definition order, so a composite (premises_…, answer_…) opens before the parts it is built from — in file
        # order the parts were "unfolded" before they appeared and grind saw opaque names. `;`, never a space: a space-joined
        # sequence stops parsing after the first step and every pair reads "no" (both caught by the planted test)
        unfold = "; ".join(f"(try unfold {x} at *)" for x in reversed(defs))

        def trial(label, example, key, ack, stated=False, negated=False):
            body = src[:end[-1].start()] + example + src[end[-1].start():] if end else src + example
            tmp = tempfile.mkdtemp(prefix="leak-")
            try:
                open(os.path.join(tmp, "L.lean"), "w", encoding="utf-8").write(body)
                r = subprocess.run([lean, "L.lean"], cwd=tmp, capture_output=True, text=True, timeout=600)
            finally:
                shutil.rmtree(tmp, ignore_errors=True)
            if r.returncode != 0:
                errs = [l for l in (r.stdout + r.stderr).splitlines() if ": error" in l]
                if errs and all("`grind` failed" in l for l in errs): return ("no", label.replace("→", "↛", 1))
                return ("ERROR", f"{label}: Lean failed for another reason — {errs[:1] or r.stderr[:200]}")
            if negated:
                return ("STATED NEGATION", f"{label} ({key}): the premises reach a row that already states the thesis's negation — a REFUTED here is a check")
            if stated:
                return ("STATED", f"{label} ({key}): the premises reach a row that already states the thesis — a check, not a finding")
            if known and key.startswith(known.strip()):
                return ("TRIVIAL", f"{label} ({key}): the run's own known answer, within one `grind` step")
            if f"LEAK ACKNOWLEDGED: {ack}" in run_md:
                return ("LEAK (acknowledged)", f"{label} ({key})")
            return ("LEAK", f"{label} ({key}): the premises restate a held-out answer")

        # (1) PER THEOREM, at its own instance (A389 OQ-C): the theorem's own premise binders → each held-out answer whose
        #     parameters it binds. This is the instance the theorem USES, never the universal closure.
        for name, groups, names, concl in signatures(src):
            if a389 and any(re.search(r":\s*premises_\w+", g) for g in groups):
                out.append(("ERROR", f"{name}: a premise BUNDLE as a hypothesis — under A389 each premise is its own binder")); continue
            if not groups:
                if a389 and "∀" in concl and "∃" not in concl.split("∀", 1)[0]:
                    out.append(("ERROR", f"{name}: a ∀-claim with no premise binders — under A389 one claim per theorem, its premises as binders"))
                continue
            for key, a, st, ng in ([(k, x, False, False) for k, x in ans] + [(k, x, True, False) for k, x in sts]
                                   + [(k, x, False, True) for k, x in ngs]):
                ba = binders(a)
                if not ba or not set(ba) <= set(names): continue
                vs = " ".join(ba)
                ex = (f"\nset_option maxHeartbeats {HEARTBEATS} in\n"
                      f"example {' '.join(groups)} : {a} {vs} := by\n  {unfold}; grind\n")
                out.append(trial(f"{name} (its premises) → {a}", ex, key.strip(), f"{name} → {a}", st, ng))

        # (2) the A388 premise SETS (`def premises_<thm>`), kept so the runs registered before A389 still check
        for p in prem:
            for key, a in ans:
                bp, ba = binders(p), binders(a)
                if not bp or bp != ba:
                    out.append(("ERROR", f"{p} {bp} and {a} {ba} must take the same binders")); continue
                vs = " ".join(bp)
                ex = (f"\nset_option maxHeartbeats {HEARTBEATS} in\n"
                      f"example : ∀ {vs}, {p} {vs} → {a} {vs} := by\n  intro {vs} h; {unfold}; grind\n")
                out.append(trial(f"{p} → {a}", ex, key.strip(), f"{p} → {a}"))
    return out

def main():
    lean = lean_bin()
    dirs = [os.path.abspath(x) for x in sys.argv[1:]] or sorted(
        os.path.dirname(f) for f in glob.glob(os.path.join(REPO, "runs", "2*", "*.lean"))
        if re.search(r"(?m)^def answer_", open(f, encoding="utf-8").read())
        or "## Type freedoms" in (open(os.path.join(os.path.dirname(f), "PREREG.md"), encoding="utf-8").read()
                                  if os.path.exists(os.path.join(os.path.dirname(f), "PREREG.md")) else ""))
    dirs = sorted(set(dirs))
    bad = 0
    for d in dirs:
        results = check_run(d, lean)
        if not results:   # a run selected for checking that yields no pair has checked nothing — never silent
            results = [("ERROR", "no premise/answer pair was checked")]
        for verdict, msg in results:
            print(f"{verdict:<20} {os.path.basename(d)}: {msg}")
            bad += verdict in ("LEAK", "ERROR")
    if not dirs: print("leak-check: no run declares a held-out answer in Lean")
    sys.exit(1 if bad else 0)

if __name__ == "__main__":
    main()
