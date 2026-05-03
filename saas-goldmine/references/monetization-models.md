# Monetization Models & Billing Logic

## The Golden Rule

**Only charge for what you can measure and enforce.**

Before proposing any limit, ask:
1. Can we technically detect when this limit is reached?
2. Can we enforce the limit without breaking UX?
3. Can users game or bypass this limit?
4. Does this limit align with value delivered?

## Billing Models Deep Dive

### 1. Per-Seat Pricing

**How It Works**: Charge per user account

**Technical Requirements**:
- User authentication system
- Invite/team management
- Seat count tracking
- License enforcement on login

**Enforcement Logic**:
```javascript
// On team member invite
if (currentSeats >= plan.maxSeats) {
  return { error: "UPGRADE_REQUIRED", currentPlan, upgradeOptions }
}

// On login
if (user.team.seats > team.plan.maxSeats) {
  // Options: block login, read-only mode, or grace period
}
```

**Edge Cases to Handle**:
- Pending invites count as seats?
- Deactivated users count?
- What happens when downgrading?
- Grace period for overages?

**When to Use**: 
- Collaboration tools
- Tools where value scales with team size
- When you can't easily meter usage

**When to Avoid**:
- Tools used by one power user
- When teams will share logins
- API-first products

**Example Tiers**:
| Tier | Seats | Price | Notes |
|------|-------|-------|-------|
| Free | 1 | $0 | Lead gen, limited features |
| Team | 5 | $29/mo | Per-seat above 5: +$5/seat |
| Business | 20 | $99/mo | Per-seat above 20: +$4/seat |
| Enterprise | Unlimited | Custom | Contact sales |

---

### 2. Usage-Based Pricing

**How It Works**: Charge for consumption (API calls, storage, compute)

**Technical Requirements**:
- Real-time metering system
- Usage aggregation
- Quota enforcement
- Usage alerts and dashboards

**Enforcement Logic**:
```javascript
// API call metering
async function handleRequest(req) {
  const usage = await getUsageThisPeriod(req.user);
  
  if (usage.apiCalls >= plan.limits.apiCalls) {
    // Options:
    // 1. Block with 429
    // 2. Allow with overage charge
    // 3. Downgrade to rate-limited mode
    return { error: "QUOTA_EXCEEDED", usage, resetAt }
  }
  
  await incrementUsage(req.user, 'apiCalls', 1);
  return processRequest(req);
}
```

**Critical Decisions**:
- Hard cap vs. soft cap with overage?
- Real-time vs. end-of-period billing?
- How to handle spikes?
- What's the billing cycle?

**When to Use**:
- APIs and developer tools
- When usage varies wildly between customers
- Infrastructure/compute products
- When costs scale with usage

**When to Avoid**:
- When metering adds latency
- When usage is hard to define
- When customers hate unpredictable bills

**Example Tiers**:
| Tier | Included | Overage | Price |
|------|----------|---------|-------|
| Free | 1,000 calls/mo | Blocked | $0 |
| Starter | 10,000 calls/mo | $0.001/call | $19/mo |
| Growth | 100,000 calls/mo | $0.0008/call | $99/mo |
| Scale | 1,000,000 calls/mo | $0.0005/call | $499/mo |

---

### 3. Feature-Gated Pricing

**How It Works**: Different features available at different tiers

**Technical Requirements**:
- Feature flag system
- Plan-feature mapping
- Graceful feature hiding/disabling

**Enforcement Logic**:
```javascript
// Feature flag check
function canAccessFeature(user, feature) {
  const plan = user.subscription.plan;
  const allowed = PLAN_FEATURES[plan].includes(feature);
  
  if (!allowed) {
    return { 
      allowed: false, 
      upgradeRequired: true,
      minimumPlan: getMinimumPlanForFeature(feature)
    }
  }
  return { allowed: true }
}

// In UI
if (!canAccessFeature(user, 'advancedReports')) {
  return <UpgradePrompt feature="advancedReports" />
}
```

**When to Use**:
- Clear feature differentiation exists
- Features have different cost to serve
- Natural upgrade path is obvious
- Features are independently valuable

**When to Avoid**:
- Features are all interdependent
- Would cripple free tier too much
- Confusing what's in each tier

**Example Tiers**:
| Feature | Free | Pro ($29) | Business ($99) |
|---------|------|-----------|----------------|
| Core feature | ✓ | ✓ | ✓ |
| Export | CSV only | CSV + PDF | All formats |
| Integrations | 2 | 10 | Unlimited |
| Support | Community | Email | Priority |
| API access | ✗ | ✓ | ✓ |
| Custom branding | ✗ | ✗ | ✓ |

---

### 4. Flat-Rate Pricing

**How It Works**: One price, everything included (or limited tiers)

**Technical Requirements**:
- Basic subscription check
- Payment status verification

**Enforcement Logic**:
```javascript
// Simple subscription check
function hasActiveSubscription(user) {
  return user.subscription?.status === 'active' 
    && user.subscription?.endDate > Date.now()
}
```

**When to Use**:
- Simple, focused product
- Low marginal cost to serve
- Want to avoid complexity
- Usage is fairly uniform

**When to Avoid**:
- High variance in customer usage
- Expensive power users would subsidize light users
- Need multiple market segments

---

## Hybrid Models

Most successful SaaS uses combinations:

**Feature-Gated + Per-Seat**:
```
Pro: $10/user/mo - advanced features
Business: $25/user/mo - Pro + admin features + SSO
```

**Feature-Gated + Usage**:
```
Starter: $29/mo - 1000 API calls + basic features
Pro: $99/mo - 10000 API calls + advanced features + priority
```

## Billing Implementation Checklist

### Stripe Integration Basics

```javascript
// Essential webhook events to handle:
- checkout.session.completed // New subscription
- customer.subscription.updated // Plan changes
- customer.subscription.deleted // Cancellation
- invoice.payment_failed // Failed payment
- invoice.paid // Successful payment

// Subscription lifecycle:
1. Create checkout session with price ID
2. Handle successful checkout → provision access
3. Store subscription ID + customer ID
4. Handle webhooks for changes
5. Check subscription status on protected routes
```

### Critical Billing Edge Cases

| Scenario | Must Handle |
|----------|-------------|
| Payment fails | Grace period → dunning emails → suspension |
| Mid-cycle upgrade | Proration or immediate charge? |
| Mid-cycle downgrade | Access until period end or immediate? |
| Refund requested | Policy + implementation |
| Trial expiration | Convert or suspend? |
| Disputed charge | Auto-suspend or manual review? |
| Account deletion | Cancel subscription, retain data how long? |

### Dunning Flow

```
Day 0: Payment fails → retry immediately
Day 1: Email "Payment failed, please update"
Day 3: Retry payment
Day 3: Email "Action required"  
Day 7: Retry payment
Day 7: Email "Final warning, suspension imminent"
Day 10: Suspend account (read-only mode)
Day 14: Final retry + email
Day 30: Full suspension
Day 60: Account deletion warning
Day 90: Delete account and data
```

## Pricing Strategy

### Price Anchoring

```
✗ Bad:  Basic: $10 | Pro: $25 | Enterprise: $100
        (Most pick Basic)

✓ Good: Basic: $29 | Pro: $49 | Enterprise: $199
        (Pro is obviously the best value)
```

### Value-Based Pricing Questions

1. What's the cost of NOT solving this problem?
   - Time: X hours/week × hourly rate = $Y/week
   - Revenue: $X lost per incident
   - Cost: $X in manual labor/tools

2. What's 10% of that value? (Your price ceiling)

3. What do alternatives cost?

### Pricing Reality Check

| Signal | What It Means |
|--------|---------------|
| Everyone picks cheapest tier | Middle tier not valuable enough |
| No one picks enterprise | Either pricing wrong or not enterprise-ready |
| High churn on paid | Value not landing, price too high, or bad customers |
| Low free→paid conversion | Free tier too generous OR paid tier not compelling |

## Output Template

```markdown
## Monetization Plan

### Billing Model
**Primary**: [Model name]
**Why**: [Reasoning based on product/market]

### Pricing Tiers

| Tier | Price | Includes | Enforced Via |
|------|-------|----------|--------------|
| Free | $0 | [limits] | [mechanism] |
| [Tier 1] | $X/mo | [limits] | [mechanism] |
| [Tier 2] | $X/mo | [limits] | [mechanism] |

### Upgrade Triggers
- Free → [Tier 1]: When user hits [specific limit]
- [Tier 1] → [Tier 2]: When user needs [specific feature/capacity]

### Technical Implementation

**Payment Provider**: Stripe/Paddle/LemonSqueezy
**Required Systems**:
- [ ] User authentication
- [ ] Subscription state management
- [ ] [Specific metering if needed]
- [ ] Webhook handlers
- [ ] Dunning emails

**Enforcement Points**:
- [Where limit 1 is checked]
- [Where limit 2 is checked]

### Edge Cases Handled
- Payment failure: [policy]
- Mid-cycle changes: [policy]
- Refunds: [policy]
```
