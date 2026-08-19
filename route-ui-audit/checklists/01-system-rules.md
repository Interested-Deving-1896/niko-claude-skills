# 1. System-level rules (Gate 0)

Run after `00-discovery.md`. You are checking whether the rules exist **in writing** — not whether the app happens to be consistent.

Test: can you answer "How should this page look and behave?" from documentation alone, without opening another page to copy it?

## The ten areas

- [ ] Design tokens: colors, typography, spacing, radii, shadows, borders, breakpoints
- [ ] Standard page widths, gutters, vertical spacing
- [ ] Standard page templates (the catalog of page types)
- [ ] Repeating page surfaces (page top, toolbar, section, empty state, …)
- [ ] Component variants and states
- [ ] Button hierarchy and placement
- [ ] Loading, empty, error and success states
- [ ] Toast behavior — when to toast, when not to
- [ ] Responsive behavior and supported breakpoints
- [ ] Accessibility expectations

## Verdict per area

| Verdict | Meaning | Consequence |
|---|---|---|
| **Documented** | Written, findable, and true of the code | Audit against it |
| **Stale** | Written but contradicted by the code | Verify against code, fix the doc, then audit |
| **Implicit** | Consistent in code, never written down | System gap — cheap to fix, write it down with Niko |
| **Missing** | Neither written nor consistent | System gap — needs a decision, not documentation |

**An area documented for desktop only is not Documented.** Every one of the ten areas has a mobile clause (see the table in `authoring/write-the-rules.md`). If the rule says what a toast or a drawer does on a large screen and is silent about a phone, the verdict is **Partial** — half the rule exists, and the missing half is where the guessing happens. Record it as `Documented (desktop only)` and treat the mobile half as Implicit or Missing on its own merits.

The Implicit/Missing distinction drives everything downstream. Implicit means the team already agreed and just never wrote it — you propose, Niko confirms, done in a minute. Missing means there is no agreement to record, and Niko has to actually decide.

## Page-type catalog

The project should name its page types. Typical set:

collection/list · record detail · create/edit form · dashboard · settings · workflow or stepper · calendar or planning view · full-screen workspace · public/auth page · system state (unauthorized, not found, unavailable)

Map every route from discovery onto a type. Routes that fit nothing are either candidates for a new documented template or one-offs that should be folded into an existing type. That list is an input to authoring.

## The branch

Count the verdicts.

**All ten Documented (or Stale)** → audit mode. Fix stale docs, then run the route audit.

**Any Implicit or Missing** → stop. Report the verdict table and tell Niko plainly:

> An audit against undocumented rules produces opinions, not findings. <N> of 10 areas have no written rule.

Then offer the choice:

- **(a) Author first** — run `authoring/write-the-rules.md` with Niko for the missing areas, then audit against real rules. Slower, and the only path that makes the audit repeatable by someone else.
- **(b) Audit now, log gaps** — every undocumented area becomes a System gap finding. Faster, and produces a prioritized authoring backlog instead of documentation.
- **(c) Split** — author the areas that are Implicit (cheap, you already have the evidence), log the Missing ones as gaps.

Recommend **(c)** when most gaps are Implicit — it's the highest ratio of system value to Niko's time. Recommend **(a)** when Missing dominates, because an audit would otherwise be one long list of "no rule exists."

**Let Niko choose. Don't pick for him, and never invent a rule to keep the audit moving.**

## Output of this gate

- Verdict table, ten rows, each with evidence path or "none found"
- Page types documented vs. page types actually in use
- Count: N documented / N stale / N implicit / N missing
- The explicit choice above, as the turn's ask
