/-
  dhatukatha/Hetuka.lean — DATA for the known-answer control run 2026-11-22-dhatukatha-hetuka-by-kind-control (A132(d), "contains" BY KIND, ruled 2026-11-22 —
  roadmap A688). The two "-hetukā" classes read by the Dhammasaṅgaṇī's ATTHUDDHĀRA, which sets aside the delusion of the delusion-only citta(s):
    dassanena pahātabbahetukā  — "Cattāro diṭṭhigatasampayuttacittuppādā, vicikicchāsahagato cittuppādo, etthuppannaṃ mohaṃ ṭhapetvā" (abh01m.mul.xml:8837)
    bhāvanāya pahātabbahetukā  — "Uddhaccasahagato cittuppādo, etthuppannaṃ mohaṃ ṭhapetvā" (+ siyā the greed-without-view and hate cittas, :8841)
  Each class's composition under each reading of A132(d)'s "contains", in the shape vocabulary of Classes4.lean (elements: 6 = mind-consciousness):
    BY KIND        — delusion stays in the class through the cittas where greed roots it → the four aggregates → "allFour"
    BY OCCURRENCE  — one occurrence of a formation (delusion) is set aside → "formationAside"
  The Dhātukathā's stated row for both (L1381) is in SampayogaMatrix4.lean. ⚠️ A FIT, not a test: L1381 was known when the reading was chosen.
-/
namespace FormalAbhidhamma.Dhatukatha

def hetukaByKind : List (String × String × List Nat) :=
  [("dassanena_pahatabbahetuka", "allFour", [6]), ("bhavanaya_pahatabbahetuka", "allFour", [6])]

def hetukaByOccurrence : List (String × String × List Nat) :=
  [("dassanena_pahatabbahetuka", "formationAside", [6]), ("bhavanaya_pahatabbahetuka", "formationAside", [6])]

end FormalAbhidhamma.Dhatukatha
