#!/usr/bin/env python3
"""cittuppada.py — capture: the Dhammasaṅgaṇī's Cittuppāda — for each class of consciousness, the dhammas present in it, and the counts its
summary states — GENERATED from the CST (founder 2026-11-21: "do per your recommendation"; /capture's model reader of the book is the
cross-check).

  scripts/cittuppada.py                 regenerate cittuppada/CITTUPPADA.json and cittuppada/CITTUPPADA.md
  scripts/cittuppada.py --check         exit 1 if either generated file differs from what the CST text gives now
  scripts/cittuppada.py --selftest      the parsing rules on known answers, and a wrong expectation that must FAIL (no CST needed: CI)
  scripts/cittuppada.py --validate [f]  the generated JSON alone: its invariants and its known answers (CI)

THE TEXT. Each class of consciousness is one sentence: "Katame dhammā kusalā? Yasmiṃ samaye kāmāvacaraṃ kusalaṃ cittaṃ uppannaṃ hoti
somanassasahagataṃ ñāṇasampayuttaṃ …, tasmiṃ samaye phasso hoti, vedanā hoti, … avikkhepo hoti; ye vā pana … – ime dhammā kusalā." Later
sentences elide ("phasso hoti…pe… avikkhepo hoti"): an elided list is recorded as ELIDED, never completed by us. A SUMMARY follows its class
("Tasmiṃ kho pana samaye cattāro khandhā honti, dvāyatanāni honti, …, aṭṭhindriyāni honti, pañcaṅgikaṃ jhānaṃ hoti, …").

THE TEST. Five of the summary's counts can be DERIVED from the same class's list — its faculties (-indriyaṃ), powers (-balaṃ), roots (alobho
… moho), path factors (sammā-/micchā-) and jhāna factors — so the script compares each stated count with the count its own list gives. The
first list has 56 terms, which the Atthasālinī states independently ("chappaññāsa padāni", /capture dhs-att-num-014/015).

Terms, numbers and positions only (PREREGISTRATION-2026-09-27b.md §5; the CST is non-commercial, legal L21): a class is described by its
FEATURE words (plane, kind, feeling, association, prompting, the consciousness), never by its sentence.
"""
import hashlib, json, os, re, sys, unicodedata

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
FILE = "abh01m.mul.xml"
OUT_JSON = os.path.join(REPO, "cittuppada", "CITTUPPADA.json")
OUT_MD = os.path.join(REPO, "cittuppada", "CITTUPPADA.md")
CHAPTER = "1. Cittuppādakaṇḍaṃ"
PE = "…pe…"
FEATURE = re.compile(r"(āvacar|lokuttar|^kusal|^akusal|vipāk|kiriy|sahagat|sampayutt|vippayutt|sasaṅkhār|viññāṇ|^cittaṃ$|dhātu$|jhān|^paṭham|^dutiy|^tatiy|^catutth|^pañcam|kasiṇ|maggaṃ|phal)")
ROOTS = {"alobho", "adoso", "amoho", "lobho", "doso", "moho"}
JHANA = {"vitakko", "vicāro", "pīti", "sukhaṃ", "upekkhā", "dukkhaṃ", "domanassaṃ", "cittassekaggatā"}
# STEMS, not words: a fused number drops its final vowel ("aṭṭh-indriyāni", "pañc-aṅgikaṃ", "dv-āyatanāni")
NUM = {"ek": 1, "dv": 2, "tay": 3, "tīṇ": 3, "tiss": 3, "catt": 4, "catu": 4, "catass": 4, "pañc": 5, "cha": 6, "satt": 7, "aṭṭh": 8, "nav": 9, "das": 10}


def nfc(s):
    return unicodedata.normalize("NFC", s)


def plain(raw):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", re.sub(r"<pb\b[^>]*/>", "", re.sub(r"<note>.*?</note>", "", raw)))).strip()


def number(word):
    """The value of a summary's number word, its own or fused ("aṭṭhindriyāni", "pañcaṅgikaṃ", "dvāyatanāni"), or None."""
    w = nfc(word).lower()
    for k in sorted(NUM, key=len, reverse=True):
        if w.startswith(k):
            return NUM[k]
    return None


def padas(listing):
    """The 'X hoti' items of a list, in order; ELIDED when the list carries …pe…"""
    # items are split at each "hoti", never at commas: the CST drops a comma once ("samādhindriyaṃ hoti manindriyaṃ hoti", L4581), and a
    # comma-bound parser lost manindriyaṃ there — the summary's own count (pañcindriyāni) caught it
    # a list ends at its closing formula "ime dhammā …", even when another sentence follows on the same line (see RESULT below)
    body = re.split(r"(?<![\wāīūṃ])ime dhammā(?![\wāīūṃ])", listing.split(";")[0].split(" – ")[0])[0]
    parts = re.split(r"\s*(?<![\wāīūṃ])hoti(?![\wāīūṃ])\s*,?\s*", body)
    items = [p.replace(PE, " ").strip(" ,.") for p in parts[:-1]]
    return [x for x in items if x], PE in body


def derive(ps):
    """What the summary's derivable counts must be, from a class's own list."""
    u = list(dict.fromkeys(ps))
    return {"indriya": sum(1 for p in u if p.endswith("indriyaṃ")),
            "bala": sum(1 for p in u if p.endswith("balaṃ")),
            "hetu": sum(1 for p in u if p in ROOTS),
            "magga": sum(1 for p in u if re.match(r"^(sammā|micchā)(diṭṭhi|saṅkappo|vāyāmo|sati|samādhi|vācā|kammanto|ājīvo)$", p)),
            "jhāna": sum(1 for p in u if p in JHANA)}


def derivable(nw, noun):
    """Only a count of the WHOLE CLASS is derivable: "aṭṭhindriyāni", "satta balāni", "tayo hetū", "pañcaṅgikaṃ jhānaṃ", "pañcaṅgiko maggo" —
    never "ekaṃ manindriyaṃ" (one mind-faculty: a member, not the class)."""
    if noun.endswith("indriyāni"): return "indriya"
    if noun.endswith("balāni"): return "bala"
    if noun == "hetū": return "hetu"
    if "aṅgik" in nw and noun.startswith("maggo"): return "magga"
    if "aṅgik" in nw and noun.startswith("jhānaṃ"): return "jhāna"
    return None


def summary(text):
    """The counts a summary states: [(noun, number word, value, derivable key or None)], and whether it elides."""
    body = text.split("samaye", 1)[1].split(";")[0]
    out = []
    for m in re.finditer(r"(?:^|,)\s*((?:\S+\s+)?\S+?)\s+hon?ti(?=[,;.…\s]|$)", body):  # hoti AND honti
        words = m.group(1).split()
        nw, noun = (words[0], " ".join(words[1:])) if len(words) > 1 else (words[0], words[0])
        v = number(nw)
        if v is None:
            continue
        if len(words) == 1:  # a fused word: "aṭṭhindriyāni", "dvāyatanāni"
            noun = nw
        key = derivable(nw, noun)
        out.append([noun, nw, v, key])
    return out, PE in body


def build():
    b = open(os.path.join(CST, FILE), "rb").read()
    L = nfc(b.decode("utf-16")).splitlines()
    start = next(i for i, l in enumerate(L, 1) if plain(l) == CHAPTER)
    end = next(i for i, l in enumerate(L, 1) if i > start and re.search(r'rend="chapter"', l) and plain(l))
    heading, cittas, sums = None, [], []
    for i in range(start, end):
        raw = L[i - 1]; t = plain(raw)
        if not t:
            continue
        if re.search(r'rend="(?:title|subhead)"', raw):
            heading = t
            continue
        m = re.search(r"Yasmiṃ samaye (.+?)tasmiṃ samaye(.*)", t)
        if m:
            # RESULT (2026-11-23): on 39 lines the question asks for the RESULTANT ("Katame dhammā abyākatā?"), and the answer first restates
            # the wholesome class that is its condition ("… ime dhammā kusalā.") and then gives the result in a second sentence ("Tasseva …
            # vipākaṃ …, tasmiṃ samaye … ime dhammā abyākatā."). The class recorded is the one the question asks for: the second sentence.
            # Until this date the first sentence's list ran on into the second, so one "term" held the next sentence's words (39 classes).
            r = re.search(r"ime dhammā \w+\.?\s*([Tt]asseva .+?)tasmiṃ samaye(.*)", t)
            if r:
                m = r
            ps, elided = padas(m.group(2))
            asks = re.search(r"Katame dhammā (\w+)\?", t)
            closes = re.search(r"ime dhammā (\w+)", m.group(2)) or re.search(r"ime dhammā (\w+)", t)
            para = re.match(r"(\d+)\.", t)
            cittas.append({"line": i, "para": int(para.group(1)) if para else None, "heading": heading,
                           **({"asks": asks.group(1)} if asks else {}), **({"closes": closes.group(1)} if closes else {}),
                           "features": [w.strip(",") for w in m.group(1).split() if FEATURE.search(w.strip(","))],
                           "padas": ps, "elided": elided, "ye_va_pana": "ye vā pana" in m.group(2)})
            continue
        if re.match(r"(?:\d+\.\s*)?Tasmiṃ kho pana samaye", t) and cittas:
            counts, elided = summary(t)
            sums.append({"line": i, "of": cittas[-1]["line"], "counts": counts, "elided": elided})
    # the test: each derivable stated count against the count its own class's list gives (full lists only)
    by = {c["line"]: c for c in cittas}
    for s in sums:
        c = by[s["of"]]
        if c["elided"]:
            s["test"] = "list elided"
            continue
        d = derive(c["padas"])
        s["test"] = [[k, v, d[k], v == d[k]] for _, _, v, k in s["counts"] if k]
    return hashlib.sha256(b).hexdigest(), cittas, sums


def render(digest, cittas, sums):
    js = ['{"generated_by": "scripts/cittuppada.py", "rule": "terms, numbers and positions only; a class is given by its feature words",',
          ' "source": ' + json.dumps({FILE: digest}) + ",", ' "classes": [']
    js += ["  " + json.dumps(c, ensure_ascii=False) + ("," if k < len(cittas) - 1 else "") for k, c in enumerate(cittas)]
    js += [" ],", ' "summaries": [']
    js += ["  " + json.dumps(s, ensure_ascii=False) + ("," if k < len(sums) - 1 else "") for k, s in enumerate(sums)]
    js += [" ]}"]
    tests = [t for s in sums if isinstance(s.get("test"), list) for t in s["test"]]
    full = [c for c in cittas if not c["elided"]]
    md = ["# CITTUPPĀDA — the dhammas of each class of consciousness, as generated data", "",
          "*GENERATED by `scripts/cittuppada.py` from the local Chaṭṭha Saṅgāyana text — never edit by hand. Terms, numbers and positions only",
          "(PREREGISTRATION-2026-09-27b.md §5). The data is `CITTUPPADA.json`.*", "",
          f"**{len(cittas)} classes of consciousness** (*Yasmiṃ samaye …*), {len(full)} with their list of dhammas written in full and "
          f"{len(cittas) - len(full)} elided (*…pe…*, recorded as elided, never completed); **{len(sums)} summaries** (*Tasmiṃ kho pana samaye …*).", "",
          f"**Known answer:** the first class's list has **{len(cittas[0]['padas'])}** terms; the Atthasālinī states 56 (*chappaññāsa padāni*).", "",
          f"**The test of the text against itself:** {len(tests)} stated counts derivable from their own class's full list "
          f"(faculties, powers, roots, path factors, jhāna factors) — **{sum(1 for t in tests if t[3])} agree**, {sum(1 for t in tests if not t[3])} differ.", "",
          "| Line | Para | Heading | Feature words | Terms | Elided |", "|---|---|---|---|---|---|"]
    for c in cittas:
        md.append(f"| {c['line']} | {c['para'] or ''} | {c['heading'] or ''} | {' '.join(c['features'][:8])} | {len(c['padas'])} | {'yes' if c['elided'] else ''} |")
    diff = [(s["line"], t) for s in sums if isinstance(s.get("test"), list) for t in s["test"] if not t[3]]
    if diff:
        md += ["", "## Where a stated count differs from its own list", "", "| Summary line | Count | Stated | From the list |", "|---|---|---|---|"]
        md += [f"| {ln} | {t[0]} | {t[1]} | {t[2]} |" for ln, t in diff]
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


FIRST = ("tasmiṃ samaye phasso hoti, vedanā hoti, vitakko hoti, vicāro hoti, pīti hoti, sukhaṃ hoti, cittassekaggatā hoti, saddhindriyaṃ hoti, "
         "paññindriyaṃ hoti, sammādiṭṭhi hoti, sammāsaṅkappo hoti, saddhābalaṃ hoti, alobho hoti, adoso hoti, amoho hoti, sammādiṭṭhi hoti, "
         "avikkhepo hoti; ye vā pana tasmiṃ samaye aññepi atthi")
CASES = [
    ("padas", FIRST, (17, False)),
    ("padas", "tasmiṃ samaye phasso hoti…pe… avikkhepo hoti…pe… ime dhammā kusalā.", (2, True)),
    # the shape of abh01m.mul.xml:4109: a second sentence follows the closing formula on the same line, and the list ends at "ime dhammā"
    ("padas", "tasmiṃ samaye phasso hoti…pe… avikkhepo hoti…pe… ime dhammā kusalā. Tasseva … vipākaṃ …, tasmiṃ samaye phasso hoti…pe… "
              "avikkhepo hoti…pe… ime dhammā abyākatā.", (2, True)),
    ("padas", "tasmiṃ samaye vīriyindriyaṃ hoti, samādhindriyaṃ hoti manindriyaṃ hoti, upekkhindriyaṃ hoti; ye vā pana", (4, False)),
    ("derive", FIRST, {"indriya": 2, "bala": 1, "hetu": 3, "magga": 2, "jhāna": 5}),
    ("summary", "Tasmiṃ kho pana samaye ekaṃ manindriyaṃ hoti, aṭṭhindriyāni honti", [["manindriyaṃ", "ekaṃ", 1, None], ["aṭṭhindriyāni", "aṭṭhindriyāni", 8, "indriya"]]),
    ("summary", "Tasmiṃ kho pana samaye cattāro khandhā honti, dvāyatanāni honti, aṭṭhindriyāni honti, pañcaṅgikaṃ jhānaṃ hoti, pañcaṅgiko maggo hoti, satta balāni honti, tayo hetū honti, eko phasso hoti; ye vā pana",
     [["khandhā", "cattāro", 4, None], ["dvāyatanāni", "dvāyatanāni", 2, None], ["aṭṭhindriyāni", "aṭṭhindriyāni", 8, "indriya"], ["jhānaṃ", "pañcaṅgikaṃ", 5, "jhāna"],
      ["maggo", "pañcaṅgiko", 5, "magga"], ["balāni", "satta", 7, "bala"], ["hetū", "tayo", 3, "hetu"], ["phasso", "eko", 1, None]]),
]


def selftest():
    bad = 0
    for kind, text, want in CASES:
        if kind == "padas":
            ps, e = padas(text.split("tasmiṃ samaye", 1)[1]); got = (len(ps), e)
        elif kind == "derive":
            got = derive(padas(text.split("tasmiṃ samaye", 1)[1])[0])
        else:
            got = summary(text)[0]
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", kind, text[:60], "" if ok else f"→ {got}, want {want}")
    wrong = padas(FIRST.split("tasmiṃ samaye", 1)[1])[0].count("sammādiṭṭhi") == 1
    print("✓" if not wrong else "✗", "the harness FAILS a wrong expectation (a repeated term counted once in the list)")
    bad += wrong
    n = len(CASES) + 1
    print(f"cittuppada selftest: {n - bad}/{n}")
    return 1 if bad else 0


def validate(path=OUT_JSON):
    d, errs = json.load(open(path, encoding="utf-8")), []
    C, S = d["classes"], d["summaries"]
    if not C or len(C[0]["padas"]) != 56:
        errs.append("known answer: the first class's list is not the Atthasālinī's 56 terms")
    if [c["line"] for c in C] != sorted(c["line"] for c in C):
        errs.append("classes out of line order")
    lines = {c["line"] for c in C}
    for s in S:
        if s["of"] not in lines or s["of"] > s["line"]:
            errs.append(f"summary L{s['line']} does not follow a class")
        for t in s.get("test") if isinstance(s.get("test"), list) else []:
            if t[3] != (t[1] == t[2]):
                errs.append(f"summary L{s['line']}: a test verdict does not match its own numbers")
    for c in C:
        if not c["elided"] and not c["padas"]:
            errs.append(f"class L{c['line']}: a full list with no terms")
        # the rule, as a property of the file: single canonical terms only (PREREGISTRATION-2026-09-27b.md §5; the CST is non-commercial, L21)
        for p in c["padas"]:
            if len(p.split()) != 1:
                errs.append(f"class L{c['line']}: a list item is not a single term ({len(p.split())} words)")
        # the class recorded is the one its question asks for: its closing formula answers the question (39 records failed this until 2026-11-23)
        if c.get("asks") and c.get("closes") and c["asks"] != c["closes"]:
            errs.append(f"class L{c['line']}: asks for {c['asks']} but the recorded list closes {c['closes']}")
    for e in errs[:10]:
        print("✗", e)
    print(f"cittuppada validate: {'PASS' if not errs else 'FAIL'} — {len(C)} classes, {len(S)} summaries" + (f", {len(errs)} error(s)" if errs else ""))
    return 1 if errs else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    if "--validate" in sys.argv:
        k = sys.argv.index("--validate")
        sys.exit(validate(sys.argv[k + 1] if len(sys.argv) > k + 1 else OUT_JSON))
    digest, cittas, sums = build()
    js, md = render(digest, cittas, sums)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_JSON, js), (OUT_MD, md)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale:
            print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("cittuppada/ is current"); sys.exit(0)
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from stamped import write_rotating
    for p, t in ((OUT_JSON, js), (OUT_MD, md)):
        r = write_rotating(p, t, "regenerated by `scripts/cittuppada.py`")
        if r:
            print(f"proof rotated: {r} (logged in TIMESTAMPS.md)")
    print("\n".join(md.split("\n")[5:10]))
