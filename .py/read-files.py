#!/usr/bin/env python3
"""
export_sources_for_gpt.py

Varre um projeto de software e exporta um único arquivo de texto contendo
os arquivos-fonte mais relevantes, em blocos com cercas de código.


Uso:
  python3 export_sources_for_gpt.py -o sources_for_gpt.txt

"""

from pathlib import Path
import argparse
import fnmatch
import os
from datetime import datetime
import sys

DEFAULT_ROOTS = [".", "./infra", "./docs", "./backend", "./frontend"]
DEFAULT_PATTERNS = [
    "*.sql",
    "*.yaml",
    "*.yml",     # pode desativar com --no-yml
    "*.py",
    "Makefile",
    ".env",
    "",
    "",     
]

EXCLUDE_DIRS = {
    ".git", ".hg", ".svn", ".idea", ".vscode", "__pycache__", "node_modules",
    "vendor", "dist", "build", "out", "target", ".cache", ".mypy_cache",
    "bazel-bin", "bazel-out", "bazel-testlogs", ".terraform", ".venv", "venv", ".py"
}

LANG_BY_EXT = {
    ".sql": "sql",
    ".py": "python",
    ".yaml": "yaml",
    ".yml": "yaml",
}
LANG_BY_BASENAME = {
    "makefile": "makefile",
}

def parse_args():
    p = argparse.ArgumentParser(description="Exportar fontes para um único .txt amigável ao GPT.")
    p.add_argument("-o", "--out", default="sources_for_gpt.txt", help="arquivo de saída (txt)")
    p.add_argument("--roots", nargs="*", default=DEFAULT_ROOTS, help="diretórios a varrer")
    p.add_argument("--max-bytes", type=int, default=0, help="limite por arquivo (0 = sem limite)")
    p.add_argument("--no-yml", action="store_true", help="não incluir *.yml")
    p.add_argument("--quiet", action="store_true", help="menos logs")
    return p.parse_args()

def build_patterns(args):
    patterns = list(DEFAULT_PATTERNS)
    if args.no_yml:
        patterns = [p for p in patterns if p != "*.yml"]
    return patterns

def matches_any_pattern(name: str, patterns) -> bool:
    for pat in patterns:
        if fnmatch.fnmatch(name, pat):
            return True
    return False

def detect_lang(path: Path) -> str:
    base = path.name.lower()
    if base in LANG_BY_BASENAME:
        return LANG_BY_BASENAME[base]
    if base in ("go.mod", "go.sum"):
        return ""  # sem linguagem específica
    return LANG_BY_EXT.get(path.suffix.lower(), "")

def iter_source_files(roots, patterns, quiet=False):
    seen = set()
    cwd = Path.cwd()
    for root in roots:
        root_path = Path(root)
        if not root_path.exists():
            if not quiet:
                print(f"[aviso] diretório inexistente ignorado: {root}", file=sys.stderr)
            continue
        for dirpath, dirnames, filenames in os.walk(root_path, followlinks=False):
            # poda de diretórios
            dirnames[:] = [
                d for d in dirnames
                if d not in EXCLUDE_DIRS and not d.startswith(".bazel")
            ]
            for fname in filenames:
                rel_path = Path(dirpath, fname)
                rel = os.path.relpath(rel_path, start=cwd)
                # dedup por caminho relativo (evita duplicar entre "." e "./api", por ex.)
                if rel in seen:
                    continue
                if matches_any_pattern(rel_path.name, patterns):
                    seen.add(rel)
                    yield Path(rel)

def write_block(out_fh, file_path: Path, lang: str, max_bytes: int):
    rel = str(file_path)
    try:
        size = file_path.stat().st_size
    except FileNotFoundError:
        size = -1

    out_fh.write(f"\n===== FILE: {rel} =====\n")
    if size >= 0:
        out_fh.write(f"# size: {size} bytes\n")
    out_fh.write("```" + (lang if lang else "") + "\n")

    try:
        with open(file_path, "r", encoding="utf-8", errors="replace") as fh:
            if max_bytes and max_bytes > 0:
                chunk = fh.read(max_bytes)
                out_fh.write(chunk)
                if len(chunk.encode("utf-8", errors="ignore")) >= max_bytes:
                    out_fh.write("\n# [TRUNCATED]\n")
            else:
                out_fh.write(fh.read())
    except Exception as e:
        out_fh.write(f"# [ERRO AO LER ARQUIVO] {e}\n")

    out_fh.write("\n```\n")

def main():
    args = parse_args()
    patterns = build_patterns(args)

    files = sorted(
        iter_source_files(args.roots, patterns, quiet=args.quiet),
        key=lambda p: str(p).lower()
    )

    with open(args.out, "w", encoding="utf-8") as out:
        out.write("# Sources export for GPT\n")
        out.write(f"# generated_at: {datetime.now().isoformat(timespec='seconds')}\n")
        out.write(f"# roots: {', '.join(args.roots)}\n")
        out.write(f"# patterns: {', '.join(patterns)}\n")
        out.write(f"# excluded_dirs: {', '.join(sorted(EXCLUDE_DIRS))}\n")
        out.write("\n")

        for fp in files:
            lang = detect_lang(fp)
            write_block(out, fp, lang, args.max_bytes)

        out.write(f"\n# total_files: {len(files)}\n")

    if not args.quiet:
        print(f"[ok] export concluído: {args.out} ({len(files)} arquivos)", file=sys.stderr)

if __name__ == "__main__":
    main()

