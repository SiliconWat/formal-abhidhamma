#!/usr/bin/env python3
"""patthana.py — capture: the Paṭṭhāna's stated COUNTS, GENERATED from the CST (founder 2026-11-19: "yes" to writing the
Paṭṭhāna scripts, the count-dense part a model reader could not finish on its credit).

  scripts/patthana.py            regenerate patthana/PATTHANA.json and patthana/PATTHANA.md from the local CST text
  scripts/patthana.py --check    exit 1 if either generated file differs from what the CST text gives now
  scripts/patthana.py --unknown  print, locally, every word of a count line this script could not classify (never written out)
  scripts/patthana.py --selftest the parsing rules on known answers, and one wrong expectation that must FAIL (no CST needed: CI)
  scripts/patthana.py --validate [file]   the generated JSON alone: 24 conditions, well-formed counts, positions in order (CI)

WHAT A COUNT LINE IS. The numerical sections (saṅkhyāvāra) state, for each condition, how many of the questions it answers:
"Hetuyā nava, ārammaṇe tīṇi, …" (pure), "Hetupaccayā ārammaṇe tīṇi, …" (with a root condition in front: ekamūlaka and beyond),
"Nahetuyā dve, …" (negative), "Hetupaccayā naārammaṇe tīṇi …" (mixed). Every word is classified: a condition (by its surface form:
the counted form "hetuyā" / "ārammaṇe" or the root form "hetupaccayā", positive or with "na"/"no"), a number word, an elision
(…pe…), or UNKNOWN. A number closes the run of conditions before it, so "anantare samanantare … dasa" gives each the same count
(marked `shared`). A line is a count line when it has at least one condition → number pair and few unknown words.

WHAT IS WRITTEN OUT. Terms, numbers and positions only (PREREGISTRATION-2026-09-27b.md §5; the CST is non-commercial, legal L21):
for each count line its file and CST line, the root conditions, and each (condition, polarity, value, flags); the headings (rend,
line, the heading's words) so the structure can be rebuilt from line order; and the text's own abridgment notes as FLAGS only
("sabbattha N" → the number N, "saṃkhittaṃ" → abridged). Unknown words are COUNTED, never written. Variant readings (<note>) are
dropped whole (the matika.py correction of 2026-11-18).

THE COUNTS ARE A TEST BANK, never premises (kala/ANSWERS.md): a rung that derives them must not be built by whoever reads them.
Cross-check: MA's /capture read Paṭṭhāna parts 1–3 with a model reader; where the two instruments differ, one of them is wrong.
"""
import hashlib, json, os, re, sys, unicodedata
from collections import Counter

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
FILES = ["abh03m7.mul.xml", "abh03m8.mul.xml", "abh03m9.mul.xml", "abh03m10.mul.xml", "abh03m11.mul.xml"]
OUT_JSON = os.path.join(REPO, "patthana", "PATTHANA.json")
OUT_MD = os.path.join(REPO, "patthana", "PATTHANA.md")
HEADS = ("nikaya", "book", "chapter", "title", "subhead")

# The 24 conditions in the uddesa's order: (name, counted form). The root form is name + "paccayā".
CONDITIONS = [("hetu", "hetuyā"), ("ārammaṇa", "ārammaṇe"), ("adhipati", "adhipatiyā"), ("anantara", "anantare"),
              ("samanantara", "samanantare"), ("sahajāta", "sahajāte"), ("aññamañña", "aññamaññe"), ("nissaya", "nissaye"),
              ("upanissaya", "upanissaye"), ("purejāta", "purejāte"), ("pacchājāta", "pacchājāte"), ("āsevana", "āsevane"),
              ("kamma", "kamme"), ("vipāka", "vipāke"), ("āhāra", "āhāre"), ("indriya", "indriye"), ("jhāna", "jhāne"),
              ("magga", "magge"), ("sampayutta", "sampayutte"), ("vippayutta", "vippayutte"), ("atthi", "atthiyā"),
              ("natthi", "natthiyā"), ("vigata", "vigate"), ("avigata", "avigate")]
FORMS = {}  # surface form → (condition, polarity "+"/"-", kind "count"/"root")
for name, loc in CONDITIONS:
    for form, kind in ((loc, "count"), (name + "paccayā", "root")):
        FORMS[form] = (name, "+", kind)
        for neg in ("na", "no"):  # "nahetuyā", "naārammaṇe" · "noatthiyā", "nonatthiyā", "novigate", "noavigate"
            FORMS.setdefault(neg + form, (name, "-", kind))

NUMBERS = {}
for w, v in [("ekaṃ", 1), ("eka", 1), ("eko", 1), ("ekā", 1), ("dve", 2), ("tīṇi", 3), ("cattāri", 4), ("pañca", 5), ("cha", 6), ("satta", 7),
             ("aṭṭha", 8), ("nava", 9), ("dasa", 10), ("ekādasa", 11), ("dvādasa", 12), ("bārasa", 12), ("terasa", 13), ("cuddasa", 14),
             ("catuddasa", 14), ("pannarasa", 15), ("pañcadasa", 15), ("soḷasa", 16), ("sattarasa", 17), ("aṭṭhārasa", 18)]:
    NUMBERS[w] = v
_UNITS = [("ekūna", -1), ("", 0), ("eka", 1), ("dvā", 2), ("bā", 2), ("te", 3), ("catu", 4), ("pañca", 5), ("cha", 6), ("satta", 7), ("aṭṭha", 8)]
for tens, v in [("vīsa", 20), ("vīsati", 20), ("tiṃsa", 30), ("ttiṃsa", 30), ("tiṃsati", 30), ("cattālīsa", 40), ("cattārīsa", 40), ("paññāsa", 50)]:
    for u, d in _UNITS:
        NUMBERS.setdefault(u + tens, v + d)
NUMBERS.update({"chabbīsa": 26, "chabbīsati": 26, "dvattiṃsa": 32, "bāttiṃsa": 32, "tettiṃsa": 33, "catuttiṃsa": 34, "chattiṃsa": 36})
NUMBERS.pop("ttiṃsa", None)


def nfc(s):
    return unicodedata.normalize("NFC", s)


def read(name):
    b = open(os.path.join(CST, name), "rb").read()
    return nfc(b.decode("utf-16")).splitlines(), hashlib.sha256(b).hexdigest()


def plain(raw):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", re.sub(r"<pb\b[^>]*/>", "", re.sub(r"<note>.*?</note>", "", raw)))).strip()


NAMES = {name: [name] for name, _ in CONDITIONS}
NAMES["hetādhipati"] = ["hetu", "adhipati"]  # hetu + adhipati joined by sandhi (abh03m7.mul.xml:8205)


def compound_roots(w):
    """The pañhāvāra states its root conditions as ONE hyphenated compound with the quotative: "upanissaya-anantara-…-vigatanti"."""
    if "-" not in w:
        return None
    parts, out = w.split("-"), []
    for k, part in enumerate(parts):
        cands = [part] + ([part[:-3], part[:-2]] if k == len(parts) - 1 else [])  # "vigatanti" → "vigata"; "atthīti" → "atthī"
        hit = next((NAMES[c] for c in cands if c in NAMES), None)
        if hit is None:
            return None  # one unknown part: not a root compound
        out += hit
    return out


FILLERS = {"sabbe", "sabbattha", "ca", "pañhā", "kātabbā", "kātabbāni", "kātabbaṃ", "gaṇitakena"}  # words a count may carry without changing it:
# "jhāne sabbe dasa" · "tettiṃsa pañhā" · "Idha magge cattāri kātabbāni" (a count in a note, abh03m10.mul.xml:3665, "four are to be made")


def classify(text):
    """The words of one stretch of text, each classified: cond · num · pe · filler · stop (sentence end) · unknown."""
    text = re.sub(r"^\d+\.\s*", "", text)
    text = re.sub(r"\s*-\s*", "-", text)  # "indriya -magga" · "na-ārammaṇe": one word, as the text means it
    # "na anantare", "na jhāne": the negative written with a space (abh03m7.mul.xml:1405) — joined only when the join IS a form
    text = re.sub(r"\b([Nn][ao])\s+(\w+)", lambda m: m.group(1) + m.group(2) if nfc(m.group(1) + m.group(2)).lower() in FORMS else m.group(0), text)
    text = re.sub(r"…\s*pe\s*…|…", " … ", text)
    out, hard = [], []  # hard[k]: punctuation (not just a space) follows token k
    for m in re.finditer(r"([^\s,.;:–—‘’“”?!]+)([\s,.;:–—‘’“”?!]*)", text):
        w, sep = m.group(1), m.group(2)
        lw = nfc(w).lower()
        root = compound_roots(lw)
        if root:
            out += [("cond", (c, "+", "root")) for c in root]
            hard += [False] * (len(root) - 1)
        elif lw == "…":
            out.append(("pe", None))
        elif lw in FORMS or lw.replace("-", "") in FORMS:
            out.append(("cond", FORMS.get(lw) or FORMS[lw.replace("-", "")]))
        elif lw in NUMBERS:
            out.append(("num", NUMBERS[lw]))
        elif lw in FILLERS:
            out.append(("filler", lw))
        else:
            out.append(("unknown", lw))
        hard.append(bool(re.search(r"[,;:–—]", sep)))
        if re.search(r"[–—]", sep):
            out.append(("dash", None)); hard.append(True)  # a dash opens a statement's EXAMPLE ("…vipākapaccayā – ekaṃ mahābhūtaṃ …")
        if re.search(r"[.?!]", sep):
            out.append(("stop", None))  # a root holds only within its sentence ("…uppajjati hetupaccayā. Hetuyā cha…")
            hard[-1] = True; hard.append(True)
    # A counted condition SANDWICHED in prose — an unclassified word right before it and right after its number, no punctuation on
    # either side — is a statement's example, not a count: "…uppajjati navippayuttapaccayā – arūpe vipāke ekaṃ khandhaṃ paṭicca…"
    # (abh03m7.mul.xml:12885, found by the cross-check with /capture's reader). Measured on all five parts 2026-11-19: it removes exactly
    # that pair; its first form also removed a true count in a note (abh03m10.mul.xml:3665), now kept by FILLERS.
    for j in range(1, len(out) - 2):
        if (out[j][0] == "cond" and out[j][1][2] == "count" and out[j - 1][0] == "unknown" and not hard[j - 1]
                and out[j + 1][0] == "num" and not hard[j + 1] and out[j + 2][0] == "unknown"):
            out[j + 1] = ("unknown", "(number in prose)")
    return out


def tokens(text):
    """The line's own words, classified, and each parenthetical note classified apart (a note can state a count:
    "(Naindriyapaccayā kamme satta pañhā.)", abh03m7.mul.xml:10545). Abridgment notes become flags."""
    flags = {"sabbattha": [], "abridged": False}
    notes = []
    for note in re.findall(r"\(([^)]*)\)", text):
        low = nfc(note).lower()
        if "saṃkhitt" in low:
            flags["abridged"] = True
        for m in re.finditer(r"sabbattha\s+(\S+?)[.,;)]*(?:\s|$)", low):
            if m.group(1) in NUMBERS:
                flags["sabbattha"].append(NUMBERS[m.group(1)])
        notes.append(classify(note))
    text = re.sub(r"\([^)]*\)", " ", text)
    if re.search(r"(?i)sabbattha\s+\S", text):
        flags["inline_sabbattha"] = True  # "… avigate sabbattha ekādasa": the number closes the run
    return classify(text), flags, notes


def parse(toks):
    """Segments of root conditions + counts. A number closes the run of counted conditions before it; any other word between a
    condition and its number breaks the run (so prose cannot pass for a count), and a word between a root and its counts drops
    the root (so a statement's "…uppajjati hetupaccayā" cannot become the root of a count)."""
    segs, cur, pending, pe_in_run, elided, dangling, broken, unknown, last = [], None, [], False, False, 0, 0, [], None
    stmt, stopped, tentative = None, False, None  # a statement's condition awaiting its count; a full stop just passed; a statement count on trial
    for kind, val in toks:
        if kind == "filler":
            continue
        if tentative is not None:
            # a statement's count is followed by a stop, an elision or nothing; a NOUN after the number means the number counts the noun
            # ("…vippayuttapaccayā ekaṃ mahābhūtaṃ …", one great element): withdrawn
            if kind == "unknown":
                segs.remove(tentative)
            tentative = None
        if kind == "dash":
            stmt = None
            continue
        if stopped and kind != "num":
            # a full stop ends the sentence: what waited for a number gets none ("Hetuyā. Nava" is the one exception, just below)
            dangling += len(pending); pending = []; stmt = None
        if kind == "stop":
            stopped = True; cur = None; last = kind
            continue
        if kind == "cond" and val[2] == "root" and last == "unknown":
            # a root form right after prose is the STATEMENT's condition ("…dhammo uppajjati hetupaccayā… hetuyā nava"), not the
            # root of the count that follows: real count roots open their sentence or follow a root or an elision. Without this,
            # 902 counts in part 5 were read under their own condition (the validate invariant below), 2026-11-19.
            # Part 5 also states a count WITH its statement: "…uppajjati hetupaccayā… tīṇi" is "Hetuyā tīṇi" for that pair, so the
            # statement's condition waits for the next number (the first only: in "…tīṇi… nava" the nine is an elided condition's).
            cur = None; stmt = val; last = kind; stopped = False
            continue
        if kind == "num" and not pending and stmt is not None:
            tentative = {"root": [], "counts": [[stmt[0], stmt[1], val, "statement"]], "stmt": 1}; segs.append(tentative); stmt = None
            last = kind; stopped = False
            continue
        if kind in ("cond", "unknown"):
            stmt = None
        stopped = False
        if kind == "cond" and val[2] == "root":
            if cur is None or cur["counts"] or pending:
                if pending:
                    dangling += len(pending); pending = []
                cur = {"root": [], "counts": []}; segs.append(cur)
            elif last == "pe" and cur["root"]:
                cur["alt"] = 1  # "Naanantarapaccayā… nasamanantarapaccayā… …": each root ALONE takes the counts that follow
            cur["root"].append([val[0], val[1]])
            last = kind
            continue
        last = kind
        if kind == "cond":
            if cur is None:
                cur = {"root": [], "counts": []}; segs.append(cur)
            if not pending:
                pe_in_run = False
            pending.append(val)
        elif kind == "num":
            if pending:
                if cur is None:  # "Hetuyā. Nava": the number came after a full stop, which closed the segment
                    cur = {"root": [], "counts": []}; segs.append(cur)
                for c in pending:
                    flags = (["shared"] if len(pending) > 1 else []) + (["across-elision"] if pe_in_run else [])
                    cur["counts"].append([c[0], c[1], val] + ([",".join(flags)] if flags else []))
                pending = []
        elif kind == "pe":
            elided = True
            if pending:
                pe_in_run = True
        else:
            unknown.append(val)
            if pending:
                broken += len(pending); pending = []
            if cur is not None and not cur["counts"]:
                cur = None  # prose after a root: the root is not this line's count root
    dangling += len(pending)
    for seg in segs:
        # Several roots whose counts include a root's OWN condition are ALTERNATIVES even with no …pe… between them: a combined root
        # never counts its own members ("Napacchājātapaccayā naāsevanapaccayā … napacchājāte nava", abh03m7.mul.xml:1497).
        if len(seg["root"]) > 1 and not seg.get("alt") and any([c[0], c[1]] in seg["root"] for c in seg["counts"]):
            seg["alt"] = 2
    return [s for s in segs if s["counts"]], elided, dangling, broken, unknown


def line_segments(p):
    """One line's count segments: its own text, then each parenthetical note (those segments carry "note": 1)."""
    toks, flags, notes = tokens(p)
    segs, elided, dangling, broken, unknown = parse(toks)
    for nt in notes:
        for seg in parse(nt)[0]:
            seg["note"] = 1
            segs.append(seg)
    return segs, elided, dangling, broken, unknown, flags


def build():
    sources, heads, lines, unknown_words = {}, [], [], Counter()
    for f in FILES:
        L, digest = read(f)
        sources[f] = digest
        for i, raw in enumerate(L, 1):
            p = plain(raw)
            if not p:
                continue
            m = re.search(r'<(?:p|head)\s+rend="([^"]+)"', raw)
            rend = m.group(1) if m else ""
            if rend in HEADS:
                heads.append([f, i, rend, p])
                continue
            segs, elided, dangling, broken, unknown, flags = line_segments(p)
            if not segs:
                continue  # no condition stated with its number: not a count line
            rec = {"f": f, "l": i, "seg": segs}
            if elided: rec["pe"] = 1
            if flags["abridged"]: rec["abridged"] = 1
            if flags["sabbattha"]: rec["sabbattha"] = flags["sabbattha"]
            if flags.get("inline_sabbattha"): rec["everywhere"] = 1
            if dangling: rec["dangling"] = dangling
            if broken: rec["broken"] = broken
            if unknown: rec["unknown"] = len(unknown); unknown_words.update(unknown)
            lines.append(rec)
    list_sum(lines)
    return sources, heads, lines, unknown_words


def list_sum(lines):
    """The STATEMENT counts tested against the text's own list (founder ruling 2026-11-21, approving the check): a run of lines whose counts
    are all statement counts ("…kusalo … uppajjati hetupaccayā… tīṇi", "…akusalo … tīṇi") is followed by the section's list ("Hetuyā nava").
    Each statement segment is marked `sum`: "agrees" when its run's counts for that condition SUM to the list's count for it, "differs" when
    they do not, "none" when no list follows or the list does not name the condition. AGREES CONFIRMS; DIFFERS NEVER REFUTES — the text writes
    out some statements and elides the rest ("…pe…"), so a run may hold fewer than the list totals."""
    run, f = [], None
    def close(next_list):
        if not run:
            return
        total = Counter()
        for seg in run:
            for c in seg["counts"]:
                total[c[0]] += c[2]
        for seg in run:
            c = seg["counts"][0]
            seg["sum"] = "none" if not next_list or c[0] not in next_list else ("agrees" if next_list[c[0]] == total[c[0]] else "differs")
    for r in lines:
        st = [g for g in r["seg"] if g.get("stmt")]
        ls = {c[0]: c[2] for g in r["seg"] if not g.get("stmt") and not g.get("note") for c in g["counts"]}
        if st and not ls and (f is None or r["f"] == f):
            run += st; f = r["f"]; continue
        close(ls if (ls and r["f"] == f) else None); run, f = [], None
        if st and not ls:
            run, f = st, r["f"]
    close(None)
    for r in lines:  # a statement on a line that ALSO lists counts is in no run: unconfirmed
        for g in r["seg"]:
            if g.get("stmt") and "sum" not in g:
                g["sum"] = "none"


def render(sources, heads, lines):
    js = ['{"generated_by": "scripts/patthana.py", "rule": "terms, numbers and positions only; a TEST BANK, never premises",',
          ' "sources": ' + json.dumps(sources, ensure_ascii=False) + ",",
          ' "conditions": ' + json.dumps([c for c, _ in CONDITIONS], ensure_ascii=False) + ",",
          ' "headings": [']
    js += ["  " + json.dumps(h, ensure_ascii=False) + ("," if k < len(heads) - 1 else "") for k, h in enumerate(heads)]
    js += [" ],", ' "count_lines": [']
    js += ["  " + json.dumps(r, ensure_ascii=False) + ("," if k < len(lines) - 1 else "") for k, r in enumerate(lines)]
    js += [" ]}"]
    by = {f: [r for r in lines if r["f"] == f] for f in FILES}
    pairs = lambda rs: sum(len(s["counts"]) for r in rs for s in r["seg"])
    shared = lambda rs: sum(1 for r in rs for s in r["seg"] for c in s["counts"] if len(c) > 3 and "shared" in c[3])
    vals = Counter(c[2] for r in lines for s in r["seg"] for c in s["counts"])
    md = ["# PAṬṬHĀNA — the stated counts, as generated data", "",
          "*GENERATED by `scripts/patthana.py` from the local Chaṭṭha Saṅgāyana text — never edit by hand. Terms, numbers and positions",
          "only (PREREGISTRATION-2026-09-27b.md §5); variant readings dropped whole; the text's abridgment notes kept as flags. The counts",
          "are a TEST BANK, never premises (`kala/ANSWERS.md`). The data is `PATTHANA.json`; this file summarizes it.*", "",
          f"**{len(lines):,} count lines · {pairs(lines):,} condition counts · {len(heads):,} headings** across the five files.", "",
          f"**Statement counts** (`\"stmt\": 1`): {sum(1 for r in lines for g in r['seg'] if g.get('stmt')):,}; their run SUMS to the section's own list for "
          f"{sum(1 for r in lines for g in r['seg'] if g.get('sum') == 'agrees'):,} (`\"sum\": \"agrees\"` — a confirmation; `differs` never refutes, the text eliding "
          "statements). Which are admitted to the test bank, and by which check, is `STATEMENT-ADMITTED.json` (founder ruling 2026-11-21).", "",
          "| File | Count lines | Counts | Shared by a run | With an elision | Abridged | Lines with unclassified words |",
          "|---|---|---|---|---|---|---|"]
    for f in FILES:
        rs = by[f]
        md.append(f"| `{f}` | {len(rs):,} | {pairs(rs):,} | {shared(rs):,} | {sum(1 for r in rs if r.get('pe')):,} | "
                  f"{sum(1 for r in rs if r.get('abridged')):,} | {sum(1 for r in rs if r.get('unknown')):,} |")
    md += ["", "## How a line reads", "",
           "`{\"f\": file, \"l\": CST line, \"seg\": [{\"root\": [[condition, ±]…], \"counts\": [[condition, ±, value, flags?]…]}]}` — `root` is the",
           "condition(s) the line is stated under (\"Hetupaccayā …\"), empty for the pure count; `±` is the polarity (\"na\"/\"no\" = −); flags:",
           "`shared` (one number closes a run of conditions), `across-elision` (the run crosses …pe…); a segment with `\"alt\": 1` lists roots",
           "separated by …pe… (each ALONE takes the counts, the text abbreviating the repeats); `\"alt\": 2` = alternatives INFERRED because the",
           "counts include a root's own condition (a combined root never counts its members); `\"note\": 1` = stated in a parenthetical",
           "note; `\"stmt\": 1` = a count stated WITH its conditioning statement (\"…uppajjati hetupaccayā… tīṇi\": hetu, 3). Line flags: `pe` (the line elides),",
           "`abridged` (the text says *saṃkhittaṃ*), `sabbattha` (a note says \"everywhere N\": the elided counts are N), `everywhere` (a run closed by *sabbattha N*), `dangling`",
           "(conditions with no number after them), `unknown` (how many words were not classified; they are not written out).", "",
           "## Values stated", "", "| Value | Times |", "|---|---|"]
    md += [f"| {v} | {n:,} |" for v, n in sorted(vals.items())]
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


# Known answers, one per rule above, each a line in the text's own form. (root, [counts]) per segment; a count is "cond±value",
# "*" = shared by a run, "n:" = stated in a note. CHECK: the harness must also FAIL a wrong expectation (the last case).
CASES = [
    ("Hetuyā nava, ārammaṇe tīṇi, adhipatiyā nava.", [("", ["hetu+9", "ārammaṇa+3", "adhipati+9"])]),
    ("Hetupaccayā ārammaṇe tīṇi. Adhipatiyā nava.", [("hetu+", ["ārammaṇa+3"]), ("", ["adhipati+9"])]),  # a root ends with its sentence
    ("Hetupaccayā ārammaṇe tīṇi, adhipatiyā nava.", [("hetu+", ["ārammaṇa+3", "adhipati+9"])]),
    ("Nahetuyā terasa, naārammaṇe naadhipatiyā terasa.", [("", ["hetu-13", "ārammaṇa-13*", "adhipati-13*"])]),
    ("na anantare ekaṃ, no avigate satta.", [("", ["anantara-1", "avigata-7"])]),
    ("Upanissaya-anantara-kamma-natthi-vigatanti nahetuyā ekaṃ.", [("upanissaya+ anantara+ kamma+ natthi+ vigata+", ["hetu-1"])]),
    ("Hetādhipati-sahajāta-atthi-avigatanti naārammaṇe dve.", [("hetu+ adhipati+ sahajāta+ atthi+ avigata+", ["ārammaṇa-2"])]),
    ("Naanantarapaccayā… nasamanantarapaccayā hetuyā pañca.", [("ALT anantara- samanantara-", ["hetu+5"])]),
    ("Hetuyā ekādasa, ārammaṇe adhipatiyā sabbattha ekādasa.", [("", ["hetu+11", "ārammaṇa+11*", "adhipati+11*"])]),
    ("Kusalaṃ dhammaṃ paṭicca kusalo dhammo uppajjati hetupaccayā. Hetuyā cha.", [("", ["hetu+6"])]),
    ("uppajjati navippayuttapaccayā – arūpe vipāke ekaṃ khandhaṃ paṭicca tayo khandhā.", []),
    ("Hetuyā satta (Naindriyapaccayā kamme satta pañhā).", [("", ["hetu+7"]), ("indriya-", ["n:kamma+7"])]),
    ("ārammaṇe vatthu tīṇi.", []),
    ("purejāte ca āsevane ca ekavīsa.", [("", ["purejāta+21*", "āsevana+21*"])]),
    ("Idha magge cattāri kātabbāni.", [("", ["magga+4"])]),
    ("Nacittasaṃsaṭṭhaṃ dhammaṃ paṭicca nacittasaṃsaṭṭho dhammo uppajjati hetupaccayā… hetuyā nava.", [("", ["hetu+9"])]),
    ("Napacchājātapaccayā naāsevanapaccayā nahetuyā dve, napacchājāte nava.", [("ALT pacchājāta- āsevana-", ["hetu-2", "pacchājāta-9"])]),
    ("Kusalaṃ noupādā dhammaṃ paṭicca nakusalo dhammo uppajjati hetupaccayā… tīṇi… nava.", [("", ["s:hetu+3"])]),
    ("Nalokiyaṃ nahetuṃ dhammaṃ paṭicca lokuttaro hetu dhammo uppajjati hetupaccayā. Ekaṃ.", [("", ["s:hetu+1"])]),
    ("Narūpiṃ dhammaṃ paṭicca arūpī dhammo uppajjati hetupaccayā… gaṇitakena tīṇi.", [("", ["s:hetu+3"])]),
    ("Hetuyā. Nava (sabbattha nava.)", [("", ["hetu+9"])]),
    ("Vipākaṃ dhammaṃ paṭicca vipāko dhammo uppajjati vipākapaccayā – ekaṃ mahābhūtaṃ paṭicca tayo mahābhūtā.", []),
    ("Vatthuṃ paṭicca khandhe vippayuttapaccayā ekaṃ mahābhūtaṃ paṭicca tayo mahābhūtā.", []),
]


def summarize(segs):
    out = []
    for seg in segs:
        root = ("ALT " if seg.get("alt") else "") + " ".join(f"{c}{p}" for c, p in seg["root"])
        counts = [("n:" if seg.get("note") else "") + ("s:" if seg.get("stmt") else "") + f"{c[0]}{c[1]}{c[2]}" + ("*" if len(c) > 3 and "shared" in c[3] else "") for c in seg["counts"]]
        out.append((root, counts))
    return out


def selftest():
    bad = 0
    # the list-sum check on a run of its own: 3 + 3 + 3 = Hetuyā nava agrees; 3 + 3 against nava differs; no list after → none
    mk = lambda l, v, stmt=True: {"f": "x", "l": l, "seg": [{"root": [], "counts": [["hetu", "+", v, "statement"]], "stmt": 1}] if stmt else [{"root": [], "counts": [["hetu", "+", v]]}]}
    a = [mk(1, 3), mk(2, 3), mk(3, 3), mk(4, 9, False)]; b = [mk(1, 3), mk(2, 3), mk(4, 9, False)]; c = [mk(1, 3)]
    list_sum(a); list_sum(b); list_sum(c)
    ok = [g["sum"] for r in a[:3] for g in r["seg"]] == ["agrees"] * 3 and [g["sum"] for r in b[:2] for g in r["seg"]] == ["differs"] * 2 and c[0]["seg"][0]["sum"] == "none"
    print("✓" if ok else "✗", "list-sum: a run summing to its list agrees, one short of it differs, one with no list after it is none")
    bad += not ok
    for text, want in CASES:
        got = summarize(line_segments(text)[0])
        ok = got == want
        bad += not ok
        print(("✓" if ok else "✗"), text, "" if ok else f"\n    want {want}\n    got  {got}")
    wrong = summarize(line_segments(CASES[0][0])[0]) == [("", ["hetu+9", "ārammaṇa+3", "adhipati+8"])]
    print(("✓" if not wrong else "✗"), "the harness FAILS a wrong expectation (adhipatiyā nava read as 8)")
    bad += wrong
    print(f"patthana selftest: {len(CASES) + 2 - bad}/{len(CASES) + 2}")
    return 1 if bad else 0


def validate(path=OUT_JSON):
    """The generated JSON alone (CI has no CST): 24 conditions, every count well formed, positions in order."""
    d, errs = json.load(open(path, encoding="utf-8")), []
    names = [c for c, _ in CONDITIONS]
    if d.get("conditions") != names:
        errs.append("the condition list is not the uddesa's 24")
    last = {}
    bad_sum = sum(1 for r in d.get("count_lines", []) for g in r["seg"] if g.get("stmt") and g.get("sum") not in ("agrees", "differs", "none"))
    if bad_sum:
        errs.append(f"{bad_sum} statement count(s) without a list-sum mark (agrees · differs · none)")
    for r in d.get("count_lines", []):
        if r["l"] <= last.get(r["f"], 0):
            errs.append(f"{r['f']}:{r['l']} out of order")
        last[r["f"]] = r["l"]
        if not r["seg"]:
            errs.append(f"{r['f']}:{r['l']} has no segment")
        for seg in r["seg"]:
            for c, pol in seg["root"]:
                if c not in names or pol not in "+-":
                    errs.append(f"{r['f']}:{r['l']} root {c}{pol}")
            roots = {(c, pol) for c, pol in seg["root"]}
            for c in seg["counts"]:
                if c[0] not in names or c[1] not in ("+", "-") or not isinstance(c[2], int) or not 1 <= c[2] <= 99:
                    errs.append(f"{r['f']}:{r['l']} count {c}")
                if len(roots) == 1 and (c[0], c[1]) in roots:  # a SINGLE root never counts its own condition: a parse error
                    errs.append(f"{r['f']}:{r['l']} {c[0]}{c[1]} counted under its own single root")
            if len(roots) > 1 and not seg.get("alt") and any((c[0], c[1]) in roots for c in seg["counts"]):
                errs.append(f"{r['f']}:{r['l']} a combined root counts its own member and is not marked alternative")
    for e in errs[:10]:
        print("✗", e)
    n = sum(len(seg["counts"]) for r in d.get("count_lines", []) for seg in r["seg"])
    print(f"patthana validate: {'PASS' if not errs else 'FAIL'} — {len(d.get('count_lines', [])):,} count lines, {n:,} counts" + (f", {len(errs)} error(s)" if errs else ""))
    return 1 if errs else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    if "--validate" in sys.argv:
        sys.exit(validate(sys.argv[sys.argv.index("--validate") + 1] if len(sys.argv) > sys.argv.index("--validate") + 1 else OUT_JSON))
    sources, heads, lines, unknown_words = build()
    if "--unknown" in sys.argv:
        for w, n in unknown_words.most_common(60):
            print(f"{n:6}  {w}")
        sys.exit(0)
    js, md = render(sources, heads, lines)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_JSON, js), (OUT_MD, md)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale:
            print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("patthana/ is current"); sys.exit(0)
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from stamped import write_rotating
    for p, t in ((OUT_JSON, js), (OUT_MD, md)):
        r = write_rotating(p, t, "regenerated by `scripts/patthana.py`")
        if r:
            print(f"proof rotated: {r} (logged in TIMESTAMPS.md)")
    print(md.split("\n")[6])
