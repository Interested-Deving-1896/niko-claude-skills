# 6. Surfaces — forms, collections, overlays

## 6a. Forms

- [ ] The form uses shared field components
- [ ] Labels, required markers and helper text are consistent
- [ ] Field widths reflect expected input
- [ ] Related fields are grouped
- [ ] Validation appears at the correct time (not on first keystroke of an untouched field)
- [ ] Errors state how to fix the problem
- [ ] Server-side errors map back to relevant fields
- [ ] Save and cancel actions use standard placement
- [ ] Submit shows pending state
- [ ] Double submission is prevented
- [ ] Successful save is acknowledged
- [ ] Failed save preserves entered data
- [ ] Unsaved-change navigation is handled
- [ ] Keyboard submission behavior is intentional
- [ ] Autofocus does not create accessibility or mobile problems
- [ ] Read-only and disabled states are visually distinguishable
- [ ] Create and edit versions remain structurally consistent

Compare create vs. edit for the same entity side by side. Divergence there is one of the most common consistency failures.

## 6b. Tables, collections and lists

- [ ] The correct collection component is used
- [ ] Column alignment and formatting are consistent (numbers right, dates one format, currency one code)
- [ ] Row click behavior is predictable
- [ ] Row actions appear in the standard location
- [ ] Selection behavior is consistent
- [ ] Bulk actions clearly show their scope ("Delete 12 selected", not "Delete")
- [ ] Pagination or infinite scrolling follows system rules
- [ ] Loading does not cause layout shifts
- [ ] Empty results have an appropriate state
- [ ] Sorting clearly shows the active direction
- [ ] Filters survive navigation when expected
- [ ] Destructive row actions require appropriate confirmation
- [ ] Mobile behavior is defined — the table does not merely overflow by accident

Row height, column widths and cell construction should be uniform. A cell that lays itself out with flex/grid inside a `td`/`tr` breaks the row rhythm — wrap inside the cell instead.

## 6c. Dialogs, drawers and overlays

- [ ] The correct surface is used for the task (dialog vs. drawer vs. full page)
- [ ] Title and action placement follow system rules
- [ ] Primary action placement is consistent
- [ ] Close, cancel and escape behavior are predictable
- [ ] Clicking the backdrop behaves intentionally
- [ ] Focus is trapped and restored correctly
- [ ] Pending actions prevent accidental closure where necessary
- [ ] Errors remain visible **in** the overlay
- [ ] Destructive confirmation clearly identifies the affected record — by name, not "this item"
- [ ] Dialogs are not nested without a compelling reason
- [ ] The route remains understandable after refresh or deep linking when the overlay is a real destination
- [ ] **The mobile form is stated** — full-screen sheet, bottom sheet, or unchanged — and it's the same choice on every route using this overlay type. See `09-mobile.md`.

Overlay width should be fixed by the system, not derived from content — content-sized dialogs resize as data changes and read as broken.

A side panel is the surface most likely to have no mobile decision at all: a 400px side sheet on a 375px screen is a full-screen takeover that nobody designed as one. Decide which it is.
