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

/-- Chapter 3's feeling counts, from the generator's own feeling axis. -/
theorem feelings121 : feelingKey121.all (fun (v, n) => (cittas121.filter (·.vedana == v)).length == n) = true := by decide
/-- Chapter 3's root counts, from the generator's root and knowledge axes. -/
theorem roots89 : rootKey89.all (fun (h, n) => (cittas89.filter (hetus · == h)).length == n) = true := by decide
/-- §30: the main reading gives the text's 28; the reading of "some" (keci) gives 20. The text's own figure
    decides between them. -/
theorem keci_reading : (cittas89.filter illimitablesKeci).length = 20 := by decide

end FormalAbhidhamma
