#!/usr/bin/env python3
"""P-FA5 — align two editions' term lists (the words before each `hoti`) position by position.

Prints only romanized single canonical terms and classifications (no running text), per
PREREGISTRATION-2026-09-27b.md §5. Each position is IDENTICAL, CLOSE (same term, spelling differs:
edit distance ≤ 3 and ≥ 70% similar — an orthographic OR transcription difference, undecided until the
printed page is checked), or DIFFERENT. Missing/extra terms are reported as INSERT/DELETE.
"""
import difflib, re, sys, unicodedata
sys.path.insert(0, __import__("os").path.dirname(__file__))
from pada import norm

def terms(text: str) -> list[str]:
    body = text.partition("tasmiṃ samaye")[2].partition("ye vā pana")[0]
    body = re.sub(r"\(\d+\)", "", body).replace("-\n", "").replace("\n", " ")
    body = re.sub(r"hoti", " hoti ", body)
    return [norm(m) for m in re.findall(r"([^\s,;.–-]+)\s+hoti", body)]

def lev(a, b):
    d = list(range(len(b) + 1))
    for i, ca in enumerate(a, 1):
        p, d[0] = d[0], i
        for j, cb in enumerate(b, 1):
            p, d[j] = d[j], min(d[j] + 1, d[j - 1] + 1, p + (ca != cb))
    return d[-1]

def classify(a, b):
    if a == b: return "IDENTICAL"
    r = difflib.SequenceMatcher(None, a, b).ratio()
    return "CLOSE" if lev(a, b) <= 3 and r >= 0.7 else "DIFFERENT"

if __name__ == "__main__":
    A, B = (terms(open(f, encoding="utf-8").read()) for f in sys.argv[1:3])
    print(f"C: {len(A)} terms · K: {len(B)} terms")
    sm = difflib.SequenceMatcher(None, A, B, autojunk=False)
    counts = {}
    for op, i1, i2, j1, j2 in sm.get_opcodes():
        if op == "equal":
            counts["IDENTICAL"] = counts.get("IDENTICAL", 0) + (i2 - i1); continue
        if op == "replace" and i2 - i1 == j2 - j1:
            for a, b in zip(A[i1:i2], B[j1:j2]):
                c = classify(a, b); counts[c] = counts.get(c, 0) + 1
                print(f"  pos {i1 + 1:>2}  {c:<9} C {a:<22} K {b}"); i1 += 1
            continue
        for a in A[i1:i2]: print(f"  DELETE (in C, not K)  {a}"); counts["DELETE"] = counts.get("DELETE", 0) + 1
        for b in B[j1:j2]: print(f"  INSERT (in K, not C)  {b}"); counts["INSERT"] = counts.get("INSERT", 0) + 1
    print("summary:", counts)
