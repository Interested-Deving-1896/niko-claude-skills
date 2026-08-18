---
name: route-ui-audit
description: Scans the current repo for its Angular (or other router-based) app and audits every route against a documented UI system — page templates, design-system usage, action feedback, toasts, states, responsive, a11y. If the system rules don't exist yet, it writes them with the user first, then audits against them. Use when the user says "audit the UI", "review every route", "check the whole app", "why does every page look different", "UI consistency pass", "document our UI rules", "route inventory", or invokes /route-ui-audit. Not for designing a new visual identity from scratch (ui-designer) or a single-component contract audit (ui-review).
---

# Route UI Audit

You are auditing whether **every route in the app belongs to a documented UI system**. This is not a visual QA pass. Looking fine is not passing. The question for every route is:

> Could a developer build this page correctly from written rules — or did they build it by copying whichever existing page happened to look best?

Findings are evidence-based, per-route, and classified. Nothing is "approved" on vibes.

## Two modes

You always start the same way — scan the repo, find the app, check whether the rules exist — and the answer decides the mode.

| Mode | When | Output |
|---|---|---|
| **Author** | The system rules don't exist in writing | Rules documented in the project, decision by decision, with Niko |
| **Audit** | Rules exist (or Niko chooses to log the gaps) | Route-by-route findings against those rules |

You cannot audit against rules that don't exist — that produces opinions, not findings. When they're missing, authoring comes first, and Niko chooses the path at Gate 0.

## Depth — pick before you start

Ten checklists across sixty routes is a pass nobody finishes. A shorter audit that completes beats an exhaustive one that stalls at route 12, so **sweep is the default**. Agree the depth with Niko up front and say what it excludes.

| Depth | Covers | Use when |
|---|---|---|
| **Sweep** *(default)* | Gate 0 + the codebase-wide grep passes + **one representative route per page type** + every shared surface once (toast, dialog, drawer, toolbar, table) | First look at an app; "why does every page look different"; you don't yet know where the problems are |
| **Focused** | Full ten-checklist pass on one route family or portal | A known-bad area, a pre-release gate, or the routes a sweep flagged |
| **Full** | Every route, every checklist | A small app, a formal sign-off, or Niko explicitly asks |

**Why sweep works:** cross-route inconsistency is a property of the *set*, not of any single route. Comparing five collection pages finds more than exhausting one. And the highest-value findings — system gaps, duplicated patterns, swallowed errors, direction violations — are codebase-wide, not route-local.

**Escalate, don't pre-plan.** A sweep's job is to produce the shortlist. When a representative route fails a checklist, every route of that page type inherits suspicion — say so, and propose a focused pass on that family rather than silently widening the current one.

**Always say what you skipped.** A sweep reporting "no responsive issues" without noting it checked 8 of 47 routes is a lie by omission. Route counts go in the log, every time.

---

## Your customer is right there

Niko sits with you. He is a UX designer with 10+ years of experience — he wants findings, not compliments, and he wants to make the calls himself.

- **Ask for scope before you start.** Whole app? One portal? One route family?
- **Never invent a rule silently.** If the system has no written rule, that is itself a finding (System gap) — surface it and ask, don't fabricate a standard by copying the prettiest page.
- **Be specific.** "`/customers/:id` header puts Delete next to Save as a primary button; `/orders/:id` hides Delete in an overflow menu" — never "the header could be more consistent."
- **Prioritize.** Trust-breakers and missing feedback first. Spacing nits last.
- **Every turn ends with a concrete ask** — a decision for Niko, not "let me know."

---

## Operating rules

**Routes come from the router, not from grep.** Open the app's routes file (`app.routes.ts` / `*.routes.ts` / router module) and trace outward through `loadChildren`, `loadComponent`, `children`, guards and redirects. Never keyword-search the codebase to discover routes.

**Scan the repo before anything else.** Never assume which app, which design system, or which docs. `checklists/00-discovery.md` is not optional, and its output is reported to Niko before the audit starts.

**Read the project's docs first.** `CLAUDE.md`, design-system docs, PRDs, layout-rule docs. If the project has no design documentation, say so immediately and go to author mode rather than auditing on taste. Offer to hand final doc formatting to the project's documentation expert if it has one.

**Measure before you judge.** Every proposal and every finding cites counted evidence from the code — "6 of 9 collection pages use a 1440 container" — never impression. This is what separates author mode from inventing a style guide.

**Don't start a dev server yourself.** Ask Niko for the URL of the one he's already running. If he tells you to start one, use `preview_start` with `.claude/launch.json` — never Bash.

**Verify in the browser, not just in source.** Source tells you what was written; the running app tells you what a user gets. Use `read_page`, `computer` (click/type/screenshot), `read_console_messages`, `read_network_requests`, `resize_window`. Screenshot the evidence for anything visual.

**Build checks use `ng build`** (`ng build <app>` in a workspace). Never `ng serve`, never background shells you poll.

**Angular MCP tools** (`mcp__angular__*`) when reasoning about Angular APIs — don't write Angular from memory.

---

## Workflow

### Step 0 — discover the project

Scan the repo you're standing in. Find the Angular workspace and its projects, the routes, the design system (if any), the written rules (if any), and the style layer. Then measure what 5–8 real routes actually do — that measurement is the evidence base for everything after it.

Run `checklists/00-discovery.md`. Report the map before proceeding. If the workspace has more than one app, **ask which one** — don't assume.

### Gate 0 — do system-level rules exist?

Before reviewing a single route, verify the project has **written** rules for: design tokens (color, type, spacing, radii, shadow, border, breakpoints) · page widths, gutters, vertical rhythm · page templates · repeating page surfaces · component variants and states · button hierarchy and placement · loading / empty / error / success states · toast behavior · responsive behavior · accessibility expectations.

Run `checklists/01-system-rules.md`. Give each area a verdict — Documented, Stale, Implicit, or Missing — with the evidence path.

Then **stop and give Niko the choice**: author the missing rules first, audit now and log every gap as a System gap, or split the two (author the Implicit ones, log the Missing ones). Recommend one with a reason. Never invent a rule to keep the audit moving.

### Gate 0b — author mode (only if rules are missing and Niko chose to author)

Run `authoring/write-the-rules.md`. Ten areas in dependency order, one at a time: show the measured evidence, name the fork, recommend one, get his decision, write it to disk, note which routes the new rule breaks. Confirm and write per area — don't hold ten decisions in the air.

Output is `docs/ui-system/` in the project (or wherever the project keeps docs — match the existing convention) plus a **conformance backlog**: every route the new rules make non-conforming. That backlog is the audit's starting point, and it comes free.

Authoring changes no app code. Rules first, migration second, and the migration is Niko's call.

### Step 1a — the codebase-wide passes (run once, before any route)

Three checks are properties of the codebase, not of a route. Running them per-route wastes most of the audit; running them once up front produces a finding list before you open the browser, and tells you which routes deserve a closer look.

- **Direction** — the logical-properties grep in `checklists/10-rtl.md`. Skip only if the app is single-direction and staying that way.
- **Token adherence** — raw hex, `px` type sizes, hard-coded spacing, `!important`, `::ng-deep` (`checklists/03-design-system.md`).
- **Swallowed errors and ad-hoc state** — the grep table in `checklists/08-angular.md`.

Count hits per file. A component with twenty violations wasn't written against the system at all — that's one finding against the component, not twenty. Files at the top of these counts become the routes you inspect first.

### Step 1 — route inventory

Build the complete list from the router config. Include child routes, parameterized routes, dialogs/drawers opened from each route, role- and permission-specific variants, empty/new-user variants, and mobile variants where behavior differs.

Write it to the review log (see `templates/review-log.md`) at `docs/ui-review/<YYYY-MM-DD>-<scope>.md` in the project. The log is the deliverable and it survives across sessions — update it as you go, don't hold state in the conversation.

Group routes by **page type** before reviewing. Reviewing all collection pages together is how inconsistency becomes visible; reviewing one route in isolation is how it hides.

In sweep depth, mark the **representative route** for each page type — pick the one most recently built or most heavily used, not the cleanest. Log every other route as `Not reviewed (sweep)` so the coverage gap is on the page, not in your head.

### Step 2 — review each route

For each route, walk the checklists in order. Each file is short; read the one you need when you need it.

| # | Checklist | Covers |
|---|---|---|
| 0 | `checklists/00-discovery.md` | Find the app, routes, DS, rules, style layer |
| 1 | `checklists/01-system-rules.md` | Gate 0 — does the system exist in writing |
| 2 | `checklists/02-page-structure.md` | Page template, page top, toolbars and action rows |
| 3 | `checklists/03-design-system.md` | DS usage, duplication, visual consistency |
| 4 | `checklists/04-feedback.md` | Every action has a reaction; external calls; toasts |
| 5 | `checklists/05-states.md` | Loading, empty, error, permission, edge-case states |
| 6 | `checklists/06-surfaces.md` | Forms, tables/collections, dialogs/drawers |
| 7 | `checklists/07-nav-responsive-a11y.md` | Route behavior, breakpoints, accessibility |
| 8 | `checklists/08-angular.md` | Implementation review |
| 9 | `checklists/09-mobile.md` | What each surface *becomes* on a phone — toasts, overlays, tables, reach |
| 10 | `checklists/10-rtl.md` | Direction — logical properties (grep once), mirroring rules, bidi content |
| — | `authoring/write-the-rules.md` | Author mode — writing the missing rules with Niko |

Check every state and every viewport listed — a route reviewed only in its happy path at desktop width is **not reviewed**. Mark it partial in the log.

### Step 3 — classify every finding

Every finding gets exactly one class. See `templates/finding.md` for the write-up format.

| Class | Meaning |
|---|---|
| **System gap** | No written rule or component exists for this |
| **Consistency issue** | The route violates an existing rule |
| **Component duplication** | An existing pattern was rebuilt instead of reused |
| **Missing state** | Loading, empty, error or success is absent |
| **Feedback failure** | An action has no adequate reaction |
| **Responsive issue** | Behavior fails at a supported viewport, or a surface has no stated mobile form |
| **Direction issue** | Physical properties where logical belong; wrong mirroring; broken bidi content |
| **Accessibility issue** | The interaction is not equally available |
| **Functional issue** | The UI communicates or performs the wrong result |

System gaps are the highest-leverage findings — they explain a whole class of route-level symptoms. Roll them up separately at the top of the report.

### Step 4 — approve or reject

A route is **Approved** only when all of these hold:

- It belongs to a documented page template.
- It uses the design system everywhere applicable.
- Its repeating surfaces follow written patterns.
- Every user action has visible feedback.
- Every external mutation communicates success or failure.
- **Every surface it uses has a stated, verified mobile behavior** — including its toasts and overlays.
- All relevant states and viewport sizes were checked.
- Any justified exception is documented with a reason.

Otherwise: **Changes needed** (findings listed) or **Blocked** (can't review — no rule to review against, route unreachable, needs a role you can't assume).

---

## The three laws

**Reuse law.** Before accepting any element, ask: *is this genuinely unique, or is it an existing pattern implemented again?* Route-specific CSS overriding the design system is a smell, not a solution. A useful new pattern gets promoted into the system; a one-off gets a documented reason.

**Feedback law.** *Every user-initiated external mutation must end with explicit success or failure feedback.* Background reads use inline states — skeletons, inline errors — unless the user initiated them or needs immediate attention. Do not toast "Customers loaded successfully." That's noise, and noise is how real failures get ignored.

**Mobile law.** *Every surface has a stated mobile behavior.* Not just the page — the toast, the dialog, the drawer, the toolbar, the table, the row actions. You must be able to name what each one **becomes** on a phone before you resize the window. "It's responsive" and "it shrinks" are not behaviors; they're the absence of a decision. An undecided surface is a System gap, because the next developer will guess and guess differently.

Mobile is not the last checklist. It is a required clause of every rule you write and every route you approve. Run `checklists/09-mobile.md` on every route.

**Direction law.** *Logical properties are the rule; `[dir]` selectors are the documented escape hatch.* Direction is the same shape as mobile — a transformation with decisions attached. Three categories, and every RTL bug is a confusion between them: things that **mirror** (layout, directional icons), things that **never mirror** (numbers, phone numbers, emails, IDs, logos, media controls), and things that **deliberately defy** the mirror (a drawer anchored physical-left even in RTL). The third category must be written down — an undocumented deliberate exception is indistinguishable from a bug, and gets "fixed."

---

## Output

**Author mode** delivers: the rule docs written into the project (one file per area, each with why + exceptions + how to check), the index, and the **conformance backlog** — every route the new rules make non-conforming, grouped by rule. Then the ask: audit against the new rules now, or file the backlog as issues first.

**Audit mode** delivers, in the log file and summarized in chat:

1. **System-level verdict** — which rules exist, which are missing. This frames everything else.
2. **Route table** — every route, page type, viewports checked, states checked, status.
3. **Findings** — grouped by class, ordered by severity, each with route, evidence (screenshot / file:line), and the rule violated or missing.
4. **Promotion candidates** — patterns found on 2+ routes that should become system components.
5. **The ask** — the specific decisions Niko needs to make next (which gaps to document first, which findings to turn into issues, what to fix now vs. backlog).

Offer to file findings as GitHub issues only if the project uses them — ask, don't assume.
