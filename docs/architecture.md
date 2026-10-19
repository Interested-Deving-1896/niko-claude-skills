# niko-claude-skills architecture

A public repo of Claude Code skills: plain Markdown, no code, no build, no service. Agents read
it in two places: GitHub Actions runners (cloned at run time) and Niko's Mac (symlinked into
`~/.claude/skills/`).

## Parts

| Part | What it is |
|---|---|
| `<skill>/SKILL.md` | One directory per skill (11 today). YAML frontmatter (`name`, `description`) tells the Skill tool when to load it; the body is the playbook. `angular-21-expert` and `atomic-design-system` have no frontmatter yet. |
| `ui-designer/course/`, `ui-review/course/` | The UI Design Course, bundled in both skills so each is self-contained. Two copies, by design. |
| `route-ui-audit/checklists/`, `authoring/`, `templates/` | The route audit's checklists and output templates. |
| `auth-builder/references/`, `saas-goldmine/references/` | Reference material those skills read on demand. |
| `scripts/check-skills.sh` | The repo's "build": every skill has a loadable `SKILL.md` and is listed in the README. `--version` prints `VERSION`. |
| `VERSION` | The one version source. |

## Data

None. No runtime state, no storage.

## External services

- GitHub: hosting, and the clone done by runners (`git clone --depth 1`, see README).
- `.github/workflows/ci.yml` runs `scripts/check-skills.sh` on PRs and pushes to main.

## Deploy targets

None. "Shipping" is merging to main: runners clone main on their next run, and local symlinks
read whatever is checked out. No release has been cut yet.

## Why it is shaped this way

- Source of truth for these skills is `~/.claude/skills` on Niko's Mac; this repo is the
  shareable subset, synced by hand (last sync 2026-08-18, commit e392216). Edits made only here
  are overwritten by the next sync.
- Public, so runners can clone it without a token. Nothing private or secret belongs here.
- Skills are self-contained directories so one can be copied or symlinked alone.
