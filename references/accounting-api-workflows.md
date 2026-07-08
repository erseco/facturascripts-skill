# FacturaScripts accounting and API workflows

Use this reference when the task is to operate FacturaScripts as an accounting user, accountant assistant or API automation agent: invoices, collections, payments, journal entries, ledgers, tax reports, issued invoices, received invoices and accounting exports.

This file is not tax or legal advice. It is an operational checklist for using FacturaScripts safely. For current IVA, IGIC, IRPF, SII, Verifactu or local rules, verify with authoritative sources and the user's accountant before filing or posting irreversible data.

## Core entities to inspect first

Before building queries or payloads, discover the real resources and fields in the target installation:

1. `GET /api/3` to list resources.
2. If installed, `GET /swagger?action=get-json` from the `DocumentacionAPI` plugin.
3. If a resource schema endpoint is available, inspect it before writing.
4. Check enabled plugins because accounting, reporting and tax behavior may change.

Common model names to look for:

- Sales: `FacturaCliente`, `FacturaClienteLinea`, `ReciboCliente`, `PagoCliente`, `Cliente`.
- Purchases: `FacturaProveedor`, `FacturaProveedorLinea`, `ReciboProveedor`, `PagoProveedor`, `Proveedor`.
- Accounting: `Ejercicio`, `Diario`, `Cuenta`, `Subcuenta`, `Asiento`, `Partida`, `CuentaEspecial`.
- Taxes: `Impuesto`, `ImpuestoZona`, `Retencion`.
- Company configuration: `Empresa`, `Serie`, `FormaPago`, `Divisa`.

Do not assume resource slugs. FacturaScripts usually exposes plural lower-case resources and custom endpoints, but the installed API is the source of truth.

## Authentication baseline

- API base path: `https://example.com/api/3`.
- Use the API key in the `Token` header when available.
- Use least-privilege API keys. Separate read-only reporting keys from write keys.
- Never print or commit tokens.
- Prefer HTTPS.

Example read request:

```bash
curl -sS \
  -H "Token: $FACTURASCRIPTS_TOKEN" \
  "$FACTURASCRIPTS_URL/api/3"
```

Example form-encoded write request:

```bash
curl -sS -X POST \
  -H "Token: $FACTURASCRIPTS_TOKEN" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "codcliente=1" \
  --data-urlencode 'lineas=[{"descripcion":"Servicio profesional","cantidad":1,"pvpunitario":100,"codimpuesto":"IVA21"}]' \
  "$FACTURASCRIPTS_URL/api/3/crearFacturaCliente"
```

## Query pattern for reports

Use `limit`, `offset`, `filter[...]` and `sort[...]`.

Typical period filter pattern, after verifying the date field exists:

```text
GET /api/3/<resource>?filter[fecha_gte]=2026-01-01&filter[fecha_lte]=2026-03-31&sort[fecha]=ASC&limit=500&offset=0
```

Known operator suffixes in the public API documentation include:

- Exact match: `filter[field]=value`
- Greater than: `filter[field_gt]=value`
- Greater or equal: `filter[field_gte]=value`
- Less than: `filter[field_lt]=value`
- Less or equal: `filter[field_lte]=value`
- Not equal: `filter[field_neq]=value`
- Contains: `filter[field_like]=value`

For large exports, paginate until fewer records than `limit` are returned, and capture `X-Total-Count` when the HTTP client exposes response headers.

## Creating invoices

When the custom endpoint exists, prefer it over manual model CRUD because it calculates totals and lines consistently.

Sales invoice:

```text
POST /api/3/crearFacturaCliente
codcliente=<customer-code-or-id>
lineas=<json-lines>
```

Supplier invoice:

```text
POST /api/3/crearFacturaProveedor
codproveedor=<supplier-code-or-id>
lineas=<json-lines>
```

Line fields normally include either `referencia` or `descripcion`. Optional fields may include `cantidad`, `pvpunitario`, discounts, tax code and retention fields. Verify the current schema before writing.

Always return a dry-run table before creation:

| Field | Value |
| --- | --- |
| Customer/supplier | ... |
| Date | ... |
| Lines | ... |
| Tax regime | IVA / IGIC / exempt / reverse charge / unknown |
| Net total | ... |
| Tax total | ... |
| Gross total | ... |
| Payment status | paid / unpaid / unknown |

After creation, read the returned `doc` and `lines` object because FacturaScripts may assign final numbers, codes and calculated totals.

## Marking invoices as paid or unpaid

When available, use:

```text
POST /api/3/pagarFacturaCliente/{id}
POST /api/3/pagarFacturaProveedor/{id}
```

Typical form fields:

```text
fechapago=YYYY-MM-DD
codpago=<payment-method-code>
pagada=1
```

Before calling payment endpoints:

1. Read the invoice and its receipts.
2. Check pending amount, currency and due dates.
3. Confirm payment method exists in `FormaPago`.
4. Confirm the payment date belongs to an open accounting period.
5. Produce a dry-run summary.

## Creating accounting entries

Treat direct journal-entry creation as high risk. Prefer existing FacturaScripts business operations when they generate entries automatically. Only create `Asiento`/`Partida` directly when the user explicitly asks for a manual journal entry and provides enough accounting data.

Minimum validation:

- Accounting date belongs to an open `Ejercicio`.
- `Diario` exists.
- Every `Subcuenta` exists and is active for the exercise.
- Debit equals credit, with currency and rounding rules applied.
- Tax-related entries reconcile with invoice tax bases and tax quotas.
- Supporting document or concept is linked when possible.
- User confirms the final entry.

Dry-run format:

| Date | Account | Description | Debit | Credit | Third party | Tax | Document |
| --- | --- | --- | ---: | ---: | --- | --- | --- |
| ... | ... | ... | ... | ... | ... | ... | ... |
| **Total** | | | **0.00** | **0.00** | | | |

Never balance an entry by inventing a suspense account unless the user explicitly instructs it and confirms.

## Diario contable

For a journal report:

1. Identify period: start date, end date and exercise.
2. Query entries (`Asiento`) by date and optionally journal.
3. Query lines (`Partida`) for the returned entry IDs.
4. Join with `Subcuenta` descriptions.
5. Sort by date, entry number and line order.
6. Validate each entry balances.

Recommended output columns:

```text
fecha, asiento, diario, subcuenta, descripcion_subcuenta, concepto, debe, haber, documento, tercero, punteada
```

## Mayor contable

For a ledger report:

1. Require or infer an account/subaccount range.
2. Query `Partida` filtered by subaccount and period.
3. Join the parent `Asiento` for date and journal.
4. Calculate opening balance from prior lines if requested.
5. Calculate running balance with the correct sign convention for the account class.
6. Include totals debit, credit and final balance.

Recommended output columns:

```text
fecha, asiento, diario, concepto, debe, haber, saldo, documento, tercero
```

## Issued invoice report

For facturas expedidas:

1. Query `FacturaCliente` for the period.
2. Include rectifying invoices separately when identifiable.
3. Join customer fiscal name and NIF when available.
4. Include tax bases by tax code/rate if lines or tax breakdowns are available.
5. Split paid, pending and overdue totals when receipts are available.

Recommended output columns:

```text
fecha, codigo, numero, serie, cliente, nif, base, impuesto, cuota, retencion, total, pagada, vencimiento, forma_pago
```

## Received invoice report

For facturas recibidas:

1. Query `FacturaProveedor` for the period.
2. Include supplier invoice number and reception/accounting date if available.
3. Join supplier fiscal name and NIF.
4. Include deductible tax quota only when the data supports it.
5. Separate rectifying invoices and reverse-charge cases.

Recommended output columns:

```text
fecha, numproveedor, codigo, proveedor, nif, base, impuesto, cuota, cuota_deducible, retencion, total, pagada, vencimiento, forma_pago
```

## IVA and IGIC checks

When the user mentions IVA or IGIC:

- Determine territory: mainland/Balearic IVA, Canary IGIC, Ceuta/Melilla IPSI, intra-EU, export, import or non-taxable.
- Determine role: supplier, customer, issuer, recipient, reseller, professional, public administration, intra-community operator.
- Determine tax status: subject, exempt, non-subject, reverse charge, zero rate, reduced rate, recargo, retention.
- Do not hardcode current rates unless recently verified.
- Keep tax code handling separate from account-code handling.
- For Canary operations, do not treat IGIC as IVA with a different rate; validate reports and models separately.

## Safe answer pattern for user-facing operations

When the user asks to perform an accounting/API task, respond in this order:

1. Restate the operation and period.
2. State what will be read and what will be written.
3. Show the exact filters or payload fields.
4. Show dry-run results.
5. Ask for confirmation for writes, unless the instruction already clearly authorizes execution.
6. Execute, then read back and reconcile.
7. Return a concise report with IDs, totals, warnings and next checks.

## Error handling

- `400`: missing mandatory field or malformed payload.
- `401/403`: token missing, invalid or lacking permissions.
- `404`: resource, document, customer, supplier or warehouse not found.
- `409/422`: model validation, blocked period, failed recalculation or business rule error.

Return the raw API message when useful, but translate it into an operational next step.

## Security and audit trail

- Log every write with timestamp, endpoint, target ID, dry-run hash or summary and actor.
- Prefer idempotent imports using external references where available.
- For bulk operations, create a CSV/JSON preview and process in batches.
- Stop on the first unreconciled accounting difference.
- Store generated reports separately from API credentials.
