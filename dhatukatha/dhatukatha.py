#!/usr/bin/env python3
"""dhatukatha.py — capture of the Dhātukathā's first naya, sections 1–3 (Khandho, Āyatanaṃ, Dhātu): the COUNTS the book states for each combination of aggregates, bases and elements
("rūpakkhandho katihi khandhehi katihāyatanehi katihi dhātūhi saṅgahito?"), read from the CST (`abh03m1.mul.xml:73–264`) and written as `Dhatukatha.lean` (the rows as data) and `DHATUKATHA.md`.
The counts are the TEST BANK, never premises (Protocol 1 §10; kala/ANSWERS.md): Lean computes them from the manual's tables (Saṅgaha ch. 7: which dhammas are in which aggregate, base and element)
and compares. Every row's three pairs must sum to 5, 12 and 18, the parser's own check.   dhatukatha.py --check exits 1 if the generated files are stale."""
import os, re, sys, unicodedata
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, "..", "tipitaka-mcp"))
import server
FILE = "abh03m1.mul.xml"; FIRST, LAST = 73, 264

def norm(s): return unicodedata.normalize("NFC", s).lower()
ITEMS = {  # stem → (kind, index)
 **{k: ("kh", i) for i, k in enumerate(["rūpakkhandh", "vedanākkhandh", "saññākkhandh", "saṅkhārakkhandh", "viññāṇakkhandh"])},
 **{k: ("ay", i) for i, k in enumerate(["cakkhāyatan", "sotāyatan", "ghānāyatan", "jivhāyatan", "kāyāyatan", "rūpāyatan", "saddāyatan", "gandhāyatan", "rasāyatan", "phoṭṭhabbāyatan", "manāyatan", "dhammāyatan"])},
 **{k: ("dh", i) for i, k in enumerate(["cakkhudhātu", "sotadhātu", "ghānadhātu", "jivhādhātu", "kāyadhātu", "rūpadhātu", "saddadhātu", "gandhadhātu", "rasadhātu", "phoṭṭhabbadhātu",
     "cakkhuviññāṇadhātu", "sotaviññāṇadhātu", "ghānaviññāṇadhātu", "jivhāviññāṇadhātu", "kāyaviññāṇadhātu", "manodhātu", "manoviññāṇadhātu", "dhammadhātu"])},
}
ALL = {"pañcakkhandhā": [("kh", i) for i in range(5)], "dvādasāyatanāni": [("ay", i) for i in range(12)], "aṭṭhārasa": [("dh", i) for i in range(18)]}
NUM = [("ekādasa", 11), ("dvādasa", 12), ("dvādas", 12), ("ekādas", 11), ("terasa", 13), ("cuddasa", 14), ("pannarasa", 15), ("soḷasa", 16), ("sattarasa", 17), ("aṭṭhārasa", 18),
       ("pañca", 5), ("eken", 1), ("ekāya", 1), ("eka", 1), ("dvī", 2), ("dva", 2), ("tī", 3), ("catū", 4), ("cha", 6), ("satta", 7), ("aṭṭha", 8), ("nava", 9), ("dasa", 10)]
def item_of(tok):
    t = norm(tok).strip(",;.?")
    t = re.sub(r"(ñca|ca)$", "", t)
    for stem, v in ITEMS.items():
        if t.startswith(stem): return v
    return None
def num_of(tok):
    t = norm(tok)
    for p, n in NUM:
        if t.startswith(p): return n
    return None

def clean(l): return re.sub(r"\s+", " ", server.plain(l)).strip()

def parse():
    ls = server.lines(FILE); rows = []; skipped = []
    for i in range(FIRST, LAST + 1):
        t = clean(ls[i - 1])
        m = re.match(r"^(\d+)\. (.*)$", t)
        if not m or "saṅgahit" not in t: continue
        n, body = int(m.group(1)), m.group(2)
        parts = re.split(r"\s*Katihi asaṅgahit\w+\?\s*", body)
        if len(parts) != 2: skipped.append((i, "no asaṅgahita sentence")); continue
        first, second = parts
        # the first sentence: the question may be spelled out ("… katihi khandhehi … saṅgahitā? <items> <counts> saṅgahitā.") or abbreviated ("<items> … <counts> saṅgahitā.")
        if "?" in first: first = first.split("?", 1)[1].strip()
        first = re.sub(r"\s*saṅgahit\w*\.?\s*$", "", first)
        pieces = re.split(r"\s*…(?:pe…)?\s*", first)
        subsets = []; counts_text = None
        for k, pc in enumerate(pieces):
            toks = pc.split(); items = []
            if toks and norm(toks[0]) in ALL: items = list(ALL[norm(toks[0])]); toks = toks[1:]
            else:
                while toks:
                    if norm(toks[0]) == "ca": toks = toks[1:]; continue
                    it = item_of(toks[0])
                    if it is None: break
                    items.append(it); toks = toks[1:]
            if items: subsets.append(items)
            if k == len(pieces) - 1: counts_text = " ".join(toks)
        if counts_text is None or not subsets: skipped.append((i, "no counts")); continue
        def triple(txt):
            txt = txt.replace("asaṅkhataṃ khandhato ṭhapetvā", "").strip()
            def grab(rx, default=None):
                mm = re.search(rx, txt)
                return mm
            if re.match(r"^na kehici khandhehi", norm(txt)): k = 0
            else:
                mk = re.search(r"(\S+) khandh(?:ehi|ena)", txt); k = num_of(mk.group(1)) if mk else None
            ma = re.search(r"na kehici āyatanehi", txt)
            if ma: a = 0
            else:
                mm = re.search(r"(\S*)āyatan(?:ehi|ena)", txt); a = num_of(mm.group(1)) if mm and mm.group(1) else None
                if mm and not mm.group(1):
                    mm = re.search(r"(\S+) āyatan(?:ehi|ena)", txt); a = num_of(mm.group(1)) if mm else None
            if re.search(r"na kāhici dhātūhi", txt): d = 0
            else:
                md = re.search(r"(\S+) dhāt(?:ūhi|uyā)", txt); d = num_of(md.group(1)) if md else None
            return (k, a, d)
        a1 = triple(counts_text); a2 = triple(second.rstrip(". "))
        if None in a1 or None in a2: skipped.append((i, f"counts unparsed {a1} {a2} :: {counts_text[:60]} / {second[:60]}")); continue
        if (a1[0] + a2[0], a1[1] + a2[1], a1[2] + a2[2]) != (5, 12, 18): skipped.append((i, f"sums {a1}+{a2} != (5,12,18)")); continue
        for s in subsets: rows.append(dict(sec=n, line=i, items=s, inc=a1, exc=a2))
    return rows, skipped

KH = ["rupa", "vedana", "sanna", "sankhara", "vinnana"]
def lean(rows):
    out = ["/-", "  dhatukatha/Dhatukatha.lean — GENERATED by dhatukatha.py (⛔ never edited by hand): the Dhātukathā's first naya, sections 1–3, as data. The COUNTS are the test bank; Lean computes them from the manual's tables below.", "-/",
           "namespace FormalAbhidhamma.Dhatukatha", ""]
    out.append("inductive Item | kh (n : Nat) | ay (n : Nat) | dh (n : Nat) deriving DecidableEq, Repr")
    out.append("/-- One stated row: the items combined, the counts of aggregates, bases and elements that include them, and that do not. `line` is the CST line (`abh03m1.mul.xml`). -/")
    out.append("structure Row where\n  line : Nat\n  items : List Item\n  inc : Nat × Nat × Nat\n  exc : Nat × Nat × Nat\n  deriving Repr\n")
    def it(x): return f"Item.{x[0]} {x[1]}"
    out.append("def rows : List Row := [")
    out.append(",\n".join("  ⟨%d, [%s], (%d, %d, %d), (%d, %d, %d)⟩" % (r["line"], ", ".join(it(x) for x in r["items"]), *r["inc"], *r["exc"]) for r in rows))
    out.append("]\n\nend FormalAbhidhamma.Dhatukatha")
    return "\n".join(out) + "\n"

def md(rows, skipped):
    L = ["# DHATUKATHA — the first naya, sections 1–3, as captured", "", "*GENERATED by `dhatukatha.py` from `abh03m1.mul.xml:73–264` (the Dhātukathā, mūla). ⛔ Never edited by hand. The counts are the TEST BANK (`kala/ANSWERS.md`), never premises.*", "",
         f"**{len(rows)} stated combinations parsed** (every one's three pairs sum to 5, 12 and 18). Skipped lines: {len(skipped)}.", ""]
    for i, why in skipped: L.append(f"- line {i}: {why}")
    L += ["", "| line | items (kind:index) | included in (aggregates, bases, elements) | not included in |", "|---|---|---|---|"]
    for r in rows: L.append(f"| {r['line']} | {', '.join(x[0] + ':' + str(x[1]) for x in r['items'])} | {r['inc']} | {r['exc']} |")
    return "\n".join(L) + "\n"

if __name__ == "__main__":
    rows, skipped = parse()
    texts = {os.path.join(HERE, "Dhatukatha.lean"): lean(rows), os.path.join(HERE, "DHATUKATHA.md"): md(rows, skipped)}
    if sys.argv[1:] == ["--check"]:
        bad = [p for p, t in texts.items() if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        print("dhatukatha files are current" if not bad else f"STALE: {bad}"); sys.exit(1 if bad else 0)
    for p, t in texts.items(): open(p, "w", encoding="utf-8").write(t)
    print(f"{len(rows)} rows; skipped {len(skipped)}")
    for i, why in skipped: print("  skipped", i, why)
