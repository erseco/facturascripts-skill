---
name: facturascripts-accounting-user
description: >
  Ayuda a usuarios contables a operar FacturaScripts con facturas, cobros, pagos, asientos, mayores, diario contable, subcuentas e informes. Usar cuando el usuario quiera contabilizar facturas, subir asientos, consultar mayores o extraer información contable desde FacturaScripts.
---

# FacturaScripts Accounting User

Usa este skill para flujos contables como usuario operativo.

## Leer primero

| Tarea | Referencia |
| --- | --- |
| Flujo contable/API | `../../references/accounting-api-workflows.md` |
| Modelos contables | `../../references/models.md` |
| Uso de API | `../../references/api.md` |
| Exportaciones y librerías contables | `../../references/libraries.md` |
| Fuentes oficiales tributarias | `../../references/fuentes-oficiales-tributarias.md` |

## Reglas

- Trata las escrituras contables como operaciones de alto riesgo.
- Prepara siempre un dry-run antes de crear asientos, pagos, cobros o facturas.
- No inventes subcuentas, diarios, ejercicios, códigos de impuesto, clientes, proveedores ni formas de pago.
- Valida que debe y haber cuadran antes de proponer cualquier asiento.
- Valida fecha, ejercicio y diario antes de contabilizar.
- Prefiere operaciones de negocio que generen contabilidad automáticamente antes que escribir `Asiento`/`Partida` directamente.
- Indica claramente si los datos se leen, se escriben, se simulan o se exportan.

## Prompts útiles

- Prepara un dry-run para este asiento manual y comprueba que cuadra.
- Obtén el mayor de la subcuenta 4300001 entre 2026-01-01 y 2026-03-31.
- Genera el diario contable del primer trimestre de 2026 y marca asientos descuadrados.
- Valida cobros y pagos pendientes por fecha de vencimiento.
