#!/usr/bin/env python3
"""relata.py — capture step 2, increment 2 (founder 2026-10-13: "link each condition to what it relates").

  scripts/relata.py            regenerate matika/RELATA.md and matika/Relata.lean from the clause table below
  scripts/relata.py --verify   check every clause's probe phrases on its cited CST line (local CST only; never in CI)
  scripts/relata.py --check    exit 1 if a generated file is stale

The Paṭṭhāna's own definitions (its *niddesa*, `abh03m7.mul.xml:37–265`) say, for each of the 24 conditions, WHAT conditions
WHAT. This table is a READING of those clauses, one row per clause: what conditions (mind · matter · concept), what is
conditioned, the time relation where the clause's own words state one, and the CST line. Every interpretive step is marked
in `note`. Only romanized canonical TERMS are written out (the CST rule, PREREGISTRATION-2026-09-27b.md §5).

The KNOWN ANSWER it is checked against (kala/ANSWERS.md "Saṅgaha ch. 8 grouping"): the Abhidhammattha-saṅgaha sorts the 24
into six groups by what conditions what (§15–26, `abh07t.nrf.xml:2845–2901`): mind→mind 6 · mind→mind-and-matter 5 ·
mind→matter 1 · matter→mind 1 · concepts, mind and matter→mind 2 · mind-and-matter→mind-and-matter 9. PREDICTED before the
Lean ran (2026-10-13): from the niddesa alone, 23 of 24 placements follow; vipāka does not (the niddesa defines it among the
mental aggregates only), and the Paṭṭhāna's detailed section (§428, `abh03m7.mul.xml:6093`) supplies the matter it conditions.
"""
import os, re, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
OUT_MD = os.path.join(REPO, "matika", "RELATA.md")
OUT_LEAN = os.path.join(REPO, "matika", "Relata.lean")

# Kinds: N = mind (citta and cetasikas; nibbāna counts as nāma, as the Saṅgaha counts it) · R = matter · P = a concept.
# Timing, ONLY where the clause's own words say it: co (sahajāta · aññamaññaṃ · sampayuttakā · taṃsamuṭṭhāna ·
# okkantikkhaṇe) · pre (purejāta) · post (pacchājāta) · ceased (samanantara-niruddhā/-vigatā; anantara) · earlier (purimā
# purimā … pacchimānaṃ) · done (kaṭattā — because it was done) · unstated.
# (condition, line, from-terms, from-kinds, to-terms, to-kinds, timing, source, probes on the line, note)
C = [
 ("hetu", 45, "hetū", "N", "hetusampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["hetū hetusampayuttakānaṃ", "taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("arammana", 49, "rūpāyatana … phoṭṭhabbāyatana", "R", "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "unstated", "niddesa", ["rūpāyatanaṃ cakkhuviññāṇadhātuyā", "manodhātuyā"], ""),
 ("arammana", 49, "sabbe dhammā", "NR", "manoviññāṇadhātu · taṃsampayuttakā", "N", "unstated", "niddesa", ["Sabbe dhammā manoviññāṇadhātuyā"], "reading: 'all dhammas' as mind and matter (nibbāna counted under mind); concepts as objects are the commentaries', not added here"),
 ("arammana", 53, "yaṃ yaṃ dhammaṃ ārabbha", "NR", "cittacetasikā dhammā", "N", "unstated", "niddesa", ["Yaṃ yaṃ dhammaṃ ārabbha", "cittacetasikā dhammā"], "reading: 'whatever dhamma' as mind and matter"),
 ("adhipati", 57, "chanda · vīriya · citta · vīmaṃsā adhipati", "N", "sampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["chandādhipati chandasampayuttakānaṃ", "taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("adhipati", 61, "yaṃ yaṃ dhammaṃ garuṃ katvā", "NR", "cittacetasikā dhammā", "N", "unstated", "niddesa", ["Yaṃ yaṃ dhammaṃ garuṃ katvā", "cittacetasikā dhammā"], "reading: 'whatever dhamma' taken as weighty, as mind and matter"),
 ("anantara", 65, "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "ceased", "niddesa", ["Anantarapaccayoti – cakkhuviññāṇadhātu", "manodhātuyā"], ""),
 ("anantara", 85, "purimā purimā kusalā · akusalā · abyākatā dhammā", "N", "pacchimā pacchimā dhammā", "N", "ceased", "niddesa", ["Purimā purimā kusalā dhammā pacchimānaṃ pacchimānaṃ kusalānaṃ dhammānaṃ anantarapaccayena"], "reading: 'abyākatā' as indeterminate CITTAS, by the section's closing clause (:97, cittacetasikā dhammā)"),
 ("anantara", 97, "yesaṃ yesaṃ dhammānaṃ anantarā", "N", "cittacetasikā dhammā", "N", "ceased", "niddesa", ["anantarā ye ye dhammā uppajjanti cittacetasikā dhammā"], ""),
 ("samanantara", 101, "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "ceased", "niddesa", ["Samanantarapaccayoti – cakkhuviññāṇadhātu"], ""),
 ("samanantara", 121, "purimā purimā kusalā · akusalā · abyākatā dhammā", "N", "pacchimā pacchimā dhammā", "N", "ceased", "niddesa", ["Purimā purimā kusalā dhammā pacchimānaṃ pacchimānaṃ kusalānaṃ dhammānaṃ samanantarapaccayena"], "reading: as for proximity (:133)"),
 ("samanantara", 133, "yesaṃ yesaṃ dhammānaṃ samanantarā", "N", "cittacetasikā dhammā", "N", "ceased", "niddesa", ["samanantarā ye ye dhammā uppajjanti cittacetasikā dhammā"], ""),
 ("sahajata", 137, "cattāro khandhā arūpino", "N", "aññamaññaṃ", "N", "co", "niddesa", ["cattāro khandhā arūpino aññamaññaṃ sahajātapaccayena"], ""),
 ("sahajata", 137, "cattāro mahābhūtā", "R", "aññamaññaṃ", "R", "co", "niddesa", ["Cattāro mahābhūtā aññamaññaṃ sahajātapaccayena"], ""),
 ("sahajata", 137, "okkantikkhaṇe nāmarūpaṃ", "NR", "aññamaññaṃ", "NR", "co", "niddesa", ["Okkantikkhaṇe nāmarūpaṃ aññamaññaṃ sahajātapaccayena"], ""),
 ("sahajata", 137, "cittacetasikā dhammā", "N", "cittasamuṭṭhānāni rūpāni", "R", "co", "niddesa", ["Cittacetasikā dhammā cittasamuṭṭhānānaṃ rūpānaṃ sahajātapaccayena"], ""),
 ("sahajata", 137, "mahābhūtā", "R", "upādārūpāni", "R", "co", "niddesa", ["Mahābhūtā upādārūpānaṃ sahajātapaccayena"], ""),
 ("sahajata", 137, "rūpino dhammā", "R", "arūpino dhammā", "N", "co", "niddesa", ["Rūpino dhammā arūpīnaṃ dhammānaṃ kiñci kāle"], "'at one time, and at another not' — co-nascent only at rebirth (the commentary)"),
 ("annamanna", 141, "cattāro khandhā arūpino", "N", "aññamaññaṃ", "N", "co", "niddesa", ["cattāro khandhā arūpino aññamaññapaccayena"], ""),
 ("annamanna", 141, "cattāro mahābhūtā", "R", "aññamaññaṃ", "R", "co", "niddesa", ["Cattāro mahābhūtā aññamaññapaccayena"], ""),
 ("annamanna", 141, "okkantikkhaṇe nāmarūpaṃ", "NR", "aññamaññaṃ", "NR", "co", "niddesa", ["Okkantikkhaṇe nāmarūpaṃ aññamaññapaccayena"], ""),
 ("nissaya", 145, "khandhā · mahābhūtā · okkantikkhaṇe nāmarūpaṃ · cittacetasikā · mahābhūtā", "NR", "aññamaññaṃ · cittasamuṭṭhānāni rūpāni · upādārūpāni", "NR", "co", "niddesa", ["cattāro khandhā arūpino aññamaññaṃ nissayapaccayena", "Mahābhūtā upādārūpānaṃ nissayapaccayena"], "the five co-nascent clauses of support, as for co-nascence"),
 ("nissaya", 149, "cakkhāyatana … kāyāyatana · yaṃ rūpaṃ nissāya", "R", "pañca viññāṇadhātuyo · manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "unstated", "niddesa", ["Cakkhāyatanaṃ cakkhuviññāṇadhātuyā taṃsampayuttakānañca dhammānaṃ nissayapaccayena", "Yaṃ rūpaṃ nissāya"], ""),
 ("upanissaya", 153, "purimā purimā kusalā · akusalā · abyākatā dhammā", "N", "pacchimā pacchimā dhammā", "N", "earlier", "niddesa", ["Upanissayapaccayoti – purimā purimā kusalā dhammā"], "reading: the conditioned 'abyākatā' as mental (the Saṅgaha §20: upanissaya conditions mind only); the conditioning abyākata states read as mental here, matter entering by :165"),
 ("upanissaya", 165, "utu · bhojana · senāsana", "R", "(no relatum named)", "N", "unstated", "niddesa", ["Utubhojanampi upanissayapaccayena", "Senāsanampi upanissayapaccayena"], "reading: the clause names no relatum; mind, as the Saṅgaha (§20). A lodging read as matter"),
 ("upanissaya", 165, "puggala", "P", "(no relatum named)", "N", "unstated", "niddesa", ["Puggalopi upanissayapaccayena"], "reading: a person is a designation (paññatti), not a dhamma"),
 ("purejata", 169, "cakkhāyatana … kāyāyatana", "R", "pañca viññāṇadhātuyo · taṃsampayuttakā", "N", "pre", "niddesa", ["Purejātapaccayoti – cakkhāyatanaṃ cakkhuviññāṇadhātuyā"], ""),
 ("purejata", 173, "rūpāyatana … phoṭṭhabbāyatana", "R", "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "pre", "niddesa", ["Rūpāyatanaṃ cakkhuviññāṇadhātuyā taṃsampayuttakānañca dhammānaṃ purejātapaccayena"], ""),
 ("purejata", 177, "yaṃ rūpaṃ nissāya", "R", "manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "pre", "niddesa", ["Yaṃ rūpaṃ nissāya manodhātu ca manoviññāṇadhātu ca vattanti"], "to mind-consciousness 'at one time, and at another not'"),
 ("pacchajata", 181, "pacchājātā cittacetasikā dhammā", "N", "purejāto ayaṃ kāyo", "R", "post", "niddesa", ["pacchājātā cittacetasikā dhammā purejātassa imassa kāyassa"], ""),
 ("asevana", 185, "purimā purimā kusalā · akusalā · kiriyābyākatā dhammā", "N", "pacchimā pacchimā dhammā", "N", "earlier", "niddesa", ["Āsevanapaccayoti – purimā purimā kusalā dhammā", "kiriyābyākatā dhammā"], "'kiriyābyākata' — functional, hence mental"),
 ("kamma", 189, "kusalākusalaṃ kammaṃ", "N", "vipākā khandhā · kaṭattā rūpāni", "NR", "done", "niddesa", ["kusalākusalaṃ kammaṃ vipākānaṃ khandhānaṃ kaṭattā ca rūpānaṃ"], ""),
 ("kamma", 189, "cetanā", "N", "sampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["Cetanā sampayuttakānaṃ dhammānaṃ taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("vipaka", 193, "vipākā cattāro khandhā arūpino", "N", "aññamaññaṃ", "N", "co", "niddesa", ["vipākā cattāro khandhā arūpino aññamaññaṃ vipākapaccayena"], "the niddesa names only the mental aggregates"),
 ("vipaka", 6093, "vipākābyākato khandho", "N", "khandhā · cittasamuṭṭhānāni rūpāni", "NR", "co", "panhavara", ["vipākābyākato eko khandho tiṇṇannaṃ khandhānaṃ cittasamuṭṭhānānañca rūpānaṃ vipākapaccayena"], "the Paṭṭhāna's DETAILED section (§428), not its niddesa"),
 ("ahara", 197, "kabaḷīkāro āhāro", "R", "ayaṃ kāyo", "R", "unstated", "niddesa", ["āhāro imassa kāyassa āhārapaccayena"], ""),
 ("ahara", 197, "arūpino āhārā", "N", "sampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["Arūpino āhārā sampayuttakānaṃ dhammānaṃ taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("indriya", 201, "cakkhundriya … kāyindriya", "R", "pañca viññāṇadhātuyo · taṃsampayuttakā", "N", "unstated", "niddesa", ["Indriyapaccayoti – cakkhundriyaṃ cakkhuviññāṇadhātuyā"], ""),
 ("indriya", 201, "rūpajīvitindriya", "R", "kaṭattārūpāni", "R", "unstated", "niddesa", ["Rūpajīvitindriyaṃ kaṭattārūpānaṃ indriyapaccayena"], ""),
 ("indriya", 205, "arūpino indriyā", "N", "sampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["Arūpino indriyā sampayuttakānaṃ dhammānaṃ taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("jhana", 209, "jhānaṅgāni", "N", "jhānasampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["jhānaṅgāni jhānasampayuttakānaṃ dhammānaṃ taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("magga", 213, "maggaṅgāni", "N", "maggasampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["maggaṅgāni maggasampayuttakānaṃ dhammānaṃ taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("sampayutta", 217, "cattāro khandhā arūpino", "N", "aññamaññaṃ", "N", "co", "niddesa", ["cattāro khandhā arūpino aññamaññaṃ sampayuttapaccayena"], ""),
 ("vippayutta", 221, "rūpino dhammā", "R", "arūpino dhammā", "N", "unstated", "niddesa", ["rūpino dhammā arūpīnaṃ dhammānaṃ vippayuttapaccayena"], ""),
 ("vippayutta", 221, "arūpino dhammā", "N", "rūpino dhammā", "R", "unstated", "niddesa", ["Arūpino dhammā rūpīnaṃ dhammānaṃ vippayuttapaccayena"], ""),
 ("atthi", 225, "khandhā · mahābhūtā · okkantikkhaṇe nāmarūpaṃ · cittacetasikā · mahābhūtā", "NR", "aññamaññaṃ · cittasamuṭṭhānāni rūpāni · upādārūpāni", "NR", "co", "niddesa", ["cattāro khandhā arūpino aññamaññaṃ atthipaccayena", "Mahābhūtā upādārūpānaṃ atthipaccayena"], "the five co-nascent clauses of presence"),
 ("atthi", 229, "cakkhāyatana … kāyāyatana · rūpāyatana … phoṭṭhabbāyatana · yaṃ rūpaṃ nissāya", "R", "pañca viññāṇadhātuyo · manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "unstated", "niddesa", ["Cakkhāyatanaṃ cakkhuviññāṇadhātuyā taṃsampayuttakānañca dhammānaṃ atthipaccayena"], "bases (:229), objects (:233) and the heart-base (:237)"),
 ("natthi", 241, "samanantaraniruddhā cittacetasikā dhammā", "N", "paṭuppannā cittacetasikā dhammā", "N", "ceased", "niddesa", ["samanantaraniruddhā cittacetasikā dhammā paṭuppannānaṃ"], ""),
 ("vigata", 245, "samanantaravigatā cittacetasikā dhammā", "N", "paṭuppannā cittacetasikā dhammā", "N", "ceased", "niddesa", ["samanantaravigatā cittacetasikā dhammā paṭuppannānaṃ"], ""),
 ("avigata", 249, "khandhā · mahābhūtā · okkantikkhaṇe nāmarūpaṃ · cittacetasikā · mahābhūtā", "NR", "aññamaññaṃ · cittasamuṭṭhānāni rūpāni · upādārūpāni", "NR", "co", "niddesa", ["cattāro khandhā arūpino aññamaññaṃ avigatapaccayena", "Mahābhūtā upādārūpānaṃ avigatapaccayena"], "the five co-nascent clauses of non-disappearance"),
 ("avigata", 253, "cakkhāyatana … kāyāyatana · rūpāyatana … phoṭṭhabbāyatana · yaṃ rūpaṃ nissāya", "R", "pañca viññāṇadhātuyo · manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "unstated", "niddesa", ["Cakkhāyatanaṃ cakkhuviññāṇadhātuyā taṃsampayuttakānañca dhammānaṃ avigatapaccayena"], "bases (:253), objects (:257) and the heart-base (:261)"),
]
ORDER = ["hetu", "arammana", "adhipati", "anantara", "samanantara", "sahajata", "annamanna", "nissaya", "upanissaya",
         "purejata", "pacchajata", "asevana", "kamma", "vipaka", "ahara", "indriya", "jhana", "magga", "sampayutta",
         "vippayutta", "atthi", "natthi", "vigata", "avigata"]
# The Saṅgaha's own placement (§16–§26), the known answer.
SANGAHA = {**{c: "namaToNama" for c in ["anantara", "samanantara", "natthi", "vigata", "asevana", "sampayutta"]},
           **{c: "namaToNamarupa" for c in ["hetu", "jhana", "magga", "kamma", "vipaka"]},
           "pacchajata": "namaToRupa", "purejata": "rupaToNama",
           **{c: "allToNama" for c in ["arammana", "upanissaya"]},
           **{c: "namarupaToNamarupa" for c in ["adhipati", "sahajata", "annamanna", "nissaya", "ahara", "indriya",
                                                 "vippayutta", "atthi", "avigata"]}}

def verify():
    files = {}
    def line(f, n):
        if f not in files: files[f] = open(os.path.join(CST, f), "rb").read().decode("utf-16").splitlines()
        # the CST carries runs of spaces ("Anantarapaccayoti  –"): collapse whitespace on BOTH sides; the words stay exact
        return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", files[f][n - 1]))
    bad = 0
    for (c, n, *_, probes, note) in C:
        text = line("abh03m7.mul.xml", n)
        for p in probes:
            if re.sub(r"\s+", " ", p) not in text: print(f"✗ {c} :{n} — '{p}' not on the line"); bad += 1
    print(f"verify: {len(C)} clauses, {sum(len(x[8]) for x in C)} probes, {bad} missing"); return bad

def kinds(s): return ", ".join({"N": ".nama", "R": ".rupa", "P": ".pannatti"}[ch] for ch in s)

def build():
    md = ["# RELATA — what each of the 24 conditions relates (the Paṭṭhāna's definitions, read clause by clause)", "",
          "*GENERATED by `scripts/relata.py` from its clause table — a READING of the Paṭṭhāna's niddesa (`abh03m7.mul.xml:37–265`),",
          "every interpretive step marked; romanized canonical terms only. `--verify` checks each clause's phrases on its cited line.*", "",
          "**Kinds:** N mind (citta and cetasikas; nibbāna counted as nāma) · R matter · P a concept. **Timing** only where the clause's own",
          "words state it. **Source:** the niddesa, or (one clause) the Paṭṭhāna's detailed section.", "",
          "| # | Condition | From | → To | Kinds | Timing | Line | Source | Reading |", "|---|---|---|---|---|---|---|---|---|"]
    for i, (c, n, ft, fk, tt, tk, tm, src, _, note) in enumerate(C, 1):
        md.append(f"| {i} | {c} | {ft} | {tt} | {fk}→{tk} | {tm} | `:{n}` | {src} | {note or '—'} |")
    lean = ["/-", "  Relata.lean — GENERATED by scripts/relata.py (capture step 2, increment 2, 2026-10-13). What each of the 24 conditions",
            "  relates, read from the Paṭṭhāna's niddesa clause by clause, and the Saṅgaha's six-way grouping (§15–26) as the known",
            "  answer it is checked against.", "-/", "namespace FormalAbhidhamma.Relata", "",
            "inductive Condition | " + " | ".join(ORDER), "  deriving DecidableEq, Repr", "",
            "inductive Kind | nama | rupa | pannatti", "  deriving DecidableEq, Repr", "",
            "inductive Timing | co | pre | post | ceased | earlier | done | unstated", "  deriving DecidableEq, Repr", "",
            "inductive Source | niddesa | panhavara", "  deriving DecidableEq, Repr", "",
            "structure Clause where", "  cond : Condition", "  src : List Kind", "  dst : List Kind", "  timing : Timing",
            "  line : Nat", "  source : Source", "", "def clauses : List Clause := ["]
    lean.append(",\n".join(f"  ⟨.{c}, [{kinds(fk)}], [{kinds(tk)}], .{tm}, {n}, .{src}⟩" for (c, n, ft, fk, tt, tk, tm, src, _, _) in C))
    lean += ["]", "",
             "/-- The Saṅgaha's six groups (§15–26, `abh07t.nrf.xml:2845–2901`). -/",
             "inductive Group | namaToNama | namaToNamarupa | namaToRupa | rupaToNama | allToNama | namarupaToNamarupa",
             "  deriving DecidableEq, Repr", "",
             "/-- What the clauses (from the given sources) say a condition relates: the kinds on each side, unioned. -/",
             "def sides (srcs : List Source) (c : Condition) : List Kind × List Kind :=",
             "  let cs := clauses.filter (fun x => x.cond == c && srcs.contains x.source)",
             "  (cs.flatMap (·.src), cs.flatMap (·.dst))", "",
             "/-- The group those sides fall in. Concepts count only on the conditioning side, as the Saṅgaha's 'concepts, mind and",
             "    matter → mind'. -/",
             "def classify (s : List Kind × List Kind) : Option Group :=",
             "  let fN := s.1.contains .nama; let fR := s.1.contains .rupa",
             "  let tN := s.2.contains .nama; let tR := s.2.contains .rupa",
             "  if fN && !fR && tN && !tR then some .namaToNama",
             "  else if fN && !fR && tN && tR then some .namaToNamarupa",
             "  else if fN && !fR && !tN && tR then some .namaToRupa",
             "  else if !fN && fR && tN && !tR then some .rupaToNama",
             "  else if fR && fN && tN && !tR then some .allToNama",
             "  else if fN && fR && tN && tR then some .namarupaToNamarupa",
             "  else none", "",
             "/-- The Saṅgaha's placement — the KNOWN ANSWER (kala/ANSWERS.md \"Saṅgaha ch. 8 grouping\"). -/",
             "def sangaha : Condition → Group"]
    lean += [f"  | .{c} => .{SANGAHA[c]}" for c in ORDER]
    lean += ["", "def all : List Condition := [" + ", ".join(f".{c}" for c in ORDER) + "]", "",
             "/-- Every condition has at least one clause in the niddesa. -/",
             "theorem every_condition_defined : all.all (fun c => clauses.any (fun x => x.cond == c && x.source == .niddesa)) = true := by decide", "",
             "/-- The Saṅgaha's counts: 6 · 5 · 1 · 1 · 2 · 9. -/",
             "theorem sangaha_counts : (all.filter (sangaha · == .namaToNama)).length = 6 ∧ (all.filter (sangaha · == .namaToNamarupa)).length = 5 ∧",
             "    (all.filter (sangaha · == .namaToRupa)).length = 1 ∧ (all.filter (sangaha · == .rupaToNama)).length = 1 ∧",
             "    (all.filter (sangaha · == .allToNama)).length = 2 ∧ (all.filter (sangaha · == .namarupaToNamarupa)).length = 9 := by decide", "",
             "/-- FROM THE NIDDESA ALONE, 23 of the Saṅgaha's 24 placements follow — and the one that does not is vipāka. -/",
             "theorem niddesa_gives_23 :",
             "    (all.filter (fun c => classify (sides [.niddesa] c) == some (sangaha c))).length = 23 ∧",
             "    all.filter (fun c => classify (sides [.niddesa] c) != some (sangaha c)) = [.vipaka] := by decide", "",
             "/-- The niddesa's vipāka is mind → mind; the Saṅgaha places it mind → mind-and-matter. -/",
             "theorem niddesa_vipaka_is_mind_to_mind : classify (sides [.niddesa] .vipaka) = some .namaToNama := by decide", "",
             "/-- With the Paṭṭhāna's detailed section (§428) for vipāka, all 24 follow. -/",
             "theorem with_the_detailed_section_all_24 : all.all (fun c => classify (sides [.niddesa, .panhavara] c) == some (sangaha c)) = true := by decide", "",
             "end FormalAbhidhamma.Relata", ""]
    return "\n".join(md) + "\n", "\n".join(lean)

if __name__ == "__main__":
    if "--verify" in sys.argv: sys.exit(1 if verify() else 0)
    md, lean = build()
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_MD, md), (OUT_LEAN, lean)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale: print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("matika/RELATA is current"); sys.exit(0)
    open(OUT_MD, "w", encoding="utf-8").write(md); open(OUT_LEAN, "w", encoding="utf-8").write(lean)
    print(f"{len(C)} clauses written")
