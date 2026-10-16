/-
  Every number the dissertation quotes from the Lean, printed as JSON by evaluation, never typed by hand.
  `reproduce.sh` writes it to numbers.json; CI fails if numbers.json is stale.
-/
import Canon
import AnswerKey
namespace FormalAbhidhamma

#eval IO.println s!"\{\"cittas89\": {cittas89.length}, \"cittas121\": {cittas121.length}, \"cetasikas\": {all.length}, \"canon_named_first_kusala\": {canonNamed.length}, \"saṅgaha_first_kusala\": {(all.filter (arises firstKusala)).length}, \"added_by_saṅgaha\": {addedByL2.length}, \"yevāpanaka\": {yevapanaka.length}, \"profile121_matches_key\": {decide (cittas121.map count = key121)}, \"profile89_matches_key\": {decide (cittas89.map count = key89)}}"

end FormalAbhidhamma
