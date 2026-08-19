# 9. Mobile behavior — per surface

Checklist 07 asks whether the *page* survives a narrow viewport. This one asks a harder question, of every surface individually:

> What does this thing **become** on a phone — and where is that written down?

"It shrinks" is not a behavior. "It's responsive" is not a behavior. A surface has a defined mobile behavior when you can name the transformation before you resize the window.

Most mobile failures are not layout failures. They are **surfaces designed for a mouse and a large canvas that were never re-thought for a thumb and a small one** — and toasts, drawers and dialogs are where it hurts most, because those are the surfaces that carry feedback and decisions.

---

## 9a. The transformation table

For every surface the route uses, the system must state the desktop form, the mobile form, and the breakpoint where it flips. Fill this in per route; contradictions between routes are findings.

| Surface | Desktop | Mobile | Flips at | Documented? |
|---|---|---|---|---|
| Page top | Title + actions inline | ? | | |
| Toolbar / filters | Inline row | ? | | |
| Toast | ? | ? | | |
| Dialog | Centered, fixed width | ? | | |
| Drawer / side panel | Side sheet | ? | | |
| Table / collection | Columns | ? | | |
| Form | ? | ? | | |
| Nav | ? | ? | | |
| Overflow / row actions | ? | ? | | |

An unanswered cell is a System gap, not a nit. It means the next developer guesses.

---

## 9b. Toasts on mobile

The most-skipped surface, and the one carrying success and failure.

- [ ] Position on mobile is defined and deliberate — top vs. bottom is a decision, not an inheritance
- [ ] Bottom-anchored toasts don't sit under the on-screen keyboard, a sticky action bar, or a bottom nav
- [ ] Toasts don't cover the primary action the user just pressed, or the field they're about to fix
- [ ] Toasts respect safe-area insets (notch, home indicator) — `env(safe-area-inset-*)`
- [ ] Width behavior is defined: full-bleed with margin, or capped — not desktop's fixed width on a 375px screen
- [ ] Long messages wrap rather than truncate, and the toast grows
- [ ] Stacking is bounded — three simultaneous failures must not consume the screen
- [ ] Dismissal works by tap and by swipe if the system claims swipe
- [ ] Duration accounts for reading on a phone, mid-task, one-handed
- [ ] Actionable toasts ("Undo", "Retry") have a thumb-sized target, not a desktop text link
- [ ] Anything the user must act on is **not** delivered only as a transient mobile toast

The rule worth writing: on mobile, a toast that covers the thing it's talking about has failed, no matter how correct the message is.

---

## 9c. Dialogs and drawers on mobile

- [ ] Each overlay type has a stated mobile form — full-screen sheet, bottom sheet, or unchanged
- [ ] The choice is consistent: the same overlay type doesn't become a bottom sheet on one route and a shrunken dialog on another
- [ ] Full-screen mobile overlays have a visible, thumb-reachable close — not a corner ✕ inherited from desktop
- [ ] Dismissal is predictable: if it can be swiped down, it can be swiped down everywhere
- [ ] Swipe-to-dismiss cannot silently discard unsaved input
- [ ] Overlay actions stay reachable when the keyboard opens — the confirm button must not be pushed under it
- [ ] The overlay scrolls internally; the page behind it does not scroll with it
- [ ] Its height is bounded by the *visual* viewport, not `100vh` (mobile browser chrome makes those differ)
- [ ] Content doesn't sit under the notch or home indicator
- [ ] Nested overlays are avoided on mobile even where desktop tolerates them
- [ ] A drawer that is a real destination is still deep-linkable on mobile

Side panels are the classic failure: a 400px side sheet on a 375px screen is a full-screen takeover that was never designed as one. Decide which it is, and write it down.

---

## 9d. Everything else

**Page top:** what happens to the primary action — stays inline, moves to a sticky bar, becomes a FAB, or drops into overflow? Pick one and apply it everywhere. Secondary actions collapse to overflow before the primary does, never the reverse.

**Toolbars and filters:** filters usually can't stay inline. State the pattern — a filter sheet, a collapsible row, or a horizontally scrolling chip row — and make active filters visible without opening anything.

**Tables:** the strategy must be named — cards, stacked key/value rows, priority columns with the rest behind a tap, or an intentional horizontal scroll with a frozen first column. Accidental overflow is not a strategy. Row actions need a defined mobile home; hover-revealed actions do not exist on touch.

**Forms:** one column. Correct `inputmode` and `autocomplete` so the right keyboard appears. Submit stays reachable with the keyboard open. Validation errors must not be scrolled off-screen — move focus to the first error.

**Touch and reach:** minimum ~44×44px targets with real spacing between adjacent destructive and safe actions. Primary actions belong in the lower two-thirds where a thumb reaches. Nothing depends on hover — every hover affordance needs a tap equivalent.

**Sticky chrome:** headers, action bars and nav each cost vertical space; count the total. Sticky elements consuming a third of a phone screen is a finding.

---

## How to verify

Resize to 375px and 390px — but also actually use it: `computer` tap and type rather than reading the DOM. Open a dialog, trigger a failure toast, focus a field so the keyboard logic engages, and check what's covered.

Screenshot every overlay and every toast at mobile width. Those two screenshots find more real problems than the rest of the responsive pass combined.
