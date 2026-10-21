#!/usr/bin/env python3
"""double-encoding.py — the draw of DOUBLE-ENCODING-PREREG.md: sort the pool by SHA-256(H + ":" + row_id), take the first 25. H = the hash of the Bitcoin block at the registered height (read from two explorers; refuses if they disagree).
  double-encoding.py --height 972410 [--hash H]"""
import hashlib, re, sys, urllib.request, os
HERE = os.path.dirname(os.path.abspath(__file__))
def get(url): return urllib.request.urlopen(url, timeout=20).read().decode().strip()
def block_hash(h):
    a = get(f"https://mempool.space/api/block-height/{h}"); b = get(f"https://blockstream.info/api/block-height/{h}")
    if a != b: sys.exit(f"the explorers disagree at {h}: {a} vs {b}")
    return a
pool = re.search(r"`(A1 [^`]*)`", open(os.path.join(HERE, "DOUBLE-ENCODING-PREREG.md"), encoding="utf-8").read()).group(1).split()
args = sys.argv[1:]
H = args[args.index("--hash") + 1] if "--hash" in args else block_hash(int(args[args.index("--height") + 1]))
ranked = sorted(pool, key=lambda r: hashlib.sha256(f"{H}:{r}".encode()).hexdigest())
print("H =", H); print("sample (25):", " ".join(ranked[:25])); print("not drawn:", " ".join(ranked[25:]))
