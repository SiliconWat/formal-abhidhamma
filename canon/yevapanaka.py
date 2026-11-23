#!/usr/bin/env python3
"""yevapanaka.py — run 2026-11-22-yevapanaka-against-the-manual: the Atthasālinī's YEVĀPANAKA (the factors its "ye vā pana … aññepi atthi" leaves to the
commentary) for each of the Dhammasaṅgaṇī's 23 fully written lists (sangaha/CanonAll.lean), and which of them it calls VARIABLE, as DATA — read from the CST and
CHECKED word by word at the cited line before anything is written. Writes sangaha/Yevapanaka.lean. COMPUTES NO COMPARISON: that is sangaha/CheckYevapanaka.lean,
written after the registration.   yevapanaka.py --check exits 1 if Yevapanaka.lean is stale.

How each class's set is given (KIND):
  named        — the commentary names the factors for this class                                             (the words are checked at the line)
  subtraction  — the supramundane path: the first wholesome class's nine minus the abstinences (listed in the Pāli) and compassion and appreciative joy
                 (their object is beings, the path's is nibbāna)                                               (:6621; its words are checked)
  reference    — the commentary refers this class to another ("…sadisameva", "…vuttanayeneva", "pākatikameva") (the reference phrase is checked)
  implicit     — the commentary states only this class's differences (feeling, rapture) and names no yevāpanaka (:5497, the fifth wholesome class)
VARIABLE (P2): the commentary's own words — the wholesome nine, four at one moment and the rest at different moments (:5053, "sesā nānākkhaṇe"); the hate class,
four fixed and envy, avarice, remorse variable (:7265, "aniyatayevāpanakā"); the third unwholesome class, "Idha mānena saddhiṃ pañca apaṇṇakaṅgāni" (:7217) —
read on its SURFACE (conceit among the sure factors) and as the Mūlaṭīkā reads it (abh01t.tik.xml:1729: "Mānassa aniyatattā na niyatayevāpanakā"). The Saṅgaha's
occasional factors: ch. 2 §33 (abh07t.nrf.xml:553, :557).
"""
import os, re, sys, unicodedata
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(REPO, "dhatukatha")); sys.path.insert(0, os.path.join(REPO, "scripts"))

ATT, TIKA, SANGAHA = "abh01a.att.xml", "abh01t.tik.xml", "abh07t.nrf.xml"
NINE = ["chanda", "adhimokkha", "manasikara", "tatramajjhattata", "karuna", "mudita", "sammavaca", "sammakammanta", "sammaajiva"]
# (CanonAll line, kind, cited line, the Pāli that must stand on the cited line, the set — or the line it refers to)
ROWS = [
    (1569, "named", 5045, ["chando", "adhimokkho", "manasikāro", "tatramajjhattatā", "karuṇā", "muditā", "kāyaduccaritavirati", "vacīduccaritavirati", "micchājīvaviratī", "yevāpanakavasena"], NINE),
    (2233, "reference", 5473, ["Tatiye", "ñāṇavippayuttaṃ", "Sesaṃ pākatikamevāti"], 1569),
    (2257, "implicit", 5497, ["Pañcame upekkhāsahagata"], 1569),
    (2301, "reference", 5509, ["Chaṭṭhasattamaaṭṭhamāni dutiyatatiyacatutthesu vuttanayeneva", "Karuṇāmuditā parikammakālepi"], 2233),
    (3041, "subtraction", 6621, ["Yevāpanakesu ca imesaṃ abhāvo", "Tathā karuṇāmuditānaṃ"], ["chanda", "adhimokkha", "manasikara", "tatramajjhattata"]),
    (3473, "named", 7121, ["chando adhimokkho manasikāro uddhaccanti ime apaṇṇakaṅgasaṅkhātā cattārova yevāpanakā"], ["chanda", "adhimokkha", "manasikara", "uddhacca"]),
    (3617, "named", 7217, ["Tatiyaṃ", "aparāmasantassa", "Idha mānena saddhiṃ pañca apaṇṇakaṅgāni"], ["chanda", "adhimokkha", "manasikara", "uddhacca", "mana"]),
    (3633, "reference", 7233, ["Pañcamaṃ", "parāmasantassa", "Sesaṃ sabbaṃ paṭhamacittasadisameva"], 3473),
    (3665, "reference", 7241, ["Chaṭṭhasattamaṭṭhamānipi", "dutiyatatiyacatutthesu vuttanayeneva"], 3617),
    (3681, "named", 7265, ["Yevāpanakesu chandādhimokkhamanasikārauddhaccāni niyatāni", "Issāmacchariyakukkuccesu"], ["chanda", "adhimokkha", "manasikara", "uddhacca", "issa", "macchariya", "kukkucca"]),
    (3721, "named", 7297, ["Manasikāro uddhaccanti dveyeva yevāpanakā"], ["manasikara", "uddhacca"]),
    (3745, "named", 7313, ["Adhimokkho manasikāroti dveyeva yevāpanakā"], ["adhimokkha", "manasikara"]),
    (3777, "named", 7349, ["Yevāpanako eko manasikāro eva"], ["manasikara"]),
    (3829, "reference", 7357, ["Sotaviññāṇādiniddesāpi imināva nayena veditabbā"], 3777),
    (3889, "named", 7369, ["Adhimokkho manasikāroti dve yevāpanakā"], ["adhimokkha", "manasikara"]),
    (3957, "reference", 7373, ["Manoviññāṇadhātuniddesesu", "Padāni manodhātuniddesasadisāneva"], 3889),
    (4029, "reference", 7373, ["Dutiyamanoviññāṇadhātu", "Padāni manodhātuniddesasadisāneva"], 3889),
    (4441, "reference", 7793, ["akusalavipākāni", "kusalavipākacittehi sadisāni"], 3829),
    (4477, "reference", 7793, ["ekā manodhātu", "kusalavipākacittehi sadisāni"], 3889),
    (4497, "reference", 7793, ["ekā manoviññāṇadhātū", "kusalavipākacittehi sadisāni"], 4029),
    (4525, "reference", 7817, ["vipākamanodhātuniddese vuttanayeneva"], 3889),
    (4545, "reference", 7837, ["somanassasahagatāhetukamanoviññāṇadhātuniddese vuttanayeneva"], 3957),
    (4581, "reference", 7841, ["Upekkhāsahagatāti", "purimacitte vuttanayeneva"], 4545),
]
# VARIABLE yevāpanaka, by the commentary's words (a class not listed has none, or takes its referent's): (CanonAll line, cited file, line, words, set)
VARIABLE = [
    (1569, ATT, 5053, ["chando adhimokkho manasikāro tatramajjhattatāti ime cattārova ekakkhaṇe labbhanti, sesā nānākkhaṇe"], ["karuna", "mudita", "sammavaca", "sammakammanta", "sammaajiva"]),
    (3681, ATT, 7265, ["Evamepi tayo dhammā aniyatayevāpanakā nāma"], ["issa", "macchariya", "kukkucca"]),
]
SURFACE_3617 = []          # :7217 on its surface: conceit among the five sure factors (apaṇṇakaṅgāni) — nothing variable
TIKA_3617 = (TIKA, 1729, ["Mānassa aniyatattā na niyatayevāpanakāti"], ["mana"])
SANGAHA_OCCASIONAL = [(SANGAHA, 553, ["Issāmaccherakukkucca-viratikaruṇādayo"]), (SANGAHA, 557, ["Nānā kadāci māno ca, thina middhaṃ tathā saha"])]
OCCASIONAL = ["issa", "macchariya", "kukkucca", "sammavaca", "sammakammanta", "sammaajiva", "karuna", "mudita", "mana", "thina", "middha"]

fold = lambda s: unicodedata.normalize("NFC", s).lower().replace("‘", "").replace("’", "").replace("'", "")


def verify():
    """Every quoted word stands on its cited CST line — or the generator refuses to write. Returns the number of quotes checked."""
    import dhatukatha as D
    clean = lambda f, n: fold(re.sub(r"\s+", " ", D.server.plain(D.server.lines(f)[n - 1])))
    checks = [(ATT, n, w) for _, _, n, words, _ in ROWS for w in words] + [(f, n, w) for _, f, n, words, _ in VARIABLE for w in words] + \
             [(TIKA_3617[0], TIKA_3617[1], w) for w in TIKA_3617[2]] + [(f, n, w) for f, n, words in SANGAHA_OCCASIONAL for w in words]
    bad = [(f, n, w) for f, n, w in checks if fold(w) not in clean(f, n)]
    if bad:
        sys.exit("✗ not on the cited line: " + "; ".join(f"{f}:{n} '{w}'" for f, n, w in bad))
    # an IMPLICIT class names no yevāpanaka at its line — or it is not implicit
    for line, kind, n, _, _ in ROWS:
        if kind == "implicit" and re.search(r"yevāpanak|apaṇṇakaṅg", clean(ATT, n)):
            sys.exit(f"✗ {line}: called implicit, but :{n} speaks of the yevāpanaka")
    return len(checks)


def resolve():
    by = {r[0]: r for r in ROWS}
    def s(line, seen=()):
        if line in seen: sys.exit(f"✗ a reference cycle at {line}")
        v = by[line][4]
        return v if isinstance(v, list) else s(v, seen + (line,))
    var = {line: v for line, _, _, _, v in VARIABLE}
    def vr(line, tika):
        if line == 3617: return TIKA_3617[3] if tika else SURFACE_3617
        if line in var: return var[line]
        v = by[line][4]
        return vr(v, tika) if not isinstance(v, list) else []
    return [(line, kind, n, s(line), vr(line, False), vr(line, True), by[line][4] if not isinstance(by[line][4], list) else 0) for line, kind, n, _, _ in ROWS]


def lean(rows):
    L = lambda xs: "[" + ", ".join(xs) + "]"
    out = ["/-", "  sangaha/Yevapanaka.lean — GENERATED by canon/yevapanaka.py (⛔ never edited by hand): for each of the Dhammasaṅgaṇī's 23 fully written lists, the",
           "  Atthasālinī's yevāpanaka (named · by subtraction · by reference · implicit), its VARIABLE ones (on the surface of :7217 and as the Mūlaṭīkā reads it), and the",
           "  Saṅgaha's occasional factors (ch. 2 §33). Every quoted word was checked at its cited CST line before this was written. DATA for run",
           "  2026-11-22-yevapanaka-against-the-manual; the comparison is CheckYevapanaka.lean.", "-/", "import Cetasika", "namespace FormalAbhidhamma", "open Cetasika", "",
           "structure YevRow where\n  line : Nat\n  kind : String\n  cite : Nat\n  yev : List Cetasika\n  varSurface : List Cetasika\n  varTika : List Cetasika\n  refersTo : Nat\n",
           "def yevRows : List YevRow := ["]
    out.append(",\n".join(f'  ⟨{line}, "{kind}", {n}, {L(s)}, {L(vs)}, {L(vt)}, {ref}⟩' for line, kind, n, s, vs, vt, ref in rows))
    out += ["]", "", "/-- The Saṅgaha's occasional factors, ch. 2 §33 (abh07t.nrf.xml:553, :557): envy, avarice, remorse, the abstinences, compassion and the rest — separately",
            "    and occasionally; conceit occasionally; sloth and torpor together. §34: the rest are fixed (niyatayogino). -/",
            f"def occasionalSangaha : List Cetasika := {L(OCCASIONAL)}", "", "end FormalAbhidhamma"]
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    have_cst = os.path.isdir(os.path.join(REPO, "..", "tipitaka-mcp"))
    # the data's header says every quote was checked: so it may be WRITTEN only where they can be (the run's refuter, 2026-11-22); --check runs anywhere
    if not have_cst and sys.argv[1:] != ["--check"]:
        sys.exit("✗ the CST is not here: Yevapanaka.lean is written only where every quote can be checked at its line (run --check to compare without it)")
    n = verify() if have_cst else 0
    rows = resolve(); text = lean(rows); p = os.path.join(REPO, "sangaha", "Yevapanaka.lean")
    if sys.argv[1:] == ["--check"]:
        ok = os.path.exists(p) and open(p, encoding="utf-8").read() == text
        print(("Yevapanaka.lean is current" if ok else "STALE: Yevapanaka.lean") + (f" · {n} quotes checked at their lines" if have_cst else " · CST not here: quotes not re-read"))
        sys.exit(0 if ok else 1)
    open(p, "w", encoding="utf-8").write(text)
    from collections import Counter
    print(f"{n} quotes checked at their cited lines · kinds: {dict(Counter(r[1] for r in rows))} · wrote {os.path.relpath(p, REPO)}")
