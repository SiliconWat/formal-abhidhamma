#!/usr/bin/env python3
"""yamaka.py — capture: the Yamaka's QUESTION INDEX, generated from the CST (founder 2026-11-20: "continue"; the Yamaka is regular enough
for a script, and /capture's model readers of all three parts are its cross-check).

  scripts/yamaka.py                 regenerate yamaka/YAMAKA.json and yamaka/YAMAKA.md
  scripts/yamaka.py --check         exit 1 if either generated file differs from what the CST text gives now
  scripts/yamaka.py --private DIR   ALSO write DIR/QUESTIONS.json: each question's own words (PRIVATE; DIR must lie outside this repo)
  scripts/yamaka.py --selftest      the parsing rules on known answers, and a wrong expectation that must FAIL (no CST needed: CI)
  scripts/yamaka.py --validate [f]  the generated JSON alone: books and sections in order, tallies consistent (CI)

WHAT A QUESTION IS. A line opening "(Ka)" or "(Kha)" (after an optional paragraph number) and asking "…?" (with the quotative "ti"
in the analyses, without it in the statement sections). Its ANSWER is either on the
same line after the "?" — Āmantā (yes) · No / Na (no) · Natthi (there is none) · a verb affirming in a tense (Uppajjittha, "it arose") ·
any other word (an answer that qualifies) — or on the following line (an ANALYSIS: "Diṭṭhisaññā saññā, na saññākkhandho …"); in the
statement sections (uddesa) a question is followed by the next question, and has NONE. The index keeps each question's CST line, letter
and answer kind; never its words (terms, numbers and positions only: PREREGISTRATION-2026-09-27b.md §5; the CST is non-commercial, L21).
"""
import hashlib, json, os, re, sys, unicodedata
from collections import Counter

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
FILES = ["abh03m4.mul.xml", "abh03m5.mul.xml", "abh03m6.mul.xml"]
OUT_JSON = os.path.join(REPO, "yamaka", "YAMAKA.json")
OUT_MD = os.path.join(REPO, "yamaka", "YAMAKA.md")
# The statement sections (uddesa) ask WITHOUT the quotative: "…sabbe te kusalamūlā?" (1,844 such lines were missed when "ti" was required)
QUESTION = re.compile(r"^(?:\d+\.\s*)?\((Ka|Kha)\)\s*(.+?)\?\s*(.*)$")
BOOK = re.compile(r"^(\d+)\.\s*(.+yamakaṃ)\s*$")
YES, NO, NONE_ = {"āmantā"}, {"no", "na"}, {"natthi"}
VERB = re.compile(r"^(uppajj|nirujjh|uppann|niruddh)")
KINDS = ["yes", "no", "none-exists", "verb", "inline-qualified", "analysis", "unanswered", "elided"]
# A body line opening (Ka)/(Kha) with NO question mark: the text abbreviates it ("(Kha) yassa vā pana ghānāyatanaṃ…pe….") — kept as
# "elided", a question whose words and answer the text does not give in full (15 lines, 2026-11-20).
ELIDED = re.compile(r"^(?:\d+\.\s*)?\((Ka|Kha)\)\s*(.+)$")


def nfc(s):
    return unicodedata.normalize("NFC", s)


def read(name):
    b = open(os.path.join(CST, name), "rb").read()
    return nfc(b.decode("utf-16")).splitlines(), hashlib.sha256(b).hexdigest()


def plain(raw):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", re.sub(r"<pb\b[^>]*/>", "", re.sub(r"<note>.*?</note>", "", raw)))).strip()


def inline_kind(rest):
    """The kind of an answer given on the question's own line, from its first word (None if nothing follows)."""
    w = nfc(re.split(r"[\s.,;…]+", rest.strip())[0]).lower() if rest.strip() else ""
    if not w:
        return None
    if w in YES:
        return "yes"
    if w in NO:
        return "no"
    if w in NONE_:
        return "none-exists"
    if VERB.match(w):
        return "verb"
    return "inline-qualified"


QMARK = re.compile(r"\?")
LETTER = re.compile(r"\((Ka|Kha)\)")


def questions_in(p):
    """[(letter, clause, answer text)] for every question in one body line. A question is a clause ending "…ti?" — or, on a line that
    opens with (Ka)/(Kha), its first "?" (the statement sections ask without "ti"). Pairs are often UNLETTERED ("Yassa … anusetīti?
    Āmantā. Yassa vā pana … anusetīti?"): the letter is kept when the text gives one, "-" otherwise (2026-11-20: a reader found 536
    such questions in part 2 that the letter-only rule missed)."""
    out, start = [], 0
    opens = re.match(r"^(?:\d+\.\s*)?\((Ka|Kha)\)", p)
    marks = [m.start() for m in QMARK.finditer(p)]
    for n, pos in enumerate(marks):
        clause = p[start:pos]
        # EVERY "?" in the Yamaka's body ends a question: its answers carry none. Measured 2026-11-20 against two model readers: "…ti?",
        # "…ti…?", and the letterless statement questions ("Sotaṃ sotindriyaṃ? Indriyā cakkhundriyaṃ?") all ask.
        letters = LETTER.findall(clause)
        nxt = marks[n + 1] if n + 1 < len(marks) else len(p)
        answer = p[pos + 1:nxt]
        # the answer runs to the sentence end; a following question starts after it
        cut = re.search(r"[.!]\s", answer)
        if not cut and n + 1 < len(marks):
            # no sentence end before the next "?": the text between is the NEXT question, so this one has no answer of its own
            # ("Sotaṃ sotindriyaṃ? Indriyā cakkhundriyaṃ?") — or shares an elided one ("…nirodhasaccanti?…Pe… …maggasaccanti? Āmantā.")
            answer = "…" if answer.lstrip().startswith("…") else ""
        out.append((letters[-1] if letters else "-", re.sub(r"^(?:\d+\.\s*)?(?:\((?:Ka|Kha)\)\s*)?", "", clause.strip()), answer[: cut.start() + 1] if cut else answer))
        start = pos + 1 + (cut.end() if cut else 0)  # no sentence end: the next question starts right after this "?"
    return out


def scan(lines):
    """[(line, letter, kind, question words)] for one file's plain lines (1-based), plus the book and section headings."""
    out, heads = [], []
    items = [(i, raw, plain(raw)) for i, raw in enumerate(lines, 1)]
    items = [x for x in items if x[2]]
    for k, (i, raw, p) in enumerate(items):
        m = re.search(r'<(?:p|head)\s+rend="([^"]+)"', raw)
        rend = m.group(1) if m else ""
        if rend in ("chapter", "title", "subhead"):
            b = BOOK.match(p) if rend == "chapter" else None
            heads.append([i, "book" if b else rend, p])
            continue
        qs = questions_in(p) if rend not in ("centre",) else []
        if not qs:
            e = ELIDED.match(p) if rend == "bodytext" else None
            if e:
                # "…ti. Āmantā." — a full stop where the question mark belongs (4 lines): answered like any other
                # …or an elided question still answered on its line: "(Kha) yassa vā pana…pe…. Āmantā."
                t = re.search(r"ti\.\s+(\S+)", e.group(2)) or re.search(r"…\.\s+(\S+?)\.?$", e.group(2))
                kind = inline_kind(t.group(1)) if t else None
                out.append((i, e.group(1), kind if kind in ("yes", "no", "none-exists") else "elided", e.group(2)))
            continue
        for n, (letter, clause, answer) in enumerate(qs):
            # "…ti?…Pe… …ti? Āmantā.": a series the text ELIDES, one answer for all
            kind = "elided" if answer.lstrip().startswith("…") else inline_kind(answer)
            if kind is None:  # nothing after the "?": the next line answers it (an analysis), or it is the next question / a heading
                if n < len(qs) - 1:
                    kind = "unanswered"
                else:
                    nxt = items[k + 1] if k + 1 < len(items) else None
                    if nxt is None:
                        kind = "unanswered"
                    else:
                        nm = re.search(r'<(?:p|head)\s+rend="([^"]+)"', nxt[1])
                        kind = "unanswered" if (questions_in(nxt[2]) or (nm and nm.group(1) in ("chapter", "title", "subhead", "centre"))) else "analysis"
                        one = inline_kind(nxt[2]) if len(nxt[2].split()) <= 2 else None
                        if kind == "analysis" and one in ("yes", "no", "none-exists"):
                            kind = one  # the next line is a single answer word ("Āmantā."), not an analysis
            out.append((i, letter, kind, clause))
    return out, heads


def build():
    sources, books, private = {}, [], []
    for f in FILES:
        L, digest = read(f)
        sources[f] = digest
        qs, heads = scan(L)
        bk = [h for h in heads if h[1] == "book"]
        for j, h in enumerate(bk):
            g = BOOK.match(h[2])
            end = bk[j + 1][0] if j + 1 < len(bk) else len(L) + 1
            mine = [q for q in qs if h[0] < q[0] < end]
            t = Counter(q[2] for q in mine)
            books.append({"n": int(g.group(1)), "title": g.group(2), "file": f, "lines": [h[0], end - 1],
                          "sections": [[s[0], s[1], s[2]] for s in heads if h[0] < s[0] < end and s[1] != "book"],
                          "q": [[q[0], q[1], q[2]] for q in mine],
                          "tally": {"questions": len(mine), "ka": sum(1 for q in mine if q[1] == "Ka"), **{k: t[k] for k in KINDS}}})
            private += [{"book": int(g.group(1)), "file": f, "line": q[0], "letter": q[1], "kind": q[2], "question": q[3]} for q in mine]
    return sources, books, private


def render(sources, books):
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from credit import CST as CREDIT
    js = ['{"generated_by": "scripts/yamaka.py", "rule": "terms, numbers and positions only; the questions\' words are not here",',
          ' "sources": ' + json.dumps(sources) + ",", ' "credit": ' + json.dumps(CREDIT, ensure_ascii=False) + ",", ' "kinds": ' + json.dumps(KINDS) + ",", ' "books": [']
    js += ["  " + json.dumps(b, ensure_ascii=False) + ("," if k < len(books) - 1 else "") for k, b in enumerate(books)]
    js += [" ]}"]
    tot = Counter()
    for b in books:
        tot.update({k: v for k, v in b["tally"].items() if k != "ka"})
    md = ["# YAMAKA — the question index, as generated data", "",
          "*GENERATED by `scripts/yamaka.py` from the local Chaṭṭha Saṅgāyana text — never edit by hand. Terms, numbers and positions only",
          "(PREREGISTRATION-2026-09-27b.md §5): each of the ten books' CST lines and section headings, and the CST line, letter ((Ka)/(Kha), or `-`",
          "where the text gives none: many pairs are written *Yassa … ti? … Yassa vā pana … ti?*) and",
          "answer kind of every question. The questions' own words are not here. The data is `YAMAKA.json`.*", "",
          f"**{len(books)} books · {tot['questions']:,} questions** — " + " · ".join(f"{k} {tot[k]:,}" for k in KINDS) + ".", "",
          "Answer kinds: **yes** *Āmantā* · **no** *No / Na* · **none-exists** *Natthi* · **verb** a verb affirming in a tense (*Uppajjittha*,",
          "it arose) · **inline-qualified** another word after the *?* · **analysis** the answer is the following line (*Diṭṭhisaññā saññā, na",
          "saññākkhandho …*) · **unanswered** the next line is another question or a heading (the statement sections, *uddesa*) · **elided** the",
          "text abbreviates the question (*…pe…*, no question mark), so its answer is not given.", "",
          "| No. | Book | File | CST lines | Questions | " + " | ".join(KINDS) + " |", "|---|---|---|---|---|" + "---|" * len(KINDS)]
    for b in books:
        md.append(f"| {b['n']} | {b['title']} | `{b['file']}` | {b['lines'][0]}–{b['lines'][1]} | {b['tally']['questions']:,} | " + " | ".join(f"{b['tally'][k]:,}" for k in KINDS) + " |")
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


CASES = [  # (lines as (rend, text), expected [(letter, kind)])
    ([("bodytext", "1. (Ka) ye keci kusalā dhammā, sabbe te kusalamūlāti? Āmantā."), ("bodytext", "(Kha) ye vā pana kusalamūlā, sabbe te dhammā kusalāti? Āmantā.")],
     [("Ka", "yes"), ("Kha", "yes")]),
    ([("bodytext", "(Ka) saññā saññākkhandhoti?"), ("bodytext", "Diṭṭhisaññā saññā, na saññākkhandho. Saññākkhandho saññā ceva saññākkhandho ca.")],
     [("Ka", "analysis")]),
    ([("bodytext", "(Ka) rūpaṃ rūpakkhandhoti?"), ("bodytext", "(Kha) rūpakkhandho rūpanti?"), ("subhead", "(2) Niddeso")],
     [("Ka", "unanswered"), ("Kha", "unanswered")]),
    ([("bodytext", "(Ka) yassa cittaṃ uppajjati tassa cittaṃ nirujjhissatīti? No.")], [("Ka", "no")]),
    ([("bodytext", "(Kha) yattha anusayo natthi tattha saṅkhārā natthīti? Natthi.")], [("Kha", "none-exists")]),
    ([("bodytext", "(Ka) yassa cittaṃ na uppajjittha tassa cittaṃ na uppajjatīti? Uppajjittha.")], [("Ka", "verb")]),
    ([("bodytext", "(Ka) yattha rūpaṃ tattha vedanāti? Kāmadhātuyā.")], [("Ka", "inline-qualified")]),
    ([("bodytext", "1. (Ka) ye keci kusalā dhammā, sabbe te kusalamūlā?"), ("bodytext", "(Kha) ye vā pana kusalamūlā, sabbe te dhammā kusalā?")],
     [("Ka", "unanswered"), ("Kha", "unanswered")]),
    ([("subhead", "(Ka) uddeso")], []),
    ([("bodytext", "(Kha) yassa vā pana ghānāyatanaṃ…pe….")], [("Kha", "elided")]),
    ([("bodytext", "Yassa kāmarāgānusayo anuseti tassa paṭighānusayo anusetīti? Āmantā."),
      ("bodytext", "Yassa vā pana paṭighānusayo anuseti tassa kāmarāgānusayo anusetīti? No.")], [("-", "yes"), ("-", "no")]),
    ([("bodytext", "Yattha rūpaṃ tattha vedanāti? Āmantā. Yattha vedanā tattha rūpanti? Natthi.")], [("-", "yes"), ("-", "none-exists")]),
    ([("bodytext", "36. (Ka) na saṅkhārā na saṅkhārakkhandhoti. Āmantā.")], [("Ka", "yes")]),
    ([("bodytext", "Na saccā na nirodhasaccanti?…Pe… na saccā na maggasaccanti? Āmantā.")], [("-", "elided"), ("-", "yes")]),
    ([("bodytext", "5. Sotaṃ sotindriyaṃ? Indriyā cakkhundriyaṃ?…Pe….")], [("-", "unanswered"), ("-", "elided")]),
    ([("bodytext", "(Kha) yassa vā pana…pe…. Āmantā.")], [("Kha", "yes")]),
    ([("bodytext", "Āmantā.…Pe… mano… dhammo āyatananti?"), ("bodytext", "Āmantā.")], [("-", "yes")]),
]


def selftest():
    bad = 0
    for lines, want in CASES:
        raw = [f'<p rend="{r}">{t}</p>' for r, t in lines]
        got = [(q[1], q[2]) for q in scan(raw)[0]]
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", lines[0][1][:70], "" if ok else f"\n    want {want}\n    got  {got}")
    wrong = [(q[1], q[2]) for q in scan([f'<p rend="bodytext">{CASES[0][0][0][1]}</p>'])[0]] == [("Ka", "no")]
    print("✓" if not wrong else "✗", "the harness FAILS a wrong expectation (Āmantā read as no)")
    bad += wrong
    n = len(CASES) + 1
    print(f"yamaka selftest: {n - bad}/{n}")
    return 1 if bad else 0


def validate(path=OUT_JSON):
    d, errs = json.load(open(path, encoding="utf-8")), []
    if [b["n"] for b in d["books"]] != list(range(1, 11)):
        errs.append("the books are not 1–10 in order")
    for b in d["books"]:
        a, z = b["lines"]
        if any(not (a < q[0] <= z) or q[1] not in ("Ka", "Kha", "-") or q[2] not in d["kinds"] for q in b["q"]):
            errs.append(f"book {b['n']}: a question outside its lines, or an unknown letter or kind")
        if any(x[0] > y[0] for x, y in zip(b["q"], b["q"][1:])):  # a line may hold several questions
            errs.append(f"book {b['n']}: questions out of line order")
        t = b["tally"]
        if t["questions"] != len(b["q"]) or sum(t[k] for k in d["kinds"]) != t["questions"] or t["ka"] != sum(1 for q in b["q"] if q[1] == "Ka"):
            errs.append(f"book {b['n']}: tally does not match its questions")
        if not b["title"].endswith("yamakaṃ"):
            errs.append(f"book {b['n']}: title {b['title']!r}")
    for e in errs[:10]:
        print("✗", e)
    q = sum(b["tally"]["questions"] for b in d["books"])
    print(f"yamaka validate: {'PASS' if not errs else 'FAIL'} — {len(d['books'])} books, {q:,} questions" + (f", {len(errs)} error(s)" if errs else ""))
    return 1 if errs else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    if "--validate" in sys.argv:
        k = sys.argv.index("--validate")
        sys.exit(validate(sys.argv[k + 1] if len(sys.argv) > k + 1 else OUT_JSON))
    sources, books, private = build()
    js, md = render(sources, books)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_JSON, js), (OUT_MD, md)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale:
            print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("yamaka/ is current"); sys.exit(0)
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from stamped import write_rotating
    for p, t in ((OUT_JSON, js), (OUT_MD, md)):
        r = write_rotating(p, t, "regenerated by `scripts/yamaka.py`")
        if r:
            print(f"proof rotated: {r} (logged in TIMESTAMPS.md)")
    if "--private" in sys.argv:
        out = os.path.abspath(sys.argv[sys.argv.index("--private") + 1])
        if out.startswith(REPO + os.sep) or out == REPO:
            sys.exit("refused: --private must lie OUTSIDE this public repository (the questions are running text)")
        os.makedirs(out, exist_ok=True)
        with open(os.path.join(out, "QUESTIONS.json"), "w", encoding="utf-8") as f:
            json.dump({"sources": sources, "questions": private}, f, ensure_ascii=False, indent=0)
        print(f"private: {len(private):,} questions → {os.path.join(out, 'QUESTIONS.json')}")
    print(md.split("\n")[6])
