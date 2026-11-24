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
COMMENTARY, COMMENTARY_LINES = "abh03a.att.xml", (1897, 6492)  # the Kathāvatthu-aṭṭhakathā inside the five books' commentary
# The schools the commentary names, by stem → the name kept in the index (terms only). A word counts only when it BEGINS with a stem and
# continues through a compound of stems ("andhakasabbatthikasammitiyabhadrayānikānaṃ"): "bandhako" (binding) contains "andhak", and
# "pubbekatahetuvāda…" (the view that past deeds are the cause) contains "hetuvād" without naming the school.
SCHOOLS = {"pubbaseliy": "Pubbaseliya", "aparaseliy": "Aparaseliya", "paraseliy": "Aparaseliya", "rājagirik": "Rājagirika",
           "siddhatthik": "Siddhatthika", "rājagiriy": "Rājagirika", "sammitiy": "Sammitiya", "samitiy": "Sammitiya", "mahāsaṅghik": "Mahāsaṅghika",
           "mahāsaṃghik": "Mahāsaṅghika", "uttarāpathak": "Uttarāpathaka", "andhak": "Andhaka", "vajjiputtak": "Vajjiputtaka", "vajjiputtiy": "Vajjiputtaka",
           "sabbatthivād": "Sabbatthivāda", "sabbatthik": "Sabbatthivāda", "mahiṃsāsak": "Mahiṃsāsaka", "mahisāsak": "Mahiṃsāsaka",
           "gokulik": "Gokulika", "kassapik": "Kassapika", "bhadrayānik": "Bhadrayānika", "hetuvād": "Hetuvāda", "vetullak": "Vetulyaka",
           "vetulyak": "Vetulyaka", "hemavatik": "Hemavatika", "vājiriy": "Vājiriya", "saṅkantik": "Saṅkantika"}
_STEMS = sorted(SCHOOLS, key=len, reverse=True)


# What may follow the last school in a word: a case ending, alone or with ca / eva / yeva ("andhakānaṃyeva", "pubbaseliyādīnaṃ",
# "sabbatthivādino"). Anything else means the word is not a school name: "andhakārena" is "by darkness" (found 2026-11-20).
_ENDING = re.compile(r"^(|ṃ|naṃ|nañca|nañceva|naññeva|naṃyeva|naṃ?ca|no|na|yo|dayo|dīnaṃ|ca|ceva|va|eva|ti)$")


def schools_in_word(w):
    """The schools a word names: a chain of stems from its first letter, each joined by its stem vowel, ending in a case ending."""
    w, out, i = nfc(w).lower(), [], 0
    while True:
        st = next((x for x in _STEMS if w.startswith(x, i)), None)
        if st is None or (i > 0 and st == "paraseliy" and w[i - 1] not in "aā"):
            break
        out.append(SCHOOLS[st]); i += len(st)
        if i < len(w) and w[i] in "aāio":
            i += 1  # the stem vowel before the next member (or the start of the ending)
    return out if out and _ENDING.match(w[i:]) else []
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


def holders():
    """The commentary's debate sections IN ORDER: [line, name key, [schools in order of first mention]]. Never keyed by name alone:
    names repeat (two Maggakathā, two Tissopikathā), and a name-keyed map merged the second section's schools into the first (found by
    the cross-check with /capture's readers, 2026-11-20)."""
    b = open(os.path.join(CST, COMMENTARY), "rb").read()
    L = nfc(b.decode("utf-16")).splitlines()
    out, cur = [], None
    for i in range(COMMENTARY_LINES[0], COMMENTARY_LINES[1] + 1):
        raw = L[i - 1]; p = plain(raw)
        if not p:
            continue
        m = re.search(r'<(?:p|head)\s+rend="([^"]+)"', raw)
        rend = m.group(1) if m else ""
        h = re.match(r"^\d+(?:[-–]\d+)?\.\s*(.+?kathā)(?:vaṇṇanā)?\s*$", p)
        if rend in ("chapter", "subhead") and h:
            cur = [i, name_key(h.group(1)), [], {}]; out.append(cur)
            continue
        if cur is None:
            continue
        for sentence in re.split(r"(?<=[.?!])\s+", p):
            words = re.findall(r"[^\s,.;:–—‘’“”?!()]+", sentence)
            # "Andhakā nāma pubbaseliyā, aparaseliyā, …" DEFINES the Andhakas: the schools after "X nāma" are its members, not holders
            k = next((n for n in range(len(words) - 1) if schools_in_word(words[n]) and nfc(words[n + 1]).lower() == "nāma"), None)
            if k is not None:  # kept, as the group's MEMBERS: a reader may fairly count them as holders (Opus did, 2026-11-20)
                group = schools_in_word(words[k])[0]
                members = [m for w in words[k + 2:] for m in schools_in_word(w) if m != group]
                cur[3].setdefault(group, [])
                cur[3][group] += [m for m in members if m not in cur[3][group]]
            for n, w in enumerate(words if k is None else words[:k + 1]):
                for sc in schools_in_word(w):
                    if sc not in cur[2]:
                        cur[2].append(sc)
    return out, hashlib.sha256(b).hexdigest()


def name_key(t):
    """A debate's name for joining text to commentary: lower case, no spaces, and "…ādikathā" ≡ "…kathā" (220–224: the root text says
    Issariyakāmakārikādikathā, the commentary Issariyakāmakārikākathā)."""
    k = re.sub(r"\s+", "", nfc(t).lower())
    return re.sub(r"ādikathā$", "ākathā", k)


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
    H, hdigest = holders()
    used = set()  # indices into H
    def take(d, j):
        d["commentary_line"], d["holders"] = H[j][0], H[j][2]; used.add(j)
        if H[j][3]:
            d["holder_members"] = H[j][3]  # "Andhakā nāma pubbaseliyā, …": the group named, and the schools it is made of
    for d in debates:  # exact names, each debate taking the FIRST unused section of its name (both lists are in text order)
        k = name_key(d["title"])
        j = next((j for j, sec in enumerate(H) if sec[1] == k and j not in used), None)
        if j is not None:
            take(d, j)
    # Second pass, spelling variants only (dussilya/dussīlya, sīlehi/sīlehīti): an unjoined debate takes an unused section whose name is
    # near-identical with diacritics removed (≥ 0.88), and only when that section is the single best match. Loose or in-order matching was
    # tried and refused: one wrong early pair shifts every later one.
    import difflib
    bare = lambda k: re.sub("[\u0300-\u036f]", "", unicodedata.normalize("NFD", k))
    global COMMENTARY_FUZZY
    COMMENTARY_FUZZY = []
    for d in debates:
        if "commentary_line" in d:
            continue
        kd = bare(name_key(d["title"]))
        scored = sorted(((difflib.SequenceMatcher(None, kd, bare(sec[1])).ratio(), j) for j, sec in enumerate(H) if j not in used), reverse=True)
        # 0.9, not 0.88: at 0.88 "Aññāṇakathā" (ignorance) took "saññojanakathā" (fetters) — checked by hand 2026-11-20
        if scored and scored[0][0] >= 0.9 and (len(scored) == 1 or scored[1][0] < scored[0][0]):
            j = scored[0][1]; take(d, j); COMMENTARY_FUZZY.append((d["n"], d["title"], H[j][1], round(scored[0][0], 2)))
    # Third pass: the commentary's name is the debate's name with a PREFIX ("samāpanno" + "saddaṃ suṇātīti"), and only one section fits.
    for d in debates:
        if "commentary_line" in d:
            continue
        kd = bare(name_key(d["title"]))
        fits = [j for j, sec in enumerate(H) if j not in used and bare(sec[1]).endswith(kd) and len(kd) >= 10]
        if len(fits) == 1:
            j = fits[0]; take(d, j); COMMENTARY_FUZZY.append((d["n"], d["title"], H[j][1], "suffix"))
    global COMMENTARY_UNMATCHED
    COMMENTARY_UNMATCHED = [H[j][1] for j in range(len(H)) if j not in used]
    digest = {FILE: digest, COMMENTARY: hdigest}
    for d in debates:
        d["paragraphs"] = [min(d["paragraphs"]), max(d["paragraphs"])] if d["paragraphs"] else []
        c = Counter(q[1] for q in d["q"])
        d["tally"] = {"questions": len(d["q"]), "yes": c["yes"], "no": c["no"], "citations": sum(1 for q in d["q"] if len(q) > 2)}
    return digest, debates, private


def render(digest, debates):
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from credit import CST as CREDIT
    js = ['{"generated_by": "scripts/kathavatthu.py", "rule": "terms, numbers and positions only; who held each view is a separate capture",',
          ' "source": ' + json.dumps(digest, ensure_ascii=False) + ",", ' "credit": ' + json.dumps(CREDIT, ensure_ascii=False) + ",", ' "debates": [']
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
          f"**Who held each view** comes from the commentary (`{COMMENTARY}` L{COMMENTARY_LINES[0]}–{COMMENTARY_LINES[1]}), joined to {sum(1 for d in debates if 'commentary_line' in d)} of the {len(debates)} debates by name",
          f"({len(COMMENTARY_FUZZY)} by a spelling variant or a prefix, each checked by hand); {sum(1 for d in debates if d.get('holders'))} name at least one school. A school counts",
          "only where a word BEGINS with its name and ends in a case ending (so *bandhako*, binding, and *andhakārena*, by darkness, are not the",
          "Andhakas); where the commentary DEFINES a group (*Andhakā nāma pubbaseliyā, …*), the members are given in brackets. The commentary may",
          "also name a school holding a NEIGHBORING view (*Sā ca laddhi andhakānañceva sammitiyānañca. Ayaṃ andhakānaṃyeva*): such a mention",
          "is kept, and is the one disagreement left with a reader of the whole commentary. Unjoined debates: " + ", ".join(str(d["n"]) for d in debates if "commentary_line" not in d) + ".", "",
          "| No. | Debate | Chapter | CST lines | Paragraphs | Questions | Yes | No | Citing scripture | Held by (commentary) |", "|---|---|---|---|---|---|---|---|---|---|"]
    for d in debates:
        par = f"§{d['paragraphs'][0]}–{d['paragraphs'][1]}" if d["paragraphs"] else ""
        md.append(f"| {d['n']}{'–' + str(d['n_last']) if 'n_last' in d else ''} | {d['title']} | {d['vagga']} | {d['lines'][0]}–{d['lines'][1]} | {par} | {d['tally']['questions']} | {d['tally']['yes']} | {d['tally']['no']} | {d['tally']['citations']} | {', '.join(h + (' (= ' + ', '.join(d['holder_members'][h]) + ')' if h in d.get('holder_members', {}) else '') for h in d.get('holders', [])) if 'commentary_line' in d else '(not joined)'} |")
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


CASES = [
    ("1. Puggalo upalabbhati saccikaṭṭhaparamatthenāti? Āmantā.", [("Puggalo upalabbhati saccikaṭṭhaparamatthenāti", "yes", "thesis")]),
    ("Yo saccikaṭṭho paramattho, tato so puggalo upalabbhatīti? Na hevaṃ vattabbe…pe….", [("Yo saccikaṭṭho paramattho, tato so puggalo upalabbhatīti", "no", "thesis")]),
    ("Atthi lokiyā saddhāti? Āmantā. Atthi lokiyaṃ saddhindriyanti? Na hevaṃ vattabbe.", [("Atthi lokiyā saddhāti", "yes", "thesis"), ("Atthi lokiyaṃ saddhindriyanti", "no", "thesis")]),
    ("Ājānāhi niggahaṃ. Hañci puggalo upalabbhati, tena vata re vattabbe.", []),
    ("Nanu vuttaṃ bhagavatā – ‘‘sabbe dhammā anattā. Iti passathā’’ti? Āmantā.", [("Nanu vuttaṃ bhagavatā – ‘‘sabbe dhammā anattā. Iti passathā’’ti", "yes", "cite")]),
    ("Nanu vuttaṃ bhagavatā – ‘‘atthi puggalo attahitāya paṭipanno’’ti? Āmantā.", [("Nanu vuttaṃ bhagavatā – ‘‘atthi puggalo attahitāya paṭipanno’’ti", "yes", "cite")]),
]
WORDS = [("andhakasabbatthikasammitiyabhadrayānikānaṃ", ["Andhaka", "Sabbatthivāda", "Sammitiya", "Bhadrayānika"]),
         ("pubbaseliyāparaseliyānaṃ", ["Pubbaseliya", "Aparaseliya"]), ("uttarāpathakānaṃyeva", ["Uttarāpathaka"]),
         ("sabbatthivādino", ["Sabbatthivāda"]), ("vajjiputtakā", ["Vajjiputtaka"]), ("rājagiriyā", ["Rājagirika"]), ("sammitiyādayo", ["Sammitiya"]),
         ("bandhako", []), ("andhakārena", []), ("pubbekatahetuvādabhayena", [])]
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
    for w, want in WORDS:
        got = schools_in_word(w)
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", "schools in", w, "" if ok else f"→ {got}, want {want}")
    for raw, p, want in HEADS:
        got = heading(raw, p)
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", "heading", p, "" if ok else f"→ {got}, want {want}")
    wrong = questions(CASES[0][0]) == [("Puggalo upalabbhati saccikaṭṭhaparamatthenāti", "no", "thesis")]
    print("✓" if not wrong else "✗", "the harness FAILS a wrong expectation (a yes read as no)")
    bad += wrong
    n = len(CASES) + len(WORDS) + len(HEADS) + 1
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
    cl = [x["commentary_line"] for x in d["debates"] if "commentary_line" in x]
    if any(a >= b for a, b in zip(cl, cl[1:])):
        errs.append("the commentary join is out of text order (a section given to two debates, or a later debate an earlier section)")
    known = set(SCHOOLS.values())
    for x in d["debates"]:
        if any(h not in known for h in x.get("holders", [])):
            errs.append(f"debate {x['n']}: an unknown school name")
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
