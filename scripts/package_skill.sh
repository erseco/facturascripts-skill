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
