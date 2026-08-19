# 7. Navigation, responsive, accessibility

## 7a. Navigation and route behavior

- [ ] The route is reachable through expected navigation
- [ ] The active navigation item is correct
- [ ] Breadcrumbs reflect the real hierarchy
- [ ] Browser back and forward work correctly
- [ ] Deep links load correctly
- [ ] Refreshing the route preserves the intended context
- [ ] Query parameters represent shareable state where appropriate
- [ ] Returning from a detail view preserves list filters and scroll position where useful
- [ ] Redirects do not create flashes or loops
- [ ] Unauthorized routes fail gracefully
- [ ] Route title and metadata are set correctly

Test each of these in the browser. Back-button and refresh behavior cannot be verified by reading route config.

## 7b. Responsive

This section is the *page-level* viewport check. The per-surface question — what each toast, dialog, drawer and table **becomes** on a phone — is `09-mobile.md`, and both are required.

Review at minimum: narrow mobile · wide mobile · tablet · laptop · wide desktop. Use `resize_window`.

- [ ] Layout changes are intentional at defined breakpoints
- [ ] No content is accidentally clipped
- [ ] Actions remain discoverable
- [ ] Toolbars wrap or collapse predictably
- [ ] Touch targets remain usable
- [ ] Tables have an intentional small-screen strategy
- [ ] Dialogs and drawers fit the viewport
- [ ] Sticky elements do not consume excessive space
- [ ] On-screen keyboards do not hide critical actions
- [ ] Loading, empty and error states work at every size

Horizontal page scroll at any supported width is a finding. Wide content (tables, code, diagrams) scrolls inside its own container — never the body.

If the app is bidirectional, check both directions. Layout that only works in one direction means physical CSS properties are being used where logical ones belong.

## 7c. Accessibility and interaction

- [ ] Semantic elements are used correctly
- [ ] The page has a logical heading hierarchy
- [ ] Every control has an accessible name
- [ ] Icon-only buttons have labels and tooltips
- [ ] All actions work with a keyboard
- [ ] Focus order matches visual order
- [ ] Focus is visible
- [ ] Color is not the only carrier of meaning
- [ ] Text and controls meet contrast requirements
- [ ] Errors are announced and associated with fields
- [ ] Loading and toast messages are announced appropriately
- [ ] Reduced-motion preferences are respected
- [ ] Zooming does not break the route

`read_page` returns the accessibility tree — use it as the primary check for names, roles and heading structure. A control that appears as an unnamed `generic` in that tree has no accessible name, regardless of what the template looks like.

Tab through the entire route once, start to finish, and note where focus disappears or jumps.
