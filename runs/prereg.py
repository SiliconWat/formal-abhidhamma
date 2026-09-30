#!/usr/bin/env python3
"""prereg.py — pre-register one Abhidhamma-mode run BEFORE the agent sees the question.

Writes runs/<date>-<slug>/PREREG.md (question, window, the axiom rows copied verbatim from
kala/AXIOMS.md, predictions, pass criteria, instrument commit), commits, pushes, and reads GitHub's
record of the push — the push time, not the commit date, is the timestamp nobody can backdate.

  runs/prereg.py <slug> --question "…" --window A0|A0′|both --axioms A1,A3,C
                 [--predict "…"]… [--pass "…"]… [--allow-recalled] [--control] [--dry-run]

Refuses: a run directory that already exists (a pre-registration is never edited; a correction is a
new run) · an axiom ID not in AXIOMS.md · a RECALLED axiom without --allow-recalled · no prediction.
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
    p.add_argument("slug"); p.add_argument("--question", required=True)
    p.add_argument("--window", required=True, choices=["A0", "A0′", "both"])
    p.add_argument("--axioms", required=True)
    p.add_argument("--predict", action="append", default=[]); p.add_argument("--pass", dest="passc", action="append", default=[])
    p.add_argument("--allow-recalled", action="store_true"); p.add_argument("--control", action="store_true")
    p.add_argument("--dry-run", action="store_true")
    a = p.parse_args()
    if not re.fullmatch(r"[a-z0-9-]+", a.slug): sys.exit("slug: lowercase letters, digits, hyphens")
    if not a.predict: sys.exit("refused: at least one --predict is required — a run with no prediction cannot fail")
    date = datetime.datetime.now().strftime("%Y-%m-%d")          # the founder's machine date
    d = os.path.join(REPO, "runs", f"{date}-{a.slug}")
    if os.path.exists(d): sys.exit(f"refused: {d} exists — a pre-registration is never edited; register a new run")
    table, ids = rows(), [x.strip() for x in a.axioms.split(",") if x.strip()]
    missing = [i for i in ids if i not in table]
    if missing: sys.exit(f"refused: not in AXIOMS.md: {', '.join(missing)}")
    def status(row):                      # the Status column only (6-cell rows); a citation may mention RECALLED for a sub-locus
        cells = [c.strip() for c in row.strip().strip("|").split("|")]
        return cells[4] if len(cells) >= 6 else ""
    recalled = [i for i in ids if "RECALLED" in status(table[i])]
    if recalled and not a.allow_recalled:
        sys.exit(f"refused: RECALLED (unverified) axioms {', '.join(recalled)} — verify them with cst.py and update AXIOMS.md, or pass --allow-recalled and carry the word into the report")
    head = sh("git", "rev-parse", "--short", "HEAD")
    stamp = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman/UPSTREAM.txt"
    tip = open(stamp).readline().strip() if os.path.exists(stamp) else "UNKNOWN — run cst-sync.py --apply first"
    win = [table["A0"]] if a.window == "A0" else [table["A0′"]] if a.window == "A0′" else [table["A0"], table["A0′"]]
    hdr = "| ID | Statement | Tier | Citation | Status | Lean |\n|---|---|---|---|---|---|"
    body = f"""# PRE-REGISTRATION — {a.slug}{' (CONTROL: a case chosen because the texts should LOSE)' if a.control else ''}

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
    if a.dry_run: print(body); return
    os.makedirs(d); open(os.path.join(d, "PREREG.md"), "w", encoding="utf-8").write(body)
    rel = os.path.relpath(os.path.join(d, "PREREG.md"), REPO)
    sh("git", "add", rel); sh("git", "commit", "-q", "-m", f"prereg: {a.slug} (window {a.window}; axioms {','.join(ids)})")
    sha = sh("git", "rev-parse", "HEAD"); sh("git", "push", "-q")
    print(f"pushed {rel} at {sha[:7]}")
    remote = sh("git", "remote", "get-url", "origin")
    slug = re.sub(r"(\.git)?$", "", remote.split("github.com")[-1].lstrip(":/"))
    for _ in range(6):
        try:
            ev = json.loads(sh("gh", "api", f"repos/{slug}/events?per_page=30"))
            for e in ev:
                if e.get("type") == "PushEvent" and e["payload"].get("head") == sha:
                    print(f"GitHub push record: {e['created_at']}  ← the timestamp"); return
        except Exception: pass
        time.sleep(10)
    print("GitHub push record: not yet in the events feed (it lags); the commit is pushed — re-read later with:\n"
          f"  gh api repos/{slug}/events --jq '.[] | select(.payload.head==\"{sha}\") | .created_at'")

if __name__ == "__main__":
    main()
