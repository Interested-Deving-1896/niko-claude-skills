---
name: mac-cleanup
description: Free up disk space on a Mac safely. Use when the user wants to "clean up my mac", "free up space", "reclaim disk", "I'm low on storage", or names a target like "get back 30GB". Surveys where space actually lives, sorts candidates into risk tiers, and deletes ONLY what the user confirms.
---

# Mac Cleanup

Find and reclaim disk space on macOS without breaking anything. The golden rule: **measure first, classify by risk, never delete without explicit confirmation.**

## Core principles

- **Survey before you suggest.** Never assume where space went. Measure with `du`/`df` first — the answer is in the numbers, not your memory.
- **Tier by risk, not by size.** A 2GB cache is safer to delete than a 200MB project folder. Always present green/yellow/red tiers.
- **Confirm destructive actions.** Green tier (auto-regenerating) can be batched after one OK. Yellow/red get path-by-path confirmation. Never `rm` real user content silently.
- **Be honest about the target.** If they want 30GB and only ~10GB is safe junk, say so plainly. Don't pad numbers or pretend caches will hit the goal.
- **Prefer `mv` to Trash over `rm`** for anything that isn't a regenerable cache, so it's recoverable.

## Step 1 — Survey

Run these to map the terrain (read-only, safe):

```bash
# Overall free space — macOS splits volumes; the Data volume is the real one
df -h /System/Volumes/Data

# Top-level home folders
du -sh ~/* 2>/dev/null | sort -rh | head -20

# Library breakdown (usually the hidden bulk)
du -sh ~/Library/* 2>/dev/null | sort -rh | head -12
du -sh ~/Library/Caches/* 2>/dev/null | sort -rh | head -15
du -sh ~/Library/Application\ Support/* 2>/dev/null | sort -rh | head -15

# Dev artifacts (regenerable)
find ~ -name node_modules -type d -prune 2>/dev/null -exec du -sh {} \; | sort -rh | head -20
du -sh ~/Library/Developer/Xcode/{DerivedData,iOS\ DeviceSupport} ~/Library/Developer/CoreSimulator 2>/dev/null
du -sh ~/Library/Containers/com.docker.docker 2>/dev/null

# Downloads, Trash
du -sh ~/Downloads/* 2>/dev/null | sort -rh | head -20
du -sh ~/.Trash 2>/dev/null
```

Note the active toolchain before flagging versioned installs for deletion:

```bash
node -v; nvm current 2>/dev/null
ls ~/.claude/plugins/cache/claude-plugins-official/*/  # keep newest, old version dirs are dupes
```

## Step 2 — Classify into tiers

**🟢 Green — regenerates automatically, zero risk:**
- `~/Library/Caches/*` (browser, app, pip, node-gyp caches)
- Project `node_modules` (restore with `npm install`)
- Old duplicate plugin/version cache dirs (keep newest only)
- Xcode `DerivedData`, stale updater caches (e.g. `*.ShipIt`, `GoogleUpdater` old builds)
- Empty/old Trash

**🟡 Yellow — re-downloadable, minor inconvenience:**
- Unused nvm/node versions (NOT the active one)
- Installers in Downloads (.pkg, .dmg, .zip, .apk)
- Cloud-sync caches (DriveFS, Dropbox cache) — may re-sync
- Xcode `iOS DeviceSupport`, old simulators

**🔴 Red — real user content, walk through one-by-one:**
- Downloads content (assets, PDFs, media)
- Old project clones / archived repos
- App profile data (Chrome profiles, etc.)
- Anything in Documents/Desktop/Movies

## Step 3 — Present & confirm

Show a tiered table (item · size · note). State the honest total each tier yields vs. the user's goal. Use a multi-select question to pick buckets. Make clear nothing is deleted yet.

## Step 4 — Execute

Green tier, after one confirmation:

```bash
# Examples — adapt to what the survey found
rm -rf ~/Library/Caches/Google
rm -rf <project>/node_modules        # tell user to re-run npm install
rm -rf ~/.claude/plugins/cache/.../<old-version>
```

Yellow/red — confirm each path, prefer Trash so it's recoverable:

```bash
mv "<path>" ~/.Trash/    # recoverable; user empties Trash to finalize
nvm uninstall <version>  # for node versions
```

After each batch, re-measure and report progress toward the goal:

```bash
df -h /System/Volumes/Data
```

## Notes

- macOS "Purgeable" space (iCloud/APFS snapshots) won't show in `du`; if numbers don't add up, mention `tmutil thinlocalsnapshots / 999999999999 4` and System Settings → Storage.
- Don't touch `~/Library/Group Containers`, app sandboxes, or `Mobile Documents` (iCloud) unless the user explicitly asks — corruption risk.
- Never delete the active node version, current plugin version, or any repo with uncommitted changes (`git status` first if unsure).
