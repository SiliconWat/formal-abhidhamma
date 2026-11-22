#!/usr/bin/env python3
"""dhatukatha_all.py — capture: every count the Dhātukathā states, in all fourteen methods (naya), GENERATED from the CST (founder
2026-11-21: "do per your recommendation"; /capture's model reader of the book is the cross-check). `dhatukatha/dhatukatha.py` (the first
method, sections 1–6, with its Lean check) is untouched and is this script's CONTROL: over its lines this parser must reproduce its 175 rows.

  scripts/dhatukatha_all.py                 regenerate dhatukatha/ALL.json and dhatukatha/ALL.md
  scripts/dhatukatha_all.py --check         exit 1 if either generated file differs from what the CST text gives now
  scripts/dhatukatha_all.py --selftest      the parsing rules on known answers, and a wrong expectation that must FAIL (no CST needed: CI)
  scripts/dhatukatha_all.py --validate [f]  the generated JSON alone: invariants, and the control's agreement as recorded (CI)

THE FORM. Every answer is a triple of instrumental counts and a verb: "catūhi khandhehi dvīhāyatanehi dvīhi dhātūhi saṅgahitā" (included in
4 aggregates, 2 bases, 2 elements) · "Katihi asaṅgahitā? Ekena khandhena dasahāyatanehi soḷasahi dhātūhi asaṅgahitā" · "na kehici khandhehi"
= 0 · a component the answer does not state is null · "… kehici sampayutto" (associated with SOME of) marks the triple partial · "Natthi" =
none. A paragraph's subjects are not written out here (terms, numbers and positions only — PREREGISTRATION-2026-09-27b.md §5); its line,
method and section are.

THE TESTS. Where a paragraph states both included and not-included, the two triples must sum to 5 aggregates, 12 bases and 18 elements
(the parser's own check, as dhatukatha.py's). Over lines 73–448 the triples must equal dhatukatha.py's 175 rows (the control).
"""
import hashlib, json, os, re, sys, unicodedata

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
FILE = "abh03m1.mul.xml"
OUT_JSON = os.path.join(REPO, "dhatukatha", "ALL.json")
OUT_MD = os.path.join(REPO, "dhatukatha", "ALL.md")
CONTROL_MD = os.path.join(REPO, "dhatukatha", "DHATUKATHA.md")
FIRST = 69  # the first method's title; the Uddeso before it is the book's table of contents
# instrumental number words, as STEMS (the āyatana forms fuse: "dvīhāyatanehi", "ekenāyatanena")
# BARE ROOTS, longest first: a fused form drops the instrumental -ahi ("dvādas-āyatanehi" as well as "dvādasah-āyatanehi")
NUM = sorted([("na kehici", 0), ("na kāhici", 0), ("ekādas", 11), ("dvādas", 12), ("teras", 13), ("cuddas", 14), ("pannaras", 15),
              ("pañcadas", 15), ("soḷas", 16), ("sattaras", 17), ("aṭṭhāras", 18), ("ek", 1), ("dv", 2), ("tī", 3), ("catū", 4), ("pañc", 5),
              ("chah", 6), ("satt", 7), ("aṭṭh", 8), ("nav", 9), ("das", 10)], key=lambda x: -len(x[0]))
KIND = {"khandh": 0, "āyatan": 1, "dhāt": 2}
VERB = re.compile(r"(saṅgahit|asaṅgahit|sampayutt|vippayutt)(?:āni|o|ā|aṃ)(?:ti)?(?![\wāīūṃ])")  # neuter plural too: saṅgahitāni (Cattāri saccāni)
TRIPLE = re.compile(r"((?:[Nn]a k[eā]hici|[^\s,;.?]+?)\s*(?:khandhehi|khandhena|āyatanehi|āyatanena|dhātūhi|dhātuyā)(?=[\s,]|$))")


def nfc(s):
    return unicodedata.normalize("NFC", s)


def plain(raw):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", re.sub(r"<pb\b[^>]*/>", "", re.sub(r"<note>.*?</note>", "", raw)))).strip()


def count_of(phrase):
    """'catūhi khandhehi' → (0, 4) · 'dvīhāyatanehi' → (1, 2) · 'na kehici āyatanehi' → (1, 0) · else None"""
    p = nfc(phrase).strip().lower()
    kind = next((v for k, v in KIND.items() if k in p), None)
    if kind is None:
        return None
    for stem, v in NUM:
        if p.startswith(stem):
            return kind, v
    return None


def triples(text):
    """Each stated answer in a passage: [verb, [aggregates, bases, elements] (null where not stated), partial?]. A clause runs from one verb
    to the next; within it the counts BEFORE the verb are its own, and a "; … kehici <verb>" clause is a separate PARTIAL triple."""
    out = []
    t = nfc(text)
    pos = 0
    for m in VERB.finditer(t):
        clause = t[pos:m.start()]
        pos = m.end()
        # only the stretch after the last question mark or sentence stop belongs to this verb's answer
        clause = re.split(r"[?]|\.\s|;\s", clause)[-1]
        if re.search(r"\bkatihi\b|\bkatihāyatanehi\b", clause):
            continue  # the question's own "katihi … ?" is not an answer
        trip = [None, None, None]
        for w in TRIPLE.finditer(clause):
            c = count_of(w.group(1))
            if c:
                trip[c[0]] = c[1]
        if trip == [None, None, None]:
            continue
        verb = m.group(1)
        out.append([verb, trip, bool(re.search(r"\bkehici\s*$", clause.strip()) or re.search(r"kehici\s+" + verb, t[m.start() - 12:m.end()]))])
    return out


def build():
    b = open(os.path.join(CST, FILE), "rb").read()
    L = nfc(b.decode("utf-16")).splitlines()
    method = section = None
    rows = []
    for i, raw in enumerate(L, 1):
        if i < FIRST:
            continue
        t = plain(raw)
        if not t:
            continue
        rend = (re.search(r'rend="([^"]+)"', raw) or [None, ""])[1]
        if rend == "chapter":
            m = re.match(r"(\d+)\.", t); method = int(m.group(1)) if m else method
            continue
        if rend in ("title", "subhead"):
            section = t
            continue
        tr = triples(t)
        none = bool(re.search(r"\?\s*Natthi\b", t))
        if tr or none:
            para = re.match(r"(\d+)\.", t)
            rows.append({"line": i, "method": method, "section": section, **({"para": int(para.group(1))} if para else {}),
                         "answers": tr, **({"none": 1} if none else {}), **({"pe": 1} if "…pe…" in t else {})})
    for r in rows:
        inc = [a[1] for a in r["answers"] if a[0] == "saṅgahit" and not a[2]]
        exc = [a[1] for a in r["answers"] if a[0] == "asaṅgahit" and not a[2]]
        if len(inc) == 1 and len(exc) == 1 and None not in inc[0] + exc[0]:
            r["sums"] = [inc[0][k] + exc[0][k] for k in range(3)]
    return hashlib.sha256(b).hexdigest(), rows


def control(rows):
    """The first method's sections 1–6 as dhatukatha.py read them (its DHATUKATHA.md table): line → (included, not included)."""
    want = []  # one row per SUBJECT: a line listing several subjects ("Vedanākkhandho… saññākkhandho…") gives each the line's answer
    for l in open(CONTROL_MD, encoding="utf-8"):
        m = re.match(r"^\| (\d+) \| [^|]+ \| \((\d+), (\d+), (\d+)\) \| \((\d+), (\d+), (\d+)\) \|$", l)
        if m:
            want.append((int(m.group(1)), ([int(x) for x in m.group(2, 3, 4)], [int(x) for x in m.group(5, 6, 7)])))
    got = {}
    for r in rows:
        inc = [a[1] for a in r["answers"] if a[0] == "saṅgahit" and not a[2]]
        exc = [a[1] for a in r["answers"] if a[0] == "asaṅgahit" and not a[2]]
        if inc and exc:
            got[r["line"]] = (inc[0], exc[0])
    agree = sum(1 for k, v in want if got.get(k) == v)
    return {"rows": len(want), "agree": agree, "differ": sorted({k for k, v in want if got.get(k) != v})[:20]}


def render(digest, rows, ctl):
    js = ['{"generated_by": "scripts/dhatukatha_all.py", "rule": "terms, numbers and positions only; a TEST BANK, never premises",',
          ' "source": ' + json.dumps({FILE: digest}) + ",", ' "control": ' + json.dumps(ctl) + ",", ' "rows": [']
    js += ["  " + json.dumps(r, ensure_ascii=False) + ("," if k < len(rows) - 1 else "") for k, r in enumerate(rows)]
    js += [" ]}"]
    n = sum(len(r["answers"]) for r in rows)
    sums = [r["sums"] for r in rows if "sums" in r]
    by = {}
    for r in rows:
        by.setdefault(r["method"], [0, 0]); by[r["method"]][0] += 1; by[r["method"]][1] += len(r["answers"])
    md = ["# DHĀTUKATHĀ — every stated count, all fourteen methods, as generated data", "",
          "*GENERATED by `scripts/dhatukatha_all.py` from the local Chaṭṭha Saṅgāyana text — never edit by hand. Terms, numbers and positions only",
          "(PREREGISTRATION-2026-09-27b.md §5); a TEST BANK, never premises. The data is `ALL.json`. The first method's sections 1–6 also have",
          "`dhatukatha.py` and its Lean check (`DHATUKATHA.md`), this script's control.*", "",
          f"**{len(rows):,} answering paragraphs · {n:,} stated triples** (aggregates, bases, elements; a component the answer leaves unstated is null).", "",
          f"**The control:** over the first method's sections 1–6, this parser reproduces **{ctl['agree']} of {ctl['rows']}** of `dhatukatha.py`'s rows.", "",
          f"**Included + not included:** {len(sums)} paragraphs state both in full; **{sum(1 for s in sums if s == [5, 12, 18])}** sum to 5 aggregates, 12 bases, 18 elements.", "",
          "| Method | Answering paragraphs | Triples |", "|---|---|---|"]
    md += [f"| {m} | {v[0]} | {v[1]} |" for m, v in sorted(by.items(), key=lambda x: x[0] or 0)]
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


CASES = [
    ("Kusalā dhammā catūhi khandhehi dvīhāyatanehi dvīhi dhātūhi saṅgahitā. Katihi asaṅgahitā? Ekena khandhena dasahāyatanehi soḷasahi dhātūhi asaṅgahitā.",
     [["saṅgahit", [4, 2, 2], False], ["asaṅgahit", [1, 10, 16], False]]),
    ("Abyākatā dhammā pañcahi khandhehi dvādasahāyatanehi aṭṭhārasahi dhātūhi saṅgahitā. Katihi asaṅgahitā? Na kehici khandhehi na kehici āyatanehi na kāhici dhātūhi asaṅgahitā.",
     [["saṅgahit", [5, 12, 18], False], ["asaṅgahit", [0, 0, 0], False]]),
    ("Rūpakkhandho katihi khandhehi katihāyatanehi katihi dhātūhi sampayuttoti? Natthi. Katihi vippayutto? Catūhi khandhehi ekenāyatanena sattahi dhātūhi vippayutto; ekenāyatanena ekāya dhātuyā kehici vippayutto.",
     [["vippayutt", [4, 1, 7], False], ["vippayutt", [None, 1, 1], True]]),
    ("Rūpakkhandho ca viññāṇakkhandho ca dvīhi khandhehi dvādasāyatanehi aṭṭhārasahi dhātūhi saṅgahitā. Katihi asaṅgahitā? Tīhi khandhehi, na kehici āyatanehi na kāhici dhātūhi asaṅgahitā.",
     [["saṅgahit", [2, 12, 18], False], ["asaṅgahit", [3, 0, 0], False]]),
    ("Bāvīsatindriyāni catūhi khandhehi sattahāyatanehi terasahi dhātūhi saṅgahitāni. Katihi asaṅgahitāni? Ekena khandhena pañcahāyatanehi pañcahi dhātūhi asaṅgahitāni.",
     [["saṅgahit", [4, 7, 13], False], ["asaṅgahit", [1, 5, 5], False]]),
    ("Viññāṇakkhandho tīhi khandhehi sampayutto; ekenāyatanena ekāya dhātuyā kehici sampayutto.",
     [["sampayutt", [3, None, None], False], ["sampayutt", [None, 1, 1], True]]),
]


def selftest():
    bad = 0
    for text, want in CASES:
        got = triples(text)
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", text[:70], "" if ok else f"\n    got  {got}\n    want {want}")
    wrong = triples(CASES[0][0])[0][1] == [4, 2, 12]
    print("✓" if not wrong else "✗", "the harness FAILS a wrong expectation (dvīhi dhātūhi read as 12)")
    bad += wrong
    n = len(CASES) + 1
    print(f"dhatukatha_all selftest: {n - bad}/{n}")
    return 1 if bad else 0


def validate(path=OUT_JSON):
    d, errs = json.load(open(path, encoding="utf-8")), []
    c = d["control"]
    if c["agree"] != c["rows"] or c["rows"] < 175:
        errs.append(f"the control: {c['agree']} of {c['rows']} of dhatukatha.py's rows reproduced")
    hi = (5, 12, 18)
    for r in d["rows"]:
        for a in r["answers"]:
            if any(v is not None and not (0 <= v <= hi[k]) for k, v in enumerate(a[1])):
                errs.append(f"L{r['line']}: a count outside 0–5 / 0–12 / 0–18")
        if "sums" in r and r["sums"] != [5, 12, 18]:
            errs.append(f"L{r['line']}: included + not included = {r['sums']}, not 5, 12, 18")
    if [r["line"] for r in d["rows"]] != sorted(r["line"] for r in d["rows"]):
        errs.append("rows out of line order")
    for e in errs[:12]:
        print("✗", e)
    print(f"dhatukatha_all validate: {'PASS' if not errs else 'FAIL'} — {len(d['rows'])} paragraphs, control {c['agree']}/{c['rows']}" + (f", {len(errs)} error(s)" if errs else ""))
    return 1 if errs else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    if "--validate" in sys.argv:
        k = sys.argv.index("--validate")
        sys.exit(validate(sys.argv[k + 1] if len(sys.argv) > k + 1 else OUT_JSON))
    digest, rows = build()
    ctl = control(rows)
    js, md = render(digest, rows, ctl)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_JSON, js), (OUT_MD, md)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale:
            print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("dhatukatha ALL is current"); sys.exit(0)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from stamped import write_rotating
    for p, t in ((OUT_JSON, js), (OUT_MD, md)):
        r = write_rotating(p, t, "regenerated by `scripts/dhatukatha_all.py`")
        if r:
            print(f"proof rotated: {r} (logged in TIMESTAMPS.md)")
    print("\n".join(md.split("\n")[5:10]))
