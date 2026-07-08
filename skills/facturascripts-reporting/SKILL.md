---
name: facturascripts-reporting
description: >
  Helps generate reproducible FacturaScripts reports for issued invoices, received invoices, payments, collections, accounting journal, ledgers, ageing and exports. Use when the user asks for accounting, billing or payment reports from FacturaScripts data.
---

# FacturaScripts Reporting

Use this skill for reports and exports based on FacturaScripts data.

## Read first

| Task | Reference |
| --- | --- |
| Report workflow | `../../references/accounting-api-workflows.md` |
| API filters and pagination | `../../references/api.md` |
| Models and joins | `../../references/models.md` |
| Export libraries | `../../references/libraries.md` |

## Rules

- Every report must state period, filters, source resources and generation date.
- Separate net base, tax quota, retention, gross total, paid amount and pending amount.
- Paginate API queries.
- Do not hide excluded records; report exclusions and assumptions.
- Validate totals against lines or document headers when possible.
- For accounting reports, flag unbalanced entries.

## Useful prompts

- Generate issued invoices report for Q1 2026 grouped by customer and tax code.
- Generate received invoices report by supplier with paid and pending totals.
- Export the accounting journal for March 2026 as CSV.
- Create a ledger report with opening balance, movements and closing balance.
