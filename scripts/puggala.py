#!/usr/bin/env python3
"""puggala.py — capture: the Puggalapaññatti's INDEX of person-types, generated from the CST (founder 2026-11-20: "continue capture?";
/capture's model reader of the whole book is the cross-check).

  scripts/puggala.py                 regenerate puggala/PUGGALA.json and puggala/PUGGALA.md
  scripts/puggala.py --check         exit 1 if either generated file differs from what the CST text gives now
  scripts/puggala.py --selftest      the parsing rules on known answers, and a wrong expectation that must FAIL (no CST needed: CI)
  scripts/puggala.py --validate [f]  the generated JSON alone: groups 1–10 in order, definitions consistent (CI)

THE BOOK. A list (mātikā) in ten groups — Ekaka … Dasaka, announced with a count from the second on ("8. Dve puggalā –") — of numbered
entries ("(1) Kodhano ca, upanāhī ca."); then the definitions (niddesa): "Katamo ca puggalo X? … ayaṃ vuccati puggalo ‘‘X’’." Terms,
numbers and positions only (PREREGISTRATION-2026-09-27b.md §5; the CST is non-commercial, legal L21): an entry's NAMES are written out only
when it is a list of short names; an entry that describes (the similes of the seven groups) is given by its position alone, and no
definition's wording is written out — only the name it defines, as the question and the closing formula each give it.
"""
import hashlib, json, os, re, sys, unicodedata

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
FILE = "abh03m2.mul.xml"
OUT_JSON = os.path.join(REPO, "puggala", "PUGGALA.json")
OUT_MD = os.path.join(REPO, "puggala", "PUGGALA.md")
GROUP_HEAD = re.compile(r"^(\d+)\.\s*(\w+?)(?:uddeso|puggalapaññatti)\s*$")
ENTRY = re.compile(r"^\((\d+)\)\s*(.+)$")
# "Katamo ca puggalo X?" (and the CST's one-g "pugalo", once) · a SET: "Katame dve puggalā X?" · "Katamesaṃ dvinnaṃ puggalānaṃ X?"
DEFINE = re.compile(r"Katamo ca pugg?alo\s+(.+?)\?")
# a SET, the description after puggalā or before it ("Tattha katame tayo gilānūpamā puggalā?"); and "Kathañca puggalo X hoti …?" (how a
# person is X: the sub-definitions inside a group) — both found by /capture's reader, 2026-11-20
DEFINE_SET = re.compile(r"(?i)katame(?:saṃ)?\s+(\w+)\s+(?:([^?]+?)\s+)?puggal(?:ā|ānaṃ)\s*([^?]*?)\?")
DEFINE_HOW = re.compile(r"Kathañca\s+puggalo\s+(.+?)\s+hoti\b[^?]*\?")
# "ayaṃ vuccati puggalo ‘‘X’’" · "Ayaṃ …" · "ime vuccanti puggalā ‘‘X’’" · an unquoted name ("ayaṃ vuccati puggalo sīlesu ca …")
CLOSE = re.compile(r"(?i)(?:ayaṃ|ime)\s+vucca(?:ti|nti)\s+puggal\w*\s+(?:‘‘(.+?)’’|([^.‘’–]+?)(?=[.–]|$))")
COUNTED = re.compile(r"^\d+\.\s*(\w+)\s+puggalā\s*[–—-]\s*$")
NUMBER = {"dve": 2, "tayo": 3, "cattāro": 4, "pañca": 5, "cha": 6, "satta": 7, "aṭṭha": 8, "nava": 9, "dasa": 10}


def nfc(s):
    return unicodedata.normalize("NFC", s)


def plain(raw):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", re.sub(r"<pb\b[^>]*/>", "", re.sub(r"<note>.*?</note>", "", raw)))).strip()


def names(entry):
    """The person-type names of a list entry, or None when it describes rather than names (each item at most three words)."""
    # an entry opening with its own count names a SET ("Tayo gilānūpamā puggalā", the three persons like the sick), defined member by member
    if nfc(entry.split()[0]).lower() in NUMBER or nfc(entry.split()[0]).lower() in ("aparepi", "apare"):
        return None
    items = [x.strip() for x in re.split(r",|\s+ca\b|\.$", entry.rstrip(".")) if x.strip() and x.strip() != "ca"]
    items = [re.sub(r"\s+ca$", "", x).strip() for x in items]
    if items and all(len(x.split()) <= 3 for x in items) and "." not in entry.rstrip("."):
        return items
    return None


def key(name):
    return re.sub(r"[^\w]", "", nfc(name).lower())


def build():
    b = open(os.path.join(CST, FILE), "rb").read()
    L = nfc(b.decode("utf-16")).splitlines()
    niddesa = next(i for i, l in enumerate(L, 1) if plain(l) == "Niddeso")
    groups, defs, cur = [], [], None
    for i, raw in enumerate(L, 1):
        p = plain(raw)
        if not p:
            continue
        m = re.search(r'<(?:p|head)\s+rend="([^"]+)"', raw)
        rend = m.group(1) if m else ""
        h = GROUP_HEAD.match(p) if rend == "subhead" else None
        if h and i < niddesa:
            cur = {"n": int(h.group(1)), "name": h.group(2), "line": i, "arity": 1, "entries": []}
            groups.append(cur)
            continue
        if i < niddesa and cur:
            c = COUNTED.match(p)
            if c and nfc(c.group(1)).lower() in NUMBER:
                cur["arity"] = NUMBER[nfc(c.group(1)).lower()]  # "Dve puggalā –": two persons IN EACH ENTRY, not two entries
                continue
            e = ENTRY.match(p)
            if e:
                nm = names(e.group(2))
                cur["entries"].append({"n": int(e.group(1)), "line": i, **({"names": nm} if nm else {"describes": True})})
            continue
        if i > niddesa:
            found = False
            for d in DEFINE.finditer(p):
                close = CLOSE.search(p[d.end():]); found = True
                defs.append({"line": i, "asks": d.group(1).strip(), **({"closes": (close.group(1) or close.group(2)).strip()} if close else {})})
            for d in DEFINE_SET.finditer(p):
                close = CLOSE.search(p[d.end():]); found = True
                defs.append({"line": i, "set": d.group(1), "asks": ((d.group(2) or "") + " " + (d.group(3) or "")).strip(), **({"closes": (close.group(1) or close.group(2)).strip()} if close else {})})
            for d in DEFINE_HOW.finditer(p):
                found = True
                defs.append({"line": i, "how": True, "asks": d.group(1).strip()})
            if not found:
                # a definition WITHOUT the question, known by its closing formula alone ("… – ayaṃ vuccati puggalo ‘‘sakadāgāmī’’")
                for close in CLOSE.finditer(p):
                    defs.append({"line": i, "closes": (close.group(1) or close.group(2)).strip(), "unasked": True})
    # join each definition to the list entry that names it (first unused, in order)
    used = set()  # (group, entry, name) — a pair entry names two persons, each defined apart
    for d in defs:
        k = key(d.get("asks") or d.get("closes", ""))
        hit = next(((g["n"], e["n"], j) for g in groups for e in g["entries"] for j, x in enumerate(e.get("names", []))
                    if key(x) == k and (g["n"], e["n"], j) not in used), None)
        if hit:
            d["entry"] = list(hit[:2]); used.add(hit)
    return hashlib.sha256(b).hexdigest(), groups, defs


def render(digest, groups, defs):
    js = ['{"generated_by": "scripts/puggala.py", "rule": "terms, numbers and positions only; a definition\'s wording is not here",',
          ' "source": ' + json.dumps({FILE: digest}) + ",", ' "groups": [']
    js += ["  " + json.dumps(g, ensure_ascii=False) + ("," if k < len(groups) - 1 else "") for k, g in enumerate(groups)]
    js += [" ],", ' "definitions": [']
    js += ["  " + json.dumps(d, ensure_ascii=False) + ("," if k < len(defs) - 1 else "") for k, d in enumerate(defs)]
    js += [" ]}"]
    agree = sum(1 for d in defs if "closes" in d and "asks" in d and key(d["closes"]) == key(d["asks"]))
    md = ["# PUGGALAPAÑÑATTI — the person-type index, as generated data", "",
          "*GENERATED by `scripts/puggala.py` from the local Chaṭṭha Saṅgāyana text — never edit by hand. Terms, numbers and positions only",
          "(PREREGISTRATION-2026-09-27b.md §5): the list's ten groups and their numbered entries (names only where an entry names; an entry that",
          "describes is given by position), and the definitions by line and the name each defines. The data is `PUGGALA.json`.*", "",
          f"**{len(groups)} groups · {sum(len(g['entries']) for g in groups)} list entries · {len(defs)} definitions** ({sum(1 for d in defs if 'asks' in d and 'set' not in d and not d.get('how'))} asked *Katamo ca puggalo …?*, "
          f"{sum(1 for d in defs if 'set' in d)} of a SET, *Katame dve puggalā …?*, {sum(1 for d in defs if d.get('how'))} *Kathañca puggalo … hoti?*, {sum(1 for d in defs if d.get('unasked'))} known by the closing formula alone), "
          f"{agree} of them closing on the same name they ask about (*…ayaṃ vuccati puggalo ‘‘…’’*), {sum(1 for d in defs if 'entry' in d)} joined to a list entry by name.", "",
          "Not joined, by design: the MEMBERS of an entry that names a set by its count (*Tayo gilānūpamā puggalā*) — the list does not name them —",
          "and a definition asking two names at once where the list gives them apart. Some definitions carry no closing formula; that is the text's.",
          "Not counted as definitions: the DESCRIPTIONS of a set's members (*Tatra yvāyaṃ puggalo …*, the water similes), which a model reader marks.", "",
          f"Each group states how many persons an entry holds (*Dve puggalā*, two; Ekaka, one): of the entries that name, {sum(1 for g in groups for e in g['entries'] if 'names' in e and len(e['names']) == g['arity'])} of {sum(1 for g in groups for e in g['entries'] if 'names' in e)} name exactly that many.", "",
          "| Group | Name | List line | Persons per entry | Entries | Entries that name | Definitions joined |", "|---|---|---|---|---|---|---|"]
    for g in groups:
        joined = sum(1 for d in defs if d.get("entry", [None])[0] == g["n"])
        md.append(f"| {g['n']} | {g['name']} | {g['line']} | {g['arity']} | {len(g['entries'])} | {sum(1 for e in g['entries'] if 'names' in e)} | {joined} |")
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


CASES = [
    ("names", "Kodhano ca, upanāhī ca.", ["Kodhano", "upanāhī"]),
    ("names", "Samayavimutto", ["Samayavimutto"]),
    ("names", "Satta udakūpamā puggalā. Sakiṃ nimuggo nimuggova hoti, ummujjitvā nimujjati.", None),
    ("define", "1. Katamo ca puggalo samayavimutto? Idhekacco puggalo … – ayaṃ vuccati puggalo ‘‘samayavimutto’’.", ("samayavimutto", "samayavimutto")),
    ("define", "Katamo ca puggalo abhabbāgamano? Ye te puggalā … – ime vuccanti puggalā ‘‘abhabbāgamanā’’.", ("abhabbāgamano", "abhabbāgamanā")),
    ("define", "Katamo ca puggalo samaṇapadumo? … Ayaṃ vuccati puggalo ‘‘samaṇapadumo’’.", ("samaṇapadumo", "samaṇapadumo")),
    ("group", "8. Dve puggalā –", 2),
    ("define", "70. Katamo ca pugalo amaccharī? Tattha katamaṃ macchariyaṃ?", ("amaccharī", None)),
    ("set", "83. Katame dve puggalā dullabhā lokasmiṃ? Yo ca pubbakārī – ime dve puggalā dullabhā lokasmiṃ.", ("dve", "dullabhā lokasmiṃ")),
    ("close", "42. Kāmarāgabyāpādānaṃ … paṭipanno. Yassa … – ayaṃ vuccati puggalo ‘‘sakadāgāmī’’.", "sakadāgāmī"),
    ("set", "94. Tattha katame tayo gilānūpamā puggalā? Tayo gilānā – idhekacco gilāno …", ("tayo", "gilānūpamā")),
    ("how", "Kathañca puggalo āgataviso hoti no ghoraviso? Idhekacco puggalo abhiṇhaṃ kujjhati.", "āgataviso"),
    ("names", "Tayo gilānūpamā puggalā.", None),
]


def selftest():
    bad = 0
    for kind, text, want in CASES:
        if kind == "names":
            got = names(text)
        elif kind == "define":
            d = DEFINE.search(text); c = CLOSE.search(text[d.end():]) if d else None
            got = (d.group(1), (c.group(1) or c.group(2)) if c else None) if d else None
        elif kind == "set":
            d = DEFINE_SET.search(text); got = (d.group(1), ((d.group(2) or "") + " " + (d.group(3) or "")).strip()) if d else None
        elif kind == "how":
            d = DEFINE_HOW.search(text); got = d.group(1) if d else None
        elif kind == "close":
            c = CLOSE.search(text); got = (c.group(1) or c.group(2)) if c else None
        else:
            c = COUNTED.match(text); got = NUMBER.get(nfc(c.group(1)).lower()) if c else None
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", kind, text[:60], "" if ok else f"→ {got}, want {want}")
    wrong = names(CASES[0][1]) == ["Kodhano"]
    print("✓" if not wrong else "✗", "the harness FAILS a wrong expectation (a pair read as one name)")
    bad += wrong
    n = len(CASES) + 1
    print(f"puggala selftest: {n - bad}/{n}")
    return 1 if bad else 0


def validate(path=OUT_JSON):
    d, errs = json.load(open(path, encoding="utf-8")), []
    if [g["n"] for g in d["groups"]] != list(range(1, 11)):
        errs.append("the groups are not 1–10 in order")
    for g in d["groups"]:
        if [e["n"] for e in g["entries"]] != list(range(1, len(g["entries"]) + 1)):
            errs.append(f"group {g['n']}: entries are not numbered 1…n")
    if any(not (x.get("asks") or x.get("closes")) for x in d["definitions"]):
        errs.append("a definition names no person")
    lines = [x["line"] for x in d["definitions"]]
    if any(a > b for a, b in zip(lines, lines[1:])):
        errs.append("definitions out of line order")
    seen = set()
    count = {}
    for x in d["definitions"]:
        if "entry" in x:
            count[tuple(x["entry"])] = count.get(tuple(x["entry"]), 0) + 1
    arity = {g["n"]: g["arity"] for g in d["groups"]}
    for (g, e), c in count.items():
        if c > arity[g]:
            errs.append(f"list entry ({g}, {e}) joined {c} times, more than its {arity[g]} persons")
    for e in errs[:10]:
        print("✗", e)
    print(f"puggala validate: {'PASS' if not errs else 'FAIL'} — {len(d['groups'])} groups, {len(d['definitions'])} definitions" + (f", {len(errs)} error(s)" if errs else ""))
    return 1 if errs else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    if "--validate" in sys.argv:
        k = sys.argv.index("--validate")
        sys.exit(validate(sys.argv[k + 1] if len(sys.argv) > k + 1 else OUT_JSON))
    digest, groups, defs = build()
    js, md = render(digest, groups, defs)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_JSON, js), (OUT_MD, md)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale:
            print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("puggala/ is current"); sys.exit(0)
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from stamped import write_rotating
    for p, t in ((OUT_JSON, js), (OUT_MD, md)):
        r = write_rotating(p, t, "regenerated by `scripts/puggala.py`")
        if r:
            print(f"proof rotated: {r} (logged in TIMESTAMPS.md)")
    print(md.split("\n")[5])
