# Flujos contables y de API para FacturaScripts

Usa esta referencia cuando la tarea consista en operar FacturaScripts como usuario contable, asistente de contabilidad o agente de automatización por API: facturas, cobros, pagos, asientos, mayores, diario, informes fiscales, facturas expedidas, facturas recibidas y exportaciones contables.

Este archivo no es asesoramiento fiscal ni legal. Es una guía operativa para usar FacturaScripts con seguridad. Para IVA, IGIC, IRPF, SII, VERI*FACTU o reglas locales vigentes, consulta `references/fuentes-oficiales-tributarias.md` y valida con la asesoría fiscal antes de presentar declaraciones o registrar operaciones irreversibles.

## Entidades principales que conviene inspeccionar

Antes de construir consultas o payloads, descubre los recursos y campos reales de la instalación objetivo:

1. `GET /api/3` para listar recursos.
2. Si está instalado, `GET /swagger?action=get-json` desde el plugin `DocumentacionAPI`.
3. Si existe un endpoint de esquema de recurso, consúltalo antes de escribir.
4. Revisa plugins activos, porque la contabilidad, los informes y la fiscalidad pueden cambiar.

Modelos habituales que pueden existir:

- Ventas: `FacturaCliente`, `FacturaClienteLinea`, `ReciboCliente`, `PagoCliente`, `Cliente`.
- Compras: `FacturaProveedor`, `FacturaProveedorLinea`, `ReciboProveedor`, `PagoProveedor`, `Proveedor`.
- Contabilidad: `Ejercicio`, `Diario`, `Cuenta`, `Subcuenta`, `Asiento`, `Partida`, `CuentaEspecial`.
- Impuestos: `Impuesto`, `ImpuestoZona`, `Retencion`.
- Configuración: `Empresa`, `Serie`, `FormaPago`, `Divisa`.

No asumas slugs de recursos. FacturaScripts suele exponer recursos en minúscula/plural y endpoints personalizados, pero la instalación concreta es la fuente de verdad.

## Autenticación

- Ruta base: `https://example.com/api/3`.
- Usa la API Key en la cabecera `Token` cuando esté disponible.
- Usa claves de mínimo privilegio.
- Separa claves de solo lectura para informes y claves de escritura para operaciones contables.
- No imprimas ni subas tokens a repositorios, issues, PRs o logs.
- Usa siempre HTTPS.

Ejemplo de lectura:

```bash
curl -sS \
  -H "Token: $FACTURASCRIPTS_TOKEN" \
  "$FACTURASCRIPTS_URL/api/3"
```

Ejemplo de escritura con formulario codificado:

```bash
curl -sS -X POST \
  -H "Token: $FACTURASCRIPTS_TOKEN" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "codcliente=1" \
  --data-urlencode 'lineas=[{"descripcion":"Servicio profesional","cantidad":1,"pvpunitario":100,"codimpuesto":"IVA21"}]' \
  "$FACTURASCRIPTS_URL/api/3/crearFacturaCliente"
```

## Patrón de consulta para informes

Usa `limit`, `offset`, `filter[...]` y `sort[...]`.

Filtro típico por periodo, tras verificar que el campo de fecha existe:

```text
GET /api/3/<recurso>?filter[fecha_gte]=2026-01-01&filter[fecha_lte]=2026-03-31&sort[fecha]=ASC&limit=500&offset=0
```

Operadores habituales documentados:

- Coincidencia exacta: `filter[campo]=valor`
- Mayor que: `filter[campo_gt]=valor`
- Mayor o igual: `filter[campo_gte]=valor`
- Menor que: `filter[campo_lt]=valor`
- Menor o igual: `filter[campo_lte]=valor`
- Distinto: `filter[campo_neq]=valor`
- Contiene: `filter[campo_like]=valor`

Para exportaciones grandes, pagina hasta recibir menos registros que `limit`. Si el cliente HTTP expone cabeceras, captura `X-Total-Count` cuando exista.

## Crear facturas

Cuando exista un endpoint específico de creación, prefiérelo frente al CRUD manual porque suele calcular líneas, totales e impuestos de forma coherente con FacturaScripts.

Factura de cliente:

```text
POST /api/3/crearFacturaCliente
codcliente=<codigo-o-id-cliente>
lineas=<json-lineas>
```

Factura de proveedor:

```text
POST /api/3/crearFacturaProveedor
codproveedor=<codigo-o-id-proveedor>
lineas=<json-lineas>
```

Las líneas suelen incluir `referencia` o `descripcion`. Otros campos posibles: `cantidad`, `pvpunitario`, descuentos, código de impuesto y retenciones. Verifica siempre el esquema real antes de escribir.

Antes de crear una factura, devuelve un dry-run:

| Campo | Valor |
| --- | --- |
| Cliente/proveedor | ... |
| Fecha | ... |
| Líneas | ... |
| Régimen fiscal | IVA / IGIC / exenta / inversión sujeto pasivo / desconocido |
| Base | ... |
| Cuota | ... |
| Retención | ... |
| Total | ... |
| Estado | cobrada/pagada / pendiente / desconocido |

Tras crear, lee el objeto devuelto (`doc`, `lines` o equivalente), porque FacturaScripts puede asignar número final, código y totales recalculados.

## Marcar facturas como cobradas o pagadas

Cuando estén disponibles, usa:

```text
POST /api/3/pagarFacturaCliente/{id}
POST /api/3/pagarFacturaProveedor/{id}
```

Campos habituales:

```text
fechapago=YYYY-MM-DD
codpago=<codigo-forma-pago>
pagada=1
```

Antes de llamar al endpoint:

1. Lee la factura y sus recibos.
2. Comprueba importe pendiente, divisa y vencimientos.
3. Confirma que la forma de pago existe en `FormaPago`.
4. Confirma que la fecha de pago pertenece a un ejercicio abierto.
5. Devuelve un dry-run.

## Crear asientos contables

La creación directa de asientos es una operación de alto riesgo. Prioriza operaciones de negocio de FacturaScripts que generen contabilidad automáticamente. Solo crea `Asiento`/`Partida` directamente cuando el usuario lo pida de forma explícita y aporte datos contables suficientes.

Validación mínima:

- La fecha pertenece a un `Ejercicio` abierto.
- El `Diario` existe.
- Todas las `Subcuenta` existen y pertenecen al ejercicio adecuado.
- Debe y haber cuadran tras aplicar redondeos.
- Las partidas con impuestos concilian con bases y cuotas de la factura relacionada.
- Existe concepto, documento soporte o tercero cuando sea aplicable.
- El usuario confirma el asiento final.

Formato de dry-run:

| Fecha | Subcuenta | Concepto | Debe | Haber | Tercero | Impuesto | Documento |
| --- | --- | --- | ---: | ---: | --- | --- | --- |
| ... | ... | ... | ... | ... | ... | ... | ... |
| **Total** | | | **0,00** | **0,00** | | | |

No cuadricules un asiento inventando una cuenta puente o de suspense salvo instrucción explícita y confirmación.

## Diario contable

Para generar un diario:

1. Identifica periodo, ejercicio y diario opcional.
2. Consulta `Asiento` por fecha.
3. Consulta `Partida` para los asientos devueltos.
4. Une con `Subcuenta` para descripciones.
5. Ordena por fecha, número de asiento y orden de línea.
6. Valida que cada asiento cuadra.

Columnas recomendadas:

```text
fecha, asiento, diario, subcuenta, descripcion_subcuenta, concepto, debe, haber, documento, tercero, punteada
```

## Mayor contable

Para generar un mayor:

1. Exige o infiere una subcuenta o rango de subcuentas.
2. Define periodo.
3. Consulta `Partida` filtrando por subcuenta y periodo.
4. Une con `Asiento` para fecha y diario.
5. Calcula saldo inicial si se solicita.
6. Calcula saldo acumulado con el signo adecuado.
7. Incluye totales de debe, haber y saldo final.

Columnas recomendadas:

```text
fecha, asiento, diario, concepto, debe, haber, saldo, documento, tercero
```

## Informe de facturas expedidas

Para facturas expedidas:

1. Consulta `FacturaCliente` en el periodo.
2. Separa facturas rectificativas si el modelo permite identificarlas.
3. Une cliente, nombre fiscal y NIF si están disponibles.
4. Incluye bases por impuesto si las líneas o desgloses lo permiten.
5. Separa cobrado, pendiente y vencido cuando existan recibos.

Columnas recomendadas:

```text
fecha, codigo, numero, serie, cliente, nif, base, impuesto, cuota, retencion, total, cobrada, vencimiento, forma_pago
```

## Informe de facturas recibidas

Para facturas recibidas:

1. Consulta `FacturaProveedor` en el periodo.
2. Incluye número de proveedor y fecha contable/recepción si existen.
3. Une proveedor, nombre fiscal y NIF.
4. Incluye cuota deducible solo cuando los datos lo permitan.
5. Separa facturas rectificativas e inversión del sujeto pasivo cuando se detecten.

Columnas recomendadas:

```text
fecha, numproveedor, codigo, proveedor, nif, base, impuesto, cuota, cuota_deducible, retencion, total, pagada, vencimiento, forma_pago
```

## Comprobaciones de IVA e IGIC

Cuando el usuario mencione IVA o IGIC:

- Determina territorio: Península/Baleares con IVA, Canarias con IGIC, Ceuta/Melilla con IPSI, UE, exportación, importación o no sujeta.
- Determina rol: emisor, receptor, cliente, proveedor, revendedor, profesional, administración pública u operador intracomunitario.
- Determina estado fiscal: sujeta, exenta, no sujeta, inversión del sujeto pasivo, tipo cero, tipo reducido, recargo o retención.
- No fijes tipos vigentes sin verificarlos en fuentes oficiales.
- Mantén separada la lógica de códigos de impuesto y la lógica de subcuentas contables.
- En operaciones canarias, no trates el IGIC como si fuera IVA con otro porcentaje.

## Patrón seguro de respuesta

Cuando el usuario pida ejecutar una tarea contable/API, responde en este orden:

1. Repite operación y periodo.
2. Indica qué se leerá y qué se escribirá.
3. Muestra filtros o campos del payload.
4. Muestra resultados del dry-run.
5. Pide confirmación para escrituras, salvo autorización inequívoca previa.
6. Ejecuta, lee de vuelta y reconcilia.
7. Devuelve informe con IDs, totales, advertencias y siguientes comprobaciones.

## Gestión de errores

- `400`: campo obligatorio ausente o payload mal formado.
- `401/403`: token ausente, inválido o sin permisos.
- `404`: recurso, documento, cliente, proveedor o almacén no encontrado.
- `409/422`: error de validación del modelo, periodo bloqueado, recálculo fallido o regla de negocio incumplida.

Devuelve el mensaje bruto de la API cuando ayude, pero tradúcelo a un siguiente paso operativo.

## Seguridad y trazabilidad

- Registra cada escritura con fecha/hora, endpoint, ID objetivo, resumen del dry-run y actor.
- Para importaciones masivas, usa referencias externas idempotentes cuando existan.
- Para lotes, crea una vista previa CSV/JSON y procesa por bloques.
- Detén el proceso ante la primera diferencia contable no conciliada.
- Guarda informes generados separados de credenciales API.
