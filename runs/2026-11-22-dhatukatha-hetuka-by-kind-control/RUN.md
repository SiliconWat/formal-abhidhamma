# Run: dhatukatha-hetuka-by-kind-control (2026-11-22) — A132(d) "contains" BY KIND, against the text's answer for the two -hetukā classes

**Registered:** `PREREG.md`, pushed 2026-11-23T03:42:46Z (push `dba8e4c`), a KNOWN-ANSWER CONTROL (agree direction) for the amendment of A132(d) the same evening
(founder: *"yes"*, roadmap A688). The case was VETTED before registration by a `refuter` (never this run's own); the data — `dhatukatha/Hetuka.lean`, the two classes
under each reading — was committed before the registration. **Window:** A0′. **Axioms:** A1 A30 A33 A74 A130 A131 A132. **Instrument:** `dhatukatha/CheckHetuka.lean`
(run 3's rule word for word), three theorems in `dhatukatha/run.sh`, a harness control and two breaks that fail.

## VERDICT: **PASS** — by kind reproduces the stated row for both -hetukā classes; by occurrence misses both, on association only. A check of a FIT: the instrument tells the two readings apart; it is not evidence for by kind.

## Result

- `by_kind_reproduces_L1381` — read BY KIND, *dassanena pahātabbahetukā* and *bhāvanāya pahātabbahetukā* hold all four aggregates, and the rule gives the Dhātukathā's
  row exactly (`abh03m1.mul.xml` L1381: associated *Natthi*; dissociated from 1 aggregate, 10 bases, 16 elements; partly from the dhamma base and element).
- `by_occurrence_misses_L1381` — read BY OCCURRENCE (one occurrence of delusion set aside → a formation set aside), both miss: the rule gives *partly associated*
  `(1, 1, 1)` where the text says *Natthi*.
- `the_miss_is_association_only` — the other three tuples agree under both readings, so the whole difference sits in the association term A132(d) governs.

**Breaks (each fails; the harness control passes first):** by kind read as an occurrence set aside · by occurrence read as all four (the control would stop
discriminating).

## What the vetting refuter established, before the registration

- **The set-aside is scoped to the delusion-only citta(s)** — settled by the mūla itself, not by *ettha* (which elsewhere covers every citta listed, `:8801`, `:8813`):
  the complements `abh01m.mul.xml:8845`, `:9621`, `:9629` place the view-cittas' delusion inside *dassanena pahātabbahetukā*; the Paṭṭhāna agrees
  (`abh03m10.mul.xml:2465`); the commentary gives the reason on the Nikkhepa (`abh01a.att.xml:8989`, `:8993`: the delusion of doubt and of restlessness has no
  other root associated with it, *aññassa sampayuttahetuno abhāvena hetuyeva, na sahetuko*); the Mūlaṭīkā likewise (`abh01t.tik.xml:2357`).
- **For *bhāvanāya pahātabbahetukā* delusion stays only through its *siyā* members** (greed without view, hate; `:8841`) — the view-cittas are NOT members (`:9629`).
  The amendment's first wording named the view-cittas for both classes; corrected the same day in `kala/AXIOMS.md`. Read by its definite members alone, that class
  would miss too; the *siyā* members are counted on the evidence of the Nikkhepa (`:7149`, *Avaseso lobho, doso, moho*) and of *micchattaniyatā*, defined only by
  *siyā* members (`:8909`) and still given a *Natthi* row (L1393).
- **The passing arm adds no new evidence**: it is run 4's tuple, scored against the same row. The control's information is the failing arm.

## Outside the control — read by the vetting refuter, so no longer blind

The same by-kind pattern, with contrasts that show it does not over-generate: *sahetukā* and *hetusampayuttā* (`abh01m.mul.xml:9001`, `:9009`, the two rootless
delusions set aside) → *Natthi* (`abh03m1.mul.xml:1421`); *āsavasampayuttā* (`:9113`, even the hate citta's delusion set aside, while delusion stays through the
greed cittas) → *Natthi* (`:1445`); against *etthuppanne hetū ṭhapetvā* (`:9021`, EVERY root set aside — no kind retained) → *kehici sampayuttā* (`:1425`), and every
āsava set aside (`:9133`) → *kehici* (`:1449`). Cited support, not machine-checked here (they are dyad rows; the parser reads the triads). No §257–305 association row
breaks the by-kind reading (the refuter searched every *ṭhapetvā* in the Dhammasaṅgaṇī, 139, against those rows). Not reached: *ganthasampayuttā*,
*upādānasampayuttā*, *saṃyojanasampayuttā* (no association row in this section), and the Dhātukathā's other methods.

## Predictions scored

1. *By kind reproduces L1381 for both:* **HIT.** 2. *By occurrence misses both:* **HIT.** 3. *The bhāvanāya class needs its siyā members:* declared, not tested.

**Refuter:** the vetting refuter's report bears on the whole case; no separate run refuter was spawned — the encoding is two tuples per reading, and both arms are
scored against a row two refuters have already read. Offered.
