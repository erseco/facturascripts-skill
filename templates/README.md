# Plantillas listas para copiar

Archivos reutilizables para el ecosistema de desarrollo de plugins de FacturaScripts.
La explicacion detallada de cada herramienta esta en
[`../references/dev-tooling.md`](../references/dev-tooling.md).

| Archivo | Para que sirve |
| --- | --- |
| `.github/workflows/ci.yml` | CI: entorno Docker + matriz de PHP. Reemplaza `PluginTemplate` por tu plugin. |
| `.github/workflows/pr-preview.yml` | Comenta en cada PR un enlace para probar la rama en el Playground. |
| `.github/workflows/release.yml` | Empaqueta el ZIP, crea la GitHub Release y publica en la forja. |
| `blueprint.json` | Configuracion del Playground para probar el plugin (plugins, install, seed, settings). |
| `scripts/rename-plugin.sh` | Renombra `PluginTemplate` al nombre real en todos los ficheros. |

## Uso rapido

1. Crea tu repo desde `erseco/facturascripts-plugin-template`.
2. Copia estos archivos a la raiz del plugin (los workflows van en `.github/workflows/`).
3. Renombra el plugin:
   ```sh
   sh scripts/rename-plugin.sh MiPlugin
   ```
4. Edita `blueprint.json` con la URL de tu repo y los datos demo que quieras.
5. En `release.yml`, ajusta `plugin-slug` al slug del plugin en la forja y define
   los secrets `FS_FORJA_USER` y `FS_FORJA_PASSWORD`.

## Recordatorios

- **Versiones de la forja**: enteros (`7`) o decimales simples (`7.1`). Los tags
  `1.2.3` o `1.0-beta` no son validos.
- **Tres nombres que deben coincidir** (sensible a mayusculas): carpeta raiz del ZIP,
  `name` en `facturascripts.ini` y nombre registrado en la forja.
- **Permisos del PR preview**: el workflow necesita `pull-requests: write`.
