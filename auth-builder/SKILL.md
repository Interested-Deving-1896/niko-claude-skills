---
name: auth-builder
description: Expert builder and auditor of authentication + user-management systems on Firebase Auth + Angular (backend-agnostic — FastAPI or Cloud Functions). Use for building auth from scratch (login, signup, invite/accept, password reset, phone OTP, RBAC, custom claims, route guards, Firestore rules, user-management UI) OR auditing/optimizing an existing auth system. Specializes in the credential-allowlist model — identity = verified email/E.164 phone value, super-admin-curated allowlist, provider-agnostic resolver, multiple credentials → one profile → many UIDs. Triggers — "build an auth system", "add login/signup/invite", "audit my auth", "fix login/invite/claims", "user management", "RBAC", "custom claims drift", "multi-provider identity", "who can access what", "/auth-builder".
user_invocable: true
---

# Auth Builder

Build a correct Firebase-Auth + Angular auth & user-management system from scratch, or audit and harden an existing one. The stack is fixed (Firebase Auth + Angular); the trusted-server backend is swappable (FastAPI **or** Cloud Functions — any process holding the Admin SDK).

This skill is the **operator**. The **authority** is the canonical guide:

```
/Users/nikotsy/MYCELIUM_2025_PROJECTS/global_guides/auth-logic/
  00-axioms.md · 01-decision-wizard.md · 02-config-template.md
  principles/   (the why — contract-framed)
  recipes/      (the how — Angular/Firebase/backend code)
  configurations/ (filled examples)
```

If that path exists, read from it — it is the source of truth and more detailed than this skill. The `references/` files here are a self-contained condensation so the skill works anywhere, but the guide wins on any conflict. The reference implementation is `hateomim-2025-admin` (`resolveSession` / `bindPhone` / `acceptInvite` + the 10 guards).

---

## First move: classify the task

Two modes. Decide which before doing anything.

- **BUILD** — greenfield, or a net-new auth feature (add invites, add phone, add RBAC). → read `references/02-build-from-scratch.md`.
- **AUDIT / OPTIMIZE** — an auth system exists; the user wants it reviewed, hardened, or a bug fixed. → read `references/03-audit-existing.md`.

In both modes, `references/01-model.md` is the mental model and `references/04-pitfalls.md` is the bug catalog you check against. Read `01-model.md` early — every decision flows from it.

**Never start writing auth code before you know the answer to two questions:** (1) what *signup paradigm* (open / admin-only / request-approve)? (2) what *identity model* (uid-as-link / credential-allowlist)? If the user hasn't said, ask. Everything downstream depends on these two.

---

## The spine: the credential-allowlist model

For any admin-gated product, or anything with more than one sign-in method (or that will grow one), this is the default and the thing this skill is expert in:

> **Identity is the verified credential VALUE (normalized email / E.164 phone), never the Firebase UID or provider.**
>
> Firebase Auth is a decoupled credential-minting machine. The super-admin curates an **allowlist** — a roster of credential values (the profiles). A **resolver** runs server-side on *every* sign-in: it pulls the **verified** credentials out of the token, matches them against the roster, and attaches claims + role + profile, backfilling a per-UID render doc. No match ⇒ orphan ⇒ deny.
>
> One human owns **many** UIDs (one per provider/credential). A Profile carries **sets** — multiple emails + multiple phones — and each is a sign-in door. Adding a future provider (Apple, magic-link) costs one line in the resolver.

Full treatment: `references/01-model.md` and `principles/13-credential-allowlist-and-resolution.md`.

---

## Non-negotiables (true in both modes)

These are the rules whose violation *is* the bug. Enforce them when building; hunt them when auditing.

1. **Match VERIFIED credentials only.** Phone is inherently verified; SSO email via `email_verified: true`; email+password is **unverified** until the inbox is proven. Matching a claimed email = impersonation-by-typing. This is the security hinge.
2. **Identity = credential, not UID.** Authorship/ownership key off the Profile id, never `request.auth.uid`. One Profile owns many UIDs.
3. **Normalize on both sides with ONE shared function.** Lowercased/trimmed email, E.164 phone — at write time (roster) and read time (resolver). Format drift = silent deny.
4. **Each credential value belongs to ≤1 Profile.** Enforce on write (`email_taken`/`phone_taken`); police with a duplicate-key janitor.
5. **Enforce in three layers, always.** UI (hide) → route guard (redirect) → backend (refuse). Guards are UX, not security. Backend must **authorize**, not just authenticate.
6. **Profile → claims, one-way.** Profile is truth; custom claims are a signed attestation; only the trusted server writes claims; client forces `getIdToken(true)` after a claims change.
7. **No open signup in the allowlist model.** A minted Firebase user with no roster row is an orphan, by design. The allowlist is the gate.
8. **Await readiness in guards.** `whenInitialized()` (Firebase restored from localStorage) + access-known before deciding — or a cold deep-link bounces a logged-in user.

---

## Stack constraints (Niko's projects)

- Angular 21+, standalone, **signals**, zoneless. **Native Firebase JS SDK** — never AngularFire.
- **SCSS only.** No Material, no Tailwind. FA solid icons only (`fa-solid`, never `fa-light`). Light theme.
- RTL/Hebrew-aware (logical CSS properties; E.164 phone is Israel-default `+972`).
- Reuse existing DS components (`hos-*`, `ds-select`); don't hand-roll native controls.
- Backend-agnostic: show the resolver/admin endpoints as a contract, then the FastAPI or Functions shape. Never assume one.
- When writing Angular, use the Angular MCP tools (`mcp__angular__*`) rather than memory.

---

## Working method

1. **Classify** (build vs audit) and **pin the two paradigm questions**. Ask if unknown — never assume (`feedback_never_assume`).
2. **Read** `references/01-model.md`, then the mode file (`02` or `03`), then the relevant guide `principles/` + `recipes/`.
3. For BUILD: produce/confirm a filled config (`02-config-template.md`), then build in dependency order (backend resolver + rules first, then frontend) — see `references/02`.
4. For AUDIT: run the checklist in `references/03`, produce findings as a prioritized list (P0/high/med) with file:line, each mapped to a non-negotiable it violates. Fix backend-before-frontend; verify with `ng build`.
5. **Expose full CRUD** in any user-management surface — especially Delete with confirm (`feedback_full_crud`).
6. **Verify, don't claim.** `ng build` (or `ng build <site>` for a workspace) must pass. Report failures honestly.

Read the reference files on demand — don't dump them into context up front.
