---
name: facturascripts-accounting-user
description: >
  Helps accounting users operate FacturaScripts with invoices, payments, collections, journal entries, ledgers, accounting journal, subaccounts and reports. Use when the user asks to account invoices, upload entries, consult ledgers or obtain accounting information through FacturaScripts.
---

# FacturaScripts Accounting User

Use this skill for accounting workflows as an operational user.

## Read first

| Task | Reference |
| --- | --- |
| Accounting/API workflow | `../../references/accounting-api-workflows.md` |
| Accounting models | `../../references/models.md` |
| API usage | `../../references/api.md` |
| Exports and accounting libraries | `../../references/libraries.md` |

## Rules

- Treat accounting writes as high risk.
- Always prepare a dry-run before creating entries, payments or invoices.
- Do not invent subaccounts, journals, exercises, tax codes, customers, suppliers or payment methods.
- Validate that debit equals credit before proposing any journal entry.
- Validate date, exercise and journal before posting.
- Prefer business operations that generate accounting automatically over direct `Asiento`/`Partida` writes.
- State clearly whether data is read, written, simulated or exported.

## Useful prompts

- Prepare a dry-run for this manual journal entry and check that it balances.
- Get the ledger for subaccount 4300001 from 2026-01-01 to 2026-03-31.
- Generate the accounting journal for Q1 2026 and flag unbalanced entries.
- Validate pending collections and payments by due date.
