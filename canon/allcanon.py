#!/usr/bin/env python3
"""allcanon.py — run 2026-11-22-cittuppada-against-the-manual: the Dhammasaṅgaṇī's 23 FULLY WRITTEN lists (cittuppada/CITTUPPADA.json) against the Saṅgaha's rules
(sangaha/Rules.lean, A32) — the first-citta check of sangaha/Canon.lean (rung 3) generalized. Writes sangaha/CanonAll.lean (DATA ONLY: each class's citta record built
from its feature words, its listed terms mapped onto the 52, whether it carries the open 'ye vā pana' clause). COMPUTES NO COMPARISON: that is CheckCanonAll.lean,
run after the registration.   allcanon.py --check exits 1 if CanonAll.lean is stale.

THE TERM MAP is canon/pada.py's MAP, pre-registered (PREREGISTRATION-2026-09-27b.md §3), unchanged, plus an EXTENSION on the same principle (a term naming a factor
under a faculty, power, path-factor or synonym form is that factor), declared in this run's registration before any comparison. A term outside both is UNMAPPED and
reported, never mapped after the fact.

THE RECORD RULES (declared): kind — kiriy- → functional, vipāk- → resultant (kusalassa / akusalassa its kamma), akusal- → unwholesome, kusal- → wholesome; plane —
lokuttar-, rūpāvacar-, arūpāvacar-, else the sense sphere; feeling — the last '-sahagat-' word (in a several-consciousness sentence the list is the LAST named's),
a supramundane first jhāna joy; root — diṭṭhigat- greed, paṭigh- hate, vicikicch- delusion with doubt, uddhacc- delusion with restlessness, wholesome and
supramundane beautiful, a sense-sphere resultant or functional with no ñāṇa word rootless; knowledge — ñāṇasampayutt- (or supramundane); view —
diṭṭhigatasampayutt-; element — the last named sense-consciousness (eye 1 … body 5), the word 'manodhātu' the mind-element, else mind-consciousness; jhāna and path —
'paṭham-' 1 for the supramundane.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import pada as P

EXTENSION = {
    **{t: "vedanā" for t in ["upekkhā", "upekkhindriyaṃ", "domanassaṃ", "domanassindriyaṃ", "dukkhaṃ", "dukkhindriyaṃ", "sukhindriyaṃ"]},
    "micchādiṭṭhi": "diṭṭhi", "micchāsaṅkappo": "vitakka", "micchāvāyāmo": "vīriya", "micchāsamādhi": "ekaggatā",
    "ahirikabalaṃ": "ahirika", "ahirikaṃ": "ahirika", "anottappabalaṃ": "anottappa", "anottappaṃ": "anottappa",
    "lobho": "lobha", "abhijjhā": "lobha", "moho": "moha", "doso": "dosa", "byāpādo": "dosa",
    "vicikicchā": "vicikicchā", "uddhaccaṃ": "uddhacca",
    "sammāvācā": "sammāvācā", "sammākammanto": "sammākammanta", "sammāājīvo": "sammāājīva",
    "anaññātaññassāmītindriyaṃ": "paññā", "aññindriyaṃ": "paññā", "aññātāvindriyaṃ": "paññā",
}
LEAN_NAME = {"phassa": "phassa", "vedanā": "vedana", "saññā": "sanna", "cetanā": "cetana", "ekaggatā": "ekaggata", "jīvitindriya": "jivitindriya",
             "vitakka": "vitakka", "vicāra": "vicara", "vīriya": "viriya", "pīti": "piti", "saddhā": "saddha", "sati": "sati", "hiri": "hiri",
             "ottappa": "ottappa", "alobha": "alobha", "adosa": "adosa", "paññā": "panna", "diṭṭhi": "ditthi", "ahirika": "ahirika",
             "anottappa": "anottappa", "lobha": "lobha", "moha": "moha", "dosa": "dosa", "vicikicchā": "vicikiccha", "uddhacca": "uddhacca",
             "sammāvācā": "sammavaca", "sammākammanta": "sammakammanta", "sammāājīva": "sammaajiva",
             **{f"{p}{x}": f"{'kaya' if p == 'kāya' else 'citta'}{x.replace('ā', 'a').replace('ñ', 'n').replace('ñ', 'n')}" for p in ["kāya", "citta"] for x in P.PAIRS}}
LEAN_NAME.update({"kāyaujukatā": "kayujukata", "cittaujukatā": "cittujukata", "kāyapāguññatā": "kayapagunnata", "cittapāguññatā": "cittapagunnata", "kāyakammaññatā": "kayakammannata", "cittakammaññatā": "cittakammannata"})
SENSE = [("cakkhuviññāṇ", 1), ("sotaviññāṇ", 2), ("ghānaviññāṇ", 3), ("jivhāviññāṇ", 4), ("kāyaviññāṇ", 5)]
FEEL = [("somanassasahagat", "somanassa"), ("upekkhāsahagat", "upekkha"), ("domanassasahagat", "domanassa"), ("sukhasahagat", "sukha"), ("dukkhasahagat", "dukkha")]


def record(words):
    w = [x.strip(",").lower() for x in words]
    has = lambda pre: any(x.startswith(pre) for x in w)
    jati = "kiriya" if has("kiriy") else "vipaka" if has("vipāk") else "akusala" if has("akusal") else "kusala"
    bhumi = "lokuttara" if has("lokuttar") else "rupa" if has("rūpāvacar") else "arupa" if has("arūpāvacar") else "kama"
    feels = [v for x in w for pre, v in FEEL if x.startswith(pre)]
    vedana = feels[-1] if feels else ("somanassa" if bhumi == "lokuttara" else "upekkha")
    if jati == "akusala":
        root = "lobha" if has("diṭṭhigat") else "dosa" if has("paṭigh") else "mohaDoubt" if has("vicikicch") else "mohaRestless"
    elif jati == "kusala" or bhumi != "kama" or has("ñāṇ"):
        root = "beautiful"
    else:
        root = "none"
    named = [d for x in w for pre, d in SENSE if x.startswith(pre)]
    dhatu = f".sense {named[-1]}" if named else (".mano" if "manodhātu" in w else ".manovinnana")
    rec = {"jati": jati, "bhumi": bhumi, "vedana": vedana, "root": root, "dhatu": dhatu,
           "ofKusala": "false" if (jati == "vipaka" and has("akusalass")) else "true",
           "knowing": "true" if (has("ñāṇasampayutt") or bhumi == "lokuttara") else "false",
           "view": "true" if has("diṭṭhigatasampayutt") else "false", "prompted": "true" if has("sasaṅkhār") else "false",
           "jhana": "1" if (bhumi == "lokuttara" and has("paṭham")) else "0", "path": "1" if (bhumi == "lokuttara" and has("paṭham")) else "0"}
    return rec


def build():
    d = json.load(open(os.path.join(REPO, "cittuppada", "CITTUPPADA.json"), encoding="utf-8"))
    out = []
    for c in d["classes"]:
        if c["elided"]:
            continue
        terms = [P.norm(t) for t in c["padas"]]
        mapped = [(t, P.MAP.get(t) or EXTENSION.get(t)) for t in terms]
        listed = sorted({m for _, m in mapped if m and m != "CITTA"})
        out.append({"line": c["line"], "rec": record(c["features"]), "listed": listed, "open": c["ye_va_pana"],
                    "unmapped": [t for t, m in mapped if m is None]})
    return out


def lean(rows):
    L = ["/-", "  sangaha/CanonAll.lean — GENERATED by canon/allcanon.py (⛔ never edited by hand): the Dhammasaṅgaṇī's 23 fully written lists, each with its citta record",
         "  (built from its feature words by declared rules), its listed terms mapped onto the 52 (the pre-registered map + this run's declared extension), and its open",
         "  'ye vā pana' clause. DATA for run 2026-11-22-cittuppada-against-the-manual; the comparison is CheckCanonAll.lean.", "-/", "import Rules",
         "namespace FormalAbhidhamma", "open Cetasika", "",
         "structure CanonRow where\n  line : Nat\n  citta : Citta\n  listed : List Cetasika\n  openClause : Bool\n  unmapped : Nat\n", "def canonRows : List CanonRow := ["]
    rec = lambda r: ("{ jati := .%s, bhumi := .%s, vedana := .%s, root := .%s, dhatu := %s, ofKusala := %s, knowing := %s, view := %s, prompted := %s, jhana := %s, path := %s }"
                     % (r["jati"], r["bhumi"], r["vedana"], r["root"], r["dhatu"], r["ofKusala"], r["knowing"], r["view"], r["prompted"], r["jhana"], r["path"]))
    L.append(",\n".join("  ⟨%d, %s, [%s], %s, %d⟩" % (x["line"], rec(x["rec"]), ", ".join(LEAN_NAME[m] for m in x["listed"]), "true" if x["open"] else "false", len(x["unmapped"])) for x in rows))
    L += ["]", "", "end FormalAbhidhamma"]
    return "\n".join(L) + "\n"


if __name__ == "__main__":
    rows = build(); text = lean(rows); p = os.path.join(REPO, "sangaha", "CanonAll.lean")
    if sys.argv[1:] == ["--check"]:
        ok = os.path.exists(p) and open(p, encoding="utf-8").read() == text
        print("CanonAll.lean is current" if ok else "STALE: CanonAll.lean"); sys.exit(0 if ok else 1)
    open(p, "w", encoding="utf-8").write(text)
    print(f"{len(rows)} fully written lists; unmapped terms (reported, never mapped after the fact):",
          sorted({t for x in rows for t in x["unmapped"]}))
