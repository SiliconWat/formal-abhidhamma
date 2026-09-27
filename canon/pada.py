#!/usr/bin/env python3
"""Rung 3 — map the Dhammasaṅgaṇī's list for the first wholesome sense-sphere citta onto the 52.

The MAP below is copied verbatim from PREREGISTRATION-2026-09-27b.md §3 (commit f4a26e5) and is not
edited after the text was read. A term outside it is reported UNMAPPED, never mapped after the fact.
Usage: pada.py <file containing the list, romanized>   (prints JSON: terms, mapped, unmapped, distinct)
"""
import json, re, sys, unicodedata

PAIRS = ["passaddhi", "lahutā", "mudutā", "kammaññatā", "pāguññatā", "ujukatā"]
MAP = {
    "phasso": "phassa",
    "vedanā": "vedanā", "sukhaṃ": "vedanā", "somanassaṃ": "vedanā", "somanassindriyaṃ": "vedanā",
    "saññā": "saññā", "cetanā": "cetanā",
    **{t: "CITTA" for t in ["cittaṃ", "viññāṇaṃ", "mano", "mānasaṃ", "hadayaṃ", "paṇḍaraṃ", "manāyatanaṃ",
                            "manindriyaṃ", "viññāṇakkhandho", "tajjāmanoviññāṇadhātu"]},
    "vitakko": "vitakka", "sammāsaṅkappo": "vitakka",
    "vicāro": "vicāra", "pīti": "pīti",
    **{t: "ekaggatā" for t in ["cittassekaggatā", "samādhindriyaṃ", "samādhibalaṃ", "sammāsamādhi", "samatho", "avikkhepo"]},
    **{t: "saddhā" for t in ["saddhā", "saddhindriyaṃ", "saddhābalaṃ"]},
    **{t: "vīriya" for t in ["vīriyaṃ", "vīriyindriyaṃ", "vīriyabalaṃ", "sammāvāyāmo", "paggāho"]},
    **{t: "sati" for t in ["sati", "satindriyaṃ", "satibalaṃ", "sammāsati"]},
    **{t: "paññā" for t in ["paññā", "paññindriyaṃ", "paññābalaṃ", "amoho", "sammādiṭṭhi", "sampajaññaṃ", "vipassanā"]},
    "jīvitindriyaṃ": "jīvitindriya",
    "hirī": "hiri", "hiribalaṃ": "hiri",
    "ottappaṃ": "ottappa", "ottappabalaṃ": "ottappa",
    "alobho": "alobha", "anabhijjhā": "alobha",
    "adoso": "adosa", "abyāpādo": "adosa",
    **{f"{p}{x}": f"{p}{x}" for p in ["kāya", "citta"] for x in PAIRS},
}
# Matched on STEMS, so an inflected form (chando, adhimokkho, karuṇā, muditā …) is caught.
NINE = {"chanda": "chand", "adhimokkha": "adhimokkh", "manasikāra": "manasikār",
        "tatramajjhattatā": "tatramajjhatt", "karuṇā": "karuṇ", "muditā": "mudit",
        "sammāvācā": "sammāvāc", "sammākammanta": "sammākammant", "sammāājīva": "sammāājīv"}

def norm(s: str) -> str:
    s = unicodedata.normalize("NFC", s.strip().lower())
    s = s.replace("ṅ", "ṃ") if s.endswith("ṅ") else s
    # SANDHI (pre-registered, §3: "sandhi … normalized before mapping"): vowel elision a + u → u,
    # so kāya + ujukatā is written kāyujukatā and citta + ujukatā cittujukatā. Added after the FIRST run
    # reported these two as UNMAPPED — both runs are recorded in RESULTS.md.
    for p in ("kāy", "citt"):
        if s.startswith(p + "uj"):
            s = p + "a" + s[len(p):]
    return s

def analyse(text: str) -> dict:
    head, _, tail = text.partition("tasmiṃ samaye")
    body, sep, rest = tail.partition("ye vā pana")
    terms = [norm(m) for m in re.findall(r"([^\s,;–-]+)\s+hoti", body)]
    mapped = [(t, MAP.get(t)) for t in terms]
    distinct = sorted({m for _, m in mapped if m and m != "CITTA"})
    return {
        "terms": terms, "n_terms": len(terms),
        "unmapped": [t for t, m in mapped if m is None],
        "distinct_cetasikas": distinct, "n_distinct": len(distinct),
        "nine_named": [n for n, stem in NINE.items() if any(t.startswith(stem) for t in terms)],
        "open_clause": bool(sep) and "aññepi atthi" in rest[:120],
    }

if __name__ == "__main__":
    print(json.dumps(analyse(open(sys.argv[1], encoding="utf-8").read()), ensure_ascii=False, indent=1))
