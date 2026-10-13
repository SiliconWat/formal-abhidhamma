#!/usr/bin/env python3
"""relata.py — capture step 2, increment 2 (founder 2026-10-13: "link each condition to what it relates").

  scripts/relata.py            regenerate matika/RELATA.md and matika/Relata.lean from the clause table below
  scripts/relata.py --verify   check every clause's probe phrases on its cited CST line (local CST only; never in CI)
  scripts/relata.py --check    exit 1 if a generated file is stale, or if any reading leans on the held-out answer (CI)

The Paṭṭhāna's own definitions (its *niddesa*, `abh03m7.mul.xml:37–265`) say, for each of the 24 conditions, WHAT conditions
WHAT. This table is a READING of those clauses, one row per clause: what conditions (mind · matter · concept), what is
conditioned, the time relation where the clause's own words state one, and the CST line. Every interpretive step is marked
in `note`. Only romanized canonical TERMS are written out (the CST rule, PREREGISTRATION-2026-09-27b.md §5).

The KNOWN ANSWER it is checked against (kala/ANSWERS.md "Saṅgaha ch. 8 grouping"): the Abhidhammattha-saṅgaha sorts the 24
into six groups by what conditions what (§15–20, §26, `abh07t.nrf.xml:2845–2877`, `:2901`). ⛔ No reading below may lean on it
(`answer_free`, run on every build and by `--check` in CI): the first version did, for decisive support, and its refuter
caught it.

⚠️ CORRECTED 2026-10-13 after the refuter (first version `bf3cad6`, which claimed "23 of 24 from the niddesa alone"): that
figure came from readings that were not uniform (the same "whatever dhamma" read as mind and matter at `:61`, mind only at
`:97`), from the Saṅgaha's own answer used as a premise, and from a classifier that never looked at concepts. Now:
  • An indefinite side is OPEN — a "whatever dhamma(s)" phrase, a relatum the clause does not name, or the class term
    *abyākata* (its extension includes matter, Dhammasaṅgaṇī `abh01m.mul.xml:4669`). Read literally, an open side takes every
    kind it could name. The rule is fixed in advance of any count: the detailed section (pañhāvāra, kusala triad) is
    consulted for EVERY condition with an open side, and there its enumeration replaces the open side.
  • Result (vipāka) has no open side; its detailed-section clause (§428) was consulted only BECAUSE it failed — outcome-
    selected, and kept in its own source so the counts show it.
  • Whether "all dhammas" (`:49`) and "whatever dhamma" take in designations is a Piṭaka-layer reading both ways: the
    Dhammasaṅgaṇī itself calls them dhammas (`abh01m.mul.xml:8453`, *ime dhammā paññatti*), and the commentaries' later
    distinction sets concepts apart. Both readings are checked; a `+` marks the sides that split on it.
Kind strings: N mind · R matter · P concept · `*` OPEN · `+` takes P under the inclusive reading.
"""
import os, re, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CST = "/Users/siliconwat/Desktop/MA/SW/siliconwat.dev/bedok.siliconwat.dev/tipitaka/india/roman"
OUT_MD = os.path.join(REPO, "matika", "RELATA.md")
OUT_LEAN = os.path.join(REPO, "matika", "Relata.lean")
FILES = {"commentary": "abh03a.att.xml"}   # every other source is the Paṭṭhāna mūla, abh03m7.mul.xml

# Kinds: N = mind (citta and cetasikas; nibbāna counted under mind — a declared reading) · R = matter · P = a concept.
# Timing, ONLY where the clause's own words say it: co (sahajāta · aññamaññaṃ · sampayuttakā · taṃsamuṭṭhāna ·
# okkantikkhaṇe) · pre (purejāta) · post (pacchājāta) · ceased (samanantara-niruddhā/-vigatā; anantara) · earlier (purimā
# purimā … pacchimānaṃ) · done (kaṭattā — because it was done) · unstated.
# Sources: niddesa · detail (the pañhāvāra, kusala triad, consulted by the OPEN-side rule) · detailByOutcome · commentary.
# (condition, line, from-terms, from-kinds, to-terms, to-kinds, timing, source, probes on the line, note)
OPEN_ABY = "the class terms kusala · akusala · abyākata; abyākata includes matter (`abh01m.mul.xml:4669`) — OPEN"
OPEN_ANY = "'whatever dhamma(s)' — OPEN"
C = [
 ("hetu", 45, "hetū", "N", "hetusampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["hetū hetusampayuttakānaṃ", "taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("arammana", 49, "rūpāyatana … phoṭṭhabbāyatana", "R", "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "unstated", "niddesa", ["rūpāyatanaṃ cakkhuviññāṇadhātuyā", "manodhātuyā"], ""),
 ("arammana", 49, "sabbe dhammā", "NR+", "manoviññāṇadhātu · taṃsampayuttakā", "N", "unstated", "niddesa", ["Sabbe dhammā manoviññāṇadhātuyā"], "'all dhammas': mind and matter; designations too under the inclusive reading (`abh01m.mul.xml:8453`)"),
 ("arammana", 53, "yaṃ yaṃ dhammaṃ ārabbha", "NR*+", "cittacetasikā dhammā", "N", "unstated", "niddesa", ["Yaṃ yaṃ dhammaṃ ārabbha", "cittacetasikā dhammā"], OPEN_ANY),
 ("adhipati", 57, "chanda · vīriya · citta · vīmaṃsā adhipati", "N", "sampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["chandādhipati chandasampayuttakānaṃ", "taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("adhipati", 61, "yaṃ yaṃ dhammaṃ garuṃ katvā", "NR*+", "cittacetasikā dhammā", "N", "unstated", "niddesa", ["Yaṃ yaṃ dhammaṃ garuṃ katvā", "cittacetasikā dhammā"], OPEN_ANY),
 ("anantara", 65, "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "ceased", "niddesa", ["Anantarapaccayoti – cakkhuviññāṇadhātu", "manodhātuyā"], ""),
 ("anantara", 85, "purimā purimā kusalā · akusalā · abyākatā dhammā", "NR*", "pacchimā pacchimā dhammā", "NR*", "ceased", "niddesa", ["Purimā purimā kusalā dhammā pacchimānaṃ pacchimānaṃ kusalānaṃ dhammānaṃ anantarapaccayena"], OPEN_ABY + " (`:85–93`)"),
 ("anantara", 97, "yesaṃ yesaṃ dhammānaṃ anantarā", "NR*+", "cittacetasikā dhammā", "N", "ceased", "niddesa", ["anantarā ye ye dhammā uppajjanti cittacetasikā dhammā"], OPEN_ANY + " on the conditioning side; the conditioned side names mind"),
 ("samanantara", 101, "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "ceased", "niddesa", ["Samanantarapaccayoti – cakkhuviññāṇadhātu"], ""),
 ("samanantara", 121, "purimā purimā kusalā · akusalā · abyākatā dhammā", "NR*", "pacchimā pacchimā dhammā", "NR*", "ceased", "niddesa", ["Purimā purimā kusalā dhammā pacchimānaṃ pacchimānaṃ kusalānaṃ dhammānaṃ samanantarapaccayena"], OPEN_ABY + " (`:121–129`)"),
 ("samanantara", 133, "yesaṃ yesaṃ dhammānaṃ samanantarā", "NR*+", "cittacetasikā dhammā", "N", "ceased", "niddesa", ["samanantarā ye ye dhammā uppajjanti cittacetasikā dhammā"], OPEN_ANY + " on the conditioning side"),
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
 ("upanissaya", 153, "purimā purimā kusalā · akusalā · abyākatā dhammā", "NR*", "pacchimā pacchimā dhammā", "NR*", "earlier", "niddesa", ["Upanissayapaccayoti – purimā purimā kusalā dhammā"], OPEN_ABY + ", on both sides (`:153–161`)"),
 ("upanissaya", 165, "utu · bhojana · senāsana", "R", "(no relatum named)", "*", "unstated", "niddesa", ["Utubhojanampi upanissayapaccayena", "Senāsanampi upanissayapaccayena"], "climate, food, lodging: matter; the clause names nothing conditioned — OPEN"),
 ("upanissaya", 165, "puggala", "P", "(no relatum named)", "*", "unstated", "niddesa", ["Puggalopi upanissayapaccayena"], "a person is a designation (the Puggalapaññatti's own title); nothing conditioned named — OPEN"),
 ("purejata", 169, "cakkhāyatana … kāyāyatana", "R", "pañca viññāṇadhātuyo · taṃsampayuttakā", "N", "pre", "niddesa", ["Purejātapaccayoti – cakkhāyatanaṃ cakkhuviññāṇadhātuyā"], ""),
 ("purejata", 173, "rūpāyatana … phoṭṭhabbāyatana", "R", "pañca viññāṇadhātuyo · manodhātu · taṃsampayuttakā", "N", "pre", "niddesa", ["Rūpāyatanaṃ cakkhuviññāṇadhātuyā taṃsampayuttakānañca dhammānaṃ purejātapaccayena"], ""),
 ("purejata", 177, "yaṃ rūpaṃ nissāya", "R", "manodhātu · manoviññāṇadhātu · taṃsampayuttakā", "N", "pre", "niddesa", ["Yaṃ rūpaṃ nissāya manodhātu ca manoviññāṇadhātu ca vattanti"], "to mind-consciousness 'at one time, and at another not'"),
 ("pacchajata", 181, "pacchājātā cittacetasikā dhammā", "N", "purejāto ayaṃ kāyo", "R", "post", "niddesa", ["pacchājātā cittacetasikā dhammā purejātassa imassa kāyassa"], ""),
 ("asevana", 185, "purimā purimā kusalā · akusalā · kiriyābyākatā dhammā", "N", "pacchimā pacchimā dhammā", "N", "earlier", "niddesa", ["Āsevanapaccayoti – purimā purimā kusalā dhammā", "kiriyābyākatā dhammā"], "'kiriyābyākata' — functional, hence mental"),
 ("kamma", 189, "kusalākusalaṃ kammaṃ", "N", "vipākā khandhā · kaṭattā rūpāni", "NR", "done", "niddesa", ["kusalākusalaṃ kammaṃ vipākānaṃ khandhānaṃ kaṭattā ca rūpānaṃ"], ""),
 ("kamma", 189, "cetanā", "N", "sampayuttakā dhammā · taṃsamuṭṭhānāni rūpāni", "NR", "co", "niddesa", ["Cetanā sampayuttakānaṃ dhammānaṃ taṃsamuṭṭhānānañca rūpānaṃ"], ""),
 ("vipaka", 193, "vipākā cattāro khandhā arūpino", "N", "aññamaññaṃ", "N", "co", "niddesa", ["vipākā cattāro khandhā arūpino aññamaññaṃ vipākapaccayena"], "the niddesa names only the mental aggregates"),
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

# The DETAILED SECTION (pañhāvāra, kusala triad), consulted by the OPEN-side rule: one row per heading ("X dhammo Y dhammassa
# …"). Kusala and akusala are mental by definition; an abyākata relatum is read from the members the clause enumerates.
def _heads(cond, rows):
    return [(cond, n, h, k1, t, k2, "unstated", "detail", [p] if isinstance(p, str) else p, note) for (n, h, k1, t, k2, p, note) in rows]
_K, _A, _B = "kusala", "akusala", "abyākata"
def _hdr(a, b, word): return f"{a.capitalize()}o dhammo {b}ssa dhammassa {word}paccayena paccayo"
C += _heads("arammana", [
 (5585, _K, "N", _K, "N", _hdr("kusal", "kusala", "ārammaṇa"), ""),
 (5589, _K, "N", _A, "N", _hdr("kusal", "akusala", "ārammaṇa"), ""),
 (5593, _K, "N", _B, "N", _hdr("kusal", "abyākata", "ārammaṇa"), "the abyākata conditioned: an arahant's reviewing and insight — functional cittas"),
 (5597, _A, "N", _A, "N", _hdr("akusal", "akusala", "ārammaṇa"), ""),
 (5601, _A, "N", _K, "N", _hdr("akusal", "kusala", "ārammaṇa"), ""),
 (5605, _A, "N", _B, "N", _hdr("akusal", "abyākata", "ārammaṇa"), "the abyākata conditioned: reviewing, insight, rebirth-linking cittas"),
 (5609, _B, "NR", _B, "N", ["Abyākato dhammo abyākatassa dhammassa ārammaṇapaccayena paccayo", "Arahā cakkhuṃ aniccato dukkhato anattato vipassati"], "fruition, nibbāna, the eye … the base, the aggregates → the arahant's cittas"),
 (5613, _B, "NR", _K, "N", ["Abyākato dhammo kusalassa dhammassa ārammaṇapaccayena paccayo", "cakkhuṃ aniccato dukkhato anattato vippassanti"], ""),
 (5617, _B, "NR", _A, "N", ["Abyākato dhammo akusalassa dhammassa ārammaṇapaccayena paccayo", "cakkhuṃ assādeti abhinandati"], ""),
])
C += _heads("adhipati", [
 (5625, _K, "N", _K, "N", _hdr("kusal", "kusala", "adhipati"), ""),
 (5629, _K, "N", _A, "N", _hdr("kusal", "akusala", "adhipati"), ""),
 (5633, _K, "N", _B, "NR", [_hdr("kusal", "abyākata", "adhipati"), "kusalādhipati cittasamuṭṭhānānaṃ rūpānaṃ adhipatipaccayena paccayo"], "reviewing the path (mind); co-nascent predominance → mind-born matter"),
 (5637, _K, "N", f"{_K} · {_B}", "NR", "kusalādhipati sampayuttakānaṃ khandhānaṃ cittasamuṭṭhānānañca rūpānaṃ", ""),
 (5641, _A, "N", _A, "N", _hdr("akusal", "akusala", "adhipati"), ""),
 (5645, _A, "N", _B, "R", [_hdr("akusal", "abyākata", "adhipati"), "akusalādhipati cittasamuṭṭhānānaṃ rūpānaṃ"], "co-nascent predominance → mind-born matter only"),
 (5649, _A, "N", f"{_A} · {_B}", "NR", "akusalādhipati sampayuttakānaṃ khandhānaṃ cittasamuṭṭhānānañca rūpānaṃ", ""),
 (5653, _B, "N", _B, "NR", [_hdr("abyākat", "abyākata", "adhipati"), "Nibbānaṃ phalassa adhipatipaccayena paccayo", "vipākābyākatakiriyābyākatādhipati sampayuttakānaṃ khandhānaṃ"], "fruition, nibbāna; resultant/functional predominance → its aggregates and mind-born matter"),
 (5657, _B, "N", _K, "N", [_hdr("abyākat", "kusala", "adhipati"), "Nibbānaṃ gotrabhussa, vodānassa, maggassa adhipatipaccayena paccayo"], ""),
 (5661, _B, "NR", _A, "N", [_hdr("abyākat", "akusala", "adhipati"), "cakkhuṃ garuṃ katvā assādeti abhinandati"], "the eye … the base, the aggregates, taken as weighty"),
])
for _cond, _base in (("anantara", 5669), ("samanantara", 5701)):
    C += _heads(_cond, [
     (_base, _K, "N", _K, "N", _hdr("kusal", "kusala", _cond), "aggregates; conformity → change-of-lineage → path"),
     (_base + 4, _K, "N", _B, "N", _hdr("kusal", "abyākata", _cond), "wholesome → emergence; path → fruition"),
     (_base + 8, _A, "N", _A, "N", _hdr("akusal", "akusala", _cond), ""),
     (_base + 12, _A, "N", _B, "N", _hdr("akusal", "abyākata", _cond), "unwholesome → emergence"),
     (_base + 16, _B, "N", _B, "N", [_hdr("abyākat", "abyākata", _cond), "vipākābyākatā kiriyābyākatā khandhā"], "resultant and functional AGGREGATES only; life-continuum → adverting"),
     (_base + 20, _B, "N", _K, "N", _hdr("abyākat", "kusala", _cond), "adverting → wholesome aggregates"),
     (_base + 24, _B, "N", _A, "N", _hdr("abyākat", "akusala", _cond), "adverting → unwholesome aggregates"),
    ])
C += _heads("upanissaya", [
 (5845, _K, "N", _K, "N", _hdr("kusal", "kusala", "upanissaya"), ""),
 (5865, _K, "N", _A, "N", _hdr("kusal", "akusala", "upanissaya"), ""),
 (5877, _K, "N", _B, "N", _hdr("kusal", "abyākata", "upanissaya"), "the abyākata conditioned: bodily feeling, fruition, result (`:5881–5889`)"),
 (5893, _A, "N", _A, "N", _hdr("akusal", "akusala", "upanissaya"), ""),
 (5909, _A, "N", _K, "N", _hdr("akusal", "kusala", "upanissaya"), ""),
 (5913, _A, "N", _B, "N", _hdr("akusal", "abyākata", "upanissaya"), "the abyākata conditioned: emergence, bodily feeling, fruition, result"),
 (5937, _B, "NR", _B, "N", "Utu kāyikassa sukhassa, kāyikassa dukkhassa, phalasamāpattiyā upanissayapaccayena paccayo", "abyākata → abyākata (`:5925`): climate, food, lodging and bodily feeling → bodily feeling and fruition"),
 (5957, _B, "NR", _K, "N", "senāsanaṃ upanissāya dānaṃ deti", "abyākata → kusala (`:5945`): fruition, nibbāna, adverting, climate, food, lodging"),
 (5965, _B, "NR", _A, "N", "cakkhuṃ garuṃ katvā assādeti abhinandati", "abyākata → akusala (`:5961`): the eye … the base, the aggregates; climate, food, lodging (`:5977`)"),
])
C += [
 ("vipaka", 6093, "vipākābyākato khandho", "N", "khandhā · cittasamuṭṭhānāni rūpāni", "NR", "co", "detailByOutcome", ["vipākābyākato eko khandho tiṇṇannaṃ khandhānaṃ cittasamuṭṭhānānañca rūpānaṃ vipākapaccayena"], "§428 — consulted BECAUSE the niddesa's placement failed (outcome-selected; vipāka has no open side)"),
 ("arammana", 7889, "paññatti", "P", "(the mind that takes it)", "N", "unstated", "commentary", ["kusalākusalavipākakiriyarūpanibbānapaññattibhedato sattavidhaṃ"], "the Paṭṭhāna-aṭṭhakathā: the object is sevenfold, concepts included"),
]
ORDER = ["hetu", "arammana", "adhipati", "anantara", "samanantara", "sahajata", "annamanna", "nissaya", "upanissaya",
         "purejata", "pacchajata", "asevana", "kamma", "vipaka", "ahara", "indriya", "jhana", "magga", "sampayutta",
         "vippayutta", "atthi", "natthi", "vigata", "avigata"]
# The Saṅgaha's own placement (§16–20, §26), the known answer — used ONLY as the key the readings are checked against.
SANGAHA = {**{c: "namaToNama" for c in ["anantara", "samanantara", "natthi", "vigata", "asevana", "sampayutta"]},
           **{c: "namaToNamarupa" for c in ["hetu", "jhana", "magga", "kamma", "vipaka"]},
           "pacchajata": "namaToRupa", "purejata": "rupaToNama",
           **{c: "allToNama" for c in ["arammana", "upanissaya"]},
           **{c: "namarupaToNamarupa" for c in ["adhipati", "sahajata", "annamanna", "nissaya", "ahara", "indriya",
                                                 "vippayutta", "atthi", "avigata"]}}

# The held-out answer, as text a reading could cite: the Saṅgaha's grouping sections and lines.
GROUPING = re.compile(r"Saṅgaha[^|]*?§\s*(1[5-9]|2[0-6])\b|abh07t\.nrf\.xml:(28[4-9]\d|290[01])")

def answer_free(rows=None):
    """Rubric item 7 carried to capture code: no reading may cite the held-out grouping (the first version did — 'mind, as the
    Saṅgaha (§20)' — and its refuter caught it). Returns the offending rows."""
    return [(c, n) for (c, n, ft, fk, tt, tk, tm, src, probes, note) in (C if rows is None else rows)
            if GROUPING.search(" ".join([ft, tt, note]))]

def verify():
    files = {}
    def line(f, n):
        if f not in files: files[f] = open(os.path.join(CST, f), "rb").read().decode("utf-16").splitlines()
        # the CST carries runs of spaces ("Anantarapaccayoti  –"): collapse whitespace on BOTH sides; the words stay exact
        return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", files[f][n - 1]))
    bad = 0
    for (c, n, *_, src, probes, note) in C:
        text = line(FILES.get(src, "abh03m7.mul.xml"), n)
        for p in probes:
            if re.sub(r"\s+", " ", p) not in text: print(f"✗ {c} :{n} — '{p}' not on the line"); bad += 1
    print(f"verify: {len(C)} clauses, {sum(len(x[8]) for x in C)} probes, {bad} missing"); return bad

def kinds(s): return ", ".join({"N": ".nama", "R": ".rupa", "P": ".pannatti"}[ch] for ch in s if ch in "NRP")
def flag(b): return "true" if b else "false"

def build():
    md = ["# RELATA — what each of the 24 conditions relates (the Paṭṭhāna's definitions, read clause by clause)", "",
          "*GENERATED by `scripts/relata.py` from its clause table — a READING of the Paṭṭhāna's niddesa (`abh03m7.mul.xml:37–265`) and,",
          "by a rule fixed in advance, of its detailed section; every interpretive step marked; romanized canonical terms only.",
          "`--verify` checks each clause's phrases on its cited line.*", "",
          "**Kinds:** N mind (citta and cetasikas; nibbāna counted under mind) · R matter · P a concept · `*` an OPEN side (a",
          "*whatever*-phrase, a relatum not named, or the class term *abyākata*) · `+` takes concepts under the INCLUSIVE reading.",
          "**The rule:** the detailed section (kusala triad) is consulted for every condition with an open side, and there its",
          "enumeration replaces the open side. Result (vipāka) has none; its §428 clause was consulted because it failed.", "",
          "## What the check finds (`Relata.lean`, against the Saṅgaha's grouping — kala/ANSWERS.md)", "",
          "| Layer | Exclusive reading (concepts are not among *all dhammas*) | Inclusive reading (`abh01m.mul.xml:8453`) |",
          "|---|---|---|",
          "| the niddesa's words alone | **19 / 24** — object, proximity, contiguity, decisive support, result fail | **19 / 24** — predominance, proximity, contiguity, decisive support, result fail |",
          "| + the detailed section, by the open-side rule | **22 / 24** — object (no concept), result | **23 / 24** — result |",
          "| + §428 for result (outcome-selected) | **23 / 24** — object | **24 / 24 — the Piṭaka alone** |",
          "| + the commentary on the object (`abh03a.att.xml:7889`) | **24 / 24** | 24 / 24 |", "",
          "⚠️ The first version (`bf3cad6`) claimed 23 of 24 *from the niddesa alone*. Its refuter showed the readings were not",
          "uniform, one leaned on the Saṅgaha's own answer, and the classifier never looked at concepts. The detailed section was",
          "then read for every condition the rule names: its proximity, contiguity and decisive-support clauses name only mental",
          "relata where the niddesa's words are open — a Piṭaka-layer source for what the first version took from the answer.", "",
          "| # | Condition | From | → To | Kinds | Timing | Line | Source | Reading |", "|---|---|---|---|---|---|---|---|---|"]
    for i, (c, n, ft, fk, tt, tk, tm, src, _, note) in enumerate(C, 1):
        f = FILES.get(src, "")
        md.append(f"| {i} | {c} | {ft} | {tt} | {fk}→{tk} | {tm} | `{f}:{n}` | {src} | {note or '—'} |")
    lean = ["/-", "  Relata.lean — GENERATED by scripts/relata.py (capture step 2, increment 2, 2026-10-13; corrected the same day after",
            "  its refuter). What each of the 24 conditions relates, read from the Paṭṭhāna's niddesa clause by clause and, by a rule",
            "  fixed in advance, from its detailed section; the Saṅgaha's six-way grouping as the known answer it is checked against.",
            "  Two readings of 'all dhammas' (with or without designations) are checked side by side.", "-/",
            "namespace FormalAbhidhamma.Relata", "",
            "inductive Condition | " + " | ".join(ORDER), "  deriving DecidableEq, Repr", "",
            "inductive Kind | nama | rupa | pannatti", "  deriving DecidableEq, Repr", "",
            "inductive Timing | co | pre | post | ceased | earlier | done | unstated", "  deriving DecidableEq, Repr", "",
            "inductive Source | niddesa | detail | detailByOutcome | commentary", "  deriving DecidableEq, Repr", "",
            "/-- One clause. `srcOpen`/`dstOpen`: the side is OPEN (a whatever-phrase, an unnamed relatum, the class term abyākata).",
            "    `srcAll`: the side takes designations under the inclusive reading of 'all dhammas'. -/",
            "structure Clause where", "  cond : Condition", "  src : List Kind", "  dst : List Kind", "  srcOpen : Bool",
            "  dstOpen : Bool", "  srcAll : Bool", "  timing : Timing", "  line : Nat", "  source : Source", "",
            "def clauses : List Clause := ["]
    lean.append(",\n".join(f"  ⟨.{c}, [{kinds(fk)}], [{kinds(tk)}], {flag('*' in fk)}, {flag('*' in tk)}, {flag('+' in fk)}, .{tm}, {n}, .{src}⟩"
                           for (c, n, ft, fk, tt, tk, tm, src, _, _) in C))
    lean += ["]", "",
             "/-- The Saṅgaha's six groups (§15–20, §26, `abh07t.nrf.xml:2845–2877`, `:2901`). -/",
             "inductive Group | namaToNama | namaToNamarupa | namaToRupa | rupaToNama | allToNama | namarupaToNamarupa",
             "  deriving DecidableEq, Repr", "",
             "/-- What the clauses from the given sources say a condition relates, the kinds on each side unioned. Where the",
             "    detailed section is among the sources AND has clauses for the condition, its enumeration replaces every open side;",
             "    `incl` adds designations to the `srcAll` sides. -/",
             "def sides (incl : Bool) (srcs : List Source) (c : Condition) : List Kind × List Kind :=",
             "  let detail := srcs.contains .detail && clauses.any (fun x => x.cond == c && x.source == .detail)",
             "  let cs := clauses.filter (fun x => x.cond == c && srcs.contains x.source)",
             "  (cs.flatMap (fun x => if detail && x.srcOpen then [] else x.src ++ (if incl && x.srcAll then [.pannatti] else [])),",
             "   cs.flatMap (fun x => if detail && x.dstOpen then [] else x.dst))", "",
             "/-- The group those sides fall in, CONCEPTS INCLUDED: only 'concepts, mind and matter → mind' admits a concept, and",
             "    it requires one (the first version never read `.pannatti`, so a concept could not change any result). -/",
             "def classify (s : List Kind × List Kind) : Option Group :=",
             "  let fN := s.1.contains .nama; let fR := s.1.contains .rupa; let fP := s.1.contains .pannatti",
             "  let tN := s.2.contains .nama; let tR := s.2.contains .rupa; let tP := s.2.contains .pannatti",
             "  if tP then none",
             "  else if fN && !fR && !fP && tN && !tR then some .namaToNama",
             "  else if fN && !fR && !fP && tN && tR then some .namaToNamarupa",
             "  else if fN && !fR && !fP && !tN && tR then some .namaToRupa",
             "  else if !fN && fR && !fP && tN && !tR then some .rupaToNama",
             "  else if fN && fR && fP && tN && !tR then some .allToNama",
             "  else if fN && fR && !fP && tN && tR then some .namarupaToNamarupa",
             "  else none", "",
             "/-- The Saṅgaha's placement — the KNOWN ANSWER (kala/ANSWERS.md \"Saṅgaha ch. 8 grouping\"). -/",
             "def sangaha : Condition → Group"]
    lean += [f"  | .{c} => .{SANGAHA[c]}" for c in ORDER]
    L = lambda *s: "[" + ", ".join(f".{x}" for x in s) + "]"
    def misses(incl, srcs, expect):
        return f"all.filter (fun c => classify (sides {incl} {srcs} c) != some (sangaha c)) = {expect}"
    N, D, O, K = "[.niddesa]", "[.niddesa, .detail]", "[.niddesa, .detail, .detailByOutcome]", "[.niddesa, .detail, .detailByOutcome, .commentary]"
    lean += ["", "def all : List Condition := [" + ", ".join(f".{c}" for c in ORDER) + "]", "",
             "/-- Every condition has at least one clause in the niddesa. -/",
             "theorem every_condition_defined : all.all (fun c => clauses.any (fun x => x.cond == c && x.source == .niddesa)) = true := by decide", "",
             "/-- THE RULE, as a property: the detailed section is consulted for exactly the conditions whose niddesa has an open side. -/",
             "theorem consulted_where_open :",
             "    all.filter (fun c => clauses.any (fun x => x.cond == c && x.source == .detail)) =",
             "    all.filter (fun c => clauses.any (fun x => x.cond == c && x.source == .niddesa && (x.srcOpen || x.dstOpen))) := by decide", "",
             "/-- The Saṅgaha's counts: 6 · 5 · 1 · 1 · 2 · 9. -/",
             "theorem sangaha_counts : (all.filter (sangaha · == .namaToNama)).length = 6 ∧ (all.filter (sangaha · == .namaToNamarupa)).length = 5 ∧",
             "    (all.filter (sangaha · == .namaToRupa)).length = 1 ∧ (all.filter (sangaha · == .rupaToNama)).length = 1 ∧",
             "    (all.filter (sangaha · == .allToNama)).length = 2 ∧ (all.filter (sangaha · == .namarupaToNamarupa)).length = 9 := by decide", "",
             "/-! ## The EXCLUSIVE reading (designations are not among 'all dhammas') -/", "",
             "/-- The niddesa's words alone: 19 of 24. -/",
             "theorem niddesa_19 : " + misses("false", N, L("arammana", "anantara", "samanantara", "upanissaya", "vipaka")) + " := by decide", "",
             "/-- With the detailed section by the open-side rule: 22 — the object lacks a concept, and result is untouched by the rule. -/",
             "theorem detail_22 : " + misses("false", D, L("arammana", "vipaka")) + " := by decide", "",
             "/-- With §428 for result (outcome-selected): 23 — only the object, which needs a concept. -/",
             "theorem with_result_23 : " + misses("false", O, L("arammana")) + " := by decide", "",
             "/-- With the commentary's concept on the object (`abh03a.att.xml:7889`): all 24. -/",
             "theorem with_the_commentary_24 : " + misses("false", K, "[]") + " := by decide", "",
             "/-! ## The INCLUSIVE reading (the Dhammasaṅgaṇī calls designations dhammas, `abh01m.mul.xml:8453`) -/", "",
             "/-- The niddesa's words alone: 19 of 24 — predominance now fails (its open 'whatever dhamma' takes in a concept). -/",
             "theorem niddesa_19_inclusive : " + misses("true", N, L("adhipati", "anantara", "samanantara", "upanissaya", "vipaka")) + " := by decide", "",
             "/-- With the detailed section by the open-side rule: 23 — only result. -/",
             "theorem detail_23_inclusive : " + misses("true", D, L("vipaka")) + " := by decide", "",
             "/-- With §428 for result: all 24, from the Piṭaka alone. -/",
             "theorem pitaka_24_inclusive : " + misses("true", O, "[]") + " := by decide", "",
             "/-- The niddesa's result is mind → mind; the Saṅgaha places it mind → mind-and-matter. -/",
             "theorem niddesa_vipaka_is_mind_to_mind : classify (sides false [.niddesa] .vipaka) = some .namaToNama := by decide", "",
             "end FormalAbhidhamma.Relata", ""]
    return "\n".join(md) + "\n", "\n".join(lean)

if __name__ == "__main__":
    if "--verify" in sys.argv: sys.exit(1 if verify() else 0)
    md, lean = build()
    leaning = answer_free()
    if leaning: print("LEANS ON THE HELD-OUT ANSWER:", leaning); sys.exit(1)
    if "--check" in sys.argv:
        stale = [p for p, t in ((OUT_MD, md), (OUT_LEAN, lean)) if not os.path.exists(p) or open(p, encoding="utf-8").read() != t]
        if stale: print("STALE:", ", ".join(os.path.relpath(p, REPO) for p in stale)); sys.exit(1)
        print("matika/RELATA is current; no reading cites the held-out grouping"); sys.exit(0)
    open(OUT_MD, "w", encoding="utf-8").write(md); open(OUT_LEAN, "w", encoding="utf-8").write(lean)
    print(f"{len(C)} clauses written")
