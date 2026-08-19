# Course backlog — lessons to fold into the numbered course files when possible

Captured from real project work. Each entry is a candidate lesson; integrate into
the most fitting numbered chapter (or a new one) when revising the course.

---

## Regions & floating panels (pinned-header zone ownership)

**Where it fits:** likely `05-the-container-decision.md` or a new "layout regions"
chapter near it.

**The lesson:**

- Treat a page as regions (a 3×3 grid is a useful mental model). A **full-width
  pinned header owns the entire top row** — top-left, top-center, top-right.
- Therefore a side panel **cannot live at top-right**. A collision with the header
  is a *region conflict*, not a z-index bug — raising z-index only hides it.
- A right-side panel belongs in **center-right** (middle-right), structurally below
  the header band.
- **Cap a centered panel's height so it never touches the header.** Because a
  vertically-centered panel grows symmetrically, subtract from both ends:
  `max-block-size: calc(100dvh − 2 × (header-height + gap))`. This needs a
  **known/claimed header height** (`--header-height`), reserved by the header.
- **Two centering modes** to teach as a deliberate choice:
  1. *Centered to the viewport* — simple, but reserves header-sized dead space at
     the bottom (symmetric cap).
  2. *Centered to the available space* — center between the actual top/bottom
     occupants; no waste, adapts to presence/absence of top-right / bottom-right
     elements. Preferred when the panel can grow tall.

**Source:** Mycelium UI — DS-demo theme rail. See
`frontend/docs/foundation/regions-and-floating-panels.md` in that repo for the
worked example.

> Note: the UI DESIGN COURSE is also bundled under the `ui-review` skill — mirror
> any course edits there to keep both copies in sync.
