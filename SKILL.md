---
name: facturascripts
description: >
  Coordinates FacturaScripts expertise for plugin development, REST API usage, accounting workflows, IVA/IGIC reasoning,
  invoices, payments, collections, journal entries, ledgers, reports, and MCP/API integrations. Use when the user mentions
  FacturaScripts, FacturaScripts plugins, FacturaScripts API, accounting entries, FacturaCliente, FacturaProveedor,
  ReciboCliente, ReciboProveedor, Asiento, Partida, Subcuenta, diario, mayor, IVA, IGIC, facturas expedidas or facturas recibidas.
---

# FacturaScripts Skill Router

This root skill is a compatibility entry point for the original single-skill layout. New work should prefer the specialized skills proposed in `PROMPT_GENERADOR_SKILLS.md` and the workflows in `references/accounting-api-workflows.md`.

The repository is an evolution of the original FacturaScripts skill by Jose Conti. Keep that attribution visible in documentation and derivative files.

## Skill selection

Use the smallest relevant scope before loading long references:

| User task | Read first |
| --- | --- |
| Build or refactor FacturaScripts plugins | `references/plugins.md`, then `references/controllers.md`, `references/models.md`, `references/views-widgets.md` |
| Create API clients, MCP tools or external integrations | `references/api.md`, then `references/accounting-api-workflows.md` |
| Work as an accounting user through the API | `references/accounting-api-workflows.md`, then `references/models.md` for entity names |
| Upload invoices, collect payments or mark supplier payments | `references/accounting-api-workflows.md`, `references/api.md` |
| Generate issued/received invoice reports | `references/accounting-api-workflows.md`, then API resource discovery or Swagger JSON |
| Consult journal, ledger, accounts and entries | `references/accounting-api-workflows.md`, `references/libraries.md`, `references/models.md` |
| Reason about IVA, IGIC, retentions or reverse-charge cases | `references/accounting-api-workflows.md`; verify current tax rules with authoritative sources when needed |
| Security, roles or API key permissions | `references/security.md`, `references/api.md` |
| Development tooling, CI, previews and releases | `references/dev-tooling.md` |

## Operating principles

1. Do not assume the user's FacturaScripts instance has every endpoint enabled. Discover resources at `/api/3` or through the `DocumentacionAPI` Swagger JSON when possible.
2. Treat accounting writes as high-risk operations. For creates, updates, payments and journal entries, produce a dry-run summary and ask for explicit confirmation unless the user already requested execution in an unambiguous way.
3. Never invent account codes, tax rates, fiscal periods, customer IDs, supplier IDs or payment methods. Query the instance or ask the user.
4. For IVA and IGIC, separate factual accounting mechanics from tax/legal advice. Validate rates, exemptions, reverse-charge treatment, recargo de equivalencia and Canary-specific IGIC rules against current authoritative sources.
5. For reports, state the data source, filters, period, currency, tax regime and whether totals are pre-tax, tax, withholding, paid, pending or gross.
6. For API calls, prefer form URL encoded payloads for FacturaScripts create/update operations unless the endpoint documentation or Swagger schema says otherwise.
7. For model CRUD, verify field names from the model schema before composing filters or payloads.
8. For code, follow the style already used by FacturaScripts and the target plugin. Do not modify core files; use plugins, extensions, controllers, models, XMLView, workers and API endpoints.

## FacturaScripts API baseline

- Base API path: `/api/3`.
- Authentication: API key in the `Token` header, or the authentication mode documented by the target instance.
- Common query controls: `limit`, `offset`, `filter[field]`, operator suffixes such as `_gt`, `_gte`, `_lt`, `_lte`, `_neq`, `_like`, and `sort[field]=ASC|DESC`.
- Common document endpoints include `crearFacturaCliente`, `crearFacturaProveedor`, `pagarFacturaCliente/{id}` and `pagarFacturaProveedor/{id}` when available.
- Export endpoints can provide PDF/XLS/CSV for supported documents, for example `exportarFacturaCliente/{id}?type=CSV` when enabled.

## Recommended specialized collection

The target collection should be generated or maintained as separate folders, each with its own `SKILL.md` and narrowly scoped description:

1. `facturascripts-developer`: plugin, API, MCP, CI and release development.
2. `facturascripts-api-user`: safe operational usage of the REST API as a user.
3. `facturascripts-accounting-user`: accounting workflows: invoices, entries, payments, collections, reports, ledgers and journal.
4. `facturascripts-tax-iva-igic`: Spanish IVA and Canary IGIC reasoning for data validation and report interpretation.
5. `facturascripts-reporting`: recurring reports for issued/received invoices, ageing, outstanding payments, ledger and journal exports.

Use `PROMPT_GENERADOR_SKILLS.md` to generate the full multi-agent version of this collection.

## Verification checklist

Before returning a final answer or committing generated files:

- The relevant skill description includes what it does and when it should be used.
- `SKILL.md` stays concise and points to reference files instead of embedding everything.
- Examples are concrete and executable.
- Accounting operations include dry-run, validation and rollback/undo notes where feasible.
- Installation and usage instructions are present in `README.md`.
- Jose Conti attribution is preserved.
