#!/usr/bin/env bash
# The "build" for this repo: every skill directory is loadable.
#   - each top-level directory (except docs, scripts, .github) has a SKILL.md
#   - SKILL.md opens with YAML frontmatter carrying `name:` and `description:`
#   - every skill linked from README.md exists, and every skill is in README.md
# Usage: scripts/check-skills.sh            (exit 1 on any failure)
#        scripts/check-skills.sh --version  (prints the VERSION file)
set -euo pipefail
cd "$(dirname "$0")/.."

if [ "${1:-}" = "--version" ]; then cat VERSION; exit 0; fi

# Known exceptions, synced from ~/.claude/skills without frontmatter. Remove a
# line once its SKILL.md gains name/description; never add new ones casually.
NO_FRONTMATTER=""

fail=0
for dir in */; do
  d="${dir%/}"
  case "$d" in docs|scripts) continue ;; esac
  f="$d/SKILL.md"
  if [ ! -f "$f" ]; then echo "FAIL $d: no SKILL.md"; fail=1; continue; fi
  if [[ " $NO_FRONTMATTER " == *" $d "* ]]; then echo "warn $d: no frontmatter (known exception)"; continue; fi
  if [ "$(head -1 "$f")" != "---" ]; then echo "FAIL $f: no frontmatter"; fail=1; continue; fi
  fm="$(awk 'NR==1{next} /^---$/{exit} {print}' "$f")"
  for key in name description; do
    grep -qE "^$key:" <<<"$fm" || { echo "FAIL $f: frontmatter has no $key"; fail=1; }
  done
  grep -q "\[\`$d/\`\]($d/)" README.md || { echo "FAIL $d: not listed in README.md"; fail=1; }
done
for linked in $(grep -oE '\]\(([a-z0-9-]+)/\)' README.md | sed -E 's/\]\(([^/]+)\/\)/\1/'); do
  [ -d "$linked" ] || { echo "FAIL README.md links $linked/, which does not exist"; fail=1; }
done
[ "$fail" = 0 ] && echo "ok: $(ls -d */ | grep -cvE '^(docs|scripts)/$') skills, version $(cat VERSION)"
exit "$fail"
