#!/usr/bin/env sh
# Renombra un plugin creado desde facturascripts-plugin-template.
#
# Sustituye "PluginTemplate" por el nuevo nombre en todos los sitios donde la
# plantilla lo deja hardcodeado: facturascripts.ini, namespaces PHP,
# docker-compose.yml, Makefile y los workflows de .github.
#
# Uso:
#   sh rename-plugin.sh MiPlugin
#
# Tras ejecutarlo, revisa:
#   - .github/workflows/release.yml -> plugin-slug (slug en la forja, minusculas)
#   - facturascripts.ini -> description, version
#   - README / cabeceras de licencia
set -eu

NEW_NAME="${1:-}"
OLD_NAME="PluginTemplate"

if [ -z "$NEW_NAME" ]; then
  echo "Uso: sh rename-plugin.sh <NuevoNombre>" >&2
  exit 1
fi

# slug en minusculas para la forja (por defecto, el nombre en minusculas)
NEW_SLUG="$(printf '%s' "$NEW_NAME" | tr '[:upper:]' '[:lower:]')"
OLD_SLUG="$(printf '%s' "$OLD_NAME" | tr '[:upper:]' '[:lower:]')"

# sed -i portable (BSD/macOS necesita argumento de sufijo)
if sed --version >/dev/null 2>&1; then
  SED_INPLACE() { sed -i "$@"; }
else
  SED_INPLACE() { sed -i '' "$@"; }
fi

echo "Renombrando '$OLD_NAME' -> '$NEW_NAME' (slug: $NEW_SLUG)..."

# Sustituye el nombre PascalCase en todos los ficheros de texto versionados.
find . -type f \
  ! -path './.git/*' \
  ! -path './dist/*' \
  ! -path './vendor/*' \
  ! -path './node_modules/*' \
  -print | while IFS= read -r file; do
    if grep -Iq "$OLD_NAME" "$file" 2>/dev/null; then
      SED_INPLACE "s/$OLD_NAME/$NEW_NAME/g" "$file"
      echo "  actualizado: $file"
    fi
  done

# El slug en minusculas (plugin-slug de la forja) requiere una pasada aparte.
if [ -f .github/workflows/release.yml ]; then
  SED_INPLACE "s/$OLD_SLUG/$NEW_SLUG/g" .github/workflows/release.yml
fi

echo "Hecho. Revisa .github/workflows/release.yml (plugin-slug) y facturascripts.ini."
