#!/usr/bin/env python3
"""Transliterate Pāli written in Khmer script into romanized Pāli (the CST's convention).

Code only: no Khmer-edition text is committed to this repository (PREREGISTRATION-2026-09-27b.md §5).
Rules: a consonant carries an inherent `a` unless followed by a vowel sign, a coeng (្, subscript
conjunct) or a bantoc (់); ំ is niggahita (ṃ); ឹ is Khmer Pāli's iṃ; ។ ends a sentence.
"""
import sys

CONS = dict(zip("កខគឃងចឆជឈញដឋឌឍណតថទធនបផពភមយរលវសហឡ",
                ["k","kh","g","gh","ṅ","c","ch","j","jh","ñ","ṭ","ṭh","ḍ","ḍh","ṇ","t","th","d","dh","n",
                 "p","ph","b","bh","m","y","r","l","v","s","h","ḷ"]))
INDEP = {"អ": "a", "ឥ": "i", "ឦ": "ī", "ឧ": "u", "ឩ": "ū", "ឯ": "e", "ឱ": "o", "ឲ": "o"}
VSIGN = {"ា": "ā", "ិ": "i", "ី": "ī", "ុ": "u", "ូ": "ū", "េ": "e", "ោ": "o", "ឹ": "iṃ", "ឺ": "ī"}
COENG, NIGG, BANTOC = "្", "ំ", "់"
DIGITS = str.maketrans("០១២៣៤៥៦៧៨៩", "0123456789")

def reorder_coeng_ro(s: str) -> str:
    """Encoding normalization: some typists enter the subscript RO (្រ) BEFORE another subscript
    (ន្រ្ទ for ន្ទ្រ). Pronunciation and spelling put it last; move it last. Not a textual change."""
    import re
    return re.sub(r"(្រ)(្[ក-ឡ])", r"\2\1", s)

def translit(s: str) -> str:
    s = reorder_coeng_ro(s)
    out, i, n = [], 0, len(s)
    while i < n:
        ch = s[i]
        if ch in CONS or ch == "អ":
            base = CONS.get(ch, "")
            nxt = s[i + 1] if i + 1 < n else ""
            if ch == "អ" and nxt in VSIGN:                      # អ + vowel sign = independent vowel
                out.append(VSIGN[nxt]); i += 2; continue
            if nxt == COENG:                                     # conjunct: no inherent vowel
                out.append(base); i += 2; continue
            if nxt in VSIGN:
                out.append(base + VSIGN[nxt]); i += 2
                if i < n and s[i] == NIGG: out.append("ṃ"); i += 1
                continue
            if nxt == BANTOC:
                out.append(base); i += 2; continue
            out.append(base + "a"); i += 1
            if i < n and s[i] == NIGG: out.append("ṃ"); i += 1
            continue
        if ch in INDEP: out.append(INDEP[ch]); i += 1; continue
        if ch in VSIGN: out.append(VSIGN[ch]); i += 1; continue
        if ch == NIGG: out.append("ṃ"); i += 1; continue
        if ch == "។": out.append("."); i += 1; continue
        if ch in "៍៎៏័៌៑ៈ​": i += 1; continue
        out.append(ch.translate(DIGITS)); i += 1
    return "".join(out)

if __name__ == "__main__":
    print(translit(open(sys.argv[1], encoding="utf-8").read()))
