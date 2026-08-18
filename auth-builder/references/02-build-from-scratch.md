# Mode: Build From Scratch

Greenfield auth, or a net-new auth feature. Build in dependency order: **decide → backend + rules → frontend → user-management → cleanup jobs**. Backend before frontend, always — the frontend has nothing real to talk to otherwise.

## Step 0 — Decide (don't skip, don't assume)

Walk `global_guides/auth-logic/01-decision-wizard.md` and fill `02-config-template.md`. The two decisions that govern everything:

- **Signup paradigm:** open / admin-only / **request-approve**. Default admin-only for internal/B2B.
- **Identity model:** uid-as-link / **credential-allowlist**. Default credential-allowlist for admin-only or any multi-provider product.

Then: providers (email+pw, Google, phone OTP), roles vocabulary (name by capability — `admin`/`editor`/`viewer`, not `customer`/`partner`), role storage (profile + claims mirror), RBAC granularity (route-based first), email provider (MailerSend/etc), TTLs.

Confirm the filled config with the user before writing code. Commit it to the repo as the authority.

## Step 1 — The shared normalizer

`shared/credential.ts` with `normEmail` / `normPhone` (see `01-model.md`). One copy. Imported by both frontend forms and the backend resolver. This is step 1 because every later step depends on agreeing on canonical credential form.

## Step 2 — Data model

- **Allowlist / Profile store** (the roster): stable id + `emails[]` + `phones[]` + role/portals/tools + status + audit fields. Enforce credential uniqueness on write.
- **Render docs:** `users/{uid}` projection (claims-relevant + display fields). Disposable.
- **Optional UID→Profile index** for the resolver fast path (rebuildable).
- **Invites:** a token doc (capability URL — opaque, high-entropy, TTL, single-use) carrying the pre-provisioned credential(s) + intended role.

## Step 3 — Backend (the trusted server) — pick FastAPI or Functions, same contract

Build these endpoints/callables (see `recipes/12-session-resolve.md`, `06/07/08-cloud-functions-*.md`):

- `resolveSession` — the resolver (Step in `01-model.md`). The heart. Runs every sign-in. Idempotent, verified-only, deny-by-default.
- `createInvite(email?, phone?, role, link_existing?)` — at least one credential; normalize; enforce uniqueness; deliver (email link or `wa_link` for phone). `link_existing` appends a credential to an existing Profile.
- `acceptInvite(token, {password? | firebase_id_token?})` — validate token (exists, not expired, single-use, atomic delete inside a transaction), bless the email as verified, then resolve.
- `bindPhone(id_token)` — resolve path for the OTP flow (verified phone → roster → claims). 403 if not approved.
- Admin: `setRole/setPortals/setTools`, `disableUser`, `reinstateUser`, `deleteUser` (soft + revoke), `reconcileUser`, cleanup-report (orphans + duplicate keys).
- **Authorize every mutator.** Authentication (valid token) is not authorization (right role/portal). The reference backend's worst finding was ~138 live mutating routes with no auth — don't repeat it. Default-deny; gate by role/department, not just "any active profile".
- Claims are written **only here**. Never from the client.

## Step 4 — Firestore rules (the data layer)

- Helper `isEmployee()` / `isAuthorized()` keyed off claims (`request.auth.token.portals != null` / role), resilient to stale claims.
- `users/{uid}`: self-read (+ employee directory read if needed); **write: if false** (backend-mediated via Admin SDK).
- Tenant pools (school/external): isolate — `isAuthenticated && uid == userId`, never the employee catch-all.
- Backend-mediated collections: `allow write: if false` and document why.
- Catch-all LAST, scoped to authorized users (not bare `isAuthenticated`).
- No permissive `match /{document=**} { allow read, write: if true }`. Public-read exceptions (headless renderers) must be explicit, narrow, and commented.

## Step 5 — Frontend (Angular, signals, native SDK)

- **`FirebaseService`** — wraps the native SDK. `setPersistence(browserLocalPersistence)` FIRST, then `onAuthStateChanged`. Expose `whenInitialized()` (resolves on first auth-state fire). Methods: email/Google/phone sign-in, OTP (reCAPTCHA verifier rebuilt per attempt), provider linking, password reset, logout.
- **`AuthSessionService`** — cache the ID token in a signal; proactive refresh ~5 min before expiry; interceptor reads it synchronously (no async hop per request). Clear + drop HTTP cache on sign-out.
- **`firebaseAuthInterceptor`** — attach `Authorization: Bearer <token>` to backend hosts only; pass anonymous endpoints through.
- **`AuthState` / `AuthCacheService`** — on sign-in: (1) `resolveSession()`, (2) `getIdToken(true)`, (3) attach the live `users/{uid}` listener. Expose `myProfileId()` (Profile id, uid-independent), `cachedPortals/Tools`, `isSuperAdmin`, `userType`, and a `waitForAccess()` readiness signal. Handle 403 → not-approved screen (sign out), never an empty portal.
- **Guards** (functional, `CanActivate`/`CanMatch`): `authGuard` (await `whenInitialized()`), `portalGuard(code)` / `toolGuard(code)` / role guards (await `waitForAccess()`). Guards redirect; they are not security.
- **Auth surface components:** login (SSO-first, phone OTP, email/pw, forgot-password; ambiguous error copy), invite-accept (welcome → auth, offering Google/phone/password — all terminate in resolve), pending-approval + account-disabled screens.

## Step 6 — User-management UI

The allowlist editor. Full CRUD with Delete-confirm. Invite by email and/or phone; show credential **sets** + linked-method count (show contact, never the internal id); add/remove sign-in method per Profile; role/portal editing; orphan + duplicate-key janitor view. See `recipes/04-admin-user-management.md` → "Credential-allowlist variant".

## Step 7 — Cleanup / reconcile jobs

- **Reconciler** — on roster write + scheduled: write Firebase to match the roster (claims, enabled-state, token revocation). Idempotent.
- **Orphan janitor** — disable/delete auth records with no active roster row (created > 24h).
- **Duplicate-key janitor** — surface any credential on >1 Profile.
- **Expired-invite + soft-deleted-profile** cleanup on a daily schedule.

## Step 8 — Verify

`ng build` (or `ng build <site>`) green. Walk one full path live: invite → accept via each provider → land in portal → sign out → sign back in via a *different* provider → same Profile. Then revoke → denied on next sign-in. Report honestly.
