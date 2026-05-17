#!/usr/bin/env python3
"""Check that all Lua language files contain the same string IDs.

- `en.lua` is treated as the reference.
- Other language files must contain *every* reference key either as an active
  entry (`HR_FOO = "...",`) or commented out (`--HR_FOO = "...",`).

Exit code:
  0 = OK
  1 = Missing keys found
  2 = Script error / invalid input
"""

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Optional, Set, Tuple


KEY_RE = re.compile(r"^\s*(?:--\s*)?(HR_[A-Z0-9_]+)\s*=", re.MULTILINE)


class ParseError(RuntimeError):
    pass


def _extract_strings_table(lua_text: str, source: Path) -> str:
    """Return the raw substring inside the `local strings = { ... }` table."""

    # Find `local strings = {`
    m = re.search(r"\blocal\s+strings\s*=", lua_text)
    if not m:
        raise ParseError(f"{source.name}: couldn't find `local strings =`")

    # Find first '{' after that.
    start = lua_text.find("{", m.end())
    if start == -1:
        raise ParseError(f"{source.name}: couldn't find '{{' after `local strings =`")

    i = start
    depth = 0

    in_quote: Optional[str] = None  # ' or "
    in_long_string = False  # [[ ... ]]
    in_line_comment = False
    in_block_comment = False  # --[[ ... ]]

    def peek(offset: int = 0) -> str:
        j = i + offset
        return lua_text[j] if 0 <= j < len(lua_text) else ""

    while i < len(lua_text):
        ch = lua_text[i]

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
            i += 1
            continue

        if in_block_comment:
            if ch == "]" and peek(1) == "]":
                in_block_comment = False
                i += 2
            else:
                i += 1
            continue

        if in_quote is not None:
            if ch == "\\":
                # Skip escaped char
                i += 2
                continue
            if ch == in_quote:
                in_quote = None
            i += 1
            continue

        if in_long_string:
            if ch == "]" and peek(1) == "]":
                in_long_string = False
                i += 2
            else:
                i += 1
            continue

        # Not in any string/comment
        if ch == "-" and peek(1) == "-":
            # comment start
            if peek(2) == "[" and peek(3) == "[":
                in_block_comment = True
                i += 4
            else:
                in_line_comment = True
                i += 2
            continue

        if ch in ("'", '"'):
            in_quote = ch
            i += 1
            continue

        if ch == "[" and peek(1) == "[":
            in_long_string = True
            i += 2
            continue

        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                # Return inside braces
                return lua_text[start + 1 : i]

        i += 1

    raise ParseError(f"{source.name}: couldn't find matching '}}' for strings table")


def extract_keys(source: Path) -> Set[str]:
    text = source.read_text(encoding="utf-8-sig")
    table = _extract_strings_table(text, source)
    return set(KEY_RE.findall(table))


@dataclass(frozen=True)
class FileReport:
    file: Path
    missing: Tuple[str, ...]
    extra: Tuple[str, ...]

    @property
    def ok(self) -> bool:
        return not self.missing


def check(lang_dir: Path, ref_file: Path) -> Tuple[Set[str], List[FileReport]]:
    ref_keys = extract_keys(ref_file)
    if not ref_keys:
        raise ParseError(f"{ref_file.name}: reference key set is empty")

    reports: List[FileReport] = []

    for f in sorted(lang_dir.glob("*.lua")):
        if f.name == ref_file.name:
            continue
        keys = extract_keys(f)
        missing = tuple(sorted(ref_keys - keys))
        extra = tuple(sorted(keys - ref_keys))
        reports.append(FileReport(file=f, missing=missing, extra=extra))

    return ref_keys, reports


def _print_report(ref_file: Path, ref_keys: Iterable[str], reports: List[FileReport]) -> int:
    ref_keys = sorted(set(ref_keys))
    print(f"Reference: {ref_file.name} ({len(ref_keys)} keys)")

    missing_any = False
    for r in reports:
        status = "OK" if r.ok else "MISSING"
        print(f"\n{r.file.name}: {status}")

        if r.missing:
            missing_any = True
            print(f"  Missing ({len(r.missing)}):")
            for k in r.missing:
                print(f"    - {k}")

        if r.extra:
            print(f"  Extra (not in {ref_file.name}) ({len(r.extra)}):")
            for k in r.extra:
                print(f"    + {k}")

    return 1 if missing_any else 0


def main(argv: List[str]) -> int:
    parser = argparse.ArgumentParser(description="Check that all /lang/*.lua files contain the same string keys.")
    parser.add_argument(
        "--lang-dir",
        type=Path,
        default=Path(__file__).resolve().parent / "lang",
        help="Path to the lang folder (default: ./lang next to this script)",
    )
    parser.add_argument(
        "--ref",
        type=str,
        default="en.lua",
        help="Reference language file name (default: en.lua)",
    )
    args = parser.parse_args(argv)

    lang_dir = args.lang_dir  # type: Path
    if not lang_dir.exists() or not lang_dir.is_dir():
        print(f"ERROR: lang dir not found: {lang_dir}", file=sys.stderr)
        return 2

    ref_file = lang_dir / args.ref
    if not ref_file.exists():
        print(f"ERROR: reference file not found: {ref_file}", file=sys.stderr)
        return 2

    try:
        ref_keys, reports = check(lang_dir=lang_dir, ref_file=ref_file)
    except ParseError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 2

    return _print_report(ref_file=ref_file, ref_keys=ref_keys, reports=reports)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))



