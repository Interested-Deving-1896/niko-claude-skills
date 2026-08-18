# 3. Design-system usage and visual consistency

## 3a. Design-system usage

The central question for every visible element:

> Is this genuinely unique, or is it an existing pattern implemented again?

- [ ] Existing design-system components are used where applicable
- [ ] Native HTML or third-party components have not recreated an existing system component
- [ ] Similar elements across routes use the same component
- [ ] Component variants are used instead of route-specific CSS overrides
- [ ] Colors, sizes and spacing use design tokens
- [ ] Icons come from the approved icon set
- [ ] Typography uses named styles rather than arbitrary values
- [ ] No unexplained magic numbers in page styling
- [ ] New patterns are reusable beyond this route
- [ ] Useful new patterns are promoted into the design system
- [ ] One-off exceptions are documented with a reason

### How to actually check this

Grep the route's SCSS for raw values — hex colors, `px` font sizes, hard-coded spacing, `!important`, and `::ng-deep` / `:host ::ng-deep` reaching into DS internals. Each hit is either a token that should exist or a variant that should exist. Both are findings; the classes differ (System gap vs. Consistency issue).

Then grep the template for native controls (`<select>`, `<input type=…>`, `<button>`, `<dialog>`, `<table>`) where a DS component exists. Hand-rolled controls are the most common duplication.

## 3b. Visual consistency

- [ ] Spacing follows the established scale
- [ ] Alignment is deliberate across sections and columns
- [ ] Similar content has the same visual hierarchy
- [ ] Cards, panels and sections follow consistent containment rules
- [ ] Borders and dividers are used consistently
- [ ] Labels, helper text and metadata have consistent styling
- [ ] Status colors and badges carry the same meaning everywhere
- [ ] Icon-only buttons share size, padding and tooltip behavior
- [ ] Density is appropriate for the page type
- [ ] The page is not visually louder than its importance requires
- [ ] Hover, focus, active, selected and disabled states match the system

### Status-color audit

Collect every badge/status chip across the audited routes into one table: value → color → meaning. The same color meaning two things, or one state rendering two ways, is a finding that no single-route review will surface.

## Promotion candidates

Keep a running list: any pattern you find implemented independently on **2+ routes** is a promotion candidate. Report it separately — these are the findings that reduce future work rather than just fixing today's page.
