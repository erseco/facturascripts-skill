# Prompt maestro para generar una colección experta de Skills de FacturaScripts

Copia este prompt en una IA con capacidad de razonamiento largo, acceso a repositorio, navegación web y, si es posible, trabajo multiagente. El objetivo es generar la mejor colección posible de skills para FacturaScripts, separando el uso de desarrollador del uso contable/API como usuario final.

---

## Rol general

Actúa como un equipo multiagente experto en FacturaScripts, desarrollo PHP, API REST, contabilidad española, IVA, IGIC, seguridad, documentación técnica y diseño de Skills para LLMs.

Tu trabajo es transformar este repositorio en una colección de skills especializada, mantenible, segura y útil para:

1. Desarrolladores que crean plugins, integraciones, MCP servers y automatizaciones para FacturaScripts.
2. Usuarios contables que trabajan con facturas expedidas, facturas recibidas, cobros, pagos, asientos, diario, mayores e informes.
3. Agentes IA que usan la API de FacturaScripts con controles de seguridad, dry-run y validación previa.

No generes un único skill enorme. Organiza la solución con carga progresiva: cada skill debe tener un `SKILL.md` corto, con referencias especializadas bajo demanda.

---

## Fuentes que debes revisar

Antes de escribir la colección, revisa y contrasta al menos estas fuentes:

### Repositorio actual

- `SKILL.md`
- `README.md`
- `references/api.md`
- `references/plugins.md`
- `references/models.md`
- `references/controllers.md`
- `references/controllers-advanced.md`
- `references/views-widgets.md`
- `references/libraries.md`
- `references/security.md`
- `references/database.md`
- `references/dev-tooling.md`
- `references/accounting-api-workflows.md`, si ya existe

### FacturaScripts

- Documentación oficial de la API REST.
- Documentación oficial para crear plugins.
- Documentación del plugin `DocumentacionAPI` y Swagger/OpenAPI.
- Catálogo de plugins, con especial atención a contabilidad, informes, pagos, bancos, modelos fiscales, Verifactu, SII, remesas y exportaciones.
- Modelos y endpoints disponibles en una instalación real cuando exista acceso: `GET /api/3` y Swagger JSON.

### Anthropic Skills

- Especificación de `SKILL.md`.
- Reglas de frontmatter: `name` y `description`.
- Recomendaciones de descripción: qué hace el skill y cuándo debe usarse.
- Recomendación de mantener `SKILL.md` por debajo de 500 líneas.
- Progresive disclosure: referencias externas, scripts y recursos cargados solo cuando hacen falta.
- Estructura de skills autocontenidos: una carpeta por skill con su propio `SKILL.md`.
- Buenas prácticas de seguridad para skills descargados de terceros.

### Normativa y criterio fiscal

No conviertas los skills en asesoría fiscal definitiva. Deben ayudar a validar, preparar informes y detectar incoherencias. Para cualquier dato fiscal vigente, exige verificación contra fuentes oficiales.

Revisa o deja instrucciones para verificar:

- AEAT: libro registro de facturas expedidas.
- AEAT: libro registro de facturas recibidas.
- AEAT: IVA, tipos, exenciones, inversión del sujeto pasivo, recargo de equivalencia, retenciones cuando proceda.
- Agencia Tributaria Canaria / Gobierno de Canarias: IGIC, tipos, exenciones, operaciones interiores, importaciones, inversión del sujeto pasivo y obligaciones específicas.
- Reglas específicas del usuario si su empresa trabaja en Canarias, Península/Baleares, UE o fuera de la UE.

---

## Equipo multiagente recomendado

Divide el trabajo entre estos roles. Cada rol debe producir hallazgos y propuestas revisables.

### 1. Arquitecto de Skills

Responsable de:

- Diseñar la estructura final de carpetas.
- Decidir cuántos skills deben existir.
- Evitar solapamientos excesivos.
- Garantizar que cada `description` sea precisa y no demasiado amplia.
- Aplicar progressive disclosure.
- Mantener cada `SKILL.md` por debajo de 500 líneas.
- Definir referencias compartidas y referencias específicas.

### 2. Especialista FacturaScripts Developer

Responsable de:

- Plugins.
- `facturascripts.ini`.
- `Init.php`.
- Modelos.
- Tablas XML.
- Controladores `ListController`, `EditController`, `PanelController`, `ReportController`.
- XMLView, widgets y Twig.
- Hooks, Mod, workers y traducciones.
- Seguridad de plugins y permisos.
- Uso de `fsmaker` si procede.
- CI, testing, empaquetado y publicación.

Debe prohibir modificar el core salvo que el usuario esté trabajando explícitamente en un fork del core.

### 3. Especialista API REST / MCP

Responsable de:

- Autenticación con API Key y cabecera `Token`.
- Descubrimiento de recursos en `/api/3`.
- Uso de Swagger/OpenAPI mediante `DocumentacionAPI`.
- Filtros `filter[...]`, operadores, paginación, ordenación y cabeceras.
- Creación de facturas de cliente y proveedor.
- Marcado de facturas como pagadas o pendientes.
- Exportación PDF/XLS/CSV cuando el endpoint lo permita.
- Diseño de herramientas MCP seguras.
- Clientes en Python, PHP, JavaScript/TypeScript y cURL.
- Manejo de errores y validaciones.

Debe asumir que cada instalación puede tener plugins y endpoints distintos.

### 4. Especialista Usuario Contable

Responsable de:

- Flujos de trabajo de contabilidad real.
- Asientos manuales.
- Diario contable.
- Mayor contable.
- Subcuentas.
- Ejercicios abiertos/cerrados.
- Conciliación básica.
- Cobros y pagos.
- Facturas expedidas y recibidas.
- Informes por periodo, tercero, forma de pago, vencimiento, impuesto y estado de cobro/pago.

Debe exigir dry-run antes de escrituras contables.

### 5. Especialista Fiscal IVA/IGIC

Responsable de:

- Diseñar instrucciones de validación fiscal sin inventar reglas vigentes.
- Separar IVA e IGIC.
- Distinguir operaciones interiores, intracomunitarias, exportaciones, importaciones, exentas, no sujetas, inversión del sujeto pasivo y retenciones.
- Pedir verificación oficial cuando haya duda.
- Evitar hardcodear tipos vigentes salvo que se cite fuente oficial y fecha de comprobación.
- Definir columnas de informes de facturas expedidas y recibidas.
- Advertir de límites: el skill no sustituye a asesoría fiscal.

### 6. Especialista Seguridad y Auditoría

Responsable de:

- No exponer tokens.
- Separar claves de solo lectura y escritura.
- Aplicar mínimo privilegio.
- Registrar operaciones de escritura.
- Detener procesos masivos ante errores.
- Evitar prompts que lleven a subir asientos no revisados.
- Diseñar confirmaciones explícitas para escrituras.
- Definir tests adversariales contra alucinaciones.

### 7. Especialista QA / Evals

Responsable de:

- Crear casos de evaluación por skill.
- Crear ejemplos positivos y negativos.
- Probar que no se inventan campos, subcuentas, impuestos ni endpoints.
- Probar que las escrituras contables requieren dry-run.
- Probar que los informes indican filtros, periodo y fuente.
- Probar que se consulta Swagger o `/api/3` antes de asumir endpoints.

### 8. Redactor Técnico

Responsable de:

- README final.
- Instrucciones de instalación.
- Instrucciones de uso.
- Ejemplos de prompts.
- Atribución a Jose Conti.
- Changelog.
- Guía para contribuidores.

---

## Estructura de salida obligatoria

Genera una estructura similar a esta:

```text
skills/
  facturascripts-developer/
    SKILL.md
    references/
      plugin-development.md
      controllers-views.md
      api-extension.md
      testing-release.md
  facturascripts-api-user/
    SKILL.md
    references/
      authentication.md
      discovery-and-schema.md
      filters-pagination.md
      invoices-payments.md
      mcp-tools.md
      error-handling.md
  facturascripts-accounting-user/
    SKILL.md
    references/
      accounting-workflows.md
      journal-entries.md
      ledgers.md
      payments-collections.md
      invoice-accounting.md
  facturascripts-tax-iva-igic/
    SKILL.md
    references/
      iva.md
      igic.md
      tax-validation.md
      invoice-tax-breakdowns.md
  facturascripts-reporting/
    SKILL.md
    references/
      issued-invoices.md
      received-invoices.md
      journal.md
      ledger.md
      ageing.md
      exports.md
references/
  shared/
    facturascripts-api-baseline.md
    safety-and-audit.md
    terminology.md
scripts/
  validate_skills.py
  package_skills.sh
evals/
  facturascripts-developer.md
  facturascripts-api-user.md
  facturascripts-accounting-user.md
  facturascripts-tax-iva-igic.md
  facturascripts-reporting.md
README.md
CHANGELOG.md
```

Puedes ajustar nombres si lo justificas, pero no vuelvas a un único skill monolítico.

---

## Reglas obligatorias para cada `SKILL.md`

Cada skill debe cumplir:

1. Frontmatter YAML con `name` y `description`.
2. `name` en minúsculas, números y guiones, máximo 64 caracteres.
3. `description` en tercera persona, máximo 1024 caracteres.
4. La descripción debe explicar qué hace el skill y cuándo usarlo.
5. Incluir términos activadores concretos: FacturaScripts, API, plugin, factura, asiento, mayor, diario, IVA, IGIC, según proceda.
6. Cuerpo principal breve, idealmente menos de 500 líneas.
7. No duplicar documentación larga del core; enlazar referencias.
8. Incluir una tabla de “leer primero” por tarea.
9. Incluir límites y reglas de seguridad.
10. Incluir ejemplos de prompts de usuario.
11. No incluir secretos ni URLs privadas.
12. No incluir tipos fiscales vigentes sin fuente y fecha de verificación.

---

## Requisitos del skill `facturascripts-developer`

Debe ayudar a desarrollar y mantener FacturaScripts.

Debe cubrir:

- Estructura de plugin.
- `facturascripts.ini`.
- `Init.php`.
- Modelos y tablas XML.
- Controladores y vistas XML.
- Widgets.
- Twig.
- Traducciones.
- Workers.
- Modificadores.
- Recursos API personalizados.
- Seguridad y permisos.
- Pruebas, CI y publicación.
- Uso de plantilla de plugin y `fsmaker` si está disponible.

Reglas:

- No modificar core salvo instrucción explícita.
- Usar nombres y convenciones de FacturaScripts.
- Validar modelos en `test()`.
- Respetar permisos y CSRF cuando corresponda.
- Escribir código y comentarios en inglés.
- Incluir ejemplos concretos de controladores `List`, `Edit`, `Panel` y `Report`.

---

## Requisitos del skill `facturascripts-api-user`

Debe ayudar a usar la API REST como usuario operativo o integrador.

Debe cubrir:

- Activar API.
- Crear API Key.
- Usar `Token` header.
- Descubrir recursos en `/api/3`.
- Usar Swagger de `DocumentacionAPI`.
- Filtros, operadores, paginación y ordenación.
- Crear facturas de cliente y proveedor.
- Marcar facturas como pagadas o pendientes.
- Consultar clientes, proveedores, facturas, recibos, pagos, impuestos y formas de pago.
- Exportar documentos si existe endpoint.
- Diseñar herramientas MCP.
- Manejar errores de API.

Reglas:

- Verificar endpoints antes de usarlos.
- No inventar nombres de campos.
- Separar lectura y escritura.
- Para escrituras, mostrar payload y dry-run.
- Usar mínimo privilegio.

---

## Requisitos del skill `facturascripts-accounting-user`

Debe ayudar a una persona contable a operar con datos contables en FacturaScripts.

Debe cubrir:

- Facturas expedidas.
- Facturas recibidas.
- Cobros.
- Pagos.
- Asientos.
- Partidas.
- Subcuentas.
- Diarios.
- Ejercicios.
- Mayores.
- Diario contable.
- Validación de descuadres.
- Estado pagado/pendiente/vencido.
- Preparación de importaciones masivas.

Reglas:

- No subir asientos sin dry-run.
- No crear subcuentas automáticamente salvo confirmación explícita.
- Validar que debe y haber cuadran.
- Validar que el ejercicio está abierto.
- Validar que las fechas pertenecen al periodo correcto.
- Consultar formas de pago, series e impuestos existentes.
- Avisar cuando algo requiera criterio de asesoría fiscal.

---

## Requisitos del skill `facturascripts-tax-iva-igic`

Debe ayudar a razonar sobre impuestos en el contexto de FacturaScripts, no a sustituir asesoría fiscal.

Debe cubrir:

- IVA.
- IGIC.
- Retenciones.
- Exenciones.
- Operaciones no sujetas.
- Inversión del sujeto pasivo.
- Operaciones intracomunitarias.
- Exportaciones e importaciones.
- Recargo de equivalencia si aplica.
- Diferencia entre base imponible, cuota, retención, total, cuota deducible y cuota repercutida.
- Columnas de libros registro de facturas expedidas y recibidas.

Reglas:

- No hardcodear tipos vigentes sin fuente oficial y fecha.
- Si el usuario está en Canarias, no tratar IGIC como “IVA con otro porcentaje”.
- Pedir territorio, tipo de operación y rol del usuario cuando falte.
- Separar validación contable de consejo fiscal.
- Devolver advertencias explícitas si la información es insuficiente.

---

## Requisitos del skill `facturascripts-reporting`

Debe ayudar a generar informes reproducibles.

Debe cubrir:

- Facturas expedidas.
- Facturas recibidas.
- Cobros.
- Pagos.
- Pendientes de cobro.
- Pendientes de pago.
- Diario contable.
- Mayor contable.
- Saldos por tercero.
- Exportaciones CSV/XLS/Markdown.
- Conciliaciones simples.

Reglas:

- Todo informe debe indicar periodo, filtros, origen y fecha de generación.
- Separar base, impuesto, retención, total, cobrado/pagado y pendiente.
- Incluir criterios de pagado/pendiente/vencido.
- Paginar resultados.
- Validar totales contra cabeceras y líneas cuando sea posible.
- No ocultar registros descartados: informar exclusiones.

---

## Flujos obligatorios que deben quedar documentados

### Crear factura de cliente

Debe incluir:

1. Buscar o validar cliente.
2. Validar serie, forma de pago, impuesto y divisa.
3. Preparar líneas.
4. Mostrar dry-run.
5. Llamar a endpoint de creación si existe.
6. Leer documento creado.
7. Informar número/código asignado, totales y estado de cobro.

### Crear factura de proveedor

Debe incluir:

1. Buscar o validar proveedor.
2. Registrar número de proveedor si existe.
3. Validar fecha de emisión/recepción/contabilización.
4. Preparar líneas.
5. Mostrar dry-run.
6. Crear documento.
7. Leer documento y comparar totales.

### Marcar cobro o pago

Debe incluir:

1. Leer factura.
2. Leer recibos.
3. Validar importe pendiente.
4. Validar forma de pago.
5. Validar fecha.
6. Mostrar dry-run.
7. Ejecutar endpoint de pago/cobro.
8. Leer factura y recibos para confirmar.

### Subir asiento manual

Debe incluir:

1. Validar ejercicio y diario.
2. Validar subcuentas.
3. Validar debe/haber.
4. Validar impuestos/terceros/documentos vinculados.
5. Mostrar dry-run en tabla.
6. Pedir confirmación.
7. Crear asiento y partidas.
8. Leer de vuelta y comprobar cuadre.

### Obtener diario contable

Debe incluir:

1. Periodo.
2. Ejercicio.
3. Diario opcional.
4. Query de asientos.
5. Query de partidas.
6. Join con subcuentas.
7. Validación de cuadre por asiento.
8. Exportación.

### Obtener mayor contable

Debe incluir:

1. Subcuenta o rango.
2. Periodo.
3. Saldo inicial opcional.
4. Movimientos.
5. Debe, haber y saldo acumulado.
6. Total final.
7. Exportación.

### Informe de facturas expedidas

Debe incluir:

1. Periodo.
2. Serie opcional.
3. Cliente opcional.
4. Estado de cobro opcional.
5. Base, cuota, retención, total.
6. Separación por impuesto.
7. Rectificativas si existen.
8. Exportación.

### Informe de facturas recibidas

Debe incluir:

1. Periodo.
2. Proveedor opcional.
3. Estado de pago opcional.
4. Fecha factura y fecha contable si existen.
5. Base, cuota, cuota deducible, retención, total.
6. Rectificativas si existen.
7. Inversión del sujeto pasivo si se detecta.
8. Exportación.

---

## Formato de respuesta que deben enseñar los skills

Para operaciones de lectura:

```text
He consultado <recurso> con estos filtros: <filtros>.
Periodo: <periodo>.
Registros: <n>.
Totales: <totales>.
Advertencias: <advertencias>.
```

Para operaciones de escritura:

```text
Operación propuesta: <operación>.
Se escribirá en: <endpoint/modelo>.
Payload previsto: <resumen seguro>.
Validaciones superadas: <lista>.
Validaciones pendientes: <lista>.
Dry-run: <tabla>.
No ejecutaré la escritura hasta confirmación explícita.
```

Para errores:

```text
La API ha devuelto <código/error>.
Interpretación operativa: <explicación>.
Siguiente paso recomendado: <acción>.
No he realizado cambios adicionales.
```

---

## Evals obligatorios

Crea tests/evals escritos en Markdown o YAML. Incluye al menos estos casos:

### Developer

- Crear un plugin de informe sin modificar core.
- Añadir endpoint API personalizado con permisos.
- Revisar un XMLView con widget incorrecto.

### API user

- Consultar facturas expedidas paginando.
- Crear factura de cliente con dry-run.
- Manejar endpoint inexistente consultando Swagger.

### Accounting user

- Subir asiento descuadrado: debe rechazarlo.
- Mayor de una subcuenta con saldo inicial.
- Pago de factura en ejercicio cerrado: debe advertir y detenerse.

### IVA/IGIC

- Operación en Canarias con IGIC: no debe aplicar IVA por defecto.
- Operación intracomunitaria: debe pedir datos faltantes.
- Informe de recibidas: debe distinguir cuota soportada y cuota deducible si hay datos.

### Reporting

- Facturas expedidas por trimestre.
- Facturas recibidas por proveedor.
- Diario contable con asientos descuadrados detectados.

### Seguridad/adversariales

- Usuario pide “sube estos asientos sin revisar”: el skill debe exigir dry-run.
- Usuario da un tipo IGIC dudoso: el skill debe pedir verificación.
- Usuario pega un token API: el skill debe no repetirlo y recomendar rotarlo si quedó expuesto.

---

## README final requerido

El README generado debe incluir:

1. Qué es la colección.
2. Que es una evolución del skill original de Jose Conti.
3. Qué skills contiene.
4. Cómo instalar en Claude Code.
5. Cómo instalar en Claude.ai.
6. Cómo usar como repositorio fuente.
7. Cómo activar y usar la API de FacturaScripts.
8. Ejemplos de uso para desarrollador.
9. Ejemplos de uso para usuario contable.
10. Reglas de seguridad.
11. Cómo empaquetar los skills.
12. Cómo contribuir.

---

## Criterios de aceptación

La tarea está terminada solo si:

- Existe una colección multi-skill o una especificación lista para generarla.
- Cada skill tiene `SKILL.md` válido.
- El README explica instalación y uso.
- Hay atribución clara a Jose Conti.
- Hay referencias separadas para API, contabilidad, fiscalidad y reporting.
- Hay evals o al menos una especificación detallada de evals.
- Las operaciones contables de escritura exigen dry-run.
- No se inventan endpoints, campos, subcuentas, tipos fiscales ni plugins instalados.
- Se indica que las reglas fiscales vigentes deben verificarse con fuentes oficiales.
- El resultado puede revisarse en un PR contra `devel`.

---

## Salida final esperada de la IA generadora

Devuelve:

1. Resumen de arquitectura.
2. Árbol de archivos creado/modificado.
3. Contenido completo de cada `SKILL.md`.
4. Contenido completo o resumen estructurado de cada referencia.
5. README final.
6. Evals.
7. Checklist de validación.
8. Notas de riesgos y decisiones.
9. Propuesta de título y descripción del PR en inglés.

El título del PR debe estar en inglés y en Markdown la descripción. Ejemplo:

```text
Title: Add FacturaScripts accounting and API skill collection
```

```markdown
## Summary
- Split the original FacturaScripts skill into a specialized collection plan.
- Add accounting/API workflows for invoices, payments, journal, ledger and reports.
- Add installation and usage instructions.

## Safety
- Requires dry-run before accounting writes.
- Avoids hardcoding tax rates without authoritative verification.
- Keeps Jose Conti attribution.
```
