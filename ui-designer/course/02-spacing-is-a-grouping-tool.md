# Spacing Is a Grouping Tool — and You're Probably Using It Wrong

*The second in a series of UI/UX principles for designers to use as pre-design guidelines or post-design review tools.*

---

The first article in this series established that every UI element carries a contract — a set of implicit claims about behavior, context, and relationship. Spacing is where many of those relational contracts play out visually. It's the mechanism by which the eye understands which elements belong together, which are peers, and which are parent and child.

Most designers treat spacing as an aesthetic decision. "Does this feel roomy enough? Does it feel cramped?" But spacing carries meaning that operates entirely independently of aesthetics. It's semantic — and it communicates whether you intend it to or not.

---

## The Core Idea: Spacing Is Semantic

**When two elements are close together, the eye reads them as related.**
**When two elements are far apart, the eye reads them as separate.**

This is a perceptual principle called the *Law of Proximity*, and it operates before the user has read anything. Every gap in a layout is making a statement about the relationship between the elements it separates.

The corollary: **equal spacing signals equal hierarchy.**

If the gap between element A and element B is the same as the gap between element B and element C, you are communicating that A, B, and C are siblings — peers at the same level of the hierarchy. The moment you establish that rhythm, users read the structure that way, and any content or behavior that contradicts it creates friction.

---

## How Flat Hierarchies Happen

Most layouts start from a grid or a flow. You place a navigation bar. Then a page title. Then a content area. Each gets a comfortable margin. It looks clean. It feels balanced.

But you've just created a flat list of three siblings — and that might not be what you mean.

In many cases, the page title *belongs* to the content area beneath it. It's the heading for that content. Conceptually, they're a unit. But spatially, equal margins have positioned the title as a peer of the navigation bar — a completely different kind of element with a completely different scope.

This mismatch between conceptual grouping and spatial grouping is the source of most layout confusion. And it connects directly to the contract principle: a title that belongs to a section is making a relational claim — *I describe what follows.* Floating it at equal distance from everything else breaks that claim before the user reads a word.

---

## The Symptom: Alignment That Feels Wrong

Here's how you can often detect a grouping problem without consciously identifying it: something in the layout will seem misaligned, and your instinct to fix it will lead somewhere that almost works but not quite.

Say a navigation bar spans the full width of the main area. Below it is a page title. Below that is a card. The navigation bar is the visual anchor — the widest element. The card aligns to it cleanly. But the title, despite appearing centered, sits slightly off — not quite centered to the nav bar, not clearly tied to the card.

Your instinct says: *center the title.* And if all three are meant to be siblings, that's the right fix.

But before applying it, ask the more important question: **should all three be siblings in the first place?**

If the title belongs to the card — if together they form a page group — then centering the title relative to the nav bar is treating the symptom. The real fix is to group the title with the card, let that group align to the nav bar, and let the title align *within its group*. The alignment problem doesn't need to be solved directly. It resolves as a consequence of getting the grouping right.

---

## The Design Review Checklist

### 1. Map the hierarchy first — before looking at spacing

Write down the intended hierarchy as a tree, from intent — not from what's on screen. What *should* the structure be, given the purpose of each element?

### 2. Compare the intended tree to what the spacing communicates

Based only on the gaps between elements — ignoring labels, colors, and content — what hierarchy does the eye infer? If the intended tree and the perceived tree don't match, you have a grouping problem.

### 3. Check for the equal-spacing trap

Find any sequence of three or more elements with consistent spacing between them. Are these elements actually peers? If not, which ones belong together, and what does their relational contract say about how they should be grouped?

### 4. Apply proximity intentionally

Once you've identified which elements belong in a group, tighten the spacing *within* the group so it's clearly smaller than the spacing *between* groups. The visual system needs meaningful contrast to register grouping — 90% of the outer margin isn't enough. Make the difference legible.

### 5. Resolve alignment questions by reference to groups, not global anchors

Alignment decisions should be made relative to the element's container, not relative to the widest element on the page. If a title is inside a group, it aligns to the group's container. The group itself aligns to the parent level. When you find yourself trying to align an element to something it's not directly related to, that's a signal the grouping is missing.

---

## The Pre-Design Version

Before placing a single element, draw the hierarchy. Write out the structural levels: what belongs to what, what are siblings, what are parents and children. Then make a rule for your spacing scale:

- Level 1 separation (between major sections): large
- Level 2 separation (between a group's internal elements): medium
- Level 3 separation (within a component): small

You don't have to follow specific numbers. But you need *distinct tiers*, and you need to assign every gap in your layout to one of them consciously. Spacing chosen intuitively, element by element, will accidentally create flat hierarchies — because intuition optimizes for local comfort, not global structure.

---

## Summary

- Equal spacing communicates equal hierarchy. Use it only when elements are genuine peers.
- Grouping problems often surface as alignment issues. The alignment fix is usually the wrong fix — correct the grouping first.
- A title that belongs to a section makes a relational contract with that section. Equal spacing from unrelated elements breaks that contract spatially even if the content is correct.
- Inner spacing should be clearly smaller than outer spacing for groups to register visually.
- Alignment decisions belong to the element's container, not to global anchors.
- Map your intended hierarchy before placing elements, then use spacing to match it.

---

*The next article deals with visual language — how treatments like shadows, borders, and color carry the same kind of implicit contracts as the elements themselves, and what happens when those treatments are applied without a defined rule.*
