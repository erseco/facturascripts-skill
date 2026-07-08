# Colección de Skills para FacturaScripts

Colección de skills en español para trabajar con FacturaScripts desde dos perspectivas complementarias:

- **Desarrollo**: plugins, modelos, controladores, XMLView, API REST, MCP, pruebas, CI y publicación.
- **Uso contable y operativo**: facturación, cobros, pagos, asientos, diario, mayores, informes de facturas expedidas y recibidas, IVA e IGIC.

Este repositorio es una **evolución del skill original de Jose Conti** para FacturaScripts, publicado originalmente en `joseconti/facturascripts-skill`, y mantiene esa atribución como base del trabajo.

## Especificación seguida

Esta colección sigue la especificación de **Agent Skills** documentada en <https://agentskills.io/specification>:

- Un skill es una carpeta que contiene, como mínimo, un archivo `SKILL.md`.
- `SKILL.md` debe tener frontmatter YAML seguido de contenido Markdown.
- Los campos obligatorios son `name` y `description`.
- `name` debe tener como máximo 64 caracteres, usar minúsculas, números y guiones, no empezar ni terminar en guion, no contener `--` y coincidir con el nombre de la carpeta padre.
- `description` debe tener entre 1 y 1024 caracteres y explicar qué hace el skill y cuándo debe usarse.
- `scripts/`, `references/` y `assets/` son directorios opcionales para carga progresiva.
- Conviene mantener `SKILL.md` por debajo de 500 líneas y mover detalle a `references/`.

Por esa razón el skill raíz usa `name: facturascripts-skill`, coincidiendo con el nombre del repositorio/carpeta cuando se clona como `facturascripts-skill`.

## Idioma y público objetivo

El público principal es hispanohablante y, en especial, usuarios y desarrolladores que trabajan con contabilidad española, IVA e IGIC. Por eso:

- La documentación operativa debe estar en español.
- Los nombres técnicos se mantienen cuando son nombres reales de FacturaScripts, rutas, clases, endpoints o archivos: `SKILL.md`, `XMLView`, `FacturaCliente`, `/api/3`, `Token`.
- Los ejemplos de uso deben estar en español.
- El código, cuando se genere para plugins, puede mantenerse en inglés si el proyecto lo requiere, pero la explicación al usuario debe estar en español.

## Organización recomendada de la colección

La colección final debería organizarse en skills pequeños, autocontenidos y especializados:

| Skill | Uso principal |
| --- | --- |
| `facturascripts-developer` | Crear, modificar, probar y publicar plugins de FacturaScripts. |
| `facturascripts-api-user` | Usar la API REST de FacturaScripts de forma segura como usuario operativo. |
| `facturascripts-accounting-user` | Contabilizar facturas, asientos, cobros, pagos, diario y mayores. |
| `facturascripts-tax-iva-igic` | Validar operaciones con IVA, IGIC, retenciones, exenciones e inversión del sujeto pasivo. |
| `facturascripts-reporting` | Generar informes de facturas expedidas, recibidas, cobros, pagos, diario y mayor. |

La estructura actual mantiene el skill raíz para compatibilidad y usa `PROMPT_GENERADOR_SKILLS.md` como especificación de generación de la colección completa.

## Instalación

### Opción A: usar el repositorio como skill único

Clona el repositorio:

```bash
git clone https://github.com/erseco/facturascripts-skill.git
cd facturascripts-skill
```

Usa la carpeta completa como skill, ya que contiene `SKILL.md` en la raíz y las referencias en `references/`.

### Opción B: descargar el ZIP de una release

Cuando se publique un tag `v*`, el workflow de release genera:

```text
facturascripts-skill-<tag>.zip
facturascripts-skill-<tag>.zip.sha256
```

Por ejemplo:

```text
facturascripts-skill-v1.zip
facturascripts-skill-v1.zip.sha256
```

Descarga el ZIP desde la última release y súbelo como skill en el cliente compatible que uses. Se usa `.zip` porque la especificación de Agent Skills define una carpeta con `SKILL.md`; no define una extensión `.skill` obligatoria.

### Opción C: instalarlo en Claude Code

En Claude Code, copia o enlaza la carpeta del skill dentro del directorio de skills que uses para tu proyecto o entorno. La carpeta debe contener:

```text
facturascripts-skill/
  SKILL.md
  README.md
  references/
  skills/
  PROMPT_GENERADOR_SKILLS.md
```

Después abre Claude Code en un proyecto relacionado con FacturaScripts y pide una tarea que active el skill, por ejemplo:

```text
Usa el skill de FacturaScripts para crear un plugin que añada un informe de facturas recibidas por proveedor.
```

### Opción D: instalarlo en Claude.ai

Crea un ZIP con la carpeta del skill:

```bash
bash scripts/package_skill.sh dev
```

O descarga el ZIP generado en una release. Después súbelo desde la configuración de Skills de Claude.ai.

### Opción E: usarlo como especificación para generar nuevos skills

Usa `PROMPT_GENERADOR_SKILLS.md` como prompt principal en una IA con capacidad multiagente o en un entorno de generación asistida. El objetivo de ese prompt es producir la colección final de skills, referencias, tests/evals, README y empaquetado.

## Preparar FacturaScripts para uso con API

1. Entra en FacturaScripts como administrador.
2. Activa la API desde el panel de administración si no está activa.
3. Crea una API Key con los permisos mínimos necesarios.
4. Usa la cabecera HTTP `Token` para autenticar llamadas a `/api/3`.
5. Para descubrir endpoints, instala o activa el plugin `DocumentacionAPI` si necesitas Swagger/OpenAPI.
6. No uses una clave con permisos de escritura para informes de solo lectura.
7. No pegues claves API en prompts, commits, issues o PRs.

Ejemplo de comprobación básica:

```bash
export FACTURASCRIPTS_URL="https://facturascripts.example.com"
export FACTURASCRIPTS_TOKEN="replace-with-your-token"

curl -sS \
  -H "Token: ${FACTURASCRIPTS_TOKEN}" \
  "${FACTURASCRIPTS_URL}/api/3"
```

## Cómo usarlo

### Como desarrollador

```text
Usa el skill de FacturaScripts para crear un plugin llamado AccountingReports que añada un ReportController con filtro por ejercicio, proveedor y rango de fechas.
```

```text
Revisa este controlador de FacturaScripts y dime si respeta el patrón de ListController, permisos, traducciones y XMLView.
```

```text
Diseña un MCP Server para consultar facturas expedidas, facturas recibidas, mayores y diario usando la API de FacturaScripts.
```

### Como usuario contable vía API

```text
Consulta las facturas expedidas entre el 1 de enero y el 31 de marzo de 2026, agrupa por cliente y separa base, impuesto, retención, total, cobrado y pendiente.
```

```text
Prepara un dry-run para contabilizar este asiento manual. No lo subas hasta que confirme. Debe cuadrar debe y haber y usar subcuentas existentes.
```

```text
Obtén el mayor de la subcuenta 4300001 para 2026 con saldo inicial, movimientos y saldo acumulado.
```

```text
Marca como pagada esta factura de proveedor con fecha de pago 2026-02-15 y forma de pago transferencia, pero primero valida que la factura exista, que el ejercicio esté abierto y que la forma de pago sea válida.
```

## Validación en CI

El repositorio incluye un validador mínimo en `scripts/validate_skills.py` y un workflow en `.github/workflows/validate-skills.yml`.

La validación comprueba:

- presencia de `SKILL.md`;
- frontmatter YAML válido;
- campos obligatorios `name` y `description`;
- formato de `name` según Agent Skills;
- coincidencia entre `name` y carpeta padre;
- límite de 1024 caracteres para `description`;
- límite de 500 caracteres para `compatibility`, si existe;
- tipo correcto de `allowed-tools`, si existe;
- aviso si un `SKILL.md` supera 500 líneas;
- detección básica de secretos evidentes.

Ejecución local:

```bash
python -m pip install pyyaml
python scripts/validate_skills.py .
```

## Releases y versionado

El workflow `.github/workflows/release.yml` se ejecuta al publicar un tag `v*`:

```bash
git tag v1
git push origin v1
```

También admite versionado semántico:

```bash
git tag v1.0.0
git push origin v1.0.0
```

La convención `v0`, `v1`, `v2` es válida si quieres releases simples. Si más adelante necesitas parches, puedes pasar a `v1.0.0`, `v1.0.1`, etc.

El workflow:

1. valida los skills;
2. genera `dist/facturascripts-skill-<tag>.zip`;
3. genera `dist/facturascripts-skill-<tag>.zip.sha256`;
4. sube ambos como artefactos;
5. si el evento viene de un tag, los adjunta a la GitHub Release.

## Fuentes oficiales tributarias enlazadas

Los skills no deben inventar tipos fiscales, plazos ni obligaciones formales. Para operaciones con IVA, IGIC, SII, libros registro o VERI*FACTU, consulta `references/fuentes-oficiales-tributarias.md`, que enlaza, entre otras fuentes:

- Portal de IVA de la AEAT: https://sede.agenciatributaria.gob.es/Sede/iva.html
- Facturación y Registro de la AEAT: https://sede.agenciatributaria.gob.es/Sede/iva/facturacion-registro.html
- SII de IVA de la AEAT: https://sede.agenciatributaria.gob.es/Sede/iva/suministro-inmediato-informacion.html
- Manual práctico IVA 2025 de la AEAT: https://sede.agenciatributaria.gob.es/Sede/ayuda/25manual/IVA.html
- VERI*FACTU y SIF de la AEAT: https://sede.agenciatributaria.gob.es/Sede/iva/sistemas-informaticos-facturacion-verifactu.html
- Agencia Tributaria Canaria: https://www3.gobiernodecanarias.org/tributos/atc/
- Sede electrónica de la Agencia Tributaria Canaria: https://sede.gobiernodecanarias.org/tributos/
- SII del IGIC: https://www3.gobiernodecanarias.org/tributos/atc/web/agencia-tributaria-canaria/w/suministro-inmediato-de-informacion-del-igic-sii-1?ida=170056&prnt=948
- Ley 37/1992 del IVA: https://www.boe.es/buscar/act.php?id=BOE-A-1992-28740
- Ley 20/1991 del REF de Canarias e IGIC: https://www.boe.es/buscar/act.php?id=BOE-A-1991-14463
- Reglamento de facturación: https://www.boe.es/buscar/act.php?id=BOE-A-2012-14696

## Principios de seguridad contable

- Toda operación de escritura debe tener **dry-run** previo.
- No se deben inventar subcuentas, clientes, proveedores, series, formas de pago, códigos de impuesto ni tipos fiscales.
- En asientos manuales, el debe y el haber deben cuadrar antes de proponer una llamada API.
- En IVA/IGIC, hay que distinguir territorio, naturaleza de la operación, exención, inversión del sujeto pasivo, retención y deducibilidad.
- Las reglas fiscales cambian. El skill debe verificar fuentes oficiales cuando el resultado dependa de normativa vigente.
- Los informes deben indicar periodo, filtros, fuente de datos y si los totales son base, cuota, retención, total, cobrado o pendiente.

## Referencias incluidas

| Archivo | Contenido |
| --- | --- |
| `SKILL.md` | Router raíz para activar la experiencia FacturaScripts. |
| `PROMPT_GENERADOR_SKILLS.md` | Prompt maestro en español para generar la colección completa de skills. |
| `references/accounting-api-workflows.md` | Flujos de API y contabilidad para usuario operativo. |
| `references/fuentes-oficiales-tributarias.md` | Enlaces oficiales de AEAT, Agencia Tributaria Canaria, BOE y BOC. |
| `references/api.md` | API REST, filtros, autenticación, recursos y MCP. |
| `references/plugins.md` | Desarrollo de plugins. |
| `references/models.md` | Modelos principales: facturas, asientos, partidas, subcuentas, impuestos, pagos y cobros. |
| `references/controllers.md` | Controladores base, ListController, EditController, PanelController y ReportController. |
| `references/views-widgets.md` | XMLView, widgets y Twig. |
| `references/security.md` | Roles, permisos, API keys y seguridad. |
| `references/dev-tooling.md` | Entorno, pruebas, previews y releases. |

## Generar la colección multi-skill

Ejecuta una IA generadora con este prompt:

```text
Lee PROMPT_GENERADOR_SKILLS.md y genera la colección completa de skills de FacturaScripts siguiendo sus criterios de aceptación.
```

La salida esperada debe incluir:

```text
skills/
  facturascripts-developer/
    SKILL.md
    references/
  facturascripts-api-user/
    SKILL.md
    references/
  facturascripts-accounting-user/
    SKILL.md
    references/
  facturascripts-tax-iva-igic/
    SKILL.md
    references/
  facturascripts-reporting/
    SKILL.md
    references/
evals/
scripts/
README.md
```

## Desarrollo y contribución

Flujo recomendado:

```bash
git checkout devel
git pull
git checkout -b feat/mi-cambio
# modificar SKILL.md, README.md, references/ y skills/
python scripts/validate_skills.py .
git add .
git commit -m "Describe el cambio"
git push -u origin feat/mi-cambio
```

Abre un PR contra `devel` con resumen de cambios, fuentes revisadas y checklist de validación.

## Atribución

Este trabajo parte del skill original de **Jose Conti** para FacturaScripts y lo reorganiza como una colección especializada orientada a desarrollo, API y uso contable.

## Licencia

Este repositorio documenta y organiza conocimiento técnico alrededor de FacturaScripts. Revisa la licencia del repositorio y la licencia LGPL v3 del proyecto FacturaScripts para el código fuente original del ERP.
