# Cashew comparison: source reports

This folder holds the detailed, code-level findings behind [`../CASHEW_COMPARISON.md`](../CASHEW_COMPARISON.md).

**Published page of the comparison:**
https://claude.ai/code/artifact/b10a4f6f-37b4-48ec-baab-3aa84577e248

Analysis date: 2 September 2026.
Cashew analysed at version 5.4.3+416, schema 46, from https://github.com/jameskokoska/Cashew (shallow clone of `main`).
The Accountant analysed at version 3.0.0+21, schema 17.

| Report | What it covers |
|---|---|
| [CASHEW_DATA_MODEL.md](CASHEW_DATA_MODEL.md) | Every Drift table, enum, and the domain logic in Cashew: transaction special types, `paid` semantics, recurring engine, one-time and long-term loans, objectives, wallets and transfers, budgets and category limits, categories and associated titles, deletion and Drive sync. |
| [CASHEW_FEATURE_INVENTORY.md](CASHEW_FEATURE_INVENTORY.md) | Cashew from the user's side: every page, home-page section, add-transaction control, filter, bulk action, budget view, wallet view, import/export path, notification, theme, integration, monetization gate, and a verified list of what Cashew does not do. |
| [ACCOUNTANT_DATA_MODEL.md](ACCOUNTANT_DATA_MODEL.md) | Every Drift table, enum, and migration in The Accountant: `TransactionPolicy`, `isPaid` and `paidAmount` semantics, transfers with fees, recurring configs and occurrence keys, credit/debt repayment flow, objectives, wallet balance service, budgets, categories with slugs, sync protocol and backend push/pull handlers, plus a list of gaps and oddities found in the model. |
| [ACCOUNTANT_FEATURE_INVENTORY.md](ACCOUNTANT_FEATURE_INVENTORY.md) | The Accountant from the user's side: shell and dashboard, transaction flows, wallets, categories, budgets, objectives, reports, AI, notifications, auth, sync, security, premium, themes and localization, onboarding, settings tree, platform support, full screen list, backend endpoint list, and a gap table against Cashew with YES/PARTIAL/NO per feature. |

File paths in the Cashew reports are relative to the `budget/` folder of the Cashew repository. File paths in the Accountant reports are relative to `the_accountant/` (Flutter) or `the-accountant-backend/src/` (backend).
