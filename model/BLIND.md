# BLIND — the blind readers' plain English for every definition (Protocol 1 §7.3)

*Five `lean` readers (no memory, no doctrine, no CLAUDE.md) each read ONLY the comment-stripped copies in `model/blind/` (copied outside the repository so the original comments could not be reached) and wrote what each definition REQUIRES of a world. `scripts/simile_guard.py` ran clean on the copies first. Their tables are kept below as the readers wrote them (2026-10-20), Cond and Cosmos condensed by the session from the reader's table. `model/table.py` joins them to the rows and the Lean as `model/TABLE.md`, the table the founder reads before Protocol 2. A reader's remark is kept as a remark; ⛔ none is acted on by this file.*

## Mind.lean

| definition name | plain English |
|---|---|
| a1_never_together | For any two different moments m and n, at least one of: n does not arise before m closes, or m does not arise before n closes. No two different moments can overlap; touching is allowed (the test is strict less-than). |
| a117_arising_and_dissolution | Every moment arises strictly before it dissolves, and dissolves strictly before it closes. Says nothing about "stand". |
| a40_three_equal | For every moment there is a positive step d with stand = arise + d, dissolve = stand + d, close = dissolve + d: four times evenly spaced by one positive amount. (Implies a117's ordering.) |
| a3_no_moment_between | For any m, n: prox m n holds exactly when m arises strictly before n and no moment at all arises strictly between them. prox is the immediate successor by arising time; if arising times are dense or tied it may be empty. |
| c_every_citta_has_a_proximate | Every moment n has some m with prox m n: every moment has an immediate predecessor in arising order. |
| a77_beginningless | Every moment has some moment arising strictly before it: no earliest-arising moment. (Mostly redundant with the previous definition when prox is as in a3, but stated independently.) |

Reader: a Scale is a type of values with a strict less-than (irreflexive, transitive, total), an associative commutative addition with zero, and left-addition preserving less-than; it does not require positivity or cancellation. A Stream imposes no constraints in itself.

## Clocks.lean

| definition name | plain English |
|---|---|
| a7_reckoning_keeps_order | f never reverses order: if a is strictly below b in S, then f b is not strictly below f a in R (monotone, non-strict; f may be constant). |
| a112_cessation_step | For any moment m marked cessation and any n with prox m n: f(arise n) is not below f(close m) + night, and f(close m) + week is not below f(arise n): the gap from m's close to n's arising, in R, is at least "night" and at most "week". Vacuous if no moment is marked cessation. |
| a24_no_night | For every moment m, f(close m) is strictly below f(arise m) + night: each moment's duration in R is less than "night". |
| a24_rate | For every R-time-point x there exists a list of distinct moments, at least 10^12 long, each arising at or after x and strictly before x + snap: every window of length "snap" holds at least a trillion distinct moments. Very strong: requires infinitely many moments overall (in effect). |

## Join.lean

| definition name | plain English |
|---|---|
| j_readings_are_the_moments | Whenever position i is mapped to a moment m and the occurrence list has an entry a at position i, that entry has kind "nama", its rise equals the moment's arise value, and its fall equals the moment's close value. Positions with no moment or no occurrence are unconstrained. |
| a3_proximity_is_the_streams_prox | For all positions i, k: the triple (anantara, i, k) is in the holds list exactly when i and k map to moments m and n with prox m n: the anantara links match the stream's prox in both directions and require both positions to map to a moment. |

## Status.lean

| definition name | plain English |
|---|---|
| a26_ultimates | The "ultimates" list is exactly [citta, cetasika, rupa, nibbana], in that order. |
| a8_time_free | The "timeFree" list is exactly [nibbana, pannatti], in that order. |
| a9_three_spaces | delimiting maps to rupa, kasina maps to pannatti, unentangled maps to pannatti. |
| a70_nibbana | nibbanaConditioned is false and nibbanaCount is exactly 1. |
| a104_time_is_a_concept | timeSort is pannatti. |
| a126_only_own_nature | For every designation d, realDesignation d is true exactly when d is ownNature. |
| a76_twelve_links | The chain is exactly the twelve links in the declared order, each once. |
| a77_structure | periods is exactly [2, 8, 2], and modes 20, connections 3, groups 4, rounds 3, roots 2. |

Reader: each a-def in Status.lean pins fields of a record to fixed values, so they are satisfiable by construction and constrain only the record, not any world. (Session: true, and intended — these rows are type-level facts; see the census class T.)
| a7_time_is_a_concept | Time's sort is pannatti and is not among the ultimates. |
| a5_delimiting_space_is_matter | The delimiting space's sort is rupa. |

## Tax.lean

| definition name | plain English |
|---|---|
| kiccaTable | For a given citta and a Kicca, says whether the citta can do that function: patisandhi, bhavanga and cuti need a vipaka citta of one of three kinds (kama, no roots, manovinnana, upekkha; kama with beautiful roots; any rupa- or arupa-realm citta); avajjana needs kiriya, no roots, upekkha; the five sense functions need the matching sense element 1 to 5; sampaticchana needs vipaka with mano element; santirana needs vipaka, kama, no roots, manovinnana; votthabbana needs kiriya, no roots, upekkha, manovinnana; javana needs kusala, or akusala, or lokuttara vipaka, or kiriya that is not (rootless and upekkha); tadarammana needs vipaka, kama, and either beautiful roots or (no roots and manovinnana). |
| originTable | A fixed table saying whether a Rupa has a given Origin: hadaya, the five pasada, itthatta, purisatta and jivita only kamma; the two vinnatti only citta; sadda citta or utu; lahuta, muduta, kammannata every origin except kamma; upacaya, santati, jarata, aniccata none; every other Rupa all four. |
| jhanaTable | Whether a meditation subject allows a given jhana number: any kasina, and anussati 10, 1 to 5; any asubha, and anussati 9, only 1; appamanna 4 only 5; other appamanna 1 to 4; any aruppa only 6; everything else none. (Match order: anussati 10 is handled as 1 to 5; other anussati values fall through to false.) |
| a27_seventytwo | The salakkhana list has no repeats and exactly 72 entries. |
| a28_eightynine | The kinds list has no repeats; its collapsed version (kinds89) has 89 entries, split 54 kama, 15 rupa, 12 arupa and 8 lokuttara (lokuttara cittas differing only by jhana or feeling merge). |
| a28_onetwentyone | The kinds list has 121 entries, 40 of them lokuttara; for every lokuttara citta in kinds89 and each jhana number 1 to 5, some citta in kinds collapses to it and has that jhana number. |
| a29_fiftytwo | The cets list has no repeats and 52 entries: 7 universals, 6 occasionals, 14 unwholesome, 25 beautiful. |
| a31_universals | Every citta in kinds is associated with every cetasika in universals. |
| a32_generated | The kinds list contains exactly the same cittas as cittas121 (defined elsewhere); no check of duplicates or order. |
| a32_association | For every citta in kinds and every item in FormalAbhidhamma.all, assoc agrees with an external function `arises`. |
| a33_feelings | Among kinds, exactly 1 citta has sukha, 1 dukkha, 62 somanassa, 2 domanassa, 55 upekkha (sum 121). |
| a34_roots | Among kinds89, 18 cittas have 0 roots, 2 have 1, 22 have 2 and 47 have 3 (sum 89). |
| a35_every_function | Every Kicca is performed by at least one citta in kinds89. |
| a35_counts | In kinds89, 68 cittas perform exactly 1 function, 2 exactly 2, 9 exactly 3, 8 exactly 4, 2 exactly 5 (sum 89, so no citta performs 0 or 6+). |
| a35_which | For every citta in kinds89 and every Kicca, the kicca field gives the same answer as kiccaTable. |
| a36_nineteen | Exactly 19 of the taxonomy's 89 kinds can perform patisandhi, bhavanga or cuti. |
| a38_one_object | For every sense citta in kinds89, the scope (flag false) is true for exactly one object, the one senseObj gives for the citta's door. |
| a38_supramundane | For every lokuttara citta in kinds, the scope (flag false) is true for exactly nibbana. |
| a38_twentyfive | Exactly 25 cittas in kinds89 are kama-realm, take at least one object, and take only kama-type objects. |
| a38_twentyone | Exactly 21 cittas in kinds89 take exactly the pannatti object and no other. |
| a38_six_any | Exactly 6 entries in modes (a citta plus a flag) can take every object. |
| a38_six_exalted | Exactly 6 cittas in kinds89 take exactly the mahaggata object and no other. |
| a38_twenty | Exactly 20 cittas in kinds89 take every object except lokuttara, agga and nibbana, and none of those three. |
| a38_five_but_agga | Exactly 5 entries in modes take every object except agga. |
| a60_twentyeight | The rupas list has no repeats and exactly 28 entries. |
| a60_concretely_produced | nipphanna is true exactly when the Rupa is not in anipphanna; exactly 18 members of the rupas list are nipphanna. |
| a62_internal | internal is true exactly when the Rupa is in pasada. |
| a62_gross | gross is true exactly when the Rupa is in pasada or gocara; exactly 12 Rupa labels are gross. |
| a62_clung | clung equals the origin function's answer for kamma. |
| a62_visible | visible is true only for vanna. |
| a62_base | base is true exactly for the five pasada and hadaya. |
| a62_door | door is true exactly for the five pasada and the two vinnatti. |
| a62_faculty | faculty is true exactly when the Rupa is in indriyaRupa. |
| a65_table | For every Rupa and Origin, the origin field equals originTable. |
| a65_counts | Among the rupas list, 18 have kamma origin, 15 citta, 13 utu, 12 ahara. |
| a107_fifth_jhana | Every citta in kinds flagged abhinna is rupa-realm and has jhana 5 (vacuous if none is flagged). |
| a71_sizes | For each PapaCat, the papa list has as many groups as the category's size (asava, ogha, yoga, gantha, upadana 4; nivarana 6; anusaya 7; the last three 10). |
| a71_unwholesome | In every papa group, each member list is non-empty and every cetasika in it is in the unwholesome list. |
| a72_sizes | For each MissakaCat, the missaka list has as many groups as the category's size (hetu 6, jhananga 7, maggangaRight 8, maggangaWrong 4, indriya 22, bala 9, adhipati 4, ahara 4). |
| a72_life_faculty | In the indriya category some group contains the rupa jivita, and some group contains the cetasika jivitindriya (possibly different groups). |
| a38_which | The taxonomy's scope function agrees with `scopeTable` for every one of the 89 kinds of citta, with the flag both false and true, and for every object. |
| a38_abhinna_which | The taxonomy's abhinna function agrees with `abhinnaTable` on all 89 kinds. |
| a71_by_nature | The distinct cetasikas in each papa list: asava, ogha, yoga 3 each; gantha 3; upadana 2; nivarana 8; anusaya 6; the two fetter lists together 9; kilesa 10. A count check only. |
| a71_which | The taxonomy's papa lists equal `papaTable` for every papa category (the exact members). |
| a72_which | The taxonomy's missaka lists equal `missakaTable` for every missaka category. |
| a73_which | The taxonomy's bodhi lists equal `bodhiTable` for every bodhi category. |
| a74_which | The taxonomy's sabba lists equal `sabbaTable` for every sabba category. |
| a72_nutriments | The ahara category is exactly the four groups [rupa ahara], [cetasika phassa], [cetasika cetana], [citta], in that order. |
| a73_sizes | For each BodhiCat, the bodhi list has as many groups as the category's size. |
| a73_fourteen | Taking all groups from all bodhi categories, flattening and removing duplicates, there are exactly 14 distinct groups. |
| a74_sizes | For each SabbaCat, the sabba list has as many groups as the category's size (khandha 5, upadanakkhandha 5, ayatana 12, dhatu 18, sacca 4). |
| a74_nibbana_outside | No group in the khandha category contains nibbana. |
| a74_sixtynine | The dhammayatana list has no repeats and 69 entries; each passes inDhammaBase; every cetasika in cets is in it; every non-gross rupa in rupas is in it; nibbana is in it. |
| a74_seven_elements | The cittas in kinds show exactly 7 distinct dhatu values. |
| a105_forty | The kammatthana field equals kammatthana40 exactly. |
| a105_absorption | For every subject in the flattened kammatthana list and every jhana number 1 to 6, kjhana equals jhanaTable. |
| a5_space_anipphanna | t.nipphanna of akasa is false (space is not classed as concretely produced). |

## Proc.lean

| definition name | plain English |
|---|---|
| veryGreatOrder | True when the list starts exactly with the five-door head, then has at least one javana, and after the javanas is either nothing or exactly two tadarammana. |
| mindDoorOrder | True when the list starts with at least one bhavanga, then one avajjana, then at least one javana, then only tadarammana (any number, including zero). |
| absorbsAfter | True when the first m javana steps are all kama, there is at least one more step, and all the remaining steps are non-kama. |
| afterPath | The steps after (and including) the first path step; empty if no path step exists. |
| a35_station_fits | In every step of every process, the taxonomy permits that step's citta (in the 89 scheme) to perform that step's kicca. |
| a36_organs | The organs for eye, ear, nose, tongue and body are exactly cakkhu, sota, ghana, jivha and kaya. Says nothing about the mind door. |
| a36_mind_door_no_organ | The mind door has no organ. |
| a36_mind_door_is_bhavanga | Every process that is not a five-door process begins with a bhavanga step (an empty process fails). |
| a36_door_free | In every step, the step has no door exactly when its kicca is patisandhi, bhavanga or cuti. |
| a37_sense_door_present | Every step with a door that is not the mind door has time "present". |
| a37_mind_object | The world's mind-object list contains all pasada rupas, all non-gross rupas the taxonomy marks, citta, every cetasika in the taxonomy, nibbana and pannatti. |
| a38_in_scope | Every step is within the taxonomy's scope for its citta, abhinna flag and object. |
| a41_entry | Every five-door process has past at least 1. |
| a41_two_vibrations | Every five-door process with past exactly 1 begins with the kiccas bhavanga, bhavanga, avajjana. |
| a41_order | Every five-door process with past 1 has, after dropping its first two steps, a kicca order satisfying veryGreatOrder for its door. |
| a41_seventeen | Every five-door process with past 1 has past plus number of steps at most 17. |
| a42_very_great | Every five-door process with past 1 has at least one javana. |
| a42_slight | Every five-door process with past 4 to 9 has no javana and has 2 or 3 votthabbana steps. |
| a42_very_slight | Every five-door process with past 10 to 15 consists only of bhavanga steps (an empty process passes). |
| a43_clear | Every mind-door process marked clear has at least one tadarammana. |
| a43_obscure | Every mind-door process marked not clear has no tadarammana. |
| a43_order | Every mind-door process has a kicca sequence satisfying mindDoorOrder. |
| a43_absorption | Every absorption or path process has javanas where the first 3 are kama and the rest non-kama, or the first 4 are kama and the rest non-kama; at least one non-kama javana is required. |
| a43_absorption_no_registration | Every absorption or path process has no tadarammana. |
| a44_seven_or_six | Every five-door or mind-door process not near death has 0, 6 or 7 javanas. |
| a44_five_at_death | Every five-door or mind-door process near death has 0 or 5 javanas. |
| a44_first_once | Every absorption process flagged first has exactly one non-kama javana. |
| a44_abhinna_once | Every process has at most one step with the abhinna flag set. |
| a44_path_one_moment | Every path process has exactly one path step. |
| a44_fruition | Every path process has 2 or 3 steps after the path step, all fruit steps. |
| a45_desirability | In every process, each step with a sense-type, sampaticchana, santirana or tadarammana kicca has a citta whose ofKusala value equals "the process desirability is not anittha". |
| a45_sense_beings | Every process with at least one tadarammana has plane kama. |
| a45_sense_objects | Every tadarammana step has an object that counts as a sense (kama) object. |
| a45_sense_javana | Every process with a tadarammana has javanas that are all kama. |
| a45_clear_or_very_great | Every process with a tadarammana is either a five-door process with past 1, or a mind-door process that is clear. |
| a57_five_at_death | Every process flagged near death has 0 or 5 javanas. |
| a57_kamma_past | Every patisandhi or bhavanga step with sign kamma has time "past". |
| a106_first | Every arupa attainment step with base 1 has object pannatti. |
| a106_second | Every arupa attainment step with base 2 has object mahaggata and objBase 1. |
| a106_third | Every arupa attainment step with base 3 has object pannatti. |
| a106_fourth | Every arupa attainment step with base 4 has object mahaggata and objBase 3. |
| a109_insight | Every path process has, after 3 or 4 initial all-kama javanas, a next javana that is a path step. |
| a109_change_of_lineage | In every path process, the last step before the first path step has object nibbana (fails if there is no step before it). |
| a109_path_once | Every path process has exactly one path step (same as a44_path_one_moment). |
| a109_fruition | Every path process has 2 or 3 fruit steps after the path step (same as a44_fruition). |
| a115_conditions_meet | For every meeting at a non-mind door where the door is intact, in range and attended, at least one following step has a kicca belonging to that door's sense functions. |
| a46_javana_by_person | For every javana in every process: an arahant's javanas are not kusala (or are lokuttara); an arahant's javanas are not akusala; a non-arahant's javanas are not kiriya; a lokuttara javana implies the person is not a worldling. |
| organAbsent | Helper: for a sense element d, true when the plane is arupa, or rupa with d at least 2; false for any other element. |
| a46_plane_organs | No step of any process uses a sense element that is absent on that process's plane (organAbsent is false). |
| a42_great | Every five-door process with past 2 or 3 holds at least one javana and no registration. Other processes are unconstrained. |

## Mat.lean

| definition name | plain English |
|---|---|
| a39_sense | Every being on the kama plane has bases exactly equal to sixBases (same order). Vacuously true if there are no kama beings. |
| a39_fine | Every being on the rupa plane has only bases drawn from cakkhu, sota, hadaya: an upper limit, not a requirement. |
| a39_immaterial | Every being on the arupa plane has an empty bases list. |
| a4_life | Every kalapa with no member in anipphanna has life exactly 51; kalapas with any anipphanna member are unconstrained. |
| a15_eight | Every kalapa contains all eight of pathavi, apo, tejo, vayo, vanna, gandha, rasa, ahara. |
| a15_lightness | Any kalapa containing lahuta must have an origin other than kamma and must have an owner. |
| a63_reach | The reached list is exactly [nose, tongue, body], in that order (pins the list; not a "contains" test). |
| a6_unbound | For every kalapa, bound is false exactly when owner is none. |
| twentyOne / isKind | A fixed list of 21 (member list, origin) pairs (9 kamma, 6 citta, 4 utu, 2 ahara); isKind compares a kalapa's members after canon (Rupa.all order, duplicates dropped) and origin to a pair. |
| a66_twenty_one | Every kalapa matches at least one of the 21 listed pairs. |
| a66_external | Every kalapa with no owner is exactly the eight with utu origin, or exactly the eight plus sadda with utu origin. |
| a66_no_delimiter_member | No kalapa has akasa, upacaya, santati, jarata or aniccata among its members. |
| a5_space | Every gap is a pair of two different valid kalapa indexes. |
| a13_arupa | Every arupa-plane being has no matter and has mind. |
| a13_mindless | Every being without mind has matter and has jivita in its faculties. |
| a129_ladder | The ladder equals exactly [36,36,36,36,7,7,7]. (Reader: also the default, so trivially true unless overridden.) |
| a129_size | Every kalapa has size exactly 1. (Reader: also the default.) |
| fineKinds / nonPercipientKinds | All Rupa.all entries except ghana, jivha, kaya, itthatta, purisatta; and the eight plus jivita, akasa, lahuta, muduta, kammannata, upacaya, santati, jarata, aniccata. |
| a68_fine | (1) Every rupa-plane being's kinds list is within fineKinds. (2) No kalapa owned by a rupa-plane being has ahara origin. |
| a68_immaterial | Every arupa-plane being has an empty kinds list. |
| a114_absent | Any being whose breathCase is not normal, or which is on the rupa or arupa plane, or has no mind, must have breathes = false. Nothing forces anyone to breathe. |
| a39_other | Every being on the lokuttara plane has all its bases among the six. |
| a68_non_percipient | Every rupa-plane being with no mind has all its kinds among the non-percipient kinds. Other beings are unconstrained. |

## Link.lean

| definition name | plain English |
|---|---|
| a120_mind_born_at_arising | Every item with citta origin has phase arise. |
| a120_kamma_born_at_all_three | For every embodied moment and each of the three phases, some item exists with kamma origin, that moment, and that phase. |
| a118_core | No item with citta origin has phase dissolve. (Weaker than a120_mind_born_at_arising, which fixes the phase to arise.) |
| a64_kamma_from_rebirth | Every kamma-origin item has some rebirth moment r that is the item's own moment or strictly earlier. |
| a67_mind_born_not_at_rebirth | No citta-origin item sits at a rebirth moment. |
| a64_mind_born_only_by_producers | Every citta-origin item sits at a moment satisfying produces. |
| a4_life_in_the_stream | For every concrete item: arising → reached by exactly 16 steps, cease phase dissolve; standing → 17 steps, cease phase arise; dissolving → 17 steps, cease phase stand (exact step counts). |
| k_kamma_born_stops | For any death moment d and any b that is 16 steps before d, every kamma-origin item is not at b with a phase other than arise, and is not 1 to 16 steps after b (which includes d). |
| a122_death_then_rebirth | Whatever immediately follows (via prox) a death moment is a rebirth moment. |
| a122_rebirth_after_death | Every rebirth moment is the immediate prox successor of some death moment. |
| a58_begins_with_rebirth | For every moment m there is a rebirth moment that is m itself or strictly earlier. |
| a47_unbroken | For every moment m that is not marked a death moment, some moment n is linked from m by prox: every non-death moment has at least one successor. (Re-read 2026-10-20 after the definition was corrected; the first reading — *every* moment has a successor, forcing an endless stream — showed the first version too strong. The re-reader adds: existence only, not uniqueness or lateness; death moments are exempt but may have a successor; a world with no death marks is endless; marking every moment death makes it trivial — the death marks are constrained by A122 and A58 elsewhere.) |
| a111_emerges_by_fruition | Any moment following a cessation moment (via prox) is a fruition moment. |
| a111_no_death_within | For a cessation moment m and a successor n, neither m nor n is a death moment. |
| present_at_arising | Occurrence k's arising reading is strictly earlier than moment m's arising, and k's ceasing reading is not strictly earlier than it (a cessation at the same reading still counts as present). |
| a116_prenascent_unceased_base | Every sense moment has a base, and that base is present at the moment's arising (arisen strictly before, not ceased before). |
| a87_organ_and_object_already_arisen | Every sense moment has both a base and an object, each present at the moment's arising. |

## Cond.lean

(blind reader's table, verbatim in substance; notation: a "fact" is a triple (condition, i, j) in the world's `holds` list)

| definition name | plain English |
|---|---|
| a78_relata | Every fact of any condition must have two real ends, and the kinds of those ends must be admitted for the group that `sangaha` assigns to the condition. Facts pointing at nonexistent positions make it false. |
| a83_co_nascent | For every sahajata fact, the two ends have the same rise time. It says nothing about fall times. |
| a84_mutual | For every annamanna fact, the ends have the same rise time. Also, the reversed fact (annamanna, j, i) must be in the list. |
| a88_post_born | The mirror of a87. For every pacchajata fact, the second end rises strictly before the first rises; the second has not fallen strictly before the first rises. |
| a97_dissociated | For every vippayutta fact, the two ends have different kinds. |
| a98_present | For every atthi fact, the two ends' lifetimes overlap or touch: neither fell strictly before the other rose. |
| a99_absent | For every natthi fact, the first rises strictly before the second, and the second does not rise strictly before the first falls: the first has ended by the time the second starts, or ends exactly then. |
| a100_gone | Identical in content to a99, for vigata facts. |
| sameCittaTogether | Two occurrences have the same `cit` number and the same rise time. |
| a79_root_scope | For every hetu fact, the ends have the same `cit` and rise time. |
| a81_predominance | For every adhipati fact, either the ends share `cit` and rise time, or the second end is nama. |
| a90_kamma | For every kamma fact: either the ends share `cit` and rise time; or the first rises strictly before the second and the second either has a vipaka citta or has `born` = kamma. |
| a89_repetition | For every asevana fact, both ends are nama, the first rises strictly before the second, both have the same `jati`, that `jati` is not vipaka, and the first has a citta. |
| a93_faculty | For every indriya fact one of: (1) the first end's rupa is in `pasada` and the second end is nama; (2) the first end's rupa is `jivita` and the second was born of kamma; (3) the first end is nama and the ends share `cit` and rise time. |
| senseOfObject | vanna→1, sadda→2, gandha→3, rasa→4, pathavi/tejo/vayo→5, else nothing. |
| a80_object_sense | For every arammana fact, take the first end's rupa r with a sense number n; if the second end's citta has dhatu `sense d`, then d = n. Vacuous when the first end has no rupa, the rupa has no number, or the second end's dhatu is not a sense one. |
| a82_contiguity_same_relata | For all i and j, an anantara fact (i,j) is present exactly when a samanantara fact (i,j) is present. |
| a121_passes_away | Every occurrence has rise strictly before fall. |

Reader's observations: a98/a101 are the same statement under different condition names; a99/a100 likewise; a96 requires matching fall times but a83 does not; every `a…` predicate except a82 and a121 is vacuously true in a world with no facts of its condition.
| prenascent | A list of 13 matter kinds: the five sense organs (cakkhu, sota, ghana, jivha, kaya), vanna, sadda, gandha, rasa, pathavi, tejo, vayo, and hadaya. Only a list. |
| a87_pre_born | Every purejata fact from occurrence a to b needs: a rises strictly before b rises, b rises strictly before a falls, and a's matter-kind is one of the 13 in `prenascent`. Says nothing about what b is. |
| a96_associated | For any two different occurrences i and j that are both mental (nama) and share the same `cit`, the world must record the sampayutta condition from i to j. A forced-presence rule, in both directions. |
| a30_sampayutta_marks | Every recorded sampayutta fact between two occurrences needs both mental, with identical rise and identical fall. Restricts the facts present; forces none. |
| a101_not_disappeared | For every pair i, j, the avigata fact holds exactly when the atthi fact holds. |
| vipakaNama | An occurrence is mental and some occurrence sharing its `cit` has a citta whose jati is vipaka (possibly itself). |
| ownCittaScope | a is mental and b has the same `cit`; b is mental, or matter whose origin is citta. |
| a94_jhana_scope | Every recorded jhana fact between a and b satisfies ownCittaScope. Restricts present facts; forces none. |
| a95_path_scope | As a94, for the magga condition. |
| a91_result | For any two different occurrences i and j that are both vipakaNama and share a `cit`, the world must record the vipaka condition from i to j. Forced presence, both directions. |
| a78_vipaka_scope | Every recorded vipaka fact between a and b needs both mental, the same rise, and both citta-types resultant (vipaka). Restricts present facts. |
| a92_nutriment | Every recorded ahara fact between a and b is either (a's matter-kind is ahara and b is matter) or satisfies ownCittaScope. Restricts present facts. |

## Cosmos.lean

| definition name | plain English |
|---|---|
| a14_sineru | sunk, risen, sineruLength, sineruWidth and oceanDepth are all exactly 84000. |
| a17_discs | The first and second components of the moon triple are 49; of the sun triple, 50. |
| a19_solids | The third component of the moon triple is 49; of the sun triple, 50. |
| a16_stack | (1) Twice moonBottom is at most `risen`; (2) sunBottom = moonBottom + the moon's third component + 1; (3) moonBottom + 100 = sunBottom + the sun's third component. Relates the numbers without pinning an absolute value; combined with a19, consistent. |
| a20_day_gain | dayGain equals 100000. |
| a22_three_lit | litContinents equals 3. |
| a23_cakkavala | cakkavala equals 1203450. |
| a48_planes | The `planes` list is exactly [4, 7, 16, 4]. |
| a11_day_lengths | kingsDay is 50 and yamaDay is 200. |
| a49_lifespans | For every k from 0 to 5, lifespan k = 9000000 × 4^k; nothing for k above 5. |
| a10_phases | kappaPhases equals 4. |
| a10_limits | fireReaches 5, waterReaches 8, windReaches 9, destroyedFields 1. |
| a50_plane_lives | The `planeLife` list is exactly the given 20 numbers, from 2 up to 504000. |

Reader's observation: every Cosmos predicate is a bare equality of fields to stipulated numbers; a16 is the only one that relates fields to each other.

## Re-read, 2026-10-20 — the definitions changed or added after the first refuter pass (`FINDINGS.md`)

*One blind reader (no memory, no doctrine) read only a file holding these definitions with their comments removed. Where a name appears above and here, THIS reading replaces it (`table.py` takes the last).*

| definition name | plain English |
|---|---|
| a107_fifth_jhana | Every citta-type in the list that is flagged as a super-knowledge type must be of the rupa plane, have jhana 5, and be of kind kusala or kiriya. Nothing in the reverse direction; vacuous if none are flagged. |
| a74_nibbana_outside | For the two groupings khandha and upadanakkhandha, no member group in the world's list for either contains nibbana. Vacuous if those lists are empty. |
| a43_clear | For every mind-door process that is clear and on the sense plane: if every one of its javana steps is a sense-sphere step whose object is sense-sphere, then the process contains at least one tadarammana step. The antecedent can be false, in which case nothing is required. |
| a57_kamma_past | Every step in every process that carries the sign kamma must have its time marked past. |
| a46_javana_by_person | For every javana step of every process: (1) if the person is an arahant, the step's citta is neither kusala nor akusala, and if supramundane it must be vipaka with path equal to 4; (2) if the person is not an arahant, it is not kiriya; (3) if it is supramundane, the person is not a worldling. |
| a35_step_cittas_are_types | For every step of every process, the step's citta, after reckon89, is in the taxonomy's kinds89. |
| a38_abhinna_flag_is_an_abhinna_citta | Whenever a step has its abhinna flag set, the taxonomy marks that step's citta (after reckon89) as an abhinna type. |
| a36_steps_at_the_processs_door | For each process: if five-door its door is not the mind door; otherwise its door is the mind door; and every step that names a door names the process's door. |
| doorObject | eye gives rupa, ear gives sadda, nose gives gandha, tongue gives rasa, body gives photthabba, mind gives kamaOther. |
| a37_sense_door_takes_its_object | In every five-door process, every step that names a door has as its object exactly doorObject of the process's door. |
| a42_range | Every five-door process has its past count at most 15. |
| a43_kind_follows_content | For every process: it contains some path step exactly when its kind is path; and if its kind is five-door or mind-door, all its javana steps are sense-sphere steps. |
| a115_no_conditions_no_consciousness | For every meeting at a non-mind door where it is not the case that intact, in range and attended all hold, none of the steps that follow has a kicca in that door's sense-kicca list. |
| a39_sense | Every being on the sense plane has all its bases drawn from sixBases. |
| a4_life | Every kalapa whose members include neither bodily-intimation nor verbal-intimation matter has life exactly 51; clusters containing either are unconstrained. |
| a120_kamma_born_at_all_three | For every embodied moment that is not within 16 or fewer steps before some death moment, and for each of the three phases, there is an item of origin kamma at that moment and phase. Moments within 16 steps before a death are exempt. |
| a56_death_followed_unless_final | Every death moment that is not a parinibbana moment has some next moment under the stream's proximity relation. |
| a56_final_ends | Every parinibbana moment is a death moment and has no next moment at all. |
| a88_post_born | Every post-born fact: the second arises strictly before the first arises, and the first arises strictly before the second falls. |
| a98_present | Every presence fact: the two lifetimes strictly overlap. |
| a81_predominance | Every predominance fact has endpoints such that either they are the same-citta-together case, or the second is of kind nama and an object fact on the same pair is also recorded. Fails if endpoints cannot be found. |
| a121_passes_away | Every occurrence not of kind pannatti arises strictly before it falls. Pannatti occurrences are exempt. |
| a24_rate | For any two moments m and n joined by exactly 10^12 stream steps, none departing from a moment flagged cessation, the clock time of n's arising is strictly less than m's arising time plus one snap. |
| a112_night_week_order | Zero is strictly less than snap, snap is strictly less than night, and week is NOT strictly less than night. |
| a47_unbroken_on_the_clock | For every moment m not flagged cessation and its next moment n, the clock time of m's closing is not strictly less than the clock time of n's arising (no gap; overlap allowed). |
| a3_cit_labels_are_moments | For any two occurrences both assigned moments, they have equal cit label exactly when they are assigned the same moment. |
| a3_every_moment_has_an_occurrence | Every moment of the stream is assigned to by some occurrence index within the occurrence list. |
| a16_stack | Twice moonBottom is at most risen; risen is at most twice moonBottom plus 200; sunBottom equals moonBottom plus the moon's third component plus 1; and moonBottom plus 100 equals sunBottom plus the sun's third component (the last two force the two third components to sum to 99). |

## Occurs.lean — the occurrence list as Lean (read 2026-10-20)

| definition name | plain English |
|---|---|
| o_a28_every_type | Every item in the world's list of 89 kinds must appear in at least one process: some step of some process must have its citta reckoned (by reckon89) as that kind. |
| o_a29_every_cetasika | Every item in the world's cetasika list must be associated with the reckoned kind of some step's citta in some process. |
| o_a35_every_function | Every function in Kicca.all must be the function of some step in some process. |
| o_a36_every_door | Each of the six doors must be the door of at least one process. |
| o_a41_very_great | There must be a process of kind fiveDoor whose "past" value is exactly 1. |
| o_a42_every_grade | There must be four fiveDoor processes, with past = 1, past in 2..3, past in 4..9 and past in 10..15 respectively. (The first clause duplicates o_a41; one process cannot fill two grades.) |
| o_a43_mind_door_and_absorption | There must be at least one process of kind mindDoor and at least one of kind absorption. |
| o_a109_path | There must be at least one process of kind path. |
| o_a110_every_person | There must be processes whose person is worldling, noble and arahant (at least one of each). |
| o_a115_a_meeting | There must be a meeting whose door is not mind and which is intact, inRange and attended. |
| o_a107_an_abhinna | Some item in the world's kinds list must be marked abhinna = true. |
| o_a48_every_sphere | For each of the three planes (kama, rupa, arupa), the world must have a being in that plane. |
| o_a13_both_kinds | There must be a being in plane arupa and a being with hasMind = false (possibly different beings). |
| o_a60_every_kind | Every rupa marked nipphanna must be a member of at least one kalapa in the world. Vacuous if no rupa is marked nipphanna. |
| o_a6_outside | There must be a kalapa whose owner is none. |
| o_a64_every_origin | Every origin in Origin.all must be the origin of at least one kalapa. |
| o_a66_every_kalapa | For every entry t in twentyOne, some kalapa must satisfy isKind k t. |
| o_k_a_corpse | Some death must exist, and some kalapa must have origin utu and an owner that is not none. (Reader: the two parts are not linked; the kalapa need not be tied to that death, and nothing about a corpse is stated — a known weak form, named in the file.) |
| o_a56_death_then_rebirth | There must be a death d and a rebirth n such that n is the proximate successor of d. |
| o_a77_a_stream | There must exist at least one moment. |
| o_a78_every_condition | Every condition in Relata.all must be the first component of some entry in the world's holds list. |
| o_a111_cessation_with_emergence | There must be moments m and n such that m is a cessation, n is the proximate successor of m, and n is a fruition. |
| Occurs | The conjunction of the 22 conditions above. A pure existence and coverage list; constrains nothing else. |
| emptyWorld | A world over the whole-number scales with no moments and no kalapas, every predicate false, every list empty, f the identity (night 2, week 7, snap 1) and placeholder process, taxonomy, cosmos and status. It cannot satisfy Occurs. |
| a4_variant_sixteen | For a link: for every concrete item that arises at a citta's arising, the cease moment is reached from the start moment in exactly 15 steps of proximity and the cease phase is dissolve. Vacuous if nothing is concrete and arising. |
