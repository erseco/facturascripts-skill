---
name: facturascripts-api-user
description: >
  Helps use the FacturaScripts REST API safely for operational tasks: discovering resources, filtering, pagination, invoices, payments, exports and MCP/API clients. Use when the user asks to consult or update FacturaScripts data through /api/3 as an authenticated user.
---

# FacturaScripts API User

Use this skill for safe operational usage of the FacturaScripts REST API.

## Read first

| Task | Reference |
| --- | --- |
| API basics | `../../references/api.md` |
| Accounting API workflows | `../../references/accounting-api-workflows.md` |
| Models and field names | `../../references/models.md` |
| Security and API keys | `../../references/security.md` |

## Rules

- Discover resources with `/api/3` or Swagger before assuming endpoint names.
- Use the `Token` header for API-key authentication when available.
- Use read-only keys for reports.
- Never print or store tokens.
- For writes, show endpoint, payload summary, validations and dry-run first.
- Prefer form URL encoded payloads unless the endpoint schema says otherwise.
- Paginate list queries and record filters used.

## Useful prompts

- List issued invoices for this quarter and group totals by customer.
- Create a dry-run payload for a supplier invoice from this CSV.
- Mark this customer invoice as paid after validating receipts and payment method.
- Build MCP tools for customers, suppliers, invoices, payments, journal and ledger.
