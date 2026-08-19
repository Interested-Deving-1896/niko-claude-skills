# Finding format

Every finding gets exactly one class, one route, and evidence. No evidence → not a finding, it's an opinion.

```md
### F-012 · Feedback failure · `/orders/:id`

**What:** "Mark as shipped" calls `PATCH /api/orders/:id` and shows nothing on failure — the
button returns to idle and the row keeps the old status. The user believes it worked.

**Evidence:** `read_network_requests` shows the 500; no toast fired.
`src/app/pages/order-detail/order-detail.component.ts:184` — `catchError(() => of(null))`.
Screenshot: `docs/ui-review/evidence/f-012-after-failure.png`

**Rule:** Feedback law — every user-initiated external mutation ends with explicit success or
failure feedback. Also `docs/ds/toasts.md#errors`.

**Fix layer:** Component (error path) — but the same swallow exists in 4 other routes, so the
real fix is a shared API-state pattern. See F-003.

**Severity:** High — silent data-state divergence.
```

## Severity

| Level | Meaning |
|---|---|
| **Critical** | The user is misinformed about what happened, or loses work |
| **High** | Action has no feedback; a state is missing; route unusable at a supported viewport or for a supported role |
| **Medium** | Real inconsistency or duplication a user would notice across routes |
| **Low** | Polish inside an otherwise correct pattern |

## Rules

- **One class per finding.** If it's both duplication and a missing state, that's two findings.
- **Name the fix layer** — token, component, template, route, service. A page-level symptom almost always traces to a lower layer; fixing it at the page is how the next route inherits the bug.
- **Link repeats.** Five routes with the same swallow is one system finding plus five references, not five findings.
- **Quote the rule violated.** If no rule exists to violate, the class is System gap — not Consistency issue.
- **No fixes during the audit** unless Niko asks for them.
