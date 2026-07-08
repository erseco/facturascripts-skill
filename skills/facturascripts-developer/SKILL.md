---
name: facturascripts-developer
description: >
  Ayuda a desarrollar plugins, controladores, modelos, vistas XMLView, endpoints API, integraciones MCP, pruebas y flujos de publicación para FacturaScripts. Usar cuando el usuario necesite crear, modificar, depurar o revisar código, plugins, vistas, modelos, informes o herramientas de desarrollo de FacturaScripts.
metadata:
  version: "v0"
---

# FacturaScripts Developer

Usa este skill para trabajos de desarrollo sobre FacturaScripts.

## Leer primero

| Tarea | Referencia |
| --- | --- |
| Plugin nuevo | `../../references/plugins.md` |
| Modelos y tablas | `../../references/models.md`, `../../references/database.md` |
| Controladores | `../../references/controllers.md`, `../../references/controllers-advanced.md` |
| XMLView, widgets y Twig | `../../references/views-widgets.md` |
| Integraciones API | `../../references/api.md`, `../../references/accounting-api-workflows.md` |
| Seguridad y permisos | `../../references/security.md` |
| CI, previews y release | `../../references/dev-tooling.md` |

## Reglas

- No modifiques archivos del core de FacturaScripts salvo que el usuario indique explícitamente que trabaja sobre un fork del core.
- Prefiere plugins, Mod, controladores, modelos, XMLView, workers y recursos API propios.
- Valida modelos en `test()` antes de `save()`.
- Mantén código y comentarios en inglés si el proyecto lo requiere, pero explica al usuario en español.
- Respeta las convenciones de nombres de FacturaScripts.
- Revisa permisos, CSRF y roles en controladores con interacción de usuario.
- Usa la versión instalada y los plugins activos como fuente de verdad.

## Prompts útiles

- Crea un plugin de FacturaScripts que añada un informe con filtros por ejercicio, rango de fechas y proveedor.
- Revisa este `ListController` y su XMLView para detectar errores de permisos, nombres y widgets.
- Añade un recurso API personalizado para exportar un mayor contable en CSV.
- Diseña un flujo de CI para empaquetar y publicar un plugin de FacturaScripts.
