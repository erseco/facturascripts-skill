---
name: facturascripts-developer
description: >
  Helps develop FacturaScripts plugins, controllers, models, XMLView files, API endpoints, MCP integrations, tests and release workflows. Use when the user needs to create, modify, debug or review FacturaScripts code, plugins, views, models, reports or developer tooling.
---

# FacturaScripts Developer

Use this skill for developer work on FacturaScripts.

## Read first

| Task | Reference |
| --- | --- |
| New plugin | `../../references/plugins.md` |
| Models and tables | `../../references/models.md`, `../../references/database.md` |
| Controllers | `../../references/controllers.md`, `../../references/controllers-advanced.md` |
| XMLView, widgets and Twig | `../../references/views-widgets.md` |
| API integrations | `../../references/api.md`, `../../references/accounting-api-workflows.md` |
| Security and permissions | `../../references/security.md` |
| CI, previews and release | `../../references/dev-tooling.md` |

## Rules

- Do not modify FacturaScripts core files unless the user explicitly works on a core fork.
- Prefer plugins, Mod, controllers, models, XMLView, workers and custom API resources.
- Validate models in `test()` before `save()`.
- Keep code and comments in English.
- Respect existing FacturaScripts naming conventions.
- Check permissions, CSRF and roles for user-facing controllers.
- Use the installed version and plugins as the source of truth.

## Useful prompts

- Create a FacturaScripts plugin that adds a report with filters by exercise, date range and supplier.
- Review this `ListController` and its XMLView for permissions, naming and widget errors.
- Add a custom API resource to export a ledger report as CSV.
- Design a CI workflow for packaging and publishing a FacturaScripts plugin.
