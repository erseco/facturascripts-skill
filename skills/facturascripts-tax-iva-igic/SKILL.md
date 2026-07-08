---
name: facturascripts-tax-iva-igic
description: >
  Helps validate IVA, IGIC, retentions, exemptions, reverse charge, issued invoices and received invoices in FacturaScripts without replacing tax advice. Use when the user asks about Spanish VAT, Canary IGIC, tax breakdowns or fiscal validation inside FacturaScripts.
---

# FacturaScripts Tax IVA/IGIC

Use this skill to reason about tax data in FacturaScripts. It does not replace professional tax advice.

## Read first

| Task | Reference |
| --- | --- |
| Tax checks in workflows | `../../references/accounting-api-workflows.md` |
| Tax and invoice models | `../../references/models.md` |
| Invoice reports | `../../references/accounting-api-workflows.md` |

## Rules

- Do not hardcode current tax rates unless they were verified against an authoritative source and the verification date is stated.
- Ask for territory when missing: mainland/Balearic IVA, Canary IGIC, Ceuta/Melilla, EU or non-EU.
- Do not treat IGIC as IVA with a different percentage.
- Distinguish subject, exempt, non-subject, reverse-charge, retention and deductible quota.
- Separate accounting mechanics from tax/legal advice.
- For filings or legally sensitive decisions, require accountant review.

## Useful prompts

- Check whether this invoice looks like IVA or IGIC and what data is missing.
- Validate tax breakdowns for issued invoices in Q1.
- Review received invoices and separate tax quota from deductible quota when data exists.
- Flag possible reverse-charge cases without making final tax determinations.
