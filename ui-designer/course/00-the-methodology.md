# Before the First Pixel — A Design System Methodology

*Article 0 of the UI/UX Principles series. The methodology that precedes every other article.*

---

Every principle in this series answers a specific question. This article answers the question that comes before all of them:

**Where do you start?**

Not with a color palette. Not with a component library. Not with a Figma file. You start with meaning — the semantic decisions that every visual decision will be built on top of. And you make those decisions in a specific order, because each one depends on the ones that came before it.

This article is a methodology for two scenarios: building a design system from scratch, and reviewing an existing one. They have different entry points but converge on the same process. Both are organized around the atomic design framework — atoms, molecules, organisms, templates, pages — extended with the semantic layer that atomic design was never designed to provide.

Atomic design tells you *how to organize* components. This methodology tells you *what they mean* before you organize them.

---

## The Problem With Starting in Figma

Most design systems start as a Figma file. A designer opens a blank canvas and begins making visual decisions — a color palette, a type scale, a button style. It feels productive. Things are being made.

But visual decisions made without semantic foundations are guesses. The color palette has no roles assigned. The type scale has no hierarchy tier definitions. The button style has no contract. These decisions look like a design system. They aren't one yet. They're a collection of visual choices waiting for meaning to be retrofitted onto them.

The cost of this order shows up later — when a second designer joins and applies the button style to navigation elements, because the contract was never defined. When a third color gets added for a specific screen and nobody remembers why, because the role system wasn't established. When the spacing looks inconsistent across the product because the tiers were never assigned and different designers made different local decisions.

The methodology in this article inverts the order. Meaning first. Visual expression second. The Figma file comes after the semantic layer is established — and when it does, every decision in it has a reason.

---

## The Two Scenarios

### Scenario A: Starting From Scratch

You have a product concept, a user, and a blank canvas. No existing components. No inherited decisions. The advantage is freedom. The risk is that freedom becomes arbitrariness — decisions made by aesthetic preference rather than semantic intent.

The methodology gives freedom a structure. You make decisions in the right order, each one narrowing the possibility space for the next in a principled way.

### Scenario B: Reviewing an Existing System

You have a product that exists. It has components, patterns, and decisions — most of which were never explicitly made. They accumulated. The advantage is that you can see what the system has been doing. The risk is that you optimize what's there rather than asking whether what's there is right.

The methodology gives review a standard. Not "is this inconsistent?" — which is a symptom. But "what rule was this trying to follow, and is it following it?" Every existing decision implies an intended rule. Making that rule explicit, then testing the design against it, is how you separate genuine inconsistency from intentional variation.

In both scenarios, the process is the same. The starting point is different. The questions are identical.

---

## The Layer Below Atoms — Foundation

Atomic design begins with atoms. But atoms are built *from* something — a set of decisions that predate any component. These foundational decisions are what atomic design skips, and what this series is built on.

Foundation is not a design artifact. It's a set of answers. You can write it in a document, fill it into a tool like Kontract, or hold it in a shared understanding. But it must exist before atoms are defined, because every atom inherits from it.

### Foundation layer 1: Emotional register

What does this product feel like to use? Three words. Emotional, not visual.
What must it never feel like? At least one anti-register.
What is the user's emotional state when they use it? (Focused, anxious, exploratory, celebratory — the answer governs where personality is permitted and where restraint is required.)

These answers are not aesthetic preferences. They are filters. Every decision made from here gets tested against them: does this serve the emotional register, or contradict it?

### Foundation layer 2: The product's entity vocabulary

What are the first-class objects in this product? Not UI components — domain objects. In a CRM: customers, deals, contacts, activities. In a project tool: projects, tasks, comments, members. In an e-commerce platform: products, orders, customers, reviews.

Every first-class entity is a route destination. Every entity has its own page. Every entity may have sub-entities. The entity vocabulary is the information architecture before it's the navigation architecture.

This step is frequently skipped. It shouldn't be. The entity vocabulary determines:
- Which views exist in the product
- Which container decisions apply to which interactions
- Which objects deserve their own URL
- Which relationships between objects need visual representation

Document every entity. For each one: what are its properties, what actions can be performed on it, what are its relationships to other entities, what is the user's emotional relationship to it (is creating one a milestone, is deleting one high-stakes, is viewing one a frequent routine).

### Foundation layer 3: Action vocabulary

What classes of action exist in this product? Destructive, constructive, mutative, navigational, background, confirmatory — or your product's specific variant.

For each action class: what is the confirmation gate, what is the feedback sequence, what is the reversibility window, what is the error contract.

This is the behavioral design system from Article 7. It belongs here, at the foundation layer, before any component is designed — because the feedback sequences and confirmation patterns will be inherited by every component that participates in those actions.

### Foundation layer 4: Spatial system

The spacing scale. The hierarchy tiers. The density setting.
Not as visual values yet — as structural decisions. How many tiers of separation exist? What is the ratio between them? What is the base unit?

These values become the skeleton's proportions. Every component built later uses them. Every layout spacing decision defers to them.

### Foundation layer 5: Elevation and treatment semantics

Before defining any shadow values: what categories of element exist in this product's visual hierarchy? How many elevation levels are needed? What does each level mean — surface, component, overlay, modal?

What treatments will be used as semantic markers? And for each treatment: what category does it mark, what is the minimum sibling requirement, what hierarchy level does it signal?

The card treatment cannot be defined until the minimum sibling requirement is answered. The answer might be different for this product than for another. A product where cards will always appear in grids of three or more has a different treatment contract than one where cards sometimes appear in dynamic lists of one.

---

## Atoms — Element Contracts

With the foundation established, atoms can be defined. In atomic design, an atom is the smallest indivisible component — a button, a label, an input, a color swatch, a type style.

In this methodology, an atom is the smallest indivisible component *with its contract defined.*

A button without a contract is a styled rectangle. A button with a contract — behavioral, contextual, relational — is a design system element. The visual form expresses the contract. The contract is primary.

### For every atom, define:

**The behavioral contract.** What does this element do when interacted with?
Button: triggers an immediate action.
Link: navigates to a new context.
Toggle: switches state immediately and permanently.
These are the defaults. Your product may have specific variations that need their own contracts.

**The contextual contract.** What environment does this element belong in?
Card: belongs in a collection. Never as a single child.
Tab: belongs in a tab bar, never standalone.
Tooltip: belongs adjacent to the element it annotates.

**The relational contract.** What does this element's presence imply about surrounding content?
Card implies a collection of peers.
Step indicator implies a sequence.
Badge implies a parent element with a status.

**Invalid uses.** Explicitly named. At least one per element.
Button: never used for navigation.
Tab: never used to navigate between fundamentally different sections.
Card: never used as a single child (outside dynamic lists).

**Treatment assignment.** Which treatment from the foundation layer does this atom use?

**Input type contract** (for form elements). From Article 10 — what data does this input type collect, and when is it the wrong tool?

### The atom inventory

At this stage, list every atom the product will use. Not just the obvious ones. Include:

Typography atoms (each type style as a defined atom with hierarchy level and usage constraints), color atoms (each color with its role and coverage limits), spacing tokens (each spacing value with its tier assignment), icon conventions (size, weight, usage rules), motion tokens (duration, easing, weight — from the animation principles).

These are the raw materials. Every molecule and organism is built from them. Their contracts propagate upward — a molecule that contains a button inherits the button's contract. If the molecule's design violates the button's contract, the violation is visible immediately because the contract was defined first.

---

## Molecules — Grouping and Hierarchy

A molecule in atomic design is a combination of atoms that functions as a unit. A form field: label + input + helper text. A card header: avatar + name + timestamp. A search bar: input + icon + clear button.

In this methodology, a molecule is a combination of atoms where **the grouping itself carries meaning.**

The spacing between the label and the input is tier 3 — tight, because they are the same thing. The spacing between one form field and the next is tier 2 — because they are related but distinct. This is not aesthetic. It is the spatial contract from Article 2, applied at the molecular level.

### For every molecule, define:

**The atom composition.** Which atoms combine, and in what relationship?

**The internal spacing tier.** What tier governs the gaps between atoms within this molecule? This should always be tier 3 or tier 4 — because a molecule is by definition a tight grouping.

**The molecule's own contract.** A molecule has a contract of its own, beyond the contracts of its atoms. A form field molecule contracts to collect a specific type of data and communicate its validation state. A card header molecule contracts to identify a collection item.

**Validation and state contracts** (for form molecules). When does validation fire, where does the error appear, what does it say?

**The molecule's relational claim.** What does this molecule's presence imply about its surroundings? A pagination molecule implies a list. A step indicator molecule implies a sequence. A breadcrumb molecule implies a hierarchy.

---

## Organisms — Behavioral Composition

An organism in atomic design is a group of molecules forming a distinct interface section. A navigation bar. A form. A card list. A data table.

In this methodology, an organism is where **behavioral contracts and visual language compose for the first time.**

This is the first level where the behavioral design system becomes visible. A card list organism is where the card treatment gets its meaning — because this is the first level where siblings exist. A form organism is where the validation contract and feedback sequence first apply together. A navigation organism is where the scope contract (global vs. local) is established.

### For every organism, define:

**The molecule composition.** Which molecules combine, and in what layout relationship?

**The external spacing tier.** What tier governs the gaps between molecules within this organism? This should be tier 2 — related but distinct elements within the same organism.

**The behavioral contract.** What actions does this organism participate in? Which action types from the foundation layer apply here, and how does the organism participate in the feedback sequences defined there?

**The treatment semantics at organism level.** A card list organism is where the minimum sibling requirement is enforced. If the organism renders one card, is that the dynamic list exception or a design violation?

**The scope contract for navigation organisms.** Is this global navigation, local navigation, or contextual navigation? The scope must match the shell level it will be placed in.

**The container decision for interactive organisms.** When an item in this organism is clicked — what happens? Route, panel, modal, or tab? The decision, and its reason, belongs here at the organism level.

---

## Templates — Shell Hierarchy and Layout

A template in atomic design is a page-level structure with no real content — it's the layout, the shell, the skeleton. Organisms placed in their structural positions.

In this methodology, a template is where **shell hierarchy and container decisions are validated.**

The global shell is established at the template level. The full-width top bar wrapping the sidebar. The sidebar's scope — does it change between major sections, or is it globally constant? The content area's constraints — max-width, padding, responsive behavior.

### For every template, define:

**The shell hierarchy.** Which organisms occupy the global shell, the local shell, the content area? Does the hierarchy match the mobile collapse behavior — does the sidebar collapse into the top bar, confirming the top bar's primacy?

**The navigation scope map.** Which navigation organisms at which shell level? Global navigation in the global shell. Local navigation in the local shell. Contextual navigation in the content area.

**The spacing tier at template level.** The gap between the shell and the content area, between the global shell and the local shell, is tier 1 — the largest separation in the system.

**The URL structure.** What routes exist at this template level? What is the URL pattern? Where do entity IDs appear, and as slugs or UUIDs?

**The responsive behavior.** How does this template change at tablet and mobile breakpoints? What collapses, what reflows, what becomes a drawer or bottom sheet?

---

## Pages — The Full Verification Pass

A page in atomic design is a template populated with real content. It's the closest representation of what the user actually sees.

In this methodology, a page is a **full contract verification** — the moment where every level of the system is tested simultaneously against real content and real context.

### The page review pass

Run this pass on every distinct page type in the product:

**Foundation check**
Does the page honor the emotional register? Does it feel like the three words, and not like the anti-register? Is the user's emotional context acknowledged in the design decisions — restraint where the context is anxious, personality where it's celebratory?

**Entity check**
Is the primary entity of this page clear? Is it a first-class entity with its own URL? Are related entities represented correctly — as links, as subordinate content, as separate routes?

**Action check**
For every action on this page — does it match its action type contract? Is the confirmation gate present where it should be? Is the feedback sequence correct? Is the reversibility window communicated?

**Atom check**
Is every atom used within its defined contract? Any buttons used for navigation? Any cards as single children? Any toggles in forms requiring submit?

**Molecule check**
Is every molecule's internal spacing at tier 3 or 4? Is every form field's validation contract honored?

**Organism check**
Is every organism's treatment semantics correct? Any card lists with one item that isn't a dynamic list? Any navigation organisms in the wrong shell level?

**Template check**
Is the shell hierarchy correct? Does the top bar wrap the sidebar? Do navigation scopes match shell levels? Is the URL structure correct for this route?

**Spacing check**
Is tier 1 used only between major sections? Tier 2 between related elements? Is equal spacing only used between genuine peers?

**Visual language check**
Is every treatment applied only to its defined semantic category? Does visual weight match hierarchical level? Is the dominant treatment earning its dominance through contrast?

**Feedback check**
Does every interactive element have an acknowledgment state? Does every action have an outcome state? Is every outcome message specific enough to tell the user what to do?

**Container check**
Is every content type using the correct container? Any first-class entities in modals? Any rich objects squeezed into panels? Any configuration flows in routes when panels would be correct?

**Form check** (for pages containing forms)
Is the output paradigm correct — data collection, object creation, or configuration? Is a live editor needed? Is input type correct for every field? Is validation behavior consistent with the system's defined contract?

---

## The Review Methodology for Existing Systems

When reviewing an existing design system, the atomic order becomes the audit order. Bottom up.

**Step 1: Reconstruct the intended rules.**
Before identifying problems, reconstruct what the system was *trying* to do. For each treatment, infer the intended semantic category. For each spacing pattern, infer the intended tier. For each input type, infer the intended task model.

Write these inferred rules down. They may never have been explicit. Make them explicit now.

**Step 2: Test every atom against its inferred contract.**
Where does the button appear in navigation contexts? Where does a card appear as a single child? Where does a select exist where a text input would serve the user better? These are atom-level violations.

**Step 3: Test every molecule for spacing coherence.**
Is the internal spacing consistently tighter than the external spacing? Are related atoms grouped closer than unrelated ones? Are there molecules where the spacing implies a different grouping than the labels suggest?

**Step 4: Test every organism for behavioral and treatment consistency.**
Is the same action type handled differently in different organisms? Is a card treatment appearing on single items that aren't dynamic lists? Is a navigation organism at the wrong shell level?

**Step 5: Test templates for shell hierarchy truth.**
Does the responsive behavior confirm the shell hierarchy the visual design implies? If the sidebar collapses into the top bar, does the visual design treat the top bar as first-level? Any mismatches between the implied hierarchy and the collapse behavior?

**Step 6: Test pages as complete systems.**
Run the full page review pass from above. Every violation found at the page level traces back to a level below it — an atom contract, a molecule spacing, an organism behavioral rule, a template hierarchy decision. Name the level. Fix at the level.

---

## The Methodology in One Sentence Per Step

1. **Foundation** — decide what the product means before deciding what it looks like.
2. **Atoms** — define every element by its contract before defining its appearance.
3. **Molecules** — define every grouping by its internal spacing tier and relational claim.
4. **Organisms** — define every composition by its behavioral contract and treatment semantics.
5. **Templates** — define the shell hierarchy and verify it against mobile collapse truth.
6. **Pages** — verify every level of the system simultaneously against real content and real context.

Building: work top-down through these steps. Don't start the next level until the current one is defined.
Reviewing: work bottom-up. Atoms first. Pages last. Every page-level problem traces to a lower-level cause.

---

## What This Methodology Is Not

It is not a guarantee of beautiful design. Beauty is the designer's contribution — the typeface, the color, the illustration style, the personality. This methodology builds the structure that beauty lands on.

It is not a process that eliminates judgment. Every step requires judgment. The methodology channels judgment toward the right questions at the right time, rather than letting aesthetic intuition answer structural questions and structural intuition answer aesthetic ones.

It is not complete. New principles belong here as they're discovered. The series this article opens will grow. The methodology grows with it.

---

*The articles that follow each address one principle in depth. Together they form the semantic layer that this methodology is built on. Read them in any order. Apply them in this one.*
