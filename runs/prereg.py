#!/usr/bin/env python3
"""prereg.py — pre-register one Abhidhamma-mode run BEFORE the agent sees the question.

Writes runs/<date>-<slug>/PREREG.md (question, window, the axiom rows copied verbatim from
kala/AXIOMS.md, predictions, pass criteria, instrument commit), commits, pushes, and reads GitHub's
record of the push — the push time, not the commit date, is the timestamp nobody can backdate.

  runs/prereg.py <slug> --question "…" --window A0|A0′|both --axioms A1,A3,C
                 [--predict "…"]… [--pass "…"]… [--allow-recalled] [--control] [--dry-run]

A PROOF run (/prove, founder 2026-10-13; rubric runs/PROVE-RUBRIC.md, cited by commit):

  runs/prereg.py <slug> --proof --thesis "…" --approved-by "…" --lean <file with the exact Lean statement>
                 --axioms A3,A41 --held-out "<ANSWERS key>,<HELD OUT ID>" --predict-outcome PROVED
                 [--founder-predicts PROVED|REFUTED|INDEPENDENT|NOT-FORMALIZABLE] [--control-known "<ANSWERS key>"]
                 [--window none|A0|A0′|both] --type-freedom "…" [--type-freedom "…"]… --predict "…" [--pass "…"]… [--dry-run]

Refuses: a run directory that already exists (a pre-registration is never edited; a correction is a
new run) · an axiom ID not in AXIOMS.md · a RECALLED axiom without --allow-recalled · no prediction ·
(proof) a premise marked HELD OUT, or one also listed as held out · a thesis that turns on an undeclared
question (avyākata) unless --avyakata-reviewed says why it does not · a Lean statement that is empty or
already proved (`sorry` is required: the statement is registered, the proof comes after).
"""
import argparse, datetime, json, os, re, subprocess, sys, time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AXIOMS = os.path.join(REPO, "kala", "AXIOMS.md")

def sh(*a, check=True):
    return subprocess.run(a, cwd=REPO, check=check, capture_output=True, text=True).stdout.strip()

def rows():
    out = {}
    for line in open(AXIOMS, encoding="utf-8"):
        m = re.match(r"\|\s*(A\d+[b′]?|A0′?|C|K)\s*\|", line)
        if m: out[m.group(1)] = line.rstrip("\n")
    return out

def main():
    p = argparse.ArgumentParser()
    p.add_argument("slug"); p.add_argument("--question")
    p.add_argument("--window", choices=["A0", "A0′", "both", "none"])
    p.add_argument("--axioms", required=True)
    p.add_argument("--predict", action="append", default=[]); p.add_argument("--pass", dest="passc", action="append", default=[])
    p.add_argument("--allow-recalled", action="store_true"); p.add_argument("--control", action="store_true")
    # A control the texts should WIN (founder 2026-09-30): without it every control is one-sided, and an instrument
    # biased AGAINST the texts would pass them all (the "Letting the Texts Lose" refuter, finding 1).
    p.add_argument("--control-agree", action="store_true")
    p.add_argument("--dry-run", action="store_true")
    # ── a PROOF run (/prove) ──
    p.add_argument("--proof", action="store_true")
    p.add_argument("--thesis"); p.add_argument("--approved-by"); p.add_argument("--lean")
    p.add_argument("--held-out", default="")
    OUTCOMES = ["PROVED", "REFUTED", "INDEPENDENT", "NOT-FORMALIZABLE"]
    p.add_argument("--predict-outcome", choices=OUTCOMES); p.add_argument("--founder-predicts", choices=OUTCOMES)
    p.add_argument("--control-known", help="an ANSWERS.md key the run must reproduce (a known-answer control)")
    p.add_argument("--avyakata-reviewed", help="why a thesis that mentions an undeclared question does not turn on one")
    # A388 OQ4 (founder 2026-10-13): what the TYPE leaves free (no citta stream, presence not tied to birth …) is declared
    # BEFORE the attempt — a result that depends on what the type cannot express is BY CONSTRUCTION too
    p.add_argument("--type-freedom", action="append", default=[])
    a = p.parse_args()
    if a.proof:
        need = [f for f in ("thesis", "approved_by", "lean", "predict_outcome", "type_freedom") if not getattr(a, f)]
        if need: sys.exit(f"refused: a proof run needs --{', --'.join(n.replace('_', '-') for n in need)}")
        a.window = a.window or "none"
        a.question = a.thesis
        # The undeclared questions (avyākata): the texts set them aside, and classical logic would "settle" one by
        # excluded middle. Refused at intake (runs/PROVE-RUBRIC.md); a mention that is not a dependence must say why.
        AVY = r"tath[aā]gat\w*.{0,40}(after death|param mara)|world.{0,20}(eternal|finite|infinite)|(soul|jīva|jiva|life-principle).{0,30}body|sassato loko|antavā loko|taṃ jīvaṃ"
        if re.search(AVY, a.thesis, re.I) and not a.avyakata_reviewed:
            sys.exit("refused: the thesis touches an undeclared question (avyākata) — the rubric refuses it at intake; "
                     "if it does not TURN on one, pass --avyakata-reviewed \"<why>\"")
    elif not a.question or not a.window:
        sys.exit("refused: --question and --window are required (or --proof with --thesis)")
    if not re.fullmatch(r"[a-z0-9-]+", a.slug): sys.exit("slug: lowercase letters, digits, hyphens")
    if a.control and a.control_agree: sys.exit("refused: --control (texts should LOSE) and --control-agree (texts should WIN) are exclusive")
    if not a.predict: sys.exit("refused: at least one --predict is required — a run with no prediction cannot fail")
    date = datetime.datetime.now().strftime("%Y-%m-%d")          # the founder's machine date
    d = os.path.join(REPO, "runs", f"{date}-{a.slug}")
    if os.path.exists(d): sys.exit(f"refused: {d} exists — a pre-registration is never edited; register a new run")
    table, ids = rows(), [x.strip() for x in a.axioms.split(",") if x.strip()]
    missing = [i for i in ids if i not in table]
    if missing: sys.exit(f"refused: not in AXIOMS.md: {', '.join(missing)}")
    held = [x.strip() for x in a.held_out.split(",") if x.strip()]
    if a.proof:
        # The texts' own answers are the TEST, never a premise (kala/ANSWERS.md, ruled 2026-10-13).
        marked = [i for i in ids if "HELD OUT" in table[i]]
        if marked: sys.exit(f"refused: {', '.join(marked)} is HELD OUT (a text's own conclusion, kala/ANSWERS.md) — never a premise")
        both = [i for i in ids if i in held]
        if both: sys.exit(f"refused: {', '.join(both)} is both a premise and held out")
        stmt = open(a.lean, encoding="utf-8").read().strip() if os.path.exists(a.lean) else ""
        if not stmt: sys.exit(f"refused: {a.lean} is empty or missing — register the exact Lean statement")
        if "sorry" not in stmt:
            sys.exit("refused: the Lean statement must end in `sorry` — the STATEMENT is registered, the proof comes after")
    def status(row):                      # the Status column only (6-cell rows); a citation may mention RECALLED for a sub-locus
        cells = [c.strip() for c in row.strip().strip("|").split("|")]
        return cells[4] if len(cells) >= 6 else ""
    recalled = [i for i in ids if "RECALLED" in status(table[i])]
    if recalled and not a.allow_recalled:
        sys.exit(f"refused: RECALLED (unverified) axioms {', '.join(recalled)} — verify them with cst.py and update AXIOMS.md, or pass --allow-recalled and carry the word into the report")
    head = sh("git", "rev-parse", "--short", "HEAD")
    stamp = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman/UPSTREAM.txt"
    tip = open(stamp).readline().strip() if os.path.exists(stamp) else "UNKNOWN — run cst-sync.py --apply first"
    win = [] if a.window == "none" else [table["A0"]] if a.window == "A0" else [table["A0′"]] if a.window == "A0′" else [table["A0"], table["A0′"]]
    hdr = "| ID | Statement | Tier | Citation | Status | Lean |\n|---|---|---|---|---|---|"
    body = f"""# PRE-REGISTRATION — {a.slug}{' (CONTROL: a case chosen because the texts should LOSE)' if a.control else ' (CONTROL — AGREE: a case chosen because the texts should WIN)' if a.control_agree else ''}

*Pushed BEFORE the `abhidhamma` agent ran. Never edited after its push; a correction is a new run.*

- **Date (machine):** {date}
- **Question:** {a.question}
- **Window:** {a.window}
- **Instrument:** `SiliconWat/formal-abhidhamma` at `{head}` (AXIOMS.md, Axioms.lean as of that commit)\n- **Tipiṭaka text:** {tip} (CST line numbers are as of this version)
{('- ⚠️ **RECALLED axioms used (unverified):** ' + ', '.join(recalled)) if recalled else ''}

## Window rows

| ID | Statement | Status |
|---|---|---|
{chr(10).join(win)}

## Axioms (rows copied verbatim from `kala/AXIOMS.md`)

{hdr}
{chr(10).join(table[i] for i in ids)}

## Predictions

{chr(10).join(f'{n}. {x}' for n, x in enumerate(a.predict, 1))}

## Pass criteria for the instrument

{chr(10).join(f'- {x}' for x in a.passc) or '- (none beyond the predictions)'}
"""
    if a.proof:
        rub = sh("git", "log", "-1", "--format=%h", "--", "runs/PROVE-RUBRIC.md") or "UNCOMMITTED"
        kind = (f" (PROOF — CONTROL, KNOWN ANSWER: {a.control_known})" if a.control_known else " (PROOF)")
        body = f"""# PRE-REGISTRATION — {a.slug}{kind}

*Pushed BEFORE the proof was attempted. Never edited after its push; a correction is a new run. Graded by
[`runs/PROVE-RUBRIC.md`](../PROVE-RUBRIC.md) at `{rub}`.*

- **Date (machine):** {date}
- **Question:** {a.thesis}
- **Thesis approved by:** {a.approved_by}
- **Window:** {a.window}
- **Instrument:** `SiliconWat/formal-abhidhamma` at `{head}` (AXIOMS.md, ANSWERS.md, Axioms.lean as of that commit)
- **Tipiṭaka text:** {tip} (CST line numbers are as of this version)
{('- ⚠️ **RECALLED axioms used (unverified):** ' + ', '.join(recalled)) if recalled else ''}
{('- **Avyākata review:** ' + a.avyakata_reviewed) if a.avyakata_reviewed else ''}

## The exact Lean statement (the proof comes after; the statement may not move)

```lean
{stmt}
```

## Axioms — the only premises (rows copied verbatim from `kala/AXIOMS.md`)

{hdr}
{chr(10).join(table[i] for i in ids)}

## Type freedoms — what the Lean type leaves free, declared before the attempt (A388 OQ4)

{chr(10).join(f'- {x}' for x in a.type_freedom)}

## Held out — the texts' own answers this run may NOT reason from

{chr(10).join(f'- {x}' for x in held) or '- (none)'}

## Predicted outcome

- **The session predicts:** {a.predict_outcome}
- **The founder predicts:** {a.founder_predicts or '(no prediction given)'}

## Predictions

{chr(10).join(f'{n}. {x}' for n, x in enumerate(a.predict, 1))}

## Pass criteria for the instrument

{chr(10).join(f'- {x}' for x in a.passc) or '- (none beyond the predictions)'}
"""
    if a.dry_run: print(body); return
    os.makedirs(d); open(os.path.join(d, "PREREG.md"), "w", encoding="utf-8").write(body)
    rel = os.path.relpath(os.path.join(d, "PREREG.md"), REPO)
    ots = os.path.expanduser("~/.cache/ots-venv/bin/ots")           # Bitcoin, independent of GitHub (TIMESTAMPS.md)
    if os.path.exists(ots):
        subprocess.run([ots, "stamp", os.path.join(d, "PREREG.md")], cwd=REPO, check=True, capture_output=True)
        sh("git", "add", rel + ".ots"); print(f"stamped {rel}.ots (OpenTimestamps; pending until Bitcoin confirms — /ots upgrades it)")
    else:
        print("⚠️ OTS client absent (~/.cache/ots-venv) — PREREG NOT stamped; run /ots later")
    sh("git", "add", rel); sh("git", "commit", "-q", "-m", f"prereg: {a.slug} ({'proof; ' if a.proof else ''}window {a.window}; axioms {','.join(ids)})")
    prereg_sha = sh("git", "rev-parse", "HEAD")
    # The track record lists every PREREG, so it goes stale the moment one is committed; CI (runs-index.py --check)
    # failed on every registration push until the run landed (2026-09-30). Regenerate it in a second commit and push
    # both at once, so no push leaves the index stale. The PREREG commit stays the one the index cites.
    subprocess.run([sys.executable, os.path.join(REPO, "scripts", "runs-index.py")], cwd=REPO, check=True, capture_output=True)
    if sh("git", "status", "--porcelain", "runs/INDEX.md"):
        sh("git", "add", "runs/INDEX.md"); sh("git", "commit", "-q", "-m", f"runs/INDEX.md: {a.slug} registered")
    sha = sh("git", "rev-parse", "HEAD"); sh("git", "push", "-q")
    print(f"pushed {rel} at {prereg_sha[:7]}" + (f" (index {sha[:7]})" if sha != prereg_sha else ""))
    remote = sh("git", "remote", "get-url", "origin")
    slug = re.sub(r"(\.git)?$", "", remote.split("github.com")[-1].lstrip(":/"))
    # The repository ACTIVITY API records each push immediately; the events feed can lag for minutes (2026-09-30).
    for _ in range(6):
        try:
            for e in json.loads(sh("gh", "api", f"repos/{slug}/activity?per_page=10")):
                if e.get("activity_type") == "push" and e.get("after") == sha:
                    print(f"GitHub push record: {e['timestamp']}  ← the timestamp"); return
        except Exception: pass
        time.sleep(5)
    print("GitHub push record: not found yet; the commit is pushed — re-read with:\n"
          f"  gh api repos/{slug}/activity --jq '.[] | select(.after==\"{sha}\") | .timestamp'")

if __name__ == "__main__":
    main()
