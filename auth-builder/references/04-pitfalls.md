# Pitfalls — The Bug Catalog

Quick-reference. Each is a real bug class. In BUILD, prevent them; in AUDIT, hunt them. Every one maps to a non-negotiable in SKILL.md.

| # | Pitfall | Symptom | Fix |
|---|---|---|---|
| 1 | **Match unverified email** | attacker email/pw-signs-up as a colleague, inherits their access | match only `email_verified` creds; phone is inherently verified; invite-click blesses email |
| 2 | **UID as identity** | same human, two providers/devices → "is this mine?" returns false; writes rejected | key ownership/authorship off Profile id (`myProfileId()`), never `request.auth.uid` |
| 3 | **Format drift** | row exists, token valid, login silently denied, no error | ONE shared normalizer (lowercase email, E.164 phone) on write AND read |
| 4 | **Locked out by provider** | invited by email, signs in with Google same address, lands on nothing | both reduce to same verified email → same Profile (the resolver) |
| 5 | **No token refresh after claims change** | admin promotes user; user still sees old access until ~1h | `getIdToken(true)` after every claims write |
| 6 | **Listener before render doc** | fresh login flashes empty/none then settles, or bounces | resolve → `getIdToken(true)` → THEN attach `users/{uid}` listener |
| 7 | **Cold-load race** | logged-in user bounced to /login on every refresh | guard awaits `whenInitialized()`; `setPersistence` before `onAuthStateChanged` |
| 8 | **Guard decides on half-loaded state** | deep-link denies access a user actually has | await `waitForAccess()` (pool known + claims/portals loaded) before deciding |
| 9 | **Backend authenticates but doesn't authorize** | any active employee can call any mutator | default-deny; gate each route by role/portal, not "any valid token" |
| 10 | **Client-set claims** | a client path can elevate itself | claims written ONLY by the trusted server (resolver/reconciler) |
| 11 | **Claims drift** | profile role X, token role Y | one writer of claims + a periodic reconciler that re-syncs |
| 12 | **No credential uniqueness** | one email/phone on two Profiles → ambiguous resolve | enforce on write (`email_taken`/`phone_taken`) + duplicate-key janitor |
| 13 | **Incomplete revocation** | removed a user but missed one of their auth records | revoke by roster edit; reconciler disables every linked UID + revokes tokens |
| 14 | **Provider path skips the 403** | unknown Google/email user lands in an empty shell | handle resolve 403 → sign out → "not invited" screen |
| 15 | **Permissive Firestore catch-all** | `match /{document=**}{ allow ...: if true }` | scope to authorized users; explicit narrow public-read exceptions only |
| 16 | **≥2 parallel permission systems** | SQL grants + JSONB + per-user + claims + render doc all live | collapse to one source (role/department-derived, read live) |
| 17 | **Vocabulary mismatch** | `prod` ≠ `production`, retired tool code → empty access | canonicalize; alias + remove |
| 18 | **Hardcoded secret fallback** | `load_key()` returns a literal default | remove + rotate (git history) |
| 19 | **Missing Delete in user mgmt** | can create/edit users but not remove | full CRUD, Delete with confirm |
| 20 | **reCAPTCHA reuse** | second SMS attempt 400s | rebuild the invisible verifier per attempt; clear() between |

## The 60-second sniff test (audit)

1. Does the resolver read `email_verified`? (if no → P0)
2. Is there ONE normalizer, imported both sides? (if no → silent-deny risk)
3. Do mutating backend routes check role/portal, or just "signed in"? (count the open ones)
4. Any `if true` in Firestore rules? Any `users` write that isn't `if false`?
5. Does a guard await readiness before deciding?
6. Ownership keyed off Profile id or `request.auth.uid`?
7. Who writes custom claims — only the server?

Seven questions. Most broken auth systems fail at least two.
