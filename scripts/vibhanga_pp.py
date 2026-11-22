#!/usr/bin/env python3
"""vibhanga_pp.py — capture: the Vibhaṅga's question-sections (pañhāpucchaka) — every classification of a chapter's items under the matrix,
GENERATED from the CST (founder 2026-11-21: "do per your recommendation"; /capture's two model readers of these sections are the cross-check).

  scripts/vibhanga_pp.py                 regenerate vibhanga/PANHAPUCCHAKA.json and vibhanga/PANHAPUCCHAKA.md
  scripts/vibhanga_pp.py --check         exit 1 if either generated file differs from what the CST text gives now
  scripts/vibhanga_pp.py --selftest      the parsing rules on known answers, and a wrong expectation that must FAIL (no CST needed: CI)
  scripts/vibhanga_pp.py --validate [f]  the generated JSON alone: its invariants (CI)

THE FORM. A section opens with its items ("Pañcakkhandhā – rūpakkhandho, …": N = 5) and then classifies them, triad by triad and dyad by
dyad: "Rūpakkhandho abyākato. Cattāro khandhā siyā kusalā, siyā akusalā, siyā abyākatā. Dve khandhā na vattabbā – ‘‘sukhāya vedanāya
sampayuttā’’tipi, …". Each sentence: a SUBJECT as written (a number and its noun — "Cattāro khandhā", 4 — or one item, 1) and its class
words, each with its MODALITY: definite (a plain predicate; a "na" stays with its word) · may-be ("siyā X") · cannot-be-said (X under "na
vattabbā") · may-be-cannot-be-said ("siyā na vattabbā"). Which items a collective subject means is NOT said by the text and not guessed.

THE TEST. One matrix item's sentences should PARTITION the section's items: 1 + 4 = 5 aggregates; so the subjects' counts, read in order, fall
into blocks that each sum to N exactly. A block that overshoots N is a finding (or a fault of this parser), and is listed.

Terms, numbers and positions only (PREREGISTRATION-2026-09-27b.md §5; the CST is non-commercial, legal L21).
"""
import hashlib, json, os, re, sys, unicodedata

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
FILE = "abh02m.mul.xml"
OUT_JSON = os.path.join(REPO, "vibhanga", "PANHAPUCCHAKA.json")
OUT_MD = os.path.join(REPO, "vibhanga", "PANHAPUCCHAKA.md")
NUM = sorted([("ek", 1), ("dve", 2), ("dv", 2), ("tayo", 3), ("tīṇi", 3), ("tīṇ", 3), ("tisso", 3), ("cattār", 4), ("catass", 4), ("catu", 4), ("pañc", 5),
              ("cha", 6), ("ch", 6), ("satt", 7), ("aṭṭh", 8), ("nav", 9), ("das", 10), ("ekādas", 11), ("dvādas", 12), ("bāras", 12), ("teras", 13),
              ("cuddas", 14), ("pannaras", 15), ("soḷas", 16), ("sattaras", 17), ("aṭṭhāras", 18), ("bāvīsat", 22), ("dvāvīsat", 22)],
             key=lambda x: -len(x[0]))
# the nouns a collective subject counts: a number is a collective ONLY joined to one of these, apart ("Cattāro khandhā") or fused
# ("Dasāyatanā", ten bases) — so "Chandiddhipādo" (an item that happens to begin with cha) stays one item
NOUNS = ("khandh", "āyatan", "dhātu", "dhātuyo", "sacc", "indriy", "satipaṭṭhān", "sammappadhān", "iddhipād", "bojjhaṅg", "maggaṅg", "jhān",
         "appamaññ", "sikkhāpad", "paṭisambhid")
BARE = {"dve", "tayo", "tīṇi", "tisso", "cattāro", "cattāri", "catasso", "pañca", "cha", "satta", "aṭṭha", "nava", "dasa", "ekādasa", "dvādasa",
        "terasa", "cuddasa", "pannarasa", "soḷasa", "sattarasa", "aṭṭhārasa", "bāvīsati"}
UNSAY = re.compile(r"(siyā\s+)?na\s+vattabb\w*\s*[–-]?\s*((?:‘‘[^’]+’’\s*ti(?:pi)?[,\s]*)+)")
QUOTE = re.compile(r"‘‘([^’]+)’’")


def nfc(s):
    return unicodedata.normalize("NFC", s)


def plain(raw):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", re.sub(r"<pb\b[^>]*/>", "", re.sub(r"<note>.*?</note>", "", raw)))).strip()


def number(word):
    w = nfc(word).lower()
    return next((v for s, v in NUM if w.startswith(s)), None)


ORDINAL = ("paṭham", "dutiy", "tatiy", "catutth", "pañcam")


def head(words, items):
    """Is a clause's first word(s) a SUBJECT? → (subject, count, words used) or None. A subject is a collective — a bare number with its noun
    ("Cattāro khandhā") or fused ("Dasāyatanā") — an ordinal with its noun ("Paṭhamaṃ jhānaṃ"), an item the section's opening list names
    ("mettā", "sammādiṭṭhi"), or a word built on a section noun ("cittiddhipādo", "Somanassindriyaṃ"). Anything else is a predicate."""
    if not words:
        return None
    w0 = nfc(words[0]).lower().strip(",;")
    w1 = nfc(words[1]).lower() if len(words) > 1 else ""
    if w0 in BARE and w1.startswith(NOUNS):
        return " ".join(words[:2]), number(w0), 2
    fused = next((st for st, _ in NUM if w0.startswith(st) and (w0[len(st):].startswith(NOUNS) or w0[len(st):].lstrip("aāiī").startswith(NOUNS))), None)
    if fused:
        return words[0], number(w0), 1
    if w0.startswith(ORDINAL) and w1.startswith(NOUNS):
        return " ".join(words[:2]), 1, 2
    if w0 in items or (any(n in w0 for n in NOUNS) and not w0.startswith(("siyā", "na", "no"))):
        return words[0], 1, 1
    return None


def clauses(s, items=(), N=None):
    """One sentence → its clauses: [{subject, count, preds: [[modality, class words]]}]. A clause with no stated subject is said of ALL the
    section's items (subject None, count N): "Kusalāyeva. Siyā sukhāya …" (the four iddhipāda); one sentence may hold two subjects
    ("Tayo iddhipādā bāhirā, cittiddhipādo ajjhattiko")."""
    s = nfc(s).strip().rstrip(".").strip()
    if not s or "?" in s:
        return []
    held = []
    def hold(m):
        held.append(["may-be-cannot-be-said" if m.group(1) else "cannot-be-said", [q.strip() for q in QUOTE.findall(m.group(2))]])
        return f" §{len(held) - 1}§ "
    s = UNSAY.sub(hold, s)
    out, cur = [], None
    for part in [x.strip() for x in re.split(r"[,;]", s)]:
        if not part or part == "…pe…":
            continue
        w = part.split()
        h = head(w, items)
        if h:
            cur = {"subject": h[0], "count": h[1], "preds": []}; out.append(cur)
            w = w[h[2]:]
        if cur is None:
            cur = {"subject": None, "count": N, "preds": [], "all": 1}; out.append(cur)
        rest = " ".join(w).strip()
        for m in re.finditer(r"§(\d+)§", rest):
            mod, qs = held[int(m.group(1))]
            cur["preds"] += [[mod, q] for q in qs]
        rest = re.sub(r"§\d+§", " ", rest).strip()
        if not rest or rest == "…pe…":
            continue
        if rest.lower().startswith("siyā "):
            cur["preds"].append(["may-be", rest[5:].strip()])
        else:
            cur["preds"].append(["definite", rest])
    return [c for c in out if c["preds"]]


def sentence(s):
    """The first clause of a sentence (the selftest's unit)."""
    c = clauses(s)
    return {k: v for k, v in c[0].items()} if c else None


def sections(L):
    heads = [i for i, l in enumerate(L, 1) if "Pañhāpucchaka" in plain(l) and re.search(r'rend="(?:title|subhead|chapter)"', l)]
    chapters = [i for i, l in enumerate(L, 1) if re.search(r'rend="chapter"', l) and plain(l)]
    for a in heads:
        z = min([c for c in chapters if c > a] + [len(L) + 1]) - 1
        chapter = plain(L[max(c for c in chapters if c < a) - 1])
        yield a, z, chapter


def build():
    b = open(os.path.join(CST, FILE), "rb").read()
    L = nfc(b.decode("utf-16")).splitlines()
    out = []
    for a, z, chapter in sections(L):
        sec = {"chapter": chapter, "line": a, "N": None, "items": [], "parts": []}
        part = None
        for i in range(a + 1, z + 1):
            raw = L[i - 1]; t = plain(raw)
            if not t:
                continue
            if sec["N"] is None and " – " in t:
                hd, lst = re.sub(r"^\d+\.\s*", "", t).split(" – ", 1)
                # the number may be any word of the head ("Ariyo aṭṭhaṅgiko maggo"): the first that reads as one
                sec["N"] = next((number(x) for x in hd.split() if number(x)), None)
                its = [x.strip(" .").split() for x in lst.split(",")]
                sec["items"] = [nfc(x[0]).lower() for x in its if x and len(x) <= 3]
                # an opening in PROSE names its items itself: "mettāsahagatena cetasā … upekkhāsahagatena" (the Appamaññā)
                sec["items"] += [nfc(m).lower() for m in re.findall(r"(\w+?)sahagatena", lst)]
                continue
            if re.search(r'rend="subhead"', raw):
                part = {"name": re.sub(r"^\d+\.\s*", "", t), "sentences": []}; sec["parts"].append(part)
                continue
            if part is None:
                continue
            body = re.sub(r"^\d+\.\s*", "", t)
            centre = bool(re.search(r'rend="centre"', raw))
            for s in re.split(r"(?<=\.)\s+(?=[A-ZĀĪŪṬḌṆÑṄḶṂ])", body):
                if centre:  # "Sappaccayā, saṅkhatā." — said of all the items, with no subject
                    preds = [["definite", p.strip(" .")] for p in s.split(",") if p.strip(" .")]
                    if preds:
                        part["sentences"].append({"line": i, "subject": None, "count": sec["N"], "preds": preds, "all": 1})
                    continue
                for x in clauses(s, sec.get("items", ()), sec["N"]):
                    part["sentences"].append({"line": i, **x, **({"pe": 1} if "…pe…" in s else {})})
        partition(sec)
        out.append(sec)
    return hashlib.sha256(b).hexdigest(), out


def partition(sec):
    """Group each part's sentences into blocks whose subject counts sum to N; a block broken by …pe… or that overshoots is marked."""
    N = sec["N"]
    for p in sec["parts"]:
        blocks, cur, total = [], [], 0
        for k, s in enumerate(p["sentences"]):
            if s.get("pe"):
                if cur: blocks.append({"from": cur[0], "n": len(cur), "sum": total, "ok": False, "why": "elided"})
                cur, total = [], 0
                continue
            cur.append(s["line"]); total += s["count"] or 0
            if N and total == N:
                blocks.append({"from": cur[0], "n": len(cur), "sum": total, "ok": True}); cur, total = [], 0
            elif N and total > N:
                blocks.append({"from": cur[0], "n": len(cur), "sum": total, "ok": False, "why": "overshoots"}); cur, total = [], 0
        if cur:
            blocks.append({"from": cur[0], "n": len(cur), "sum": total, "ok": False, "why": "short at the part's end"})
        p["blocks"] = blocks


def render(digest, secs):
    js = ['{"generated_by": "scripts/vibhanga_pp.py", "rule": "terms, numbers and positions only; which items a collective subject means is not given",',
          ' "source": ' + json.dumps({FILE: digest}) + ",", ' "sections": [']
    js += ["  " + json.dumps(s, ensure_ascii=False) + ("," if k < len(secs) - 1 else "") for k, s in enumerate(secs)]
    js += [" ]}"]
    S = [x for s in secs for p in s["parts"] for x in p["sentences"]]
    P = [x for x in S for _ in x["preds"]]
    mods = {}
    for x in S:
        for m, _ in x["preds"]:
            mods[m] = mods.get(m, 0) + 1
    B = [b for s in secs for p in s["parts"] for b in p["blocks"]]
    md = ["# VIBHAṄGA — the question-sections' classifications, as generated data", "",
          "*GENERATED by `scripts/vibhanga_pp.py` from the local Chaṭṭha Saṅgāyana text — never edit by hand. Terms, numbers and positions only",
          "(PREREGISTRATION-2026-09-27b.md §5). Which items a collective subject (\"Cattāro khandhā\") means is not given by the text and not",
          "guessed here. The data is `PANHAPUCCHAKA.json`.*", "",
          f"**{len(secs)} sections · {len(S):,} classification sentences · {len(P):,} class words** — "
          + " · ".join(f"{m} {n:,}" for m, n in sorted(mods.items(), key=lambda x: -x[1])) + ".", "",
          f"**The partition test:** {len(B):,} blocks of sentences; **{sum(1 for b in B if b['ok']):,}** cover their section's items exactly "
          f"(subject counts summing to N); {sum(1 for b in B if not b['ok'] and b.get('why') == 'elided'):,} broken by an elision; "
          f"{sum(1 for b in B if not b['ok'] and b.get('why') != 'elided'):,} do not sum to N.", "",
          "| Section | Chapter | N | Parts | Sentences | Blocks exact | Blocks not |", "|---|---|---|---|---|---|---|"]
    for s in secs:
        bs = [b for p in s["parts"] for b in p["blocks"]]
        md.append(f"| {s['line']} | {s['chapter']} | {s['N']} | {', '.join(p['name'] for p in s['parts'])} | {sum(len(p['sentences']) for p in s['parts'])} | "
                  f"{sum(1 for b in bs if b['ok'])} | {sum(1 for b in bs if not b['ok'])} |")
    bad = [(s["line"], b) for s in secs for p in s["parts"] for b in p["blocks"] if not b["ok"] and b.get("why") != "elided"]
    if bad:
        md += ["", "## Blocks whose subjects do not sum to N", "", "| Section | From line | Sentences | Sum | Why |", "|---|---|---|---|---|"]
        md += [f"| {l} | {b['from']} | {b['n']} | {b['sum']} | {b['why']} |" for l, b in bad[:60]]
    return "\n".join(js) + "\n", "\n".join(md) + "\n"


CASES = [
    ("Rūpakkhandho abyākato.", {"subject": "Rūpakkhandho", "count": 1, "preds": [["definite", "abyākato"]]}),
    ("Cattāro khandhā siyā kusalā, siyā akusalā, siyā abyākatā.", {"subject": "Cattāro khandhā", "count": 4, "preds": [["may-be", "kusalā"], ["may-be", "akusalā"], ["may-be", "abyākatā"]]}),
    ("Dve khandhā na vattabbā – ‘‘sukhāya vedanāya sampayuttā’’tipi, ‘‘dukkhāya vedanāya sampayuttā’’tipi.",
     {"subject": "Dve khandhā", "count": 2, "preds": [["cannot-be-said", "sukhāya vedanāya sampayuttā"], ["cannot-be-said", "dukkhāya vedanāya sampayuttā"]]}),
    ("Cattāro khandhā siyā maggārammaṇā, siyā na vattabbā – ‘‘maggārammaṇā’’tipi.",
     {"subject": "Cattāro khandhā", "count": 4, "preds": [["may-be", "maggārammaṇā"], ["may-be-cannot-be-said", "maggārammaṇā"]]}),
    ("Cattāro khandhā na hetū.", {"subject": "Cattāro khandhā", "count": 4, "preds": [["definite", "na hetū"]]}),
    ("Soḷasa dhātuyo abyākatā.", {"subject": "Soḷasa dhātuyo", "count": 16, "preds": [["definite", "abyākatā"]]}),
    ("Dasāyatanā abyākatā.", {"subject": "Dasāyatanā", "count": 10, "preds": [["definite", "abyākatā"]]}),
    ("Chāyatanā upādinnā.", {"subject": "Chāyatanā", "count": 6, "preds": [["definite", "upādinnā"]]}),
    ("Tīṇindriyā siyā kusalā.", {"subject": "Tīṇindriyā", "count": 3, "preds": [["may-be", "kusalā"]]}),
    ("Chandiddhipādo siyā kusalo.", {"subject": "Chandiddhipādo", "count": 1, "preds": [["may-be", "kusalo"]]}),
    ("Siyā sukhāya vedanāya sampayuttā, siyā adukkhamasukhāya vedanāya sampayuttā.", {"subject": None, "count": None, "preds": [["may-be", "sukhāya vedanāya sampayuttā"], ["may-be", "adukkhamasukhāya vedanāya sampayuttā"]], "all": 1}),
]


def selftest():
    bad = 0
    for text, want in CASES:
        got = sentence(text)
        ok = got == want
        bad += not ok
        print("✓" if ok else "✗", text[:60], "" if ok else f"\n    got  {got}\n    want {want}")
    sec = {"N": 5, "parts": [{"sentences": [{"line": 1, "count": 1}, {"line": 1, "count": 4}, {"line": 2, "count": 2}, {"line": 2, "count": 3}, {"line": 3, "count": 4}, {"line": 3, "count": 4}]}]}
    partition(sec); bl = sec["parts"][0]["blocks"]
    ok = [b["ok"] for b in bl] == [True, True, False] and bl[2]["why"] == "overshoots"
    print("✓" if ok else "✗", "partition: 1+4 and 2+3 cover five; 4+4 overshoots")
    bad += not ok
    two = clauses("Tayo iddhipādā bāhirā, cittiddhipādo ajjhattiko.", (), 4)
    ok = [(c["subject"], c["count"], c["preds"]) for c in two] == [("Tayo iddhipādā", 3, [["definite", "bāhirā"]]), ("cittiddhipādo", 1, [["definite", "ajjhattiko"]])]
    print("✓" if ok else "✗", "two subjects in one sentence: Tayo iddhipādā bāhirā, cittiddhipādo ajjhattiko (3 + 1)")
    bad += not ok
    wrong = sentence(CASES[4][0])["preds"] == [["definite", "hetū"]]
    print("✓" if not wrong else "✗", "the harness FAILS a wrong expectation (na hetū read without its na)")
    bad += wrong
    n = len(CASES) + 3
    print(f"vibhanga_pp selftest: {n - bad}/{n}")
    return 1 if bad else 0


def validate(path=OUT_JSON):
    d, errs = json.load(open(path, encoding="utf-8")), []
    if len(d["sections"]) != 14:
        errs.append(f"{len(d['sections'])} sections, not the Vibhaṅga's 14 question-sections")
    MODS = {"definite", "may-be", "cannot-be-said", "may-be-cannot-be-said"}
    for s in d["sections"]:
        if not s["N"]:
            errs.append(f"section L{s['line']}: no item count read from its opening list")
        for p in s["parts"]:
            for x in p["sentences"]:
                if not x["preds"] or any(m not in MODS for m, _ in x["preds"]) or (x["subject"] is None and x["count"] != s["N"]):
                    errs.append(f"L{x['line']}: a sentence with no class word, or an unknown modality")
            for bl in p["blocks"]:
                if bl["ok"] != (bl["sum"] == s["N"] and bl.get("why") is None):
                    errs.append(f"section L{s['line']}: a block's verdict does not match its own sum")
    for e in errs[:10]:
        print("✗", e)
    n = sum(len(p["sentences"]) for s in d["sections"] for p in s["parts"])
    print(f"vibhanga_pp validate: {'PASS' if not errs else 'FAIL'} — {len(d['sections'])} sections, {n:,} sentences" + (f", {len(errs)} error(s)" if errs else ""))
    return 1 if errs else 0


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    if "--validate" in sys.argv:
        k = sys.argv.index("--validate")
        sys.exit(validate(sys.argv[k + 1] if len(sys.argv) > k + 1 else OUT_JSON))
    digest, secs = build()
    js, md = render(digest, secs)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_JSON, js), (OUT_MD, md)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale:
            print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("vibhanga/ is current"); sys.exit(0)
    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from stamped import write_rotating
    for p, t in ((OUT_JSON, js), (OUT_MD, md)):
        r = write_rotating(p, t, "regenerated by `scripts/vibhanga_pp.py`")
        if r:
            print(f"proof rotated: {r} (logged in TIMESTAMPS.md)")
    print("\n".join(md.split("\n")[5:9]))
