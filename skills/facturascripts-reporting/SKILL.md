---
name: facturascripts-reporting
description: >
  Ayuda a generar informes reproducibles de FacturaScripts sobre facturas expedidas, facturas recibidas, cobros, pagos, diario contable, mayores, vencimientos y exportaciones. Usar cuando el usuario pida informes contables, de facturación o de tesorería a partir de datos de FacturaScripts.
metadata:
  version: "v0"
---

# FacturaScripts Reporting

Usa este skill para informes y exportaciones basadas en datos de FacturaScripts.

## Leer primero

| Tarea | Referencia |
| --- | --- |
| Flujo de informes | `../../references/accounting-api-workflows.md` |
| Filtros y paginación API | `../../references/api.md` |
| Modelos y relaciones | `../../references/models.md` |
| Librerías de exportación | `../../references/libraries.md` |
| Fuentes oficiales tributarias | `../../references/fuentes-oficiales-tributarias.md` |

## Reglas

- Todo informe debe indicar periodo, filtros, recursos origen y fecha de generación.
- Separa base imponible, cuota, retención, total, importe cobrado/pagado e importe pendiente.
- Pagina las consultas API.
- No ocultes registros excluidos: informa exclusiones y supuestos.
- Valida totales contra líneas o cabeceras del documento cuando sea posible.
- En informes contables, marca asientos descuadrados.

## Prompts útiles

- Genera un informe de facturas expedidas del primer trimestre de 2026 agrupado por cliente y código de impuesto.
- Genera un informe de facturas recibidas por proveedor con totales pagados y pendientes.
- Exporta el diario contable de marzo de 2026 como CSV.
- Crea un informe de mayor con saldo inicial, movimientos y saldo final.
