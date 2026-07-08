# FacturaScripts Skills Collection

Colección de skills para trabajar con FacturaScripts desde dos perspectivas complementarias:

- **Desarrollo**: plugins, modelos, controladores, XMLView, API REST, MCP, pruebas, CI y publicación.
- **Uso contable y operativo**: facturación, cobros, pagos, asientos, diario, mayores, informes de facturas expedidas y recibidas, IVA e IGIC.

Este repositorio es una **evolución del skill original de Jose Conti** para FacturaScripts, publicado originalmente en `joseconti/facturascripts-skill`, y mantiene esa atribución como base del trabajo. La rama actual reorganiza el material para poder evolucionar desde un único skill generalista hacia una colección de skills especializados con carga progresiva.

## Qué cambia en esta evolución

- El `SKILL.md` raíz pasa a funcionar como **router de compatibilidad**.
- Se añade una referencia específica para **flujos contables y API**: `references/accounting-api-workflows.md`.
- Se añade un prompt maestro en español para que una IA multiagente genere una colección completa de skills: `PROMPT_GENERADOR_SKILLS.md`.
- Se documentan instrucciones de instalación y uso.
- Se separan claramente los usos de desarrollador y de usuario contable.

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

### Opción B: instalarlo en Claude Code

En Claude Code, copia o enlaza la carpeta del skill dentro del directorio de skills que uses para tu proyecto o entorno. La carpeta debe contener:

```text
facturascripts-skill/
  SKILL.md
  README.md
  references/
  PROMPT_GENERADOR_SKILLS.md
```

Después abre Claude Code en un proyecto relacionado con FacturaScripts y pide una tarea que active el skill, por ejemplo:

```text
Usa el skill de FacturaScripts para crear un plugin que añada un informe de facturas recibidas por proveedor.
```

Cuando la colección multi-skill esté generada, instala cada carpeta de `skills/<nombre-del-skill>/` como skill independiente. Cada skill debe tener su propio `SKILL.md`.

### Opción C: instalarlo en Claude.ai

Crea un ZIP con la carpeta del skill:

```bash
zip -r facturascripts-skill.zip SKILL.md README.md references PROMPT_GENERADOR_SKILLS.md
```

Después súbelo desde la configuración de Skills de Claude.ai. Si generas la colección multi-skill, crea un ZIP por cada carpeta de `skills/` o empaqueta solo el skill que quieras usar.

### Opción D: usarlo como especificación para generar nuevos skills

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

Ejemplos de peticiones:

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

Ejemplos de peticiones:

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
git checkout -b feat/accounting-api-skill-collection
# modificar SKILL.md, README.md, references/ y skills/
git add .
git commit -m "Add accounting and API skill collection plan"
git push -u origin feat/accounting-api-skill-collection
```

Abre un PR contra `devel` con resumen de cambios, fuentes revisadas y checklist de validación.

## Atribución

Este trabajo parte del skill original de **Jose Conti** para FacturaScripts y lo reorganiza como una colección especializada orientada a desarrollo, API y uso contable.

## Licencia

Este repositorio documenta y organiza conocimiento técnico alrededor de FacturaScripts. Revisa la licencia del repositorio y la licencia LGPL v3 del proyecto FacturaScripts para el código fuente original del ERP.
