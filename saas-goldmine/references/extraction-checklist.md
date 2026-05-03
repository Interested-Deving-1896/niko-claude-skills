# SaaS Extraction & Implementation Checklist

## Phase 0: Pre-Extraction Assessment

### Code Quality Check

```bash
# Quick assessment commands
find . -name "*.env*" -o -name "*secret*" -o -name "*password*"  # Hardcoded secrets?
grep -r "TODO\|FIXME\|HACK" --include="*.{js,ts,py}"  # Tech debt markers
find . -name "test*" -o -name "*spec*" -o -name "*test*"  # Test coverage
```

### Extraction Readiness Checklist

- [ ] **Auth is separable**: Not deeply coupled to single-user assumption
- [ ] **Data is isolatable**: Can add tenant_id without massive refactor
- [ ] **Config is externalized**: No hardcoded values in business logic
- [ ] **Secrets are managed**: Not in code, using env vars or secret manager
- [ ] **Dependencies are current**: No abandoned/vulnerable packages
- [ ] **Core logic is documented**: Someone else can understand it

### Red Flags (Major Refactor Needed)

| Issue | Impact | Effort to Fix |
|-------|--------|---------------|
| Global state everywhere | High | Days-weeks |
| Hardcoded single tenant | High | Days |
| No separation of concerns | Medium | Days |
| Synchronous-only (needs async) | Medium | Days |
| Outdated framework | High | Weeks |
| No tests + complex logic | High | Weeks |

---

## Phase 1: Foundation (Week 1-2)

### 1.1 Project Setup

```bash
# Recommended structure
project-name/
├── apps/
│   ├── web/           # Frontend
│   └── api/           # Backend
├── packages/
│   ├── database/      # Schema + migrations
│   ├── core/          # Business logic (extracted from original)
│   └── shared/        # Shared types/utils
├── infrastructure/
│   ├── docker/
│   └── terraform/     # Or pulumi/SST
└── docs/
```

### 1.2 Multi-Tenancy Implementation

**Option A: Shared Database, Tenant Column (Recommended for MVP)**

```sql
-- Add tenant_id to every table
ALTER TABLE projects ADD COLUMN tenant_id UUID NOT NULL;
ALTER TABLE projects ADD CONSTRAINT fk_tenant 
  FOREIGN KEY (tenant_id) REFERENCES tenants(id);

-- Create tenant-aware index
CREATE INDEX idx_projects_tenant ON projects(tenant_id);
```

```javascript
// Middleware to inject tenant context
async function tenantMiddleware(req, res, next) {
  const tenantId = req.user?.tenantId;
  if (!tenantId) return res.status(401).json({ error: 'No tenant' });
  
  req.tenantContext = { tenantId };
  next();
}

// All queries must include tenant filter
const projects = await db.projects.findMany({
  where: { tenantId: req.tenantContext.tenantId }
});
```

**Option B: Schema Per Tenant (For strict isolation needs)**

```javascript
// Dynamic schema selection
const schema = `tenant_${tenantId}`;
await db.$executeRaw`SET search_path TO ${schema}`;
```

**Option C: Database Per Tenant (Enterprise only)**
- Most isolation but highest operational complexity
- Use only if compliance/security requires

### 1.3 Authentication System

**Recommended Stack**: 
- Auth0 / Clerk / Supabase Auth (don't build your own)
- Or: NextAuth.js / Lucia for self-hosted

**Minimum Requirements**:
- [ ] Email/password signup
- [ ] Email verification
- [ ] Password reset flow
- [ ] Session management
- [ ] Team/organization support
- [ ] Role-based permissions

```javascript
// Permission model
const ROLES = {
  owner: ['*'],
  admin: ['read', 'write', 'invite', 'billing'],
  member: ['read', 'write'],
  viewer: ['read']
};

function can(user, action, resource) {
  const role = user.teamRole;
  const permissions = ROLES[role];
  return permissions.includes('*') || permissions.includes(action);
}
```

---

## Phase 2: Billing Integration (Week 2-3)

### 2.1 Stripe Setup

```javascript
// 1. Create products in Stripe Dashboard
// 2. Store price IDs in config
const PRICE_IDS = {
  free: null,
  starter: 'price_xxx_starter_monthly',
  pro: 'price_xxx_pro_monthly',
  enterprise: null // Contact sales
};

// 3. Create checkout session
const session = await stripe.checkout.sessions.create({
  customer_email: user.email,
  client_reference_id: user.tenantId,
  line_items: [{ price: PRICE_IDS[plan], quantity: 1 }],
  mode: 'subscription',
  success_url: `${BASE_URL}/billing?success=true`,
  cancel_url: `${BASE_URL}/billing?canceled=true`,
  metadata: { tenantId: user.tenantId }
});
```

### 2.2 Webhook Handling

```javascript
// Essential webhook handler
app.post('/webhooks/stripe', async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const event = stripe.webhooks.constructEvent(req.body, sig, WEBHOOK_SECRET);
  
  switch (event.type) {
    case 'checkout.session.completed':
      await handleNewSubscription(event.data.object);
      break;
    case 'customer.subscription.updated':
      await handleSubscriptionChange(event.data.object);
      break;
    case 'customer.subscription.deleted':
      await handleCancellation(event.data.object);
      break;
    case 'invoice.payment_failed':
      await handlePaymentFailure(event.data.object);
      break;
  }
  
  res.json({ received: true });
});
```

### 2.3 Subscription State Management

```javascript
// Store subscription state
const subscriptionSchema = {
  tenantId: 'uuid',
  stripeCustomerId: 'string',
  stripeSubscriptionId: 'string',
  plan: 'enum(free, starter, pro, enterprise)',
  status: 'enum(active, past_due, canceled, trialing)',
  currentPeriodEnd: 'datetime',
  cancelAtPeriodEnd: 'boolean'
};

// Check subscription on protected routes
async function requirePlan(minPlan) {
  return async (req, res, next) => {
    const sub = await getSubscription(req.tenantContext.tenantId);
    if (planLevel(sub.plan) < planLevel(minPlan)) {
      return res.status(402).json({ 
        error: 'UPGRADE_REQUIRED',
        currentPlan: sub.plan,
        requiredPlan: minPlan
      });
    }
    next();
  };
}
```

---

## Phase 3: Usage Metering (If Applicable, Week 3-4)

### 3.1 Metering System Design

```javascript
// Usage tracking table
const usageSchema = {
  tenantId: 'uuid',
  metricName: 'string',  // 'api_calls', 'storage_bytes', etc.
  periodStart: 'datetime',
  periodEnd: 'datetime', 
  count: 'bigint',
  lastUpdated: 'datetime'
};

// Increment usage (use Redis for high-volume)
async function trackUsage(tenantId, metric, amount = 1) {
  const period = getCurrentBillingPeriod(tenantId);
  
  await db.usage.upsert({
    where: { tenantId, metricName: metric, periodStart: period.start },
    update: { count: { increment: amount }, lastUpdated: new Date() },
    create: { tenantId, metricName: metric, periodStart: period.start, 
              periodEnd: period.end, count: amount }
  });
}
```

### 3.2 Quota Enforcement

```javascript
// Middleware for usage-limited endpoints
async function checkQuota(metric) {
  return async (req, res, next) => {
    const usage = await getCurrentUsage(req.tenantContext.tenantId, metric);
    const limit = getPlanLimit(req.subscription.plan, metric);
    
    if (usage >= limit) {
      return res.status(429).json({
        error: 'QUOTA_EXCEEDED',
        metric,
        usage,
        limit,
        resetAt: getBillingPeriodEnd(req.tenantContext.tenantId)
      });
    }
    
    // Track after successful processing
    res.on('finish', () => {
      if (res.statusCode < 400) {
        trackUsage(req.tenantContext.tenantId, metric);
      }
    });
    
    next();
  };
}
```

---

## Phase 4: Operational Readiness (Week 4-5)

### 4.1 Monitoring & Alerting

**Minimum Monitoring**:
- [ ] Uptime monitoring (external)
- [ ] Error tracking (Sentry / LogRocket)
- [ ] Performance monitoring (basic APM)
- [ ] Database monitoring
- [ ] Billing webhook failures

**Alert Thresholds**:
```yaml
alerts:
  - name: API Error Rate
    condition: error_rate > 5%
    for: 5m
    severity: critical
    
  - name: Webhook Failures
    condition: failed_webhooks > 0
    for: 1m
    severity: high
    
  - name: Subscription Churn
    condition: cancellations > 5/day
    for: 24h
    severity: warning
```

### 4.2 Support System

**MVP Support Stack**:
- Email inbox (support@yourproduct.com)
- Simple ticketing (Linear / Height / even just a Notion DB)
- FAQ / Help docs (GitBook / Notion / Docusaurus)
- Status page (Statuspage / BetterStack)

### 4.3 Onboarding Flow

```markdown
## Minimum Onboarding

1. Welcome email (immediate)
   - Quick start guide
   - Key first action
   
2. In-app checklist
   - [ ] Complete profile
   - [ ] [Core action 1]
   - [ ] [Core action 2]
   - [ ] Invite team member (if applicable)
   
3. Day 2 email
   - "Need help getting started?"
   - Link to docs/support
   
4. Day 7 email (if inactive)
   - "We noticed you haven't [done X]"
   - Offer help
```

---

## Phase 5: Legal & Compliance (Week 5-6)

### Required Legal Documents

1. **Terms of Service**
   - Service description
   - User obligations
   - Payment terms
   - Termination conditions
   - Limitation of liability
   - Dispute resolution

2. **Privacy Policy**
   - Data collected
   - How data is used
   - Data sharing
   - User rights (GDPR if applicable)
   - Cookie usage
   - Contact information

3. **Data Processing Agreement** (B2B)
   - Required if handling customer data
   - GDPR compliance
   - Data security measures

**Do NOT copy/paste random templates. Options**:
- TermsFeed / Iubenda (paid generators)
- Lawyer review (recommended for serious products)
- At minimum: adapt competitor's docs as starting point

### Security Baseline

- [ ] HTTPS everywhere
- [ ] Password hashing (bcrypt/argon2)
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] CSRF protection
- [ ] Rate limiting
- [ ] Secure headers (HSTS, CSP)
- [ ] Dependency vulnerability scanning
- [ ] Secrets in environment variables
- [ ] Audit logging for sensitive actions

---

## Launch Checklist

### Pre-Launch

- [ ] Domain + SSL configured
- [ ] Email sending working (transactional)
- [ ] Payment flow tested end-to-end
- [ ] Webhook retries configured
- [ ] Error tracking active
- [ ] Backup strategy in place
- [ ] Legal docs live
- [ ] Support email working
- [ ] Analytics installed

### Launch Day

- [ ] Remove beta/coming soon flags
- [ ] Enable signup
- [ ] Test payment flow one more time
- [ ] Monitor error rates
- [ ] Be available for support

### Post-Launch (Week 1)

- [ ] Monitor churn reasons
- [ ] Collect user feedback
- [ ] Fix critical bugs immediately
- [ ] Track key metrics (signups, activations, conversions)

---

## Effort Estimation Template

```markdown
## SaaS-ification Effort Estimate

### Phase 1: Foundation
| Task | Effort | Dependency |
|------|--------|------------|
| Multi-tenancy | X days | - |
| Auth system | X days | - |
| Database migration | X days | Multi-tenancy |

### Phase 2: Billing
| Task | Effort | Dependency |
|------|--------|------------|
| Stripe integration | X days | Auth |
| Webhook handlers | X days | Stripe |
| Subscription logic | X days | Webhooks |

### Phase 3: Usage (if applicable)
...

### Phase 4: Operations
...

### Phase 5: Legal
...

**Total Estimated Effort**: X-Y weeks
**Critical Path**: [list of blocking dependencies]
**Biggest Risks**: [technical/market risks]
```
