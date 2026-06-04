---
name: facturascripts
description: >
  Skill completo para FacturaScripts 2025, el ERP open-source en PHP. Usa este skill SIEMPRE que el usuario
  mencione FacturaScripts, facturascripts, plugins de FacturaScripts, API de FacturaScripts, ERP FacturaScripts,
  o cualquier tarea relacionada con crear, modificar, depurar o documentar codigo para FacturaScripts.
  Tambien cuando mencione modelos como FacturaCliente, AlbaranCliente, Producto, Cliente, Proveedor,
  o controladores como ListController, EditController, PanelController. Tambien si habla de conectar
  sistemas externos con la API REST de FacturaScripts, crear un MCP para FacturaScripts, o automatizar
  procesos de facturacion, contabilidad, stock o compras/ventas en este ERP.
---

# FacturaScripts 2025 - Skill Completo

Este skill contiene la documentacion exhaustiva de FacturaScripts 2025.81, un ERP open-source en PHP
para gestion empresarial: facturacion, contabilidad, stock, compras, ventas, CRM y mas.

## Cuando usar cada referencia

Antes de escribir codigo, lee la referencia relevante segun la tarea:

| Tarea | Referencia a leer |
|-------|-------------------|
| Entender como funciona FacturaScripts | `references/architecture.md` (2374 lineas) |
| Crear un plugin nuevo | `references/plugins.md` (2089 lineas) |
| Trabajar con modelos (datos, CRUD) | `references/models.md` (1135 lineas) |
| Crear o modificar controladores | `references/controllers.md` (1721 lineas) + `references/controllers-advanced.md` (713 lineas) |
| Crear o modificar vistas/formularios | `references/views-widgets.md` (2787 lineas) |
| Conectar con la API REST | `references/api.md` (2811 lineas) |
| Trabajar con base de datos | `references/database.md` (2649 lineas) |
| Exportacion, PDF, email, contabilidad | `references/libraries.md` (944 lineas) |
| Usuarios, roles, permisos, seguridad | `references/security.md` (1840 lineas) |
| Traducciones e internacionalizacion | `references/translations.md` (1181 lineas) |
| Consulta rapida de metodos y clases | `references/quick-reference.md` (454 lineas) |
| Montar entorno, probar plugins/PRs, automatizar releases | `references/dev-tooling.md` |

Para la mayoria de tareas de desarrollo de plugins, lee `references/plugins.md` primero
y luego las referencias especificas que necesites.

Si la tarea involucra crear un MCP Server para conectar con FacturaScripts, lee
`references/api.md` que incluye una seccion completa sobre como crear un MCP Server
con herramientas basadas en la API REST.

Si la tarea involucra **arrancar un proyecto de plugin**, **montar un entorno de
desarrollo o pruebas**, **dar a un revisor una demo en vivo de un PR**, **probar un
plugin definiendo un `blueprint.json`** o **automatizar el release/publicacion en la
forja**, lee `references/dev-tooling.md`. Documenta el ecosistema de herramientas y
hay archivos listos para copiar en `templates/` (workflows de CI/preview/release,
`blueprint.json` y script de renombrado).

## Entorno de desarrollo, pruebas y publicacion

Ademas de la documentacion del core, este skill cubre el ecosistema de herramientas
para el ciclo de vida completo de un plugin (detalle en `references/dev-tooling.md`):

| Herramienta | Repositorio | Para que |
|-------------|-------------|----------|
| Imagen Docker base | [erseco/alpine-facturascripts](https://github.com/erseco/alpine-facturascripts) | Imagen ligera (Alpine + PHP 8.4) con instalacion desatendida; base del entorno dev y CI |
| Plantilla de plugin | [erseco/facturascripts-plugin-template](https://github.com/erseco/facturascripts-plugin-template) | Esqueleto con Docker, tests, lint y workflows de CI/release |
| Playground (WASM) | [erseco/facturascripts-playground](https://github.com/erseco/facturascripts-playground) | FacturaScripts en el navegador, configurable con `blueprint.json` |
| Action PR Preview | [erseco/action-facturascripts-playground-pr-preview](https://github.com/erseco/action-facturascripts-playground-pr-preview) | Comentario en el PR con enlace para probar la rama en el Playground |
| Action Publicar Forja | [erseco/action-facturascripts-publicar-forja](https://github.com/erseco/action-facturascripts-publicar-forja) | Sube el ZIP como build a la forja oficial tras una release |

Flujo recomendado: crear repo desde la plantilla -> desarrollar en local con
`make up` -> calidad con `make lint/test` (y CI) -> PR con preview automatico en el
Playground -> tag numerico que dispara ZIP + GitHub Release + publicacion en la forja.

## Estructura de FacturaScripts 2025

```
facturascripts/
  index.php                  # Punto de entrada
  Core/
    Kernel.php               # Nucleo: rutas, controladores, ciclo de vida
    Plugins.php              # Gestor de plugins
    Session.php              # Sesion y autenticacion
    Request.php              # Datos HTTP de entrada
    Response.php             # Respuesta HTTP
    Cache.php                # Cache basada en archivos
    Logger.php               # Sistema de logging
    Tools.php                # Utilidades (fechas, numeros, archivos)
    Translator.php           # Sistema de traducciones
    Html.php                 # Motor Twig con funciones custom
    Http.php                 # Cliente HTTP (cURL)
    DbQuery.php              # Query builder fluent
    Where.php                # Constructor de clausulas WHERE
    WorkQueue.php            # Cola de trabajos asincronos
    Validator.php            # Validacion de datos
    Base/
      Controller.php         # Clase base de controladores
      DataBase.php           # Abstraccion BD (MySQL/PostgreSQL)
    Controller/              # 125+ controladores del core
    Model/                   # 87+ modelos de dominio
      Base/                  # Clases base (ModelCore, ModelClass, traits)
      Join/                  # Modelos virtuales (JOIN)
    Lib/
      ExtendedController/    # Controladores extendidos (List, Edit, Panel)
      Widget/                # 36 tipos de widgets
      API/                   # Sistema API REST
      ListFilter/            # 7 tipos de filtros
      AjaxForms/             # Formularios AJAX
      Export/                # Exportacion (CSV, XLS, PDF)
      PDF/                   # Generacion PDF
      Email/                 # Envio de emails
      Accounting/            # Contabilidad
    View/                    # Plantillas Twig
    XMLView/                 # 133 definiciones de vistas XML
    Table/                   # Esquemas de tablas XML
    Translation/             # Archivos de traduccion JSON
    Mod/                     # Sistema de modificadores (hooks)
    Worker/                  # Workers para cola de trabajos
  Plugins/                   # Directorio de plugins
  MyFiles/                   # Archivos generados, cache, uploads
```

## Conceptos fundamentales

### Ciclo de vida de una peticion

```
1. index.php carga autoloader Composer
2. CrashReport::init() - manejo de errores fatales
3. Kernel::init() - constantes, idioma, workers, plugins
4. Plugins::init() - ejecuta Init.php de cada plugin activo
5. Kernel::run($url)
   a. Sanitiza URL
   b. Carga rutas (core + MyFiles/routes.json)
   c. Busca controlador que coincida con URL
   d. Instancia controlador
   e. Ejecuta controlador->run($response, $request)
6. WorkQueue::run() - procesa trabajos pendientes
7. Telemetry::update()
8. Logger::save() - persiste logs
9. DataBase::close()
```

### Ciclo de vida de un controlador

```
1. __construct() - configura getPageData()
2. run($response, $request)
   a. checkSecurity() - verifica login y permisos
   b. execPreviousAction($action) - procesa acciones del usuario
   c. loadData() - carga datos del modelo
   d. execAfterAction($action) - post-procesamiento
   e. Renderiza vista Twig
```

### Patron MVC

- **Modelo**: Clases en `Core/Model/` que extienden `ModelClass`. Cada modelo mapea una tabla.
- **Vista**: Definida en XML (`Core/XMLView/`) y renderizada con Twig (`Core/View/`). Los widgets controlan la UI.
- **Controlador**: Clases en `Core/Controller/` que extienden `BaseController` o sus variantes extendidas.

### Tipos de controlador

| Tipo | Uso | Clase |
|------|-----|-------|
| ListController | Listados con filtros, ordenacion, paginacion | `Lib\ExtendedController\ListController` |
| EditController | Formulario de edicion de un registro | `Lib\ExtendedController\EditController` |
| PanelController | Formulario con pestanas (tabs) | `Lib\ExtendedController\PanelController` |
| ReportController | Informes con filtros | `Lib\ExtendedController\ReportController` |

### Estructura minima de un plugin

```
Plugins/MiPlugin/
  facturascripts.ini         # Metadatos del plugin
  Init.php                   # Hooks de inicializacion
  Controller/
    ListMiModelo.php         # Controladores
    EditMiModelo.php
  Model/
    MiModelo.php             # Modelos
  Table/
    mi_tabla.xml             # Esquema de tabla
  XMLView/
    ListMiModelo.xml         # Definicion de vista lista
    EditMiModelo.xml         # Definicion de vista edicion
  Translation/
    es_ES.json               # Traducciones
```

### API REST

FacturaScripts incluye una API REST completa accesible en `/api/3/`. Soporta:
- Autenticacion por API Key (header `Token`) o login/password
- Operaciones CRUD sobre cualquier modelo
- Filtros con operadores: `=`, `gt`, `gte`, `lt`, `lte`, `neq`, `like`, `null`, `notnull`
- Paginacion con `offset` y `limit`
- Recursos personalizados

Para detalles completos de cada area, consulta las referencias especificas en `references/`.

## Reglas de desarrollo

1. Los modelos SIEMPRE deben implementar `tableName()`, `primaryColumn()` y `clear()`.
2. La validacion va en `test()`, que se ejecuta antes de `save()`.
3. Los nombres de tabla usan snake_case en plural (ej: `facturas_cli`, `productos`).
4. Los controladores List llevan prefijo `List` y los Edit llevan prefijo `Edit`.
5. Las vistas XML deben coincidir en nombre con el controlador (ListProducto.xml para ListProducto.php).
6. Usa `Tools::lang()->trans('clave')` para textos traducibles.
7. Los plugins NO deben modificar archivos del core. Usa Mod (modificadores) para extender comportamiento.
8. Las migraciones de BD se definen en archivos XML en `Table/`.
9. Para relaciones entre modelos, usa metodos `get*()` (ej: `getLines()`, `getCustomer()`).
10. El sistema de permisos se basa en Roles con acceso por pagina (controlador).
