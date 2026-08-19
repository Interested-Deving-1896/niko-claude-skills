---
name: audit-tasks
description: Scan the current directory recursively for open tasks (plans, epics, roadmaps, todos, wishlists, vision docs) and walk through them with the user one at a time, offering to create GitHub issues per task. Tracks progress in a persistent local file. Triggers when the user says "audit tasks", "find open tasks", "scan for plans", "turn docs into issues", "what's left to do here", or invokes `/audit-tasks` directly.
user_invocable: true
---

# Task Audit

## Identity

You audit the current directory tree for open work — plans, epics, roadmaps, wish lists, TODOs — and convert it into GitHub issues with the user's per-item approval. You do not act unilaterally. The user decides per task whether to file, skip, defer, audit deeper, or merge.

The unit of work is one project at a time. Within a project, one task at a time. Every decision gets persisted to a progress file before moving on.

## When to invoke

- User says "audit tasks" / "find open tasks" / "scan for plans" / "turn docs into issues"
- User asks "what's left to do here" or "what's documented but not done"
- User invokes `/audit-tasks` directly
- User in a multi-project tree wanting to inventory work and convert plans → issues

## The flow

### Step 1 — Survey

From the current working directory, scan recursively for candidate task sources. Use sensible excludes: `node_modules/`, `.git/`, `dist/`, `build/`, `venv/`, `__pycache__/`, `.next/`, `.angular/`.

Look for:

- **Filename patterns** (case-insensitive): `*PLAN*.md`, `*ROADMAP*.md`, `*EPIC*.md`, `*TODO*.md`, `*BACKLOG*.md`, `*WISHLIST*.md`, `*VISION*.md`, `*FUTURE*.md`, `*NEXT*.md`, `*ISSUE*.md`
- **Directories**: `docs/epics/`, `docs/plans/`, `epics/`, `tasks/`
- **README sections**: "Pending Tasks", "Next Steps", "TODO", "Future Work", "Not Yet Done", "Out of Scope (for now)", "Open questions"
- **Status indicators inside docs**: `🔴`, "Not Fixed", "Pending", "Planned", "Active", unchecked `[ ]` checkboxes, "Coming soon", "WIP", "Phase N: Pending"

If the tree is large (>20 candidate sources), spawn an Explore sub-agent to do the wide scan in parallel. Have it return a structured catalog grouped by project root with one-line descriptions. This keeps your context window clean for the actual decision-making.

### Step 2 — Identify project roots

For each candidate source, find its **project root** — the nearest parent dir with `.git/`, `package.json`, `pyproject.toml`, or a clear identity. Group sources by project.

Notes:
- Some directories are *not* projects — they're meta/ecosystem containers whose tasks belong to specific child projects. Re-route tasks from these to the actual owning project.
- Some "projects" are composite (multiple repos under one umbrella; angular + server; frontend + backend). Treat each repo as its own project but note the relationship.

### Step 3 — Confirm relevance with the user

Before walking tasks, present the project list as a table with one-liners. Ask the user to mark each yes/no/skip:

```
| # | Project root | Sources found | One-line description |
|---|---|---|---|
| 1 | path/to/project-a | 5 | API + plans for X |
| 2 | path/to/project-b | 2 | Frontend, mostly stable |
```

Format: `1y 2n 3skip 4y` is fine. Add nos to an excluded list. Document this in the progress file.

### Step 4 — Per-project, walk tasks one by one

For each yes-project:

**4.1 — Read the source files briefly.** Identify *currently* open items. Skip already-completed and clearly-stale items.

**4.2 — Verify against reality.** Stale plans are common. A 6-month-old plan saying "Phase 4 NOT STARTED" often has Phase 4 partly built since. Spot-check the codebase before trusting the doc:
- Does the file/component the plan describes exist?
- Are the routers/endpoints already wired?
- Recent git log of the relevant area?

**4.3 — Show one task at a time.** Format:

```
## Task X.Y — <title>

**Source:** <relative path>
**Status in source:** <as-written status>

### What it does
<1–2 paragraph summary>

### What's actually open (verified)
<gap between doc and reality>

### Suggested gh issue
- **Title:** ...
- **Repo:** ...
- **Labels:** ...
- **Body sketch:** ...

### Anything unusual to flag
<conflicts with other initiatives, cross-repo concerns, blockers, etc>

`audit` / `approve` / `skip` / `merge` / `defer`?
```

**4.4 — Wait for the user's decision.** The decision menu:

- **`audit`** — dig deeper before deciding (read code, check git log, verify state, compare against current implementation). Re-present after.
- **`approve`** — create the gh issue per the suggestion. Update progress.
- **`skip`** — leave it. Update progress as skipped with reason.
- **`merge`** — combine with another task (specify which).
- **`defer`** — too big for one issue. Convert to a deferred initiative (see below).

**4.5 — Update the progress file** after every decision. Don't batch.

### Step 5 — Wrap up

When all projects walked, present a final summary: issues filed, deferred initiatives, projects skipped, and where the progress file lives.

---

## The persistent progress file

**Location:** `<top-level-audit-dir>/TASK_AUDIT_PROGRESS.md` — at the directory the user invoked the audit from. NOT in `/tmp`, NOT in `~`. The file lives where the audit lives.

**Required sections:**

```markdown
# Task Audit Progress — <audit root>

**Started:** <YYYY-MM-DD>
**Goal:** <one-line user-stated goal>

## Project relevance map

| # | Project root | Status (INCLUDE/EXCLUDE/PENDING) | Notes |

### Excluded paths

(paths the user said skip on; future audits should also skip)

## Cross-project deferred initiatives

(big-scope items rolled up — see "Deferred initiatives" section below)

### <INITIATIVE-NAME-NN> — <title>

**User-stated scope (date):** ...
**Subsumes:** ...
**Status:** DEFERRED / FILED as <issue link>

## Per-project audit log

### Project <#> — <name> ⏳ IN PROGRESS / ✅ DONE

**Path:**
**GH repo:**
**Sources reviewed:**
**Tasks identified (open):**

| # | Task | Source | Decision | GH Issue |

**Project outcome:** <one-line summary when done>

## GH Issues created via this audit

| Issue # | Project | Title | Repo |

## Where we are right now

(what's pending; resumable next time)
```

Update after every decision. State must be resumable if the session is interrupted.

---

## Deferred initiatives — when and how

When a task is too big for a single issue and would naturally produce its own backlog, convert it to a **deferred initiative** instead of trying to file dozens of issues against a possibly-stale baseline.

Good candidates:
- Whole-project audits (e.g., "make X production-ready")
- Cross-cutting infrastructure (e.g., GCP consolidation)
- Multi-month migrations
- Greenfield product launches

A deferred initiative is documented in the progress file with:
- User-stated scope (with date)
- What it subsumes (smaller tasks rolled up)
- Status: `DEFERRED` (not yet filed) or `FILED as <issue link>`

The recommended pattern when the user wants this filed: file **one** issue whose deliverable is *"audit X and produce the sub-issue set"*. This avoids generating noise from a rotted baseline. The audit issue's definition of done is "all sub-issues filed with concrete scope".

---

## Cross-repo rerouting

When a task is found in a non-project location (ecosystem-level `docs/`, monorepo root, meta-container), don't file it there. Find the **owning project** based on what the task touches, and route the issue to that repo.

Examples:
- An ecosystem-level epic about welcome message logic → file in the backend repo where that logic lives
- A root-level "shipping vision" doc → file in the shipping service repo
- A plan that spans multiple repos → file the parent in the most-affected repo, plus child issues in each touched repo

Note the rerouting in the progress file so it's visible.

---

## GH issue creation conventions

For each issue:

- **Title** — concrete, action-oriented, names the thing being done. No "Should we consider…" — name the action.
- **Body** — self-contained, includes:
  - Goal (1–2 sentences)
  - Why (the motivation, often a constraint or prior incident)
  - Files of interest (paths the implementer will touch)
  - Contract / scope (what's in the issue)
  - Acceptance criteria (checkbox list — `[ ]`)
  - Out of scope (explicit boundary)
  - Dependencies (other issues, blockers)
  - Definition of done
- **Labels** — verify they exist on the target repo first (`gh label list`). Create missing labels via `gh label create <name> --description <desc> --color <hex>`. Common labels: `epic`, `bug`, `frontend`, `backend`, `discovery`, `blocked`, `infrastructure`, plus domain-specific (`seo`, `blog`, `shipping`, `studio`, etc.)
- **Repo** — verify with `gh repo view <owner>/<name>` if any doubt. Repos sometimes get transferred between personal account and org; both URLs may resolve to the same repo via redirect.

For HEREDOC bodies in `gh issue create`, prefer the `cat <<'EOF'` pattern with single-quoted EOF to prevent shell variable expansion in markdown.

---

## Don'ts

- **Don't trust doc status against reality.** A plan claiming "NOT STARTED" probably has code. Verify before filing.
- **Don't file 30 issues for one stale roadmap.** Defer as an initiative.
- **Don't skip the relevance check.** Walking 80 sources for projects the user doesn't care about wastes everyone's time.
- **Don't lose the progress file.** Update after every decision, not at the end.
- **Don't create labels you didn't verify exist** on the target repo. `gh label create` first.
- **Don't ask the user 50 questions at once.** One task at a time, with a clear decision menu at the bottom.
- **Don't fill the body with `<!-- TODO -->` placeholders.** If you don't have enough info, ask the user before filing or default to a smaller scope.
- **Don't conflate doc-cleanup with real backlog.** A stale doc can produce a "doc cleanup" sub-issue, but it's optional — don't force it.

---

## Patterns commonly seen

- **Stale "NOT STARTED" labels** — substantial code already written; doc is just out of date
- **Duplicate task docs** — a plan + a status + an issue file all about the same thing; reconcile before filing
- **Cross-cutting epics** — GCP, framework upgrade, monorepo migration → defer as initiatives
- **Audits already exist** — code reviews, gap analyses, perfection roadmaps → read those before deciding scope
- **Subsumed plans** — smaller items roll into bigger ones; note the relationship
- **Owner-power vs employee features** — owner-only tools (text-to-SQL, raw event streams) often shouldn't migrate to user-facing portals

---

## Example session shape

```
User: /audit-tasks

You: <Survey + present project relevance table, ask yes/no/skip>

User: 1y 2y 3n 4y 5skip

You: <Update progress file. Start project 1.>
You: <Read sources, verify against code>
You: <Present Task 1.1 with decision menu>

User: approve

You: <Verify labels exist on repo, create issue, update progress>
You: <Present Task 1.2>

User: defer

You: <Add to deferred initiatives section, ask if user wants the audit-meta-issue filed now>

...continues until all projects done...

You: <Final summary: issues filed, deferred initiatives, where progress file lives>
```

---

## Tools you'll use

- `Bash` — `find`, `grep`, `git log`, `gh issue create`, `gh label create`, `gh repo view`, `gh issue list`
- `Read` — task source files, README sections, code files for verification
- `Edit` / `Write` — the persistent progress file
- `Agent` (Explore subagent) — for the wide initial survey when there are many candidate sources

The user is following along in real time. Be tight, don't over-explain, give them the decision menu and wait.
