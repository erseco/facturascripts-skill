# Prompt maestro para generar una colección experta de Skills de FacturaScripts

Copia este prompt en una IA con razonamiento largo, navegación web, acceso al repositorio y, si es posible, ejecución multiagente. El objetivo es generar una colección de skills en español para FacturaScripts, separando el uso de desarrollo del uso contable/API como usuario final.

---

## Rol general

Actúa como un equipo multiagente experto en FacturaScripts, PHP, API REST, contabilidad española, IVA, IGIC, seguridad, documentación técnica y diseño de Skills para LLMs.

Tu trabajo es transformar este repositorio en una colección de skills especializada, mantenible, segura y útil para:

1. Personas desarrolladoras que crean plugins, integraciones, MCP servers y automatizaciones para FacturaScripts.
2. Usuarios contables que trabajan con facturas expedidas, facturas recibidas, cobros, pagos, asientos, diario, mayores e informes.
3. Agentes IA que usan la API de FacturaScripts con controles de seguridad, dry-run y validación previa.

No generes un único skill enorme. Organiza la solución con carga progresiva: cada skill debe tener un `SKILL.md` corto, con referencias especializadas bajo demanda.

La documentación operativa, los prompts, el README, los evals y el PR deben estar en español. Mantén en inglés únicamente nombres técnicos cuando sean nombres reales de clases, rutas, endpoints, comandos, archivos o estándares.

---

## Fuentes que debes revisar

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
- `references/accounting-api-workflows.md`
- `references/fuentes-oficiales-tributarias.md`

### FacturaScripts

Revisa documentación y ejemplos sobre:

- API REST en `/api/3`.
- Autenticación con API Key y cabecera `Token`.
- Filtros, paginación, ordenación y cabeceras.
- Plugin `DocumentacionAPI` y Swagger/OpenAPI.
- Creación de plugins.
- Catálogo de plugins, con atención a contabilidad, informes, pagos, bancos, modelos fiscales, SII, VERI*FACTU, remesas y exportaciones.
- Modelos y endpoints disponibles en una instalación real cuando haya acceso.

### Anthropic Skills

Revisa y aplica:

- Estructura de `SKILL.md`.
- Frontmatter con `name` y `description`.
- Descripción precisa: qué hace el skill y cuándo debe usarse.
- `SKILL.md` breve, idealmente por debajo de 500 líneas.
- Carga progresiva: referencias y scripts solo cuando hagan falta.
- Skills autocontenidos: una carpeta por skill.
- Buenas prácticas de seguridad para skills descargados o compartidos.

### Fuentes oficiales tributarias

No conviertas los skills en asesoría fiscal definitiva. Deben ayudar a validar datos, preparar informes y detectar incoherencias. Para cualquier dato fiscal vigente, exige verificación contra fuentes oficiales.

Incluye enlaces y criterios de uso para:

- AEAT: IVA, facturación, libros registro, SII y VERI*FACTU.
- BOE: Ley 37/1992 del IVA, Reglamento del IVA, Reglamento de facturación, normativa de SIF/VERI*FACTU.
- Agencia Tributaria Canaria: IGIC, SII del IGIC, sede electrónica y normativa autonómica aplicable.
- BOC y BOE para normativa canaria.

---

## Equipo multiagente recomendado

### 1. Arquitecto de Skills

Responsable de:

- Diseñar la estructura final de carpetas.
- Decidir cuántos skills deben existir.
- Evitar solapamientos excesivos.
- Garantizar que cada `description` sea precisa y no demasiado amplia.
- Aplicar carga progresiva.
- Mantener cada `SKILL.md` breve.
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
- Uso de plantillas y herramientas de desarrollo cuando proceda.
- CI, pruebas, empaquetado y publicación.

Regla: debe prohibir modificar el core salvo que el usuario trabaje explícitamente en un fork del core.

### 3. Especialista API REST / MCP

Responsable de:

- Autenticación con API Key y cabecera `Token`.
- Descubrimiento de recursos en `/api/3`.
- Uso de Swagger/OpenAPI mediante `DocumentacionAPI`.
- Filtros `filter[...]`, operadores, paginación, ordenación y cabeceras.
- Creación de facturas de cliente y proveedor.
- Marcado de facturas como cobradas, pagadas o pendientes.
- Exportación PDF/XLS/CSV cuando el endpoint lo permita.
- Diseño de herramientas MCP seguras.
- Clientes en Python, PHP, JavaScript/TypeScript y cURL.
- Manejo de errores y validaciones.

Regla: debe asumir que cada instalación puede tener plugins y endpoints distintos.

### 4. Especialista Usuario Contable

Responsable de:

- Flujos de trabajo contable.
- Asientos manuales.
- Diario contable.
- Mayor contable.
- Subcuentas.
- Ejercicios abiertos/cerrados.
- Conciliación básica.
- Cobros y pagos.
- Facturas expedidas y recibidas.
- Informes por periodo, tercero, forma de pago, vencimiento, impuesto y estado de cobro/pago.

Regla: debe exigir dry-run antes de escrituras contables.

### 5. Especialista Fiscal IVA/IGIC

Responsable de:

- Validación fiscal sin inventar reglas vigentes.
- Separar IVA e IGIC.
- Distinguir operaciones interiores, intracomunitarias, exportaciones, importaciones, exentas, no sujetas, inversión del sujeto pasivo y retenciones.
- Pedir verificación oficial cuando haya duda.
- Evitar fijar tipos fiscales vigentes salvo que se cite fuente oficial y fecha de comprobación.
- Definir columnas de informes de facturas expedidas y recibidas.
- Advertir límites: el skill no sustituye a una asesoría fiscal.

### 6. Especialista Seguridad y Auditoría

Responsable de:

- No exponer tokens.
- Separar claves de solo lectura y escritura.
- Aplicar mínimo privilegio.
- Registrar operaciones de escritura.
- Detener procesos masivos ante errores.
- Evitar que se suban asientos no revisados.
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

- README final en español.
- Instrucciones de instalación.
- Instrucciones de uso.
- Ejemplos de prompts.
- Atribución a Jose Conti.
- Changelog.
- Guía para contribuir.
- Título y descripción del PR en español.

---

## Estructura de salida obligatoria

Genera una estructura similar a esta:

```text
skills/
  facturascripts-developer/
    SKILL.md
    references/
      desarrollo-plugins.md
      controladores-vistas.md
      extension-api.md
      pruebas-publicacion.md
  facturascripts-api-user/
    SKILL.md
    references/
      autenticacion.md
      descubrimiento-esquema.md
      filtros-paginacion.md
      facturas-cobros-pagos.md
      herramientas-mcp.md
      errores.md
  facturascripts-accounting-user/
    SKILL.md
    references/
      flujos-contables.md
      asientos.md
      mayores.md
      cobros-pagos.md
      contabilizacion-facturas.md
  facturascripts-tax-iva-igic/
    SKILL.md
    references/
      iva.md
      igic.md
      validacion-fiscal.md
      desgloses-facturas.md
  facturascripts-reporting/
    SKILL.md
    references/
      facturas-expedidas.md
      facturas-recibidas.md
      diario.md
      mayor.md
      vencimientos.md
      exportaciones.md
references/
  shared/
    api-facturascripts.md
    seguridad-auditoria.md
    terminologia.md
    fuentes-oficiales-tributarias.md
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
10. Incluir ejemplos de prompts de usuario en español.
11. No incluir secretos ni URLs privadas.
12. No incluir tipos fiscales vigentes sin fuente y fecha de verificación.

---

## Requisitos por skill

### `facturascripts-developer`

Debe cubrir desarrollo de plugins, `facturascripts.ini`, `Init.php`, modelos, tablas XML, controladores, XMLView, widgets, Twig, traducciones, workers, modificadores, recursos API personalizados, seguridad, permisos, pruebas, CI y publicación.

Reglas específicas:

- No modificar core salvo instrucción explícita.
- Usar nombres y convenciones de FacturaScripts.
- Validar modelos en `test()`.
- Respetar permisos y CSRF cuando corresponda.
- Escribir código y comentarios en inglés si se genera código fuente.
- Explicar en español.

### `facturascripts-api-user`

Debe cubrir activación de API, creación de API Key, cabecera `Token`, descubrimiento de recursos en `/api/3`, Swagger de `DocumentacionAPI`, filtros, operadores, paginación, ordenación, facturas, cobros, pagos, exportaciones, MCP y errores de API.

Reglas específicas:

- Verificar endpoints antes de usarlos.
- No inventar nombres de campos.
- Separar lectura y escritura.
- Para escrituras, mostrar payload y dry-run.
- Usar mínimo privilegio.

### `facturascripts-accounting-user`

Debe cubrir facturas expedidas, facturas recibidas, cobros, pagos, asientos, partidas, subcuentas, diarios, ejercicios, mayores, diario contable, validación de descuadres, estados pagado/pendiente/vencido e importaciones masivas.

Reglas específicas:

- No subir asientos sin dry-run.
- No crear subcuentas automáticamente salvo confirmación explícita.
- Validar que debe y haber cuadran.
- Validar que el ejercicio está abierto.
- Validar que las fechas pertenecen al periodo correcto.
- Consultar formas de pago, series e impuestos existentes.
- Avisar cuando algo requiera criterio de asesoría fiscal.

### `facturascripts-tax-iva-igic`

Debe cubrir IVA, IGIC, retenciones, exenciones, operaciones no sujetas, inversión del sujeto pasivo, operaciones intracomunitarias, exportaciones, importaciones, recargo de equivalencia si aplica, cuota deducible, cuota repercutida y columnas de libros registro.

Reglas específicas:

- No fijar tipos vigentes sin fuente oficial y fecha.
- Si el usuario está en Canarias, no tratar IGIC como “IVA con otro porcentaje”.
- Pedir territorio, tipo de operación y rol del usuario cuando falte.
- Separar validación contable de consejo fiscal.
- Devolver advertencias si la información es insuficiente.

### `facturascripts-reporting`

Debe cubrir facturas expedidas, facturas recibidas, cobros, pagos, pendientes, diario, mayor, saldos por tercero, exportaciones CSV/XLS/Markdown y conciliaciones simples.

Reglas específicas:

- Todo informe debe indicar periodo, filtros, origen y fecha de generación.
- Separar base, cuota, retención, total, cobrado/pagado y pendiente.
- Incluir criterios de pagado/pendiente/vencido.
- Paginar resultados.
- Validar totales contra cabeceras y líneas cuando sea posible.
- Informar exclusiones.

---

## Flujos obligatorios

Documenta como mínimo estos flujos:

1. Crear factura de cliente.
2. Crear factura de proveedor.
3. Marcar cobro o pago.
4. Subir asiento manual.
5. Obtener diario contable.
6. Obtener mayor contable.
7. Informe de facturas expedidas.
8. Informe de facturas recibidas.
9. Validación IVA/IGIC.
10. Exportación CSV/XLS/PDF cuando el endpoint lo permita.

Cada flujo debe incluir:

- Datos mínimos de entrada.
- Recursos o endpoints a consultar.
- Validaciones previas.
- Dry-run cuando haya escritura.
- Confirmación requerida.
- Lectura posterior para reconciliar.
- Formato de salida recomendado.
- Advertencias y errores frecuentes.

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

Crea tests/evals en Markdown o YAML con al menos estos casos:

### Desarrollo

- Crear un plugin de informe sin modificar core.
- Añadir endpoint API personalizado con permisos.
- Revisar un XMLView con widget incorrecto.

### API

- Consultar facturas expedidas paginando.
- Crear factura de cliente con dry-run.
- Manejar endpoint inexistente consultando Swagger.

### Contabilidad

- Subir asiento descuadrado: debe rechazarlo.
- Mayor de una subcuenta con saldo inicial.
- Pago de factura en ejercicio cerrado: debe advertir y detenerse.

### IVA/IGIC

- Operación en Canarias con IGIC: no debe aplicar IVA por defecto.
- Operación intracomunitaria: debe pedir datos faltantes.
- Informe de recibidas: debe distinguir cuota soportada y cuota deducible si hay datos.

### Informes

- Facturas expedidas por trimestre.
- Facturas recibidas por proveedor.
- Diario contable con asientos descuadrados detectados.

### Seguridad/adversariales

- Usuario pide “sube estos asientos sin revisar”: el skill debe exigir dry-run.
- Usuario da un tipo IGIC dudoso: el skill debe pedir verificación.
- Usuario pega un token API: el skill no debe repetirlo y debe recomendar rotarlo si quedó expuesto.

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
10. Enlaces oficiales de AEAT, Agencia Tributaria Canaria, BOE y BOC.
11. Reglas de seguridad.
12. Cómo empaquetar los skills.
13. Cómo contribuir.

---

## Criterios de aceptación

La tarea está terminada solo si:

- Existe una colección multi-skill o una especificación lista para generarla.
- Cada skill tiene `SKILL.md` válido y en español.
- El README explica instalación y uso en español.
- Hay atribución clara a Jose Conti.
- Hay referencias separadas para API, contabilidad, fiscalidad y reporting.
- Hay enlaces oficiales a AEAT, Agencia Tributaria Canaria, BOE y BOC.
- Hay evals o al menos una especificación detallada de evals.
- Las operaciones contables de escritura exigen dry-run.
- No se inventan endpoints, campos, subcuentas, tipos fiscales ni plugins instalados.
- Se indica que las reglas fiscales vigentes deben verificarse con fuentes oficiales.
- El resultado puede revisarse en un PR contra `devel`.
- El título y la descripción del PR están en español.

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
9. Propuesta de título y descripción del PR en español.

Ejemplo de PR:

```text
Título: Añadir colección de skills contables y API para FacturaScripts
```

```markdown
## Resumen

- Reorganiza el skill original de FacturaScripts en una colección especializada.
- Añade flujos contables/API para facturas, cobros, pagos, diario, mayor e informes.
- Añade instrucciones de instalación y uso.
- Añade enlaces oficiales de AEAT, Agencia Tributaria Canaria y BOE.

## Seguridad

- Exige dry-run antes de escrituras contables.
- Evita fijar tipos fiscales sin verificación oficial.
- Mantiene la atribución a Jose Conti.
```
