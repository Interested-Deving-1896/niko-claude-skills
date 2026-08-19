# 4. Feedback — actions, external calls, toasts

## 4a. Every action has a reaction

Review every clickable, editable or draggable control. For each meaningful action, test the full lifecycle:

`Idle → Hover/focus → Activated → Processing → Success or failure → Updated screen`

- [ ] Hover state indicates interactivity where appropriate
- [ ] Pressed or active state is visible
- [ ] Keyboard focus is visible
- [ ] The action responds immediately
- [ ] Longer work shows progress
- [ ] Repeated submission is prevented while processing
- [ ] Success is communicated
- [ ] Failure is communicated
- [ ] Validation explains what must be corrected
- [ ] The resulting UI state updates without requiring a refresh
- [ ] Optimistic updates roll back correctly after failure
- [ ] Disabled actions explain why they are unavailable
- [ ] Destructive actions request confirmation where appropriate
- [ ] Navigation actions clearly change route or context
- [ ] Nothing clickable appears dead

**Nothing clickable appears dead** is the one to be ruthless about. Click everything.

## 4b. External calls

Inventory every API, database, upload, download and background operation the route initiates. Use `read_network_requests` — don't rely on reading the service code.

### Mutating operations (create, update, delete, send, import, sync, upload)

- [ ] A loading or pending state appears immediately
- [ ] The initiating control cannot accidentally submit twice
- [ ] Success produces a success toast
- [ ] Failure produces an error toast
- [ ] The error toast gives a meaningful, human-readable message
- [ ] Field-specific errors also appear next to their fields
- [ ] The UI reflects the confirmed result
- [ ] Failed optimistic changes are reverted
- [ ] A retry action exists where useful
- [ ] Unsaved work is not silently lost

### Read operations

- [ ] Initial loading uses an appropriate page or section skeleton
- [ ] Refreshing existing data does not unnecessarily blank the screen
- [ ] Failure produces an **inline** error state
- [ ] Manual refresh failure may also produce a toast
- [ ] Empty data is distinguished from failed loading
- [ ] Retry is available
- [ ] Stale data is identified when relevant

### How to force failures

You can't audit error handling on a happy path. Break the calls deliberately: block or fail the request in the browser tooling, point the route at a bad id, revoke the permission, or use `javascript_tool` to stub the fetch with a rejection. If you cannot force a failure, say so in the log rather than marking the check passed.

## 4c. Toasts

**The law:** every user-initiated external *mutation* ends with explicit success or failure feedback. Background *reads* use inline states unless the user initiated them or needs immediate attention. Otherwise ordinary page loading produces "Customers loaded successfully" noise — and noise is how real failures get ignored.

- [ ] All toasts use the shared toast service/component
- [ ] Success, error, warning and informational types have defined uses
- [ ] Wording follows a consistent pattern
- [ ] Messages describe what happened, not merely "Success" or "Error"
- [ ] Technical error details are translated into useful language
- [ ] Toasts do not expose internal exception messages
- [ ] Related failures are not duplicated across multiple toasts
- [ ] Important messages remain visible long enough
- [ ] Toasts are keyboard and screen-reader accessible
- [ ] Toast position and stacking are consistent
- [ ] Persistent or actionable failures are not communicated **only** through a temporary toast
- [ ] **Mobile behavior is defined and verified** — position, width, stacking limit, safe-area insets, keyboard collision, and whether it covers the action the user just pressed. Full detail in `09-mobile.md`; do not mark this checklist complete from a desktop window alone.

Good:

- "Customer created."
- "Changes saved."
- "Couldn't save the customer. Try again."
- "File uploaded, but processing failed."
- "3 records imported; 2 require attention."
