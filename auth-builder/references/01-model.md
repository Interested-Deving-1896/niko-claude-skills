# The Model — Credential Allowlist (condensed)

Full version: `global_guides/auth-logic/principles/13-credential-allowlist-and-resolution.md`. This is the operating summary.

## Three decoupled parts

```
FIREBASE AUTH            THE RESOLVER                    THE ALLOWLIST
(credential machine)     (trusted server, every login)   (profiles / roster)
mints a UID for     ──▶  pull VERIFIED creds from   ──▶  one row per HUMAN:
whoever proves a         token → look up roster →         emails[] + phones[]
credential. any          attach claims+profile →          + role + status.
provider, now/future.    backfill render doc for          curated by super-admin.
gates nothing.           THIS uid. no match ⇒ deny.       THE access decision.
```

Each part knows nothing of the others' internals. Swap the resolver's host (Functions ↔ FastAPI), add a provider, or rebuild the UID index without touching the other two.

## Identity = verified credential value, not UID

- A **Profile** has a stable internal id (the identity), and **sets**: `emails: string[]`, `phones: string[]`. No `uid` field — a uid is not identity.
- One human accumulates **many UIDs** over time (work-email-via-Google, cell-via-OTP, personal-email-via-password) — all resolve to one Profile.
- The doc at `users/{uid}` is a **disposable per-UID render projection** the resolver backfills (for the live Firestore listener + security rules). Delete them all → rebuilt on next sign-in.
- **Authorship/ownership key off `profile.id`, never `request.auth.uid`.** Gating a write on `author_uid == request.auth.uid` breaks the moment the session uid ≠ the render-doc uid.

## The cornerstone: match VERIFIED only

The resolver may only match a credential Firebase marks verified in the token:

- **Phone** — inherently verified (OTP is the only way to mint it).
- **SSO (Google/Apple)** — trust `email_verified: true`, not the bare `email`.
- **Email+password** — **unverified** until the inbox is proven. Never match it. (The invite click is the one place you safely bless an email as verified out-of-band — the inbox was proven by receiving the capability URL.)

Skip this and an attacker email/password-signs-up as `ceo@company.com` and inherits the CEO's access. The verified check is what stops impersonation-by-typing.

## Normalize on both sides — one function

```ts
// shared/credential.ts — ONE copy, imported by frontend forms AND backend resolver
export const normEmail = (s?: string|null) => (s ?? '').trim().toLowerCase() || null;
export const normPhone = (s?: string|null) => {        // Israel-default; adjust region
  const d = (s ?? '').replace(/\D/g, '');
  if (!d) return null;
  if (d.startsWith('972')) return `+${d}`;
  if (d.startsWith('0'))   return `+972${d.slice(1)}`;
  return `+972${d}`;
};
```

Drift here (`0546…` stored vs `+972…` queried) is a **silent deny** — row exists, token valid, lookup misses, no error. Centralize the normalizer; the reference codebase's bug was two copies (`toE164` in login, `toE164Israeli` in invite).

## Invariant: each credential value ≤ 1 Profile

Enforce on write (reject `email_taken`/`phone_taken`). Police with a duplicate-key janitor (a value on two Profiles = a conflict to resolve, never steady state). This uniqueness is what makes "match any credential → one Profile" deterministic.

## The resolver contract

```
POST /auth/session/resolve            # no body; identity from the verified Bearer token
  token = verifyFirebaseIdToken(...)  # platform verified signature + exp
  creds = []
  if token.email and token.email_verified: creds.push(normEmail(token.email))
  if token.phone_number:                    creds.push(normPhone(token.phone_number))
  # future providers slot in here — all reduce to "what verified cred did this prove?"
  if creds.isEmpty(): return 403 not_approved
  profile = allowlist.findActiveByAnyCredential(creds)     # emails IN creds OR phones IN creds, active
  if not profile: return 403 not_approved                  # orphan
  setCustomClaims(token.uid, projectClaims(profile))       # role/portals/tools/super_admin/status
  upsert users/{token.uid} = projection(profile)           # the render doc
  indexUidToProfile(token.uid, profile.id)                 # optional fast-path cache
  return projection(profile)
```

Properties: **verified-only inputs**, **provider-agnostic** (never branches on how they signed in), **idempotent** (call every sign-in; twice changes nothing), **deny-by-default**. After it runs, the **client must `getIdToken(true)`** to pull the fresh claims.

## All flows reduce to one resolve

| Flow | What differs | What's identical |
|---|---|---|
| Login (returning) | nothing | resolve verified creds → roster → claims + render doc |
| Invite accept (first) | super-admin pre-added the row; the click blesses the email as verified | same resolve |
| Add a sign-in method | a new UID for an existing human; the new cred is already on their Profile | same resolve |

The invite is the **delivery + pre-provisioning + verified-email-blessing** wrapper around the same resolution. That's why an invite screen can offer Google / phone / password interchangeably.

## Revoke by editing the roster, not chasing UIDs

Remove a credential / flip `status` to disabled → the resolver denies on next sign-in for *every* linked UID, and a **reconciler** (sweep that writes Firebase to match the roster) proactively disables the auth records and revokes refresh tokens. Access is roster-derived: one row edit, system-wide effect.

## When uid-as-link is acceptable instead

Only if you are certain there will forever be exactly one sign-in method per human (open/B2C single-provider). Then `users/{uid}` keyed by uid is simpler and fine. The moment a second provider appears, migrate to credential-as-link — see the guide's `principles/01` linking note.
