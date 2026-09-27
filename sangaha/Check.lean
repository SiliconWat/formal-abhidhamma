import Rules
import AnswerKey
namespace FormalAbhidhamma
set_option maxRecDepth 100000

theorem n89  : cittas89.length = 89 := by decide
theorem n121 : cittas121.length = 121 := by decide
theorem distinct121 : cittas121.Nodup := by decide
theorem profile89  : cittas89.map count = key89 := by decide
theorem profile121 : cittas121.map count = key121 := by decide
theorem occurrences121 : occurrenceKey121.all (fun (x, n) => occurrences cittas121 x == n) = true := by decide
theorem occurrences89  : occurrenceKey89.all (fun (x, n) => occurrences cittas89 x == n) = true := by decide
theorem absences121 : absenceKey121.all (fun (x, n) => cittas121.length - occurrences cittas121 x == n) = true := by decide
theorem absences89  : absenceKey89.all (fun (x, n) => cittas89.length - occurrences cittas89 x == n) = true := by decide

end FormalAbhidhamma
