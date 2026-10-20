#!/bin/sh
# 2026-10-20 ai-forward-pass-citta-stream: S1 (external kalāpa has no base) must CHECK; each deliberate break must FAIL.
set -u; cd "$(dirname "$0")"; LEAN="${LEAN:-lean}"
command -v "$LEAN" >/dev/null 2>&1 || LEAN="$(cd ../.. && elan which lean 2>/dev/null)"
[ -n "$LEAN" ] || LEAN="$HOME/.elan/bin/lean"
$LEAN Base.lean && echo "PASS  S1: an external kalāpa has no heart-base, organ or life faculty · the pure octad is external, the heart decad is not (model) · S2 (BY CONSTRUCTION) no rūpa is a bhavaṅga" || { echo "FAIL  the build"; exit 1; }
try() { T=$(mktemp -d); cp Base.lean "$T/"; sed -i.orig "$2" "$T/Base.lean"
  if cmp -s "$T/Base.lean" "$T/Base.lean.orig"; then echo "BREAK NOT APPLIED  $1"; exit 1; fi
  if $LEAN "$T/Base.lean" >/dev/null 2>&1; then echo "BLIND  $1 — still checks"; exit 1; else echo "FAILS as required  $1"; fi; rm -rf "$T"; }
try "A66 dropped: an external kalāpa may carry any kind" 's/def A66ext (k : Kalapa) : Prop := (∀ r ∈ k.members, r ∈ pureOctad ++ \[.sadda\]) ∧ k.origin = .utu/def A66ext (k : Kalapa) : Prop := k.origin = .utu/'
try "A66 widened: the heart-base counted among the external kinds" 's/r ∈ pureOctad ++ \[.sadda\]/r ∈ pureOctad ++ [.sadda, .hadaya]/'
echo "all breaks fail as required"
