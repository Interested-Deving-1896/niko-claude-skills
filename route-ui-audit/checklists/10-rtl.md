# 10. Direction — RTL / LTR

Skip only if the app is single-direction **and** will stay that way. If any surface is bidirectional, or the app is Hebrew/Arabic, this is not optional.

Same shape as mobile: direction is a **transformation with decisions attached**, not a flip. Three categories, and confusing them is where every RTL bug lives.

| Category | Behavior | Examples |
|---|---|---|
| **Mirrors** | Follows the writing direction automatically | Layout flow, text alignment, list order, drawer edge (usually), directional icons (arrows, chevrons, undo/redo) |
| **Never mirrors** | Stays LTR regardless of page direction | Numbers, phone numbers, email addresses, URLs, IDs and SKUs, code, timestamps in `HH:MM`, media transport controls, logos, brand marks |
| **Deliberately defies** | Documented exception that overrides the mirror | Anchored-to-physical-side surfaces — e.g. drawers and overlays that always open physical-left even in RTL |

The third row is the one that must be written down. An undocumented deliberate exception looks exactly like a bug and gets "fixed" by the next developer.

---

## 10a. The grep pass — run once per codebase, not per route

Most of the audit is mechanical. Do it first; it produces the finding list before you open the browser.

| Grep | Verdict |
|---|---|
| `margin-left` / `margin-right` | Should be `margin-inline-start` / `-end` |
| `padding-left` / `padding-right` | Should be `padding-inline-start` / `-end` |
| `left:` / `right:` in positioning | Should be `inset-inline-start` / `-end` |
| `text-align: left` / `right` | Should be `start` / `end` |
| `float: left` / `right` | Should be `inline-start` / `inline-end` |
| `border-left` / `border-right` | Should be `border-inline-start` / `-end` |
| `border-radius` with 4 values | Check the logical equivalents |
| `transform: translateX(` | Sign flips under RTL — needs a direction-aware value |
| `::before`/`::after` with a hard-coded `left`/`right` | Same |
| `[dir="rtl"]` / `[dir="ltr"]` selectors | Legitimate **only** where a logical property genuinely can't express it. Each one needs a comment saying why. Direction selectors used to patch physical properties are the violation, not the fix. |

Count the hits per file. A component with twenty physical properties wasn't written with direction in mind at all — that's one finding against the component, not twenty.

Logical properties are the rule; `[dir]` selectors are the documented escape hatch.

## 10b. Structure and DOM order

- [ ] The direction container (`dir="rtl"`) is set at the right level, not sprinkled per component
- [ ] DOM order reflects reading order, so that visual order follows without positional hacks
- [ ] Grid and flex layouts rely on flow-relative placement, not column indices assuming a side
- [ ] Tab order follows visual order in both directions
- [ ] Sticky/anchored surfaces resolve to the correct edge — and where a physical anchor is intended, it's documented as a deliberate exception
- [ ] Scroll position and any scroll-based logic account for inverted scroll origin in RTL

## 10c. Content that must not mirror

- [ ] Numbers, currency amounts and percentages render correctly inside RTL text
- [ ] Phone numbers stay intact — no reversed segments, no misplaced `+`
- [ ] Emails, URLs, IDs, SKUs and order numbers keep LTR presentation
- [ ] Mixed Hebrew/English strings don't scramble punctuation at the boundary (the classic: a trailing `.` or `:` jumping to the wrong end)
- [ ] Parentheses and quotes around mixed content land on the correct sides
- [ ] Dates and times use the intended format and don't reorder their parts
- [ ] Input fields with LTR content (phone, email, IBAN) set direction on the *input*, not just the label
- [ ] Placeholders align consistently with the value that replaces them

Bidi punctuation is the single most common visible RTL bug and it never shows up in a component-level review — only with real mixed content. Test with a real Hebrew string containing an English product name and a phone number.

## 10d. Icons and motion

- [ ] Directional icons mirror (back/forward, next/prev, arrows, indent, undo/redo)
- [ ] Non-directional icons do not (checkmarks, search, settings, logos, brand marks)
- [ ] Media transport controls do not mirror — play always points the same way
- [ ] Slide/drawer animations enter from the correct edge in both directions
- [ ] Progress and stepper flows advance in the reading direction
- [ ] Charts: axis order and legend placement are a deliberate decision, recorded either way

## 10e. Per-route spot-check

After the grep pass, verify visually — but only on one route per page type, plus any route the grep flagged heavily.

- [ ] Page top: title, actions and overflow land on the correct sides
- [ ] Toolbar, filters and search read correctly
- [ ] Table column order and numeric alignment (numbers stay end-aligned in the numeric sense)
- [ ] Forms: labels, required markers, helper and error text
- [ ] Dialogs and drawers open from the intended edge and their actions sit correctly
- [ ] Toasts appear on the intended side, with the same rule in both directions
- [ ] Nothing overflows horizontally that didn't in the other direction

Switch direction live via `javascript_tool` (`document.dir = 'rtl'`) for a fast pass — but confirm real findings by loading the app in its actual configured direction. A live flip won't reveal DOM-order problems that the app's own markup fixes.

---

## Authoring clause

If direction rules don't exist, this is a Gate 0 area like any other. The rule must state: which direction is primary, whether both are supported, that logical properties are mandatory, the conditions under which a `[dir]` selector is acceptable, and the list of deliberate physical-anchor exceptions with their reasons.
