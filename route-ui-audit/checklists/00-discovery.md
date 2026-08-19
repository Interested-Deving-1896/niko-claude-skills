# 0. Discovery — what am I actually auditing?

Run this first, always. You cannot audit a system you haven't located. Produce a written map before touching Gate 0.

Report the map to Niko before proceeding — if you found the wrong app or the wrong docs, that's a 10-second correction now and a wasted audit later.

## 0a. Find the app(s)

| Look for | Tells you |
|---|---|
| `angular.json` / `workspace.json` | Workspace root, every project, app vs. library, which is buildable |
| `projects.*.architect.build.options.styles` | Global style entry points — the token/theme files live near here |
| `stylePreprocessorOptions.includePaths` | Shared SCSS roots |
| `budgets` | Whether anyone is enforcing size |
| `package.json` | Angular version, UI deps (Material, Tailwind, PrimeNG, a toast lib), icon set |
| `nx.json` / `pnpm-workspace.yaml` / multiple `angular.json` | Monorepo — ask which app is in scope, don't assume |

If there is more than one app, **stop and ask which one**. Auditing the wrong app in a workspace is the most common way this goes sideways.

If there is no `angular.json`: identify the framework from `package.json` and say so plainly. The checklists still apply — only checklist 08 is Angular-specific.

## 0b. Find the routes

`app.routes.ts`, `*-routing.module.ts`, `*.routes.ts`. Trace through `loadChildren`, `loadComponent`, `children`, `redirectTo`, guards. Never grep for route strings — read the router.

Note route count and depth. That sizes the audit and tells you whether to scope down before starting.

## 0c. Find the design system

| Look for | Tells you |
|---|---|
| `projects/*` or `libs/*` with a `ui`/`ds`/`design` name | A real DS library exists |
| `src/styles/`, `_tokens.scss`, `_variables.scss`, `:root { --… }` | Token layer, and whether it's CSS custom props or SCSS vars |
| A `shared/components` or `ui/` folder inside the app | Components that were *meant* to be shared but never left the app |
| `.storybook/`, a `/developer/ds` or `/demo` route | A living component gallery — open it |
| Component `index.ts` / public API barrel | What's actually exported vs. internal |

Count: how many components does the DS expose, and how many components live in route folders? That ratio is the headline number for the whole audit.

## 0d. Find the written rules

- `CLAUDE.md` (root and nested) — often the only place rules are written
- `docs/`, `documentation/`, `README.md`, `CONTRIBUTING.md`
- Any `*.md` matching: design, ui, ux, ds, token, style, brand, guideline, pattern, layout, component, prd
- Comment headers in the token files — sometimes the only spec that exists

For each document: **is it current?** Verify a sample of its claims against the code before trusting it. A stale doc is worse than a missing one, because it gets cited. Stale docs get fixed, not ignored — but verify against code first.

## 0e. Sample the reality

Before judging anything, measure what the code already does. Pick 5–8 routes across different page types and record:

- Page container max-width / full-width, and the source of that value
- Where the page title lives and what type style it uses
- Whether the page top is a shared component or hand-built
- Which spacing values appear (tokens vs. raw px)
- Whether the route imports DS components or native controls
- Whether a toast fires on save

This is the evidence base. In audit mode it produces findings; in authoring mode it produces the proposals. Either way, you now speak from measurement instead of impression.

## Output

```
App: <name> at <path>  ·  Angular <version>  ·  <N> routes across <M> page types
Design system: <lib path or "none — components live in route folders">
  Exposed DS components: <N>   Route-local components: <M>
Written rules found: <paths, with current/stale verdict>
Style layer: <CSS custom props / SCSS vars / neither>  ·  UI deps: <list>
Measured reality: <the 5–8 route sample, as a small table>
```

Then hand off to `01-system-rules.md`.
