import Canon
import AnswerKey
namespace FormalAbhidhamma
open Cetasika
set_option maxRecDepth 100000
def ext (cs : List Citta) (x : Cetasika) : Nat := occurrences cs x
def lst (l : List Nat) : String := "[" ++ ", ".intercalate (l.map toString) ++ "]"
def kv (k : String) (v : String) : String := s!"\"{k}\": {v}"
def factors : List (String × Cetasika) :=
 [("r1",phassa),("r2",vitakka),("r3",vicara),("r4",adhimokkha),("r5",viriya),("r6",piti),("r7",chanda),("r8",moha),("r9",lobha),("r10",ditthi),("r11",mana),("r12",dosa),("r13",thina),("r14",vicikiccha),("r15",saddha),("r16",sammavaca),("r17",karuna),("r18",panna)]
def rows : List String :=
 [kv "g1" (toString lobhaCittas.length), kv "g2" (toString dosaCittas.length), kv "g3" (toString mohaCittas.length),
  kv "g4_bad" (toString (ahetukaVipaka false).length), kv "g4_good" (toString (ahetukaVipaka true).length),
  kv "g5" (toString ahetukaKiriya.length), kv "g6" (toString kamaSobhana.length), kv "g7" (toString rupaCittas.length), kv "g8" (toString arupaCittas.length),
  kv "g9_89" (toString (lokuttaraCittas [1]).length), kv "g9_121" (toString (lokuttaraCittas [1,2,3,4,5]).length),
  kv "mundane" (toString mundane.length),
  kv "lobha_counts" (lst (lobhaCittas.map count)), kv "dosa_counts" (lst (dosaCittas.map count)), kv "moha_counts" (lst (mohaCittas.map count)),
  kv "ahetuka_bad_counts" (lst ((ahetukaVipaka false).map count)), kv "ahetuka_good_counts" (lst ((ahetukaVipaka true).map count)), kv "ahetuka_kiriya_counts" (lst (ahetukaKiriya.map count)),
  kv "kama_counts" (lst (kamaSobhana.map count)), kv "rupa_counts" (lst (rupaCittas.map count)), kv "arupa_counts" (lst (arupaCittas.map count)),
  kv "lok89_counts" (lst ((lokuttaraCittas [1]).map count)), kv "lok121_counts" (lst ((lokuttaraCittas [1,2,3,4,5]).map count)),
  kv "keci" (toString (cittas89.filter illimitablesKeci).length),
  kv "feel_sukha" (toString (cittas121.filter (·.vedana == .sukha)).length), kv "feel_dukkha" (toString (cittas121.filter (·.vedana == .dukkha)).length),
  kv "feel_domanassa" (toString (cittas121.filter (·.vedana == .domanassa)).length), kv "feel_somanassa" (toString (cittas121.filter (·.vedana == .somanassa)).length), kv "feel_upekkha" (toString (cittas121.filter (·.vedana == .upekkha)).length),
  kv "root0" (toString (cittas89.filter (hetus · == 0)).length), kv "root1" (toString (cittas89.filter (hetus · == 1)).length), kv "root2" (toString (cittas89.filter (hetus · == 2)).length), kv "root3" (toString (cittas89.filter (hetus · == 3)).length),
  kv "class_universals" (toString universals.length), kv "class_occasionals" (toString occasionals.length), kv "class_unwholesome" (toString unwholesome.length), kv "class_beautiful_univ" (toString beautifulUniversals.length), kv "class_abstinences" (toString abstinences.length), kv "class_illimitables" (toString illimitables.length),
  kv "class_beautiful" (toString (beautifulUniversals.length + abstinences.length + illimitables.length + 1)),
  kv "canon_in_universals" (toString (canonNamed.filter universals.contains).length), kv "canon_in_occasionals" (toString (canonNamed.filter occasionals.contains).length), kv "canon_in_beautiful_univ" (toString (canonNamed.filter beautifulUniversals.contains).length),
  kv "yv_in_universals" (toString (yevapanaka.filter universals.contains).length), kv "yv_in_occasionals" (toString (yevapanaka.filter occasionals.contains).length), kv "yv_in_beautiful_univ" (toString (yevapanaka.filter beautifulUniversals.contains).length), kv "yv_in_abstinences" (toString (yevapanaka.filter abstinences.contains).length), kv "yv_in_illimitables" (toString (yevapanaka.filter illimitables.contains).length),
  kv "first_common" (toString ((all.filter (arises firstKusala)).filter (fun x => universals.contains x || occasionals.contains x)).length),
  kv "first_beautiful" (toString ((all.filter (arises firstKusala)).filter (fun x => !(universals.contains x || occasionals.contains x))).length),
  kv "key89_len" (toString key89.length), kv "key121_len" (toString key121.length),
  kv "occ89_entries" (toString occurrenceKey89.length), kv "occ121_entries" (toString occurrenceKey121.length), kv "abs89_entries" (toString absenceKey89.length), kv "abs121_entries" (toString absenceKey121.length)]
  ++ factors.map (fun (k,x) => kv (k ++ "_89") (toString (ext cittas89 x)))
  ++ factors.map (fun (k,x) => kv (k ++ "_121") (toString (ext cittas121 x)))
  ++ [kv "abs_vitakka121" (toString (121 - ext cittas121 vitakka)), kv "abs_vicara121" (toString (121 - ext cittas121 vicara)), kv "abs_piti121" (toString (121 - ext cittas121 piti)),
      kv "abs_adhimokkha89" (toString (89 - ext cittas89 adhimokkha)), kv "abs_viriya89" (toString (89 - ext cittas89 viriya)), kv "abs_chanda89" (toString (89 - ext cittas89 chanda))]
#eval IO.println ("{" ++ ", ".intercalate rows ++ "}")
end FormalAbhidhamma
