# niko-claude-skills

**TL;DR:** This repo is a public copy of eleven of Niko's Claude Code skills (written playbooks that tell an AI coding agent how to do a kind of work: design a UI system, review an interface, build sign-in, audit a SaaS idea, clean up a Mac). It exists so that Claude agents running somewhere other than Niko's Mac, such as GitHub Actions, can read the same playbooks he uses locally.

## What it is

Each skill is a folder with a `SKILL.md` (frontmatter and instructions) and sometimes supporting files (`course/`, `references/`, `templates/`). The working copies live in Niko's private `claude-config` repo (`~/.claude/skills` points there); this repo is a hand-made snapshot of the generic ones, last synced on 2026-08-18. Three have drifted since: `auth-builder` and `landing-page-playbook` have newer `SKILL.md` files locally, and the local `ui-review` course has an extra `_BACKLOG.md`.

The repo is public. Its license section says it is personal and internal reference, with no license to redistribute.

## What's in here

| Skill | Purpose |
|---|---|
| [`ui-designer/`](ui-designer/) | Scaffold a new design system from scratch. Top-down, contract-based, atomic layering. Bundles the UI Design Course as canonical reference. |
| [`ui-review/`](ui-review/) | Audit existing interfaces. Bottom-up, evidence-based, contract-violation hunting. Bundles the UI Design Course. |
| [`route-ui-audit/`](route-ui-audit/) | Audit every route of a router-based app against a documented UI system — page templates, feedback, states, responsive, a11y, RTL. Writes the rules first if they don't exist. |
| [`atomic-design-system/`](atomic-design-system/) | Atomic design system reference and methodology. |
| [`landing-page-playbook/`](landing-page-playbook/) | Structure and copy for SaaS landing pages that convert — section order, CTAs, social proof, and what to cut. |
| [`angular-21-expert/`](angular-21-expert/) | Angular 21 expert — standalone, zoneless, signals, modern routing. |
| [`genkit-expert/`](genkit-expert/) | Firebase Genkit expert for Angular 21 + Firebase/GCP and FastAPI on Cloud Run. Flows, tools, agents, RAG, MCP. |
| [`auth-builder/`](auth-builder/) | Build or audit auth + user management on Firebase Auth + Angular — invites, RBAC, custom claims, guards, Firestore rules, the credential-allowlist model. |
| [`saas-goldmine/`](saas-goldmine/) | Audit projects for SaaS potential — competitive analysis, monetization, extraction planning. |
| [`audit-tasks/`](audit-tasks/) | Scan a repo for open tasks buried in plans, roadmaps, and todo docs, then walk them with the user and file GitHub issues. |
| [`mac-cleanup/`](mac-cleanup/) | Reclaim Mac disk space safely — survey where space lives, sort by risk tier, delete only what's confirmed. |


`ui-designer/` and `ui-review/` each carry the UI Design Course under `course/`.

## Using these in a GitHub Actions runner

Add a step before the Claude action that clones this repo to a known path, then reference it in the agent's prompt:

```yaml
- name: Fetch shared Claude skills
  run: git clone --depth 1 https://github.com/nikotsy/niko-claude-skills.git "$HOME/claude-skills"

- name: Run Claude
  uses: anthropics/claude-code-action@beta
  with:
    # ...
    direct_prompt: |
      Shared skills are available at $HOME/claude-skills/. Before any UI work,
      read $HOME/claude-skills/ui-designer/SKILL.md (or ui-review/SKILL.md
      for audits). The course articles under course/ are the source of truth
      for design decisions — do not paraphrase from memory.
```

Note: the GitHub Action runs Claude in agent mode without the local Skill-tool discovery layer, so "having access" means: the files are on disk, and the agent reads them as plain Markdown via the `Read` tool. Skills that depend on local-only tooling won't carry over.


The agent-queue workflows that used to clone this repo (in Pact, for example) were removed in June 2026; a GitHub code search across the Mycelium, Hateomim, Guild and nikotsy accounts (2026-10-19) found no workflow that still clones it.

## Using these locally

Symlink or copy into `~/.claude/skills/`:

```bash
git clone https://github.com/nikotsy/niko-claude-skills.git ~/niko-claude-skills
ln -s ~/niko-claude-skills/ui-designer ~/.claude/skills/ui-designer
```

## Build, test, release

Nothing to build, test or deploy. Updating means copying the skill folders from `~/.claude/skills` and committing.

## Status

Two commits: the seed on 2026-05-03 and a sync on 2026-08-18; nothing since.

## License

Personal/internal reference. No license granted for redistribution at this time.
