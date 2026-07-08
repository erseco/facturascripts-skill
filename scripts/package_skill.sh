#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-dev}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
STAGE_DIR="$(mktemp -d)"
PACKAGE_DIR="${STAGE_DIR}/facturascripts-skill"
PACKAGE_NAME="facturascripts-skill-${VERSION}.zip"

cleanup() {
  rm -rf "${STAGE_DIR}"
}
trap cleanup EXIT

cd "${ROOT_DIR}"

python scripts/validate_skills.py .

rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}" "${PACKAGE_DIR}"

copy_if_exists() {
  local source="$1"
  local target="$2"
  if [ -e "${source}" ]; then
    cp -R "${source}" "${target}"
  fi
}

copy_if_exists "SKILL.md" "${PACKAGE_DIR}/"
copy_if_exists "README.md" "${PACKAGE_DIR}/"
copy_if_exists "PROMPT_GENERADOR_SKILLS.md" "${PACKAGE_DIR}/"
copy_if_exists "references" "${PACKAGE_DIR}/"
copy_if_exists "skills" "${PACKAGE_DIR}/"

python - "${PACKAGE_DIR}" "${VERSION}" <<'PY'
from __future__ import annotations

import sys
from pathlib import Path

import yaml

package_dir = Path(sys.argv[1])
version = sys.argv[2]

for path in [package_dir / "SKILL.md", *sorted(package_dir.glob("skills/*/SKILL.md"))]:
    if not path.is_file():
        continue

    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        raise SystemExit(f"{path}: missing YAML frontmatter")

    end_index = None
    for index, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end_index = index
            break

    if end_index is None:
        raise SystemExit(f"{path}: missing YAML frontmatter terminator")

    metadata = yaml.safe_load("\n".join(lines[1:end_index])) or {}
    metadata.setdefault("metadata", {})
    metadata["metadata"]["version"] = version

    dumped = yaml.safe_dump(metadata, sort_keys=False, allow_unicode=True).strip()
    body = "\n".join(lines[end_index + 1 :]).lstrip("\n")
    path.write_text(f"---\n{dumped}\n---\n\n{body}\n", encoding="utf-8")
PY

(
  cd "${STAGE_DIR}"
  zip -r "${DIST_DIR}/${PACKAGE_NAME}" "facturascripts-skill" \
    -x '*/.DS_Store' \
    -x '*/.git/*' \
    -x '*/.github/*' \
    -x '*/dist/*' \
    -x '*/node_modules/*' \
    -x '*/.env' \
    -x '*/.env.*' \
    -x '*/__pycache__/*'
)

sha256sum "${DIST_DIR}/${PACKAGE_NAME}" > "${DIST_DIR}/${PACKAGE_NAME}.sha256"

printf 'Generated package:\n  %s\n  %s\n' \
  "${DIST_DIR}/${PACKAGE_NAME}" \
  "${DIST_DIR}/${PACKAGE_NAME}.sha256"
