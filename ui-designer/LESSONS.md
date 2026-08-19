# Lessons Log — corrections from Niko, recorded so they never repeat

> Read this BEFORE the molecule layer of any project. These are real failures
> caught in review, not theory. Each lesson names the violation, the cost, and
> the rule that prevents it.

---

## 2026-06-12 · The payload contract (Mycelium HQ v3, IssueRow)

**The failure.** The most common molecule on the page — the issue tile — has
one primal contract: *show the issue title*. As shipped, the title rendered as
~2 words in one column, **3 characters** in another. Every metadata cell
(mono ref, scope crumb, state word, age) was protected with `nowrap` and
`flex-shrink: 0`; the title was the only flexible element, so it absorbed
100% of the width loss. The least important content was the most protected.

**Niko's framing (verbatim spirit):** "the most basic, foremost, primal
CONTRACT with the user is to show the issue title… do you think this honors
the contract?"

**The rules:**

1. **Name the payload.** Every molecule has ONE element it exists to deliver
   (row → title; card → name; notification → message). Write it down before
   layout. In CSS terms: the payload gets space priority; metadata yields,
   shrinks, or dies first. If anything must truncate to 3 characters, it must
   never be the payload.
2. **Redundancy steals from the payload.** The repo name appeared twice per
   row (ref `hateomim-admin#81` + scope crumb "… · hateomim-admin"); state
   appeared twice (dot + the word). Every duplicate costs payload width on
   every row, thousands of times a day. Say each fact once; prefer the
   cheapest encoding (dot over word, `#81` over `owner-repo#81` when the repo
   is already on the row).
3. **Single-line rows are inherited table-thinking, not a contract.** Equal
   row height buys cross-row comparability only in grids where the eye tracks
   columns across rows. In a single-column vertical list there is nothing to
   align — peer-ness comes from repeated ANATOMY (same padding, hairlines,
   structure), not from equal height. Let the payload wrap (clamp ~2 lines;
   full text lives one click deeper). Never pay with the payload for a
   benefit the layout doesn't even use.
4. **Test the molecule at its narrowest real container.** The row was
   designed against a full-width ledger, then dropped into ~400px desk
   columns without re-testing. A molecule isn't done until it's been rendered
   at the minimum width it will actually live in.

**Meta-lesson for reviews:** when auditing a screen, check the most common
molecule's primal contract FIRST — before data-layer truth, before state
machines. I found a derived-state lie (a real bug) and completely missed that
the page's main molecule was unreadable. The user sees the broken title
contract a hundred times before they ever notice a wrong state.
