# 8. Angular implementation review

This layer explains *why* the UI findings exist. A route that reimplements state handling will drift again after it's fixed once — fix the layer, not the symptom.

- [ ] Route components use established page shells and layouts
- [ ] Shared UI lives in reusable components rather than route templates
- [ ] Components have clear inputs, outputs and responsibilities
- [ ] Similar state handling is not reimplemented on every route
- [ ] API state exposes loading, success and failure explicitly
- [ ] Subscriptions and effects are cleaned up correctly
- [ ] Signals/observables update the UI predictably
- [ ] `track` (or `trackBy`) is used for repeated collections
- [ ] Change detection does not rely on accidental mutation
- [ ] Route loading and permissions use consistent guards/resolvers where appropriate
- [ ] Errors are not swallowed in services
- [ ] Toasts are triggered from the correct operation boundary
- [ ] Shared components stay domain-neutral where possible
- [ ] Route-specific CSS does not override the design system unnecessarily

## Signals worth grepping

| Grep | What it usually means |
|---|---|
| `catchError(() => of(` | Error swallowed — the UI can never show a failure |
| `loading = true` in a component | Ad-hoc state handling instead of a shared API-state pattern |
| `::ng-deep` / `!important` | Reaching into DS internals; the variant doesn't exist |
| `subscribe(` without `takeUntilDestroyed` / async pipe | Leak, and stale updates after navigation |
| `@for` without `track` | Re-render churn, lost focus and scroll on refresh |
| Toast call inside a component that also calls the API | Feedback boundary is fine — but check it isn't *also* toasted in the service (duplicate toasts) |

## Verification

Compile with `ng build` (`ng build <app>` in a workspace). Never `ng serve` as a check, and never leave background shells to poll.

Use the Angular MCP tools (`mcp__angular__*`) when reasoning about current Angular APIs rather than writing from memory — control flow, signals, and lifecycle APIs move fast.

## Scope discipline

This checklist produces findings, not refactors. Don't rewrite code during an audit unless Niko asks. Log the finding, name the layer to fix, move to the next route.
