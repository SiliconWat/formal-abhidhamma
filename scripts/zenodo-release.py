#!/usr/bin/env python3
"""zenodo-release.py — deposit a tagged release of this repository on Zenodo as SOFTWARE (a citable DOI).

  scripts/zenodo-release.py <tag> [--dry-run]

First release: creates the record (concept DOI + version DOI). Later releases: a NEW VERSION of the same
concept, read from ZENODO.json. ⚠️ A published Zenodo record cannot be deleted — run --dry-run first.
Token: macOS Keychain `zenodo-token` (the corpus's; never in this repo). Creators follow the corpus's
convention (TH/publications/scripts/zenodo-deposit.py): Thon Ly with ORCID; Miss Aquarius as the disclosed
AI co-author, with no ORCID (it identifies human researchers).
"""
import json, os, subprocess, sys, urllib.request, urllib.parse

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATE = os.path.join(REPO, "ZENODO.json")
API = "https://zenodo.org/api"
PAPERS = {  # concept DOIs of the corpus papers this code supplements
    "10.5281/zenodo.23020670": "The Counts Check",
    "10.5281/zenodo.23020020": "Abhidhamma and Discrete Quantum Gravity",
    "10.5281/zenodo.23020015": "The Vibhajjavādin View of Time",
}

def meta(tag):
    return {
        "upload_type": "software",
        "title": "Formal Abhidhamma: the Theravāda Abhidhamma in Lean 4",
        "version": tag.lstrip("v"),
        "creators": [
            {"name": "Ly, Thon", "orcid": "0009-0009-4503-8575",
             "affiliation": "Independent Researcher - Founder, HeartBank(R) - Kampot, Cambodia"},
            {"name": "Miss Aquarius", "affiliation": "HeartBank(R) - AI co-author (disclosed)"},
        ],
        "description": (
            "<p>A research program expressing the Theravāda Abhidhamma in the language of mathematics, "
            "machine-checked in Lean 4, pre-registered and open (CC0).</p>"
            "<ul>"
            "<li><b>The counts check</b> (<code>sangaha/</code>, <code>canon/</code>, <code>control/</code>): whether "
            "general cetasika combination rules, never a per-citta table, generate the traditional 89/121 citta "
            "types, per edition (Khmer, Chaṭṭha Saṅgāyana) and per textual layer.</li>"
            "<li><b>Kāla</b> (<code>kala/</code>): time as a designation on one mental stream's order; "
            "the asymmetry that matter has a 'between' (delimiting space) and mind has none; the end of a "
            "stream at parinibbāna; beginninglessness derived from conditionality. With a satisfying model "
            "and deliberate breaks that must fail.</li>"
            "<li><b>Abhidhamma-mode runs</b> (<code>runs/</code>): questions answered by presuming the texts "
            "correct and deriving what physics would have to be. Each run is pre-registered (question, "
            "window, axioms verbatim, predictions) before the derivation, OpenTimestamps-stamped, derived "
            "blind, attacked by a separate refuter, Lean-checked, and scored. The ledger includes "
            "known-failure CONTROLS and reports their verdicts as scored, failures included.</li>"
            "</ul>"
            "<p>A proof assistant verifies that conclusions follow from the stated definitions; it does not "
            "show that the definitions are faithful to the texts, or that nature agrees. Every axiom is "
            "tier-labelled (Piṭaka · commentarial · sub-commentarial · manual · ours) with its citation in "
            "<code>kala/AXIOMS.md</code>.</p>"
            f"<p>Source: https://github.com/SiliconWat/formal-abhidhamma (tag {tag}).</p>"),
        "access_right": "open",
        "license": "cc-zero",
        "keywords": ["Abhidhamma", "Theravāda", "Lean 4", "formal verification", "Buddhist philosophy of time",
                     "causal set theory", "pre-registration", "Tipiṭaka", "Paṭṭhāna", "Abhidhammattha-saṅgaha"],
        "related_identifiers": (
            [{"identifier": f"https://github.com/SiliconWat/formal-abhidhamma/tree/{tag}",
              "relation": "isSupplementTo", "resource_type": "software"}] +
            [{"identifier": d, "relation": "isSupplementTo", "resource_type": "publication-other"} for d in PAPERS]),
        "language": "eng",
    }

def token():
    return subprocess.run(["security", "find-generic-password", "-s", "zenodo-token", "-w"],
                          check=True, capture_output=True, text=True).stdout.strip()

def req(method, url, tok, data=None, raw=None, ctype="application/json"):
    url = url if url.startswith("http") else API + url
    body = raw if raw is not None else (json.dumps(data).encode() if data is not None else None)
    r = urllib.request.Request(url, data=body, method=method)
    r.add_header("Authorization", f"Bearer {tok}")
    if body is not None: r.add_header("Content-Type", ctype)
    try:
        with urllib.request.urlopen(r, timeout=180) as resp:
            p = resp.read(); return json.loads(p) if p else {}
    except urllib.error.HTTPError as e:
        sys.exit(f"Zenodo {method} {url} -> HTTP {e.code}\n{e.read().decode(errors='replace')[:800]}")

def main():
    if len(sys.argv) < 2: sys.exit(__doc__)
    tag, dry = sys.argv[1], "--dry-run" in sys.argv
    subprocess.run(["git", "-C", REPO, "rev-parse", tag], check=True, capture_output=True)   # the tag must exist
    zipf = os.path.join("/tmp", f"formal-abhidhamma-{tag}.zip")
    subprocess.run(["git", "-C", REPO, "archive", "--format=zip", f"--prefix=formal-abhidhamma-{tag}/",
                    "-o", zipf, tag], check=True)
    m = meta(tag)
    print(json.dumps(m, ensure_ascii=False, indent=1)[:2500]); print(f"archive: {zipf} ({os.path.getsize(zipf)} bytes)")
    if dry: print("DRY RUN — nothing sent."); return
    tok = token()
    state = json.load(open(STATE)) if os.path.exists(STATE) else {}
    if state.get("latest_id"):
        r = req("POST", f"/deposit/depositions/{state['latest_id']}/actions/newversion", tok)
        dep = req("GET", r["links"]["latest_draft"], tok)
        for f in dep.get("files", []): req("DELETE", f["links"]["self"], tok)
    else:
        dep = req("POST", "/deposit/depositions", tok, data={})
    req("PUT", f"/deposit/depositions/{dep['id']}", tok, data={"metadata": m})
    with open(zipf, "rb") as fh:
        req("PUT", f"{dep['links']['bucket']}/{urllib.parse.quote(os.path.basename(zipf))}", tok,
            raw=fh.read(), ctype="application/octet-stream")
    pub = req("POST", f"/deposit/depositions/{dep['id']}/actions/publish", tok)
    state = {"concept_doi": pub.get("conceptdoi"), "concept_recid": pub.get("conceptrecid"),
             "latest_id": pub["id"], "latest_doi": pub["doi"], "latest_tag": tag,
             "url": pub["links"]["html"]}
    json.dump(state, open(STATE, "w"), indent=1); print("PUBLISHED", json.dumps(state, indent=1))

if __name__ == "__main__":
    main()
