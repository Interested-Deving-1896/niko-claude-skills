# Behavioral Consistency — Designing the Rules Before the Interactions

*The seventh in a series of UI/UX principles for designers to use as pre-design guidelines or post-design review tools.*

---

Most design systems define visual consistency. Colors, typography, spacing, component styles — these get documented, tokenized, and enforced. A button looks the same everywhere. A card uses the same border radius. The visual language is coherent.

But there's a second design system that almost nobody writes down: the **behavioral design system**. The rules that govern how the product responds to user actions. Not how things look — how things *behave*.

And without it, even a visually consistent product becomes behaviorally incoherent. The user submits a form and gets a toast. They delete a record and get a modal confirmation followed by a slide-out animation. They send a message and get — nothing. No feedback at all. Each interaction was designed individually, in isolation, by whoever was building that screen that week.

The user experiences this as inconsistency they can't name. The system feels unreliable. Not broken — just unpredictable. And unpredictable erodes trust slowly and completely.

---

## The Root Problem: Designing Interactions in Isolation

Interactions are almost always designed screen by screen. The designer working on the contacts list thinks about what happens when you delete a contact. The designer working on the projects page thinks about what happens when you delete a project. They might make different decisions. Or the same decision made differently. Or one of them might not think about it at all.

The result is a product where deleting a contact feels different from deleting a project, even though "delete" is the same action type in both cases. The user builds a mental model from the first experience and is surprised by the second. Surprise, at the behavioral level, is friction.

The solution isn't to design every interaction the same — it's to design the *rules* first, and then apply them everywhere.

---

## Step One — Define Your Action Types

Before designing any individual interaction, map the action types that exist in your system. These are the semantic categories of things users can do — not specific actions, but classes of action that share behavioral characteristics.

A starting vocabulary for most systems:

**Destructive actions** — permanently remove or irrecoverably alter something. Deleting a record, cancelling a subscription, clearing data. These carry the highest stakes and require the most considered feedback.

**Constructive actions** — create or add something. Creating a record, uploading a file, adding a team member. These are positive outcomes that deserve clear confirmation without interruption.

**Mutative actions** — change something that already exists. Editing a record, updating settings, renaming a file. Lower stakes than destructive actions but still consequential enough to confirm.

**Navigational actions** — move the user to a different context. Clicking a nav item, following a link, selecting a record from a list. These are covered by the navigation contract from earlier in this series, but they belong in the behavioral vocabulary.

**Background actions** — things the system does on the user's behalf without requiring their attention. Auto-saving, syncing, uploading in the background. These need ambient feedback, not prominent feedback.

**Confirmatory actions** — acknowledge or approve something. Marking a task complete, approving a request, signing off on a document. Often have a celebratory dimension — the user has accomplished something.

**Reversible vs. irreversible** cuts across all of these and affects the feedback contract significantly. A mutative action that can be undone has a different contract from one that can't. An "undo" affordance fundamentally changes what the outcome feedback needs to say.

Your system may have different action types, or more granular ones. The point is not to adopt this vocabulary wholesale — it's to establish *your* vocabulary before you design a single interaction.

---

## Step Two — Design One Contract Per Action Type

Once the action types are defined, design the behavioral contract for each one. For each type, the contract specifies:

**The confirmation gate** — does this action require confirmation before it executes? Destructive actions almost always do. Constructive actions rarely do. Mutative actions depend on reversibility. The confirmation gate is not a visual decision yet — it's a structural one. Does the system pause and check, or does it act immediately?

**The feedback sequence** — what is the complete sequence of feedback from action to resolution? For a destructive action: confirmation modal → execution → visual removal of the item → outcome toast. Every step in the sequence, defined.

**The feedback weight** — how prominent is the outcome feedback? Matches the significance of the action, as established in the previous article.

**The reversibility window** — if the action is reversible, how long and through what mechanism? An undo toast that persists for five seconds? A soft-delete with a restore option? The reversibility window is part of the contract, not an afterthought.

**The error contract** — what happens if the action fails? Every action type needs a designed failure state, not just a designed success state. The error contract should match the weight of the action — a failed destructive action needs a clearer error than a failed background sync.

---

## Step Three — Write It Down

This is the step that almost never happens, and it's the step that makes everything else hold.

Write the behavioral contracts. Not in code — in plain language, in a document that any designer or developer on the team can read. One section per action type. One paragraph per contract element.

It should be possible to hand this document to a new team member and have them understand exactly how the system responds to every class of user action, without looking at a single screen.

This document is a design decision made once, applied everywhere. Without it, the same decision gets made differently by different people on different days — which is how behavioral inconsistency happens even in teams with strong visual design systems.

---

## Applying It — The Delete Sequence Example

Consider a complete delete sequence in a CRM — deleting a customer record. With a behavioral design system in place, the contract is defined before anyone touches Figma or writes code:

**Destructive action contract:**
- Confirmation gate: required. Modal with explicit warning copy and a clearly destructive button.
- Feedback sequence: confirmation modal → destructive button click → modal closes → record animates out of the list → toast confirming deletion with undo affordance.
- Feedback weight: prominent toast, not ambient.
- Reversibility window: undo available for 8 seconds via the toast. After that, permanent.
- Error contract: if deletion fails, modal remains open with an inline error. No ambiguity about whether the deletion occurred.

Every destructive action in the system follows this contract. Deleting a project. Removing a team member. Archiving a document. The specific copy changes. The specific animation might vary slightly based on the container. But the structure — gate, sequence, weight, reversibility, error — is identical.

The user deletes a customer and learns the contract. The next time they delete anything in the system, they already know what to expect. They know there will be a confirmation step. They know there will be an undo window. They know what "deleted" looks and feels like. That accumulated knowledge is trust.

---

## Consistency Across Contexts, Not Sameness

Behavioral consistency doesn't mean every interaction looks identical. It means every interaction of the same *type* follows the same *rules*.

A delete confirmation in a mobile context might be a bottom sheet instead of a modal. The undo toast might appear at the bottom of the screen instead of the top right. The animation might differ based on the layout. None of this breaks consistency — because the behavioral contract is the same. Confirmation gate: present. Undo window: present. Error contract: present.

Visual adaptation to context is expected and correct. Behavioral inconsistency — where the same action type has a confirmation gate in one context and not in another — is the violation. The contract is behavioral, not visual.

---

## Global Patterns and System-Learned Behaviors

Beyond the internal consistency of your own system, there's a wider contract to honor: the behaviors that users have learned from other products.

Pull-to-refresh on mobile. Swipe-to-delete on list items. Pressing Escape to close a modal. Cmd/Ctrl+Z to undo. These are system-level contracts — behaviors so consistent across products that users have internalized them as universal. Violating them isn't just inconsistent with your own system; it's inconsistent with the user's entire model of how software works.

The behavioral design system should explicitly acknowledge these global patterns and either adopt them or consciously deviate from them with a specific reason. Unconscious deviation — where a designer simply didn't know or think about the global pattern — is one of the most avoidable sources of user friction.

---

## The Behavioral Audit

For existing products, run this audit to surface inconsistency:

1. **List every destructive action in the product.** Does each one have a confirmation gate? Is the feedback sequence the same?
2. **List every form submission.** What does success look like? What does failure look like? Is it the same across forms?
3. **List every item deletion.** Does the item animate out? Is there an undo affordance? Is the behavior the same regardless of which list or page the item is on?
4. **List every background operation.** Is ambient feedback present and consistent?
5. **List every navigation action.** Are page transitions consistent in type and weight?

Inconsistencies found in this audit are not individual design problems. They are symptoms of a missing behavioral design system. The fix is not to patch each one individually — it's to define the contract and then apply it everywhere.

---

## Summary

- Visual design systems define how things look. Behavioral design systems define how things respond. Most products have the first and lack the second.
- Behavioral inconsistency — the same action type behaving differently in different contexts — erodes user trust without users being able to name why.
- Define action types before designing interactions. Establish a vocabulary of behavioral categories for your system.
- Design one contract per action type: confirmation gate, feedback sequence, feedback weight, reversibility window, error contract.
- Write it down. A behavioral contract that exists only in one designer's head will be violated by the next person who builds an interaction.
- Consistency is behavioral, not visual. Adapting the visual form to context is correct. Changing the behavioral contract between contexts is the violation.
- Honor global patterns. The behaviors users have learned from other products are contracts too.

---

*The next article examines how behavioral contracts compose — how the button inside the modal inside the delete sequence maintains its own contracts while participating in a larger one, and how personality and delight sit on top of a structure that's now solid enough to hold them.*
