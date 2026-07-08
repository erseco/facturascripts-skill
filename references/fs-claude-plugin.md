# Ideas adaptadas de fs-claude-plugin

Esta referencia recoge ideas compatibles con esta colección de Agent Skills a partir del repositorio oficial `FacturaScripts/fs-claude-plugin`.

- Repositorio de origen: https://github.com/FacturaScripts/fs-claude-plugin
- Autoría/licencia de origen: FacturaScripts, licencia MIT.
- Fecha de revisión: 2026-07-08.

No se copia el plugin ni su servidor MCP. Esta colección mantiene formato **Agent Skills** (`SKILL.md`, `references/`, `scripts/`) y adapta únicamente patrones de organización, vocabulario operativo y criterios de diseño útiles.

## Qué aporta el repositorio original

`fs-claude-plugin` se organiza como un marketplace de Claude Code con tres subplugins:

| Subplugin | Enfoque aprovechable aquí |
| --- | --- |
| `fs-dev` | Taxonomía de tareas de desarrollo: creación de plugin, modelo, controlador, extensión, XMLView, Twig, backend, frontend, API, testing y fsmaker. |
| `fs-user` | Tareas para usuarios no técnicos: análisis de ventas, clientes morosos, stock bajo, informes personalizados y guía de uso del ERP. |
| `fs-mcp` | Patrón de conexión MCP contra la API REST de FacturaScripts, herramientas por dominio, metadata de modelos y resources `fs-schema://`. |

## Adaptaciones recomendadas para estos skills

### 1. Afinar la taxonomía de desarrollo

El skill `facturascripts-developer` debería reconocer estas familias de tareas, aunque no se implementen como skills separadas:

- crear plugin;
- crear modelo y tabla XML;
- crear controlador `ListController`, `EditController`, `PanelController` o `ReportController`;
- crear extensión sin tocar el core;
- crear o modificar `XMLView`;
- crear vistas Twig;
- trabajar con documentos de compra/venta;
- crear migraciones;
- crear workers y tareas `Cron.php` / `CronClass`;
- crear mods de documentos;
- diseñar endpoints REST personalizados;
- depurar con `FS_DEBUG`, logs y PHPUnit;
- preparar commits y pull requests.

### 2. Mejorar el skill de usuario operativo

Los skills `facturascripts-accounting-user` y `facturascripts-reporting` deberían cubrir explícitamente estas tareas de negocio:

- ventas por período con cifras clave, tendencias y comparativas;
- clientes con deuda vencida y plan de seguimiento de cobros;
- productos con stock bajo, stock muerto y sobrestock;
- informes personalizados sobre datos disponibles;
- guía de uso del ERP para facturación, clientes, inventario, compras y contabilidad.

Cuando no haya conexión MCP o API configurada, deben responder con limitaciones claras: pueden explicar el procedimiento, pero no consultar datos reales.

### 3. Diseñar MCP como capa opcional, no obligatoria

`fs-mcp` demuestra un patrón útil que esta colección puede documentar:

- permitir varias conexiones y una conexión por defecto;
- aceptar `connection`, `limit` y `offset` en herramientas de consulta;
- agrupar herramientas por dominio: clientes/proveedores, productos, ventas, compras, contabilidad, finanzas, configuración, geografía, comunicación, sistema y analítica;
- usar herramientas de schema como `list_models`, `describe_model` y `verify_model_columns`;
- exponer resources tipo `fs-schema://models` y `fs-schema://model/<nombre>` para metadata de modelos.

En estos skills, MCP debe tratarse como **fuente de datos opcional**. Si existe, se usa para descubrir modelos, columnas y relaciones. Si no existe, se recurre a `/api/3`, Swagger/OpenAPI o documentación local.

### 4. Añadir reglas de seguridad específicas para MCP

- No incluir credenciales en prompts, issues, PRs ni documentación.
- No mostrar credenciales al listar conexiones.
- En certificados autofirmados, advertir del riesgo y limitarlo a entornos locales, VPN o desarrollo.
- En operaciones CRUD, exigir dry-run y confirmación explícita.
- Para herramientas genéricas `create_*`, `update_*` y `delete_*`, preferir operaciones de negocio específicas cuando existan.
- En contabilidad, no crear `Asiento`/`Partida` directamente si una factura, cobro o pago puede generar contabilidad de forma controlada.

### 5. Incorporar metadata de modelos al flujo de trabajo

Antes de componer filtros, payloads o informes, el asistente debe intentar obtener metadata actualizada:

1. `describe_model` o resource `fs-schema://model/<nombre>` si hay MCP.
2. Swagger/OpenAPI del plugin `DocumentacionAPI` si está disponible.
3. Consulta ligera a `/api/3/<recurso>?limit=1` para verificar columnas reales.
4. Referencias locales de este repositorio como fallback.

Esto reduce errores cuando la instalación tiene plugins privados, campos personalizados o versiones distintas de FacturaScripts.

## Herramientas MCP que conviene reconocer en prompts

### Gestión de conexiones

- `add_connection`
- `list_connections`
- `set_default_connection`

### Metadata de modelos

- `list_models`
- `describe_model`
- `verify_model_columns`

### Lectura por dominios

- Clientes/proveedores: `get_clientes`, `get_proveedores`, `get_contactos`, `get_agentes`.
- Productos/inventario: `get_productos`, `get_variantes`, `get_familias`, `get_almacenes`, `get_stocks`.
- Ventas: `get_facturaclientes`, `get_lineafacturaclientes`, `get_reciboclientes`, `get_pagoclientes`.
- Compras: `get_facturaproveedores`, `get_lineafacturaproveedores`, `get_reciboproveedores`, `get_pagoproveedores`.
- Contabilidad: `get_ejercicios`, `get_asientos`, `get_partidas`, `get_cuentas`, `get_subcuentas`, `get_diarios`.
- Finanzas: `get_formapagos`, `get_divisas`, `get_retenciones`, `get_impuestos`, `get_impuestozonas`.

### Analítica/KPIs

- `get_dashboard_resumen`
- `get_clientes_morosos`
- `get_productos_bajo_stock`
- `get_dso`
- `get_aging_cobros`
- `get_aging_pagos`
- `get_cash_flow_proyectado`
- `get_comparativa_ventas_periodos`
- `get_rotacion_stock`
- `get_valoracion_inventario`
- `get_funnel_ventas`

## Nota de atribución para trabajos derivados

Cuando una respuesta, referencia o implementación se base en estas ideas, incluye una nota breve:

> Inspirado en la organización y patrones del repositorio `FacturaScripts/fs-claude-plugin` de FacturaScripts, licencia MIT. Adaptado al formato Agent Skills de este repositorio.

## No adaptar directamente

- No copiar el servidor MCP completo dentro de este repositorio de skills.
- No convertir esta colección en un marketplace de Claude Plugin salvo que se decida cambiar de objetivo.
- No prometer ejecución MCP si el usuario solo instala el ZIP del skill.
- No asumir que todas las herramientas de `fs-mcp` existen en la instalación del usuario.
