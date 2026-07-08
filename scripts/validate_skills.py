#!/usr/bin/env python3
"""Validate Agent Skills structure for this repository.

This intentionally stays small and dependency-light. It checks the rules from
https://agentskills.io/specification that matter most for CI:

- SKILL.md exists.
- YAML frontmatter is valid.
- name and description are present.
- name follows the Agent Skills naming rules.
- name matches the parent directory name.
- description and compatibility length limits are respected.
- metadata is a string-to-string map and includes version.
- SKILL.md stays reasonably small.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from typing import Any

import yaml

NAME_RE = re.compile(r"^[a-z0-9](?:[a-z0-9-]{0,62}[a-z0-9])?$")
VERSION_RE = re.compile(r"^v[0-9]+(?:\.[0-9]+){0,2}(?:[-+][A-Za-z0-9.-]+)?$|^dev$|^manual$")
SECRET_PATTERNS = [
    re.compile(r"-----BEGIN (?:RSA |OPENSSH |EC |DSA )?PRIVATE KEY-----"),
    re.compile(r"sk-ant-[A-Za-z0-9_-]{20,}"),
    re.compile(r"ghp_[A-Za-z0-9_]{20,}"),
    re.compile(r"github_pat_[A-Za-z0-9_]{20,}"),
]


def error(message: str) -> None:
    print(f"::error::{message}")


def warning(message: str) -> None:
    print(f"::warning::{message}")


def find_skill_files(root: Path) -> list[Path]:
    files = [root / "SKILL.md"] if (root / "SKILL.md").is_file() else []
    files.extend(sorted(root.glob("skills/*/SKILL.md")))
    return files


def split_frontmatter(path: Path) -> tuple[dict[str, Any] | None, str, list[str]]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    if not lines or lines[0].strip() != "---":
        return None, text, ["SKILL.md debe comenzar con frontmatter YAML delimitado por ---"]

    end_index = None
    for index, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end_index = index
            break

    if end_index is None:
        return None, text, ["No se ha encontrado el cierre --- del frontmatter YAML"]

    raw_yaml = "\n".join(lines[1:end_index])
    body = "\n".join(lines[end_index + 1 :])

    try:
        metadata = yaml.safe_load(raw_yaml) or {}
    except yaml.YAMLError as exc:
        return None, body, [f"Frontmatter YAML inválido: {exc}"]

    if not isinstance(metadata, dict):
        return None, body, ["El frontmatter debe ser un mapa YAML"]

    return metadata, body, []


def expected_name_for(path: Path, root: Path) -> str:
    if path.parent == root:
        return root.name
    return path.parent.name


def validate_metadata_field(frontmatter: dict[str, Any], rel: Path) -> int:
    failures = 0
    metadata = frontmatter.get("metadata")

    if metadata is None:
        error(f"{rel}: falta 'metadata.version' con valor por defecto 'v0'")
        return 1

    if not isinstance(metadata, dict):
        error(f"{rel}: 'metadata' debe ser un mapa de cadenas")
        return 1

    for key, value in metadata.items():
        if not isinstance(key, str) or not isinstance(value, str):
            error(f"{rel}: 'metadata' debe contener solo claves y valores de texto")
            failures += 1

    version = metadata.get("version")
    if not isinstance(version, str) or not version.strip():
        error(f"{rel}: falta 'metadata.version' como texto no vacío")
        failures += 1
    elif not VERSION_RE.match(version):
        warning(
            f"{rel}: 'metadata.version' tiene formato no habitual ({version!r}); "
            "se recomienda v0, v1, v1.0.0, dev o manual"
        )

    return failures


def validate_skill(path: Path, root: Path) -> int:
    failures = 0
    rel = path.relative_to(root)
    metadata, body, frontmatter_errors = split_frontmatter(path)

    for message in frontmatter_errors:
        error(f"{rel}: {message}")
        failures += 1

    if metadata is None:
        return failures

    name = metadata.get("name")
    description = metadata.get("description")
    compatibility = metadata.get("compatibility")
    allowed_tools = metadata.get("allowed-tools")

    if not isinstance(name, str) or not name.strip():
        error(f"{rel}: falta el campo obligatorio 'name'")
        failures += 1
    else:
        if len(name) > 64:
            error(f"{rel}: 'name' supera 64 caracteres")
            failures += 1
        if not NAME_RE.match(name) or "--" in name:
            error(
                f"{rel}: 'name' debe usar minúsculas, números y guiones; "
                "no puede empezar/terminar en guion ni contener --"
            )
            failures += 1
        expected = expected_name_for(path, root)
        if name != expected:
            error(f"{rel}: 'name' debe coincidir con la carpeta padre: {expected!r}")
            failures += 1

    if not isinstance(description, str) or not description.strip():
        error(f"{rel}: falta el campo obligatorio 'description'")
        failures += 1
    elif len(description) > 1024:
        error(f"{rel}: 'description' supera 1024 caracteres")
        failures += 1

    if compatibility is not None:
        if not isinstance(compatibility, str) or not compatibility.strip():
            error(f"{rel}: 'compatibility' debe ser texto no vacío si se declara")
            failures += 1
        elif len(compatibility) > 500:
            error(f"{rel}: 'compatibility' supera 500 caracteres")
            failures += 1

    if allowed_tools is not None and not isinstance(allowed_tools, str):
        error(f"{rel}: 'allowed-tools' debe ser una cadena separada por espacios")
        failures += 1

    failures += validate_metadata_field(metadata, rel)

    line_count = len(path.read_text(encoding="utf-8").splitlines())
    if line_count > 500:
        warning(f"{rel}: SKILL.md tiene {line_count} líneas; la especificación recomienda menos de 500")

    text = path.read_text(encoding="utf-8")
    for pattern in SECRET_PATTERNS:
        if pattern.search(text):
            error(f"{rel}: posible secreto detectado por patrón {pattern.pattern}")
            failures += 1

    if "../../" in body:
        warning(
            f"{rel}: contiene referencias con ../../; si se empaqueta como skill independiente, "
            "conviene hacerlas relativas a la raíz del skill"
        )

    return failures


def validate_repository(root: Path) -> int:
    failures = 0
    skill_files = find_skill_files(root)

    if not skill_files:
        error("No se ha encontrado ningún SKILL.md")
        return 1

    if not (root / "references" / "fuentes-oficiales-tributarias.md").is_file():
        warning("No existe references/fuentes-oficiales-tributarias.md")

    for path in skill_files:
        failures += validate_skill(path, root)

    if failures:
        print(f"Validación fallida: {failures} error(es)")
    else:
        print(f"Validación correcta: {len(skill_files)} skill(s) revisado(s)")

    return failures


def main() -> int:
    parser = argparse.ArgumentParser(description="Valida SKILL.md según reglas básicas de Agent Skills")
    parser.add_argument("path", nargs="?", default=".", help="Ruta del repositorio o skill")
    args = parser.parse_args()

    root = Path(args.path).resolve()
    if not root.exists():
        error(f"La ruta no existe: {root}")
        return 1

    return 1 if validate_repository(root) else 0


if __name__ == "__main__":
    sys.exit(main())
