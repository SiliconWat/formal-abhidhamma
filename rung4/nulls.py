#!/usr/bin/env python3
"""nulls.py — is the text's table special, or would any table like it look the same?

Two null models for the citta × cetasika table the rules generate (rung4/Table.lean):

  N1  MARGIN-PRESERVING SHUFFLES. Random tables with the same row totals and column totals (curveball
      algorithm, Strona et al. 2014). Asks: is there structure beyond the margins? Expected yes; it is
      the floor, not the finding. Statistics: GF(2) rank, distinct columns, LZMA size (a compression
      proxy for description length). The canonical basis is NOT computed for shuffles: on unstructured
      tables of this size its enumeration does not finish (measured 2026-10-15, synthetic data).
  N2  AXIS-BUILT RANDOM RULES. Rule systems of the SAME SHAPE as the text's (the same column groups, the
      same number of conditions per rule) drawn at random over the SAME citta axes (rung4/Axes.lean).
      Asks the examiner's question: does any rule system on these axes compress this well? Statistics:
      canonical basis size and intents (fca.py), plus the three above.

  nulls.py run --table T121.txt --axes AXES.txt [--n1 1000] [--n2 1000] [--seed 20261015] [--out F.json]
  nulls.py control       the instruments on known answers (no real data)
"""
import argparse
import json
import lzma
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fca          # noqa: E402
import mutants      # noqa: E402

# The text's column groups, in `all` order (control/Cetasika.lean), one per clause of sangaha/Rules.lean.
GROUPS = {"§R1": range(0, 7), "§R2": [7], "§R3": [8], "§R4": [9], "§R5": [10], "§R6": [11], "§R7": [12],
          "§R8": [13, 14, 15, 16], "§R9": [17], "§R10": [18], "§R11": [19], "§R12": [20, 21, 22, 23],
          "§R13": [24, 25], "§R14": [26], "§R15": range(27, 46), "§R16": [46, 47, 48], "§R17": [49, 50],
          "§R18": [51]}


# ── statistics ───────────────────────────────────────────────────────────────────────────────────────
def gf2_rank(rows):
    rank, rows = 0, [r for r in rows if r]
    while rows:
        pivot = rows.pop()
        if not pivot:
            continue
        rank += 1
        low = pivot & -pivot
        rows = [r ^ pivot if r & low else r for r in rows]
        rows = [r for r in rows if r]
    return rank


def columns(rows, m):
    return [sum(1 << i for i, r in enumerate(rows) if r >> j & 1) for j in range(m)]


def lzma_size(rows, m):
    nbytes = (m + 7) // 8
    data = b"".join(r.to_bytes(nbytes, "little") for r in rows)
    return len(lzma.compress(data, preset=9 | lzma.PRESET_EXTREME))


def cheap_stats(rows, m):
    return {"gf2_rank": gf2_rank(list(rows)), "distinct_columns": len(set(columns(rows, m))),
            "lzma_bytes": lzma_size(rows, m)}


def full_stats(rows, m):
    basis, intents = fca.canonical_basis(m, rows)
    return {**cheap_stats(rows, m), "basis_size": len(basis), "intents": intents}


# ── N1: curveball ────────────────────────────────────────────────────────────────────────────────────
def curveball(rows, m, trades, rng):
    sets = [{j for j in range(m) if r >> j & 1} for r in rows]
    n = len(sets)
    for _ in range(trades):
        a, b = rng.sample(range(n), 2)
        only_a, only_b = list(sets[a] - sets[b]), list(sets[b] - sets[a])
        if not only_a or not only_b:
            continue
        pool = only_a + only_b
        rng.shuffle(pool)
        keep = sets[a] & sets[b]
        sets[a] = keep | set(pool[:len(only_a)])
        sets[b] = keep | set(pool[len(only_a):])
    return [sum(1 << j for j in s) for s in sets]


def margins(rows, m):
    return [bin(r).count("1") for r in rows], [sum(r >> j & 1 for r in rows) for j in range(m)]


# ── N2: random rules of the text's shape over the real axes ──────────────────────────────────────────
def read_axes(path):
    out = []
    for ln in open(path, encoding="utf-8"):
        if ln.strip():
            out.append(dict(kv.split("=", 1) for kv in ln.split()))
    return out


def shapes():
    """(clause tag, number of atomic conditions) for each clause of the text's rules."""
    src = open(os.path.join(mutants.REPO, "sangaha", "Rules.lean"), encoding="utf-8").read()
    return [(cl["clause"], len(mutants.atoms(cl["expr"]))) for cl in mutants.clauses(src, "arises")]


def random_atom(axes, rng):
    key = rng.choice(["jati", "bhumi", "vedana", "root", "dhatu", "ofKusala", "knowing", "view", "prompted", "jhana", "sense"])
    if key == "jhana":
        k = rng.randint(0, 5)
        return lambda c: int(c["jhana"]) <= k
    if key == "sense":
        neg = rng.random() < 0.5
        return lambda c: c["dhatu"].startswith("sense") != neg
    values = sorted({c[key] for c in axes})
    v, eq = rng.choice(values), rng.random() < 0.5
    return (lambda c: c[key] == v) if eq else (lambda c: c[key] != v)


def random_condition(n_atoms, axes, rng):
    if n_atoms == 0:
        return lambda c: True
    atoms_ = [random_atom(axes, rng) for _ in range(n_atoms)]
    ops = [rng.choice(["and", "or"]) for _ in range(n_atoms - 1)]
    def f(c):
        val = atoms_[0](c)
        for op, at in zip(ops, atoms_[1:]):
            val = (val and at(c)) if op == "and" else (val or at(c))
        return val
    return f


def axis_built_table(axes, shape, rng):
    """One random rule system of the text's shape. A clause is redrawn while its column would be empty or
    universal (the text has neither, except the universals' own clause)."""
    rows = [0] * len(axes)
    for tag, n_atoms in shape:
        for _ in range(1000):
            f = random_condition(n_atoms, axes, rng)
            col = [f(c) for c in axes]
            if tag == "§R1" or 0 < sum(col) < len(axes):
                break
        for i, present in enumerate(col):
            if present:
                for j in GROUPS[tag]:
                    rows[i] |= 1 << j
    return rows


def percentile(value, sample):
    below = sum(x < value for x in sample)
    ties = sum(x == value for x in sample)
    return round(100 * (below + 0.5 * ties) / len(sample), 2)


def run(table_path, axes_path, n1, n2, seed, out=None):
    m, rows = fca.read_table(table_path)
    axes = read_axes(axes_path)
    if len(axes) != len(rows):
        sys.exit("table and axes disagree on the number of citta-types")
    rng = random.Random(seed)
    real = full_stats(rows, m)
    n1_stats = []
    for _ in range(n1):
        shuffled = curveball(rows, m, 20 * len(rows), rng)
        n1_stats.append(cheap_stats(shuffled, m))
    shape = shapes()
    n2_stats = [full_stats(axis_built_table(axes, shape, rng), m) for _ in range(n2)]
    report = {"real": real, "seed": seed, "n1": n1, "n2": n2,
              "n1_percentile": {k: percentile(real[k], [s[k] for s in n1_stats]) for k in n1_stats[0]},
              "n2_percentile": {k: percentile(real[k], [s[k] for s in n2_stats]) for k in n2_stats[0]},
              "n2_basis_size": sorted(s["basis_size"] for s in n2_stats)}
    if out:
        json.dump({"report": report, "n1": n1_stats, "n2": n2_stats}, open(out, "w"), indent=1)
    return report


def control():
    rng = random.Random(1)
    checks = []
    rows = [rng.getrandbits(12) for _ in range(15)]
    shuffled = curveball(rows, 12, 300, rng)
    checks.append(("curveball keeps every row and column total", margins(rows, 12) == margins(shuffled, 12)))
    checks.append(("curveball actually moves cells", shuffled != rows))
    stair = [(1 << (6 - i)) - 1 for i in range(6)]          # row totals 6,5,…,1 nested: one realization only
    checks.append(("a uniquely realizable table never changes", curveball(stair, 6, 500, rng) == stair))
    seen = {tuple(curveball([0b01, 0b10], 2, 1, random.Random(s))) for s in range(40)}
    checks.append(("the 2×2 identity reaches its anti-identity", (0b10, 0b01) in seen))
    checks.append(("GF(2) rank: identity 8 = 8, all-ones = 1", gf2_rank([1 << i for i in range(8)]) == 8 and gf2_rank([255] * 8) == 1))
    checks.append(("GF(2) rank: 1⊕2 = 3 is dependent", gf2_rank([1, 2, 3]) == 2))
    checks.append(("LZMA: an empty table compresses below a random one",
                   lzma_size([0] * 121, 52) < lzma_size([rng.getrandbits(52) for _ in range(121)], 52)))
    toy_axes = [{"jati": j, "bhumi": "kama", "vedana": "upekkha", "root": "none", "dhatu": "manovinnana",
                 "ofKusala": "true", "knowing": "false", "view": "false", "prompted": "false", "jhana": "0"}
                for j in ("kusala", "akusala", "vipaka", "kiriya") * 3]
    t = axis_built_table(toy_axes, shapes(), random.Random(3))
    univ = all((r & 0x7F) == 0x7F for r in t)
    grouped = all(len({(r >> j) & 1 for j in GROUPS["§R15"]}) == 1 for r in t)
    checks.append(("N2 keeps the text's groups (universals in every row; the 19 move together)", univ and grouped))
    checks.append(("N2 is reproducible from its seed", axis_built_table(toy_axes, shapes(), random.Random(3)) == t))
    checks.append(("shape read from the rules: 18 clauses, §R1 unconditioned", len(shapes()) == 18 and shapes()[0] == ("§R1", 0)))
    for name, good in checks:
        print(("PASS  " if good else "FAIL  ") + name)
    return 0 if all(g for _, g in checks) else 1


def main():
    p = argparse.ArgumentParser()
    p.add_argument("mode", choices=["run", "control"])
    p.add_argument("--table"); p.add_argument("--axes"); p.add_argument("--out")
    p.add_argument("--n1", type=int, default=1000); p.add_argument("--n2", type=int, default=1000)
    p.add_argument("--seed", type=int, default=20261015)
    a = p.parse_args()
    if a.mode == "control":
        sys.exit(control())
    print(json.dumps(run(a.table, a.axes, a.n1, a.n2, a.seed, a.out), indent=1))


if __name__ == "__main__":
    main()
