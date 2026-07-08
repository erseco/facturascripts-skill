---
name: facturascripts
description: >
  Coordina conocimiento experto de FacturaScripts para desarrollo de plugins, uso de la API REST, contabilidad, IVA/IGIC,
  facturas, cobros, pagos, asientos, mayores, diario, informes e integraciones MCP/API. Usar cuando el usuario mencione
  FacturaScripts, plugins, API, FacturaCliente, FacturaProveedor, ReciboCliente, ReciboProveedor, Asiento, Partida,
  Subcuenta, diario, mayor, IVA, IGIC, facturas expedidas o facturas recibidas.
---

# Router de Skills de FacturaScripts

Este skill raíz funciona como punto de entrada compatible con el diseño original de un único skill. Para trabajo nuevo, usa la colección especializada propuesta en `PROMPT_GENERADOR_SKILLS.md` y los flujos de `references/accounting-api-workflows.md`.

Este repositorio es una evolución del skill original de FacturaScripts creado por Jose Conti. Mantén esa atribución visible en la documentación y en los archivos derivados.

## Selección del skill o referencia

Carga siempre el alcance más pequeño que resuelva la tarea antes de abrir referencias largas:

| Tarea del usuario | Leer primero |
| --- | --- |
| Crear o refactorizar plugins de FacturaScripts | `references/plugins.md`, después `references/controllers.md`, `references/models.md`, `references/views-widgets.md` |
| Crear clientes API, herramientas MCP o integraciones externas | `references/api.md`, después `references/accounting-api-workflows.md` |
| Operar FacturaScripts como usuario contable mediante API | `references/accounting-api-workflows.md`, después `references/models.md` para nombres de entidades |
| Subir facturas, registrar cobros o marcar pagos | `references/accounting-api-workflows.md`, `references/api.md` |
| Generar informes de facturas expedidas o recibidas | `references/accounting-api-workflows.md`, después descubrir recursos API o Swagger JSON |
| Consultar diario, mayor, cuentas y asientos | `references/accounting-api-workflows.md`, `references/libraries.md`, `references/models.md` |
| Razonar sobre IVA, IGIC, retenciones o inversión del sujeto pasivo | `references/accounting-api-workflows.md` y `references/fuentes-oficiales-tributarias.md` |
| Seguridad, roles o permisos de API Key | `references/security.md`, `references/api.md` |
| Entorno, pruebas, CI, previews y releases | `references/dev-tooling.md` |

## Principios de funcionamiento

1. No asumas que la instalación de FacturaScripts tiene todos los endpoints activos. Descubre recursos en `/api/3` o mediante el Swagger JSON del plugin `DocumentacionAPI` cuando exista.
2. Trata las escrituras contables como operaciones de alto riesgo. Antes de crear, actualizar, cobrar, pagar o subir asientos, prepara un dry-run salvo que el usuario haya autorizado la ejecución de forma explícita e inequívoca.
3. No inventes códigos de cuenta, tipos fiscales, ejercicios, clientes, proveedores, series, almacenes, formas de pago ni impuestos. Consulta la instalación o pide el dato.
4. Para IVA e IGIC, separa mecánica contable de asesoramiento fiscal. Valida tipos, exenciones, inversión del sujeto pasivo, recargos y reglas canarias con fuentes oficiales actualizadas.
5. En informes, indica origen de datos, filtros, periodo, divisa, régimen fiscal y si los importes son base, cuota, retención, cobrado/pagado, pendiente o total.
6. Para llamadas API de creación/actualización, prefiere payload `application/x-www-form-urlencoded` salvo que el endpoint o Swagger indique otra cosa.
7. Para CRUD de modelos, verifica nombres de campos antes de componer filtros o payloads.
8. Para código, sigue el estilo de FacturaScripts y del plugin objetivo. No modifiques el core: usa plugins, extensiones, controladores, modelos, XMLView, workers y endpoints API.

## Base de API de FacturaScripts

- Ruta base: `/api/3`.
- Autenticación habitual: API Key en la cabecera `Token`, o el modo documentado por la instalación.
- Controles habituales de consulta: `limit`, `offset`, `filter[campo]`, operadores como `_gt`, `_gte`, `_lt`, `_lte`, `_neq`, `_like` y `sort[campo]=ASC|DESC`.
- Endpoints frecuentes, si están disponibles: `crearFacturaCliente`, `crearFacturaProveedor`, `pagarFacturaCliente/{id}` y `pagarFacturaProveedor/{id}`.
- Algunos endpoints de exportación pueden devolver PDF/XLS/CSV, por ejemplo `exportarFacturaCliente/{id}?type=CSV` si está habilitado.

## Colección especializada recomendada

La colección final debe mantenerse como carpetas separadas, cada una con su propio `SKILL.md` y una descripción precisa:

1. `facturascripts-developer`: desarrollo de plugins, API, MCP, CI y releases.
2. `facturascripts-api-user`: uso operativo seguro de la API REST.
3. `facturascripts-accounting-user`: facturas, asientos, cobros, pagos, diario, mayores e informes.
4. `facturascripts-tax-iva-igic`: validación de IVA, IGIC, retenciones y casuística fiscal española/canaria.
5. `facturascripts-reporting`: informes de facturas expedidas, recibidas, vencimientos, diario y mayor.

Usa `PROMPT_GENERADOR_SKILLS.md` para generar o ampliar la colección completa.

## Checklist de verificación

Antes de devolver una respuesta final o confirmar cambios:

- La descripción del skill indica qué hace y cuándo debe usarse.
- `SKILL.md` se mantiene breve y delega en referencias.
- Los ejemplos son concretos y ejecutables.
- Las operaciones contables incluyen dry-run, validación y notas de reversión cuando sea posible.
- El README incluye instalación y uso.
- Las fuentes tributarias oficiales están enlazadas en `references/fuentes-oficiales-tributarias.md`.
