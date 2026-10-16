#!/usr/bin/env python3
"""fca.py — the Duquenne–Guigues (canonical) basis of an object × attribute table.

The canonical basis is the provably smallest set of implications between attributes from which every
implication that holds in the table follows (Guigues and Duquenne 1986; Ganter and Wille 1999). Over
a citta × cetasika table it is the minimum number of "if these factors, then those" rules the table
itself contains, which no author chose. Rung 4 compares it with the text's stated rules.

  fca.py basis TABLE      one row per object, a string of 0/1 per attribute; prints the basis size,
                          the number of intents (formal concepts), and the basis itself as JSON
  fca.py control          the instrument on known answers and on a brute-force definition (no real data)

Attribute sets are Python ints used as bitmasks. Standard library only.
"""
import itertools
import json
import random
import sys


def read_table(path):
    rows = [ln.strip() for ln in open(path, encoding="utf-8") if ln.strip()]
    m = len(rows[0])
    if any(len(r) != m or set(r) - {"0", "1"} for r in rows):
        sys.exit(f"{path}: every row must be {m} characters of 0/1")
    return m, [sum(1 << i for i, ch in enumerate(r) if ch == "1") for r in rows]


def closer(m, objs):
    full = (1 << m) - 1

    def close(a):  # a'' : the attributes shared by every object that has all of a
        out = full
        for o in objs:
            if o & a == a:
                out &= o
        return out
    return close


def lclose(b, basis):
    """Close b under the implications found so far, firing P -> Q only for P a PROPER subset of b (L•)."""
    changed = True
    while changed:
        changed = False
        for p, q in basis:
            if p & b == p and p != b and q & ~b:
                b |= q
                changed = True
    return b


def canonical_basis(m, objs):
    """Ganter's algorithm: walk the L•-closed sets in lectic order; each that is not an intent is a
    pseudo-intent P and contributes P -> P''. Returns (basis, number of intents)."""
    close = closer(m, objs)
    full = (1 << m) - 1
    basis, intents, a = [], 0, 0
    while True:
        c = close(a)
        if c != a:
            basis.append((a, c))
        else:
            intents += 1
        if a == full:
            return basis, intents
        a = next_set(a, m, basis)


def next_set(a, m, basis):
    for i in range(m - 1, -1, -1):
        bit = 1 << i
        if a & bit:
            continue
        lower = bit - 1                       # the attributes ordered before i
        b = lclose((a & lower) | bit, basis)
        if (b & ~a) & lower == 0:             # nothing new below i: lectically next
            return b
    raise AssertionError("no next set below the full set")


def brute_basis(m, objs):
    """The DEFINITION, by exhaustion: P is pseudo-closed iff P != P'' and Q'' ⊆ P for every
    pseudo-closed Q ⊊ P. Exponential; for the control only."""
    close = closer(m, objs)
    pseudo = []
    for size in range(m + 1):
        for combo in itertools.combinations(range(m), size):
            p = sum(1 << i for i in combo)
            c = close(p)
            if c != p and all(close(q) & ~p == 0 for q in pseudo if q & p == q and q != p):
                pseudo.append(p)
    return sorted((p, close(p)) for p in pseudo)


def control():
    checks = []
    # 1. A planted closure system: all subsets of {a,b,c,d} closed under a->b and b->c. Its canonical
    #    basis is known by hand: {b}->{b,c} and {a}->{a,b,c} (two implications).
    a, b, c, d = 1, 2, 4, 8
    ok = lambda s: (not s & a or s & b) and (not s & b or s & c)
    objs = [s for s in range(16) if ok(s)]
    basis, _ = canonical_basis(4, objs)
    checks.append(("planted a->b, b->c: basis = {b->bc, a->abc}", sorted(basis) == sorted([(b, b | c), (a, a | b | c)])))
    # 2. A known failure: a table with no implications at all (every subset is an object) has an empty basis.
    basis, intents = canonical_basis(3, list(range(8)))
    checks.append(("power set: empty basis, 8 intents", basis == [] and intents == 8))
    # 3. A universal attribute is implied by the empty set: the basis must say so.
    basis, _ = canonical_basis(2, [0b01, 0b11])
    checks.append(("universal attribute: {} -> {0}", (0, 1) in basis))
    # 4. The algorithm against the definition, on 600 random small tables.
    rng = random.Random(20261015)
    agree = 0
    for _ in range(600):
        m = rng.randint(1, 7)
        objs = [rng.getrandbits(m) for _ in range(rng.randint(1, 9))]
        if sorted(canonical_basis(m, objs)[0]) == brute_basis(m, objs):
            agree += 1
    checks.append((f"Ganter's algorithm = the definition on random tables ({agree}/600)", agree == 600))
    # 5. Planting a counterexample removes an implication: add an object with a but not b.
    basis, _ = canonical_basis(4, objs_with := [s for s in range(16) if ok(s)] + [a])
    checks.append(("a counterexample to a->b removes it", not any(p == a and q & b for p, q in basis)))
    for name, good in checks:
        print(("PASS  " if good else "FAIL  ") + name)
    return 0 if all(g for _, g in checks) else 1


def main():
    if len(sys.argv) >= 2 and sys.argv[1] == "control":
        sys.exit(control())
    if len(sys.argv) == 3 and sys.argv[1] == "basis":
        m, objs = read_table(sys.argv[2])
        basis, intents = canonical_basis(m, objs)
        bits = lambda s: [i for i in range(m) if s >> i & 1]
        print(json.dumps({"objects": len(objs), "attributes": m, "distinct_objects": len(set(objs)),
                          "basis_size": len(basis), "intents": intents,
                          "basis": [[bits(p), bits(q & ~p)] for p, q in basis]}))
        return
    sys.exit(__doc__)


if __name__ == "__main__":
    main()
