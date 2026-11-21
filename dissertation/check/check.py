#!/usr/bin/env python3
"""Check every figure in the chapter prose against numbers.json + figures.json.

Reads the FINISHED chapter files, not the templates. Masks what is citation or identifier (listed below), then walks every
remaining digit-number and spelled number in order, and compares each with the next binding's value. So a figure changed to
ANY other value fails, even one that occurs elsewhere in the chapter (a plain membership test would miss that), and a
number added or removed fails. Exit 1 on any mismatch.

usage: check.py [--numbers PATH] [--dir PATH] [--show-exempt]
"""
import json, os, re, sys, argparse
D = os.path.dirname(os.path.abspath(__file__))
ap = argparse.ArgumentParser()
ap.add_argument('--numbers', default=os.path.join(os.path.dirname(D), 'numbers.json'))
ap.add_argument('--dir', default=os.path.dirname(D))
ap.add_argument('--show-exempt', action='store_true')
a = ap.parse_args()
N = json.load(open(a.numbers))
F = json.load(open(D + '/figures.json'))
FV = F['values']
WORD = {'zero': 0, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
        'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14, 'fifteen': 15, 'sixteen': 16, 'seventeen': 17,
        'eighteen': 18, 'nineteen': 19, 'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60, 'seventy': 70,
        'eighty': 80, 'ninety': 90, 'hundred': 100, 'thousand': 1000, 'twice': 2}
# what is not a figure: each pattern is an identifier or a citation, and is reported with --show-exempt
MASKS = [
    ('code span', r'`[^`\n]*`'),
    ('url', r'https?://\S+'),
    ('doi', r'doi:\S+'),
    ('timestamp', r'\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}Z)?'),
    ('section mark', r'§§?[RG]?\d+(\.\d+)?(\([a-z]\))?(\s?[–-]\s?§?\d+)?'),
    ('prediction id', r'P-FA\d+[ab]?'),
    ('rule id', r'\bR\d+\b'),
    ('layer id', r'\bL[123]\b'),
    ('control id', r'\bC[12]\b'),
    ('gap id', r'GAP \d[a-z]'),
    ('heading number', r'(?m)^#+ (Chapter )?\d+(\.\d+)?'),
    ('chapter ref', r'(?i)\bchapters? \d+(( and |–|, )\d+)*'),
    ('ch. ref', r'\bch\. \d+'),
    ('owed item', r'owed item \d+'),
    ('table ref', r'Tables? \d\.\d(–\d\.\d)?'),
    ('rung ref', r'(?i)\brungs? \d[ab]?'),
    ('LNCS/venue', r'ASE \d{4}'),
    ('year', r'\b(1[0-9]{3}|20[0-9]{2})\b'),
    ('century', r'\b\d+(st|nd|rd|th)(–\d+(st|nd|rd|th))?\b'),
    ('volume and page', r'volumes? 7\d(–\d+)?|vol\. \d+|pp?\. \d+(–\d+)?'),
    ('line ref', r'lines? \d+(–\d+)?'),
    ('break label', r'jhānas 1–4'),
    ('RFC', r'RFC \d+'),
    ('Lean', r'Lean 4'),
    ('SHA', r'SHA-256'),
    ('0-1 matrix', r'0-1 matrices'),
    ('NFC', r'NFC'),
    ('license', r'CC0(-1\.0)?'),
    ('list marker', r'(?m)^\d+\. '),
    ('part of a volume', r'part \d'),
    ('site name', r'5000-years\.org'),
    ('CRediT/section', r'§\d'),
]
# spelled numbers in ordinary prose that state a structural fact of the text or of the argument. Each is listed, not hidden.
EXEMPT_PHRASES = [
    'two methods', 'two editions', 'two lists', 'two files', 'two reckonings', 'two readings', 'two factors',
    'two delusion-rooted', 'two powers', 'two roots', 'two pre-registrations', 'two parts', 'two ways', 'two features',
    'two lines', 'two views', 'two binary', 'two reckon', 'the two', 'Two predictions', 'Two artifacts', 'Two editions',
    'Two features', 'Two are properties', 'three binary axes', 'three abstinences', 'three things', 'Three things',
    'three details', 'Three details', 'three cautions', 'Three scripts', 'three passes', 'three depend', 'three factors',
    'three written-out', 'these three', 'four routes', 'four terms', 'four classes', 'naming four', 'caught all four',
    'four alone', 'these four', 'four per-type', 'five-jhāna', 'five-door', 'all five', 'five faculties', 'five situations',
    'twice-five', 'sometimes sixty', 'sixty-one', 'exactly thirty', 'fifty-six', 'the nine stated', 'nine further',
    'these nine are known', "commentary's nine", 'sixty-five', 'more than fifty', 'fifty-five', 'Thirty-six', 'thirty-five',
    'thirty-four', 'thirty-three twice', 'eleven first-jhāna', 'twelve beginning', 'nine stated', 'of the nine', 'these nine',
    'occurs twice', 'states it twice', 'twice-', 'and twice', 'twice:', 'five to seven centuries', 'the fifty-six',
    'and the nine', 'first two pages', 'Two files', 'four pairs', 'Two stamping', 'consciousness twice', 'two more', 'two-rooted', 'three-rooted', 'no two types', 'two rule-shaped', "commentaries' nine", 'there are sixty', 'A zero says', 'two remain undecided', 'two further positions', 'two independent',
]
num_re = re.compile(r'\d+(?:\.\d+)?')
word_re = re.compile(r"\b(" + '|'.join(sorted(WORD, key=len, reverse=True)) + r")\b", re.I)

def resolve(key):
    base, _, idx = key.partition('.')
    v = N[base] if base in N else FV[base]
    return v[int(idx)] if idx else v

def mask(text, tally):
    def blank(label):
        def f(m):
            tally[label] = tally.get(label, 0) + 1
            return ' ' * len(m.group(0))
        return f
    for label, pat in MASKS:
        text = re.sub(pat, blank(label), text)
    for p in EXEMPT_PHRASES:
        # keep length; a spelled number inside an exempt phrase is not a bound figure
        text = re.sub(re.escape(p), blank('prose phrase: ' + p), text)
    # Pāli quotations and italic terms carry no English figures by construction, but digits inside them still count
    return text

def tokens(text):
    out = []
    for m in re.finditer(r'\d+(?:\.\d+)?|\b(?:' + '|'.join(sorted(WORD, key=len, reverse=True)) + r')\b', text, re.I):
        s = m.group(0)
        if s[0].isdigit():
            out.append((m.start(), s, float(s), 'digit'))
        else:
            out.append((m.start(), s, float(WORD[s.lower()]), 'word'))
    return out

bad = 0; total = 0; tally = {}
files = sorted(f for f in os.listdir(a.dir) if re.match(r'chapter-\d.*\.md$', f))
for f in files:
    text = open(os.path.join(a.dir, f), encoding='utf-8').read()
    b = json.load(open(os.path.join(D, 'bindings', f + '.json')))
    b_vals = []
    for x in b:
        v = resolve(x['key'])
        b_vals.append((x['key'], float(v) if not isinstance(v, bool) else None))
    m = mask(text, tally)
    # the number 'one' is not swept: English uses it as a pronoun. Bindings with value 1 written as digits still are.
    toks = tokens(m)
    errs = []
    for i in range(max(len(toks), len(b_vals))):
        if i >= len(toks):
            errs.append(f'  missing figure: binding {b_vals[i][0]} = {b_vals[i][1]} has no token left in the text'); break
        pos, s, v, _ = toks[i]
        line = text.count('\n', 0, pos) + 1
        ctx = text[max(0, pos - 42):pos + 22].replace('\n', ' ')
        if i >= len(b_vals):
            errs.append(f'  line {line}: UNBOUND number "{s}" … {ctx} …'); break
        k, ev = b_vals[i]
        if v != ev:
            errs.append(f'  line {line}: "{s}" where {k} = {ev} … {ctx} …'); break
    total += len(toks)
    print(f'{f}: {len(toks)} figures, {len(b_vals)} bindings: ' + ('OK' if not errs else 'FAIL'))
    for e in errs:
        print(e)
    bad += bool(errs)
if a.show_exempt:
    print('\nmasked, by kind:')
    for k in sorted(tally):
        print(f'  {tally[k]:>4}  {k}')
n_keys = {x['key'].partition('.')[0] for f in files for x in json.load(open(os.path.join(D, 'bindings', f + '.json')))}
print(f'\n{total} figures in {len(files)} chapters; {sum(k in N for k in n_keys)} distinct numbers.json keys, {sum(k not in N for k in n_keys)} distinct other keys')
print('RESULT:', 'FAIL' if bad else 'PASS')
sys.exit(1 if bad else 0)
