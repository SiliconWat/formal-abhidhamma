#!/usr/bin/env python3
"""kathavatthu.py — capture: the Kathāvatthu's DEBATE INDEX, generated from the CST (founder 2026-11-20: "continue", after a model
reader marked under half of the text's questions; the text's own question form is regular enough for a script).

  scripts/kathavatthu.py                 regenerate kathavatthu/KATHAVATTHU.json and kathavatthu/KATHAVATTHU.md
  scripts/kathavatthu.py --check         exit 1 if either generated file differs from what the CST text gives now
  scripts/kathavatthu.py --private DIR   ALSO write DIR/THESES.json: every question's own words (PRIVATE: running text never enters this
                                         repo; DIR must lie outside it)
  scripts/kathavatthu.py --selftest      the parsing rules on known answers, and a wrong expectation that must FAIL (no CST needed: CI)
  scripts/kathavatthu.py --validate [f]  the generated JSON alone: debates in order, positions inside their debate, tallies consistent (CI)

WHAT A DEBATE IS. The first chapter's debates are its own chapter headings ("1. Puggalakathā"); from then on a chapter is a vagga
("21. Ekavīsatimavaggo") and its debates are numbered subheads ("(194) 1. Asañciccakathā"). A debate runs from its heading to the next
debate's heading or vagga heading.

WHAT A QUESTION IS. A clause ending in "…ti?" followed by its reply: "Āmantā" (yes) or "Na hevaṃ vattabbe" (it should not be said so).
The index keeps, per debate, the CST line of every question and its reply kind, never the question's words (terms, numbers and
positions only: PREREGISTRATION-2026-09-27b.md §5; the CST is non-commercial, legal L21). Variant readings (<note>) are dropped whole.
Who held each view is NOT in this text (the commentary names the schools): it is a separate capture.
"""
import hashlib, json, os, re, sys, unicodedata
from collections import Counter

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
FILE = "abh03m3.mul.xml"
OUT_JSON = os.path.join(REPO, "kathavatthu", "KATHAVATTHU.json")
OUT_MD = os.path.join(REPO, "kathavatthu", "KATHAVATTHU.md")
REPLIES = {"āmantā": "yes", "na hevaṃ vattabbe": "no"}
# A question: the clause back to the previous sentence end, ending "…ti?" and followed by its reply.
QUESTION = re.compile(r"([^.?!;]*?ti)\?\s*(Āmantā|Na hevaṃ vattabbe)", re.IGNORECASE)
# "(194) 1. Asañciccakathā" · "(188) 3 Sāmaññaphalakathā" (no dot) · "(106-108) 1-3. Tissopi anusayakathā" and "(212-4) 5-7. …" (one heading
# for several debates; the text abbreviates the second number)
DEBATE_SUB = re.compile(r"^\((\d+)(?:[-–](\d+))?\)\s*\d+(?:[-–]\d+)?\.?\s*(.+kathā)\s*$")
DEBATE_CH = re.compile(r"^(\d+)\.\s*(.+kathā)\s*$")
VAGGA = re.compile(r"^(\d+)\.\s*(.+vaggo)\s*$")


def nfc(s):
    return unicodedata.normalize("NFC", s)


def read():
    b = open(os.path.join(CST, FILE), "rb").read()
    return nfc(b.decode("utf-16")).splitlines(), hashlib.sha256(b).hexdigest()


def plain(raw):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", re.sub(r"<pb\b[^>]*/>", "", re.sub(r"<note>.*?</note>", "", raw)))).strip()


def questions(text):
    """(clause, reply, kind) for every question in one line: kind "cite" when it asks whether scripture said so ("Nanu vuttaṃ
    bhagavatā – ‘‘…’’ti? Āmantā"), else "thesis"."""
    out, prev = [], 0
    for m in QUESTION.finditer(text):
        # A quoted sutta contains full stops, so the clause alone can lose its "Nanu vuttaṃ bhagavatā –" opening: look back to the
        # previous question's end instead.
        span = text[prev:m.end(1)]
        k = re.search(r"(?i)nanu\s+vutta", span)
        clause = span[k.start():] if k else re.sub(r"^\d+\.\s*", "", m.group(1).strip(" –—…,"))
        out.append((clause.strip(), REPLIES[nfc(m.group(2)).lower()], "cite" if k else "thesis"))
        prev = m.end()
    return out


def heading(raw, p):
    """('debate', n, title) · ('vagga', n, title) · None."""
    m = re.search(r'<(?:p|head)\s+rend="([^"]+)"', raw)
    rend = m.group(1) if m else ""
    if rend in ("subhead", "title") and DEBATE_SUB.match(p):  # (12) is a title in the CST
        g = DEBATE_SUB.match(p)
        first, last = g.group(1), g.group(2)
        if last and len(last) < len(first):
            last = first[: len(first) - len(last)] + last  # "212-4" → 214
        return ("debate", int(first), g.group(3).strip()) + ((int(last),) if last else ())
    if rend == "chapter" and VAGGA.match(p):
        g = VAGGA.match(p)
        return ("vagga", int(g.group(1)), g.group(2).strip())
    if rend == "chapter" and DEBATE_CH.match(p):
        g = DEBATE_CH.match(p)
        return ("debate", int(g.group(1)), g.group(2).strip())  # the first chapter: its debates are chapter headings
    return None


def build():
    L, digest = read()
    debates, vagga, cur, private = [], None, None, []
    for i, raw in enumerate(L, 1):
        p = plain(raw)
        if not p:
            continue
        h = heading(raw, p)
        if h and h[0] == "vagga":
            vagga = {"n": h[1], "title": h[2], "line": i}
            cur = None
            continue
        if h and h[0] == "debate":
            cur = {"n": h[1], **({"n_last": h[3]} if len(h) > 3 else {}), "title": h[2], "vagga": vagga["n"] if vagga else 1, "lines": [i, i], "paragraphs": [], "q": []}
            debates.append(cur)
            continue
        if cur is None:
            continue
        cur["lines"][1] = i
        m = re.search(r'\bn="(\d+)"', raw)
        if m:
            cur["paragraphs"].append(int(m.group(1)))
        for clause, reply, kind in questions(p):
            cur["q"].append([i, reply] + (["cite"] if kind == "cite" else []))
            private.append({"debate": cur["n"], "line": i, "reply": reply, "kind": kind, "question": clause})
    for d in debates:
        d["paragraphs"] = [min(d["paragraphs"]), max(d["paragraphs"])] if d["paragraphs"] else []
        c = Counter(q[1] for q in d["q"])
        d["tally"] = {"questions": len(d["q"]), "yes": c["yes"], "no": c["no"], "citations": sum(1 for q in d["q"] if len(q) > 2)}
    return digest, debates, private


def render(digest, debates):
    js = ['{"generated_by": "scripts/kathavatthu.py", "rule": "terms, numbers and positions only; who held each view is a separate capture",',
          ' "source": ' + json.dumps({FILE: digest}) + ",", ' "debates": [']
    js += ["  " + json.dumps(d, ensure_ascii=False) + ("," if k < len(debates) - 1 else "") for k, d in enumerate(debates)]
    js += [" ]}"]
    q = sum(d["tally"]["questions"] for d in debates)
    yes = sum(d["tally"]["yes"] for d in debates)
    md = ["# KATHĀVATTHU — the debate index, as generated data", "",
          "*GENERATED by `scripts/kathavatthu.py` from the local Chaṭṭha Saṅgāyana text — never edit by hand. Terms, numbers and positions",
          "only (PREREGISTRATION-2026-09-27b.md §5): each debate's number, title, chapter, CST lines and paragraphs, and the CST line and reply",
          "of every question it puts (*…ti? Āmantā* = yes · *…ti? Na hevaṃ vattabbe* = no; `cite` = it asks whether scripture said so, *Nanu",
          "vuttaṃ bhagavatā …*). The questions' own words are not here. Who held",
          "each view is not in this text: the commentary names the schools (a separate capture). The data is `KATHAVATTHU.json`.*", "",
          "**The boundary, measured:** a question here is one answered *Āmantā* or *Na hevaṃ vattabbe*. A few questions take another reply",
          "(*…ti? Tattheva*, or a counter-argument at once) and are not counted; the refutation formula's RESTATEMENTS of a thesis (*Tvaṃ ce",
          "pana maññasi…*, *Vattabbe kho…*) are not questions. Cross-checked 2026-11-20 against two model readers of the whole text: the",
          "index holds 97.7% and 99.6% of the lines they marked as theses (the rest are those two kinds); they marked 47.6% and 43.9% of its.", "",
          f"**{len(debates)} debate headings covering {sum(d.get('n_last', d['n']) - d['n'] + 1 for d in debates)} numbered debates · {q:,} questions ({yes:,} answered yes, {q - yes:,} no; {sum(d['tally']['citations'] for d in debates):,} cite scripture).**", "",
          "| No. | Debate | Chapter | CST lines | Paragraphs | Questions | Yes | No | Citing scripture |", "|---|---|---|---|---|---|---|---|---|"]
    for d in debates:
        par = f"§{d['paragraphs'][0]}–{d['paragraphs'][1]}" if d["paragraphs"] else ""
        md.append(f"| {d['n']}{'–' + str(d['n_last']) if 'n_last' in d else ''} | {d['title']} | {d['vagga']} | {d['lines'][0]}–{d['lines'][1]} | {par} | {d['tally']['questions']} | {d['tally']['yes']} | {d['tally']['no']} | {d['tally']['citations']} |")
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


CASES = [
    ("1. Puggalo upalabbhati saccikaṭṭhaparamatthenāti? Āmantā.", [("Puggalo upalabbhati saccikaṭṭhaparamatthenāti", "yes", "thesis")]),
    ("Yo saccikaṭṭho paramattho, tato so puggalo upalabbhatīti? Na hevaṃ vattabbe…pe….", [("Yo saccikaṭṭho paramattho, tato so puggalo upalabbhatīti", "no", "thesis")]),
    ("Atthi lokiyā saddhāti? Āmantā. Atthi lokiyaṃ saddhindriyanti? Na hevaṃ vattabbe.", [("Atthi lokiyā saddhāti", "yes", "thesis"), ("Atthi lokiyaṃ saddhindriyanti", "no", "thesis")]),
    ("Ājānāhi niggahaṃ. Hañci puggalo upalabbhati, tena vata re vattabbe.", []),
    ("Nanu vuttaṃ bhagavatā – ‘‘sabbe dhammā anattā. Iti passathā’’ti? Āmantā.", [("Nanu vuttaṃ bhagavatā – ‘‘sabbe dhammā anattā. Iti passathā’’ti", "yes", "cite")]),
    ("Nanu vuttaṃ bhagavatā – ‘‘atthi puggalo attahitāya paṭipanno’’ti? Āmantā.", [("Nanu vuttaṃ bhagavatā – ‘‘atthi puggalo attahitāya paṭipanno’’ti", "yes", "cite")]),
]
HEADS = [
    ('<p rend="chapter">1. Puggalakathā</p>', "1. Puggalakathā", ("debate", 1, "Puggalakathā")),
    ('<p rend="chapter">21. Ekavīsatimavaggo</p>', "21. Ekavīsatimavaggo", ("vagga", 21, "Ekavīsatimavaggo")),
    ('<p rend="subhead">(194) 1. Asañciccakathā</p>', "(194) 1. Asañciccakathā", ("debate", 194, "Asañciccakathā")),
    ('<p rend="title">1. Suddhasaccikaṭṭho</p>', "1. Suddhasaccikaṭṭho", None),
    ('<p rend="title">(12) 3. Kaṅkhākathā</p>', "(12) 3. Kaṅkhākathā", ("debate", 12, "Kaṅkhākathā")),
    ('<p rend="subhead">(188) 3 Sāmaññaphalakathā</p>', "(188) 3 Sāmaññaphalakathā", ("debate", 188, "Sāmaññaphalakathā")),
    ('<p rend="subhead">(212-4) 5-7. Tissopikathā</p>', "(212-4) 5-7. Tissopikathā", ("debate", 212, "Tissopikathā", 214)),
]


def selftest():
    bad = 0
    for text, want in CASES:
        got = questions(text)
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", text[:70], "" if ok else f"\n    want {want}\n    got  {got}")
    for raw, p, want in HEADS:
        got = heading(raw, p)
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", "heading", p, "" if ok else f"→ {got}, want {want}")
    wrong = questions(CASES[0][0]) == [("Puggalo upalabbhati saccikaṭṭhaparamatthenāti", "no", "thesis")]
    print("✓" if not wrong else "✗", "the harness FAILS a wrong expectation (a yes read as no)")
    bad += wrong
    n = len(CASES) + len(HEADS) + 1
    print(f"kathavatthu selftest: {n - bad}/{n}")
    return 1 if bad else 0


def validate(path=OUT_JSON):
    d, errs = json.load(open(path, encoding="utf-8")), []
    last_end = 0
    for x in d["debates"]:
        a, b = x["lines"]
        if a <= last_end or b < a:
            errs.append(f"debate {x['n']} lines {a}–{b} out of order")
        last_end = b
        if any(not (a < q[0] <= b) or q[1] not in ("yes", "no") or (len(q) > 2 and q[2] != "cite") for q in x["q"]):
            errs.append(f"debate {x['n']}: a question outside its lines or with an unknown reply")
        t = x["tally"]
        if t["questions"] != len(x["q"]) or t["yes"] + t["no"] != t["questions"] or t["yes"] != sum(1 for q in x["q"] if q[1] == "yes") or t["citations"] != sum(1 for q in x["q"] if len(q) > 2):
            errs.append(f"debate {x['n']}: tally does not match its questions")
        if not x["title"].endswith("kathā"):
            errs.append(f"debate {x['n']}: title {x['title']!r} is not a kathā")
    for e in errs[:10]:
        print("✗", e)
    q = sum(x["tally"]["questions"] for x in d["debates"])
    print(f"kathavatthu validate: {'PASS' if not errs else 'FAIL'} — {len(d['debates'])} debates, {q:,} questions" + (f", {len(errs)} error(s)" if errs else ""))
    return 1 if errs else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    if "--validate" in sys.argv:
        k = sys.argv.index("--validate")
        sys.exit(validate(sys.argv[k + 1] if len(sys.argv) > k + 1 else OUT_JSON))
    digest, debates, private = build()
    js, md = render(digest, debates)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_JSON, js), (OUT_MD, md)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale:
            print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("kathavatthu/ is current"); sys.exit(0)
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from stamped import write_rotating
    for p, t in ((OUT_JSON, js), (OUT_MD, md)):
        r = write_rotating(p, t, "regenerated by `scripts/kathavatthu.py`")
        if r:
            print(f"proof rotated: {r} (logged in TIMESTAMPS.md)")
    if "--private" in sys.argv:
        out = os.path.abspath(sys.argv[sys.argv.index("--private") + 1])
        if out.startswith(REPO + os.sep) or out == REPO:
            sys.exit("refused: --private must lie OUTSIDE this public repository (the questions are running text)")
        os.makedirs(out, exist_ok=True)
        with open(os.path.join(out, "THESES.json"), "w", encoding="utf-8") as f:
            json.dump({"source": {FILE: digest}, "questions": private}, f, ensure_ascii=False, indent=0)
        print(f"private: {len(private):,} questions → {os.path.join(out, 'THESES.json')}")
    print(md.split("\n")[6])
