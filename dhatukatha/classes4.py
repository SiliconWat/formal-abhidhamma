#!/usr/bin/env python3
"""classes4.py — for run 2026-11-22-dhatukatha-association-4: the SCOPE of the sixth method's matrix (§5, Tikaṃ) that run 3's rule covers, by a STATED criterion
read from the Dhammasaṅgaṇī's own definitions (its Nikkhepa, abh01m.mul.xml:7017–7309), never chosen by hand (run 3's refuter, finding 5: "scope picked without a
stated criterion"). Fixed and committed BEFORE the run is registered, and before the sixth method's rows for these classes are read. Writes dhatukatha/Classes4.lean.

  THE CRITERION. Every class named in §5 is looked up in the Nikkhepa; each READING of its definition (a clause closing "– ime dhammā <the class>") gets a shape:
    object       — defined by what it takes as object ("… ārabbha …", "… karitvā ye uppajjanti cittacetasikā …")        → OUT (needs the object rules, not in the inputs)
    mixed        — contains matter or the unconditioned ("rūpaṃ", "asaṅkhatā")                                          → OUT (the rule has no mixed shape)
    feelingAside — sets aside a feeling ("vedanaṃ / sukhaṃ / upekkhaṃ ṭhapetvā")                                          → IN
    formationAside — sets aside any other mental dhamma ("pītiṃ / vicāraṃ / vitakkavicāre … ṭhapetvā")                   → IN
    allFour      — the four aggregates ("vedanākkhandho … viññāṇakkhandho") or whole cittas (wholesome, unwholesome,
                   path, fruit), nothing set aside; "taṃsamuṭṭhānaṃ kāyakammaṃ, vacīkammaṃ, manokammaṃ" read as volitions     → IN
    unclassified — none of these (e.g. defined by kammas and a view)                                                    → OUT
  A class is IN only if ALL its readings give one IN shape; readings that disagree ("several") are OUT. Run 3's ten classes are left out (tested there).
  ELEMENTS E (from the Dhammasaṅgaṇī's Cittuppāda, cittuppada/CITTUPPADA.json): a set-aside class from the classes whose written list holds the dhamma(s) set
  aside — every one of them for two (savitakkasavicārā: vitakko AND vicāro); "-mattā" (vicāraṃ ṭhapetvā, no vitakka): vicāro and not vitakko. An allFour class
  from the Cittuppāda classes its citta words pick: wholesome, unwholesome and path cittas are the classes that are neither results nor functional (E_NRNF);
  the fruits are the supramundane results (E_LR).
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(REPO, "scripts"))
import dhatukatha as D
import ranges as R

RUN3 = {"sukhāya vedanāya sampayuttā", "dukkhāya vedanāya sampayuttā", "adukkhamasukhāya vedanāya sampayuttā", "pītisahagatā", "sukhasahagatā",
        "upekkhāsahagatā", "vipākā", "mahaggatā", "sanidassanasappaṭighā", "anidassanasappaṭighā"}
FEELING = ("vedanaṃ", "sukhaṃ", "upekkhaṃ", "dukkhaṃ")
clean = lambda l: re.sub(r"\s+", " ", D.server.plain(l)).strip()
key = lambda s: D.norm(s).replace("upādiṇṇ", "upādinn").replace("ācayagāmi na", "ācayagāmino na").strip()


def matrix_names():
    """(line, [class names]) for every §5 row — NAMES ONLY: the text from the first count word on is never kept."""
    ls = D.server.lines("abh03m1.mul.xml")
    start = next(i for i, l in enumerate(ls, 1) if clean(l) == "6. Chaṭṭhanayo")
    end = next(i for i, l in enumerate(ls, 1) if clean(l) == "7. Sattamanayo")
    out, in_tika = [], False
    for i in range(start, end):
        raw, t = ls[i - 1], clean(ls[i - 1])
        if 'rend="subhead"' in raw:
            in_tika = bool(re.match(r"\d+\.\s*Tikaṃ", t)); continue
        m = re.match(r"^(\d+)\. (.*)$", t)
        if not in_tika or not m:
            continue
        subj = re.split(r"\bkatihi\b|\bsampayuttāti\b", m.group(2))[0]
        names = []
        for piece in re.split(r"\s*…(?:pe…)?\s*", subj):
            # a piece may join several names ("dassanena pahātabbā dhammā bhāvanāya pahātabbā dhammā"); a name ends in " dhammā" or is one word in
            # "-dhammā" ("vipākadhammadhammā", which the first version of this split dropped — caught by the coverage check below)
            for n in re.findall(r"(.+?)(?: dhammā|(?<=dhammā))(?=\s|$)", piece.strip(" ,")):
                n = key(n).strip(" ,")
                if n:
                    names.append(n)
        out.append((i, names))
    return out


def definitions():
    """{class name: (first line, [reading texts])} from the Nikkhepa: each reading is a clause closing '– ime dhammā <name>'."""
    ls = D.server.lines("abh01m.mul.xml")
    heads = [(i, re.match(r"\d+\. Katame dhammā ([^?]+)\?", clean(ls[i - 1]))) for i in range(7000, 7320)]
    heads = [(i, key(m.group(1))) for i, m in heads if m]
    out = {}
    for n, (i, name) in enumerate(heads):
        stop = heads[n + 1][0] if n + 1 < len(heads) else i + 4
        text = " ".join(clean(ls[j - 1]) for j in range(i, stop))
        text = re.sub(r"^\d+\. Katame dhammā [^?]+\?\s*", "", text)
        readings, prev = [], 0
        for m in re.finditer(r"–\s*ime dhammā ([^.–]+?)\s*\.", text):
            if key(m.group(1)) == name:
                seg = text[prev:m.start()]
                seg = re.split(r"\d+\. ", seg)[-1]   # a reading starts after its own paragraph number: a fetter's sub-definitions are not the class
                readings.append(seg)
            prev = m.end()
        out[name] = (i, readings)
    return out


def shape(r):
    if re.search(r"ārabbha|karitvā ye uppajjanti", r):
        return "object"
    if re.search(r"\brūpaṃ\b|asaṅkhatā|rūpāyatanaṃ", r):
        return "mixed"
    m = re.search(r"(\S+(?: \S+)?) ṭhapetvā", r)
    if m:
        return "feelingAside" if m.group(1).split()[-1] in FEELING else "formationAside"
    if re.search(r"vedanākkhandho|kusal|akusal|maggā|phal", r):
        return "allFour"
    return "unclassified"


def cittuppada():
    return json.load(open(os.path.join(REPO, "cittuppada", "CITTUPPADA.json"), encoding="utf-8"))["classes"]


def elements_of(classes):
    out = set()
    for c in classes:
        words = [w.strip(",").lower() for w in c["features"]]
        named = [e for w in words for k, e in R.SENSE if w.startswith(k)]
        out |= set(named) if named else ({"manoD"} if "manodhātu" in words else {"manoV"})
    return out


def result_or_functional(c):
    return any(w.lower().startswith(("vipāk", "kiriy", "kusalass", "akusalass", "kammavipāk")) for w in c["features"])


def table():
    C = cittuppada(); defs = definitions(); rows, report = [], []
    E_NRNF = elements_of([c for c in C if not result_or_functional(c)])
    E_LR = elements_of([c for c in C if result_or_functional(c) and any(w.lower().startswith("lokuttar") for w in c["features"])])
    has = lambda c, p: p in c["padas"]
    for line, names in matrix_names():
        for name in names:
            if name in RUN3:
                report.append((line, name, "—", "OUT: tested in run 3")); continue
            if name not in defs:
                report.append((line, name, "?", "OUT: no Nikkhepa definition found")); continue
            dline, readings = defs[name]
            shapes = sorted({shape(r) for r in readings}) or ["none"]
            s = shapes[0] if len(shapes) == 1 else "several"
            if s not in ("allFour", "formationAside", "feelingAside"):
                report.append((line, name, s, f"OUT ({'; '.join(shapes)}) — definition :{dline}")); continue
            if s == "formationAside":
                if name == "savitakkasavicārā":
                    E = elements_of([c for c in C if has(c, "vitakko") and has(c, "vicāro")])
                elif name == "avitakkavicāramattā":
                    E = elements_of([c for c in C if has(c, "vicāro") and not has(c, "vitakko")])
                else:
                    report.append((line, name, s, "OUT: a set-aside with no element rule declared")); continue
            elif s == "allFour":
                E = E_LR | E_NRNF if name in ("sekkhā", "asekkhā") else E_NRNF
            else:
                report.append((line, name, s, "OUT: a feeling set-aside outside run 3 — no element rule declared")); continue
            rows.append((line, name, s, E)); report.append((line, name, s, f"IN — definition :{dline} · E = {sorted(E, key=R.ORDER.index)}"))
    return rows, report, (E_NRNF, E_LR)


def slug(name):
    t = name.lower()
    for a, b in (("ā", "a"), ("ī", "i"), ("ū", "u"), ("ṃ", "m"), ("ṅ", "n"), ("ñ", "n"), ("ṭ", "t"), ("ḍ", "d"), ("ṇ", "n"), ("ḷ", "l"), (" ", "_")):
        t = t.replace(a, b)
    return t


def lean(rows):
    out = ["/-", "  dhatukatha/Classes4.lean — GENERATED by classes4.py (⛔ never edited by hand): the §5 classes run 3's rule covers by the STATED criterion (classes4.py),",
           "  with their matrix line, shape (from the Nikkhepa's own words) and consciousness elements (from the Cittuppāda: 0 eye · 1 ear · 2 nose · 3 tongue · 4 body ·",
           "  5 mind-element · 6 mind-consciousness), fixed before run 2026-11-22-dhatukatha-association-4 is registered.", "-/", "namespace FormalAbhidhamma.Dhatukatha", "",
           "def classes4 : List (String × String × List Nat) := ["]
    out.append(",\n".join(f'  ("{slug(n)}", "{s}", [{", ".join(str(R.ORDER.index(e)) for e in sorted(E, key=R.ORDER.index))}])' for _, n, s, E in rows))
    out += ["]", "", "/-- each class's §5 line (several classes share one row) -/", "def classLine4 : List (String × Nat) := ["]
    out.append(",\n".join(f'  ("{slug(n)}", {line})' for line, n, _, _ in rows))
    out += ["]", "", "end FormalAbhidhamma.Dhatukatha"]
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    rows, report, (nrnf, lr) = table(); text = lean(rows); p = os.path.join(HERE, "Classes4.lean")
    if sys.argv[1:] == ["--check"]:
        ok = os.path.exists(p) and open(p, encoding="utf-8").read() == text
        print("Classes4.lean is current" if ok else "STALE: Classes4.lean"); sys.exit(0 if ok else 1)
    open(p, "w", encoding="utf-8").write(text)
    print(f"E_NRNF (wholesome, unwholesome, path) = {sorted(nrnf, key=R.ORDER.index)} · E_LR (supramundane results) = {sorted(lr, key=R.ORDER.index)}")
    for line, name, s, why in report:
        print(f"L{line}  {name:44} {s:15} {why}")
