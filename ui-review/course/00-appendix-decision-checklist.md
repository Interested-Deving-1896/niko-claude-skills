# Design System Decision Checklist
## Appendix to the UI/UX Principles Series

*A working document. Fill it in for your specific product. Every blank is a decision that needs an answer before design begins.*

---

## How to Use This Checklist

This is not a generic best practices list. It is a set of questions whose answers are specific to your product, your users, and your entities. Generic answers are wrong answers.

Work through it in order. Each section depends on the previous one. A decision in Section 3 that contradicts a decision in Section 1 means one of them is wrong.

Two modes:
**Building from scratch** — complete every section before opening a design tool.
**Reviewing existing work** — complete every section based on what the system *implies*, then compare against what it *does*. Every gap between the two is a finding.

---

## Section 1 — Foundation

### 1.1 Emotional Register

What three words describe how this product should feel to use?
*(Emotional words, not visual words. "Confident," "calm," "direct" — not "minimal," "clean," "modern.")*

1. _______________
2. _______________
3. _______________

What must this product never feel like?
_______________________________________________

What is the user's typical emotional state when using this product?
*(Select all that apply)*
- [ ] Focused — completing a specific task
- [ ] Anxious — something is at stake
- [ ] Exploratory — discovering or learning
- [ ] Rushed — time-pressured
- [ ] Relaxed — low stakes, unhurried
- [ ] Analytical — processing data or making decisions
- [ ] Celebratory — completing something meaningful
- [ ] Frustrated — something has gone wrong

What contexts within the product have a *different* emotional state from the default?
*(e.g., "The billing section has an anxious context even though the rest of the product is exploratory")*
_______________________________________________

---

### 1.2 Entity Vocabulary

List every first-class entity in this product.
*(A first-class entity is a domain object that has its own page, its own URL, its own full identity.)*

| Entity name | User's relationship to it | Typical action | Stakes of deletion |
|---|---|---|---|
| | | | |
| | | | |
| | | | |

For each entity: what are its sub-entities or related entities?
*(These will determine navigation scope and container decisions)*
_______________________________________________

Which entities are created frequently as part of core workflows?
*(These may need streamlined creation flows — panels, inline creation, or dedicated routes)*
_______________________________________________

Which entities are deleted rarely and with high consequence?
*(These need the full destructive action contract)*
_______________________________________________

---

### 1.3 Action Vocabulary

For each action type, fill in the contract. Add rows for product-specific action types.

**Destructive actions** *(permanently remove or irrecoverably alter)*

Confirmation gate: [ ] None [ ] Inline [ ] Modal
Container for confirmation: _______________
Feedback sequence (step by step):
1. _______________
2. _______________
3. _______________
Reversibility window: [ ] None [ ] Timed undo — duration: ___ seconds [ ] Soft delete
Error contract: _______________________________________________

**Constructive actions** *(create or add)*

Confirmation gate: [ ] None [ ] Inline [ ] Modal
Feedback sequence:
1. _______________
2. _______________
Reversibility: [ ] Immediate undo [ ] Edit only [ ] Not reversible
Error contract: _______________________________________________

**Mutative actions** *(edit or update existing)*

Auto-save: [ ] Yes [ ] No
Save trigger: [ ] Explicit save button [ ] On blur [ ] Auto-save with indicator
Feedback sequence: _______________________________________________
Unsaved changes warning: [ ] Yes [ ] No — shown when: _______________
Error contract: _______________________________________________

**Background actions** *(system acts without user attention)*

Ambient feedback mechanism: _______________________________________________
Failure notification: _______________________________________________
Retry behavior: _______________________________________________

**Confirmatory actions** *(acknowledge, approve, complete)*

Celebration moment: [ ] Yes [ ] No
Form: _______________________________________________
Feedback weight: [ ] Prominent [ ] Standard [ ] Ambient

**Product-specific action types:**

Name: _______________ Definition: _______________________________________________
Contract: _______________________________________________

---

### 1.4 Spatial System

Base unit: ___ px

| Spacing value | Tier assignment | Used for |
|---|---|---|
| | Tier 1 — between major sections | |
| | Tier 1 — between major sections | |
| | Tier 2 — between grouped elements | |
| | Tier 2 — between grouped elements | |
| | Tier 3 — within component | |
| | Tier 3 — within component | |
| | Tier 4 — tight internal | |

Density setting: [ ] Compact [ ] Default [ ] Comfortable
Reason: _______________________________________________

---

### 1.5 Elevation and Treatment System

| Level | Name | Meaning | Shadow value |
|---|---|---|---|
| 0 | Surface | Base — no elevation | none |
| 1 | Component | Cards, inputs, interactive elements | |
| 2 | Overlay | Panels, drawers, tooltips | |
| 3 | Modal | Modal dialogs | |

Elevation contrast: [ ] Flat [ ] Moderate [ ] Dramatic
Reason: _______________________________________________

Border radius: ___ px
Character this communicates: _______________________________________________

**Treatment definitions:**

| Treatment name | Semantic category | Minimum siblings | Hierarchy level | Must never appear on |
|---|---|---|---|---|
| | Interactive collection item | | | |
| | Static container | | | |
| | Overlay | | | |
| | Focused/active state | | | |

---

### 1.6 Color System

| Color | Role | When to use | When never to use | Coverage limit |
|---|---|---|---|---|
| | Primary action | | | Accent / Supporting / Dominant |
| | Destructive | | | Accent / Supporting / Dominant |
| | Success | | | Accent / Supporting / Dominant |
| | Warning | | | Accent / Supporting / Dominant |
| | Neutral surface | | | Accent / Supporting / Dominant |
| | Brand accent | | | Accent / Supporting / Dominant |
| | Text primary | | | Accent / Supporting / Dominant |
| | Text secondary | | | Accent / Supporting / Dominant |

---

### 1.7 Typography Scale

| Style name | Hierarchy level | Max lines | Valid surfaces | Must never be used for |
|---|---|---|---|---|
| | Page title | | | |
| | Section header | | | |
| | Body primary | | | |
| | Body secondary | | | |
| | Label | | | |
| | Caption | | | |

---

## Section 2 — Atoms

For each atom, answer all fields. The list below is a starting point — add product-specific atoms.

### Button

Behavioral contract: Triggers an immediate action. The action happens, it does not navigate.
Contextual contract: _______________________________________________
Invalid uses: Never used for navigation. Never styled to resemble a link when the action is destructive.
Additional invalid uses specific to this product: _______________________________________________
Treatment: _______________________________________________
Press state: _______________________________________________
Loading state: _______________________________________________
Disabled state logic: _______________________________________________

### Link / Text action

Behavioral contract: Navigates to a new context or opens a resource.
Invalid uses: Never used for actions that change data. Never styled to look like a button.
Additional invalid uses: _______________________________________________

### Card

Behavioral contract: _______________________________________________
Contextual contract: Always appears in a collection. Minimum siblings: ___
Dynamic list exception: [ ] Yes [ ] No — if yes, what triggers the single-item case: _______________
Invalid uses: Never as a single child outside dynamic list context. Never as a page container.
Additional invalid uses: _______________________________________________
Treatment: _______________________________________________

### Input — Text

Valid data types: Open-ended, format-independent answers.
Invalid data types: _______________________________________________
*(List any data types in this product that look like free text but have format constraints)*
Structured inputs required for: _______________________________________________

### Input — Select / Dropdown

Use when option count exceeds: ___
Searchable select threshold: ___
Known value inputs that must NOT use select: _______________________________________________
*(List any fields in this product where the user knows their answer as a typeable value)*

### Input — Radio

Use when option count is between: ___ and ___
Card radio required when: _______________________________________________
*(List the specific choice types in this product where visual demonstration is needed)*

### Input — Toggle

Immediate effect: [ ] Always [ ] Only in settings context
In forms requiring submit: Use checkbox instead. [ ] Confirmed

### Modal

Behavioral contract: Suspends context. Requires resolution. Used for decisions and alerts only.
Invalid uses: Never for primary record display. Never for content the user might want to share or bookmark.
Product-specific modal uses: _______________________________________________
*(List the specific scenarios in this product where a modal is correct)*
Product-specific modal anti-uses: _______________________________________________

### Side Panel / Drawer

Behavioral contract: Retains and remains adjacent to current context. Used for detail within a primary context.
Content ceiling: _______________________________________________
*(Describe the maximum content complexity this panel holds before a route is more appropriate)*
URL change: [ ] Never [ ] Always [ ] Conditional — when: _______________________________________________

### Tab

Behavioral contract: Shows a different facet of the same parent entity. Parent is constant across all tabs.
URL per tab: [ ] Yes [ ] No — reason if no: _______________________________________________
Invalid uses: Never for navigation between different entities or sections.

### Toast / Notification

Position desktop: _______________
Position mobile: _______________
Default duration: ___ seconds
Undo affordance: [ ] Always [ ] Destructive actions only [ ] Never
Maximum simultaneous: ___

---

## Section 3 — Navigation and Shell

### 3.1 Shell Hierarchy

First-level shell (global): _______________________________________________
Second-level shell (local): _______________________________________________
Does the local shell collapse into the global shell on mobile? [ ] Yes [ ] No
If no — document why and confirm this is an intentional hierarchy inversion: _______________________________________________

### 3.2 Navigation Scope Map

| Navigation element | Shell level | Scope | Changes between sections? |
|---|---|---|---|
| | Global | Always true | No |
| | Local | Section-specific | Yes |
| | Contextual | Page/record specific | Yes |

### 3.3 Container Decision Map

For every content type and interaction type in the product, decide the container. No blanks.

| Content / interaction type | Container | Reason | URL change? |
|---|---|---|---|
| [Entity name] full profile | Route | First-class entity with own depth | Yes |
| [Entity name] quick preview | Panel | Detail within list context | Conditional |
| Delete [entity] | Modal | Destructive action requiring resolution | No |
| [Entity] sub-section (e.g. activity) | Tab | Facet of same entity | Yes |
| | Route / Panel / Modal / Tab | | Yes / No / Conditional |
| | Route / Panel / Modal / Tab | | Yes / No / Conditional |
| | Route / Panel / Modal / Tab | | Yes / No / Conditional |
| | Route / Panel / Modal / Tab | | Yes / No / Conditional |

### 3.4 URL Contract

Base URL structure: _______________________________________________
Slug policy: [ ] Human-readable slugs always [ ] UUIDs with surrounding structure [ ] UUIDs only
If UUIDs: what surrounding path structure provides context: _______________________________________________

Which views have URLs:

| View | URL | URL pattern |
|---|---|---|
| | Yes | |
| | Yes | |
| | No — reason: | — |

Which UI states do NOT get URLs:

| State | Reason |
|---|---|
| Modal open | Not a navigation event |
| Panel open | Not a navigation event (unless shareable) |
| | |

---

## Section 4 — Forms

For every form in the product, complete this sheet.

### Form: _______________________________________________

**Output paradigm**
[ ] Data collection — output is structured data, user never sees it rendered
[ ] Object creation — output is a rendered artifact with visual identity
[ ] Configuration — output is behavioral rules with invisible consequences
[ ] Governed object — output is subject to external rules or approval

**Live editor required:** [ ] Yes [ ] No
If yes — what is the primary surface (the rendered output)? _______________________________________________

**Fields:**

| Field name | Input type | Reason for type | Validation fires | Error placement | Error message format |
|---|---|---|---|---|---|
| | | | On blur / On change / On submit | Inline below field | |
| | | | On blur / On change / On submit | Inline below field | |
| | | | On blur / On change / On submit | Inline below field | |

**Field dependencies:**
Which fields affect other fields? What cascades when the controlling field changes?
_______________________________________________

**Submit button:**
Label: _______________ *(not "Submit" — describes the outcome)*
Disabled when: _______________________________________________
Feedback sequence on success: _______________________________________________
Feedback sequence on failure: _______________________________________________

**Multi-step (if applicable):**
Number of steps: ___
Each step has URL: [ ] Yes [ ] No
Back button behavior: _______________________________________________
Progress indicator: _______________________________________________

---

## Section 5 — Personality and Voice

### 5.1 Motion Principles

Duration character: Instant ←[  ]→ Measured
*(position on scale 1–10)*: ___

Easing character: Mechanical ←[  ]→ Organic: ___

Motion weight: Weightless ←[  ]→ Grounded: ___

Transition scope: Subtle ←[  ]→ Expressive: ___

Motion principles statement (one paragraph): _______________________________________________

### 5.2 Voice Rules

Tone: Formal ←[  ]→ Conversational ←[  ]→ Playful: ___

This product's voice always:
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

This product's voice never:
1. _______________________________________________
2. _______________________________________________

### 5.3 Personality Moments

| Moment | Permitted | Form |
|---|---|---|
| Empty states | Yes / No | |
| Success / completion | Yes / No | |
| Loading / waiting | Yes / No | |
| Error states | Yes / No | |
| Onboarding | Yes / No | |
| Destructive confirmations | Yes / No | |

---

## Section 6 — The Page Review Pass

Use this for every distinct page type in the product. A pass means every item is checked. A fail at any item traces to a lower level — find the level, fix the definition.

### Page: _______________________________________________

**Foundation**
- [ ] Honors emotional register — feels like the three words
- [ ] Avoids anti-register
- [ ] Serves the user's emotional context for this page type

**Entities**
- [ ] Primary entity is clear
- [ ] First-class entities have their own routes
- [ ] Entity relationships are represented correctly

**Actions**
- [ ] Every action matches its defined action type contract
- [ ] Confirmation gates are present where defined
- [ ] Feedback sequences are correct
- [ ] Reversibility windows are communicated

**Atoms**
- [ ] No buttons used for navigation
- [ ] No cards as single children (outside dynamic list context)
- [ ] No toggles in submit-required forms
- [ ] No selects where typeable known values are faster
- [ ] No text inputs for structured data (phone, date, postal code)

**Molecules**
- [ ] Internal spacing is tier 3 or 4
- [ ] Related atoms are grouped correctly
- [ ] Validation contracts are honored

**Organisms**
- [ ] Card lists have the correct minimum siblings
- [ ] Navigation organisms are at the correct shell level
- [ ] Container decisions match the decision map

**Template**
- [ ] Shell hierarchy is correct — global shell wraps local shell
- [ ] Navigation scopes match shell levels
- [ ] Mobile collapse behavior confirms hierarchy

**Spacing**
- [ ] Tier 1 only between major sections
- [ ] Tier 2 between related elements
- [ ] Equal spacing only between genuine peers

**Visual language**
- [ ] Every treatment applied only to its defined semantic category
- [ ] Visual weight matches hierarchical level
- [ ] No dominant treatments on isolated elements with nothing to contrast against

**Feedback**
- [ ] Every interactive element has an acknowledgment state
- [ ] Every action has an outcome state
- [ ] Every error message is specific and actionable

**Containers**
- [ ] No first-class entities in modals
- [ ] No rich objects compressed into panels beyond their content ceiling
- [ ] Container decisions match the defined decision map

**Forms** *(if applicable)*
- [ ] Output paradigm is correct
- [ ] Live editor present if output has visual identity
- [ ] Input types correct for each field
- [ ] Validation fires at the right time
- [ ] Error messages tell the user what to do
- [ ] Submit label describes the outcome

---

*This checklist is a living document. Every new principle discovered adds a new question. Every new entity or action type in the product adds new rows. It is never complete — because the product is never complete.*
