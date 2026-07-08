---
name: facturascripts-api-user
description: >
  Ayuda a usar la API REST de FacturaScripts de forma segura para tareas operativas: descubrimiento de recursos, filtros, paginación, facturas, cobros, pagos, exportaciones y clientes MCP/API. Usar cuando el usuario quiera consultar o actualizar datos de FacturaScripts mediante /api/3 como usuario autenticado.
metadata:
  version: "v0"
---

# FacturaScripts API User

Usa este skill para operar de forma segura con la API REST de FacturaScripts.

## Leer primero

| Tarea | Referencia |
| --- | --- |
| Base de la API | `../../references/api.md` |
| Flujos contables por API | `../../references/accounting-api-workflows.md` |
| Modelos y nombres de campos | `../../references/models.md` |
| Seguridad y API Keys | `../../references/security.md` |

## Reglas

- Descubre recursos con `/api/3` o Swagger antes de asumir nombres de endpoints.
- Usa la cabecera `Token` para autenticación por API Key cuando esté disponible.
- Usa claves de solo lectura para informes.
- Nunca imprimas ni almacenes tokens.
- Para escrituras, muestra primero endpoint, resumen del payload, validaciones y dry-run.
- Prefiere payload `application/x-www-form-urlencoded` salvo que el endpoint indique otra cosa.
- Pagina las consultas de listado y documenta los filtros usados.

## Prompts útiles

- Lista las facturas expedidas de este trimestre y agrupa totales por cliente.
- Crea un payload en dry-run para una factura de proveedor a partir de este CSV.
- Marca esta factura de cliente como cobrada después de validar recibos y forma de pago.
- Construye herramientas MCP para clientes, proveedores, facturas, cobros, pagos, diario y mayor.
