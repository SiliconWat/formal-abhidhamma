#!/usr/bin/env python3
"""de_packet.py — the adjudication packets of the double encoding (DOUBLE-ENCODING-PREREG-2.md): for each drawn row, OUR definitions (the row's conjunction, with the helpers they use, names replaced by part1..., docstrings and comments stripped) beside the encoder's Answer.lean, X/Y labels randomized, rows shuffled, two packets with different orders.
  de_packet.py <workdir> <seed> ROW...   writes <workdir>/PACKET1.md and PACKET2.md and <workdir>/KEY.json (which side is ours, per packet)"""
import re, random, sys, json, os
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import de_tools as D
work, seed, rows = sys.argv[1], sys.argv[2], sys.argv[3:]
TOP = re.compile(r"(/--|/-!|/-|--|theorem |lemma |example |def |abbrev |structure |inductive |instance |class |end |namespace |section |open |variable |set_option |noncomputable |private |protected |@\[|#)")
blocks = {}
for f in ["Mind","Tax","Proc","Mat","Link","Cond","Clocks","Join","Cosmos","Status","World"]:
    L = open(os.path.join(HERE, f + ".lean"), encoding="utf-8").read().split("\n")
    for i, l in enumerate(L):
        m = re.match(r"(?:private )?def ([A-Za-z0-9_.']+)", l)
        if m:
            a = i
            if a > 0 and L[a-1].rstrip().endswith("-/"):
                while a > 0 and not L[a-1].lstrip().startswith("/--"): a -= 1
                a -= 1
            b = i + 1
            while b < len(L) and L[b].strip() and not TOP.match(L[b]): b += 1
            blocks[m.group(1)] = "\n".join(L[a:b])
vocab_defs = set(re.findall(r"(?:structure|inductive|def|abbrev) ([A-Za-z0-9_.']+)", open(os.path.join(HERE, "Vocab.lean")).read()))
def strip(c):
    c = re.sub(r"/--.*?-/\n?", "", c, flags=re.S); c = re.sub(r"(?m)^\s*--.*\n", "", c); return re.sub(r"(?m)\s+--.*$", "", c)
def closure(names):
    seen, st = [], list(names)
    while st:
        n = st.pop()
        if n in seen or n not in blocks or n in vocab_defs: continue
        seen.append(n)
        for tok in set(re.findall(r"[A-Za-z_][A-Za-z0-9_.']*", blocks[n])):
            if tok in blocks and tok not in seen and tok not in vocab_defs: st.append(tok)
    return seen
hdr = "# Adjudication packet %d\n\nFor each pair there are two definitions, X and Y, both written over the same vocabulary (the types are in `Vocab.lean`: read it first). Each is meant to say what the row says. Do not open anything else on the machine. A definition may be a conjunction of named parts followed by helper definitions. For each pair give ONE verdict: **EQUIVALENT** (true of exactly the same worlds) · **X STRONGER** (X implies Y, not conversely) · **Y STRONGER** · **DIFFERENT** (neither implies the other) · **NOT ENCODABLE**; for any verdict but EQUIVALENT give a concrete counterexample world (which fields, which values) where one holds and the other fails, and say whether either is vacuous or too weak for the row. Judge what the Lean DOES, not what a comment says. Add one line on which of the row's own words each definition leaves out. Return a table: pair | verdict | counterexample | note. Keep it complete for every pair.\n"
rng = random.Random(seed); key = {}
for pk in (1, 2):
    out = [hdr % pk]; order = rows[:]; rng.shuffle(order); key[pk] = {}
    for r in order:
        st, tier, cite = D.rows()[r]; _, names = D.ours(r)
        ans = re.sub(r"(?m)^\s*namespace V\s*$|^\s*end V\s*$", "", open(f"{work}/{r}/Answer.lean").read()).strip()
        cl = closure(names)
        ren = {n: f"part{i+1}" for i, n in enumerate(names)}
        hel = {n: f"helper{j+1}" for j, n in enumerate([c for c in cl if c not in names])}
        allren = {**ren, **hel}
        def sub(t):
            for k in sorted(allren, key=len, reverse=True): t = re.sub(r"(?<![A-Za-z0-9_.'])" + re.escape(k) + r"(?![A-Za-z0-9_'])", allren[k], t)
            return t
        conj = " ∧\n    ".join(f"{ren[n]} {ap}" for _, n, ap in D.W.defs() if n in ren)
        text = sub("def enc {S R : Scale} (w : World S R) : Prop :=\n    " + conj + "".join("\n\n" + strip(blocks[n]) for n in cl))
        parts = [("ours", text), ("theirs", ans)]; rng.shuffle(parts)
        key[pk][r] = "X" if parts[0][0] == "ours" else "Y"
        out.append(f"\n---\n## Pair {r}\n**Row statement.** {st}\n\n**Tier.** {tier}\n")
        for lab, (who, src) in zip("XY", parts): out.append(f"### Definition {lab}\n```lean\n{src}\n```\n")
    open(f"{work}/PACKET{pk}.md", "w", encoding="utf-8").write("\n".join(out)); print(pk, len("\n".join(out)))
json.dump(key, open(f"{work}/KEY.json", "w"))
