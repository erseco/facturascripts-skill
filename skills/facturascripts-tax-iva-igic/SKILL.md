---
name: facturascripts-tax-iva-igic
description: >
  Ayuda a validar IVA, IGIC, retenciones, exenciones, inversión del sujeto pasivo, facturas expedidas y facturas recibidas en FacturaScripts sin sustituir asesoramiento fiscal. Usar cuando el usuario pregunte por IVA español, IGIC canario, desglose de impuestos o validación fiscal dentro de FacturaScripts.
metadata:
  version: "v0"
---

# FacturaScripts Tax IVA/IGIC

Usa este skill para razonar sobre datos fiscales en FacturaScripts. No sustituye a una asesoría fiscal.

## Leer primero

| Tarea | Referencia |
| --- | --- |
| Comprobaciones fiscales en flujos contables | `../../references/accounting-api-workflows.md` |
| Modelos de impuestos y facturas | `../../references/models.md` |
| Fuentes oficiales | `../../references/fuentes-oficiales-tributarias.md` |

## Reglas

- No fijes tipos fiscales vigentes sin verificarlos contra una fuente oficial e indicar la fecha de comprobación.
- Pregunta por territorio cuando falte: Península/Baleares, Canarias, Ceuta/Melilla, UE o terceros países.
- No trates el IGIC como “IVA con otro porcentaje”.
- Distingue operación sujeta, exenta, no sujeta, inversión del sujeto pasivo, retención y cuota deducible.
- Separa mecánica contable de asesoramiento fiscal.
- Para declaraciones, libros oficiales o decisiones fiscalmente sensibles, exige revisión por asesoría fiscal.

## Prompts útiles

- Comprueba si esta factura parece de IVA o IGIC y qué datos faltan.
- Valida los desgloses fiscales de facturas expedidas del primer trimestre.
- Revisa facturas recibidas y separa cuota soportada de cuota deducible si los datos lo permiten.
- Marca posibles casos de inversión del sujeto pasivo sin hacer una conclusión fiscal definitiva.
