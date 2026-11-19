"""stamped.py — write a GENERATED file that may carry an OpenTimestamps proof, without ever leaving the proof attesting old text.

`ots stamp` overwrites a proof, and the weekly job stamps only files that have none, so a regenerated file would keep a proof of its
superseded text until a person rotated it by hand (TIMESTAMPS.md). write_rotating() does the rotation as part of the write: if the file
exists, its text changes, and `<file>.ots` exists, the proof moves to the next free `<file>.rN.ots` and a row is appended to TIMESTAMPS.md's
rotation log. The weekly job then stamps the new text. (Founder 2026-11-19: "yes", matika/ is stamped; this makes the rule a property of
the generators rather than a step to remember.)
"""
import datetime, os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOG = os.path.join(REPO, "TIMESTAMPS.md")


def write_rotating(path, text, why):
    """Write `text` to `path`. Returns the rotated proof's repo-relative path, or None if no proof was rotated."""
    old = open(path, encoding="utf-8").read() if os.path.exists(path) else None
    rotated = None
    if old is not None and old != text and os.path.exists(path + ".ots"):
        n = 1
        while os.path.exists(f"{path}.r{n}.ots"):
            n += 1
        os.rename(path + ".ots", f"{path}.r{n}.ots")
        rotated = os.path.relpath(f"{path}.r{n}.ots", REPO)
        row = f"| {datetime.date.today().isoformat()} | `{os.path.relpath(path, REPO)}` | `{rotated}` | {why} |\n"
        with open(LOG, "a", encoding="utf-8") as f:
            f.write(row)
    if old != text:
        with open(path, "w", encoding="utf-8") as f:
            f.write(text)
    return rotated
