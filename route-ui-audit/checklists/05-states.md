# 5. Page and data states

Every route must be seen in every state that applies to it. A route reviewed only in its populated happy path is **not reviewed** — mark it partial.

- [ ] Initial loading
- [ ] Background refreshing
- [ ] Populated data
- [ ] No data yet
- [ ] No search results
- [ ] Partial data
- [ ] Long or unusual content
- [ ] Recoverable error
- [ ] Unrecoverable error
- [ ] Offline or unavailable service
- [ ] Unauthorized
- [ ] Forbidden by role
- [ ] Record not found
- [ ] Stale or concurrently modified data
- [ ] Operation in progress
- [ ] Successful operation
- [ ] Failed operation

## Empty states must explain

1. What this area contains
2. Why it is empty
3. What the user can do next

"No results" alone fails all three. An empty state with no next action on a page whose entire purpose is creating records is a Missing state finding, not a nit.

**No data yet ≠ no search results.** They need different copy and different actions (create something vs. clear the filter). Collapsing them into one state is a finding.

## How to reach each state

| State | How |
|---|---|
| Loading | Throttle the network, or screenshot within the first paint |
| Empty | A filter that matches nothing; a fresh/`?new` record; a test account |
| Not found | Bad `:id` in the URL |
| Unauthorized / forbidden | Log out; or ask Niko for an account with the lesser role — don't guess at role behavior from guard code alone |
| Error | Force the request to fail (see checklist 04) |
| Long content | Paste a realistically long value — a real customer name, a real Hebrew address, a 300-char note |
| Stale | Two tabs; edit in one, act in the other |

If a state is unreachable without backend changes, log it as **unverified** with the reason. Never mark it passed because the code looks like it handles it.

## States at 375px

Every state above must also hold on a phone — states are where mobile breaks quietest, because nobody screenshots an error at 375px.

- [ ] Skeletons match the *mobile* layout, not the desktop one collapsing into it
- [ ] Empty-state illustration and copy fit without pushing the next action off-screen
- [ ] Error states keep their retry action reachable
- [ ] Inline errors inside a form aren't scrolled out of view — focus moves to the first one
- [ ] A loading state doesn't leave the page taller than the viewport with the action at the bottom

Check the empty and error states of at least the collection and form pages at mobile width. Those two carry most of the risk.
