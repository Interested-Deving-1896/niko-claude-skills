# niko-claude-skills

Public, shareable Claude Code skills — designed to be cloned into automation environments (e.g., GitHub Actions runners) so autonomous Claude agents have access to the same playbooks Niko uses locally.

## What's here

| Skill | Purpose |
|---|---|
| [`ui-designer/`](ui-designer/) | Scaffold a new design system from scratch. Top-down, contract-based, atomic layering. Bundles the UI Design Course as canonical reference. |
| [`ui-review/`](ui-review/) | Audit existing interfaces. Bottom-up, evidence-based, contract-violation hunting. Bundles the UI Design Course. |
| [`atomic-design-system/`](atomic-design-system/) | Atomic design system reference and methodology. |
| [`angular-21-expert/`](angular-21-expert/) | Angular 21 expert — standalone, zoneless, signals, modern routing. |
| [`genkit-expert/`](genkit-expert/) | Firebase Genkit expert for Angular 21 + Firebase/GCP and FastAPI on Cloud Run. Flows, tools, agents, RAG, MCP. |
| [`saas-goldmine/`](saas-goldmine/) | Audit projects for SaaS potential — competitive analysis, monetization, extraction planning. |

Each skill is a self-contained directory with a `SKILL.md` (frontmatter + body) plus any auxiliary files (`course/`, `references/`).

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

## Using these locally

Symlink or copy into `~/.claude/skills/`:

```bash
git clone https://github.com/nikotsy/niko-claude-skills.git ~/niko-claude-skills
ln -s ~/niko-claude-skills/ui-designer ~/.claude/skills/ui-designer
```

## License

Personal/internal reference. No license granted for redistribution at this time.
