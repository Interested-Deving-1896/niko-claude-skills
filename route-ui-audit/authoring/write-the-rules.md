# Authoring mode — writing the rules with Niko

Entered when Gate 0 finds Implicit or Missing areas and Niko chooses to author. The output is a set of documents in the project that a developer can build from, and that a future audit can be run against.

You are not writing a style guide. You are writing **the thing the audit checks against**. If a rule can't be checked in a review, it isn't a rule yet — rewrite it until it can be.

---

## The rules of authoring

**Propose from evidence, never from taste.** Every proposal starts with what the code already does, measured in discovery. "Six of nine collection pages use a 1440px container; `/reports` and `/settings` are full-width, `/inbox` is 1200." That's a proposal. "I suggest 1440px" is not.

**Niko decides. You draft.** He's a UX designer with 10+ years — he has opinions and they outrank your defaults. Your job is to surface the fork clearly, recommend one option with a reason, and write down what he picks.

**Never pick the prettiest page as the standard silently.** That's the exact failure this whole skill exists to catch. If the majority pattern is bad, say it's the majority *and* that it's bad, then let him choose.

**One area at a time. Confirm, then write, then move on.** Don't hold ten decisions in the air and dump one giant document at the end. Each confirmed area gets written to disk immediately — the session survives interruption, and Niko sees progress.

**Every rule needs a "why".** A rule without a reason gets overridden by the first developer who disagrees. One sentence is enough.

**Write down the exceptions too.** "Full-width is allowed for calendar and workspace pages, because a fixed container wastes the horizontal space those views exist to use." An undocumented exception becomes tomorrow's inconsistency.

**No rule is finished until it answers mobile.** Every area below has a mobile clause, and a rule that only describes the desktop form is half a rule. Ask it explicitly, every time: *what does this become on a phone?* If the honest answer is "nothing changes," write that down — "unchanged below 768" is a decision. "We'll see" is not, and it's how a design system quietly becomes desktop-only.

**Don't over-specify.** Ten rules that are followed beat forty that are ignored. If Niko doesn't care about an area, record "no rule, deliberate" and move on — that's a legitimate outcome and it stops the next audit from re-raising it.

---

## Order of authoring

Dependency order. Later areas reference earlier ones, so authoring out of order produces contradictions.

| # | Area | Depends on |
|---|---|---|
| 1 | Design tokens | — |
| 2 | Page widths, gutters, vertical rhythm | tokens |
| 3 | Page-type catalog (templates) | widths |
| 4 | Repeating surfaces (page top, toolbar, section, empty state) | templates |
| 5 | Component variants and states | tokens |
| 6 | Button hierarchy and placement | variants, surfaces |
| 7 | Loading / empty / error / success states | surfaces |
| 8 | Toast behavior | states |
| 9 | Responsive behavior | widths, templates |
| 10 | Accessibility expectations | all |
| 11 | Direction (RTL/LTR) — *only if the app is or may become bidirectional* | tokens, layout, surfaces |

Skip any area already Documented. For Stale areas, verify against code and rewrite rather than authoring fresh.

Area 9 is not where mobile gets handled — it's where the **breakpoints and the transformation table** get recorded. The mobile *decisions* are made inside areas 2–8, as each surface is defined. By the time you reach 9, you should be writing down choices already made, not discovering that nobody made them.

### The mobile clause per area

| Area | The question that must be answered |
|---|---|
| 1 Tokens | Do type, spacing or density change on small screens, or is the scale fluid? |
| 2 Layout | Gutters and vertical rhythm on a phone; where the container rule stops applying |
| 3 Page types | What each page type becomes on mobile — the transformation, per type |
| 4 Surfaces | Page top: primary action stays inline, sticky bar, FAB, or overflow? Toolbar: sheet, collapse, or scrolling chips? |
| 5 Components | Which variants exist only for touch; minimum target size; the tap equivalent of every hover affordance |
| 6 Actions | Reach — where the primary action lives on a phone; how destructive actions stay separated without hover |
| 7 States | Skeletons and empty states at 375px; error states that don't push actions off-screen |
| 8 Toasts | Position, width, stacking limit, safe-area insets, keyboard collision, and what an actionable toast becomes |
| 9 Responsive | Breakpoints, and the full transformation table collected from 2–8 |
| 10 Accessibility | Touch targets, focus with an on-screen keyboard, zoom without breaking |
| 11 Direction | Which surfaces keep a physical anchor on mobile, where the mirror and the small screen disagree |

Area 11 records: which direction is primary, whether both are supported, that logical properties are mandatory, when a `[dir]` selector is acceptable, and the list of deliberate physical-anchor exceptions with reasons. If the app is single-direction and staying that way, record "single-direction, deliberate" and move on.

---

## The per-area loop

For each area, in one exchange:

**1. Show the evidence.** What the code does today, counted. Include the outliers by name — the outliers are the interesting part.

**2. Name the fork.** Usually two or three real options. If there's a dominant existing pattern, say so; if the code is genuinely all over the place, say that too.

**3. Recommend one, with a reason.** A recommendation you'd defend, not a hedge. Put it first.

**4. Get the decision.** Use a question with concrete options when it's a clean fork; ask openly when it isn't.

**4b. Ask the mobile clause.** Same exchange, before writing: what does this become on a phone? Use the table above for the question that fits the area. Don't defer it to area 9 — deferred mobile decisions are never made, they're inherited.

**5. Write it.** Append the confirmed rule to the area's doc, with the why, the exceptions, **the mobile form**, and how to check it. Show Niko the written rule, not a summary of it.

**6. Note the migration cost.** "This makes 3 routes non-conforming: `/reports`, `/settings`, `/inbox`." That's the audit backlog forming as you go — capture it, don't fix it now.

Do not batch steps 1–4 across multiple areas. One area, one decision, one write.

---

## What good rules look like

Testable, with a why and named exceptions:

> **Page container.** Content pages use `max-inline-size: 1440px`, centered, with `--space-gutter` inline padding.
> *Why:* line lengths past ~1440 break scanability on the data-dense pages that dominate this app.
> *Exceptions:* calendar, planning and full-screen workspace pages go edge-to-edge — a fixed container wastes the horizontal space those views exist to use.
> *Mobile:* below 768 the container rule stops applying; gutter drops to `--space-gutter-sm`. Edge-to-edge below 480.
> *Check:* the page's outermost element uses `.page-container` or the page-shell component.

> **Toasts.** Every user-initiated external mutation ends with a success or failure toast. Reads never toast — they use inline skeletons and inline error states.
> *Why:* toasting reads produces noise, and noise is how real failures get ignored.
> *Exception:* a user-triggered manual refresh may toast on failure, since the user is waiting on it.
> *Mobile:* bottom-anchored, full-bleed minus gutter, above the safe-area inset and above any sticky action bar; max 2 stacked; long text wraps rather than truncates. Actionable toasts ("Retry") get a 44px target. Anything the user must act on also persists somewhere that isn't transient.
> *Check:* any toast call in a read path is a violation; any mutation path with no toast is a violation; at 375px a toast overlapping the primary action is a violation.

Not rules:

- "Use consistent spacing." — Not checkable.
- "Pages should feel clean." — Not checkable.
- "Prefer the design system." — No teeth. Say what happens when it doesn't have what you need.
- "Mobile-friendly." / "Responsive." — Names no transformation. Say what it becomes and at what width.

---

## Where it gets written

Default: `docs/ui-system/` in the project, one file per area, plus `README.md` as the index.

```
docs/ui-system/
  README.md                 index + how to use these rules in review
  01-tokens.md
  02-layout.md              widths, gutters, vertical rhythm
  03-page-types.md          the catalog + which routes are which
  04-surfaces.md            page top, toolbar, section, empty state
  05-components.md          variants and states
  06-actions.md             button hierarchy and placement
  07-states.md              loading / empty / error / success
  08-toasts.md
  09-responsive.md
  10-accessibility.md
```

Ask first if the project keeps docs elsewhere — match the existing convention rather than imposing this one. If the project has a docs expert or documentation skill, offer to hand off the final formatting to it.

Each file gets a header: date authored, who decided (Niko), and status (`agreed` / `provisional`). Provisional means Niko wants to see it in practice before committing — mark it, and re-raise it at the next audit.

---

## Finishing

When the areas are done:

- Write `docs/ui-system/README.md` — the index, plus one paragraph on how these rules are used in a route audit.
- Produce the **conformance backlog**: every route that the newly written rules make non-conforming, grouped by rule. This is the audit's starting point and it came free.
- Tell Niko what's now checkable that wasn't before.
- Ask whether to run the route audit now against the new rules, or to file the conformance backlog as issues first.

Authoring does not change any app code. Rules first, migration second, and the migration is Niko's call.
