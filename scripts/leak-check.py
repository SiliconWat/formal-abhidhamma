#!/usr/bin/env python3
"""leak-check.py — does a proof run's premise SET restate a held-out answer? (founder 2026-10-13, A388 OQ3: "approve all")

  scripts/leak-check.py [runs/<dir> …]      default: every run whose Lean file declares a `def answer_…`

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

def check_run(d, lean):
    out = []
    pre = open(os.path.join(d, "PREREG.md"), encoding="utf-8").read() if os.path.exists(os.path.join(d, "PREREG.md")) else ""
    known = (re.search(r"KNOWN ANSWER: ([^)]+)\)", pre.split("\n", 1)[0]) or [None, None])[1]
    run_md = open(os.path.join(d, "RUN.md"), encoding="utf-8").read() if os.path.exists(os.path.join(d, "RUN.md")) else ""
    for f in sorted(glob.glob(os.path.join(d, "*.lean"))):
        src = open(f, encoding="utf-8").read()
        def binders(name):
            """the binder NAMES of `def <name> (k : Int) (w : World) : Prop` → ["k", "w"]"""
            m = re.search(rf"(?m)^def {name}((?:\s*\([^)]*\))*)\s*:\s*Prop", src)
            return [n for g in re.findall(r"\(([^):]*):", m.group(1)) for n in g.split()] if m else None
        prem = re.findall(r"(?m)^def (premises_\w+)", src)
        ans = re.findall(r"/--\s*ANSWER:\s*([^\n—-]+?)\s*(?:—[^\n]*)?-/\s*\ndef (answer_\w+)", src)
        if not ans: continue
        if not prem:
            out.append(("ERROR", f"{os.path.relpath(f, REPO)} declares answers but no `def premises_<thm>`")); continue
        defs = re.findall(r"(?m)^def (\w+)", src)
        end = list(re.finditer(r"(?m)^end (\S+)\s*$", src))
        for p in prem:
            for key, a in ans:
                key = key.strip()
                bp, ba = binders(p), binders(a)
                if not bp or bp != ba:
                    out.append(("ERROR", f"{p} {bp} and {a} {ba} must take the same binders")); continue
                vs = " ".join(bp)
                # REVERSE definition order, so a composite (premises_…, answer_…) opens before the parts it is built
                # from — in file order the parts were "unfolded" before they appeared and grind saw opaque names
                unfold = "; ".join(f"(try unfold {x} at *)" for x in reversed(defs))   # `;`, never a space: a space-joined
                # sequence stops parsing after the first step and every pair reads "no" (caught by the planted test)
                ex = (f"\nset_option maxHeartbeats {HEARTBEATS} in\n"
                      f"example : ∀ {vs}, {p} {vs} → {a} {vs} := by\n  intro {vs} h; {unfold}; grind\n")
                body = src[:end[-1].start()] + ex + src[end[-1].start():] if end else src + ex
                tmp = tempfile.mkdtemp(prefix="leak-")
                try:
                    open(os.path.join(tmp, "L.lean"), "w", encoding="utf-8").write(body)
                    r = subprocess.run([lean, "L.lean"], cwd=tmp, capture_output=True, text=True, timeout=600)
                finally:
                    shutil.rmtree(tmp, ignore_errors=True)
                hit = r.returncode == 0
                if not hit:
                    errs = [l for l in (r.stdout + r.stderr).splitlines() if ": error" in l]
                    if errs and all("`grind` failed" in l for l in errs): out.append(("no", f"{p} ↛ {a}"))
                    else: out.append(("ERROR", f"{p} → {a}: Lean failed for another reason — {errs[:1] or r.stderr[:200]}"))
                    continue
                if known and key.startswith(known.strip()):
                    out.append(("TRIVIAL", f"{p} → {a} ({key}): the run's own known answer, within one `grind` step"))
                elif f"LEAK ACKNOWLEDGED: {p} → {a}" in run_md:
                    out.append(("LEAK (acknowledged)", f"{p} → {a} ({key})"))
                else:
                    out.append(("LEAK", f"{p} → {a} ({key}): the premises restate a held-out answer"))
    return out

def main():
    lean = lean_bin()
    dirs = [os.path.abspath(x) for x in sys.argv[1:]] or sorted(
        os.path.dirname(f) for f in glob.glob(os.path.join(REPO, "runs", "2*", "*.lean"))
        if re.search(r"(?m)^def answer_", open(f, encoding="utf-8").read()))
    dirs = sorted(set(dirs))
    bad = 0
    for d in dirs:
        for verdict, msg in check_run(d, lean):
            print(f"{verdict:<20} {os.path.basename(d)}: {msg}")
            bad += verdict in ("LEAK", "ERROR")
    if not dirs: print("leak-check: no run declares a held-out answer in Lean")
    sys.exit(1 if bad else 0)

if __name__ == "__main__":
    main()
