# Mode: Audit / Optimize Existing

An auth system exists. The user wants it reviewed, hardened, or a specific bug fixed. **Read the code first** — answers live in env files, services, guards, rules, and the resolver, not in cloud consoles. Trace from the routes/guards back, don't keyword-grep blindly.

## How to read the system (in this order)

1. **Routes + guards** — `app.routes.ts` and `guards/*`. What's protected, by what, and does the guard await readiness? This is the map; trace back from it.
2. **Auth services** — the `FirebaseService` (sign-in methods, persistence, `whenInitialized`), the token/session cache + interceptor, the `AuthCache/AuthState` (resolve-on-sign-in? live listener? `myProfileId`?).
3. **The resolver + invite/accept/bind endpoints** — backend. Is matching verified-only? Normalized? Idempotent? Deny-by-default?
4. **Backend route gating** — does every mutating route *authorize* (role/portal), or merely authenticate? Count the open mutators.
5. **Firestore rules** — pools isolated? `users` write-blocked? Any `if true` catch-all? Stale-claim resilience?
6. **The user-management surface** — full CRUD? Credential sets or single-email? Duplicate-key handling?

## The finding catalog — check each, map to a non-negotiable

Produce findings as a prioritized list (P0 / high / med), each with **file:line**, the **non-negotiable violated**, and a **fix**. Backend-before-frontend when fixing.

### P0 — security
- **Ungated mutators** — live mutating routes with no `Depends`/auth, or that only check "any active profile" not role/portal. (Reference backend had ~138.) → default-deny + role gate.
- **Unverified-email match** — resolver matches `token.email` without `email_verified`. → impersonation-by-typing. Add the verified gate.
- **Client-set claims** — any path where the client can set its own custom claims. → move to trusted server only.
- **Hardcoded secret fallbacks** — `load_x_key()` returning a literal `a455…` default. → remove + rotate (it's in git history forever).
- **Permissive Firestore catch-all** — `match /{document=**} { allow read, write: if true }` or `isAuthenticated` where it should be authorized. → scope it.
- **Global authz middleware disabled / debug=True** — no default-deny; full tracebacks in 500 bodies. → enable; strip.

### High — correctness / identity
- **UID as identity** — ownership/authorship gated on `request.auth.uid` instead of Profile id. → breaks across providers/devices. Key off `myProfileId()`.
- **Format drift** — credential normalized differently on write vs read (two copies of the E.164 helper). → one shared normalizer; silent-deny bug.
- **Missing token refresh** — claims changed but no `getIdToken(true)`; user runs stale until expiry.
- **No resolve-then-listen ordering** — listener attaches before the render doc exists → cold-load bounce.
- **Guard decides on half-loaded state** — no `whenInitialized()` / `waitForAccess()` await → logged-in user bounced to /login on refresh; deep-link decides on empty portals.
- **Provider path skips the gate** — e.g. Google/email login navigates straight to `/` without handling the not-approved 403 (lands unknown users in an empty shell instead of a clean "not invited" screen).
- **No credential uniqueness** — same email/phone can land on two Profiles. → add the invariant + janitor.

### Med — drift / hygiene
- **Claims drift** — profile says role X, claims say Y; a second writer of claims exists. → one-writer rule + reconciler.
- **≥2 parallel permission systems** — legacy SQL grant tables + JSONB defaults + per-user rows + claims + render doc all live. → collapse to one (department/role-derived, read live).
- **Vocabulary mismatch** — `prod` vs `production`, retired tool codes → empty access. → canonicalize.
- **CORS `*` + credentials**, orphaned/dead routers, leftover `.rules.temp`.
- **Missing CRUD** — user-management lacks Delete (with confirm).
- **Custom-claims fallback still live** when render-doc is the source of truth → dead/contradictory read path.

## Output shape

A findings report: grouped by severity, each finding = `file:line` · what · why (non-negotiable violated) · fix · blast radius. Then, if asked to fix: smallest focused commits, backend first, `ng build` green, verify the path live. Don't fix silently — surface the list, let the user prioritize.

## Optimize (perf), not just security

The healthy patterns to preserve / introduce: Bearer token cached + single proactive refresh (no per-request async hop), GET dedup (shareReplay), short cache TTL on the Profile gate, resolve run off the hot path via threadpool, live Firestore listener instead of polling. If cold-start fan-out is the complaint, look there before touching auth correctness.
