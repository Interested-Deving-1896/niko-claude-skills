# Input Type Is a Contract — Choosing the Right Field for the Right Task

*The tenth in a series of UI/UX principles for designers to use as pre-design guidelines or post-design review tools.*

---

Every input type carries a contract. Not just a visual convention — a behavioral promise about what kind of data it collects, how the user will interact with it, and what cognitive work it asks of them.

A text input says: express this in your own words, in any format you choose.
A select dropdown says: choose from a predefined set, and I'll manage the options.
A radio group says: choose exactly one from a small visible set.
A checkbox says: choose any combination, including none.
A toggle says: switch between two states, and the change takes effect immediately.

These aren't interchangeable with different visual treatments. They're different contracts. Using the wrong one for a given task doesn't just look off — it creates friction by misrepresenting what the interaction is and what it demands from the user.

The most common source of this problem: **input types are chosen by pattern, not by task.** The designer reaches for what they've seen used for similar-looking data, rather than asking what the user is actually trying to do and what cognitive mode best serves that task.

---

## The Decision Framework

Before choosing an input type, answer four questions:

**1. How many options are there?**
This is the first filter. Unbounded answers need free text. A small, fixed, known set needs a constrained input. A large set needs a different approach than a small one even if both are constrained.

**2. Does the user know the options, or do they need to discover them?**
If a user is choosing a country, they know what countries are. They need to find their specific entry in a large set. If a user is choosing a notification type, they may not know all the types available — the input needs to surface the options, not just accept them.

**3. Does the choice have visible consequences?**
If selecting an option changes the appearance, behavior, or downstream fields of the form — the user needs to understand the choice before making it. A simple radio doesn't communicate what each option means. A card input can show it.

**4. How long will the interaction take, and how does input type affect that?**
This is the question that kills the year-of-birth select. The user knows their answer exactly. The input type should honor that — accept the known answer directly, not require the user to navigate to it through a constrained interface.

---

## The Text Input

**Contract:** Express this in your own words, in your own format.

The text input is the most permissive field. It accepts anything. This is its strength and its failure mode — because "accepts anything" also means "validates nothing" and "formats nothing." When a text input is used for data that has a known format, the contract breaks: the field implies freedom the data doesn't actually have.

**Use when:**
- The answer is genuinely open-ended and format-independent (names, messages, descriptions)
- The set of valid answers is unbounded and unpredictable
- The user's exact wording is the data — not just the semantic content

**Don't use when:**
- The data has a known format (phone numbers, dates, postal codes, currency)
- The valid values are from a finite set the system knows
- The user's expression of the answer matters less than its structured value

### The phone field — not a text input

A phone number is not free text. It has a format. It has country-specific rules. It has a specific rendering in the output (with country code, with formatting). Treating it as a text input passes all format decisions to the user — who will enter it in twelve different ways across twelve users, none of which your system may parse consistently.

A phone input should: select country code separately (ideally with a searchable flag picker), accept only numeric input for the number itself, format in real time as the user types, validate against the format rules for the selected country.

None of this is possible with a plain text input. The text input contract — express this in your own words — is wrong for a phone number. The phone number has words of its own.

### The formatting question

Any field where the output will be rendered in a specific way needs to communicate that format to the user while they type. A text input for a message template body that supports variables needs to show variable syntax inline. A text input for a URL slug needs to show the full URL path updating as the user types. The input type alone isn't enough — the contract extends to how the field represents the output relationship.

---

## The Textarea

**Contract:** This answer is long, multi-line, and prose-form.

The textarea is a text input for extended content. Its contract carries additional implications: the answer is expected to be long, the user will need to read what they've written, and editing will be non-trivial.

**The character limit question**

If a textarea has a character limit, the limit is part of the field's behavioral contract. It must be visible, live, and countdown-style — not a static note below the field that the user has to remember while typing.

Character limits with static indicators ("Maximum 500 characters") are broken contracts. The user types freely, ignoring the note, and discovers the constraint when they hit it — or after they submit. The limit existed in the documentation; it was never part of the interaction.

A live counter that shifts in visual weight as the user approaches and exceeds the limit is the correct implementation. The constraint is part of the field's live feedback. The user always knows where they stand.

**When textarea becomes live editor**

If the textarea's content will be rendered as formatted output — an email body, a template message, a product description with formatting — the textarea is the wrong container. The user is writing content that will be seen in a context other than a plain text field. They need to write in that context, not in a plain field and hope the rendering matches.

This is the point at which the paradigm shift from the previous article applies. The textarea becomes a rich text editor, or better, a live preview panel where the rendered output is the primary surface.

---

## The Select Dropdown

**Contract:** Choose one from a large set I'm managing for you. The set is too large to show all at once.

The select is a power tool that gets used as a default. It hides its options behind an interaction, requires sequential scanning, and on mobile produces a native picker that has its own platform-specific behavior. It earns its use in specific situations. Used outside those situations, it creates unnecessary friction.

**Use when:**
- The option set is large (more than 7–8 options)
- The options are standardized and well-known (countries, currencies, languages, timezones)
- The user knows what they're looking for and needs to find it
- Space is constrained and a visible list would dominate the layout

**Don't use when:**
- There are fewer than 5 options — use radios
- The user needs to see all options to make an informed choice
- The options have visual distinctions that a dropdown can't communicate
- The user knows their answer as a typed value faster than they can find it in a list

### The year of birth — the canonical anti-pattern

The year-of-birth field is the most cited example of input type chosen by category rather than by task, and it deserves its reputation.

The data is a year. The user knows their year exactly. It is a four-digit number they have typed thousands of times on thousands of forms. The cognitive cost of recalling it is zero.

A select dropdown for year of birth requires the user to: open the picker, scan a list of roughly 100 years, scroll to find their year — which is probably somewhere in the middle of the list — and select it. The time cost is 5–15 seconds. The friction is entirely created by the input type.

A text input with type="number", a maxlength of 4, and numeric keyboard on mobile takes four keystrokes and 2 seconds.

The select exists on year-of-birth fields because "year" looks like a category, and categories look like selects. The task analysis — what is the user actually trying to do — was never performed.

The rule: **if the user knows their answer as a typeable value, a free text input is almost always faster than a select.** The select earns its place when the user needs to discover or browse options, not when they need to enter a known value.

### The searchable select

For genuinely large sets where the user knows what they're looking for but can't type the exact value efficiently — timezone selection, for example, where the canonical name may be unfamiliar — a searchable select (combobox) is the correct tool. The user can either type to filter or scroll to browse. Both modes are supported. Neither is forced.

---

## Radio Buttons

**Contract:** Choose exactly one from a small, fully visible set. The options are known, comparable, and mutually exclusive.

The radio's contract includes full visibility — all options are shown simultaneously. This is both its strength (the user can compare before choosing) and its constraint (the set must be small enough to show in full).

**Use when:**
- 2–6 mutually exclusive options
- The user benefits from seeing all options before choosing
- The options are text-labelled and self-explanatory
- The choice is not binary enough for a toggle but not large enough for a select

**Don't use when:**
- There are more than 6–7 options — use a select
- The choice is binary with immediate effect — use a toggle
- The options need visual demonstration to be understood — use card radios
- The options have different visual consequences for the output being created

### When radio becomes card radio

The card radio is a radio that can show its meaning visually. It earns its use when the difference between options cannot be communicated by a label alone — when the user needs to see what they're choosing, not just read it.

**Correct uses of card radios:**
- Layout selection (compact / comfortable / spacious — show the density, don't just name it)
- Color scheme selection (show the scheme, don't just name it)
- Template selection (show the rendered template, not just its name)
- Plan selection where features differ visually between options

**Incorrect uses of card radios:**
- Options whose difference is entirely communicated by their label ("Monthly" vs "Annual")
- Options in a data collection form where no visual demonstration is relevant
- Any context where the card size makes the form feel inflated relative to the decision's importance

The card radio is the correct pattern for object creation forms where choosing an option directly affects the visual output. It is decoration in data collection forms where the label is sufficient.

---

## Checkboxes

**Contract:** Choose any combination, including none. Each option is independent.

The checkbox is the multi-select equivalent of the radio. Its contract is independence — checking one option has no effect on any other.

This independence contract is violated when checkboxes are used for options that are actually mutually exclusive (only one should be selected at a time — that's a radio), or when certain combinations are invalid and the form doesn't prevent or explain them.

The most common checkbox error: using a single checkbox where the interaction is actually a toggle. A single checkbox for "I want to receive marketing emails" is a toggle. It has two states. It should look like one.

---

## The Toggle

**Contract:** Switch between two states. The change takes effect immediately.

The toggle's contract has two parts, and the second one is frequently violated.

"Two states" is understood. "Takes effect immediately" is not. A toggle in a form that requires a submit action to apply is breaking its own contract — it looks like immediate state change but behaves like a deferred one.

**Use when:**
- Binary choice with immediate effect (settings, preferences, live states)
- The two states have clear labels (On/Off, Enabled/Disabled, Visible/Hidden)
- The context is a settings or configuration panel where live application is expected

**Don't use when:**
- The change requires saving (use a checkbox in a form with a submit button)
- The states are not clearly opposite (use radio buttons with explicit labels)
- The user needs to see a consequence before committing (use a radio or card radio with a preview)

---

## Combining Input Types — The Form as a System

Individual input type decisions don't exist in isolation. A form is a composition of input types, and the combination needs its own coherence.

**Field length communicates answer length.** A wide, full-row text input implies a long answer. A short inline input implies a short, precise answer. This is a visual contract — the user adjusts their expected answer length to match the field's visual width. A phone number field that spans the full form width implies the phone number is a long, complex answer. It isn't. The field width is lying.

**Related fields should be visually grouped.** The spacing and grouping principles from earlier in the series apply directly inside forms. First name and last name are siblings — they belong on the same row with the same visual weight. Country and postal code are related — they should be adjacent, not separated by unrelated fields. The grouping communicates the relationship before the label does.

**Field order is a narrative.** Forms have a reading direction, and that direction should follow the logic of the task, not the order fields appear in the database. Contact information before product preferences. Name before company. The most critical, always-required fields first. Optional or conditional fields last or progressively disclosed.

**Input type contrast communicates decision weight.** A form where every field is the same input type — a column of text inputs — implies all fields are equal. They're not. A prominent card radio for a plan selection, surrounded by standard text inputs for billing details, communicates correctly: this choice is the important one, these details support it.

---

## Summary

- Every input type carries a contract about what data it collects and what cognitive mode it asks of the user.
- Input types are most commonly chosen by pattern — what looks like similar data — rather than by task analysis.
- The year-of-birth select is the canonical anti-pattern: a typed known value forced into a browse interaction, creating friction that serves nobody.
- Text inputs are for open-ended, format-independent answers. Structured data with known formats (phone, date, postal code) needs structured inputs.
- Selects earn their use when the set is large and the user needs to find their option. They're wrong when the user already knows their answer as a typeable value.
- Card radios are correct when the difference between options requires visual demonstration. They're decoration when the label is sufficient.
- Toggles take immediate effect. In a form requiring a submit, use a checkbox.
- Field length, grouping, order, and input type contrast are all semantic signals — they communicate the shape of the task before the user reads a label.

---

*The final article in the forms arc examines the form as a complete system — validation as a feedback contract, progressive disclosure, field dependencies, and how every principle in this series converges on the form surface.*
