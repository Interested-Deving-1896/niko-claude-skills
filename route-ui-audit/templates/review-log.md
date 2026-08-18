# UI Route Audit — <scope>

**Date:** <YYYY-MM-DD>
**Scope:** <app / portal / route family>
**Depth:** Sweep / Focused / Full — **reviewed <N> of <M> routes**
**Not reviewed:** <route count and which page types were sampled rather than exhausted>
**Reviewed against:** <design-system doc paths, CLAUDE.md, PRDs>
**App URL:** <running dev server or deployed URL>

> Coverage is stated, never implied. "No responsive issues" means nothing without the denominator.

---

## System-level verdict (Gate 0)

| Rule area | Verdict | Where documented / gap |
|---|---|---|
| Design tokens | Documented / Stale / Implicit / Missing | |
| Page widths, gutters, rhythm | | |
| Page templates | | |
| Repeating surfaces | | |
| Component variants and states | | |
| Button hierarchy and placement | | |
| Loading / empty / error / success | | |
| Toast behavior | | |
| Responsive behavior | | |
| Accessibility expectations | | |

**Page types documented:** <list>
**Page types actually in use:** <list>

---

## Codebase-wide passes (run once)

| Pass | Hits | Top offenders | Verdict |
|---|---:|---|---|
| Physical CSS properties (RTL) | | | |
| Raw values / `!important` / `::ng-deep` | | | |
| Swallowed errors / ad-hoc loading state | | | |

Files at the top of these counts are the routes to inspect first.

---

## Route inventory

| Route | Page type | Rep? | Desktop | Mobile | RTL | States checked | Issues | Status |
|---|---|:--:|:--:|:--:|:--:|---|---|---|
| `/customers` | Collection | ★ | ✓ | ✓ | ✓ | Loading, empty, error, populated | — | Approved |
| `/customers/:id` | Record detail | ★ | ✓ | ✓ | ✓ | Found, missing, restricted | Header differs | Changes needed |
| `/customers/:id` → edit drawer | Overlay | ★ | ✓ | ✗ | — | Pending, error | No error toast | Changes needed |
| `/suppliers` | Collection | | | | | | | Not reviewed (sweep) |

★ = representative route for its page type in a sweep. When a representative fails a checklist, every route of that page type inherits suspicion — note it and propose a focused pass on the family.

Status: **Approved** · **Changes needed** · **Blocked** · **Not reviewed (sweep)** · **Not started**

Mark a route **partial** in the States column when a state could not be reached — and say why.

---

## Mobile transformation table

What each surface becomes on a phone. An unanswered cell is a System gap — the next developer guesses.

| Surface | Desktop | Mobile | Flips at | Documented? | Verified? |
|---|---|---|---|---|---|
| Page top | | | | | |
| Toolbar / filters | | | | | |
| Toast | | | | | |
| Dialog | | | | | |
| Drawer / side panel | | | | | |
| Table / collection | | | | | |
| Form | | | | | |
| Nav | | | | | |
| Row / overflow actions | | | | | |

---

## Findings

Grouped by class, severity first. One entry per finding (format in `finding.md`).

### System gaps
### Consistency issues
### Component duplication
### Missing states
### Feedback failures
### Responsive issues
### Direction issues
### Accessibility issues
### Functional issues

---

## Promotion candidates

Patterns found independently implemented on 2+ routes that should become system components.

| Pattern | Seen on | Proposed home |
|---|---|---|

---

## Open questions for Niko

Decisions blocking the audit or the fixes.
